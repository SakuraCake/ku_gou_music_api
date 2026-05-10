import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.debug);

  print('=== CommentApi.music - 直接请求 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/mcomment/v1/cmtlist',
      params: {
        'mixsongid': 307584,
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
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      print('data keys: ${(result['data'] as Map).keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== UserApi.vipDetail - 直接请求 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/v1/get_union_vip',
      params: {'busi_type': 'concept'},
      baseURL: 'https://kugouvip.kugou.com',
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    print('errcode: ${result['errcode']}');
    print('error_code: ${result['error_code']}');
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
