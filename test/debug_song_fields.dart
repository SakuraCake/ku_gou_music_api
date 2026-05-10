import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  final result = await api.search.songs(keyword: '周杰伦 晴天', pageSize: 3);
  final songs = result.songs;
  if (songs != null) {
    for (final song in songs) {
      print('name: ${song.name}, hash: ${song.hash}, albumId: ${song.albumId}, albumAudioId: ${song.albumAudioId}');
    }
  }

  api.httpClient.close();
}
