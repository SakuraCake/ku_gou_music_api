import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== FmApi.classes - 完整解析 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/v1/class_fm_song',
      body: {
        'kguid': 0,
        'clienttime': DateTime.now().millisecondsSinceEpoch,
        'mid': api.httpClient.mid,
        'platform': 'android',
        'clientver': api.httpClient.config.clientver,
        'uid': 0,
        'get_tracker': 1,
        'appid': api.httpClient.config.appid,
        'key': signParams(DateTime.now().millisecondsSinceEpoch.toString(), appid: api.httpClient.config.appid, clientver: api.httpClient.config.clientver, isLite: api.httpClient.config.isLite),
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
    );
    if (result['status'] == 1) {
      final data = result['data'] as Map<String, dynamic>;
      final classList = data['class_list'] as List;
      final first = classList[0] as Map<String, dynamic>;
      
      print('classid: ${first['classid']} (type: ${first['classid'].runtimeType})');
      print('classname: ${first['classname']} (type: ${first['classname'].runtimeType})');
      print('class_count: ${first['class_count']} (type: ${first['class_count'].runtimeType})');
      
      try {
        final group = FmClassGroup.fromJson(first);
        print('FmClassGroup parsed OK: ${group.className}');
      } catch (e) {
        print('FmClassGroup parse error: $e');
      }
      
      try {
        final fmResult = FmClassResult.fromJson(data);
        print('FmClassResult parsed OK: ${fmResult.classList?.length}');
      } catch (e, st) {
        print('FmClassResult parse error: $e');
        print('Stack: ${st.toString().split('\n').take(8).join('\n')}');
      }
    }
  } catch (e, st) {
    print('Error: $e');
    print('Stack: ${st.toString().split('\n').take(8).join('\n')}');
  }

  api.httpClient.close();
}
