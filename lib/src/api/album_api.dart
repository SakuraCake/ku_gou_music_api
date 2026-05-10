import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../models/album.dart';

/// 专辑相关接口
class AlbumApi extends BaseApi {
  /// 构造专辑 API 实例
  AlbumApi(super.client);

  /// 获取专辑详情，[albumId] 为专辑 ID，多个以逗号分隔
  Future<AlbumDetailResult> detail({required String albumId}) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final data = albumId.split(',').map((s) => {'album_id': s, 'album_name': '', 'author_name': ''}).toList();
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    return client.post<AlbumDetailResult>(
      '/v1/album',
      body: {
        'appid': client.httpClient.config.appid,
        'clienttime': dateTime,
        'clientver': client.httpClient.config.clientver,
        'data': data,
        'dfid': client.httpClient.dfid,
        'fields': '',
        'key': key,
        'mid': client.httpClient.mid,
      },
      baseURL: 'http://kmr.service.kugou.com',
      router: 'kmr.service.kugou.com',
      encryptType: EncryptType.android,
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
