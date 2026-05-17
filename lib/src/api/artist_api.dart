import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../crypto/signature.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../models/song.dart';

/// 歌手相关接口
class ArtistApi extends BaseApi {
  /// 构造歌手 API 实例
  ArtistApi(super.client);

  /// 获取歌手详情，[id] 为歌手 ID
  Future<ArtistDetailResult> detail({required int id}) async {
    return client.post<ArtistDetailResult>(
      '/kmr/v3/author',
      body: {'author_id': id},
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '36'},
      fromJson: (json) => ArtistDetailResult.fromJson(json),
    );
  }

  /// 获取歌手歌曲列表，[id] 为歌手 ID，[sort] 为排序方式（hot/new），[page] 为页码，[pageSize] 为每页数量
  Future<ArtistAudioResult> audios({
    required int id,
    int page = 1,
    int pageSize = 30,
    String sort = 'hot',
  }) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final key = signParams(
      clienttime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<ArtistAudioResult>(
      '/kmr/v1/audio_group/author',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'mid': client.httpClient.mid,
        'clienttime': clienttime,
        'key': key,
        'author_id': id,
        'pagesize': pageSize,
        'page': page,
        'sort': sort == 'hot' ? 1 : 2,
        'area_code': 'all',
      },
      baseURL: 'https://openapi.kugou.com',
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '220'},
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          return ArtistAudioResult(
            songs: data.whereType<Map<String, dynamic>>().map((e) => Song.fromJson(e)).toList(),
          );
        }
        return ArtistAudioResult.fromJson(json);
      },
    );
  }

  /// 获取歌手专辑列表，[id] 为歌手 ID，[sort] 为排序方式（hot/new），[page] 为页码，[pageSize] 为每页数量
  Future<ArtistAlbumResult> albums({
    required int id,
    int page = 1,
    int pageSize = 30,
    String sort = 'hot',
  }) async {
    return client.post<ArtistAlbumResult>(
      '/kmr/v1/author/albums',
      body: {
        'author_id': id,
        'pagesize': pageSize,
        'page': page,
        'sort': sort == 'hot' ? 3 : 1,
        'category': 1,
        'area_code': 'all',
      },
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '36'},
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          return ArtistAlbumResult(
            albums: data.whereType<Map<String, dynamic>>().map((e) => AlbumInfo.fromJson(e)).toList(),
          );
        }
        return ArtistAlbumResult.fromJson(json);
      },
    );
  }

  /// 获取歌手分类列表，[type] 为分类类型，[sexType] 为性别筛选，[musician] 是否音乐人，[hotSize] 热门数量
  Future<ArtistListResult> list({
    int type = 0,
    int sexType = 0,
    int musician = 0,
    int hotSize = 30,
  }) async {
    return client.get<ArtistListResult>(
      '/ocean/v6/singer/list',
      params: {
        'musician': musician,
        'sextype': sexType,
        'showtype': 2,
        'type': type,
        'hotsize': hotSize,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => ArtistListResult.fromJson(json),
    );
  }

  /// 关注歌手，[id] 为歌手 ID，需要登录
  Future<Map<String, dynamic>> follow({required int id}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final token = client.httpClient.token ?? '';
    final encrypt = cryptoAesEncrypt({'singerid': id, 'token': token});
    final p = cryptoRSAEncrypt(
      jsonEncode({'clienttime': clienttime, 'key': encrypt['key']}),
      publicKey: client.httpClient.config.rsaPublicKey,
    ).toUpperCase();
    return client.post<Map<String, dynamic>>(
      '/followservice/v3/follow_singer',
      body: {
        'plat': 0,
        'userid': client.httpClient.userid ?? 0,
        'singerid': id,
        'source': 7,
        'p': p,
        'params': encrypt['str'],
      },
      params: {'clienttime': clienttime},
      encryptType: EncryptType.android,
    );
  }

  /// 取消关注歌手，[id] 为歌手 ID，需要登录
  Future<Map<String, dynamic>> unfollow({required int id}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final token = client.httpClient.token ?? '';
    final encrypt = cryptoAesEncrypt({'singerid': id, 'token': token});
    final p = cryptoRSAEncrypt(
      jsonEncode({'clienttime': clienttime, 'key': encrypt['key']}),
      publicKey: client.httpClient.config.rsaPublicKey,
    ).toUpperCase();
    return client.post<Map<String, dynamic>>(
      '/followservice/v3/unfollow_singer',
      body: {
        'plat': 0,
        'userid': client.httpClient.userid ?? 0,
        'singerid': id,
        'source': 7,
        'p': p,
        'params': encrypt['str'],
      },
      params: {'clienttime': clienttime},
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> videos({
    required int id,
    String tag = 'all',
    int page = 1,
    int pagesize = 30,
  }) async {
    const tagMapping = <String, dynamic>{
      'official': 18,
      'live': 20,
      'fan': 23,
      'artist': 42419,
      'all': '',
    };
    return client.get<Map<String, dynamic>>(
      '/kmr/v1/author/videos',
      params: {
        'author_id': id,
        'tag_idx': tagMapping[tag] ?? '',
        'page': page,
        'pagesize': pagesize,
      },
      baseURL: 'https://openapicdn.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> followNewSongs({
    int lastAlbumId = 0,
    int pagesize = 30,
    int optSort = 1,
  }) async {
    return client.post<Map<String, dynamic>>(
      '/feed/v1/follow/newsong_album_list',
      body: {'last_album_id': lastAlbumId},
      params: {
        'last_album_id': lastAlbumId,
        'page_size': pagesize,
        'opt_sort': optSort,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> honour({
    required int id,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<Map<String, dynamic>>(
      '/v1/query_singer_honour_detail',
      params: {
        'singer_id': id,
        'pagesize': pagesize,
        'page': page,
      },
      baseURL: 'http://h5activity.kugou.com',
      encryptType: EncryptType.android,
    );
  }
}
