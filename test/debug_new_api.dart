import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.debug);

  print('=== 1. RankApi.list (原始响应) ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/rank/list',
      params: {'plat': 2, 'withsong': 1, 'parentid': 0},
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    print('data type: ${result['data'].runtimeType}');
    if (result['data'] is Map) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
      final rankList = data['rank_list'];
      if (rankList is List) {
        print('rank_list length: ${rankList.length}');
        if (rankList.isNotEmpty) {
          print('first item keys: ${(rankList[0] as Map).keys.toList()}');
          print('first item: ${rankList[0]}');
        }
      } else {
        print('rank_list type: ${rankList.runtimeType}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. ArtistApi.list (原始响应) ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/singer/list',
      params: {'musician': 0, 'sextype': 0, 'showtype': 2, 'type': 0, 'hotsize': 5},
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    print('data type: ${result['data'].runtimeType}');
    if (result['data'] is Map) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
      final list = data['list'];
      if (list is List) {
        print('list length: ${list.length}');
        if (list.isNotEmpty) print('first: ${list[0]}');
      } else {
        print('list type: ${list.runtimeType}');
      }
      final hotSingers = data['hot_singers'];
      if (hotSingers is List) {
        print('hot_singers length: ${hotSingers.length}');
        if (hotSingers.isNotEmpty) print('first hot: ${hotSingers[0]}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 3. PlaylistApi.top (原始响应) ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/v2/special_recommend',
      body: {
        'appid': api.httpClient.config.appid,
        'mid': api.httpClient.mid,
        'clientver': api.httpClient.config.clientver,
        'platform': 'android',
        'clienttime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'userid': 0,
        'module_id': 1,
        'page': 1,
        'pagesize': 5,
        'special_recommend': {
          'withtag': 1, 'withsong': 1, 'sort': 1, 'ugc': 1,
          'is_selected': 0, 'withrecommend': 1, 'area_code': 1, 'categoryid': 0,
        },
        'req_multi': 1,
        'retrun_min': 5,
        'return_special_falg': 1,
      },
      router: 'specialrec.service.kugou.com',
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 0) {
      print('error_code: ${result['error_code']}');
      print('errcode: ${result['errcode']}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 4. FmApi.classes (原始响应) ===');
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
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    print('data type: ${result['data'].runtimeType}');
    if (result['data'] is Map) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 5. RecommendApi.newSongs (原始响应) ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/musicadservice/container/v1/newsong_publish',
      body: {
        'rank_id': 21608,
        'userid': 0,
        'page': 1,
        'pagesize': 5,
        'tags': [],
      },
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 0) {
      print('error_code: ${result['error_code']}');
    }
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
