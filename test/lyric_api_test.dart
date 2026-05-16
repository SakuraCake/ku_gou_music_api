import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:kugou_api/src/client.dart';
import 'package:kugou_api/src/config.dart';
import 'package:kugou_api/src/models/lyric.dart';
import 'package:kugou_api/src/api/lyric_api.dart';

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
  group('LyricApi', () {
    late KuGouConfig config;
    late KuGouHttpClient httpClient;
    late ApiClient apiClient;
    late LyricApi lyricApi;

    setUp(() {
      config = KuGouConfig(platform: Platform.standard);
    });

    test('search 构造正确的请求参数', () async {
      late http.BaseRequest capturedRequest;

      final mockClient = MockHttpClient((request) async {
        capturedRequest = request;
        return _jsonResponse({
          'status': 1,
          'data': {
            'candidates': [
              {
                'id': '123',
                'accesskey': 'abc',
                'duration': 300,
                'song': 'Test',
                'singer': 'Artist',
              },
            ],
            'count': 1,
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      final result = await lyricApi.search(
        keyword: 'hello',
        duration: 300,
        hash: 'hash123',
      );

      expect(capturedRequest.url.toString(), contains('/search'));
      expect(
        capturedRequest.url.toString(),
        contains('keyword=hello'),
      );
      expect(capturedRequest.url.toString(), contains('duration=300'));
      expect(capturedRequest.url.toString(), contains('hash=hash123'));
      expect(capturedRequest.url.toString(), contains('lyrics.kugou.com'));

      expect(result, isA<LyricSearchResult>());
      expect(result.candidates?.length, equals(1));
      expect(result.candidates?.first.id, equals('123'));
      expect(result.candidates?.first.accesskey, equals('abc'));

      httpClient.close();
    });

    test('search 仅传 keyword 参数', () async {
      late http.BaseRequest capturedRequest;

      final mockClient = MockHttpClient((request) async {
        capturedRequest = request;
        return _jsonResponse({
          'status': 1,
          'data': {'candidates': [], 'count': 0},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      await lyricApi.search(keyword: 'test');

      expect(capturedRequest.url.toString(), contains('keyword=test'));

      httpClient.close();
    });

    test('get LRC 格式解码 base64 内容', () async {
      final lrcContent = '[00:00.00]Hello World';
      final encodedContent = base64Encode(utf8.encode(lrcContent));

      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'content': encodedContent,
            'info': 'OK',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      final result = await lyricApi.get(
        id: '456',
        accesskey: 'key456',
        format: LyricFormat.lrc,
      );

      expect(result, isA<LyricResult>());
      expect(result.content, equals(lrcContent));
      expect(result.format, equals('lrc'));

      httpClient.close();
    });

    test('get LRC 格式非 base64 内容保留原始值', () async {
      final rawContent = '[00:00.00]Raw LRC content';

      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'content': rawContent,
            'info': 'OK',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      final result = await lyricApi.get(
        id: '789',
        accesskey: 'key789',
        format: LyricFormat.lrc,
      );

      expect(result, isA<LyricResult>());
      expect(result.format, equals('lrc_raw'));

      httpClient.close();
    });

    test('get KRC 格式解密内容', () async {
      final krcPlaintext =
          '[ti:Test Song]\n[ar:Artist]\n[00:01.00]Line 1\n[00:05.00]Line 2';
      final krcBytes = _buildKrcBytes(krcPlaintext);
      final encodedContent = base64Encode(krcBytes);

      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'content': encodedContent,
            'info': 'OK',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      final result = await lyricApi.get(
        id: '111',
        accesskey: 'key111',
        format: LyricFormat.krc,
      );

      expect(result, isA<LyricResult>());
      expect(result.content, equals(krcPlaintext));
      expect(result.format, equals('krc'));

      httpClient.close();
    });

    test('get KRC 格式无效数据标记为 krc_raw', () async {
      final invalidKrcHeader = [
        ...utf8.encode('krc1'),
        ...List.filled(20, 0xFF),
      ];
      final invalidContent = base64Encode(invalidKrcHeader);

      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'content': invalidContent,
            'info': 'OK',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      final result = await lyricApi.get(
        id: '222',
        accesskey: 'key222',
        format: LyricFormat.krc,
      );

      expect(result, isA<LyricResult>());
      expect(result.format, equals('krc_raw'));

      httpClient.close();
    });

    test('get JSON 格式无 content 时 format 为 json', () async {
      final mockClient = MockHttpClient((request) async {
        return _jsonResponse({
          'status': 1,
          'data': {
            'info': 'OK',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      final result = await lyricApi.get(
        id: '333',
        accesskey: 'key333',
        format: LyricFormat.json,
      );

      expect(result, isA<LyricResult>());
      expect(result.format, equals('json'));
      expect(result.content, isNull);

      httpClient.close();
    });

    test('get 构造正确的请求参数', () async {
      late http.BaseRequest capturedRequest;

      final mockClient = MockHttpClient((request) async {
        capturedRequest = request;
        return _jsonResponse({
          'status': 1,
          'data': {
            'content': 'test',
            'info': 'OK',
          },
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      await lyricApi.get(id: '444', accesskey: 'key444');

      expect(capturedRequest.url.toString(), contains('lyrics.kugou.com'));
      expect(capturedRequest.url.toString(), contains('/download'));
      expect(capturedRequest.url.toString(), contains('id=444'));
      expect(capturedRequest.url.toString(), contains('accesskey=key444'));
      expect(capturedRequest.url.toString(), contains('fmt=krc'));
      expect(capturedRequest.url.toString(), contains('charset=utf8'));
      expect(capturedRequest.url.toString(), contains('ver=1'));
      expect(capturedRequest.url.toString(), contains('client=android'));

      httpClient.close();
    });

    test('get LRC 格式请求参数 fmt=lrc', () async {
      late http.BaseRequest capturedRequest;

      final mockClient = MockHttpClient((request) async {
        capturedRequest = request;
        return _jsonResponse({
          'status': 1,
          'data': {'content': 'test'},
        });
      });

      httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
      apiClient = ApiClient(httpClient: httpClient);
      lyricApi = LyricApi(apiClient);

      await lyricApi.get(
        id: '555',
        accesskey: 'key555',
        format: LyricFormat.lrc,
      );

      expect(capturedRequest.url.toString(), contains('fmt=lrc'));

      httpClient.close();
    });
  });
}

List<int> _buildKrcBytes(String plaintext) {
  const krcKey = [
    0x40,
    0x47,
    0x61,
    0x77,
    0x5e,
    0x32,
    0x74,
    0x47,
    0x51,
    0x36,
    0x31,
    0x2d,
    0xce,
    0xd2,
    0x6e,
    0x69,
  ];
  final plainBytes = utf8.encode(plaintext);
  final xored = List<int>.generate(
    plainBytes.length,
    (i) => plainBytes[i] ^ krcKey[i % krcKey.length],
  );
  final compressed = zlib.encode(xored);
  return [...utf8.encode('krc1'), ...compressed];
}
