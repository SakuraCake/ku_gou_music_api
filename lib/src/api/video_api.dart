import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/md5.dart';
import '../crypto/signature.dart';
import '../models/video.dart';

/// 视频相关接口
class VideoApi extends BaseApi {
  /// 构造视频 API 实例
  VideoApi(super.client);

  /// 获取视频详情，[videoId] 为视频 ID，多个以逗号分隔
  Future<VideoDetailResult> detail({required String videoId}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final key = signParams(
      clienttime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    final uuid = cryptoMd5('${client.httpClient.dfid}${client.httpClient.mid}');
    return client.post<VideoDetailResult>(
      '/v1/video',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'clienttime': clienttime,
        'mid': client.httpClient.mid,
        'uuid': uuid,
        'dfid': client.httpClient.dfid,
        'token': client.httpClient.token ?? '',
        'key': key,
        'show_resolution': 1,
        'data': videoId.split(',').map((s) => {'video_id': s}).toList(),
      },
      router: 'kmr.service.kugou.com',
      encryptType: EncryptType.android,
      clearDefaultParams: true,
      fromJson: (json) => VideoDetailResult.fromJson(json),
    );
  }

  /// 获取视频权限信息，[videoId] 为视频 ID，[hash] 为资源哈希值，需要登录
  Future<VideoPrivilegeResult> privilege({
    required String videoId,
    String hash = '',
  }) async {
    return client.post<VideoPrivilegeResult>(
      '/v1/get_video_privilege',
      body: {
        'appid': client.httpClient.config.appid,
        'area_code': 1,
        'behavior': 'play',
        'clientver': client.httpClient.config.clientver,
        'dfid': client.httpClient.dfid,
        'mid': client.httpClient.mid,
        'resource': hash.split(',').map((s) => {'hash': s, 'id': 0, 'name': ''}).toList(),
        'token': client.httpClient.token ?? '',
        'userid': client.httpClient.userid ?? 0,
        'vip': 0,
      },
      router: 'media.store.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => VideoPrivilegeResult.fromJson(json),
    );
  }

  /// 获取视频播放地址，[hash] 为视频哈希值
  Future<VideoUrlResult> url({required String hash}) async {
    return client.get<VideoUrlResult>(
      '/v2/interface/index',
      params: {
        'backupdomain': 1,
        'cmd': 123,
        'ext': 'mp4',
        'ismp3': 0,
        'hash': hash,
        'pid': 1,
        'type': 1,
      },
      router: 'trackermv.kugou.com',
      encryptType: EncryptType.android,
      encryptKey: true,
      fromJson: (json) => VideoUrlResult.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> audioMv({
    required String albumAudioId,
    String fields = '',
  }) async {
    final data = albumAudioId.split(',').map((s) => {'album_audio_id': s}).toList();
    return client.post<Map<String, dynamic>>(
      '/kmr/v1/audio/mv',
      body: {
        'data': data,
        'fields': fields,
      },
      router: 'openapi.kugou.com',
      headers: {'kg-tid': '38'},
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> audioDetail({
    required String albumAudioId,
    String fields = 'base',
  }) async {
    final data = albumAudioId.split(',').map((s) => {'entity_id': int.parse(s)}).toList();
    return client.post<Map<String, dynamic>>(
      '/kmr/v2/audio',
      body: {
        'data': data,
        'fields': fields,
      },
      router: 'openapi.kugou.com',
      headers: {'kg-tid': '238'},
      encryptType: EncryptType.android,
    );
  }
}
