/// Interactive example usage of kugou_api package
library;

import 'dart:io';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi();

  print('=== KuGou Music API Interactive Demo ===\n');

  try {
    while (true) {
      print('Options:');
      print('  1. Search songs');
      print('  2. Get hot search keywords');
      print('  3. Get song URL');
      print('  4. Exit');
      stdout.write('\nEnter your choice (1-4): ');
      
      final choice = stdin.readLineSync()?.trim();
      
      switch (choice) {
        case '1':
          await searchSongs(api);
          break;
        case '2':
          await getHotSearch(api);
          break;
        case '3':
          await getSongUrl(api);
          break;
        case '4':
          print('Goodbye!');
          return;
        default:
          print('Invalid choice, please try again.\n');
      }
    }
  } finally {
    api.httpClient.close();
  }
}

Future<void> searchSongs(KuGouApi api) async {
  stdout.write('Enter search keyword: ');
  final keyword = stdin.readLineSync()?.trim();
  
  if (keyword == null || keyword.isEmpty) {
    print('Keyword cannot be empty.\n');
    return;
  }

  print('\nSearching for "$keyword"...\n');
  
  final result = await api.search.songs(keyword: keyword, page: 1, pageSize: 10);
  final songs = result.songs;
  
  if (songs == null || songs.isEmpty) {
    print('No songs found.\n');
    return;
  }

  print('Found ${result.total ?? songs.length} songs:\n');
  for (var i = 0; i < songs.length; i++) {
    final song = songs[i];
    print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
  }
  print('');
}

Future<void> getHotSearch(KuGouApi api) async {
  print('\nFetching hot search keywords...\n');
  
  final hotSearch = await api.search.hotDetail();
  
  print('Top 10 hot searches:\n');
  for (var i = 0; i < hotSearch.take(10).length; i++) {
    final item = hotSearch.elementAt(i);
    print('  ${i + 1}. ${item.keyword ?? item.searchWord} (score: ${item.score ?? 0})');
  }
  print('');
}

Future<void> getSongUrl(KuGouApi api) async {
  stdout.write('Enter song hash: ');
  final hash = stdin.readLineSync()?.trim();
  
  if (hash == null || hash.isEmpty) {
    print('Hash cannot be empty.\n');
    return;
  }

  stdout.write('Enter quality (128/320/flac) [default: 320]: ');
  final qualityInput = stdin.readLineSync()?.trim() ?? '320';
  
  final quality = switch (qualityInput) {
    '128' => AudioQuality.standard,
    '320' => AudioQuality.high,
    'flac' => AudioQuality.lossless,
    _ => AudioQuality.high,
  };

  print('\nGetting song URL...\n');
  
  try {
    final result = await api.song.url(hash: hash, quality: quality);
    if (result.url != null) {
      print('Song URL: ${result.url}');
      print('File size: ${result.fileSize ?? 0} bytes');
      print('Bit rate: ${result.bitRate ?? 0} kbps');
    } else {
      print('Failed to get song URL. The song may require VIP access.');
    }
  } catch (e) {
    print('Error: $e');
  }
  print('');
}
