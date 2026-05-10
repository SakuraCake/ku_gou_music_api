import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/longaudio.dart';

/// 长音频/广播剧相关接口
class LongaudioApi extends BaseApi {
  /// 构造长音频 API 实例
  LongaudioApi(super.client);

  /// 获取长音频专辑详情，[albumId] 为专辑 ID，多个以逗号分隔
  Future<LongaudioDetailResult> albumDetail({required String albumId}) async {
    final data = albumId.split(',').map((s) => {'album_id': s}).toList();
    return client.post<LongaudioDetailResult>(
      '/openapi/v2/broadcast',
      body: {
        'data': data,
        'show_album_tag': 1,
        'fields': 'album_name,album_id,category,authors,sizable_cover,intro,author_name,trans_param,album_tag,mix_intro,full_intro,is_publish',
      },
      encryptType: EncryptType.android,
      headers: {'kg-tid': '78'},
      fromJson: (json) => LongaudioDetailResult.fromJson(json),
    );
  }

  /// 获取长音频专辑音频列表，[albumId] 为专辑 ID，[page] 为页码，[pagesize] 为每页数量
  Future<LongaudioAudiosResult> albumAudios({
    required String albumId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<LongaudioAudiosResult>(
      '/longaudio/v2/album_audios',
      body: {
        'album_id': albumId,
        'area_code': 1,
        'tagid': 0,
        'page': page,
        'pagesize': pagesize,
      },
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '78'},
      fromJson: (json) => LongaudioAudiosResult.fromJson(json),
    );
  }

  /// 获取长音频每日推荐，[page] 为页码，[pagesize] 为每页数量
  Future<LongaudioDailyResult> dailyRecommend({
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<LongaudioDailyResult>(
      '/longaudio/v1/home_new/daily_recommend',
      params: {
        'module_id': 1,
        'size': pagesize,
        'page': page,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => LongaudioDailyResult.fromJson(json),
    );
  }

  /// 获取长音频排行榜推荐
  Future<LongaudioRankResult> rankRecommend() async {
    return client.get<LongaudioRankResult>(
      '/longaudio/v1/home_new/rank_card_recommend',
      params: {'platform': 'ios'},
      encryptType: EncryptType.android,
      fromJson: (json) => LongaudioRankResult.fromJson(json),
    );
  }

  /// 获取长音频 VIP 精选推荐
  Future<LongaudioVipResult> vipRecommend() async {
    return client.post<LongaudioVipResult>(
      '/longaudio/v1/home_new/vip_select_recommend',
      body: {'album_playlist': []},
      params: {'position': '2', 'clientver': 12329},
      encryptType: EncryptType.android,
      fromJson: (json) => LongaudioVipResult.fromJson(json),
    );
  }

  /// 获取长音频每周新专辑推荐
  Future<LongaudioWeekResult> weekRecommend() async {
    return client.post<LongaudioWeekResult>(
      '/longaudio/v1/home_new/week_new_albums_recommend',
      body: {'album_playlist': []},
      params: {'clientver': 12329},
      encryptType: EncryptType.android,
      fromJson: (json) => LongaudioWeekResult.fromJson(json),
    );
  }
}
