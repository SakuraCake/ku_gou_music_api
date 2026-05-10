import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/rank.dart';

/// 排行榜相关接口
class RankApi extends BaseApi {
  /// 构造排行榜 API 实例
  RankApi(super.client);

  /// 获取排行榜列表
  Future<RankListResult> list() async {
    return client.get<RankListResult>(
      '/ocean/v6/rank/list',
      params: {
        'plat': 2,
        'withsong': 1,
        'parentid': 0,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => RankListResult.fromJson(json),
    );
  }

  /// 获取排行榜详情，[rankId] 为排行榜 ID，[rankCid] 为排行榜分类 ID
  Future<RankInfoResult> info({
    required int rankId,
    int rankCid = 0,
  }) async {
    return client.get<RankInfoResult>(
      '/ocean/v6/rank/info',
      params: {
        'rankid': rankId,
        'rank_cid': rankCid,
        'with_album_img': 1,
        'zone': '',
      },
      encryptType: EncryptType.android,
      fromJson: (json) => RankInfoResult.fromJson(json),
    );
  }
}
