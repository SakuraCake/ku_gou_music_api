import '../exception.dart';
import '../util/logger.dart';
import '../util/retry.dart';
import '../util/cache.dart';
import 'http_client.dart';

/// API 客户端，封装 HTTP 请求、日志记录、缓存和重试逻辑。
class ApiClient {
  /// HTTP 客户端实例。
  final KuGouHttpClient httpClient;

  /// 日志记录器。
  final Logger logger;

  /// 内存缓存实例。
  final MemoryCache cache;

  /// 重试配置。
  final RetryOptions retryOptions;

  /// 缓存过期时间，为 null 时不使用缓存。
  final Duration? cacheTtl;

  /// 创建 [ApiClient] 实例。
  ///
  /// [logger] 未提供时使用默认日志器，[cache] 未提供时使用默认内存缓存。
  ApiClient({
    required this.httpClient,
    Logger? logger,
    MemoryCache? cache,
    this.retryOptions = const RetryOptions(),
    this.cacheTtl,
  }) : logger = logger ?? Logger(),
       cache = cache ?? MemoryCache();

  /// 发送 GET 请求并返回解析后的数据。
  ///
  /// [path] 请求路径，[params] 查询参数，[fromJson] 自定义 JSON 解析函数，
  /// [useCache] 是否启用缓存，[encryptType] 签名算法类型，
  /// [encryptKey] 是否加密 key，[notSignature] 是否跳过签名，
  /// [clearDefaultParams] 是否清除默认参数，[baseURL] 覆盖基础 URL。
  /// 启用缓存时，会先查询缓存，命中则直接返回。
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    String? router,
    EncryptType encryptType = EncryptType.android,
    bool encryptKey = false,
    bool notSignature = false,
    bool clearDefaultParams = false,
    String? baseURL,
    T Function(Map<String, dynamic>)? fromJson,
    bool useCache = false,
  }) async {
    if (useCache && cacheTtl != null) {
      final cacheKey = cache.generateKey('GET:$path', params ?? {});
      final cached = cache.get<T>(cacheKey);
      if (cached != null) return cached;
    }

    final stopwatch = Stopwatch()..start();
    logger.debug('GET $path params=$params');

    try {
      final result = await withRetry(
        () => httpClient.get(
          path,
          params: params,
          headers: headers,
          router: router,
          encryptType: encryptType,
          encryptKey: encryptKey,
          notSignature: notSignature,
          clearDefaultParams: clearDefaultParams,
          baseURL: baseURL,
        ),
        options: retryOptions,
        retryIf: (e) => e is KuGouNetworkException,
      );

      stopwatch.stop();
      logger.info('GET $path completed in ${stopwatch.elapsedMilliseconds}ms');

      _checkStatus(result);

      if (useCache && cacheTtl != null) {
        final cacheKey = cache.generateKey('GET:$path', params ?? {});
        final dataField = result['data'];
        final data = dataField is Map<String, dynamic> ? dataField : result;
        if (fromJson != null) {
          cache.set(cacheKey, fromJson(data), cacheTtl!);
        } else {
          cache.set(cacheKey, data as T, cacheTtl!);
        }
      }

      if (fromJson != null) {
        final dataField = result['data'];
        final data = dataField is Map<String, dynamic> ? dataField : result;
        return fromJson(data);
      }
      return result as T;
    } on KuGouApiException {
      rethrow;
    } on KuGouNetworkException catch (e) {
      stopwatch.stop();
      logger.error('GET $path failed: $e');
      rethrow;
    } catch (e) {
      stopwatch.stop();
      logger.error('GET $path failed: $e');
      throw KuGouNetworkException(message: e.toString(), originalError: e);
    }
  }

  /// 发送 POST 请求并返回解析后的数据。
  ///
  /// [path] 请求路径，[params] 查询参数，[body] 请求体，
  /// [fromJson] 自定义 JSON 解析函数，[encryptType] 签名算法类型，
  /// [encryptKey] 是否加密 key，[notSignature] 是否跳过签名，
  /// [clearDefaultParams] 是否清除默认参数，[baseURL] 覆盖基础 URL。
  Future<T> post<T>(
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
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final stopwatch = Stopwatch()..start();
    logger.debug('POST $path params=$params');

    try {
      final result = await withRetry(
        () => httpClient.post(
          path,
          params: params,
          body: body,
          headers: headers,
          router: router,
          encryptType: encryptType,
          encryptKey: encryptKey,
          notSignature: notSignature,
          clearDefaultParams: clearDefaultParams,
          baseURL: baseURL,
        ),
        options: retryOptions,
        retryIf: (e) => e is KuGouNetworkException,
      );

      stopwatch.stop();
      logger.info('POST $path completed in ${stopwatch.elapsedMilliseconds}ms');

      _checkStatus(result);

      if (fromJson != null) {
        final dataField = result['data'];
        if (dataField is Map<String, dynamic>) {
          return fromJson(dataField);
        }
        return fromJson(result);
      }
      return result as T;
    } on KuGouApiException {
      rethrow;
    } on KuGouNetworkException catch (e) {
      stopwatch.stop();
      logger.error('POST $path failed: $e');
      rethrow;
    } catch (e) {
      stopwatch.stop();
      logger.error('POST $path failed: $e');
      throw KuGouNetworkException(message: e.toString(), originalError: e);
    }
  }

  void _checkStatus(Map<String, dynamic> result) {
    final status = result['status'];
    if (status != null && status == 0) {
      final code = result['error_code'] as int? ?? result['errcode'] as int? ?? result['code'] as int?;
      if (code == 31136) return;
      throw KuGouApiException(
        status: status is int ? status : int.tryParse(status.toString()),
        code: code,
        message: result['error']?.toString() ?? result['errmsg']?.toString() ?? result['message']?.toString(),
        data: result['data'],
      );
    }
  }
}
