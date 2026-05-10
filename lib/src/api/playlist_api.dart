import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../models/playlist.dart';
import '../models/song.dart';

/// 歌单相关接口
class PlaylistApi extends BaseApi {
  /// 构造歌单 API 实例
  PlaylistApi(super.client);

  /// 获取歌单详情，[ids] 为歌单 ID，多个以逗号分隔，需要登录
  Future<PlaylistDetailResult> detail({required String ids}) async {
    final data = ids.split(',').map((s) => {'global_collection_id': s}).toList();
    return client.post<PlaylistDetailResult>(
      '/v3/get_list_info',
      body: {
        'data': data,
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
      },
      router: 'pubsongs.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) {
        final dataField = json['data'];
        if (dataField is List) {
          return PlaylistDetailResult(
            list: dataField.whereType<Map<String, dynamic>>().map((e) => PlaylistInfo.fromJson(e)).toList(),
          );
        }
        return PlaylistDetailResult.fromJson(json);
      },
    );
  }

  /// 获取歌单歌曲列表，[id] 为歌单 ID，[page] 为页码，[pageSize] 为每页数量
  Future<PlaylistTrackResult> tracks({
    required String id,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.get<PlaylistTrackResult>(
      '/pubsongs/v2/get_other_list_file_nofilt',
      params: {
        'area_code': 1,
        'begin_idx': (page - 1) * pageSize,
        'plat': 1,
        'type': 1,
        'mode': 1,
        'personal_switch': 1,
        'extend_fields': 'abtags,hot_cmt,popularization',
        'pagesize': pageSize,
        'global_collection_id': id,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => _parseTrackResult(json),
    );
  }

  /// 获取歌单标签列表
  Future<List<PlaylistTag>> tags() async {
    final result = await client.post<Map<String, dynamic>>(
      '/pubsongs/v1/get_tags_by_type',
      body: {
        'tag_type': 'collection',
        'tag_id': 0,
        'source': 3,
      },
      encryptType: EncryptType.android,
    );
    final data = result['data'];
    if (data is List) {
      return data.map((e) => PlaylistTag.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  /// 获取相似歌单，[ids] 为歌单 ID，多个以逗号分隔
  Future<SimilarPlaylistResult> similar({required String ids}) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final data = ids.split(',').map((s) => {'global_collection_id': s}).toList();
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<SimilarPlaylistResult>(
      '/pubsongs/v1/kmr_get_similar_lists',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'clienttime': dateTime,
        'key': key,
        'userid': client.httpClient.userid ?? 0,
        'ugc': 1,
        'show_list': 1,
        'need_songs': 1,
        'data': data,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SimilarPlaylistResult.fromJson(json),
    );
  }

  /// 获取热门歌单列表，[categoryId] 为分类 ID，[page] 为页码，[pageSize] 为每页数量
  Future<TopPlaylistResult> top({
    int categoryId = 0,
    int page = 1,
    int pageSize = 30,
  }) async {
    final dateTime = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final key = signParams(
      dateTime,
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<TopPlaylistResult>(
      '/v2/special_recommend',
      body: {
        'appid': client.httpClient.config.appid,
        'mid': client.httpClient.mid,
        'clientver': client.httpClient.config.clientver,
        'platform': 'android',
        'clienttime': dateTime,
        'userid': client.httpClient.userid ?? 0,
        'module_id': 1,
        'page': page,
        'pagesize': pageSize,
        'key': key,
        'special_recommend': {
          'withtag': 1,
          'withsong': 1,
          'sort': 1,
          'ugc': 1,
          'is_selected': 0,
          'withrecommend': 1,
          'area_code': 1,
          'categoryid': categoryId,
        },
        'req_multi': 1,
        'retrun_min': 5,
        'return_special_falg': 1,
      },
      router: 'specialrec.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => TopPlaylistResult.fromJson(json),
    );
  }

  /// 收藏歌单（添加到我的歌单），[name] 为歌单名称，需要登录
  Future<Map<String, dynamic>> add({
    required String name,
    required int listCreateUserid,
    required String listCreateListid,
    String listCreateGid = '',
    int type = 0,
    int source = 1,
    int isPri = 0,
  }) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final dataMap = <String, dynamic>{
      'userid': client.httpClient.userid ?? 0,
      'token': client.httpClient.token ?? '',
      'total_ver': 0,
      'name': name,
      'type': type,
      'source': source,
      'is_pri': isPri,
      'list_create_userid': listCreateUserid,
      'list_create_listid': listCreateListid,
      'list_create_gid': listCreateGid,
      'from_shupinmv': 0,
    };
    return client.post<Map<String, dynamic>>(
      '/cloudlist.service/v5/add_list',
      body: dataMap,
      params: type == 0
          ? {
              'last_time': clienttime,
              'last_area': 'gztx',
              'userid': client.httpClient.userid ?? 0,
              'token': client.httpClient.token ?? '',
            }
          : {},
      encryptType: EncryptType.android,
    );
  }

  /// 向歌单添加歌曲，[listId] 为歌单 ID，[data] 为歌曲数据（格式：名称|hash|albumId|mixsongid），需要登录
  Future<Map<String, dynamic>> addTracks({
    required String listId,
    required String data,
  }) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final resource = data.split(',').map((s) {
      final parts = s.split('|');
      return {
        'number': 1,
        'name': parts.isNotEmpty ? parts[0] : '',
        'hash': parts.length > 1 ? parts[1] : '',
        'size': 0,
        'sort': 0,
        'timelen': 0,
        'bitrate': 0,
        'album_id': parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
        'mixsongid': parts.length > 3 ? int.tryParse(parts[3]) ?? 0 : 0,
      };
    }).toList();
    return client.post<Map<String, dynamic>>(
      '/cloudlist.service/v6/add_song',
      body: {
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
        'listid': listId,
        'list_ver': 0,
        'type': 0,
        'slow_upload': 1,
        'scene': 'false;null',
        'data': resource,
      },
      params: {
        'last_time': clienttime,
        'last_area': 'gztx',
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
      },
      encryptType: EncryptType.android,
    );
  }

  /// 从歌单移除歌曲，[listId] 为歌单 ID，[fileIds] 为歌曲文件 ID，多个以逗号分隔，需要登录
  Future<Map<String, dynamic>> removeTracks({
    required String listId,
    required String fileIds,
  }) async {
    final resource = fileIds.split(',').map((s) => {'fileid': int.tryParse(s) ?? 0}).toList();
    return client.post<Map<String, dynamic>>(
      '/v4/delete_songs',
      body: {
        'listid': listId,
        'userid': client.httpClient.userid ?? 0,
        'data': resource,
        'type': 0,
        'token': client.httpClient.token ?? '',
        'list_ver': 0,
      },
      router: 'cloudlist.service.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  /// 删除歌单，[id] 为歌单 ID，需要登录
  Future<PlaylistDeleteResult> delete({required String id}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final key = signKey(
      '',
      client.httpClient.mid,
      userid: client.httpClient.userid,
      appid: client.httpClient.config.appid,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<PlaylistDeleteResult>(
      '/v2/delete_list',
      body: {
        'dfid': client.httpClient.dfid,
        'mid': client.httpClient.mid,
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'clienttime': clienttime,
        'key': key,
        'data': {
          'list_id': id,
          'type': 0,
        },
        'token': client.httpClient.token ?? '',
        'userid': client.httpClient.userid ?? 0,
      },
      router: 'cloudlist.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => PlaylistDeleteResult.fromJson(json),
    );
  }

  PlaylistTrackResult _parseTrackResult(Map<String, dynamic> json) {
    final songsData = json['songs'];
    if (songsData is List) {
      final songs = songsData
          .whereType<Map<String, dynamic>>()
          .map((e) => Song.fromJson(e))
          .toList();
      return PlaylistTrackResult(
        songs: songs,
        songCount: json['count'] is int
            ? json['count'] as int
            : int.tryParse(json['count']?.toString() ?? ''),
      );
    }
    return PlaylistTrackResult.fromJson(json);
  }
}
