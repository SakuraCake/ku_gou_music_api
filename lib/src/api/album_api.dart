import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../models/album.dart';

/// 专辑相关接口
class AlbumApi extends BaseApi {
  /// 构造专辑 API 实例
  AlbumApi(super.client);

  /// 获取专辑详情，[albumId] 为专辑 ID，多个以逗号分隔
  Future<AlbumDetailResult> detail({required String albumId, int isBuy = 0}) async {
    final data = albumId.split(',').map((s) => {'album_id': s}).toList();
    return client.post<AlbumDetailResult>(
      '/kmr/v2/albums',
      body: {
        'data': data,
        'is_buy': isBuy,
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

  Future<Map<String, dynamic>> oldDetail({
    required String albumId,
    String fields = '',
  }) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final data = albumId.split(',').map((s) => {
      'album_id': s,
      'album_name': '',
      'author_name': '',
    }).toList();
    final body = <String, dynamic>{
      'appid': client.httpClient.config.appid,
      'clienttime': dateTime,
      'clientver': client.httpClient.config.clientver,
      'data': data,
      'dfid': client.httpClient.dfid,
      'fields': fields,
      'key': signParamsKey(
        dateTime,
        appid: client.httpClient.config.appid,
        clientver: client.httpClient.config.clientver,
        isLite: client.httpClient.config.isLite,
      ),
      'mid': client.httpClient.mid,
    };
    if (client.httpClient.token != null) body['token'] = client.httpClient.token;
    if (client.httpClient.userid != null) body['userid'] = client.httpClient.userid;
    return client.post<Map<String, dynamic>>(
      '/v1/album',
      body: body,
      baseURL: 'http://kmr.service.kugou.com',
      router: 'kmr.service.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> songs({
    required int id,
    String isBuy = '',
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<Map<String, dynamic>>(
      '/v1/album_audio/lite',
      body: {
        'album_id': id,
        'is_buy': isBuy,
        'page': page,
        'pagesize': pagesize,
      },
      headers: {'kg-tid': '255'},
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> shop() async {
    return client.get<Map<String, dynamic>>(
      '/zhuanjidata/v3/album_shop_v2/get_classify_data',
      encryptType: EncryptType.android,
    );
  }
}
