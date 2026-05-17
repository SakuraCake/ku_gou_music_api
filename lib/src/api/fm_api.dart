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
    String? fmtype,
    String? fmoffset,
    String? fmsize,
  }) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    final fmtypeList = fmtype?.split(',');
    final fmoffsetList = fmoffset?.split(',');
    final fmsizeList = fmsize?.split(',');
    final fmIds = fmId.split(',');
    final fmData = <Map<String, dynamic>>[];
    for (var i = 0; i < fmIds.length; i++) {
      fmData.add({
        'fmid': fmIds[i],
        'fmtype': fmtypeList != null && i < fmtypeList.length ? int.tryParse(fmtypeList[i]) ?? type : type,
        'offset': fmoffsetList != null && i < fmoffsetList.length ? int.tryParse(fmoffsetList[i]) ?? offset : offset,
        'size': fmsizeList != null && i < fmsizeList.length ? int.tryParse(fmsizeList[i]) ?? size : size,
        'singername': '',
      });
    }
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

  /// 个性化电台推荐，获取私人 FM 推荐歌曲
  Future<PersonalFmResult> personal({
    String action = 'play',
    String? songId,
    int? songPoolId,
    String? hash,
    int? playtime,
    String platform = 'ios',
    String mode = 'normal',
    bool isOverplay = false,
    int? vipType,
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
    if (vipType != null) dataMap['vip_type'] = vipType;
    return client.post<PersonalFmResult>(
      '/v2/personal_recommend',
      body: dataMap,
      router: 'persnfm.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => PersonalFmResult.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> recommend() async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    return client.post<Map<String, dynamic>>(
      '/v1/rcmd_list',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'clienttime': dateTime,
        'mid': client.httpClient.mid,
        'key': signParamsKey(dateTime),
        'rcmdsongcount': 1,
        'level': 0,
        'area_code': 1,
        'get_tracker': 1,
        'uid': 0,
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> image({required String fmId}) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final fmData = fmId.split(',').map((s) => {
      'fields': 'imgUrl100,imgUrl50',
      'fmid': s,
      'fmtype': 2,
    }).toList();
    return client.post<Map<String, dynamic>>(
      '/v1/fm_info',
      body: {
        'appid': client.httpClient.config.appid,
        'clienttime': dateTime,
        'clientver': client.httpClient.config.clientver,
        'data': fmData,
        'dfid': client.httpClient.dfid,
        'key': signParamsKey(dateTime),
        'mid': client.httpClient.mid,
      },
      router: 'fm.service.kugou.com',
      headers: {'Content-Type': 'application/json'},
      encryptType: EncryptType.android,
    );
  }
}
