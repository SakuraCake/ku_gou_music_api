import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../models/fm.dart';
import '../models/song.dart';

/// 电台/FM 相关接口
class FmApi extends BaseApi {
  /// 构造电台 API 实例
  FmApi(super.client);

  /// 获取电台分类列表
  Future<FmClassResult> classes() async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<FmClassResult>(
      '/v1/class_fm_song',
      body: {
        'kguid': client.httpClient.userid ?? 0,
        'clienttime': dateTime,
        'mid': client.httpClient.mid,
        'platform': 'android',
        'clientver': client.httpClient.config.clientver,
        'uid': client.httpClient.userid ?? 0,
        'get_tracker': 1,
        'key': key,
        'appid': client.httpClient.config.appid,
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => FmClassResult.fromJson(json),
    );
  }

  /// 获取电台歌曲列表，[fmId] 为电台 ID，多个以逗号分隔，[type] 为类型，[size] 为每页数量
  Future<FmSongResult> songs({
    required String fmId,
    int type = 2,
    int offset = -1,
    int size = 20,
  }) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    final fmData = fmId.split(',').map((s) => {
      'fmid': s,
      'fmtype': type,
      'offset': offset,
      'size': size,
      'singername': '',
    }).toList();
    return client.post<FmSongResult>(
      '/v1/app_song_list_offset',
      body: {
        'appid': client.httpClient.config.appid,
        'area_code': 1,
        'clienttime': dateTime,
        'clientver': client.httpClient.config.clientver,
        'data': fmData,
        'get_tracker': 1,
        'key': key,
        'mid': client.httpClient.mid,
        'uid': client.httpClient.userid ?? 0,
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
      headers: {'Content-Type': 'application/json'},
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          final allSongs = <Song>[];
          for (final item in data) {
            if (item is Map<String, dynamic>) {
              final songlist = item['songlist'];
              if (songlist is List) {
                allSongs.addAll(songlist.whereType<Map<String, dynamic>>().map((e) => Song.fromJson(e)));
              }
            }
          }
          return FmSongResult(songs: allSongs);
        }
        return FmSongResult.fromJson(json);
      },
    );
  }

  /// 个性化电台推荐（已废弃），API 已下线，服务端返回 HTML，暂不可用
  @Deprecated('API 已下线，服务端返回 HTML，暂不可用')
  Future<PersonalFmResult> personal({
    String action = 'play',
    String? songId,
    int? songPoolId,
    String? hash,
    int? playtime,
    String platform = 'ios',
    String mode = 'normal',
    bool isOverplay = false,
  }) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    final dataMap = <String, dynamic>{
      'appid': client.httpClient.config.appid,
      'clienttime': dateTime,
      'mid': client.httpClient.mid,
      'action': action,
      'recommend_source_locked': 0,
      'song_pool_id': songPoolId ?? 0,
      'callerid': 0,
      'm_type': 1,
      'platform': platform,
      'area_code': 1,
      'remain_songcnt': 0,
      'clientver': client.httpClient.config.clientver,
      'is_overplay': isOverplay ? 1 : 0,
      'mode': mode,
      'fakem': 'ca981cfc583a4c37f28d2d49000013c16a0a',
      'key': key,
    };
    final userid = client.httpClient.userid;
    if (userid != null && userid != 0) {
      dataMap['userid'] = userid;
      dataMap['kguid'] = userid;
    }
    final token = client.httpClient.token;
    if (token != null && token.isNotEmpty) dataMap['token'] = token;
    if (hash != null) dataMap['hash'] = hash;
    if (songId != null) dataMap['songid'] = songId;
    if (playtime != null) dataMap['playtime'] = playtime;
    return client.post<PersonalFmResult>(
      '/v2/personal_recommend',
      body: dataMap,
      router: 'persnfm.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => PersonalFmResult.fromJson(json),
    );
  }
}
