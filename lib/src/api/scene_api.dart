import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/scene.dart';

/// 场景相关接口
class SceneApi extends BaseApi {
  /// 构造场景 API 实例
  SceneApi(super.client);

  /// 获取场景列表
  Future<SceneListResult> lists() async {
    return client.get<SceneListResult>(
      '/scene/v1/scene/list',
      encryptType: EncryptType.android,
      fromJson: (json) => SceneListResult.fromJson(json),
    );
  }

  /// 获取场景列表 V2（已废弃），API 已下线，服务端返回 HTML，暂不可用
  @Deprecated('API 已下线，服务端返回 HTML，暂不可用')
  Future<SceneListResult> listsV2({
    int? sceneId,
    String sort = 'rec',
    int page = 1,
    int pagesize = 30,
  }) async {
    final sortType = {'rec': 1, 'hot': 2, 'new': 3};
    final params = <String, dynamic>{
      'page': page,
      'pagesize': pagesize,
      'sort_type': sortType[sort] ?? 1,
      'kugouid': client.httpClient.userid ?? 0,
    };
    if (sceneId != null) params['scene_id'] = sceneId;
    return client.post<SceneListResult>(
      '/scene/v1/scene/list_v2',
      params: params,
      body: {'exposure': []},
      encryptType: EncryptType.android,
      fromJson: (json) => SceneListResult.fromJson(json),
    );
  }

  /// 获取场景模块列表，[sceneId] 为场景 ID
  Future<SceneModuleResult> module({required int sceneId}) async {
    return client.post<SceneModuleResult>(
      '/scene/v1/scene/module',
      params: {'scene_id': sceneId},
      encryptType: EncryptType.android,
      fromJson: (json) => SceneModuleResult.fromJson(json),
    );
  }

  /// 获取场景模块详情，[sceneId] 为场景 ID，[moduleId] 为模块 ID
  Future<SceneModuleInfoResult> moduleInfo({
    required int sceneId,
    required int moduleId,
  }) async {
    return client.get<SceneModuleInfoResult>(
      '/scene/v1/scene/module_info',
      params: {
        'scene_id': sceneId,
        'module_id': moduleId,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SceneModuleInfoResult.fromJson(json),
    );
  }

  /// 获取场景音频列表，[sceneId] 为场景 ID，[page] 为页码，[pagesize] 为每页数量
  Future<SceneAudioListResult> audioList({
    required int sceneId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<SceneAudioListResult>(
      '/scene/v1/scene/audio_list',
      params: {
        'scene_id': sceneId,
        'page': page,
        'page_size': pagesize,
      },
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'token': client.httpClient.token ?? '',
        'userid': client.httpClient.userid ?? 0,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SceneAudioListResult.fromJson(json),
    );
  }

  /// 获取场景推荐音乐，[sceneId] 为场景 ID，[page] 为页码，[pagesize] 为每页数量
  Future<SceneMusicResult> music({
    required int sceneId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<SceneMusicResult>(
      '/genesisapi/v1/scene_music/rec_music',
      params: {
        'scene_id': sceneId,
        'page': page,
        'pagesize': pagesize,
      },
      body: {'exposure': []},
      encryptType: EncryptType.android,
      fromJson: (json) => SceneMusicResult.fromJson(json),
    );
  }

  /// 获取场景歌单集合列表，[tagId] 为标签 ID，[page] 为页码，[pagesize] 为每页数量
  Future<SceneCollectionListResult> collectionList({
    required int tagId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<SceneCollectionListResult>(
      '/scene/v1/distribution/collection_list',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'token': client.httpClient.token ?? '',
        'userid': client.httpClient.userid ?? 0,
        'tag_id': tagId,
        'page': page,
        'page_size': pagesize,
        'exposed_data': [],
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SceneCollectionListResult.fromJson(json),
    );
  }

  /// 获取场景视频列表，[tagId] 为标签 ID，[page] 为页码，[pagesize] 为每页数量
  Future<SceneVideoListResult> videoList({
    required int tagId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<SceneVideoListResult>(
      '/scene/v1/distribution/video_list',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'token': client.httpClient.token ?? '',
        'userid': client.httpClient.userid ?? 0,
        'tag_id': tagId,
        'page': page,
        'page_size': pagesize,
        'exposed_data': [],
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SceneVideoListResult.fromJson(json),
    );
  }
}
