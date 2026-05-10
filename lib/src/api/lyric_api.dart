import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../crypto/krc_decrypt.dart';
import '../models/lyric.dart';

/// 歌词相关接口
class LyricApi extends BaseApi {
  /// 构造歌词 API 实例
  LyricApi(super.client);

  /// 搜索歌词，[keyword] 为搜索关键词，[duration] 为歌曲时长（毫秒），[hash] 为歌曲哈希值
  Future<LyricSearchResult> search({
    required String keyword,
    int? duration,
    String? hash,
  }) async {
    return client.get<LyricSearchResult>(
      '/search',
      params: {
        'ver': 1,
        'man': 'yes',
        'client': 'mobi',
        'keyword': keyword,
        'page': 1,
        'pagesize': 10,
        if (hash != null) 'hash': hash,
        if (duration != null) 'duration': duration,
      },
      baseURL: 'https://lyrics.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => _parseLyricSearchResult(json, keyword),
    );
  }

  /// 获取歌词内容，[id] 为歌词 ID，[accesskey] 为访问密钥，[format] 为歌词格式（krc/lrc）
  Future<LyricResult> get({
    required String id,
    required String accesskey,
    LyricFormat format = LyricFormat.krc,
  }) async {
    final fmtStr = format == LyricFormat.krc ? 'krc' : 'lrc';
    return client.get<LyricResult>(
      '/download',
      params: {
        'ver': 1,
        'client': 'android',
        'id': id,
        'accesskey': accesskey,
        'fmt': fmtStr,
        'charset': 'utf8',
      },
      baseURL: 'https://lyrics.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) {
        final content = json['content'] as String?;
        if (content != null && format == LyricFormat.krc) {
          try {
            final decoded = base64Decode(content);
            final decrypted = decryptKrc(decoded);
            json['content'] = decrypted;
            json['format'] = 'krc';
          } catch (_) {
            json['format'] = 'krc_raw';
          }
        } else if (content != null && format == LyricFormat.lrc) {
          try {
            final decoded = utf8.decode(base64Decode(content));
            json['content'] = decoded;
            json['format'] = 'lrc';
          } catch (_) {
            json['format'] = 'lrc_raw';
          }
        } else {
          json['format'] = 'json';
        }
        return LyricResult.fromJson(json);
      },
    );
  }

  LyricSearchResult _parseLyricSearchResult(dynamic json, String keyword) {
    if (json is! Map<String, dynamic>) {
      return LyricSearchResult();
    }
    final candidates = json['candidates'];
    if (candidates is List) {
      final items = candidates
          .whereType<Map<String, dynamic>>()
          .map((e) => LyricItem(
                id: e['id']?.toString(),
                accesskey: e['accesskey'] as String?,
                song: e['song'] as String?,
                singer: e['singer'] as String?,
                duration: e['duration'] as int?,
              ))
          .toList();
      return LyricSearchResult(candidates: items);
    }
    return LyricSearchResult.fromJson(json);
  }
}
