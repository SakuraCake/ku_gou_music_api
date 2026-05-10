import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/search_result.dart';
import '../models/song.dart';

/// 搜索相关接口
class SearchApi extends BaseApi {
  /// 构造搜索 API 实例
  SearchApi(super.client);

  /// 搜索歌曲，[keyword] 为搜索关键词，[page] 为页码，[pageSize] 为每页数量
  Future<SearchResult> songs({
    required String keyword,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.get<SearchResult>(
      '/api/v3/search/song',
      params: {
        'keyword': keyword,
        'page': page,
        'pagesize': pageSize,
      },
      baseURL: 'http://mobilecdn.kugou.com',
      notSignature: true,
      fromJson: (json) => _parseSearchResult(json, keyword),
    );
  }

  /// 搜索歌单，[keyword] 为搜索关键词，[page] 为页码，[pageSize] 为每页数量
  Future<SearchResult> playlists({
    required String keyword,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.get<SearchResult>(
      '/api/v3/search/special',
      params: {
        'keyword': keyword,
        'page': page,
        'pagesize': pageSize,
      },
      baseURL: 'http://mobilecdn.kugou.com',
      notSignature: true,
      fromJson: (json) => _parseSearchResult(json, keyword),
    );
  }

  /// 搜索专辑，[keyword] 为搜索关键词，[page] 为页码，[pageSize] 为每页数量
  Future<SearchResult> albums({
    required String keyword,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.get<SearchResult>(
      '/api/v3/search/album',
      params: {
        'keyword': keyword,
        'page': page,
        'pagesize': pageSize,
      },
      baseURL: 'http://mobilecdn.kugou.com',
      notSignature: true,
      fromJson: (json) => _parseSearchResult(json, keyword),
    );
  }

  /// 搜索歌词，[keyword] 为搜索关键词，[page] 为页码，[pageSize] 为每页数量
  Future<SearchResult> lyrics({
    required String keyword,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.get<SearchResult>(
      '/api/v3/search/lyric',
      params: {
        'keyword': keyword,
        'page': page,
        'pagesize': pageSize,
      },
      baseURL: 'http://mobilecdn.kugou.com',
      notSignature: true,
      fromJson: (json) => _parseSearchResult(json, keyword),
    );
  }

  /// 综合搜索，同时搜索歌曲和专辑，[keyword] 为搜索关键词
  Future<SearchResult> mixed({required String keyword}) async {
    final songResult = await songs(keyword: keyword, pageSize: 5);
    final albumResult = await albums(keyword: keyword, pageSize: 5);
    return SearchResult(
      keyword: keyword,
      songs: songResult.songs,
      albums: albumResult.albums,
      total: (songResult.total ?? 0) + (albumResult.total ?? 0),
    );
  }

  /// 获取热搜详情列表
  Future<List<HotSearchItem>> hotDetail() async {
    final result = await client.get<Map<String, dynamic>>(
      '/api/v3/search/hot',
      baseURL: 'http://mobilecdn.kugou.com',
      notSignature: true,
    );
    final data = result['data'];
    if (data is Map<String, dynamic>) {
      final info = data['info'];
      if (info is List) {
        return info
            .map((e) => HotSearchItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    if (data is List) {
      return data
          .map((e) => HotSearchItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// 搜索建议，[keyword] 为搜索关键词，返回歌曲名建议列表
  Future<SearchSuggest> suggest({
    required String keyword,
    int albumTipCount = 10,
    int correctTipCount = 10,
    int mvTipCount = 10,
    int musicTipCount = 10,
  }) async {
    final result = await client.get<Map<String, dynamic>>(
      '/api/v3/search/song',
      params: {
        'keyword': keyword,
        'page': '1',
        'pagesize': '5',
      },
      baseURL: 'http://mobilecdn.kugou.com',
      notSignature: true,
    );
    final data = result['data'];
    final songs = <String>[];
    if (data is Map<String, dynamic>) {
      final info = data['info'];
      if (info is List) {
        for (final item in info) {
          if (item is Map<String, dynamic>) {
            final songName = item['songname']?.toString();
            if (songName != null) songs.add(songName);
          }
        }
      }
    }
    return SearchSuggest(
      keyword: keyword,
      songs: songs,
      albums: [],
      artists: [],
    );
  }

  /// 综合搜索（已废弃），API 已下线，服务端返回 HTML，暂不可用
  @Deprecated('API 已下线，服务端返回 HTML，暂不可用')
  Future<SearchComplexResult> complex({
    required String keyword,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.get<SearchComplexResult>(
      '/v6/search/complex',
      params: {
        'platform': 'AndroidFilter',
        'keyword': keyword,
        'page': page,
        'pagesize': pagesize,
        'cursor': 0,
      },
      baseURL: 'https://complexsearch.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => SearchComplexResult.fromJson(json),
    );
  }

  /// 获取搜索默认关键词
  Future<SearchDefaultResult> defaultWord() async {
    return client.post<SearchDefaultResult>(
      '/searchnofocus/v1/search_no_focus_word',
      body: {
        'userid': client.httpClient.userid ?? 0,
        'tags': [
          {'id': 0, 'name': ''}
        ],
        'device': 'android',
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SearchDefaultResult.fromJson(json),
    );
  }

  /// 搜索歌曲流，自动分页，[keyword] 为搜索关键词，[pageSize] 为每页数量
  Stream<SearchResult> songsStream({
    required String keyword,
    int pageSize = 30,
  }) async* {
    int page = 1;
    while (true) {
      final result = await songs(
        keyword: keyword,
        page: page,
        pageSize: pageSize,
      );
      yield result;
      if ((result.total ?? 0) <= page * pageSize) break;
      page++;
    }
  }

  SearchResult _parseSearchResult(dynamic json, String keyword) {
    if (json is! Map<String, dynamic>) {
      return SearchResult(keyword: keyword);
    }
    final info = json['info'];
    if (info is List) {
      final songs = info
          .whereType<Map<String, dynamic>>()
          .map((e) => Song(
                name: e['songname'] as String?,
                songName: e['songname'] as String?,
                singer: e['singername'] as String?,
                ownerName: e['singername'] as String?,
                hash: e['hash'] as String?,
                albumId: e['album_id'] is int
                    ? e['album_id'] as int
                    : int.tryParse(e['album_id']?.toString() ?? ''),
                duration: e['duration'] as int?,
              ))
          .toList();
      return SearchResult(
        keyword: keyword,
        total: json['total'] as int?,
        songs: songs,
      );
    }
    return SearchResult.fromJson(json);
  }
}
