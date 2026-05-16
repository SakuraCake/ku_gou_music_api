import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:kugou_api/src/client.dart';
import 'package:kugou_api/src/config.dart';
import 'package:kugou_api/src/api/login_api.dart';

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

    test('byPassword 构造正确的请求参数', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'token': 'test_token',
            'userid': 12345,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.byPassword(
        username: 'test_user',
        password: 'test_password',
      );
      expect(result, isNotNull);
    });

    test('sendCaptcha 发送成功', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.sendCaptcha(phone: '13800138000');
      print('Result: success=${result.success}, message=${result.message}');
      expect(result.success, isTrue);
    });

    test('sendCaptcha 发送失败', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 0,
          'error_code': 20015,
          'data': '发送失败',
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      try {
        final result = await loginApi.sendCaptcha(phone: '13800138000');
        expect(result.success, isFalse);
      } catch (e) {
        print('Caught exception: $e');
        rethrow;
      }
    });

    test('byCaptcha 登录成功', () async {
      final mockClient = MockHttpClient((request) async {
        if (request.url.path.contains('login_by_verifycode')) {
          return _jsonResponse({
            'status': 1,
            'data': {
              'token': 'test_token_67890',
              'userid': 67890,
            },
          });
        }
        return _jsonResponse({'status': 0});
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      final loginApi = LoginApi(apiClient);

      final result = await loginApi.byCaptcha(
        phone: '13800138000',
        captcha: '123456',
      );
      expect(result.success, isTrue);
      expect(result.token, equals('test_token_67890'));
      expect(result.userId, equals(67890));
    });
  });
}
