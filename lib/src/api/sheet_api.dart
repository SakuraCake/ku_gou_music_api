import '../client/base_api.dart';
import '../client/http_client.dart';
import '../config/constants.dart';
import '../models/sheet.dart';

/// 乐谱相关接口
class SheetApi extends BaseApi {
  /// 构造乐谱 API 实例
  SheetApi(super.client);

  /// 获取乐谱广场合集列表
  Future<SheetCollectionResult> collection() async {
    return client.get<SheetCollectionResult>(
      '/miniyueku/v1/opern_square/get_home_module_config',
      params: {
        'srcappid': kSrcAppid,
        'position': 2,
      },
      encryptType: EncryptType.web,
      fromJson: (json) => SheetCollectionResult.fromJson(json),
    );
  }

  /// 获取乐谱合集详情，[collectionId] 为合集 ID，[page] 为页码，[pagesize] 为每页数量
  Future<SheetCollectionDetailResult> collectionDetail({
    required String collectionId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.get<SheetCollectionDetailResult>(
      '/miniyueku/v1/opern_square/collection_detail',
      params: {
        'srcappid': kSrcAppid,
        'collection_id': collectionId,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.web,
      fromJson: (json) => SheetCollectionDetailResult.fromJson(json),
    );
  }

  /// 获取乐谱详情，[id] 为乐谱 ID
  Future<SheetDetailResult> detail({required String id}) async {
    return client.get<SheetDetailResult>(
      '/v1/opern/detail',
      params: {
        'id': id,
        'from': 'opern_square',
      },
      baseURL: 'https://miniyueku.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => SheetDetailResult.fromJson(json),
    );
  }

  /// 获取热门乐谱列表
  Future<SheetHotResult> hot() async {
    return client.get<SheetHotResult>(
      '/miniyueku/v1/opern_square/get_home_hot_opern',
      params: {
        'srcappid': kSrcAppid,
        'opern_type': 1,
      },
      encryptType: EncryptType.web,
      fromJson: (json) => SheetHotResult.fromJson(json),
    );
  }

  /// 获取歌曲关联乐谱列表，[albumAudioId] 为专辑音频 ID，[opernType] 为乐谱类型，[page] 为页码
  Future<SheetListResult> list({
    required int albumAudioId,
    int opernType = 0,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.get<SheetListResult>(
      '/v1/opern/list',
      params: {
        'album_audio_id': albumAudioId,
        'opern_type': opernType,
        'page': page,
        'pagesize': pagesize,
      },
      baseURL: 'https://miniyueku.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => SheetListResult.fromJson(json),
    );
  }
}
