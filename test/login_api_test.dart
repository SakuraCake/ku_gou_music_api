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

    test('byPassword 已禁用，调用抛出异常', () async {
      httpClient = KuGouHttpClient(config: config);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      expect(
        () => loginApi.byPassword(
          username: '13800138000',
          password: 'test_password',
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('sendCaptcha 已禁用，调用抛出异常', () async {
      httpClient = KuGouHttpClient(config: config);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      expect(
        () => loginApi.sendCaptcha(phone: '13800138000'),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('byCaptcha 已禁用，调用抛出异常', () async {
      httpClient = KuGouHttpClient(config: config);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      expect(
        () => loginApi.byCaptcha(phone: '13800138000', captcha: '123456'),
        throwsA(isA<UnsupportedError>()),
      );
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
      expect(states.first, equals(QrCodeState.waiting));
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

      expect(states.length, equals(3));
      expect(states[0], equals(QrCodeState.waiting));
      expect(states[1], equals(QrCodeState.waiting));
      expect(states[2], equals(QrCodeState.expired));
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

      expect(states[0], equals(QrCodeState.waiting));
      expect(states[1], equals(QrCodeState.scanned));
      expect(states[2], equals(QrCodeState.confirmed));
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

      expect(capturedRequest.url.toString(), contains('login-user.kugou.com'));
      expect(
        capturedRequest.url.toString(),
        contains('/v2/get_userinfo_qrcode'),
      );
      expect(capturedRequest.url.toString(), contains('qrcode=test_qr_code'));
      expect(capturedRequest.url.toString(), contains('plat=4'));
      expect(capturedRequest.url.toString(), contains('srcappid=2919'));
    });
  });
}
