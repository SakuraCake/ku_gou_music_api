import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== FmApi.classes - 逐步解析 ===');
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
      final fmlist = first['fmlist'] as List;
      final fmFirst = fmlist[0] as Map<String, dynamic>;
      
      print('fmid: ${fmFirst['fmid']} (type: ${fmFirst['fmid'].runtimeType})');
      print('fmtype: ${fmFirst['fmtype']} (type: ${fmFirst['fmtype'].runtimeType})');
      print('fmname: ${fmFirst['fmname']} (type: ${fmFirst['fmname'].runtimeType})');
      print('imgurl: ${fmFirst['imgurl']} (type: ${fmFirst['imgurl'].runtimeType})');
      print('parentId: ${fmFirst['parentId']} (type: ${fmFirst['parentId'].runtimeType})');
      print('broadcast_type: ${fmFirst['broadcast_type']} (type: ${fmFirst['broadcast_type'].runtimeType})');
      print('addtime: ${fmFirst['addtime']} (type: ${fmFirst['addtime'].runtimeType})');
      print('fmid type detailed: ${fmFirst['fmid'].runtimeType}');
      
      try {
        final fmItem = FmClassItem.fromJson(fmFirst);
        print('FmClassItem parsed OK: ${fmItem.fmName}');
      } catch (e) {
        print('FmClassItem parse error: $e');
      }
    }
  } catch (e, st) {
    print('Error: $e');
    print('Stack: ${st.toString().split('\n').take(8).join('\n')}');
  }

  api.httpClient.close();
}
