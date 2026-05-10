import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. RankApi.info - 原始响应 ===');
  try {
    final result = await api.client.get<Map<String, dynamic>>(
      '/ocean/v6/rank/info',
      params: {'rankid': 8888, 'rank_cid': 0, 'with_album_img': 1, 'zone': ''},
      encryptType: EncryptType.android,
    );
    final data = result['data'];
    print('data type: ${data.runtimeType}');
    if (data is Map) {
      print('data keys: ${data.keys.toList()}');
      final songinfo = data['songinfo'];
      print('songinfo type: ${songinfo?.runtimeType}');
      if (songinfo is List) {
        print('songinfo is List, length: ${songinfo.length}');
        if (songinfo.isNotEmpty) print('first: ${jsonEncode(songinfo[0]).substring(0, 200)}');
      } else if (songinfo is Map) {
        print('songinfo keys: ${songinfo.keys.toList()}');
        final songs = songinfo['songs'];
        print('songs type: ${songs?.runtimeType}');
      }
    } else if (data is List) {
      print('data is List, length: ${data.length}');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. PlaylistApi.top - 原始响应 ===');
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
        'pagesize': 2,
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
    final specialList = data['special_list'] as List;
    if (specialList.isNotEmpty) {
      final first = specialList[0] as Map<String, dynamic>;
      print('first keys: ${first.keys.toList()}');
      print('global_collection_id: ${first['global_collection_id']} (type: ${first['global_collection_id'].runtimeType})');
      print('specialid: ${first['specialid']} (type: ${first['specialid'].runtimeType})');
      print('name: ${first['name']}');
      print('song_count: ${first['song_count']} (type: ${first['song_count'].runtimeType})');
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 3. AlbumApi.detail - 原始响应 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/v1/album',
      body: {
        'appid': api.httpClient.config.appid,
        'clienttime': DateTime.now().millisecondsSinceEpoch,
        'clientver': api.httpClient.config.clientver,
        'data': [{'album_id': '190208464', 'album_name': '', 'author_name': ''}],
        'dfid': api.httpClient.dfid,
        'fields': '',
        'key': signParams(DateTime.now().millisecondsSinceEpoch.toString(), appid: api.httpClient.config.appid, clientver: api.httpClient.config.clientver, isLite: api.httpClient.config.isLite),
        'mid': api.httpClient.mid,
      },
      baseURL: 'http://kmr.service.kugou.com',
      router: 'kmr.service.kugou.com',
      encryptType: EncryptType.android,
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

  print('\n=== 4. ArtistApi.audios - 原始响应 ===');
  try {
    final clienttime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final key = signParams(clienttime.toString(), appid: api.httpClient.config.appid, clientver: api.httpClient.config.clientver, isLite: api.httpClient.config.isLite);
    final result = await api.client.post<Map<String, dynamic>>(
      '/kmr/v1/audio_group/author',
      body: {
        'appid': api.httpClient.config.appid,
        'clientver': api.httpClient.config.clientver,
        'mid': api.httpClient.mid,
        'clienttime': clienttime,
        'key': key,
        'author_id': 3069,
        'pagesize': 5,
        'page': 1,
        'sort': 1,
        'area_code': 'all',
      },
      baseURL: 'https://openapi.kugou.com',
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '220'},
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'];
      print('data type: ${data.runtimeType}');
      if (data is Map) {
        print('data keys: ${data.keys.toList()}');
        print('sample: ${jsonEncode(data).substring(0, 300)}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 5. FmApi.classes - 原始响应 ===');
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
      final classList = data['class_list'] as List?;
      if (classList != null && classList.isNotEmpty) {
        final first = classList[0] as Map<String, dynamic>;
        print('first keys: ${first.keys.toList()}');
        print('sample: ${jsonEncode(first).substring(0, 300)}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 6. CommentApi.music - 原始响应 ===');
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
      body: {},
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

  print('\n=== 7. UserApi.vipDetail - 原始响应 ===');
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
