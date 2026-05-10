import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  final details = await api.song.detail(hashes: ['b3a52a7a958bf0aed0ebfba2e9a818b7']);
  if (details.isNotEmpty) {
    final detail = details.first;
    print('audioId: ${detail.audioId}');
    print('audioName: ${detail.audioName}');

    if (detail.audioId != null) {
      final result = await api.comment.music(mixSongId: detail.audioId!, pageSize: 3);
      print('评论数量: ${result.list?.length ?? 0}');
      if (result.list != null && result.list!.isNotEmpty) {
        print('第一条评论: ${result.list!.first.content}');
      }
    }
  }

  api.httpClient.close();
}
