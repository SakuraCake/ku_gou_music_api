import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== CommentApi.music - 完整响应 ===');
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
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'];
      print('data type: ${data.runtimeType}');
      if (data is Map) {
        print('data keys: ${data.keys.toList()}');
        print('sample: ${jsonEncode(data).substring(0, 500)}');
      } else if (data is List) {
        print('data is List, length: ${data.length}');
      } else {
        print('data: $data');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
