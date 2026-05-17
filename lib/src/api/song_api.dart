import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../config/constants.dart';
import '../crypto/md5.dart';
import '../crypto/signature.dart';
import '../models/song.dart';
import '../util/random.dart';

/// 歌曲相关接口
class SongApi extends BaseApi {
  /// 构造歌曲 API 实例
  SongApi(super.client);

  /// 获取歌曲播放地址，[hash] 为歌曲哈希值，[quality] 为音质，[freePart] 是否试听
  Future<SongUrl> url({
    required String hash,
    int albumId = 0,
    int albumAudioId = 0,
    AudioQuality quality = AudioQuality.standard,
    bool freePart = false,
  }) async {
    final isLite = client.httpClient.config.isLite;
    String qualityValue;
    if (quality == AudioQuality.magic) {
      qualityValue = 'magic_piano';
    } else if (quality == AudioQuality.lossless) {
      qualityValue = 'flac';
    } else {
      qualityValue = quality.value.toString();
    }

    final randomDfid = randomString(24);
    return client.get<SongUrl>(
      '/v5/url',
      params: {
        'hash': hash.toLowerCase(),
        'album_id': albumId,
        'album_audio_id': albumAudioId,
        'quality': qualityValue,
        'area_code': 1,
        'ssa_flag': 'is_fromtrack',
        'version': 11430,
        'page_id': isLite ? 967177915 : 151369488,
        'behavior': 'play',
        'pid': isLite ? 411 : 2,
        'cmd': 26,
        'pidversion': 3001,
        'IsFreePart': freePart ? 1 : 0,
        'ppage_id': isLite
            ? '356753938,823673182,967485191'
            : '463467626,350369493,788954147',
        'cdnBackup': 1,
        'module': '',
        'clientver': 11430,
        'dfid': randomDfid,
      },
      headers: {'dfid': randomDfid},
      router: 'trackercdn.kugou.com',
      encryptKey: true,
      encryptType: EncryptType.android,
      fromJson: (json) => SongUrl.fromJson(json),
    );
  }

  /// 批量获取歌曲详情，[hashes] 为歌曲哈希值列表
  Future<List<SongDetail>> detail({
    required List<String> hashes,
    int albumId = 0,
  }) async {
    final dateTime = DateTime.now().millisecondsSinceEpoch;
    final data = hashes.map((h) => {'hash': h, 'audio_id': 0}).toList();
    final key = signParams(
      dateTime.toString(),
      appid: client.httpClient.config.appid,
      clientver: client.httpClient.config.clientver,
      isLite: client.httpClient.config.isLite,
    );
    final result = await client.post<Map<String, dynamic>>(
      '/v1/audio/audio',
      body: {
        'appid': client.httpClient.config.appid,
        'clienttime': dateTime,
        'clientver': client.httpClient.config.clientver,
        'data': data,
        'dfid': client.httpClient.dfid,
        'key': key,
        'mid': client.httpClient.mid,
      },
      baseURL: 'http://kmr.service.kugou.com',
      router: 'kmr.service.kugou.com',
      encryptType: EncryptType.android,
    );
    final responseData = result['data'];
    if (responseData is List) {
      return responseData
          .map((e) => SongDetail.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// 获取歌曲排名信息，[albumAudioId] 为专辑音频 ID
  Future<SongRankingResult> ranking({required int albumAudioId}) async {
    return client.get<SongRankingResult>(
      '/grow/v1/song_ranking/play_page/ranking_info',
      params: {'album_audio_id': albumAudioId},
      encryptType: EncryptType.android,
      fromJson: (json) => SongRankingResult.fromJson(json),
    );
  }

  /// 获取歌曲私有播放地址（新版接口）
  ///
  /// [hash] 歌曲哈希值
  /// [albumAudioId] 专辑音频ID
  /// [qualities] 请求的音质列表，默认请求所有音质
  /// [freePart] 是否获取免费试听部分
  ///
  /// 返回包含多种音质的播放地址信息，包括128k、320k、flac、high等
  Future<SongPrivUrlResult> privUrl({
    required String hash,
    int? albumAudioId,
    List<String>? qualities,
    bool freePart = false,
  }) async {
    final token = client.httpClient.token ?? '';
    final userid = client.httpClient.userid ?? 0;
    final dfid = client.httpClient.dfid;
    final clienttimeMs = DateTime.now().millisecondsSinceEpoch;

    final key = cryptoMd5(
      '$hash$kLiteSignKeySalt'
      '${client.httpClient.config.appid}'
      '${client.httpClient.mid}'
      '$userid',
    );

    return client.post<SongPrivUrlResult>(
      '/v6/priv_url',
      baseURL: 'http://tracker.kugou.com',
      body: {
        'appid': client.httpClient.config.appid,
        'clientver': client.httpClient.config.clientver,
        'area_code': '1',
        'behavior': 'play',
        'qualities': qualities ?? ['128', '320', 'flac', 'high', 'super'],
        'resource': {
          'album_audio_id': albumAudioId ?? 0,
          'collect_list_id': '3',
          'collect_time': clienttimeMs,
          'hash': hash.toLowerCase(),
          'id': 0,
          'page_id': 1,
          'type': 'audio',
        },
        'token': token,
        'dfid': dfid,
        'mid': client.httpClient.mid,
        'tracker_param': {
          'all_m': 1,
          'auth': '',
          'is_free_part': freePart ? 1 : 0,
          'key': key,
          'module_id': 0,
          'need_climax': 1,
          'need_xcdn': 1,
          'open_time': '',
          'pid': '411',
          'pidversion': '3001',
          'priv_vip_type': '6',
          'viptoken': '',
        },
        'userid': '$userid',
        'vip': 0,
      },
      headers: {'dfid': dfid},
      notSignature: true,
      clearDefaultParams: true,
      fromJson: (json) => _parsePrivUrlResult(json),
    );
  }

  SongPrivUrlResult _parsePrivUrlResult(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return SongPrivUrlResult(songs: []);
    }

    final songs = json['songs'] as List?;
    if (songs == null || songs.isEmpty) {
      return SongPrivUrlResult(
        status: json['status'] as int?,
        errorCode: json['error_code'] as int?,
        errorMsg: json['error_msg'] as String?,
        songs: [],
      );
    }

    final parsedSongs = songs.whereType<Map<String, dynamic>>().map((e) {
      final qualities = e['qualities'] as List?;
      final parsedQualities = qualities
          ?.whereType<Map<String, dynamic>>()
          .map(
            (q) => AudioQualityItem(
              quality: q['quality'] as String?,
              bitrate: _parseInt(q['bitrate']),
              fileSize: _parseInt(q['file_size']),
              extName: q['ext_name'] as String?,
              url: q['url'] as String?,
              backupUrl: (q['backup_url'] as List?)
                  ?.whereType<String>()
                  .toList(),
              privStatus: _parseInt(q['priv_status']),
            ),
          )
          .toList();

      return SongPrivUrlItem(
        hash: e['hash'] as String?,
        audioName: e['audio_name'] as String?,
        singerName: e['singer_name'] as String?,
        albumName: e['album_name'] as String?,
        timeLen: _parseInt(e['time_len']),
        qualities: parsedQualities,
      );
    }).toList();

    return SongPrivUrlResult(
      status: json['status'] as int?,
      errorCode: json['error_code'] as int?,
      errorMsg: json['error_msg'] as String?,
      songs: parsedSongs,
    );
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<Map<String, dynamic>> climax({required String hash}) async {
    final data = jsonEncode(hash.split(',').map((s) => {'hash': s}).toList());
    return client.get<Map<String, dynamic>>(
      '/v1/audio_climax/audio',
      params: {'data': data},
      baseURL: 'https://expendablekmrcdn.kugou.com',
      encryptType: EncryptType.android,
      notSignature: true,
    );
  }

  Future<Map<String, dynamic>> rankingFilter({
    required int albumAudioId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.get<Map<String, dynamic>>(
      '/grow/v1/song_ranking/unlock/v2/ranking_filter',
      params: {
        'album_audio_id': albumAudioId,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
    );
  }
}
