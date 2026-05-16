import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/album.dart';

/// 专辑相关接口
class AlbumApi extends BaseApi {
  /// 构造专辑 API 实例
  AlbumApi(super.client);

  /// 获取专辑详情，[albumId] 为专辑 ID，多个以逗号分隔
  Future<AlbumDetailResult> detail({required String albumId}) async {
    final data = albumId.split(',').map((s) => {'album_id': s}).toList();
    return client.post<AlbumDetailResult>(
      '/kmr/v2/albums',
      body: {
        'data': data,
        'is_buy': 0,
        'fields': 'album_id,album_name,publish_date,sizable_cover,intro,language,is_publish,heat,type,quality,authors,exclusive,author_name,trans_param',
      },
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '255'},
      fromJson: (json) {
        final data = json['data'];
        if (data is List) {
          return AlbumDetailResult(
            list: data.whereType<Map<String, dynamic>>().map((e) => AlbumInfo.fromJson(e)).toList(),
          );
        }
        return AlbumDetailResult.fromJson(json);
      },
    );
  }

  /// 获取新专辑上架列表，[page] 为页码，[pageSize] 为每页数量
  Future<TopAlbumResult> top({
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.post<TopAlbumResult>(
      '/musicadservice/v1/mobile_newalbum_sp',
      body: {
        'apiver': client.httpClient.config.clientver,
        'page': page,
        'pagesize': pageSize,
        'withpriv': 1,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => TopAlbumResult.fromJson(json),
    );
  }
}
