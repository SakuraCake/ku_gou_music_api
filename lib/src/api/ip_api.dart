import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/ip.dart';

/// IP 专区相关接口
class IpApi extends BaseApi {
  /// 构造 IP 专区 API 实例
  IpApi(super.client);

  /// 获取 IP 专区内容列表，[id] 为 IP ID，[type] 为内容类型（audios/albums/videos/author_list），[page] 为页码
  Future<IpContentResult> content({
    required String id,
    String type = 'audios',
    int page = 1,
    int pagesize = 30,
  }) async {
    final validType = ['audios', 'albums', 'videos', 'author_list'].contains(type) ? type : 'audios';
    return client.post<IpContentResult>(
      '/openapi/v1/ip/$validType',
      body: {
        'is_publish': 1,
        'ip_id': id,
        'sort': 3,
        'page': page,
        'pagesize': pagesize,
        'query': 1,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => IpContentResult.fromJson(json),
    );
  }

  /// 获取 IP 专区详情，[id] 为 IP ID，多个以逗号分隔
  Future<IpDetailResult> detail({required String id}) async {
    final data = id.split(',').map((s) => {'ip_id': s}).toList();
    return client.post<IpDetailResult>(
      '/openapi/v1/ip',
      body: {
        'data': data,
        'is_publish': 1,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => IpDetailResult.fromJson(json),
    );
  }

  /// 获取 IP 专区关联歌单，[id] 为 IP ID，[page] 为页码，[pagesize] 为每页数量
  Future<IpPlaylistResult> playlist({
    required String id,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<IpPlaylistResult>(
      '/ocean/v6/pubsongs/list_info_for_ip',
      params: {
        'ip': id,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => IpPlaylistResult.fromJson(json),
    );
  }

  /// 获取 IP 专区分类
  Future<IpZoneResult> zone() async {
    return client.get<IpZoneResult>(
      '/v1/zone/index',
      router: 'yuekucategory.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => IpZoneResult.fromJson(json),
    );
  }

  /// 获取 IP 专区首页，[id] 为专区 ID
  Future<IpZoneHomeResult> zoneHome({required String id}) async {
    return client.get<IpZoneHomeResult>(
      '/v1/zone/home',
      params: {
        'id': id,
        'share': 0,
      },
      router: 'yuekucategory.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => IpZoneHomeResult.fromJson(json),
    );
  }
}
