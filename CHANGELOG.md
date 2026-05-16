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
