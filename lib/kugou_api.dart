/// 酷狗音乐 API 的 Dart 封装库，纯 Dart 实现，无 Flutter 依赖。
///
/// 灵感来自 [MakcRe/KuGouMusicApi](https://github.com/MakcRe/KuGouMusicApi) Node.js 项目。
///
/// 提供 22 个 API 模块、约 105 个接口方法，涵盖搜索、歌曲、歌词、登录、
/// 排行榜、歌单、专辑、歌手、推荐、评论、用户、FM、IP 专区、榜单卡片、
/// 图片、乐库、长音频、视频、场景、歌谱、主题、杂项等。
///
/// 内置 Cookie 管理（[CookieJar]）、签名算法（Android/Web/Register）、
/// 重试机制、内存缓存和日志系统。
///
/// ## 快速开始
///
/// ```dart
/// final api = KuGouApi();
/// final result = await api.search.songs(keyword: '周杰伦');
/// ```
///
/// ## TODO — 并非所有工作都已完成
///
/// 参考项目共有约 156 个接口模块，当前已实现约 105 个 API 方法。
/// 完整的 API 列表及实现状况请参阅 README.md。
///
/// 未实现的部分包括：青少年频道系列、云盘、登录扩展、排行榜扩展、
/// 歌单全量曲目、歌手 MV/荣誉、用户云盘/视频收藏、搜索混合/歌词搜索等。
///
/// 以下 6 个接口因服务端下线已标记 `@Deprecated`：
/// `SearchApi.complex`、`SongApi.climax`、`SongApi.rankingFilter`、
/// `FmApi.personal`、`SceneApi.listsV2`、`MiscApi.brush`。
///
/// CookieJar 不内置文件持久化，需用户自行保存 `serialize()` 的输出。
library;

export 'src/client/kugou_api.dart';
export 'src/client/http_client.dart';
export 'src/client/api_client.dart';
export 'src/client/base_api.dart';
export 'src/config.dart';
export 'src/config/constants.dart';
export 'src/exception.dart';
export 'src/crypto.dart';
export 'src/models.dart';
export 'src/util.dart';
export 'src/api/search_api.dart';
export 'src/api/song_api.dart';
export 'src/api/lyric_api.dart';
export 'src/api/login_api.dart';
export 'src/api/rank_api.dart';
export 'src/api/playlist_api.dart';
export 'src/api/album_api.dart';
export 'src/api/artist_api.dart';
export 'src/api/recommend_api.dart';
export 'src/api/comment_api.dart';
export 'src/api/user_api.dart';
export 'src/api/fm_api.dart';
export 'src/api/ip_api.dart';
export 'src/api/top_api.dart';
export 'src/api/images_api.dart';
export 'src/api/yueku_api.dart';
export 'src/api/longaudio_api.dart';
export 'src/api/video_api.dart';
export 'src/api/scene_api.dart';
export 'src/api/sheet_api.dart';
export 'src/api/theme_api.dart';
export 'src/api/misc_api.dart';
