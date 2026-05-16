import 'dart:async';
import 'http_client.dart';
import 'api_client.dart';
import '../api/search_api.dart';
import '../api/song_api.dart';
import '../api/lyric_api.dart';
import '../api/login_api.dart';
import '../api/rank_api.dart';
import '../api/playlist_api.dart';
import '../api/album_api.dart';
import '../api/artist_api.dart';
import '../api/recommend_api.dart';
import '../api/comment_api.dart';
import '../api/user_api.dart';
import '../api/fm_api.dart';
import '../api/ip_api.dart';
import '../api/top_api.dart';
import '../api/images_api.dart';
import '../api/yueku_api.dart';
import '../api/longaudio_api.dart';
import '../api/video_api.dart';
import '../api/scene_api.dart';
import '../api/sheet_api.dart';
import '../api/theme_api.dart';
import '../api/misc_api.dart';
import '../config.dart';
import '../util/logger.dart';
import '../util/cache.dart';
import '../util/cookie_jar.dart';
import '../util/retry.dart';
import '../models/user.dart';

/// 酷狗音乐 API 主入口类。
///
/// 通过工厂构造函数创建实例，内部自动组装配置、HTTP 客户端和 API 客户端，
/// 并提供各业务模块的 API 访问入口。
class KuGouApi {
  /// 酷狗配置信息。
  final KuGouConfig config;

  /// HTTP 客户端实例。
  final KuGouHttpClient httpClient;

  /// API 客户端实例。
  final ApiClient client;

  /// 搜索接口。
  late final SearchApi search;

  /// 歌曲接口。
  late final SongApi song;

  /// 歌词接口。
  late final LyricApi lyric;

  /// 登录接口。
  late final LoginApi login;

  /// 排行榜接口。
  late final RankApi rank;

  /// 歌单接口。
  late final PlaylistApi playlist;

  /// 专辑接口。
  late final AlbumApi album;

  /// 歌手接口。
  late final ArtistApi artist;

  /// 推荐接口。
  late final RecommendApi recommend;

  /// 评论接口。
  late final CommentApi comment;

  /// 用户接口。
  late final UserApi user;

  /// 私人 FM 接口。
  late final FmApi fm;

  /// IP 信息接口。
  late final IpApi ip;

  /// 榜单接口。
  late final TopApi top;

  /// 图片接口。
  late final ImagesApi images;

  /// 乐库接口。
  late final YuekuApi yueku;

  /// 长音频接口。
  late final LongaudioApi longaudio;

  /// 视频接口。
  late final VideoApi video;

  /// 场景接口。
  late final SceneApi scene;

  /// 歌谱接口。
  late final SheetApi sheet;

  /// 主题接口。
  late final ThemeApi theme;

  /// 杂项接口。
  late final MiscApi misc;

  /// Cookie 管理器，可读取或手动设置 Cookie。
  CookieJar get cookieJar => httpClient.cookieJar;

  KuGouApi._({
    required this.config,
    required this.httpClient,
    required this.client,
  }) {
    search = SearchApi(client);
    song = SongApi(client);
    lyric = LyricApi(client);
    login = LoginApi(client);
    rank = RankApi(client);
    playlist = PlaylistApi(client);
    album = AlbumApi(client);
    artist = ArtistApi(client);
    recommend = RecommendApi(client);
    comment = CommentApi(client);
    user = UserApi(client);
    fm = FmApi(client);
    ip = IpApi(client);
    top = TopApi(client);
    images = ImagesApi(client);
    yueku = YuekuApi(client);
    longaudio = LongaudioApi(client);
    video = VideoApi(client);
    scene = SceneApi(client);
    sheet = SheetApi(client);
    theme = ThemeApi(client);
    misc = MiscApi(client);
  }

  Timer? _refreshTimer;

  /// 启用自动刷新登录功能。
  ///
  /// [interval] 指定刷新间隔时间，默认值为 24 小时。
  /// [onRefresh] 刷新成功时的回调函数，参数为 [LoginResult]。
  /// [onError] 刷新失败时的回调函数，参数为错误对象。
  ///
  /// 自动刷新会定期调用 [LoginApi.refreshToken] 来保持登录状态。
  /// 需要先设置有效的 token 和 userid。
  ///
  /// ```dart
  /// final api = KuGouApi(token: 'your_token', userid: 12345);
  ///
  /// api.enableAutoRefresh(
  ///   interval: Duration(hours: 12),
  ///   onRefresh: (result) {
  ///     print('Token refreshed successfully');
  ///   },
  ///   onError: (e) {
  ///     print('Refresh failed: $e');
  ///   },
  /// );
  /// ```
  void enableAutoRefresh({
    Duration interval = const Duration(hours: 24),
    void Function(LoginResult)? onRefresh,
    void Function(Object)? onError,
  }) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) async {
      try {
        final result = await login.refreshToken();
        if (onRefresh != null) {
          onRefresh(result);
        }
      } catch (e) {
        if (onError != null) {
          onError(e);
        }
      }
    });
  }

  /// 禁用自动刷新登录功能。
  ///
  /// 停止定时刷新任务，释放相关资源。
  void disableAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// 确保用户已登录。
  ///
  /// 如果已设置 token，则调用 [LoginApi.refreshToken] 刷新登录状态。
  /// 如果未设置 token，返回失败的 [LoginResult]。
  ///
  /// 返回 [LoginResult]，包含刷新是否成功的信息。
  Future<LoginResult> ensureLoggedIn() async {
    if (httpClient.token != null && httpClient.token!.isNotEmpty) {
      return login.refreshToken();
    }
    return LoginResult(success: false, message: '请先登录');
  }

  /// 释放资源。
  ///
  /// 停止自动刷新定时器，关闭 HTTP 客户端连接。
  /// 调用此方法后，不再应使用此实例。
  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    httpClient.close();
  }

  /// 创建 [KuGouApi] 实例的工厂构造函数。
  ///
  /// [platform] 选择标准版或轻量版平台，[proxy] 设置 HTTP 代理地址，
  /// [connectTimeout] 和 [receiveTimeout] 设置连接与接收超时时间，
  /// [logLevel] 和 [logCallback] 控制日志输出，
  /// [cacheMaxSize] 和 [cacheTtl] 控制缓存容量与过期时间，
  /// [retryOptions] 配置重试策略，
  /// [token]、[userid]、[dfid]、[mid] 为用户认证与设备标识参数，
  /// [appid]、[clientver]、[baseUrl]、[userAgent] 可覆盖默认配置，
  /// [cookieJar] 可传入自定义 Cookie 管理器（含初始 Cookie），
  /// [initialCookies] 可传入初始 Cookie 映射（键为域名，值为 Cookie 字符串）。
  factory KuGouApi({
    Platform platform = Platform.standard,
    String? proxy,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    LogLevel logLevel = LogLevel.none,
    LogCallback? logCallback,
    int cacheMaxSize = 100,
    Duration? cacheTtl,
    RetryOptions retryOptions = const RetryOptions(),
    String? token,
    int? userid,
    String? dfid,
    String? mid,
    int? appid,
    int? clientver,
    String? baseUrl,
    String? userAgent,
    CookieJar? cookieJar,
    Map<String, String>? initialCookies,
  }) {
    final config = KuGouConfig(
      platform: platform,
      appid: appid,
      clientver: clientver,
      baseUrl: baseUrl,
      userAgent: userAgent,
    );
    final effectiveCookieJar = cookieJar ??
        (initialCookies != null ? CookieJar(initialCookies: initialCookies) : null);
    final httpClient = KuGouHttpClient(
      config: config,
      proxy: proxy,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      token: token,
      userid: userid,
      dfid: dfid,
      mid: mid,
      cookieJar: effectiveCookieJar,
    );
    final client = ApiClient(
      httpClient: httpClient,
      logger: Logger(minLevel: logLevel, callback: logCallback),
      cache: MemoryCache(maxSize: cacheMaxSize),
      retryOptions: retryOptions,
      cacheTtl: cacheTtl,
    );
    return KuGouApi._(config: config, httpClient: httpClient, client: client);
  }
}
