import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. 不带签名 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/mcomment/v1/cmtlist',
      params: {
        'mixsongid': 20505418,
        'need_show_image': 1,
        'p': 1,
        'pagesize': 3,
        'show_classify': 1,
        'show_hotword_list': 1,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
      },
      notSignature: true,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      print('count: ${result['count']}');
      print('list length: ${(result['list'] as List?)?.length ?? 0}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. 带 web 签名 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/mcomment/v1/cmtlist',
      params: {
        'mixsongid': 20505418,
        'need_show_image': 1,
        'p': 1,
        'pagesize': 3,
        'show_classify': 1,
        'show_hotword_list': 1,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
      },
      encryptType: EncryptType.web,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      print('count: ${result['count']}');
    }
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
