import 'package:json_annotation/json_annotation.dart';

part 'lyric.g.dart';

/// 歌词格式枚举
enum LyricFormat {
  /// LRC格式
  lrc,

  /// KRC格式（酷狗逐字歌词）
  krc,

  /// JSON格式
  json
}

/// 歌词搜索结果
@JsonSerializable()
class LyricSearchResult {
  /// 候选歌词列表
  final List<LyricItem>? candidates;

  /// 候选数量
  final int? count;

  /// Creates a new [LyricSearchResult] instance.
  LyricSearchResult({this.candidates, this.count});

  /// Creates a [LyricSearchResult] from JSON data.
  factory LyricSearchResult.fromJson(Map<String, dynamic> json) =>
      _$LyricSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$LyricSearchResultToJson(this);
}

/// 歌词候选项
@JsonSerializable()
class LyricItem {
  /// 歌词ID
  final String? id;

  /// 访问密钥
  final String? accesskey;

  /// 歌曲时长
  final int? duration;

  /// 歌曲名称
  final String? song;

  /// 歌手名称
  final String? singer;

  /// LRC歌词内容
  @JsonKey(name: 'lrc_content')
  final String? lrcContent;

  /// Creates a new [LyricItem] instance.
  LyricItem({
    this.id,
    this.accesskey,
    this.duration,
    this.song,
    this.singer,
    this.lrcContent,
  });

  /// Creates a [LyricItem] from JSON data.
  factory LyricItem.fromJson(Map<String, dynamic> json) =>
      _$LyricItemFromJson(json);
  Map<String, dynamic> toJson() => _$LyricItemToJson(this);
}

/// 歌词内容结果
@JsonSerializable()
class LyricResult {
  /// 歌词内容
  final String? content;

  /// 歌词格式
  final String? format;

  /// 提示信息
  final String? info;

  /// 状态码
  final int? status;

  /// 错误码
  @JsonKey(name: 'error_code')
  final int? errorCode;

  /// 字符编码
  final String? charset;

  /// 内容类型
  final int? contenttype;

  /// 格式标识
  final String? fmt;

  /// Creates a new [LyricResult] instance.
  LyricResult({
    this.content,
    this.format,
    this.info,
    this.status,
    this.errorCode,
    this.charset,
    this.contenttype,
    this.fmt,
  });

  /// Creates a [LyricResult] from JSON data.
  factory LyricResult.fromJson(Map<String, dynamic> json) =>
      _$LyricResultFromJson(json);
  Map<String, dynamic> toJson() => _$LyricResultToJson(this);
}
