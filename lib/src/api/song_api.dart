import 'dart:convert';

import 'package:http/http.dart' as http;

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/signature.dart';
import '../exception.dart';
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
    final qualityValue = quality == AudioQuality.magic
        ? 'magic_piano'
        : quality.value.toString();

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

  /// 获取歌曲高潮片段（已废弃），API 已下线，CDN 服务器返回 missing all client info，暂不可用
  @Deprecated('API 已下线，CDN 服务器返回 missing all client info，暂不可用')
  Future<SongClimaxResult> climax({required String hash}) async {
    final data = hash.split(',').map((s) => {'hash': s}).toList();

    final paramsMap = <String, dynamic>{
      'appid': client.httpClient.config.appid,
      'clientver': client.httpClient.config.clientver,
      'data': data,
    };

    final signature = signatureAndroidParams(paramsMap, null, client.httpClient.config.isLite);

    final sortedKeys = paramsMap.keys.toList()..sort();
    final query = sortedKeys.map((key) {
      final value = paramsMap[key];
      final strValue = value is Map || value is List ? jsonEncode(value) : value.toString();
      return '$key=${Uri.encodeComponent(strValue)}';
    }).join('&');

    final url = 'https://expendablekmrcdn.kugou.com/v1/audio_climax/audio?$query&signature=$signature';

    final response = await http.get(Uri.parse(url));
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    if (result['status'] != 1) {
      throw KuGouApiException(
        status: result['status'] as int? ?? 0,
        code: result['error_code'] as int? ?? result['errcode'] as int? ?? 0,
        message: result['errmsg']?.toString() ?? result['error_msg']?.toString() ?? '',
      );
    }
    final dataField = result['data'];
    if (dataField is Map<String, dynamic>) {
      return SongClimaxResult.fromJson(dataField);
    }
    return SongClimaxResult.fromJson(result);
  }

  /// 获取歌曲排名信息，[albumAudioId] 为专辑音频 ID
  Future<SongRankingResult> ranking({required int albumAudioId}) async {
    return client.get<SongRankingResult>(
      '/grow/v1/song_ranking/play_page/ranking_info',
      params: {
        'album_audio_id': albumAudioId,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SongRankingResult.fromJson(json),
    );
  }

  /// 获取歌曲排名筛选（已废弃），API 返回参数错误，可能需要登录或已下线，暂不可用
  @Deprecated('API 返回参数错误，可能需要登录或已下线，暂不可用')
  Future<SongRankingFilterResult> rankingFilter({
    required int albumAudioId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.get<SongRankingFilterResult>(
      '/grow/v1/song_ranking/unlock/v2/ranking_filter',
      params: {
        'album_audio_id': albumAudioId,
        'page': page,
        'pagesize': pagesize,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => SongRankingFilterResult.fromJson(json),
    );
  }
}
