import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/rank.dart';

/// 排行榜相关接口
class RankApi extends BaseApi {
  /// 构造排行榜 API 实例
  RankApi(super.client);

  /// 获取排行榜列表
  Future<RankListResult> list({int withSong = 1}) async {
    return client.get<RankListResult>(
      '/ocean/v6/rank/list',
      params: {
        'plat': 2,
        'withsong': withSong,
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
    int albumImg = 1,
  }) async {
    return client.get<RankInfoResult>(
      '/ocean/v6/rank/info',
      params: {
        'rankid': rankId,
        'rank_cid': rankCid,
        'with_album_img': albumImg,
        'zone': '',
      },
      encryptType: EncryptType.android,
      fromJson: (json) => RankInfoResult.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> audio({
    required int rankId,
    int rankCid = 0,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<Map<String, dynamic>>(
      '/openapi/kmr/v2/rank/audio',
      body: {
        'show_portrait_mv': 1,
        'show_type_total': 1,
        'filter_original_remarks': 1,
        'area_code': 1,
        'pagesize': pagesize,
        'rank_cid': rankCid,
        'type': 1,
        'page': page,
        'rank_id': rankId,
      },
      headers: {'kg-tid': '369'},
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> top() async {
    return client.get<Map<String, dynamic>>(
      '/mobileservice/api/v5/rank/rec_rank_list',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> vol({
    required int rankId,
    int rankCid = 0,
  }) async {
    return client.get<Map<String, dynamic>>(
      '/ocean/v6/rank/vol',
      params: {
        'rank_cid': rankCid,
        'rankid': rankId,
        'ranktype': 1,
        'type': 0,
        'plat': 2,
      },
      encryptType: EncryptType.android,
    );
  }
}
