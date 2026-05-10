import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.info);

  int passed = 0;
  int failed = 0;

  Future<void> test(String name, Future<void> Function() fn) async {
    try {
      await fn();
      passed++;
      print('✅ $name');
    } catch (e) {
      failed++;
      print('❌ $name: $e');
    }
  }

  print('========================================');
  print('  新增 API 集成测试');
  print('========================================\n');

  await test('RankApi.list - 排行榜列表', () async {
    final result = await api.rank.list();
    final info = result.info;
    if (info == null || info.isEmpty) throw Exception('info 为空');
    print('   排行榜数量: ${info.length}');
    print('   第一个: ${info.first.rankname} (id=${info.first.rankId})');
  });

  await test('RankApi.info - 排行榜详情', () async {
    final result = await api.rank.info(rankId: 8888);
    print('   排行榜名: ${result.rankname}');
    final songs = result.songinfo;
    print('   歌曲数量: ${songs?.length ?? 0}');
  });

  await test('PlaylistApi.top - 推荐歌单', () async {
    final result = await api.playlist.top(pageSize: 5);
    final list = result.specialList;
    if (list == null || list.isEmpty) throw Exception('specialList 为空');
    print('   歌单数量: ${list.length}');
    print('   第一个: ${list.first.name} (gid=${list.first.globalCollectionId})');
  });

  String? testPlaylistGid;

  await test('PlaylistApi.detail - 歌单详情', () async {
    final topResult = await api.playlist.top(pageSize: 1);
    final gid = topResult.specialList?.first.globalCollectionId;
    if (gid == null) throw Exception('无法获取歌单 gid');
    testPlaylistGid = gid;
    final result = await api.playlist.detail(ids: gid);
    final list = result.list;
    if (list == null || list.isEmpty) throw Exception('list 为空');
    print('   歌单名: ${list.first.name}');
  });

  await test('PlaylistApi.tracks - 歌单歌曲', () async {
    if (testPlaylistGid == null) throw Exception('无可用歌单 gid');
    final result = await api.playlist.tracks(id: testPlaylistGid!, pageSize: 5);
    final songs = result.songs;
    print('   歌曲数量: ${songs?.length ?? 0}');
  });

  await test('PlaylistApi.tags - 歌单分类标签', () async {
    final tags = await api.playlist.tags();
    if (tags.isEmpty) throw Exception('tags 为空');
    print('   标签数量: ${tags.length}');
    print('   第一个: ${tags.first.tagName}');
  });

  await test('PlaylistApi.similar - 相似歌单', () async {
    if (testPlaylistGid == null) throw Exception('无可用歌单 gid');
    final result = await api.playlist.similar(ids: testPlaylistGid!);
    final list = result.list;
    print('   相似歌单数量: ${list?.length ?? 0}');
  });

  await test('AlbumApi.top - 推荐专辑', () async {
    final result = await api.album.top(pageSize: 5);
    final chn = result.chn;
    if (chn == null || chn.isEmpty) throw Exception('chn 为空');
    print('   华语专辑数量: ${chn.length}');
    print('   第一个: ${chn.first.albumName} - ${chn.first.singerName}');
  });

  await test('AlbumApi.detail - 专辑详情', () async {
    final topResult = await api.album.top(pageSize: 1);
    final aid = topResult.chn?.first.albumId;
    if (aid == null) throw Exception('无法获取专辑 id');
    final result = await api.album.detail(albumId: aid.toString());
    final list = result.list;
    if (list == null || list.isEmpty) throw Exception('list 为空');
    print('   专辑名: ${list.first.albumName}');
    print('   歌手: ${list.first.singerName}');
  });

  await test('ArtistApi.list - 歌手列表', () async {
    final result = await api.artist.list(hotSize: 5);
    final info = result.info;
    if (info == null || info.isEmpty) throw Exception('info 为空');
    print('   分组数量: ${info.length}');
    print('   第一个分组: ${info.first.title}');
    final singers = info.first.singer;
    if (singers != null && singers.isNotEmpty) {
      print('   第一个歌手: ${singers.first.singerName} (id=${singers.first.singerId})');
    }
  });

  await test('ArtistApi.detail - 歌手详情', () async {
    final result = await api.artist.detail(id: 3069);
    print('   歌手名: ${result.authorName}');
    print('   歌曲数: ${result.songCount}');
    print('   专辑数: ${result.albumCount}');
  });

  await test('ArtistApi.audios - 歌手单曲', () async {
    final result = await api.artist.audios(id: 3069, pageSize: 5);
    final songs = result.songs;
    print('   单曲数量: ${songs?.length ?? 0}');
  });

  await test('ArtistApi.albums - 歌手专辑', () async {
    final result = await api.artist.albums(id: 3069, pageSize: 5);
    final albums = result.albums;
    print('   专辑数量: ${albums?.length ?? 0}');
  });

  await test('RecommendApi.newSongs - 新歌速递', () async {
    final result = await api.recommend.newSongs(pageSize: 5);
    final songs = result.songs;
    if (songs == null || songs.isEmpty) throw Exception('songs 为空');
    print('   新歌数量: ${songs.length}');
  });

  await test('RecommendApi.everyday - 每日推荐', () async {
    try {
      final result = await api.recommend.everyday();
      final songs = result.songs;
      print('   推荐歌曲数量: ${songs?.length ?? 0}');
    } catch (e) {
      print('   (可能需要登录) $e');
      rethrow;
    }
  });

  await test('RecommendApi.ai - AI推荐 (需要登录)', () async {
    try {
      final result = await api.recommend.ai();
      final songs = result.songs;
      print('   AI推荐歌曲数量: ${songs?.length ?? 0}');
    } catch (e) {
      print('   (需要登录) $e');
      rethrow;
    }
  });

  await test('CommentApi.music - 歌曲评论', () async {
    final result = await api.comment.music(mixSongId: 33140471, pageSize: 3);
    final list = result.list;
    print('   评论数量: ${list?.length ?? 0}');
  });

  await test('CommentApi.count - 评论数', () async {
    final result = await api.comment.count(hash: '1335f720c701863f127fb14ccc9c08a2');
    print('   评论数: ${result.count}');
  });

  await test('UserApi.vipDetail - VIP详情 (需要登录)', () async {
    try {
      final result = await api.user.vipDetail();
      print('   VIP类型: ${result.vipType}');
      print('   VIP名称: ${result.vipName}');
    } catch (e) {
      print('   (需要登录) $e');
      rethrow;
    }
  });

  await test('UserApi.favoriteCount - 收藏数', () async {
    final result = await api.user.favoriteCount(mixSongIds: '307584');
    print('   收藏数: ${result.count}');
  });

  await test('FmApi.classes - 电台分类', () async {
    final result = await api.fm.classes();
    final list = result.classList;
    if (list == null || list.isEmpty) throw Exception('classList 为空');
    print('   电台分类数量: ${list.length}');
    print('   第一个: ${list.first.className} (id=${list.first.classId})');
    final fmlist = list.first.fmlist;
    if (fmlist != null && fmlist.isNotEmpty) {
      print('   第一个电台: ${fmlist.first.fmName}');
    }
  });

  await test('FmApi.songs - 电台歌曲', () async {
    final classResult = await api.fm.classes();
    final classId = classResult.classList?.first.classId;
    if (classId == null) throw Exception('无法获取电台 id');
    final result = await api.fm.songs(fmId: classId.toString(), size: 5);
    final songs = result.songs;
    print('   电台歌曲数量: ${songs?.length ?? 0}');
  });

  api.httpClient.close();

  print('\n========================================');
  print('  测试结果: ✅ $passed 通过, ❌ $failed 失败');
  print('========================================');
}
