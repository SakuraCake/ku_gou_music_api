import 'package:test/test.dart';
import 'package:kugou_api/src/client/api_client.dart';
import 'package:kugou_api/src/client/http_client.dart';
import 'package:kugou_api/src/config.dart';
import 'package:kugou_api/src/api/search_api.dart';

class _ApiCallRecord {
  final String method;
  final String path;
  final Map<String, dynamic>? params;
  final Map<String, String>? headers;
  final String? router;
  final EncryptType encryptType;
  final bool notSignature;
  final String? baseURL;

  _ApiCallRecord({
    required this.method,
    required this.path,
    this.params,
    this.headers,
    this.router,
    required this.encryptType,
    required this.notSignature,
    this.baseURL,
  });
}

class _FakeApiClient extends ApiClient {
  _FakeApiClient()
    : super(
        httpClient: KuGouHttpClient(
          config: KuGouConfig(platform: Platform.standard),
        ),
      );

  final List<_ApiCallRecord> calls = [];
  final List<dynamic> _responses = [];
  int _callIndex = 0;

  void stubResponse(dynamic response) {
    _responses.add(response);
  }

  @override
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
    calls.add(
      _ApiCallRecord(
        method: 'GET',
        path: path,
        params: params != null ? Map<String, dynamic>.from(params) : null,
        headers: headers != null ? Map<String, String>.from(headers) : null,
        router: router,
        encryptType: encryptType,
        notSignature: notSignature,
        baseURL: baseURL,
      ),
    );

    final idx = _callIndex < _responses.length
        ? _callIndex
        : _responses.length - 1;
    _callIndex++;

    final response = _responses[idx];
    if (fromJson != null && response is Map<String, dynamic>) {
      return fromJson(response);
    }
    return response as T;
  }
}

void main() {
  group('SearchApi', () {
    late _FakeApiClient fakeClient;
    late SearchApi searchApi;

    setUp(() {
      fakeClient = _FakeApiClient();
      searchApi = SearchApi(fakeClient);
    });

    test('songs 构造正确的请求参数', () async {
      fakeClient.stubResponse({
        'info': [],
        'total': 0,
      });

      await searchApi.songs(keyword: '周杰伦', page: 2, pageSize: 20);

      expect(fakeClient.calls.length, equals(1));
      final call = fakeClient.calls.first;
      expect(call.path, equals('/v3/search/song'));
      expect(call.params!['keyword'], equals('周杰伦'));
      expect(call.params!['page'], equals(2));
      expect(call.params!['pagesize'], equals(20));
      expect(call.router, equals('complexsearch.kugou.com'));
      expect(call.encryptType, equals(EncryptType.android));
    });

    test('songs 使用默认分页参数', () async {
      fakeClient.stubResponse({'info': [], 'total': 0});

      await searchApi.songs(keyword: 'test');

      final call = fakeClient.calls.first;
      expect(call.params!['page'], equals(1));
      expect(call.params!['pagesize'], equals(30));
    });

    test('songsStream 自动翻页', () async {
      fakeClient.stubResponse({
        'info': [],
        'total': 60,
      });
      fakeClient.stubResponse({
        'info': [],
        'total': 60,
      });

      final results = await searchApi
          .songsStream(keyword: 'test', pageSize: 30)
          .toList();

      expect(results.length, equals(2));
      expect(fakeClient.calls.length, equals(2));
      expect(fakeClient.calls[0].params!['page'], equals(1));
      expect(fakeClient.calls[1].params!['page'], equals(2));
    });

    test('songsStream total <= page*pageSize 时停止', () async {
      fakeClient.stubResponse({
        'info': [],
        'total': 30,
      });

      final results = await searchApi
          .songsStream(keyword: 'test', pageSize: 30)
          .toList();

      expect(results.length, equals(1));
      expect(fakeClient.calls.length, equals(1));
    });

    test('songsStream total 为 null 时只请求一页', () async {
      fakeClient.stubResponse({'info': [], 'total': null});

      final results = await searchApi
          .songsStream(keyword: 'test', pageSize: 30)
          .toList();

      expect(results.length, equals(1));
    });

    test('hotDetail 返回热搜列表', () async {
      fakeClient.stubResponse({
        'data': [
          {'searchWord': '周杰伦', 'score': 100, 'content': '周杰伦'},
          {'searchWord': '林俊杰', 'score': 90, 'content': '林俊杰'},
        ],
      });

      final result = await searchApi.hotDetail();

      expect(result.length, equals(2));
      expect(result[0].content, equals('周杰伦'));
      expect(result[0].score, equals(100));
      expect(result[1].content, equals('林俊杰'));

      final call = fakeClient.calls.first;
      expect(call.path, equals('/api/v3/search/hot'));
      expect(call.baseURL, equals('http://mobilecdn.kugou.com'));
      expect(call.notSignature, isTrue);
    });

    test('hotDetail data 不是 List 时返回空列表', () async {
      fakeClient.stubResponse({'data': null});

      final result = await searchApi.hotDetail();

      expect(result, isEmpty);
    });

    test('suggest 构造正确的请求', () async {
      fakeClient.stubResponse({
        'data': {
          'info': [
            {'songname': '周杰伦'},
            {'songname': '林俊杰'},
          ],
        },
      });

      final result = await searchApi.suggest(keyword: '周');

      expect(result.keyword, equals('周'));
      expect(result.songs, equals(['周杰伦', '林俊杰']));
      expect(result.albums, equals([]));

      final call = fakeClient.calls.first;
      expect(call.path, equals('/api/v3/search/song'));
      expect(call.params!['keyword'], equals('周'));
      expect(call.params!['page'], equals('1'));
      expect(call.params!['pagesize'], equals('5'));
      expect(call.baseURL, equals('http://mobilecdn.kugou.com'));
      expect(call.notSignature, isTrue);
    });

    test('suggest 自定义 tipCount 参数不传递给 mobilecdn', () async {
      fakeClient.stubResponse({
        'data': {'info': []},
      });

      await searchApi.suggest(
        keyword: 'test',
        albumTipCount: 5,
        correctTipCount: 3,
        mvTipCount: 2,
        musicTipCount: 8,
      );

      final call = fakeClient.calls.first;
      expect(call.params!['keyword'], equals('test'));
      expect(call.params!['page'], equals('1'));
      expect(call.params!['pagesize'], equals('5'));
    });

    test('playlists 使用正确的路径', () async {
      fakeClient.stubResponse({'playlists': [], 'total': 0});

      await searchApi.playlists(keyword: 'test');

      final call = fakeClient.calls.first;
      expect(call.path, equals('/v1/search/special'));
      expect(call.router, equals('complexsearch.kugou.com'));
      expect(call.encryptType, equals(EncryptType.android));
    });

    test('albums 使用正确的路径', () async {
      fakeClient.stubResponse({'albums': [], 'total': 0});

      await searchApi.albums(keyword: 'test');

      final call = fakeClient.calls.first;
      expect(call.path, equals('/v1/search/album'));
      expect(call.router, equals('complexsearch.kugou.com'));
      expect(call.encryptType, equals(EncryptType.android));
    });

    test('lyrics 使用正确的路径', () async {
      fakeClient.stubResponse({'total': 0});

      await searchApi.lyrics(keyword: 'test');

      final call = fakeClient.calls.first;
      expect(call.path, equals('/api/v3/search/lyric'));
      expect(call.baseURL, equals('http://mobilecdn.kugou.com'));
      expect(call.notSignature, isTrue);
    });

    test('mixed 组合调用 songs 和 albums', () async {
      fakeClient.stubResponse({
        'info': [],
        'total': 10,
      });
      fakeClient.stubResponse({
        'albums': [],
        'total': 5,
      });

      final result = await searchApi.mixed(keyword: 'test');

      expect(result.keyword, equals('test'));
      expect(result.total, equals(15));

      expect(fakeClient.calls.length, equals(2));
      expect(fakeClient.calls[0].path, equals('/v3/search/song'));
      expect(fakeClient.calls[0].params!['keyword'], equals('test'));
      expect(fakeClient.calls[0].params!['pagesize'], equals(5));
      expect(fakeClient.calls[0].router, equals('complexsearch.kugou.com'));
      expect(fakeClient.calls[0].encryptType, equals(EncryptType.android));

      expect(fakeClient.calls[1].path, equals('/v1/search/album'));
      expect(fakeClient.calls[1].params!['keyword'], equals('test'));
      expect(fakeClient.calls[1].params!['pagesize'], equals(5));
      expect(fakeClient.calls[1].router, equals('complexsearch.kugou.com'));
      expect(fakeClient.calls[1].encryptType, equals(EncryptType.android));
    });

    test('lyrics 使用 mobilecdn 且 notSignature', () async {
      fakeClient.stubResponse({'total': 0});

      await searchApi.lyrics(keyword: 't');

      final call = fakeClient.calls.first;
      expect(call.path, equals('/api/v3/search/lyric'));
      expect(call.baseURL, equals('http://mobilecdn.kugou.com'));
      expect(call.notSignature, isTrue);
    });
  });
}
