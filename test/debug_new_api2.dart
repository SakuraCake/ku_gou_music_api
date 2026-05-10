import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. RankApi.list - 查看完整 data 结构 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/rank/list',
      params: {'plat': 2, 'withsong': 1, 'parentid': 0},
      encryptType: EncryptType.android,
    );
    final data = result['data'] as Map<String, dynamic>;
    print('data keys: ${data.keys.toList()}');
    final info = data['info'];
    if (info is List) {
      print('info length: ${info.length}');
      if (info.isNotEmpty) {
        final first = info[0] as Map<String, dynamic>;
        print('first item keys: ${first.keys.toList()}');
        print('first item (partial): rankid=${first['rankid']}, name=${first['name']}, img=${(first['img'] ?? '').toString().substring(0, 30)}...');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. RankApi.info - 查看排行榜详情 ===');
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
        print('first (partial): ${first.keys.where((k) => k != 'img').map((k) => '$k=${first[k]}').join(', ')}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 3. ArtistApi.list - 查看歌手列表结构 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/singer/list',
      params: {'musician': 0, 'sextype': 0, 'showtype': 2, 'type': 0, 'hotsize': 5},
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
        print('first: author_id=${first['author_id']}, author_name=${first['author_name']}');
      }
    }
    final enuList = data['enu_list'];
    if (enuList is List) {
      print('enu_list length: ${enuList.length}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 4. PlaylistApi.tags - 不带签名测试 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/pubsongs/v1/get_tags_by_type',
      body: {'tag_type': 'collection', 'tag_id': 0, 'source': 3},
      notSignature: true,
    );
    print('status: ${result['status']}');
    print('data type: ${result['data'].runtimeType}');
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 5. PlaylistApi.top - 不带签名测试 ===');
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
      notSignature: true,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      print('data keys: ${(result['data'] as Map).keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 6. AlbumApi.top - 不带签名测试 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/musicadservice/v1/mobile_newalbum_sp',
      body: {
        'apiver': api.httpClient.config.clientver,
        'page': 1,
        'pagesize': 5,
        'withpriv': 1,
      },
      notSignature: true,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 7. FmApi.classes - 不带签名测试 ===');
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
      notSignature: true,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 8. RecommendApi.newSongs - 不带签名测试 ===');
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
      notSignature: true,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 9. CommentApi.music - 不带签名测试 ===');
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
      notSignature: true,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'] as Map;
      print('data keys: ${data.keys.toList()}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 10. UserApi.vipDetail - 不带签名测试 ===');
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
