import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. 先搜索获取有效的 mixsongid ===');
  try {
    final searchResult = await api.search.songs(keyword: '周杰伦', pageSize: 1);
    final songs = searchResult.songs;
    if (songs != null && songs.isNotEmpty) {
      final song = songs.first;
      print('song name: ${song.name}');
      print('song hash: ${song.hash}');
    }
  } catch (e) {
    print('Search error: $e');
  }

  print('\n=== 2. CommentApi.music - 用不同 mixsongid ===');
  for (final mixSongId in [307584, 33140471, 1105646353]) {
    try {
      final result = await api.client.post<Map<String, dynamic>>(
        '/mcomment/v1/cmtlist',
        params: {
          'mixsongid': mixSongId,
          'need_show_image': 1,
          'p': 1,
          'pagesize': 3,
          'show_classify': 1,
          'show_hotword_list': 1,
          'extdata': '0',
          'code': 'fc4be23b4e972707f36b8a828a93ba8a',
        },
        encryptType: EncryptType.android,
      );
      print('mixsongid=$mixSongId: status=${result['status']}');
      if (result['status'] == 1) {
        final data = result['data'] as Map;
        print('  data keys: ${data.keys.toList()}');
      }
    } catch (e) {
      print('mixsongid=$mixSongId: Error: $e');
    }
  }

  print('\n=== 3. UserApi.vipDetail - 不带签名测试 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/v1/get_union_vip',
      params: {'busi_type': 'concept'},
      baseURL: 'https://kugouvip.kugou.com',
      notSignature: true,
    );
    print('status: ${result['status']}');
    print('data type: ${result['data'].runtimeType}');
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
