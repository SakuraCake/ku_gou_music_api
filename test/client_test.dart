import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:kugou_api/src/client.dart';
import 'package:kugou_api/src/config.dart';
import 'package:kugou_api/src/exception.dart';
import 'package:kugou_api/src/util/logger.dart';
import 'package:kugou_api/src/util/cache.dart';
import 'package:kugou_api/src/util/retry.dart';

class MockHttpClient extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest) handler;

  MockHttpClient(this.handler);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return handler(request);
  }
}

Future<http.StreamedResponse> _jsonResponse(
  Map<String, dynamic> body, {
  int statusCode = 200,
}) async {
  return http.StreamedResponse(
    Stream.value(utf8.encode(jsonEncode(body))),
    statusCode,
  );
}

void main() {
  group('KuGouHttpClient', () {
    late KuGouConfig config;

    setUp(() {
      config = KuGouConfig(platform: Platform.standard);
    });

    test('buildDefaultParams 返回正确的默认参数', () {
      final client = KuGouHttpClient(config: config);
      final params = client.buildDefaultParams();

      expect(params.containsKey('dfid'), isTrue);
      expect(params.containsKey('mid'), isTrue);
      expect(params.containsKey('uuid'), isTrue);
      expect(params['uuid'], equals('-'));
      expect(params['dfid'], equals('-'));
      expect(params['appid'], equals(config.appid));
      expect(params['clientver'], equals(config.clientver));
      expect(params.containsKey('clienttime'), isTrue);
      expect(params['clienttime'], isA<int>());

      client.close();
    });

    test('buildDefaultParams 使用自定义 dfid 和 mid', () {
      final client = KuGouHttpClient(
        config: config,
        dfid: 'custom_dfid_123',
        mid: 'custom_mid_456',
      );
      final params = client.buildDefaultParams();

      expect(params['dfid'], equals('custom_dfid_123'));
      expect(params['mid'], equals('custom_mid_456'));

      client.close();
    });

    test('buildHeaders 包含必要的请求头', () {
      final client = KuGouHttpClient(config: config);
      final headers = client.buildHeaders(clienttime: 1700000000);

      expect(headers['User-Agent'], equals(config.userAgent));
      expect(headers['dfid'], equals(client.dfid));
      expect(headers['clienttime'], equals('1700000000'));
      expect(headers['mid'], equals(client.mid));
      expect(headers['kg-rc'], equals('1'));
      expect(headers['kg-thash'], equals('5d816a0'));
      expect(headers['kg-rec'], equals('1'));
      expect(headers['kg-rf'], equals('B9EDA08A64250DEFFBCADDEE00F8F25F'));
      expect(headers.containsKey('x-router'), isFalse);

      client.close();
    });

    test('buildHeaders 包含 x-router', () {
      final client = KuGouHttpClient(config: config);
      final headers = client.buildHeaders(
        router: 'some.router',
        clienttime: 1700000000,
      );

      expect(headers['x-router'], equals('some.router'));

      client.close();
    });

    test('signParams 根据 encryptType=android 生成签名', () {
      final client = KuGouHttpClient(config: config);
      final params = <String, dynamic>{'appid': 1005, 'clientver': 20489};

      client.signParams(params, EncryptType.android);

      expect(params.containsKey('signature'), isTrue);
      expect(params['signature'], isA<String>());
      expect((params['signature'] as String).length, equals(32));
      expect(
        RegExp(r'^[0-9a-f]{32}$').hasMatch(params['signature'] as String),
        isTrue,
      );

      client.close();
    });

    test('signParams 根据 encryptType=web 生成签名', () {
      final client = KuGouHttpClient(config: config);
      final params = <String, dynamic>{'key': 'value'};

      client.signParams(params, EncryptType.web);

      expect(params.containsKey('signature'), isTrue);
      expect(params['signature'], isA<String>());
      expect((params['signature'] as String).length, equals(32));

      client.close();
    });

    test('signParams 根据 encryptType=register 生成签名', () {
      final client = KuGouHttpClient(config: config);
      final params = <String, dynamic>{'field1': 'val1', 'field2': 'val2'};

      client.signParams(params, EncryptType.register);

      expect(params.containsKey('signature'), isTrue);
      expect(params['signature'], isA<String>());
      expect((params['signature'] as String).length, equals(32));

      client.close();
    });

    test('signParams 不覆盖已有 signature', () {
      final client = KuGouHttpClient(config: config);
      final params = <String, dynamic>{
        'appid': 1005,
        'signature': 'existing_sig',
      };

      client.signParams(params, EncryptType.android);

      expect(params['signature'], equals('existing_sig'));

      client.close();
    });

    test('token 和 userid 自动注入参数', () {
      final client = KuGouHttpClient(
        config: config,
        token: 'test_token',
        userid: 12345,
      );
      final params = client.buildRequestParams(
        encryptType: EncryptType.android,
        encryptKey: false,
        notSignature: false,
      );

      expect(params['token'], equals('test_token'));
      expect(params['userid'], equals(12345));

      client.close();
    });

    test('encryptKey=true 时生成 key 参数', () {
      final client = KuGouHttpClient(config: config);
      final params = client.buildRequestParams(
        params: {'hash': 'abc123'},
        encryptType: EncryptType.android,
        encryptKey: true,
        notSignature: false,
      );

      expect(params.containsKey('key'), isTrue);
      expect(params['key'], isA<String>());
      expect((params['key'] as String).length, equals(32));

      client.close();
    });

    test('notSignature=true 时不生成签名', () {
      final client = KuGouHttpClient(config: config);
      final params = client.buildRequestParams(
        encryptType: EncryptType.android,
        encryptKey: false,
        notSignature: true,
      );

      expect(params.containsKey('signature'), isFalse);

      client.close();
    });

    test('lite 平台不注入 _isLite 到参数', () {
      final liteConfig = KuGouConfig(platform: Platform.lite);
      final client = KuGouHttpClient(config: liteConfig);
      final params = client.buildRequestParams(
        encryptType: EncryptType.android,
        encryptKey: false,
        notSignature: true,
      );

      expect(params.containsKey('_isLite'), isFalse);

      client.close();
    });

    test('lite 平台生成正确的签名', () {
      final liteConfig = KuGouConfig(platform: Platform.lite);
      final client = KuGouHttpClient(config: liteConfig);
      final params = client.buildRequestParams(
        encryptType: EncryptType.android,
        encryptKey: false,
        notSignature: false,
      );

      expect(params.containsKey('signature'), isTrue);
      expect(params['signature'], isA<String>());
      expect((params['signature'] as String).length, equals(32));

      client.close();
    });

    test('GET 请求成功返回 JSON', () async {
      final mockClient = MockHttpClient((request) async {
        expect(request.method, equals('GET'));
        return _jsonResponse({
          'status': 1,
          'data': {'id': 42},
        });
      });

      final client = KuGouHttpClient(config: config, innerClient: mockClient);

      final result = await client.get('/test');
      expect(result['status'], equals(1));
      expect((result['data'] as Map)['id'], equals(42));

      client.close();
    });

    test('POST 请求成功返回 JSON', () async {
      final mockClient = MockHttpClient((request) async {
        expect(request.method, equals('POST'));
        return _jsonResponse({
          'status': 1,
          'data': {'result': 'ok'},
        });
      });

      final client = KuGouHttpClient(config: config, innerClient: mockClient);

      final result = await client.post('/test', body: {'key': 'value'});
      expect(result['status'], equals(1));

      client.close();
    });

    test('GET 请求带 router 设置 x-router 头', () async {
      String? capturedRouter;

      final mockClient = MockHttpClient((request) async {
        capturedRouter = request.headers['x-router'];
        return _jsonResponse({'status': 1});
      });

      final client = KuGouHttpClient(config: config, innerClient: mockClient);

      await client.get('/test', router: 'custom.router');
      expect(capturedRouter, equals('custom.router'));

      client.close();
    });

    test('网络错误抛出 KuGouNetworkException', () async {
      final mockClient = MockHttpClient((request) async {
        throw Exception('Network error');
      });

      final client = KuGouHttpClient(config: config, innerClient: mockClient);

      expect(() => client.get('/test'), throwsA(isA<KuGouNetworkException>()));

      client.close();
    });

    test('openapicdn URL 将参数拼接到 URL 中', () async {
      String? capturedUrl;

      final mockClient = MockHttpClient((request) async {
        capturedUrl = request.url.toString();
        return _jsonResponse({'status': 1});
      });

      final client = KuGouHttpClient(config: config, innerClient: mockClient);

      await client.get('/test', baseURL: 'https://openapicdn.kugou.com');
      expect(capturedUrl, contains('dfid='));
      expect(capturedUrl, contains('mid='));

      client.close();
    });
  });

  group('ApiClient', () {
    late KuGouConfig config;
    late KuGouHttpClient httpClient;

    setUp(() {
      config = KuGouConfig(platform: Platform.standard);
    });

    test('缓存命中时不再发起请求', () async {
      final cache = MemoryCache();
      cache.set(cache.generateKey('GET:/test', {}), {
        'cached': true,
      }, const Duration(minutes: 5));

      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {'not_cached': true},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(
        httpClient: httpClient,
        cache: cache,
        cacheTtl: const Duration(minutes: 5),
      );

      final result = await apiClient.get<Map<String, dynamic>>(
        '/test',
        useCache: true,
      );
      expect(result['cached'], equals(true));
    });

    test('status != 1 且 != 200 时抛出 KuGouApiException', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 0,
          'error': 'something went wrong',
          'data': null,
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(httpClient: httpClient);

      expect(() => apiClient.get('/test'), throwsA(isA<KuGouApiException>()));
    });

    test('status=1 不抛异常', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {'key': 'val'},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(httpClient: httpClient);
      final result = await apiClient.get('/test');
      expect(result['status'], equals(1));
    });

    test('status=200 不抛异常', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 200,
          'data': {'key': 'val'},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(httpClient: httpClient);
      final result = await apiClient.get('/test');
      expect(result['status'], equals(200));
    });

    test('fromJson 转换响应数据', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {'name': 'test', 'value': 42},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(httpClient: httpClient);
      final result = await apiClient.get<Map<String, dynamic>>(
        '/test',
        fromJson: (json) => json,
      );
      expect(result['name'], equals('test'));
      expect(result['value'], equals(42));
    });

    test('日志记录请求信息', () async {
      final logs = <(LogLevel, String)>[];
      final logger = Logger(
        minLevel: LogLevel.debug,
        callback: (level, message) => logs.add((level, message)),
      );

      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({'status': 1});
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(httpClient: httpClient, logger: logger);

      await apiClient.get('/test');

      expect(
        logs.any((l) => l.$1 == LogLevel.debug && l.$2.contains('GET /test')),
        isTrue,
      );
      expect(
        logs.any((l) => l.$1 == LogLevel.info && l.$2.contains('completed')),
        isTrue,
      );
    });

    test('网络错误记录 error 日志', () async {
      final logs = <(LogLevel, String)>[];
      final logger = Logger(
        minLevel: LogLevel.debug,
        callback: (level, message) => logs.add((level, message)),
      );

      final mockClient = MockHttpClient((request) async {
        throw Exception('Network error');
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(
        httpClient: httpClient,
        logger: logger,
        retryOptions: const RetryOptions(maxAttempts: 1),
      );

      try {
        await apiClient.get('/test');
      } catch (_) {}

      expect(
        logs.any((l) => l.$1 == LogLevel.error && l.$2.contains('failed')),
        isTrue,
      );
    });

    test('POST 请求成功', () async {
      final mockClient = MockHttpClient((request) async {
        expect(request.method, equals('POST'));
        return _jsonResponse({
          'status': 1,
          'data': {'ok': true},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);

      final apiClient = ApiClient(httpClient: httpClient);
      final result = await apiClient.post('/test', body: {'key': 'value'});
      expect(result['status'], equals(1));
    });
  });

  group('BaseApi', () {
    test('持有 ApiClient 引用', () {
      final config = KuGouConfig(platform: Platform.standard);
      final httpClient = KuGouHttpClient(config: config);
      final apiClient = ApiClient(httpClient: httpClient);

      final baseApi = _TestApi(apiClient);
      expect(identical(baseApi.client, apiClient), isTrue);

      httpClient.close();
    });
  });
}

class _TestApi extends BaseApi {
  _TestApi(super.client);
}
