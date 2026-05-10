import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:kugou_api/src/client.dart';
import 'package:kugou_api/src/config.dart';
import 'package:kugou_api/src/api/login_api.dart';
import 'package:kugou_api/src/models/user.dart';
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
  group('LoginApi', () {
    late KuGouConfig config;
    late KuGouHttpClient httpClient;
    late ApiClient apiClient;

    setUp(() {
      config = KuGouConfig(platform: Platform.standard);
    });

    tearDown(() {
      httpClient.close();
    });

    test('byPassword 登录成功并保存 token', () async {
      final mockClient = MockHttpClient((request) async {
        expect(request.method, equals('POST'));
        expect(request.headers['x-router'], equals('login.user.kugou.com'));
        return _jsonResponse({
          'status': 1,
          'data': {
            'userId': 12345,
            'token': 'test_token_pwd',
            'userName': 'testuser',
            'vipType': 0,
            'success': true,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.byPassword(
        username: '13800138000',
        password: 'test_password',
      );

      expect(result.token, equals('test_token_pwd'));
      expect(result.userId, equals(12345));
      expect(result.success, isTrue);
      expect(loginApi.token, equals('test_token_pwd'));
      expect(loginApi.userid, equals(12345));
      expect(httpClient.token, equals('test_token_pwd'));
      expect(httpClient.userid, equals(12345));
    });

    test('byPassword 登录失败不保存 token', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'userId': null,
            'token': null,
            'success': false,
            'message': '密码错误',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.byPassword(
        username: '13800138000',
        password: 'wrong_password',
      );

      expect(result.token, isNull);
      expect(result.success, isFalse);
      expect(loginApi.token, isNull);
      expect(loginApi.userid, isNull);
    });

    test('sendCaptcha 发送验证码成功', () async {
      final mockClient = MockHttpClient((request) async {
        expect(request.method, equals('POST'));
        expect(request.headers['x-router'], equals('loginuser.kugou.com'));
        return _jsonResponse({
          'status': 1,
          'data': {'status': 1},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.sendCaptcha(phone: '13800138000');
      expect(result, isTrue);
    });

    test('sendCaptcha 发送验证码失败', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {'status': 0},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.sendCaptcha(phone: '13800138000');
      expect(result, isFalse);
    });

    test('byCaptcha 登录成功并保存 token', () async {
      final mockClient = MockHttpClient((request) async {
        expect(request.method, equals('POST'));
        expect(request.headers['x-router'], equals('loginuser.kugou.com'));
        return _jsonResponse({
          'status': 1,
          'data': {
            'userId': 67890,
            'token': 'test_token_captcha',
            'userName': 'captcha_user',
            'vipType': 1,
            'success': true,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.byCaptcha(
        phone: '13800138000',
        captcha: '123456',
      );

      expect(result.token, equals('test_token_captcha'));
      expect(result.userId, equals(67890));
      expect(loginApi.token, equals('test_token_captcha'));
      expect(loginApi.userid, equals(67890));
      expect(httpClient.token, equals('test_token_captcha'));
      expect(httpClient.userid, equals(67890));
    });

    test('byCaptcha 登录失败不保存 token', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'userId': null,
            'token': null,
            'success': false,
            'message': '验证码错误',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.byCaptcha(
        phone: '13800138000',
        captcha: '000000',
      );

      expect(result.token, isNull);
      expect(result.success, isFalse);
      expect(loginApi.token, isNull);
    });

    test('qrCodeStream 获取二维码失败返回 error', () async {
      final mockClient = MockHttpClient((request) async {
        throw Exception('Network error');
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(
        httpClient: httpClient,
        retryOptions: const RetryOptions(maxAttempts: 1),
      );
      final loginApi = LoginApi(apiClient);

      final states = await loginApi.qrCodeStream().toList();
      expect(states, equals([QrCodeState.error]));
    });

    test('qrCodeStream 等待后确认', () async {
      final mockClient = MockHttpClient((request) async {
        if (request.url.path.contains('get_userinfo_qrcode')) {
          return _jsonResponse({
            'status': 1,
            'data': {'status': 4, 'token': 'qr_token', 'userid': 99999},
          });
        }
        return _jsonResponse({
          'status': 1,
          'data': {
            'qrcode': 'test_qr_code',
            'qrcode_txt': 'https://example.com/qr',
            'expire_time': 300,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final states = await loginApi
          .qrCodeStream(interval: const Duration(milliseconds: 10))
          .toList();

      expect(states, contains(QrCodeState.confirmed));
      expect(loginApi.token, equals('qr_token'));
      expect(loginApi.userid, equals(99999));
      expect(httpClient.token, equals('qr_token'));
      expect(httpClient.userid, equals(99999));
    });

    test('qrCodeStream 等待后过期', () async {
      int checkCount = 0;

      final mockClient = MockHttpClient((request) async {
        if (request.url.path.contains('get_userinfo_qrcode')) {
          checkCount++;
          if (checkCount == 1) {
            return _jsonResponse({
              'status': 1,
              'data': {'status': 1},
            });
          }
          return _jsonResponse({
            'status': 1,
            'data': {'status': 0},
          });
        }
        return _jsonResponse({
          'status': 1,
          'data': {
            'qrcode': 'test_qr_code',
            'qrcode_txt': 'https://example.com/qr',
            'expire_time': 300,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final states = await loginApi
          .qrCodeStream(interval: const Duration(milliseconds: 10))
          .toList();

      expect(states.length, equals(2));
      expect(states[0], equals(QrCodeState.waiting));
      expect(states[1], equals(QrCodeState.expired));
    });

    test('qrCodeStream 已扫码状态', () async {
      int checkCount = 0;

      final mockClient = MockHttpClient((request) async {
        if (request.url.path.contains('get_userinfo_qrcode')) {
          checkCount++;
          if (checkCount == 1) {
            return _jsonResponse({
              'status': 1,
              'data': {'status': 2},
            });
          }
          return _jsonResponse({
            'status': 1,
            'data': {'status': 4, 'token': 'scanned_token', 'userid': 11111},
          });
        }
        return _jsonResponse({
          'status': 1,
          'data': {
            'qrcode': 'test_qr_code',
            'qrcode_txt': 'https://example.com/qr',
            'expire_time': 300,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final states = await loginApi
          .qrCodeStream(interval: const Duration(milliseconds: 10))
          .toList();

      expect(states[0], equals(QrCodeState.scanned));
      expect(states[1], equals(QrCodeState.confirmed));
    });

    test('token 优先使用 LoginApi 实例的 token', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({'status': 1, 'data': {}});
      });

      httpClient = KuGouHttpClient(
        config: config,
        token: 'http_token',
        userid: 100,
        innerClient: mockClient,
      );
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      expect(loginApi.token, equals('http_token'));
      expect(loginApi.userid, equals(100));

      final mockClient2 = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {'userId': 200, 'token': 'api_token', 'success': true},
        });
      });

      httpClient.close();
      httpClient = KuGouHttpClient(config: config, innerClient: mockClient2);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi2 = LoginApi(apiClient);

      await loginApi2.byPassword(username: '13800138000', password: 'test');

      expect(loginApi2.token, equals('api_token'));
      expect(loginApi2.userid, equals(200));
    });

    test('byPassword 密码经过 AES 加密', () async {
      String? capturedBody;

      final mockClient = MockHttpClient((request) async {
        capturedBody = await request.finalize().bytesToString();
        return _jsonResponse({
          'status': 1,
          'data': {'userId': 1, 'token': 'encrypted_token', 'success': true},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      await loginApi.byPassword(
        username: '13800138000',
        password: 'plain_password',
      );

      expect(capturedBody, isNotNull);
      final body = jsonDecode(capturedBody!) as Map<String, dynamic>;
      expect(body['username'], equals('13800138000'));
      expect(body['params'], isNot(equals('plain_password')));
      expect(body['pk'], isNotNull);
      expect(body['t1'], isNotNull);
      expect(body['t2'], isNotNull);
      expect(body['t3'], equals('MCwwLDAsMCwwLDAsMCwwLDA='));
      expect(body['plat'], equals(1));
      expect(body['support_multi'], equals(1));
    });

    test('qrCodeStream 使用正确的 baseURL 和 encryptType', () async {
      late http.BaseRequest capturedRequest;

      final mockClient = MockHttpClient((request) async {
        if (request.url.path.contains('get_userinfo_qrcode')) {
          capturedRequest = request;
          return _jsonResponse({
            'status': 1,
            'data': {'status': 4, 'token': 'qr_token2', 'userid': 55555},
          });
        }
        return _jsonResponse({
          'status': 1,
          'data': {
            'qrcode': 'test_qr_code',
            'qrcode_txt': 'https://example.com/qr',
            'expire_time': 300,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      await loginApi
          .qrCodeStream(interval: const Duration(milliseconds: 10))
          .toList();

      expect(
        capturedRequest.url.toString(),
        contains('login-user.kugou.com'),
      );
      expect(
        capturedRequest.url.toString(),
        contains('/v2/get_userinfo_qrcode'),
      );
      expect(
        capturedRequest.url.toString(),
        contains('qrcode=test_qr_code'),
      );
      expect(
        capturedRequest.url.toString(),
        contains('plat=4'),
      );
      expect(
        capturedRequest.url.toString(),
        contains('srcappid=2919'),
      );
    });
  });
}
