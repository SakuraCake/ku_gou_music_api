**English** | [中文](README_CN.md)

# kugou_api

A comprehensive Dart package for KuGou Music API with full API coverage, authentication, caching, and more.

Inspired by [MakcRe/KuGouMusicApi](https://github.com/MakcRe/KuGouMusicApi) Node.js project, ported to native Dart.

## Requirements

- Dart SDK ^3.11.4

## Installation

```yaml
dependencies:
  kugou_api: ^0.1.0
```

Or:

```shell
dart pub add kugou_api
```

## Quick Start

### Basic Usage

```dart
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi();

  // Search songs
  final result = await api.search.songs(keyword: 'Jay Chou', page: 1, pageSize: 10);
  print(result);
}
```

### Use Lite Platform

```dart
final api = KuGouApi(platform: Platform.lite);
// Note: Tokens are not interchangeable between different platforms
```

### Proxy Configuration

```dart
final api = KuGouApi(proxy: 'http://127.0.0.1:7890');
```

## Authentication

### Password Login

```dart
final loginResult = await api.login.byPassword(
  username: 'your_username',
  password: 'your_password',
);
```

### Captcha Login

```dart
final result = await api.login.sendCaptcha(phone: '13800138000');
if (result.success) {
  final loginResult = await api.login.byCaptcha(phone: '13800138000', captcha: '1234');
}
```

### QR Code Login

```dart
await for (final state in api.login.qrCodeStream()) {
  if (state == QrCodeState.confirmed) break;
}
```

## Auto Refresh Login

```dart
// Initialize with existing token
final api = KuGouApi(token: 'your_token', userid: 12345);

// Enable auto refresh (default: every 24 hours)
api.enableAutoRefresh(
  interval: Duration(hours: 24),
  onRefresh: (result) {
    print('Token refreshed: ${result.token}');
  },
  onError: (e) {
    print('Refresh failed: $e');
  },
);

// Ensure logged in
final result = await api.ensureLoggedIn();

// Disable auto refresh
api.disableAutoRefresh();

// Cleanup resources
api.dispose();
```

## Cookie Management

Built-in `CookieJar` for automatic cookie handling:

```dart
// Option 1: Pass initial cookies
final api = KuGouApi(initialCookies: {
  'kugou.com': 'token=abc123; userid=42',
});

// Option 2: Set cookies manually
api.cookieJar.set(domain: 'kugou.com', name: 'token', value: 'abc123');

// Read cookies
final cookies = api.cookieJar.getCookiesForUrl('https://kugou.com/api');
```

### Cookie Persistence

`CookieJar` provides `serialize()` / `loadFromMap()` methods for serialization. Users should handle persistence themselves:

```dart
import 'dart:io';
import 'dart:convert';

// Save
final data = api.cookieJar.serialize();
await File('cookies.json').writeAsString(jsonEncode(data));

// Restore
final json = jsonDecode(await File('cookies.json').readAsString()) as Map<String, dynamic>;
api.cookieJar.loadFromMap(json.map((k, v) => MapEntry(k, v as Map<String, dynamic>)));
```

## Custom Configuration

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

## Error Handling

```dart
try {
  final detail = await api.song.detail(hash: 'xxx');
} on KuGouApiException catch (e) {
  print('API error: status=${e.status}, code=${e.code}, message=${e.message}');
} on KuGouNetworkException catch (e) {
  print('Network error: ${e.message}');
}
```

## Features

### Search

- [x] Search songs (`search.songs`)
- [x] Search playlists (`search.playlists`)
- [x] Search albums (`search.albums`)
- [x] Search lyrics (`search.lyrics`)
- [x] Mixed search (`search.mixed`)
- [x] Mixed search v2 (`search.mixedSearch`)
- [x] Hot search list (`search.hotDetail`)
- [x] Hot search tabs (`search.hotTab`)
- [x] Search suggestions (`search.suggest`)
- [x] Search suggestions v2 (`search.suggestV2`)
- [x] Default search keyword (`search.defaultWord`)
- [x] Complex search (`search.complex`)
- [ ] Lyric search (`search_lyric`)

### Song

- [x] Get song URL (`song.url`)
- [x] Get song detail (`song.detail`)
- [x] Song ranking (`song.ranking`)
- [x] Song climax (`song.climax`)
- [x] Song ranking filter (`song.rankingFilter`)
- [ ] Get song URL (new) (`song_url_new`)

### Lyric

- [x] Lyric search (`lyric.search`)
- [x] Get lyrics (`lyric.get`)

### Login

- [x] Password login (`login.byPassword`)
- [x] Send captcha (`login.sendCaptcha`)
- [x] Captcha login (`login.byCaptcha`)
- [x] QR code login (`login.qrCodeStream`)
- [x] Device login (`login.deviceLogin`)
- [x] Device kick (`login.deviceKick`)
- [x] Open platform login (`login.openplatLogin`)
- [ ] Token login (`login_token`)
- [x] WeChat login create (`login.wxCreate`)
- [x] WeChat login check (`login.wxCheck`)

### Ranking

- [x] Ranking list (`rank.list`)
- [x] Ranking info (`rank.info`)
- [x] Ranking audio (`rank.audio`)
- [x] Ranking top (`rank.top`)
- [x] Ranking history (`rank.vol`)

### Playlist

- [x] Get playlist detail (`playlist.detail`)
- [x] Get playlist tracks (`playlist.tracks`)
- [x] Playlist categories (`playlist.tags`)
- [x] Similar playlists (`playlist.similar`)
- [x] Playlist list (`playlist.top`)
- [x] Favorite/Create playlist (`playlist.add`)
- [x] Add tracks to playlist (`playlist.addTracks`)
- [x] Remove tracks from playlist (`playlist.removeTracks`)
- [x] Delete playlist (`playlist.delete`)
- [x] Playlist effect (`playlist.effect`)
- [ ] Get all playlist tracks (`playlist_track_all`)
- [x] Get all playlist tracks new (`playlist.trackAllNew`)

### Album

- [x] Album detail (`album.detail`)
- [x] Album old detail (`album.oldDetail`)
- [x] New albums (`album.top`)
- [x] Album songs (`album.songs`)
- [x] Album shop (`album.shop`)

### Artist

- [x] Get artist detail (`artist.detail`)
- [x] Get artist songs (`artist.audios`)
- [x] Get artist albums (`artist.albums`)
- [x] Get artist list (`artist.list`)
- [x] Follow artist (`artist.follow`)
- [x] Unfollow artist (`artist.unfollow`)
- [x] Get artist MVs (`artist.videos`)
- [x] Get followed artist new songs (`artist.followNewSongs`)
- [x] Get artist honors (`artist.honour`)

### Recommend

- [x] Daily recommend (`recommend.everyday`)
- [x] AI recommend (`recommend.ai`)
- [x] New songs (`recommend.newSongs`)
- [x] Daily recommend friends (`recommend.everydayFriend`)
- [x] History recommend (`recommend.everydayHistory`)
- [x] Style recommend (`recommend.everydayStyleRecommend`)

### Comment

- [x] Song comments (`comment.music`)
- [x] Comment count (`comment.count`)
- [x] Floor comments (`comment.floor`)
- [x] Comment hot words (`comment.hotWord`)
- [x] Classified comments (`comment.classify`)
- [x] Album comments (`comment.album`)
- [x] Playlist comments (`comment.playlist`)

### User

- [x] Get user detail (`user.detail`)
- [x] Get user playlists (`user.playlists`)
- [x] Get user listening history (`user.history`)
- [x] Get user VIP info (`user.vipDetail`)
- [x] Favorite count (`user.favoriteCount`)
- [x] Follow artist (`user.follow`)
- [x] Submit listening history (`user.uploadHistory`)
- [x] Listening time report (`user.listenTimeAdd`)
- [x] User follow messages (`user.followMessage`)
- [x] User listening ranking (`user.listen`)
- [x] User cloud (`user.cloud`)
- [x] User cloud URL (`user.cloudUrl`)
- [x] User video favorites (`user.videoCollect`)
- [x] User video likes (`user.videoLove`)

### FM

- [x] FM categories (`fm.classes`)
- [x] FM songs (`fm.songs`)
- [x] Personal FM (`fm.personal`)
- [x] FM recommend (`fm.recommend`)
- [x] FM image (`fm.image`)

### IP Zone

- [x] IP content list (`ip.content`)
- [x] IP detail (`ip.detail`)
- [x] IP playlists (`ip.playlist`)
- [x] IP zone categories (`ip.zone`)
- [x] IP zone home (`ip.zoneHome`)

### Top Card

- [x] Top card (`top.card`)
- [x] Youth card (`top.cardYouth`)
- [x] IP top (`top.ip`)
- [x] Top playlist (`top.playlist`)
- [x] Top songs (`top.song`)

### Images

- [x] Get album and artist images (`images.albumImages`)
- [x] Get artist images (`images.audioImages`)

### Music Library

- [x] Music library recommend (`yueku.recommend`)
- [x] Music library banner (`yueku.banner`)
- [x] Music library FM (`yueku.fm`)

### Long Audio/Audiobook

- [x] Audiobook album detail (`longaudio.albumDetail`)
- [x] Audiobook album songs (`longaudio.albumAudios`)
- [x] Daily recommend (`longaudio.dailyRecommend`)
- [x] Ranking recommend (`longaudio.rankRecommend`)
- [x] VIP recommend (`longaudio.vipRecommend`)
- [x] Weekly recommend (`longaudio.weekRecommend`)

### Video

- [x] Get video detail (`video.detail`)
- [x] Get video privilege (`video.privilege`)
- [x] Get video URL (`video.url`)
- [x] Get song MV (`video.audioMv`)
- [x] Get audio MV detail (`video.audioDetail`)

### Scene

- [x] Scene music list (`scene.lists`)
- [x] Scene music list V2 (`scene.listsV2`)
- [x] Get scene modules (`scene.module`)
- [x] Get scene module info (`scene.moduleInfo`)
- [x] Get scene music list (`scene.audioList`)
- [x] Get scene music (`scene.music`)
- [x] Get scene playlist list (`scene.collectionList`)
- [x] Get scene video list (`scene.videoList`)

### Sheet Music

- [x] Song sheets (`sheet.collection`)
- [x] Sheet collection detail (`sheet.collectionDetail`)
- [x] Sheet detail (`sheet.detail`)
- [x] Hot sheets (`sheet.hot`)
- [x] Sheet list (`sheet.list`)

### Theme

- [x] Get theme music (`theme.music`)
- [x] Get theme music detail (`theme.musicDetail`)
- [x] Get theme playlists (`theme.playlist`)
- [x] Get theme playlist tracks (`theme.playlistTrack`)

### Misc

- [x] Get artist list (`misc.singerList`)
- [x] New songs (`misc.latestSongs`)
- [x] Get server time (`misc.serverNow`)
- [x] Get privilege info (`misc.privilegeLite`)
- [x] Shuffle recommend (`misc.brush`)
- [x] Register device (`misc.registerDev`)
- [ ] Send captcha (`captcha_sent`)
- [x] PC radio (`misc.pcDiantai`)
- [ ] AI recommend (`ai_recommend`)

### Youth Channel

- [x] Get all user channels (`youth.channelAll`)
- [x] Channel recommend (`youth.channelAmway`)
- [x] Channel detail (`youth.channelDetail`)
- [x] Similar channels (`youth.channelSimilar`)
- [x] Channel subscribe (`youth.channelSubscribe`)
- [x] Channel music story (`youth.channelSong`)
- [x] Channel music story detail (`youth.channelSongDetail`)
- [x] Claim VIP (`youth.dayVip`)
- [x] VIP upgrade (`youth.dayVipUpgrade`)
- [x] Dynamic (`youth.dynamic$`)
- [x] Recent dynamic (`youth.dynamicRecent`)
- [x] Listen song (`youth.listenSong`)
- [x] Monthly VIP record (`youth.monthVipRecord`)
- [x] Union VIP (`youth.unionVip`)
- [x] VIP (`youth.vip`)
- [x] User song (`youth.userSong`)

### Audio Extension

- [ ] Accompaniment matching (`audio_accompany_matching`)
- [ ] KTV count (`audio_ktv_total`)
- [ ] Related audio (`audio_related`)

## Signature Algorithm

This library includes six KuGou API signature/encryption algorithms:

- **Android Signature** - Default algorithm using Android client salt
- **Web Signature** - Web algorithm for QR code login etc.
- **Register Signature** - Register-specific algorithm
- **Playlist AES Encrypt/Decrypt** - AES-CBC with 6-char random key, base64 I/O
- **RSA Encrypt 2** - RSA with PKCS1 v1.5 padding
- **SHA1 Hash** - SHA1 hash function

POST request signatures automatically include the request body (JSON encoded) in the signature calculation.

## Known Limitations

- Some endpoints require login (e.g., `IpApi.zoneHome`), use `CookieJar` to pass initial cookies or login first
- CookieJar does not include file persistence, users should save `serialize()` output themselves

## Disclaimer

> 1. This project is for learning purposes only. Please respect copyright and do not use this project for commercial or illegal purposes!
> 2. This project may generate copyrighted data during use. The project does not own the copyright of such data. To avoid infringement, users must clear any copyrighted data generated within 24 hours.
> 3. The user is responsible for any direct, indirect, special, incidental, or consequential damages arising from the use of this project.
> 4. **Do not use this project in violation of local laws and regulations.** The user bears full responsibility for any violations.
> 5. Music platforms work hard - please respect copyright and support legitimate sources.
> 6. This project is for technical feasibility exploration only and does not accept any commercial cooperation or donations.
> 7. If the official music platform finds this project inappropriate, please contact to have it modified or removed.

## License

[BSD 3-Clause "New" or "Revised" License](LICENSE)
