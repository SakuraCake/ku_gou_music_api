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
}
