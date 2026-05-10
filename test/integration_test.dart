import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(
    platform: Platform.standard,
    logLevel: LogLevel.debug,
    logCallback: (level, msg) => print('[${level.name}] $msg'),
  );

  print('=== 1. 搜索歌曲 ===');
  try {
    final result = await api.search.songs(keyword: '周杰伦', pageSize: 5);
    print('搜索结果总数: ${result.total}');
    if (result.songs != null && result.songs!.isNotEmpty) {
      final song = result.songs!.first;
      print('第一首: ${song.songName ?? song.name} - ${song.ownerName ?? song.singer}');
      print('Hash: ${song.hash}');

      print('\n=== 2. 歌曲详情 ===');
      try {
        final details = await api.song.detail(hashes: [song.hash!]);
        print('详情数量: ${details.length}');
        if (details.isNotEmpty) {
          final d = details.first;
          print('audioName: ${d.audioName}');
          print('displayName: ${d.displayName}');
          print('displaySinger: ${d.displaySinger}');
          print('albumName: ${d.albumName}');
          print('bitrate: ${d.bitrate}');
          print('filesize128: ${d.filesize128}');
        }
      } catch (e) {
        print('歌曲详情失败: $e');
      }

      print('\n=== 3. 获取歌曲URL ===');
      try {
        final url = await api.song.url(hash: song.hash!);
        print('URL: ${url.url}');
        print('Hash: ${url.hash}');
        print('fileSize: ${url.fileSize}');
        print('bitRate: ${url.bitRate}');
        print('extName: ${url.extName}');
      } catch (e) {
        print('歌曲URL失败: $e');
      }

      print('\n=== 4. 歌词搜索 ===');
      try {
        final lyricSearch = await api.lyric.search(
          keyword: song.songName ?? song.name ?? '',
          hash: song.hash,
        );
        print('歌词搜索结果数: ${lyricSearch.candidates?.length ?? 0}');
        if (lyricSearch.candidates != null && lyricSearch.candidates!.isNotEmpty) {
          final first = lyricSearch.candidates!.first;
          print('歌词ID: ${first.id}, accesskey: ${first.accesskey}');
          print('歌曲: ${first.song}, 歌手: ${first.singer}');

          print('\n=== 5. 获取歌词 ===');
          try {
            final lyric = await api.lyric.get(
              id: first.id!,
              accesskey: first.accesskey!,
              format: LyricFormat.lrc,
            );
            final content = lyric.content ?? '';
            print('歌词格式: ${lyric.format}');
            print('歌词内容(前200字): ${content.substring(0, content.length > 200 ? 200 : content.length)}');
          } catch (e) {
            print('获取歌词详情失败: $e');
          }
        }
      } catch (e) {
        print('歌词搜索失败: $e');
      }
    }
  } catch (e) {
    print('搜索失败: $e');
  }

  print('\n=== 6. 热搜列表 ===');
  try {
    final hotList = await api.search.hotDetail();
    print('热搜数量: ${hotList.length}');
    if (hotList.isNotEmpty) {
      for (var i = 0; i < (hotList.length > 5 ? 5 : hotList.length); i++) {
        print('  ${i + 1}. ${hotList[i].displayText}');
      }
    }
  } catch (e) {
    print('热搜失败: $e');
  }

  print('\n=== 7. 搜索建议 ===');
  try {
    final suggest = await api.search.suggest(keyword: '周');
    print('搜索建议: keyword=${suggest.keyword}, songs=${suggest.songs}');
  } catch (e) {
    print('搜索建议失败: $e');
  }

  print('\n=== 8. 综合搜索 ===');
  try {
    final mixed = await api.search.mixed(keyword: '周杰伦');
    print('综合搜索: songs=${mixed.songs?.length ?? 0}, albums=${mixed.albums?.length ?? 0}');
  } catch (e) {
    print('综合搜索失败: $e');
  }

  print('\n=== 测试完成 ===');
  api.httpClient.close();
}
