import 'dart:convert';

import 'package:http/http.dart' as http;

import '../client/base_api.dart';
import '../crypto/signature.dart';
import '../exception.dart';
import '../models/images.dart';

/// 图片相关接口
class ImagesApi extends BaseApi {
  /// 构造图片 API 实例
  ImagesApi(super.client);

  /// 获取专辑封面图片，[hash] 为歌曲哈希值，[albumId] 为专辑 ID，[count] 为图片数量
  Future<AlbumImagesResult> albumImages({
    required String hash,
    String? albumId,
    String? albumAudioId,
    int count = 5,
  }) async {
    final hashes = hash.split(',');
    final albumIds = albumId?.split(',') ?? [];
    final albumAudioIds = albumAudioId?.split(',') ?? [];

    final data = hashes.asMap().entries.map((entry) {
      final index = entry.key;
      final h = entry.value;
      return <String, dynamic>{
        'album_id': index < albumIds.length && albumIds[index].isNotEmpty ? albumIds[index] : 0,
        'hash': h,
        'album_audio_id': index < albumAudioIds.length && albumAudioIds[index].isNotEmpty ? albumAudioIds[index] : 0,
      };
    }).toList();

    final paramsMap = <String, dynamic>{
      'album_image_type': '-3',
      'appid': client.httpClient.config.appid,
      'clientver': client.httpClient.config.clientver,
      'author_image_type': '3,4,5',
      'count': count,
      'data': data,
      'isCdn': 1,
      'publish_time': 1,
    };

    final signature = signatureAndroidParams(paramsMap, null, client.httpClient.config.isLite);

    final sortedKeys = paramsMap.keys.toList()..sort();
    final query = sortedKeys.map((key) {
      final value = paramsMap[key];
      final strValue = value is Map || value is List ? jsonEncode(value) : value.toString();
      return '$key=${Uri.encodeComponent(strValue)}';
    }).join('&');

    final url = 'https://expendablekmr.kugou.com/container/v2/image?$query&signature=$signature';

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
      return AlbumImagesResult.fromJson(dataField);
    }
    return AlbumImagesResult.fromJson(result);
  }

  /// 获取歌手/音频相关图片，[hash] 为歌曲哈希值，[audioId] 为音频 ID，[count] 为图片数量
  Future<AudioImagesResult> audioImages({
    required String hash,
    String? audioId,
    String? albumAudioId,
    String? filename,
    int count = 5,
  }) async {
    final hashes = hash.split(',');
    final audioIds = audioId?.split(',') ?? [];
    final albumAudioIds = albumAudioId?.split(',') ?? [];
    final filenames = filename?.split(',') ?? [];

    final data = hashes.asMap().entries.map((entry) {
      final index = entry.key;
      final h = entry.value;
      return <String, dynamic>{
        'audio_id': index < audioIds.length && audioIds[index].isNotEmpty ? audioIds[index] : 0,
        'hash': h,
        'album_audio_id': index < albumAudioIds.length && albumAudioIds[index].isNotEmpty ? albumAudioIds[index] : 0,
        'filename': index < filenames.length ? filenames[index] : '',
      };
    }).toList();

    final paramsMap = <String, dynamic>{
      'appid': client.httpClient.config.appid,
      'clientver': client.httpClient.config.clientver,
      'count': count,
      'data': data,
      'isCdn': 1,
      'publish_time': 1,
      'show_authors': 1,
    };

    final signature = signatureAndroidParams(paramsMap, null, client.httpClient.config.isLite);

    final sortedKeys = paramsMap.keys.toList()..sort();
    final query = sortedKeys.map((key) {
      final value = paramsMap[key];
      final strValue = value is Map || value is List ? jsonEncode(value) : value.toString();
      return '$key=${Uri.encodeComponent(strValue)}';
    }).join('&');

    final url = 'https://expendablekmr.kugou.com/v2/author_image/audio?$query&signature=$signature';

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
    if (dataField is List) {
      return AudioImagesResult(data: dataField.whereType<Map<String, dynamic>>().map((e) => AudioImageItem.fromJson(e)).toList());
    }
    if (dataField is Map<String, dynamic>) {
      return AudioImagesResult.fromJson(dataField);
    }
    return AudioImagesResult.fromJson(result);
  }
}
