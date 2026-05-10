import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/rsa.dart';
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
  }) async {
    return client.post<UserFollowResult>(
      '/v4/follow_list',
      body: {
        'page': page,
        'pagesize': pagesize,
      },
      router: 'relationuser.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => UserFollowResult.fromJson(json),
    );
  }

  /// 上传播放历史，[songId] 为歌曲 ID，[operate] 为操作类型，需要登录
  Future<PlayHistoryUploadResult> uploadHistory({
    required int songId,
    int operate = 1,
  }) async {
    return client.post<PlayHistoryUploadResult>(
      '/playhistory/v1/upload_songs',
      body: {
        'data': [
          {
            'songid': songId,
            'operate': operate,
            'time': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'play_device': 'android',
          }
        ],
      },
      encryptType: EncryptType.android,
      fromJson: (json) => PlayHistoryUploadResult.fromJson(json),
    );
  }

  /// 获取听歌时长等级信息，需要登录
  Future<ListenTimeResult> listenTimeAdd() async {
    return client.post<ListenTimeResult>(
      '/v2/get_grade_info',
      body: {
        'userid': client.httpClient.userid ?? 0,
        'token': client.httpClient.token ?? '',
      },
      baseURL: 'http://userscenario.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => ListenTimeResult.fromJson(json),
    );
  }
}
