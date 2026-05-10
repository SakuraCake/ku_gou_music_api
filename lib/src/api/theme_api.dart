import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/theme.dart';

/// 主题相关接口
class ThemeApi extends BaseApi {
  /// 构造主题 API 实例
  ThemeApi(super.client);

  /// 获取主题音乐推荐列表
  Future<ThemeMusicResult> music() async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return client.post<ThemeMusicResult>(
      '/everydayrec.service/v1/mul_theme_category_recommend',
      body: {
        'platform': 'android',
        'clienttime': clienttime,
        'userid': client.httpClient.userid ?? 0,
        'module_id': 508,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => ThemeMusicResult.fromJson(json),
    );
  }

  /// 获取主题音乐详情，[themeId] 为主题分类 ID
  Future<ThemeMusicDetailResult> musicDetail({required String themeId}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return client.post<ThemeMusicDetailResult>(
      '/everydayrec.service/v1/theme_category_recommend',
      body: {
        'platform': 'android',
        'clienttime': clienttime,
        'theme_category_id': themeId,
        'show_theme_category_id': 0,
        'userid': client.httpClient.userid ?? 0,
        'module_id': 508,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => ThemeMusicDetailResult.fromJson(json),
    );
  }

  /// 获取主题歌单列表
  Future<ThemePlaylistResult> playlist() async {
    final clienttime = DateTime.now().millisecondsSinceEpoch;
    return client.post<ThemePlaylistResult>(
      '/v2/getthemelist',
      body: {
        'platform': 'android',
        'clientver': client.httpClient.config.clientver,
        'clienttime': clienttime,
        'area_code': 1,
        'module_id': 1,
        'userid': client.httpClient.userid ?? 0,
      },
      router: 'everydayrec.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => ThemePlaylistResult.fromJson(json),
    );
  }

  /// 获取主题歌单歌曲列表，[themeId] 为主题 ID
  Future<ThemePlaylistTrackResult> playlistTrack({required String themeId}) async {
    final clienttime = DateTime.now().millisecondsSinceEpoch;
    return client.post<ThemePlaylistTrackResult>(
      '/v2/gettheme_songidlist',
      body: {
        'platform': 'android',
        'clientver': client.httpClient.config.clientver,
        'clienttime': clienttime,
        'area_code': 1,
        'module_id': 1,
        'userid': client.httpClient.userid ?? 0,
        'theme_id': themeId,
      },
      router: 'everydayrec.service.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => ThemePlaylistTrackResult.fromJson(json),
    );
  }
}
