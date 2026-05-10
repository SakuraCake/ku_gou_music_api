import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== CommentApi.music - 完整原始响应 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/mcomment/v1/cmtlist',
      params: {
        'mixsongid': 33140471,
        'need_show_image': 1,
        'p': 1,
        'pagesize': 2,
        'show_classify': 1,
        'show_hotword_list': 1,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
      },
      encryptType: EncryptType.android,
    );
    print('Full response keys: ${result.keys.toList()}');
    print('Full response: ${jsonEncode(result).substring(0, 800)}');
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
