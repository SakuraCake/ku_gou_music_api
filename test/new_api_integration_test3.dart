import 'package:kugou_api/kugou_api.dart';

String _ds(dynamic d) {
  if (d == null) return 'null';
  if (d is Map) return 'Map(${d.keys.toList()})';
  if (d is List) return 'List(${d.length})';
  return d.runtimeType.toString();
}

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
  print('  补全 + 新增 API 集成测试');
  print('========================================\n');

  await test('SearchApi.defaultWord - 默认搜索词', () async {
    final result = await api.search.defaultWord();
    print('   默认搜索词: data=${_ds(result.data)}');
  });

  await test('SongApi.ranking - 歌曲排名', () async {
    final result = await api.song.ranking(albumAudioId: 32144322);
    print('   歌曲排名: data=${_ds(result.data)}');
  });

  await test('CommentApi.album - 专辑评论', () async {
    final result = await api.comment.album(albumId: 96457139);
    print('   专辑评论: count=${result.count}, list=${result.list?.length ?? 0}');
  });

  await test('CommentApi.playlist - 歌单评论', () async {
    final result = await api.comment.playlist(playlistId: 638912923);
    print('   歌单评论: count=${result.count}, list=${result.list?.length ?? 0}');
  });

  await test('MiscApi.singerList - 歌手分类列表', () async {
    final result = await api.misc.singerList();
    print('   歌手列表: data=${_ds(result.data)}');
  });

  await test('MiscApi.serverNow - 服务器时间', () async {
    final result = await api.misc.serverNow();
    print('   服务器时间: data=${_ds(result.data)}');
  });

  await test('MiscApi.privilegeLite - 歌曲权限', () async {
    final result = await api.misc.privilegeLite(hash: '1335f720c701863f127fb14ccc9c08a2');
    print('   歌曲权限: data=${_ds(result.data)}');
  });

  await test('VideoApi.detail - 视频详情', () async {
    final result = await api.video.detail(videoId: '83963');
    print('   视频详情: data=${_ds(result.data)}');
  });

  await test('VideoApi.privilege - 视频特权', () async {
    final result = await api.video.privilege(videoId: '83963', hash: 'B3B1D275E9F2B0E2681E5D3F3D5D1D3E');
    print('   视频特权: data=${_ds(result.data)}');
  });

  await test('SceneApi.lists - 场景列表', () async {
    final result = await api.scene.lists();
    print('   场景列表: data=${_ds(result.data)}');
  });

  await test('SheetApi.collection - 乐谱主页', () async {
    final result = await api.sheet.collection();
    print('   乐谱主页: data=${_ds(result.data)}');
  });

  await test('SheetApi.hot - 热门乐谱', () async {
    final result = await api.sheet.hot();
    print('   热门乐谱: data=${_ds(result.data)}');
  });

  await test('SheetApi.list - 乐谱列表', () async {
    final result = await api.sheet.list(albumAudioId: 32144322);
    print('   乐谱列表: data=${_ds(result.data)}');
  });

  await test('ThemeApi.music - 主题音乐', () async {
    final result = await api.theme.music();
    print('   主题音乐: data=${_ds(result.data)}');
  });

  await test('ThemeApi.playlist - 主题歌单', () async {
    final result = await api.theme.playlist();
    print('   主题歌单: data=${_ds(result.data)}');
  });

  api.httpClient.close();

  print('\n========================================');
  print('  测试结果: ✅ $passed 通过, ❌ $failed 失败');
  print('========================================');
  print('\n已弃用（API 已下线/不可用）:');
  print('  - SearchApi.complex (服务端返回 HTML)');
  print('  - SongApi.climax (CDN 服务器返回 missing all client info)');
  print('  - SongApi.rankingFilter (参数错误，可能需要登录)');
  print('  - FmApi.personal (服务端返回 HTML)');
  print('  - SceneApi.listsV2 (服务端返回 HTML)');
  print('  - MiscApi.brush (服务端返回 HTML)');
}
