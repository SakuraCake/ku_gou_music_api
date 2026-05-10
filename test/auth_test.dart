import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(
    platform: Platform.standard,
    logLevel: LogLevel.debug,
    logCallback: (level, msg) => print('[${level.name}] $msg'),
  );

  final token = '628979c10e7d4edfe716fcd16b2b28ea342640e0a3072c84f93889d1ce0a057f';
  final userId = 1882890175;
  api.httpClient.token = token;
  api.httpClient.userid = userId;

  print('=== 1. 搜索歌曲 ===');
  final result = await api.search.songs(keyword: '周杰伦', pageSize: 5);
  print('搜索结果: ${result.total} 首\n');

  for (final song in result.songs ?? []) {
    print('--- ${song.songName ?? song.name} ---');

    print('\n歌曲详情:');
    final details = await api.song.detail(hashes: [song.hash!]);
    if (details.isNotEmpty) {
      final d = details.first;
      print('  名称: ${d.displayName}');
      print('  128K: ${d.filesize128}, 320K: ${d.filesize320}, FLAC: ${d.filesizeFlac}');
    }

    print('\n歌曲URL:');
    final url = await api.song.url(hash: song.hash!);
    print('  status: ${url.status}');
    print('  isFree: ${url.isFree}, isVip: ${url.isVip}');
    print('  hasUrl: ${url.hasUrl}');
    if (url.hasUrl) {
      print('  URL: ${url.url!.substring(0, 80)}...');
      print('  备用URL数量: ${url.backupUrls?.length ?? 0}');
      print('  文件大小: ${url.fileSize}');
      print('  比特率: ${url.bitRate}');
      print('  时长: ${url.timeLength}s');
      print('  文件名: ${url.fileName}');
    }
    if (url.hashOffset != null) {
      print('  试听: ${url.hashOffset!.startMs}ms - ${url.hashOffset!.endMs}ms');
      print('  试听hash: ${url.hashOffset!.offsetHash}');
    }
    print('');
  }

  api.httpClient.close();
}
