import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(
    platform: Platform.standard,
    logLevel: LogLevel.info,
  );

  print('=== 搜索免费歌曲（儿歌/轻音乐） ===');
  try {
    final result = await api.search.songs(keyword: '小星星 儿歌', pageSize: 5);
    for (int i = 0; i < (result.songs?.length ?? 0); i++) {
      final song = result.songs![i];
      print('\n--- 歌曲 $i: ${song.songName ?? song.name} - ${song.ownerName ?? song.singer} ---');
      try {
        final url = await api.song.url(hash: song.hash!);
        print('URL: ${url.url != null ? "${url.url!.substring(0, 50)}..." : "null"}');
        print('fileSize: ${url.fileSize}, bitRate: ${url.bitRate}');
        if (url.url != null) {
          print('成功获取到URL！');
          break;
        }
      } catch (e) {
        print('URL失败: $e');
      }
    }
  } catch (e) {
    print('搜索失败: $e');
  }

  api.httpClient.close();
}
