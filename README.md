# kugou_api

酷狗音乐 API 的 Dart 封装库，纯 Dart 实现，无 Flutter 依赖。

灵感来自 [MakcRe/KuGouMusicApi](https://github.com/MakcRe/KuGouMusicApi) Node.js 项目，将其核心功能移植为 Dart 原生包。

## 灵感来自

[MakcRe/KuGouMusicApi](https://github.com/MakcRe/KuGouMusicApi)

## 环境要求

需要 Dart SDK 3.11.4+ 环境

## 工作原理

伪造请求头，调用官方 API

## 免责声明

> 1. 本项目仅供学习使用，请尊重版权，请勿利用此项目从事商业行为及非法用途!
> 2. 使用本项目的过程中可能会产生版权数据。对于这些版权数据，本项目不拥有它们的所有权。为了避免侵权，使用者务必在 24 小时内清除使用本项目的过程中所产生的版权数据。
> 3. 由于使用本项目产生的包括由于本协议或由于使用或无法使用本项目而引起的任何性质的任何直接、间接、特殊、偶然或结果性损害（包括但不限于因商誉损失、停工、计算机故障或故障引起的损害赔偿，或任何及所有其他商业损害或损失）由使用者负责。
> 4. **禁止在违反当地法律法规的情况下使用本项目。** 对于使用者在明知或不知当地法律法规不允许的情况下使用本项目所造成的任何违法违规行为由使用者承担，本项目不承担由此造成的任何直接、间接、特殊、偶然或结果性责任。
> 5. 音乐平台不易，请尊重版权，支持正版。
> 6. 本项目仅用于对技术可行性的探索及研究，不接受任何商业（包括但不限于广告等）合作及捐赠。
> 7. 如果官方音乐平台觉得本项目不妥，可联系本项目更改或移除。

### 安装

```yaml
dependencies:
  kugou_api: ^0.0.1
```

或：

```shell
dart pub add kugou_api
```

### 使用接口为概念版

```dart
final api = KuGouApi(platform: Platform.lite);
// 注意不同版本的平台的 token 是不通用的
```

### 使用

```dart
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi();

  // 搜索歌曲
  final result = await api.search.songs(keyword: '周杰伦', page: 1, pageSize: 10);
  print(result);
}
```

### 代理配置

```dart
final api = KuGouApi(proxy: 'http://127.0.0.1:7890');
```

### 登录

```dart
// 密码登录
final loginResult = await api.login.byPassword(
  username: 'your_username',
  password: 'your_password',
);

// 验证码登录
final loginResult = await api.login.byCaptcha(phone: '13800138000', captcha: '1234');

// 二维码登录
await for (final state in api.login.qrCodeStream()) {
  if (state == QrCodeState.confirmed) break;
}
```

### Cookie 管理

内置 `CookieJar`，自动处理请求/响应 Cookie：

```dart
// 方式一：通过 initialCookies 传入初始 Cookie
final api = KuGouApi(initialCookies: {
  'kugou.com': 'token=abc123; userid=42',
});

// 方式二：通过 cookieJar 手动设置
api.cookieJar.set(domain: 'kugou.com', name: 'token', value: 'abc123');

// 读取 Cookie
final cookies = api.cookieJar.getCookiesForUrl('https://kugou.com/api');
```

### Cookie 持久化

`CookieJar` 提供了 `serialize()` / `loadFromMap()` 方法用于序列化，但**不内置文件持久化**——这是有意为之的设计，纯 Dart 包不应假设文件系统可用（如在浏览器端运行时）。用户可自行将序列化数据保存到文件/数据库：

```dart
import 'dart:io';
import 'dart:convert';

// 保存
final data = api.cookieJar.serialize();
await File('cookies.json').writeAsString(jsonEncode(data));

// 恢复
final json = jsonDecode(await File('cookies.json').readAsString()) as Map<String, dynamic>;
api.cookieJar.loadFromMap(json.map((k, v) => MapEntry(k, v as Map<String, dynamic>)));
```

### 自定义配置

```dart
final api = KuGouApi(
  platform: Platform.lite,
  proxy: 'http://127.0.0.1:7890',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 30),
  logLevel: LogLevel.debug,
  logCallback: (level, msg) => print('[$level] $msg'),
  cacheMaxSize: 200,
  cacheTtl: Duration(minutes: 5),
  retryOptions: RetryOptions(maxAttempts: 3),
  token: 'your_token',
  userid: 12345,
  dfid: 'your_dfid',
  mid: 'your_mid',
);
```

### 错误处理

```dart
try {
  final detail = await api.song.detail(hash: 'xxx');
} on KuGouApiException catch (e) {
  print('API 错误: status=${e.status}, code=${e.code}, message=${e.message}');
} on KuGouNetworkException catch (e) {
  print('网络错误: ${e.message}');
}
```

## 功能特性

### 搜索

- [x] 搜索歌曲 (`search.songs`)
- [x] 搜索歌单 (`search.playlists`)
- [x] 搜索专辑 (`search.albums`)
- [x] 搜索歌词 (`search.lyrics`)
- [x] 综合搜索 (`search.mixed`)
- [x] 热搜列表 (`search.hotDetail`)
- [x] 搜索建议 (`search.suggest`)
- [x] 默认搜索关键词 (`search.defaultWord`)
- [x] 综合搜索（已废弃）(`search.complex`)
- [ ] 搜索混合 (`search_mixed`)
- [ ] 歌词搜索 (`search_lyric`)

### 歌曲

- [x] 获取音乐 URL (`song.url`)
- [x] 获取音乐详情 (`song.detail`)
- [x] 歌曲排行 (`song.ranking`)
- [x] 歌曲高潮片段（已废弃）(`song.climax`)
- [x] 歌曲排行筛选（已废弃）(`song.rankingFilter`)
- [ ] 获取音乐 URL（新版）(`song_url_new`)

### 歌词

- [x] 歌词搜索 (`lyric.search`)
- [x] 获取歌词 (`lyric.get`)

### 登录

- [x] 密码登录 (`login.byPassword`)
- [x] 发送验证码 (`login.sendCaptcha`)
- [x] 验证码登录 (`login.byCaptcha`)
- [x] 二维码登录 (`login.qrCodeStream`)
- [ ] 手机号登录 (`login_cellphone`)
- [ ] 设备登录 (`login_device`)
- [ ] 设备踢出 (`login_device_kick`)
- [ ] 开放平台登录 (`login_openplat`)
- [ ] Token 登录 (`login_token`)
- [ ] 微信登录检查 (`login_wx_check`)
- [ ] 微信登录创建 (`login_wx_create`)

### 排行榜

- [x] 排行列表 (`rank.list`)
- [x] 排行信息 (`rank.info`)
- [ ] 排行音频 (`rank_audio`)
- [ ] 排行榜顶部 (`rank_top`)
- [ ] 排行榜往期 (`rank_vol`)

### 歌单

- [x] 获取歌单详情 (`playlist.detail`)
- [x] 获取歌单歌曲 (`playlist.tracks`)
- [x] 歌单分类 (`playlist.tags`)
- [x] 相似歌单 (`playlist.similar`)
- [x] 歌单列表 (`playlist.top`)
- [x] 收藏歌单/新建歌单 (`playlist.add`)
- [x] 对歌单添加歌曲 (`playlist.addTracks`)
- [x] 对歌单删除歌曲 (`playlist.removeTracks`)
- [x] 删除歌单 (`playlist.delete`)
- [ ] 歌单效果 (`playlist_effect`)
- [ ] 获取歌单所有歌曲 (`playlist_track_all`)
- [ ] 获取歌单所有歌曲（新版）(`playlist_track_all_new`)

### 专辑

- [x] 专辑详情 (`album.detail`)
- [x] 新碟上架 (`album.top`)
- [ ] 专辑音乐列表 (`album_songs`)
- [ ] 专辑商店 (`album_shop`)

### 歌手

- [x] 获取歌手详情 (`artist.detail`)
- [x] 获取歌手单曲 (`artist.audios`)
- [x] 获取歌手专辑 (`artist.albums`)
- [x] 获取歌手列表 (`artist.list`)
- [x] 关注歌手 (`artist.follow`)
- [x] 取消关注歌手 (`artist.unfollow`)
- [ ] 获取歌手 MV (`artist_videos`)
- [ ] 获取关注歌手新歌 (`artist_follow_newsongs`)
- [ ] 获取歌手荣誉 (`artist_honour`)

### 推荐

- [x] 每日推荐 (`recommend.everyday`)
- [x] AI 推荐 (`recommend.ai`)
- [x] 新歌速递 (`recommend.newSongs`)
- [ ] 每日推荐好友 (`everyday_friend`)
- [ ] 历史推荐 (`everyday_history`)
- [ ] 风格推荐 (`everyday_style_recommend`)

### 评论

- [x] 歌曲评论 (`comment.music`)
- [x] 评论数 (`comment.count`)
- [x] 楼层评论 (`comment.floor`)
- [x] 评论热词 (`comment.hotWord`)
- [x] 分类评论 (`comment.classify`)
- [x] 专辑评论 (`comment.album`)
- [x] 歌单评论 (`comment.playlist`)

### 用户

- [x] 获取用户详情 (`user.detail`)
- [x] 获取用户歌单 (`user.playlists`)
- [x] 获取用户听歌历史 (`user.history`)
- [x] 获取用户 VIP 信息 (`user.vipDetail`)
- [x] 收藏数 (`user.favoriteCount`)
- [x] 关注歌手 (`user.follow`)
- [x] 提交听歌历史 (`user.uploadHistory`)
- [x] 听歌时长上报 (`user.listenTimeAdd`)
- [ ] 用户关注消息 (`user_follow_message`)
- [ ] 用户听歌排行 (`user_listen`)
- [ ] 用户云盘 (`user_cloud`)
- [ ] 用户云盘 URL (`user_cloud_url`)
- [ ] 用户视频收藏 (`user_video_collect`)
- [ ] 用户视频喜欢 (`user_video_love`)

### FM

- [x] FM 分类 (`fm.classes`)
- [x] FM 歌曲 (`fm.songs`)
- [x] 私人 FM（已废弃）(`fm.personal`)
- [ ] FM 推荐 (`fm_recommend`)
- [ ] FM 图片 (`fm_image`)

### IP 专区

- [x] IP 内容列表 (`ip.content`)
- [x] IP 详情 (`ip.detail`)
- [x] IP 歌单 (`ip.playlist`)
- [x] IP 专区分类 (`ip.zone`)
- [x] IP 专区首页 (`ip.zoneHome`)

### 榜单卡片

- [x] 榜单卡片 (`top.card`)
- [x] 青年卡片 (`top.cardYouth`)
- [x] IP 榜单 (`top.ip`)
- [x] 榜单歌单 (`top.playlist`)
- [x] 榜单歌曲 (`top.song`)

### 图片

- [x] 获取歌手和专辑图片 (`images.albumImages`)
- [x] 获取歌手图片 (`images.audioImages`)

### 乐库

- [x] 乐库推荐 (`yueku.recommend`)
- [x] 乐库 Banner (`yueku.banner`)
- [x] 乐库 FM (`yueku.fm`)

### 长音频/有声书

- [x] 有声书专辑详情 (`longaudio.albumDetail`)
- [x] 有声书专辑音乐列表 (`longaudio.albumAudios`)
- [x] 每日推荐 (`longaudio.dailyRecommend`)
- [x] 排行推荐 (`longaudio.rankRecommend`)
- [x] VIP 推荐 (`longaudio.vipRecommend`)
- [x] 每周推荐 (`longaudio.weekRecommend`)

### 视频

- [x] 获取视频详情 (`video.detail`)
- [x] 获取视频权限 (`video.privilege`)
- [x] 获取视频 URL (`video.url`)
- [ ] 获取歌曲 MV (`kmr_audio_mv`)
- [ ] 获取音频 MV (`krm_audio`)

### 场景

- [x] 场景音乐列表 (`scene.lists`)
- [x] 场景音乐详情 V2（已废弃）(`scene.listsV2`)
- [x] 获取场景音乐模块 (`scene.module`)
- [x] 获取场景音乐模块信息 (`scene.moduleInfo`)
- [x] 获取场景音乐列表 (`scene.audioList`)
- [x] 获取场景音乐 (`scene.music`)
- [x] 获取场景歌单列表 (`scene.collectionList`)
- [x] 获取场景视频列表 (`scene.videoList`)

### 歌谱

- [x] 歌曲曲谱 (`sheet.collection`)
- [x] 曲谱合集详情 (`sheet.collectionDetail`)
- [x] 曲谱详情 (`sheet.detail`)
- [x] 推荐曲谱 (`sheet.hot`)
- [x] 曲谱列表 (`sheet.list`)

### 主题

- [x] 获取主题音乐 (`theme.music`)
- [x] 获取主题音乐详情 (`theme.musicDetail`)
- [x] 获取主题歌单 (`theme.playlist`)
- [x] 获取主题歌单歌曲 (`theme.playlistTrack`)

### 杂项

- [x] 获取歌手列表 (`misc.singerList`)
- [x] 新歌速递 (`misc.latestSongs`)
- [x] 获取服务器时间 (`misc.serverNow`)
- [x] 获取权限信息 (`misc.privilegeLite`)
- [x] 刷刷（已废弃）(`misc.brush`)
- [ ] 注册设备 (`register_dev`)
- [ ] 验证码发送 (`captcha_sent`)
- [ ] PC 电台 (`pc_diantai`)
- [ ] AI 推荐 (`ai_recommend`)

### 青少年频道

- [ ] 获取用户所有频道 (`youth_channel_all`)
- [ ] 频道安利 (`youth_channel_amway`)
- [ ] 频道详情 (`youth_channel_detail`)
- [ ] 相似频道 (`youth_channel_similar`)
- [ ] 频道订阅 (`youth_channel_sub`)
- [ ] 频道音乐故事 (`youth_channel_song`)
- [ ] 频道音乐故事详情 (`youth_channel_song_detail`)
- [ ] 领取 VIP (`youth_day_vip`)
- [ ] VIP 升级 (`youth_day_vip_upgrade`)
- [ ] 动态 (`youth_dynamic`)
- [ ] 动态最近 (`youth_dynamic_recent`)
- [ ] 听歌 (`youth_listen_song`)
- [ ] 月度 VIP 记录 (`youth_month_vip_record`)
- [ ] 联合 VIP (`youth_union_vip`)
- [ ] VIP (`youth_vip`)
- [ ] 用户歌曲 (`youth_user_song`)

### 音频扩展

- [ ] 伴奏匹配 (`audio_accompany_matching`)
- [ ] K 歌数量 (`audio_ktv_total`)
- [ ] 相关音频 (`audio_related`)

## 签名算法

本库内置三种酷狗 API 签名算法：

- **Android 签名** — 默认算法，使用 Android 客户端盐值
- **Web 签名** — Web 端算法，用于二维码登录等接口
- **Register 签名** — 注册专用算法

POST 请求签名会自动将请求体（JSON 编码）纳入签名计算。

## 已知限制

- 部分接口需要登录后才能使用（如 `IpApi.zoneHome`），可通过 `CookieJar` 传入初始 Cookie 或登录后自动获取
- 以下接口因服务端下线已标记 `@Deprecated`：
  - `SearchApi.complex` — 服务端返回 HTML
  - `SongApi.climax` — CDN 服务器拒绝请求
  - `SongApi.rankingFilter` — 参数错误
  - `FmApi.personal` — 服务端返回 HTML
  - `SceneApi.listsV2` — 服务端返回 HTML
  - `MiscApi.brush` — 服务端返回 HTML
- CookieJar 不内置文件持久化，需用户自行保存 `serialize()` 的输出

## License

[The MIT License (MIT)](LICENSE)
