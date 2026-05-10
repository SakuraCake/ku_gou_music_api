import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../crypto/md5.dart';
import '../crypto/signature.dart';
import '../exception.dart';
import '../util/cookie_jar.dart';
import '../util/random.dart';

/// 加密类型枚举，用于选择请求签名算法。
enum EncryptType {
  /// Android 客户端签名算法。
  android,

  /// Web 端签名算法。
  web,

  /// 注册专用签名算法。
  register,
}

/// 酷狗 HTTP 客户端，负责构建请求参数、签名和发送 HTTP 请求。
class KuGouHttpClient {
  /// 酷狗配置信息。
  final KuGouConfig config;

  /// HTTP 代理地址，如 `http://127.0.0.1:7890`。
  final String? proxy;

  /// 连接超时时间。
  final Duration? connectTimeout;

  /// 接收超时时间。
  final Duration? receiveTimeout;

  /// 用户登录令牌。
  String? token;

  /// 用户 ID。
  int? userid;

  /// 设备指纹标识。
  String dfid;

  /// 设备唯一标识。
  String mid;

  /// UUID 标识。
  String uuid;

  /// 底层 HTTP 客户端实例。
  http.Client innerClient;

  /// Cookie 管理器，自动处理请求 Cookie 和响应 Set-Cookie。
  final CookieJar cookieJar;

  /// 创建 [KuGouHttpClient] 实例。
  ///
  /// [dfid] 未提供时默认为 `-`，[mid] 未提供时自动生成，
  /// [innerClient] 未提供时使用默认的 [http.Client]。
  KuGouHttpClient({
    required this.config,
    this.proxy,
    this.connectTimeout,
    this.receiveTimeout,
    this.token,
    this.userid,
    String? dfid,
    String? mid,
    http.Client? innerClient,
    CookieJar? cookieJar,
  }) : dfid = dfid ?? '-',
       mid = mid ?? calculateMid(cryptoMd5(generateGuid())),
       uuid = '-',
       innerClient = innerClient ?? http.Client(),
       cookieJar = cookieJar ?? CookieJar();

  /// 发送 GET 请求。
  ///
  /// [path] 请求路径，[params] 查询参数，[headers] 额外请求头，
  /// [router] 路由标识，[encryptType] 签名算法类型，
  /// [encryptKey] 是否加密 key 参数，[notSignature] 是否跳过签名，
  /// [clearDefaultParams] 是否清除默认参数，[baseURL] 覆盖基础 URL。
  /// 返回解析后的 JSON 响应数据。
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    String? router,
    EncryptType encryptType = EncryptType.android,
    bool encryptKey = false,
    bool notSignature = false,
    bool clearDefaultParams = false,
    String? baseURL,
  }) async {
    final effectiveBaseURL = baseURL ?? config.baseUrl;
    final allParams = buildRequestParams(
      params: params,
      encryptType: encryptType,
      encryptKey: encryptKey,
      notSignature: notSignature,
      clearDefaultParams: clearDefaultParams,
    );
    final clienttime = allParams['clienttime'] as int? ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final allHeaders = buildHeaders(router: router, clienttime: clienttime);
    if (headers != null) allHeaders.addAll(headers);

    Uri uri;
    final queryString = allParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    uri = Uri.parse('$effectiveBaseURL$path?$queryString');

    final request = http.Request('GET', uri)..headers.addAll(allHeaders);

    final cookieHeader = cookieJar.getCookiesForUrl(uri.toString());
    if (cookieHeader.isNotEmpty) {
      request.headers['Cookie'] = cookieHeader;
    }

    http.StreamedResponse response;
    try {
      var future = innerClient.send(request);
      if (connectTimeout != null) {
        future = future.timeout(connectTimeout!);
      }
      response = await future;
      _saveCookiesFromResponse(uri.toString(), response);
      var bodyFuture = response.stream.toBytes();
      if (receiveTimeout != null) {
        bodyFuture = bodyFuture.timeout(receiveTimeout!);
      }
      final body = await bodyFuture;
      final bodyStr = _stripKgTags(utf8.decode(body));
      return jsonDecode(bodyStr) as Map<String, dynamic>;
    } on Exception catch (e) {
      throw KuGouNetworkException(message: e.toString(), originalError: e);
    }
  }

  /// 发送 POST 请求。
  ///
  /// [path] 请求路径，[params] 查询参数，[body] 请求体，
  /// [headers] 额外请求头，[router] 路由标识，[encryptType] 签名算法类型，
  /// [encryptKey] 是否加密 key 参数，[notSignature] 是否跳过签名，
  /// [clearDefaultParams] 是否清除默认参数，[baseURL] 覆盖基础 URL。
  /// 返回解析后的 JSON 响应数据。
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? params,
    dynamic body,
    Map<String, String>? headers,
    String? router,
    EncryptType encryptType = EncryptType.android,
    bool encryptKey = false,
    bool notSignature = false,
    bool clearDefaultParams = false,
    String? baseURL,
  }) async {
    final effectiveBaseURL = baseURL ?? config.baseUrl;
    final allParams = buildRequestParams(
      params: params,
      encryptType: encryptType,
      encryptKey: encryptKey,
      notSignature: notSignature,
      clearDefaultParams: clearDefaultParams,
      data: body != null ? (body is String ? body : jsonEncode(body)) : '',
    );
    final clienttime = allParams['clienttime'] as int? ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final allHeaders = buildHeaders(router: router, clienttime: clienttime);
    if (headers != null) allHeaders.addAll(headers);

    Uri uri;
    final queryString = allParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    uri = Uri.parse('$effectiveBaseURL$path?$queryString');

    final request = http.Request('POST', uri)..headers.addAll(allHeaders);

    final cookieHeader = cookieJar.getCookiesForUrl(uri.toString());
    if (cookieHeader.isNotEmpty) {
      request.headers['Cookie'] = cookieHeader;
    }

    if (body != null) {
      if (body is String) {
        request.body = body;
      } else {
        request.body = jsonEncode(body);
        request.headers['Content-Type'] = 'application/json';
      }
    }

    http.StreamedResponse response;
    try {
      var future = innerClient.send(request);
      if (connectTimeout != null) {
        future = future.timeout(connectTimeout!);
      }
      response = await future;
      _saveCookiesFromResponse(uri.toString(), response);
      var bodyFuture = response.stream.toBytes();
      if (receiveTimeout != null) {
        bodyFuture = bodyFuture.timeout(receiveTimeout!);
      }
      final responseBody = await bodyFuture;
      final bodyStr = _stripKgTags(utf8.decode(responseBody));
      return jsonDecode(bodyStr) as Map<String, dynamic>;
    } on Exception catch (e) {
      throw KuGouNetworkException(message: e.toString(), originalError: e);
    }
  }

  static String _stripKgTags(String body) {
    return body
        .replaceAll('<!--KG_TAG_RES_START-->', '')
        .replaceAll('<!--KG_TAG_RES_END-->', '')
        .trim();
  }

  void _saveCookiesFromResponse(String url, http.StreamedResponse response) {
    final setCookie = response.headers['set-cookie'];
    if (setCookie != null && setCookie.isNotEmpty) {
      cookieJar.setFromHeader(url, setCookie);
    }
  }

  /// 构建请求参数，合并默认参数、用户参数、签名和加密 key。
  ///
  /// [params] 用户自定义参数，[encryptType] 签名算法类型，
  /// [encryptKey] 是否计算加密 key，[notSignature] 是否跳过签名，
  /// [clearDefaultParams] 是否不添加默认参数，[data] 请求体数据（用于签名计算）。
  Map<String, dynamic> buildRequestParams({
    Map<String, dynamic>? params,
    required EncryptType encryptType,
    required bool encryptKey,
    required bool notSignature,
    bool clearDefaultParams = false,
    String? data,
  }) {
    final allParams = clearDefaultParams ? <String, dynamic>{} : buildDefaultParams();
    if (params != null) allParams.addAll(params);
    if (!clearDefaultParams) {
      if (token != null && token!.isNotEmpty) allParams['token'] = token;
      if (userid != null && userid != 0) allParams['userid'] = userid;
    }

    if (encryptKey) {
      final hash = allParams['hash'] ?? allParams['file_hash'] ?? '';
      allParams['key'] = signKey(
        hash.toString(),
        mid,
        userid: userid,
        appid: config.appid,
        isLite: config.isLite,
      );
    }

    if (!notSignature) {
      signParams(allParams, encryptType, data);
    }

    return allParams;
  }

  /// 构建默认请求参数，包含设备标识和应用版本信息。
  Map<String, dynamic> buildDefaultParams() {
    return {
      'dfid': dfid,
      'mid': mid,
      'uuid': uuid,
      'appid': config.appid,
      'clientver': config.clientver,
      'clienttime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
  }

  /// 构建请求头，包含 User-Agent、设备标识和酷狗特有头信息。
  ///
  /// [router] 路由标识，设置 `x-router` 头，[clienttime] 客户端时间戳。
  Map<String, String> buildHeaders({String? router, required int clienttime}) {
    final h = <String, String>{
      'User-Agent': config.userAgent,
      'Accept': 'application/json, text/plain, */*',
      'dfid': dfid,
      'clienttime': clienttime.toString(),
      'mid': mid,
      'kg-rc': '1',
      'kg-thash': '5d816a0',
      'kg-rec': '1',
      'kg-rf': 'B9EDA08A64250DEFFBCADDEE00F8F25F',
    };
    if (router != null) h['x-router'] = router;
    return h;
  }

  /// 对请求参数进行签名。
  ///
  /// [params] 待签名的参数映射，[encryptType] 选择签名算法，
  /// [data] 请求体数据（Android 签名需要）。
  void signParams(
    Map<String, dynamic> params,
    EncryptType encryptType, [
    String? data,
  ]) {
    if (params.containsKey('signature')) return;
    switch (encryptType) {
      case EncryptType.android:
        params['signature'] = signatureAndroidParams(params, data, config.isLite);
        break;
      case EncryptType.web:
        params['signature'] = signatureWebParams(params);
        break;
      case EncryptType.register:
        params['signature'] = signatureRegisterParams(params);
        break;
    }
  }

  /// 关闭底层 HTTP 客户端，释放资源。
  void close() {
    innerClient.close();
  }
}
