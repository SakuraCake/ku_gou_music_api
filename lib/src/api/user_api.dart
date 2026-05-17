import 'dart:convert';

import 'package:http/http.dart' as http;

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../crypto/signature.dart';
import '../models/user_detail.dart';

/// 用户相关接口
class UserApi extends BaseApi {
  /// 构造用户 API 实例
  UserApi(super.client);

  /// 获取当前用户详情，需要登录
  Future<UserDetailResult> detail() async {
    final token = client.httpClient.token ?? '';
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final p = cryptoRSAEncrypt(
      jsonEncode({'token': token, 'clienttime': clienttime}),
    ).toUpperCase();
    return client.post<UserDetailResult>(
      '/v3/get_my_info',
      body: {
        'visit_time': clienttime,
        'usertype': 1,
        'p': p,
        'userid': client.httpClient.userid ?? 0,
      },
      params: {'plat': 1},
      router: 'usercenter.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => UserDetailResult.fromJson(json),
    );
  }

  /// 获取用户歌单列表，[page] 为页码，[pageSize] 为每页数量，需要登录
  Future<UserPlaylistResult> playlists({
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.post<UserPlaylistResult>(
      '/v7/get_all_list',
      body: {
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
        'total_ver': 979,
        'type': 2,
        'page': page,
        'pagesize': pageSize,
      },
      params: {
        'plat': 1,
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
      },
      router: 'cloudlist.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => UserPlaylistResult.fromJson(json),
    );
  }

  /// 获取用户播放历史，[bp] 为分页游标，需要登录
  Future<UserHistoryResult> history({String? bp}) async {
    final dataMap = <String, dynamic>{
      'token': client.httpClient.token ?? '',
      'userid': client.httpClient.userid ?? 0,
      'source_classify': 'app',
      'to_subdivide_sr': 1,
    };
    if (bp != null) dataMap['bp'] = bp;
    return client.post<UserHistoryResult>(
      '/playhistory/v1/get_songs',
      body: dataMap,
      encryptType: EncryptType.android,
      fromJson: (json) => UserHistoryResult.fromJson(json),
    );
  }

  /// 获取 VIP 详情，需要登录
  Future<VipDetailResult> vipDetail() async {
    return client.get<VipDetailResult>(
      '/v1/get_union_vip',
      params: {'busi_type': 'concept'},
      baseURL: 'https://kugouvip.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => VipDetailResult.fromJson(json),
    );
  }

  /// 获取收藏数量，[mixSongIds] 为混合歌曲 ID，多个以逗号分隔
  Future<FavoriteCountResult> favoriteCount({required String mixSongIds}) async {
    return client.get<FavoriteCountResult>(
      '/count/v1/audio/mget_collect',
      params: {'mixsongids': mixSongIds},
      encryptType: EncryptType.android,
      fromJson: (json) => FavoriteCountResult.fromJson(json),
    );
  }

  /// 获取用户关注列表，[page] 为页码，[pagesize] 为每页数量，需要登录
  Future<UserFollowResult> follow({
    int page = 1,
    int pagesize = 30,
    int? merge,
    int? needIdenType,
    String? extParams,
    int? type,
    int? idType,
  }) async {
    final body = <String, dynamic>{
      'page': page,
      'pagesize': pagesize,
    };
    if (merge != null) body['merge'] = merge;
    if (needIdenType != null) body['need_iden_type'] = needIdenType;
    if (extParams != null) body['ext_params'] = extParams;
    if (type != null) body['type'] = type;
    if (idType != null) body['id_type'] = idType;
    return client.post<UserFollowResult>(
      '/v4/follow_list',
      body: body,
      router: 'relationuser.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => UserFollowResult.fromJson(json),
    );
  }

  /// 上传播放历史，[songId] 为歌曲 ID，[operate] 为操作类型，需要登录
  Future<PlayHistoryUploadResult> uploadHistory({
    required int songId,
    int operate = 1,
    int? mxid,
    int? time,
    int? pc,
  }) async {
    final dataItem = <String, dynamic>{
      'songid': mxid ?? songId,
      'operate': operate,
      'time': time ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'play_device': pc ?? 'android',
    };
    return client.post<PlayHistoryUploadResult>(
      '/playhistory/v1/upload_songs',
      body: {
        'data': [dataItem],
      },
      encryptType: EncryptType.android,
      fromJson: (json) => PlayHistoryUploadResult.fromJson(json),
    );
  }

  /// 获取听歌时长等级信息，需要登录
  Future<ListenTimeResult> listenTimeAdd() async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final token = client.httpClient.token ?? '';
    final p = cryptoRSAEncrypt(
      jsonEncode({'clienttime': clienttime, 'token': token}),
    ).toUpperCase();
    return client.post<ListenTimeResult>(
      '/v2/get_grade_info',
      body: {
        'userid': client.httpClient.userid ?? 0,
        'token': token,
        'p': p,
        'appid': client.httpClient.config.appid,
        'mid': client.httpClient.mid,
        'clientver': client.httpClient.config.clientver,
        'clienttime': clienttime,
        'type': 1,
        'uuid': client.httpClient.uuid,
        'key': signParamsKey(clienttime),
      },
      baseURL: 'http://userscenario.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => ListenTimeResult.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> cloud({
    int page = 1,
    int pagesize = 30,
  }) async {
    final dataMap = <String, dynamic>{
      'page': page,
      'pagesize': pagesize,
      'getkmr': 1,
    };
    final aesEncrypt = playlistAesEncrypt(dataMap);
    final p = rsaEncrypt2({
      'aes': aesEncrypt['key'],
      'uid': client.httpClient.userid ?? 0,
      'token': client.httpClient.token ?? '',
    }).toUpperCase();
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final queryParams = <String, dynamic>{
      'clienttime': clienttime,
      'mid': client.httpClient.mid,
      'key': signParamsKey(clienttime),
      'clientver': client.httpClient.config.clientver,
      'appid': client.httpClient.config.appid,
      'p': p,
    };
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    final url = Uri.parse('https://mcloudservice.kugou.com/v1/get_list?$queryString');
    final httpClient = http.Client();
    try {
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'text/plain'
        ..body = aesEncrypt['str']!;
      final response = await httpClient.send(request);
      final responseBody = await response.stream.toBytes();
      final decrypted = playlistAesDecrypt(
        base64Encode(responseBody),
        aesEncrypt['key']!,
      );
      if (decrypted is Map<String, dynamic>) {
        return decrypted;
      }
      return jsonDecode(decrypted as String) as Map<String, dynamic>;
    } finally {
      httpClient.close();
    }
  }

  Future<Map<String, dynamic>> cloudUrl({
    required String hash,
    int albumAudioId = 0,
    int audioId = 0,
    String name = '',
  }) async {
    return client.get<Map<String, dynamic>>(
      '/bsstrackercdngz/v2/query_musicclound_url',
      params: {
        'hash': hash.toLowerCase(),
        'ssa_flag': 'is_fromtrack',
        'version': '20102',
        'ssl': 0,
        'album_audio_id': albumAudioId,
        'pid': 20026,
        'audio_id': audioId,
        'kv_id': 2,
        'key': signCloudKey(hash, '20026'),
        'bucket': 'musicclound',
        'name': name,
        'with_res_tag': 0,
      },
      baseURL: 'https://mcloudservice.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> listen({int type = 0}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final p = rsaEncrypt2({
      'clienttime': clienttime,
      'token': client.httpClient.token ?? '',
    }).toUpperCase();
    return client.post<Map<String, dynamic>>(
      '/v2/get_list',
      body: {
        't_userid': client.httpClient.userid ?? 0,
        'userid': client.httpClient.userid ?? 0,
        'list_type': type,
        'area_code': 1,
        'cover': 2,
        'p': p,
      },
      params: {
        'clienttime': clienttime,
        'plat': 0,
      },
      baseURL: 'https://listenservice.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> followMessage({
    required int id,
    int pagesize = 30,
  }) async {
    return client.get<Map<String, dynamic>>(
      '/msg.mobile/v3/msgtag/history',
      params: {
        'filter': 1,
        'maxid': 0,
        'pagesize': pagesize,
        'tag': 'chat:${client.httpClient.userid ?? 0}_$id',
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> videoCollect({
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<Map<String, dynamic>>(
      '/collectservice/v2/collect_list_mixvideo',
      body: {
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
        'page': page,
        'pagesize': pagesize,
      },
      params: {
        'plat': 1,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> videoLove({int pagesize = 30}) async {
    return client.get<Map<String, dynamic>>(
      '/m.comment.service/v1/get_user_like_video',
      params: {
        'kugouid': client.httpClient.userid ?? 0,
        'pagesize': pagesize,
        'load_video_info': 1,
        'p': 1,
        'plat': 1,
      },
      encryptType: EncryptType.android,
    );
  }
}
