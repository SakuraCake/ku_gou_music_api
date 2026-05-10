import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:kugou_api/src/client.dart';
import 'package:kugou_api/src/config.dart';
import 'package:kugou_api/src/models/song.dart';
import 'package:kugou_api/src/api/song_api.dart';

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
  group('SongApi', () {
    late KuGouConfig config;
    late KuGouHttpClient httpClient;
    late ApiClient apiClient;
    late SongApi songApi;

    setUp(() {
      config = KuGouConfig(platform: Platform.standard);
    });

    group('url', () {
      test('构造正确的请求参数', () async {
        Map<String, dynamic>? capturedParams;

        final mockClient = MockHttpClient((request) async {
          capturedParams = request.url.queryParameters;
          return _jsonResponse({
            'status': 1,
            'data': {
              'url': 'https://example.com/song.mp3',
              'hash': 'abc123',
              'fileSize': 1024,
              'extName': 'mp3',
              'bitRate': 128,
              'type': 1,
            },
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        final result = await songApi.url(hash: 'ABC123');

        expect(capturedParams!['hash'], equals('abc123'));
        expect(capturedParams!['album_id'], equals('0'));
        expect(capturedParams!['album_audio_id'], equals('0'));
        expect(capturedParams!['quality'], equals('128'));
        expect(capturedParams!['area_code'], equals('1'));
        expect(capturedParams!['ssa_flag'], equals('is_fromtrack'));
        expect(capturedParams!['version'], equals('11430'));
        expect(capturedParams!['page_id'], equals('151369488'));
        expect(capturedParams!['behavior'], equals('play'));
        expect(capturedParams!['pid'], equals('2'));
        expect(capturedParams!['cmd'], equals('26'));
        expect(capturedParams!['pidversion'], equals('3001'));
        expect(capturedParams!['IsFreePart'], equals('0'));
        expect(
          capturedParams!['ppage_id'],
          equals('463467626,350369493,788954147'),
        );
        expect(capturedParams!['cdnBackup'], equals('1'));
        expect(capturedParams!['clientver'], equals('11430'));
        expect(capturedParams!.containsKey('key'), isTrue);

        expect(result, isA<SongUrl>());
        expect(result.url, equals('https://example.com/song.mp3'));
        expect(result.hash, equals('abc123'));
        expect(result.fileSize, equals(1024));
        expect(result.extName, equals('mp3'));
        expect(result.bitRate, equals(128));

        httpClient.close();
      });

      test('hash 自动转小写', () async {
        String? capturedHash;

        final mockClient = MockHttpClient((request) async {
          capturedHash = request.url.queryParameters['hash'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'ABCDEF123456');

        expect(capturedHash, equals('abcdef123456'));

        httpClient.close();
      });

      test('标准音质 quality=128', () async {
        String? capturedQuality;

        final mockClient = MockHttpClient((request) async {
          capturedQuality = request.url.queryParameters['quality'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash', quality: AudioQuality.standard);

        expect(capturedQuality, equals('128'));

        httpClient.close();
      });

      test('超高音质 quality=320', () async {
        String? capturedQuality;

        final mockClient = MockHttpClient((request) async {
          capturedQuality = request.url.queryParameters['quality'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash', quality: AudioQuality.high);

        expect(capturedQuality, equals('320'));

        httpClient.close();
      });

      test('无损音质 quality=999', () async {
        String? capturedQuality;

        final mockClient = MockHttpClient((request) async {
          capturedQuality = request.url.queryParameters['quality'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash', quality: AudioQuality.lossless);

        expect(capturedQuality, equals('999'));

        httpClient.close();
      });

      test('魔法音效 quality=magic_piano', () async {
        String? capturedQuality;

        final mockClient = MockHttpClient((request) async {
          capturedQuality = request.url.queryParameters['quality'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash', quality: AudioQuality.magic);

        expect(capturedQuality, equals('magic_piano'));

        httpClient.close();
      });

      test('freePart=true 时 IsFreePart=1', () async {
        String? capturedIsFreePart;

        final mockClient = MockHttpClient((request) async {
          capturedIsFreePart = request.url.queryParameters['IsFreePart'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash', freePart: true);

        expect(capturedIsFreePart, equals('1'));

        httpClient.close();
      });

      test('lite 平台使用不同的 page_id 和 pid', () async {
        String? capturedPageId;
        String? capturedPid;
        String? capturedPpageId;

        final liteConfig = KuGouConfig(platform: Platform.lite);
        final mockClient = MockHttpClient((request) async {
          capturedPageId = request.url.queryParameters['page_id'];
          capturedPid = request.url.queryParameters['pid'];
          capturedPpageId = request.url.queryParameters['ppage_id'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(
          config: liteConfig,
          innerClient: mockClient,
        );
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash');

        expect(capturedPageId, equals('967177915'));
        expect(capturedPid, equals('411'));
        expect(capturedPpageId, equals('356753938,823673182,967485191'));

        httpClient.close();
      });

      test('设置 x-router 头为 trackercdn.kugou.com', () async {
        String? capturedRouter;

        final mockClient = MockHttpClient((request) async {
          capturedRouter = request.headers['x-router'];
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash');

        expect(capturedRouter, equals('trackercdn.kugou.com'));

        httpClient.close();
      });

      test('生成 signature 和 key', () async {
        final mockClient = MockHttpClient((request) async {
          final params = request.url.queryParameters;
          expect(params.containsKey('signature'), isTrue);
          expect(params.containsKey('key'), isTrue);
          return _jsonResponse({
            'status': 1,
            'data': {'url': 'https://example.com/song.mp3'},
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.url(hash: 'testhash');

        httpClient.close();
      });
    });

    group('detail', () {
      test('构造正确的请求参数', () async {
        String? capturedBody;
        String? capturedMethod;

        final mockClient = MockHttpClient((request) async {
          capturedMethod = request.method;
          if (request is http.Request) {
            capturedBody = request.body;
          }
          return _jsonResponse({
            'status': 1,
            'data': [
              {
                'hash': 'testhash',
                'album_id': 123,
                'name': 'Test Song',
                'singer': 'Test Singer',
                'duration': 300,
                'img': 'https://example.com/cover.jpg',
                'lyrics': 'la la la',
                'author_name': 'Author',
                'album_name': 'Test Album',
              },
            ],
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        final result = await songApi.detail(hashes: ['testhash']);

        expect(capturedMethod, equals('POST'));
        expect(capturedBody, isNotNull);
        final bodyMap = jsonDecode(capturedBody!) as Map<String, dynamic>;
        expect(bodyMap['data'], isA<List>());
        expect((bodyMap['data'] as List).first['hash'], equals('testhash'));

        expect(result, isA<List<SongDetail>>());
        expect(result.length, equals(1));
        expect(result.first.hash, equals('testhash'));
        expect(result.first.albumId, equals(123));
        expect(result.first.name, equals('Test Song'));
        expect(result.first.singer, equals('Test Singer'));
        expect(result.first.duration, equals(300));
        expect(result.first.img, equals('https://example.com/cover.jpg'));
        expect(result.first.lyrics, equals('la la la'));
        expect(result.first.authorName, equals('Author'));
        expect(result.first.albumName, equals('Test Album'));

        httpClient.close();
      });

      test('设置 x-router 头为 kmr.service.kugou.com', () async {
        String? capturedRouter;

        final mockClient = MockHttpClient((request) async {
          capturedRouter = request.headers['x-router'];
          return _jsonResponse({
            'status': 1,
            'data': [],
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        await songApi.detail(hashes: ['testhash']);

        expect(capturedRouter, equals('kmr.service.kugou.com'));

        httpClient.close();
      });

      test('支持批量查询多个hash', () async {
        List? capturedData;

        final mockClient = MockHttpClient((request) async {
          final bodyStr = request is http.Request ? request.body : '';
          final body = jsonDecode(bodyStr) as Map<String, dynamic>;
          capturedData = body['data'] as List?;
          return _jsonResponse({
            'status': 1,
            'data': [
              {'hash': 'hash1', 'name': 'Song 1'},
              {'hash': 'hash2', 'name': 'Song 2'},
            ],
          });
        });

        httpClient = KuGouHttpClient(config: config, innerClient: mockClient);
        apiClient = ApiClient(httpClient: httpClient);
        songApi = SongApi(apiClient);

        final result = await songApi.detail(hashes: ['hash1', 'hash2']);

        expect(capturedData!.length, equals(2));
        expect(result.length, equals(2));

        httpClient.close();
      });
    });
  });
}
