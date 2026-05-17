import 'dart:convert';
import '../config.dart';
import '../config/constants.dart';
import '../client/base_api.dart';
import '../client/http_client.dart';
import '../client/api_client.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../crypto/signature.dart';
import '../util/logger.dart';
import '../util/cache.dart';
import '../util/random.dart';

class YouthApi extends BaseApi {
  YouthApi(super.client);

  KuGouHttpClient get _liteHttp {
    return KuGouHttpClient(
      config: KuGouConfig(platform: Platform.lite),
      token: client.httpClient.token,
      userid: client.httpClient.userid,
      dfid: client.httpClient.dfid,
      mid: client.httpClient.mid,
      cookieJar: client.httpClient.cookieJar,
    );
  }

  Future<Map<String, dynamic>> channelAll({
    int page = 1,
    int pagesize = 30,
    int type = 1,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/v2/channel/channel_all_list',
      params: {
        'page': page,
        'pagesize': pagesize,
        'type': type,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> channelAmway({
    required String globalCollectionId,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/api/amway/v2/index',
      params: {
        'global_collection_id': globalCollectionId,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> channelDetail({
    required String globalCollectionId,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    final ids = globalCollectionId
        .split(',')
        .map((id) => {'global_collection_id': id.trim()})
        .toList();
    return liteClient.post<Map<String, dynamic>>(
      '/youth/api/channel/v1/channel_list_by_id',
      body: {
        'data': ids,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> channelSimilar({
    required String channelId,
    int vipType = 0,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.post<Map<String, dynamic>>(
      '/youth/v1/channel/get_friendly_channel',
      params: {
        'channel_id': channelId,
        'vip_type': vipType,
      },
      body: {
        'area_code': 1,
        'playlist_ver': 2,
        'vip_type': vipType,
        'platform': 'ios',
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> channelSubscribe({
    required String globalCollectionId,
    required bool subscribe,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    final path = subscribe
        ? '/youth/v1/channel_subscribe'
        : '/youth/v1/channel_un_subscribe';
    return liteClient.post<Map<String, dynamic>>(
      path,
      params: {
        'global_collection_id': globalCollectionId,
        'source': 1,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> channelSong({
    required String globalCollectionId,
    int page = 1,
    int pagesize = 30,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/api/channel/v1/channel_get_song_audit_passed',
      params: {
        'global_collection_id': globalCollectionId,
        'page': page,
        'pagesize': pagesize,
        'is_filter': 0,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> channelSongDetail({
    required String globalCollectionId,
    required String fileId,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/v2/post/get_song_detail',
      params: {
        'global_collection_id': globalCollectionId,
        'file_id': fileId,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> dayVip({
    required int receiveDay,
    int sourceId = 90139,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.post<Map<String, dynamic>>(
      '/youth/v1/recharge/receive_vip_listen_song',
      params: {
        'source_id': sourceId,
        'receive_day': receiveDay,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> dayVipUpgrade({
    int adType = 1,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.post<Map<String, dynamic>>(
      '/youth/v1/listen_song/upgrade_vip_reward',
      params: {
        'kugouid': client.httpClient.userid ?? 0,
        'ad_type': adType,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> dynamic$() async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/v3/user/get_dynamic',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> dynamicRecent() async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/v3/user/recent_dynamic',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> listenSong({
    int mixsongid = 666075191,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.post<Map<String, dynamic>>(
      '/youth/v2/report/listen_song',
      params: {
        'clientver': 10566,
      },
      body: {
        'mixsongid': mixsongid,
      },
      headers: {
        'user-agent': 'Android13-1070-10566-201-0-ReportPlaySongToServerProtocol-wifi',
        'content-type': 'application/json; charset=utf-8',
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> monthVipRecord() async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/v1/activity/get_month_vip_record',
      params: {
        'latest_limit': 100,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> unionVip() async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/v1/get_union_vip',
      params: {
        'busi_type': 'concept',
        'opt_product_types': 'dvip,qvip',
        'product_type': 'svip',
      },
      baseURL: 'https://kugouvip.kugou.com',
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> vip() async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return liteClient.post<Map<String, dynamic>>(
      '/youth/v1/ad/play_report',
      body: {
        'ad_id': 12307537187,
        'play_end': currentTime,
        'play_start': currentTime - 30000,
      },
      encryptType: EncryptType.android,
    );
  }

  Future<Map<String, dynamic>> userSong({
    required int userid,
    int type = 0,
    int page = 1,
    int pagesize = 30,
  }) async {
    final liteClient = ApiClient(
      httpClient: _liteHttp,
      logger: Logger(minLevel: LogLevel.none),
      cache: MemoryCache(maxSize: 10),
    );
    return liteClient.get<Map<String, dynamic>>(
      '/youth/v1/get_user_song_public',
      params: {
        'userid': userid,
        'type': type,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
    );
  }
}
