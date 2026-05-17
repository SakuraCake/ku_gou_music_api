## 0.1.0

### 新增 API 类

- **YouthApi**（概念版）— 16 个方法：channelAll, channelAmway, channelDetail, channelSimilar, channelSubscribe, channelSong, channelSongDetail, dayVip, dayVipUpgrade, dynamic$, dynamicRecent, listenSong, monthVipRecord, unionVip, vip, userSong

### 新增方法（14 个 API 类，30 个方法）

- **SearchApi**: mixedSearch, suggestV2, hotTab
- **LoginApi**: deviceLogin, deviceKick, openplatLogin, wxCreate, wxCheck
- **MiscApi**: registerDev, pcDiantai
- **UserApi**: cloud, cloudUrl, listen, followMessage, videoCollect, videoLove
- **RankApi**: audio, top, vol
- **PlaylistApi**: trackAllNew, effect
- **AlbumApi**: oldDetail, songs, shop
- **ArtistApi**: videos, followNewSongs, honour
- **SongApi**: climax, rankingFilter
- **VideoApi**: audioMv, audioDetail
- **SceneApi**: listsV2
- **FmApi**: recommend, image
- **RecommendApi**: everydayFriend, everydayHistory, everydayStyleRecommend

### 修改方法

- **LoginApi.qrCodeStream**: 新增 `qrimg` 参数（默认 false）— 为 true 时返回 base64 二维码图片，为 false 时返回二维码链接
- **LoginApi._getQrCode**: 新增 `qrimg` 参数支持

### 参数补充（13 个方法）

- FmApi.songs: 新增 fmtype, fmoffset, fmsize
- FmApi.personal: 新增 vipType
- MiscApi.brush: 新增 songPoolId
- MiscApi.privilegeLite: 新增 albumId
- AlbumApi.detail: 新增 isBuy
- RankApi.info: 新增 albumImg
- RankApi.list: 新增 withSong
- UserApi.follow: 新增 merge, needIdenType, extParams, type, idType
- UserApi.uploadHistory: 新增 mxid, time, pc
- UserApi.listenTimeAdd: 新增 p, appid, mid, clientver, clienttime, type, uuid, key
- SceneApi.audioList: 新增 moduleId, tag
- SearchApi.defaultWord: 新增 vipType, mType
- TopApi.cardYouth: 新增 tagId

### Bug 修复

- **LoginApi.refreshToken**: 修复返回 `userId` 为 null 的问题 — 现在会先从 `data['userid']` 获取，解密结果可覆盖
- **UserPlaylistResult**: 修复 JSON 解析错误 — `list` 字段正确映射到 `info`，`totalCount` 字段正确映射到 `list_count`

### 新增加密函数

- playlistAesEncrypt / playlistAesDecrypt（AES-CBC，6 位随机密钥，base64 输入输出）
- rsaEncrypt2（RSA PKCS1 v1.5 填充）
- cryptoSha1（SHA1 哈希）

### 新增常量

- kWxAppid, kWxSecret, kWxLiteAppid, kWxLiteSecret
- kAudioRelatedSalt, kKtvSignSalt

## 0.0.5

- Removed old generated `docs/` from git tracking
- Added `.pubignore` to exclude non-package files from publishing
- All tests passing, dry-run clean

## 0.0.4

- Added Chinese README (`README_CN.md`) with language switcher between English and Chinese
- Added GitHub Actions publish workflow (`.github/workflows/publish.yml`)
- Fixed missing changelog entries for test fixes and documentation updates

## 0.0.3

- Rewrote README in English for pub.dev compliance
- Added interactive example (`example/kugou_api_example.dart`)
- Updated pointycastle dependency to ^4.0.0
- Fixed various code analysis warnings
- Fixed search API tests to match new `complexsearch.kugou.com` endpoint
- Fixed lyric API tests to remove non-existent `client=mobi` parameter
- Fixed song API tests for lossless quality parameter (`flac`)
- All 119 tests passing

## 0.0.2

- Fixed song URL retrieval for high-quality audio (320kbps, FLAC)
- Fixed incorrect quality parameter for lossless audio
- Removed deprecated APIs that are no longer working:
  - `SongApi.climax` (CDN server rejects requests)
  - `SongApi.rankingFilter` (parameter error)
  - `SceneApi.listsV2` (server returns HTML)
- Restored previously incorrectly deprecated APIs:
  - `SearchApi.complex` (complex search)
  - `MiscApi.brush` (shuffle recommendation)
  - `FmApi.personal` (personalized FM)
- Cleaned up test files and debug scripts
- Updated README documentation
- Fixed various code analysis warnings

## 0.0.1

- Initial release
- Full KuGou Music API coverage
- Support for search, songs, lyrics, playlists, albums, artists, comments, users, FM, and more
- Authentication support (password, captcha, QR code login)
- Cookie management with CookieJar
- Built-in caching support
- Retry mechanism for failed requests
- Proxy configuration support
- Comprehensive error handling
