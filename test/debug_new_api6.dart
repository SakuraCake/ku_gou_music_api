import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. FmApi.classes - 完整响应 ===');
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
      if (classList.isNotEmpty) {
        final first = classList[0] as Map<String, dynamic>;
        print('class keys: ${first.keys.toList()}');
        final fmlist = first['fmlist'] as List?;
        if (fmlist != null && fmlist.isNotEmpty) {
          final fmFirst = fmlist[0] as Map<String, dynamic>;
          print('fm keys: ${fmFirst.keys.toList()}');
          print('fm sample: ${jsonEncode(fmFirst).substring(0, 300)}');
          final songlist = fmFirst['songlist'];
          if (songlist is List && songlist.isNotEmpty) {
            print('song keys: ${(songlist[0] as Map).keys.toList()}');
            print('song sample: ${jsonEncode(songlist[0]).substring(0, 300)}');
          }
        }
      }
    }
  } catch (e, st) {
    print('Error: $e');
    print('Stack: ${st.toString().split('\n').take(5).join('\n')}');
  }

  print('\n=== 2. PlaylistApi.tracks - 完整响应 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/pubsongs/v2/get_other_list_file_nofilt',
      params: {
        'area_code': 1,
        'begin_idx': 0,
        'plat': 1,
        'type': 1,
        'mode': 1,
        'personal_switch': 1,
        'extend_fields': 'abtags,hot_cmt,popularization',
        'pagesize': 2,
        'global_collection_id': 'collection_3_509004950_37_0',
      },
      encryptType: EncryptType.android,
    );
    if (result['status'] == 1) {
      final data = result['data'] as Map<String, dynamic>;
      print('data keys: ${data.keys.toList()}');
      final songs = data['songs'];
      if (songs is List && songs.isNotEmpty) {
        final first = songs[0] as Map<String, dynamic>;
        print('song keys: ${first.keys.toList()}');
        print('song sample: ${jsonEncode(first).substring(0, 400)}');
      }
    }
  } catch (e, st) {
    print('Error: $e');
    print('Stack: ${st.toString().split('\n').take(5).join('\n')}');
  }

  api.httpClient.close();
}
