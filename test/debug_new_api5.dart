import 'dart:convert';
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(logLevel: LogLevel.none);

  print('=== 1. PlaylistApi.detail - 原始响应 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/v3/get_list_info',
      body: {
        'data': [{'global_collection_id': 'collection_1_1125691219_503741_0'}],
        'userid': 0,
        'token': '',
      },
      router: 'pubsongs.kugou.com',
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'];
      print('data type: ${data.runtimeType}');
      if (data is Map) {
        print('data keys: ${data.keys.toList()}');
        print('sample: ${jsonEncode(data).substring(0, 400)}');
      } else if (data is List) {
        print('data is List, length: ${data.length}');
        if (data.isNotEmpty) {
          final first = data[0] as Map<String, dynamic>;
          print('first keys: ${first.keys.toList()}');
          print('sample: ${jsonEncode(first).substring(0, 400)}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 2. PlaylistApi.tracks - 原始响应 ===');
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
        'pagesize': 3,
        'global_collection_id': 'collection_1_1125691219_503741_0',
      },
      encryptType: EncryptType.android,
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'];
      print('data type: ${data.runtimeType}');
      if (data is Map) {
        print('data keys: ${data.keys.toList()}');
        final info = data['info'];
        if (info is List && info.isNotEmpty) {
          final first = info[0] as Map<String, dynamic>;
          print('first keys: ${first.keys.toList()}');
          print('sample: ${jsonEncode(first).substring(0, 300)}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 3. AlbumApi.detail - 原始响应 ===');
  try {
    final topResult = await api.client.post<Map<String, dynamic>>(
      '/musicadservice/v1/mobile_newalbum_sp',
      body: {
        'apiver': api.httpClient.config.clientver,
        'page': 1,
        'pagesize': 1,
        'withpriv': 1,
      },
      encryptType: EncryptType.android,
    );
    final chn = (topResult['data']['chn'] as List?) ?? [];
    if (chn.isEmpty) { print('No albums'); } else {
      final albumId = chn[0]['albumid'];
      print('albumId: $albumId (type: ${albumId.runtimeType})');
      final result = await api.client.post<Map<String, dynamic>>(
        '/v1/album',
        body: {
          'appid': api.httpClient.config.appid,
          'clienttime': DateTime.now().millisecondsSinceEpoch,
          'clientver': api.httpClient.config.clientver,
          'data': [{'album_id': albumId.toString(), 'album_name': '', 'author_name': ''}],
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
        final data = result['data'];
        print('data type: ${data.runtimeType}');
        if (data is List && data.isNotEmpty) {
          final first = data[0] as Map<String, dynamic>;
          print('first keys: ${first.keys.toList()}');
          print('album_name: ${first['album_name']}');
          print('author_name: ${first['author_name']}');
          print('sample: ${jsonEncode(first).substring(0, 400)}');
        }
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  print('\n=== 4. ArtistApi.albums - 原始响应 ===');
  try {
    final result = await api.client.post<Map<String, dynamic>>(
      '/kmr/v1/author/albums',
      body: {
        'author_id': 3069,
        'pagesize': 5,
        'page': 1,
        'sort': 3,
        'category': 1,
        'area_code': 'all',
      },
      router: 'openapi.kugou.com',
      encryptType: EncryptType.android,
      headers: {'kg-tid': '36'},
    );
    print('status: ${result['status']}');
    if (result['status'] == 1) {
      final data = result['data'];
      print('data type: ${data.runtimeType}');
      if (data is Map) {
        print('data keys: ${data.keys.toList()}');
        print('sample: ${jsonEncode(data).substring(0, 300)}');
      } else if (data is List) {
        print('data is List, length: ${data.length}');
        if (data.isNotEmpty) print('first: ${jsonEncode(data[0]).substring(0, 200)}');
      }
    }
  } catch (e) {
    print('Error: $e');
  }

  api.httpClient.close();
}
