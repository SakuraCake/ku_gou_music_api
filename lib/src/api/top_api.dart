import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../models/top.dart';

/// 首页顶部卡片推荐相关接口
class TopApi extends BaseApi {
  /// 构造顶部推荐 API 实例
  TopApi(super.client);

  /// 获取推荐卡片内容，[cardId] 为卡片 ID
  Future<TopCardResult> card({int cardId = 1}) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<TopCardResult>(
      '/singlecardrec.service/v1/single_card_recommend',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'platform': 'android',
        'clienttime': dateTime,
        'userid': client.httpClient.userid ?? 0,
        'key': key,
        'fakem': '60f7ebf1f812edbac3c63a7310001701760f',
        'area_code': 1,
        'mid': client.httpClient.mid,
        'uuid': '-',
        'client_playlist': [],
        'u_info': 'a0c35cd40af564444b5584c2754dedec',
      },
      params: {
        'card_id': cardId,
        'fakem': '60f7ebf1f812edbac3c63a7310001701760f',
        'area_code': 1,
        'platform': 'ios',
      },
      encryptType: EncryptType.android,
      fromJson: (json) => TopCardResult.fromJson(json),
    );
  }

  /// 获取青春版推荐卡片内容，[cardId] 为卡片 ID，[pagesize] 为每页数量
  Future<TopCardYouthResult> cardYouth({int cardId = 3005, int pagesize = 30, String? tagId}) async {
    return client.post<TopCardYouthResult>(
      '/youth/v1/song/single_card_recommend',
      body: {
        'tagid': tagId ?? '',
        'u_info': '',
        'source_mixsong': '',
      },
      params: {
        'card_id': cardId,
        'area_code': 1,
        'platform': 'ops',
        'module_id': 1,
        'ver': 'v2',
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => TopCardYouthResult.fromJson(json),
    );
  }

  /// 获取每日推荐 IP 内容
  Future<TopIpResult> ip() async {
    return client.post<TopIpResult>(
      '/v1/daily_recommend',
      body: {
        'tags': {},
      },
      params: {
        'clientver': 12349,
        'area_code': 1,
      },
      baseURL: 'http://musicadservice.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => TopIpResult.fromJson(json),
    );
  }
}
