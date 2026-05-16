import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../config/constants.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../crypto/signature.dart';
import '../exception.dart';
import '../models/user.dart';
import '../util/random.dart';

/// 登录相关接口
class LoginApi extends BaseApi {
  /// 构造登录 API 实例
  LoginApi(super.client);

  /// 当前登录令牌
  String? _token;

  /// 当前登录用户 ID
  int? _userid;

  /// 获取登录令牌，优先使用本地缓存的令牌
  String? get token => _token ?? client.httpClient.token;

  /// 获取登录用户 ID，优先使用本地缓存的用户 ID
  int? get userid => _userid ?? client.httpClient.userid;

  /// 密码登录。
  ///
  /// [username] 用户名，[password] 密码。
  /// 返回登录结果，包含用户信息和 token。
  /// 
  /// 错误码说明：
  /// - 20028: 可能需要验证码登录，请使用 [byCaptcha] 方法
  Future<LoginResult> byPassword({
    required String username,
    required String password,
  }) async {
    final clienttimeMs = DateTime.now().millisecondsSinceEpoch;

    final aesResult = cryptoAesEncrypt({
      'pwd': password,
      'code': '',
      'clienttime_ms': clienttimeMs,
    });

    final rsaEncrypted = cryptoRSAEncrypt(
      jsonEncode({'clienttime_ms': clienttimeMs, 'key': aesResult['key']}),
      publicKey: client.httpClient.config.rsaPublicKey,
    ).toUpperCase();

    final dataMap = {
      'plat': 1,
      'support_multi': 1,
      'clienttime_ms': clienttimeMs,
      't1': kStandardLoginT1,
      't2': kStandardLoginT2,
      't3': kStandardLoginT3,
      'username': username,
      'params': aesResult['str'],
      'pk': rsaEncrypted,
    };

    try {
      final result = await client.post<Map<String, dynamic>>(
        '/v9/login_by_pwd',
        body: dataMap,
        router: 'login.user.kugou.com',
        encryptType: EncryptType.android,
      );

      final data = result['data'] as Map<String, dynamic>?;
      if (data == null) {
        return LoginResult(success: false);
      }

      String? token;
      int? userId;

      if (data['secu_params'] != null) {
        final decrypted = cryptoAesDecrypt(
          data['secu_params'] as String,
          aesResult['key']!,
        );
        if (decrypted is Map<String, dynamic>) {
          token = decrypted['token'] as String?;
          userId = (decrypted['userid'] as num?)?.toInt();
        } else if (decrypted is String) {
          token = decrypted;
        }
      } else {
        token = data['token'] as String?;
        userId = (data['userid'] as num?)?.toInt();
      }

      if (token != null) {
        _token = token;
        _userid = userId;
        client.httpClient.token = token;
        client.httpClient.userid = userId;
      }

      return LoginResult(
        success: token != null,
        token: token,
        userId: userId,
        userName: data['username'] as String?,
      );
    } on KuGouApiException catch (e) {
      if (e.code == 20028) {
        return LoginResult(
          success: false,
          message: '密码登录失败，可能需要验证码登录。请使用 sendCaptcha 发送验证码，然后使用 byCaptcha 登录。',
        );
      }
      rethrow;
    }
  }

  /// 发送验证码到指定手机号。
  ///
  /// [phone] 手机号码，需要是 11 位数字。
  ///
  /// 返回 [CaptchaResult]，包含发送是否成功及错误信息。
  ///
  /// 错误码说明：
  /// - 20015: 该号码发送的短信数已经超过上限
  /// - 20016: 验证码发送过于频繁，请稍后再试
  /// - 20017: 手机号格式不正确
  Future<CaptchaResult> sendCaptcha({required String phone}) async {
    try {
      final result = await client.post<Map<String, dynamic>>(
        '/v7/send_mobile_code',
        body: {
          'businessid': 5,
          'mobile': phone,
          'plat': 3,
        },
        baseURL: 'http://login.user.kugou.com',
        encryptType: EncryptType.android,
        headers: {
          'mid': client.httpClient.mid,
        },
      );
      final status = result['status'] as int?;
      final errorCode = result['error_code'] as int?;
      final data = result['data'];
      String? dataStr;
      if (data is String) {
        dataStr = data;
      }
      
      if (status == 1) {
        return CaptchaResult(success: true);
      }
      
      String message;
      switch (errorCode) {
        case 20015:
          message = '该号码发送的短信数已经超过上限';
          break;
        case 20016:
          message = '验证码发送过于频繁，请稍后再试';
          break;
        case 20017:
          message = '手机号格式不正确';
          break;
        default:
          message = dataStr ?? '验证码发送失败 (错误码: $errorCode)';
      }
      
      return CaptchaResult(
        success: false,
        errorCode: errorCode,
        message: message,
      );
    } catch (e) {
      return CaptchaResult(
        success: false,
        message: '请求失败: $e',
      );
    }
  }

  /// 验证码登录
  ///
  /// [phone] 手机号码，[captcha] 验证码。
  /// 返回登录结果，包含用户信息和令牌。
  Future<LoginResult> byCaptcha({
    required String phone,
    required String captcha,
  }) async {
    final isLite = client.httpClient.config.isLite;
    final clienttimeMs = DateTime.now().millisecondsSinceEpoch;

    final encrypt = cryptoAesEncrypt({'mobile': phone, 'code': captcha});

    final maskedMobile = '${phone.substring(0, 2)}*****${phone.substring(10)}';

    final dfid = client.httpClient.dfid.isNotEmpty
        ? client.httpClient.dfid
        : randomString(24);

    dynamic t1 = 0;
    dynamic t2 = 0;
    if (isLite) {
      final guid = generateGuid();
      final mac = '00:00:00:00:00:00';
      final dev = 'android$clienttimeMs';
      t2 = cryptoAesEncrypt(
        '$guid|0f607264fc6318a92b9e13c65db7cd3c|$mac|$dev|$clienttimeMs',
        key: kLiteLoginT2Key,
        iv: kLiteLoginT2Iv,
      );
      t1 = cryptoAesEncrypt(
        '|$clienttimeMs',
        key: kLiteLoginT1Key,
        iv: kLiteLoginT1Iv,
      );
    }

    final pk = cryptoRSAEncrypt(
      jsonEncode({'clienttime_ms': clienttimeMs, 'key': encrypt['key']}),
      publicKey: isLite ? kLiteRsaPublicKey : kStandardRsaPublicKey,
    ).toUpperCase();

    final dataMap = <String, dynamic>{
      'plat': 1,
      'support_multi': 1,
      't1': t1,
      't2': t2,
      'clienttime_ms': clienttimeMs,
      'mobile': maskedMobile,
      'key': signParamsKey(clienttimeMs, isLite: isLite),
      'pk': pk,
      'params': encrypt['str'],
    };

    if (isLite) {
      dataMap['dfid'] = dfid;
      dataMap['dev'] = 'android$clienttimeMs';
      dataMap['gitversion'] = '5f0b7c4';
    } else {
      dataMap['t3'] = kStandardLoginT3;
    }

    try {
      final result = await client.post<Map<String, dynamic>>(
        '/v7/login_by_verifycode',
        body: dataMap,
        baseURL: kLoginBaseUrl,
        encryptType: EncryptType.android,
        headers: {
          'support-calm': '1',
          'User-Agent': 'Android16-1070-11440-130-0-LOGIN-wifi',
        },
      );

      final data = result['data'] as Map<String, dynamic>?;
      final secuParams = data?['secu_params'] as String?;

      String? token;
      int? userId;

      if (secuParams != null) {
        final decrypted = cryptoAesDecrypt(secuParams, encrypt['key']!);
        if (decrypted is Map<String, dynamic>) {
          token = decrypted['token'] as String?;
          userId = (decrypted['userid'] as num?)?.toInt();
        }
      } else {
        token = data?['token'] as String?;
        userId = (data?['userid'] as num?)?.toInt();
      }

      if (token != null) {
        _token = token;
        _userid = userId;
        client.httpClient.token = token;
        client.httpClient.userid = userId;
      }

      return LoginResult(
        userId: userId,
        token: token,
        userName: data?['username'] as String?,
        vipType: (data?['vip_type'] as num?)?.toInt(),
        success: token != null,
        message: result['error_msg'] as String?,
      );
    } catch (e) {
      return LoginResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// 刷新登录状态
  ///
  /// 使用已有的 token 刷新登录状态，延长 token 有效期。
  /// 返回刷新后的登录结果。
  Future<LoginResult> refreshToken() async {
    final currentToken = token;
    final currentUserId = userid ?? 0;
    
    if (currentToken == null || currentToken.isEmpty) {
      return LoginResult(
        success: false,
        message: '没有可用的 token，请先登录',
      );
    }

    final clienttimeMs = DateTime.now().millisecondsSinceEpoch;
    final isLite = client.httpClient.config.isLite;

    final key = isLite ? 'c24f74ca2820225badc01946dba4fdf7' : '90b8382a1bb4ccdcf063102053fd75b8';
    final iv = isLite ? 'adc01946dba4fdf7' : 'f063102053fd75b8';

    final p3 = cryptoAesEncrypt(
      {'clienttime': clienttimeMs ~/ 1000, 'token': currentToken},
      key: key,
      iv: iv,
    ) as String;
    final encryptParams = cryptoAesEncrypt({}) as Map<String, dynamic>;
    final pk = cryptoRSAEncrypt(
      jsonEncode({'clienttime_ms': clienttimeMs, 'key': encryptParams['key']}),
      publicKey: client.httpClient.config.rsaPublicKey,
    );

    dynamic t1 = 0;
    dynamic t2 = 0;
    if (isLite) {
      final guid = generateGuid();
      final mac = '00:00:00:00:00:00';
      final dev = 'android$clienttimeMs';
      t2 = cryptoAesEncrypt(
        '$guid|0f607264fc6318a92b9e13c65db7cd3c|$mac|$dev|$clienttimeMs',
        key: kLiteLoginT2Key,
        iv: kLiteLoginT2Iv,
      );
      t1 = cryptoAesEncrypt(
        '|$clienttimeMs',
        key: kLiteLoginT1Key,
        iv: kLiteLoginT1Iv,
      );
    }

    final dataMap = <String, dynamic>{
      'dfid': client.httpClient.dfid,
      'p3': p3,
      'plat': 1,
      't1': t1,
      't2': t2,
      't3': kStandardLoginT3,
      'pk': pk,
      'params': encryptParams['str'],
      'userid': currentUserId,
      'clienttime_ms': clienttimeMs,
    };

    try {
      final result = await client.post<Map<String, dynamic>>(
        '/v5/login_by_token',
        body: dataMap,
        baseURL: 'http://login.user.kugou.com',
        encryptType: EncryptType.android,
      );

      final data = result['data'] as Map<String, dynamic>?;
      final secuParams = data?['secu_params'] as String?;

      String? newToken;
      int? newUserId;

      if (secuParams != null) {
        final decrypted = cryptoAesDecrypt(secuParams, encryptParams['key']!);
        if (decrypted is Map<String, dynamic>) {
          newToken = decrypted['token'] as String?;
          newUserId = (decrypted['userid'] as num?)?.toInt();
        }
      } else {
        newToken = data?['token'] as String?;
        newUserId = (data?['userid'] as num?)?.toInt();
      }

      if (newToken != null) {
        _token = newToken;
        _userid = newUserId;
        client.httpClient.token = newToken;
        client.httpClient.userid = newUserId;
      }

      return LoginResult(
        success: newToken != null,
        token: newToken,
        userId: newUserId,
        vipType: (data?['vip_type'] as num?)?.toInt(),
        message: result['error_msg'] as String?,
      );
    } catch (e) {
      return LoginResult(
        success: false,
        message: e.toString(),
      );
    }
  }

  /// 二维码登录状态流，[interval] 为轮询间隔，自动获取二维码并持续检查扫码状态
  ///
  /// 首次 yield 会返回 [QrCodeState.waiting] 并附带 [QrCodeInfo] 中的二维码图片，
  /// 可通过 [qrInfo] 获取二维码信息（含 base64 图片）。
  Stream<QrCodeState> qrCodeStream({
    Duration interval = const Duration(seconds: 3),
  }) async* {
    _qrInfo = await _getQrCode();
    if (_qrInfo == null) {
      yield QrCodeState.error;
      return;
    }

    yield QrCodeState.waiting;

    while (true) {
      final state = await _checkQrCodeState(_qrInfo!);
      yield state;
      if (state == QrCodeState.confirmed ||
          state == QrCodeState.error ||
          state == QrCodeState.expired) {
        break;
      }
      await Future.delayed(interval);
    }
  }

  /// 最近一次二维码信息，二维码登录前为 null
  QrCodeInfo? _qrInfo;

  /// 获取当前二维码信息
  QrCodeInfo? get qrInfo => _qrInfo;

  Future<QrCodeInfo?> _getQrCode() async {
    try {
      final result = await client.get<Map<String, dynamic>>(
        '/v2/qrcode',
        params: {
          'appid': 1001,
          'type': 1,
          'plat': 4,
          'qrimg': 1,
          'qrcode_txt':
              'https://h5.kugou.com/apps/loginQRCode/html/index.html?appid=${client.httpClient.config.appid}&',
          'srcappid': kSrcAppid,
        },
        baseURL: 'https://login-user.kugou.com',
        encryptType: EncryptType.web,
      );
      final data = result['data'];
      if (data is Map<String, dynamic>) {
        return QrCodeInfo(
          qrCode: data['qrcode'] as String?,
          qrUrl: data['qrcode_txt'] as String?,
          qrImg: data['qrcode_img'] as String?,
          expire: (data['expire_time'] as num?)?.toInt(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<QrCodeState> _checkQrCodeState(QrCodeInfo qrInfo) async {
    try {
      final result = await client.get<Map<String, dynamic>>(
        '/v2/get_userinfo_qrcode',
        params: {
          'plat': 4,
          'appid': client.httpClient.config.appid,
          'srcappid': kSrcAppid,
          'qrcode': qrInfo.qrCode,
        },
        baseURL: 'https://login-user.kugou.com',
        encryptType: EncryptType.web,
      );
      final data = result['data'] as Map<String, dynamic>?;
      final status = data?['status'] as int?;
      switch (status) {
        case 0:
          return QrCodeState.expired;
        case 1:
          return QrCodeState.waiting;
        case 2:
          return QrCodeState.scanned;
        case 4:
          final token = data?['token'] as String?;
          final userId = (data?['userid'] as num?)?.toInt();
          if (token != null) {
            _token = token;
            _userid = userId;
            client.httpClient.token = token;
            client.httpClient.userid = userId;
          }
          return QrCodeState.confirmed;
        default:
          return QrCodeState.error;
      }
    } catch (_) {
      return QrCodeState.error;
    }
  }
}
