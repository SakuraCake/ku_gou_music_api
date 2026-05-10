import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. RankApi.list - 数据结构 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/rank/list',
      params: {'plat': 2, 'withsong': 1, 'parentid': 0},
      encryptType: EncryptType.android,
    );
    final data = result['data'] as Map<String, dynamic>;
    final info = data['info'] as List;
    print('info length: ${info.length}');
    final first = info[0] as Map<String, dynamic>;
    print('first keys: ${first.keys.toList()}');
    final rankItem = first['rank'] as Map<String, dynamic>?;
    if (rankItem != null) {
      print('rank keys: ${rankItem.keys.toList()}');
      print('rankid: ${rankItem['rankid']}, rankname: ${rankItem['rankname']}');
    } else {
      print('first sample: ${jsonEncode(first).substring(0, 200)}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. RankApi.info - 数据结构 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/rank/info',
      params: {'rankid': 8888, 'rank_cid': 0, 'with_album_img': 1, 'zone': ''},
      encryptType: EncryptType.android,
    );
    final data = result['data'] as Map<String, dynamic>;
    print('data keys: ${data.keys.toList()}');
    final info = data['info'];
    if (info is List) {
      print('info length: ${info.length}');
      if (info.isNotEmpty) {
        final first = info[0] as Map<String, dynamic>;
        print('first keys: ${first.keys.toList()}');
        print('sample: ${jsonEncode(first).substring(0, 300)}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 3. ArtistApi.list - 数据结构 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/singer/list',
      params: {'musician': 0, 'sextype': 0, 'showtype': 2, 'type': 0, 'hotsize': 5},
      encryptType: EncryptType.android,
    );
    final data = result['data'] as Map<String, dynamic>;
    final info = data['info'] as List;
    print('info length: ${info.length}');
    final first = info[0] as Map<String, dynamic>;
    print('first keys: ${first.keys.toList()}');
    print('sample: ${jsonEncode(first).substring(0, 300)}');
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 4. PlaylistApi.top - 数据结构 ===');
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
    final data = result['data'] as Map<String, dynamic>;
    print('data keys: ${data.keys.toList()}');
    final list = data['list'];
    if (list is List) {
      print('list length: ${list.length}');
      if (list.isNotEmpty) {
        final first = list[0] as Map<String, dynamic>;
        print('first keys: ${first.keys.toList()}');
        print('sample: ${jsonEncode(first).substring(0, 300)}');
      }
    } else {
      print('list type: ${list?.runtimeType}');
      print('data sample: ${jsonEncode(data).substring(0, 300)}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 5. AlbumApi.top - 数据结构 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/musicadservice/v1/mobile_newalbum_sp',
      body: {
        'apiver': api.httpClient.config.clientver,
        'page': 1,
        'pagesize': 5,
        'withpriv': 1,
      },
      encryptType: EncryptType.android,
    );
    final data = result['data'] as Map<String, dynamic>;
    print('data keys: ${data.keys.toList()}');
    print('sample: ${jsonEncode(data).substring(0, 300)}');
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 6. RecommendApi.newSongs - 数据结构 ===');
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
    final data = result['data'] as Map<String, dynamic>;
    print('data keys: ${data.keys.toList()}');
    print('sample: ${jsonEncode(data).substring(0, 300)}');
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 7. FmApi.classes - 调试签名 ===');
  try {
    final clienttime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(clienttime.toString(), appid: api.httpClient.config.appid, clientver: api.httpClient.config.clientver, isLite: api.httpClient.config.isLite);
    final result = await api.client.post<Map<String, dynamic>>(
      '/v1/class_fm_song',
      body: {
        'kguid': 0,
        'clienttime': clienttime,
        'mid': api.httpClient.mid,
        'platform': 'android',
        'clientver': api.httpClient.config.clientver,
        'uid': 0,
        'get_tracker': 1,
        'appid': api.httpClient.config.appid,
        'key': key,
      },
      router: 'fm.service.kugou.com',
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map<String, dynamic>;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 8. CommentApi.music - 数据结构 ===');
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
      final data = result['data'] as Map<String, dynamic>;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 9. UserApi.vipDetail - 数据结构 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/v1/get_union_vip',
      params: {'busi_type': 'concept'},
      baseURL: 'https://kugouvip.kugou.com',
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map<String, dynamic>;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 10. PlaylistApi.tags - 数据结构 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/pubsongs/v1/get_tags_by_type',
      body: {'tag_type': 'collection', 'tag_id': 0, 'source': 3},
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map<String, dynamic>;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 11. PlaylistApi.detail - 数据结构 ===');
  try {
    final topResult = await api.client.post<Map<String, dynamic>>(
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
        'pagesize': 1,
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
    final list = (topResult['data']['list'] as List?) ?? [];
    if (list.isEmpty) { print('No playlists found'); } else {
      final gid = list[0]['global_collection_id'] as String?;
      print('gid: $gid');
      if (gid != null) {
        final detailResult = await api.client.post<Map<String, dynamic>>(
          '/v3/get_list_info',
          body: {
            'data': [{'global_collection_id': gid}],
            'userid': 0,
            'token': '',
          },
          router: 'pubsongs.kugou.com',
          encryptType: EncryptType.android,
        );
        print('status: ${detailResult['status']}');
        if (detailResult['status'] == 1) {
          final data = detailResult['data'] as Map<String, dynamic>;
          print('data keys: ${data.keys.toList()}');
          print('sample: ${jsonEncode(data).substring(0, 300)}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 12. ArtistApi.detail - 数据结构 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/kmr/v3/author',
      body: {'author_id': 3069},
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '36'},
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map<String, dynamic>;
      print('data keys: ${data.keys.toList()}');
      print('sample: ${jsonEncode(data).substring(0, 300)}');
    }
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
