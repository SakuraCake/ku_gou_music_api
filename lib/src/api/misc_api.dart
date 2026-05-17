import 'dart:convert';

import 'package:http/http.dart' as http;

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../crypto/signature.dart';
import '../models/misc.dart';

/// 杂项相关接口
class MiscApi extends BaseApi {
  /// 构造杂项 API 实例
  MiscApi(super.client);

  /// 获取歌手分类列表，[type] 为分类类型，[sex] 为性别筛选（-1 全部/0 男/1 女）
  Future<SingerListResult> singerList({int type = 0, int sex = -1}) async {
    return client.get<SingerListResult>(
      '/ocean/v6/singer/list',
      params: {
        'hotsize': 200,
        'musician': 0,
        'sextype': sex,
        'showtype': 2,
        'type': type,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SingerListResult.fromJson(json),
    );
  }

  /// 获取最新歌曲列表，需要登录
  Future<LatestSongsResult> latestSongs() async {
    return client.post<LatestSongsResult>(
      '/playque/devque/v1/get_latest_songs',
      body: {
        'area_code': '1',
        'sources': ['pc', 'mobile', 'tv', 'car'],
        'userid': client.httpClient.userid ?? 0,
        'ret_info': 1,
        'token': client.httpClient.token ?? '',
        'pagesize': 30,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => LatestSongsResult.fromJson(json),
    );
  }

  /// 获取服务器当前时间，需要登录
  Future<ServerNowResult> serverNow() async {
    return client.post<ServerNowResult>(
      '/v1/server_now',
      body: {
        'token': client.httpClient.token ?? '',
        'userid': client.httpClient.userid ?? 0,
      },
      params: {'plat': 3},
      router: 'usercenter.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => ServerNowResult.fromJson(json),
    );
  }

  /// 获取歌曲权限精简信息，[hash] 为歌曲哈希值，多个以逗号分隔
  Future<PrivilegeLiteResult> privilegeLite({required String hash, int? albumId}) async {
    final resource = hash.split(',').map((s) => <String, dynamic>{
      'type': 'audio',
      'page_id': 0,
      'hash': s,
      'album_id': albumId ?? 0,
    }).toList();
    return client.post<PrivilegeLiteResult>(
      '/v2/get_res_privilege/lite',
      body: {
        'appid': client.httpClient.config.appid,
        'area_code': 1,
        'behavior': 'play',
        'clientver': client.httpClient.config.clientver,
        'need_hash_offset': 1,
        'relate': 1,
        'support_verify': 1,
        'resource': resource,
        'qualities': ['128', '320', 'flac', 'high', 'viper_atmos', 'viper_tape', 'viper_clear', 'super', 'multitrack'],
      },
      router: 'media.store.kugou.com',
      encryptType: EncryptType.android,
      headers: {'Content-Type': 'application/json'},
      fromJson: (json) => PrivilegeLiteResult.fromJson(json),
    );
  }

  /// 刷一刷推荐，获取个性化推荐歌曲
  Future<BrushResult> brush({int? songPoolId}) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    final personalRecommend = <String, dynamic>{
      'userid': client.httpClient.userid ?? 0,
      'appid': client.httpClient.config.appid,
      'playlist_ver': 2,
      'clienttime': dateTime,
      'mid': client.httpClient.mid,
      'new_sync_point': dateTime,
      'module_id': 1,
      'action': 'login',
      'vip_type': 0,
      'vip_flags': 3,
      'recommend_source_locked': 0,
      'song_pool_id': songPoolId ?? 0,
      'callerid': 0,
      'm_type': 1,
      'kguid': client.httpClient.userid ?? 0,
      'platform': 'ios',
      'area_code': 1,
      'fakem': 'ca981cfc583a4c37f28d2d49000013c16a0a',
      'clientver': 11850,
      'mode': 'normal',
      'active_swtich': 'on',
      'key': key,
    };
    return client.post<BrushResult>(
      '/genesisapi/v1/newepoch_song_rec/feed',
      body: {
        'behaviors': [],
        'abtest': {
          'abtest': {
            'shuashua': {'commentcard': 2},
          },
        },
        'personal_recommend_params': personalRecommend,
      },
      params: {
        'sort_type': 1,
        'platform': 'ios',
        'page': 1,
        'content_ver': 4,
        'clientver': 11850,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => BrushResult.fromJson(json),
    );
  }

  Future<Map<String, dynamic>> registerDev() async {
    final guid = client.httpClient.mid;

    final dataMap = <String, dynamic>{
      'availableRamSize': 4983533568,
      'availableRomSize': 48114719,
      'availableSDSize': 48114717,
      'basebandVer': '',
      'batteryLevel': 100,
      'batteryStatus': 3,
      'brand': 'Redmi',
      'buildSerial': 'unknown',
      'device': 'marble',
      'imei': guid,
      'imsi': '',
      'manufacturer': 'Xiaomi',
      'uuid': client.httpClient.uuid,
      'accelerometer': false,
      'accelerometerValue': '',
      'gravity': false,
      'gravityValue': '',
      'gyroscope': false,
      'gyroscopeValue': '',
      'light': false,
      'lightValue': '',
      'magnetic': false,
      'magneticValue': '',
      'orientation': false,
      'orientationValue': '',
      'pressure': false,
      'pressureValue': '',
      'step_counter': false,
      'step_counterValue': '',
      'temperature': false,
      'temperatureValue': '',
    };

    final aesEncrypt = playlistAesEncrypt(dataMap);
    final p = rsaEncrypt2({
      'aes': aesEncrypt['key'],
      'uid': client.httpClient.userid ?? 0,
      'token': client.httpClient.token ?? '',
    });

    final allParams = client.httpClient.buildRequestParams(
      params: {'part': 1, 'platid': 1, 'p': p},
      encryptType: EncryptType.android,
      encryptKey: false,
      notSignature: false,
      clearDefaultParams: false,
      data: aesEncrypt['str'],
    );

    final clienttime = allParams['clienttime'] as int? ??
        DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final allHeaders = client.httpClient.buildHeaders(clienttime: clienttime);

    final queryString = allParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    final uri = Uri.parse(
      'https://userservice.kugou.com/risk/v2/r_register_dev?$queryString',
    );

    final request = http.Request('POST', uri)..headers.addAll(allHeaders);
    request.body = aesEncrypt['str']!;

    final cookieHeader =
        client.httpClient.cookieJar.getCookiesForUrl(uri.toString());
    if (cookieHeader.isNotEmpty) {
      request.headers['Cookie'] = cookieHeader;
    }

    final response = await client.httpClient.innerClient.send(request);
    final responseBody = await response.stream.toBytes();
    final responseBase64 = base64Encode(responseBody);
    final decrypted = playlistAesDecrypt(responseBase64, aesEncrypt['key']!);

    if (decrypted is Map<String, dynamic>) {
      if (decrypted['status'] == 1 && decrypted['data'] != null) {
        final data = decrypted['data'];
        if (data is Map<String, dynamic> && data['dfid'] != null) {
          client.httpClient.dfid = data['dfid'].toString();
        }
      }
      return decrypted;
    }

    return {'raw': decrypted};
  }

  Future<Map<String, dynamic>> pcDiantai() async {
    return client.post<Map<String, dynamic>>(
      '/v3/pc_diantai',
      body: {
        'isvip': 0,
        'userid': client.httpClient.userid ?? 0,
        'vipType': 0,
      },
      baseURL: 'https://adservice.kugou.com',
      encryptType: EncryptType.android,
    );
  }
}
