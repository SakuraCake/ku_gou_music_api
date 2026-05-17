import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../models/recommend.dart';

/// 推荐相关接口
class RecommendApi extends BaseApi {
  /// 构造推荐 API 实例
  RecommendApi(super.client);

  /// 每日推荐歌曲，[platform] 为平台类型，需要登录
  Future<RecommendSongResult> everyday({String platform = 'android'}) async {
    return client.post<RecommendSongResult>(
      '/everyday_song_recommend',
      body: {
        'platform': platform,
        'userid': client.httpClient.userid ?? 0,
      },
      router: 'everydayrec.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => RecommendSongResult.fromJson(json),
    );
  }

  /// AI 推荐歌曲，[albumAudioIds] 为种子歌曲 ID，多个以逗号分隔，需要登录
  Future<RecommendSongResult> ai({String? albumAudioIds}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch;
    final recommendSource = albumAudioIds != null
        ? albumAudioIds.split(',').map((s) => {'ID': int.tryParse(s) ?? 0}).toList()
        : <Map<String, dynamic>>[];
    return client.post<RecommendSongResult>(
      '/recommend',
      body: {
        'platform': 'ios',
        'clientver': client.httpClient.config.clientver,
        'clienttime': clienttime,
        'userid': client.httpClient.userid ?? 0,
        'client_playlist': [],
        'source_type': 2,
        'playlist_ver': 2,
        'area_code': 1,
        'appid': client.httpClient.config.appid,
        'key': signParamsKey(clienttime),
        'mid': client.httpClient.mid,
        'recommend_source': recommendSource,
      },
      router: 'songlistairec.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => RecommendSongResult.fromJson(json),
    );
  }

  /// 获取新歌推荐，[type] 为推荐类型，[page] 为页码，[pageSize] 为每页数量
  Future<NewSongResult> newSongs({
    int type = 21608,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.post<NewSongResult>(
      '/musicadservice/container/v1/newsong_publish',
      body: {
        'rank_id': type,
        'userid': client.httpClient.userid ?? 0,
        'page': page,
        'pagesize': pageSize,
        'tags': [],
      },
      encryptType: EncryptType.android,
      fromJson: NewSongResult.fromJson,
    );
  }

  Future<Map<String, dynamic>> everydayFriend() async {
    return client.post<Map<String, dynamic>>(
      '/sing7/relation/json/v3/friend_rec_by_using_song_list',
      body: {
        'list': [
          {'user_id': 853927886, 'mixsong_ids': []}
        ],
      },
      params: {
        'channel': 130,
        'isteen': 0,
        'platform': 2,
        'usemkv': 1,
      },
      headers: {'pid': '126556797'},
      baseURL: 'https://acsing.service.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> everydayHistory({
    String mode = 'list',
    String platform = 'ios',
    String? historyName,
    String? date,
  }) async {
    final queryParams = <String, dynamic>{
      'mode': mode,
      'platform': platform,
    };
    if (historyName != null) queryParams['history_name'] = historyName;
    if (date != null) queryParams['date'] = date;
    return client.post<Map<String, dynamic>>(
      '/everyday/api/v1/get_history',
      params: queryParams,
      router: 'everydayrec.service.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> everydayStyleRecommend({
    String platform = 'ios',
    String tagids = '',
  }) async {
    return client.post<Map<String, dynamic>>(
      '/everydayrec.service/everyday_style_recommend',
      body: {},
      params: {'tagids': tagids},
      encryptType: EncryptType.android,
    );
  }
}
