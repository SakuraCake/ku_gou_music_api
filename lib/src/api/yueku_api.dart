import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/yueku.dart';

/// 乐库相关接口
class YuekuApi extends BaseApi {
  /// 构造乐库 API 实例
  YuekuApi(super.client);

  /// 获取乐库推荐内容
  Future<YuekuRecommendResult> recommend() async {
    return client.get<YuekuRecommendResult>(
      '/v1/yueku/recommend_v2',
      params: {
        'operator': 7,
        'plat': 0,
        'type': 11,
        'area_code': 1,
        'req_multi': 1,
      },
      router: 'service.mobile.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => YuekuRecommendResult.fromJson(json),
    );
  }

  /// 获取乐库 Banner 轮播图
  Future<YuekuBannerResult> banner() async {
    return client.post<YuekuBannerResult>(
      '/ads.gateway/v3/listen_banner',
      body: {
        'plat': 0,
        'channel': 201,
        'operator': 7,
        'networktype': 2,
        'userid': client.httpClient.userid ?? 0,
        'vip_type': 0,
        'm_type': 0,
        'tags': [],
        'apiver': 5,
        'ability': 2,
        'mode': 'normal',
      },
      encryptType: EncryptType.android,
      fromJson: (json) => YuekuBannerResult.fromJson(json),
    );
  }

  /// 获取乐库电台信息
  Future<YuekuFmResult> fm() async {
    return client.get<YuekuFmResult>(
      '/v1/time_fm_info',
      params: {
        'operator': 7,
        'plat': 0,
        'type': 11,
        'area_code': 1,
        'req_multi': 1,
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => YuekuFmResult.fromJson(json),
    );
  }
}
