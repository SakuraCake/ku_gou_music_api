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
