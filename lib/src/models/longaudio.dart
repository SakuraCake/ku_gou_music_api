import 'package:json_annotation/json_annotation.dart';

part 'longaudio.g.dart';

/// 长音频详情结果
@JsonSerializable()
class LongaudioDetailResult {
  /// 长音频专辑列表
  final List<LongaudioAlbumItem>? data;

  /// Creates a new [LongaudioDetailResult] instance.
  LongaudioDetailResult({this.data});

  /// Creates a [LongaudioDetailResult] from JSON data.
  factory LongaudioDetailResult.fromJson(Map<String, dynamic> json) => _$LongaudioDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioDetailResultToJson(this);
}

/// 长音频专辑条目
@JsonSerializable()
class LongaudioAlbumItem {
  /// 专辑ID
  @JsonKey(name: 'album_id', fromJson: _parseInt)
  final int? albumId;

  /// 专辑名称
  @JsonKey(name: 'album_name')
  final String? albumName;

  /// 分类
  final String? category;

  /// 作者列表
  final dynamic authors;

  /// 高清封面地址
  @JsonKey(name: 'sizable_cover')
  final String? sizableCover;

  /// 简介
  final String? intro;

  /// 作者名称
  @JsonKey(name: 'author_name')
  final String? authorName;

  /// 是否已发布
  @JsonKey(name: 'is_publish', fromJson: _parseInt)
  final int? isPublish;

  /// 专辑标签
  @JsonKey(name: 'album_tag')
  final dynamic albumTag;

  /// 混合简介
  @JsonKey(name: 'mix_intro')
  final String? mixIntro;

  /// 完整简介
  @JsonKey(name: 'full_intro')
  final String? fullIntro;

  /// 传输参数
  @JsonKey(name: 'trans_param')
  final dynamic transParam;

  /// Creates a new [LongaudioAlbumItem] instance.
  LongaudioAlbumItem({
    this.albumId,
    this.albumName,
    this.category,
    this.authors,
    this.sizableCover,
    this.intro,
    this.authorName,
    this.isPublish,
    this.albumTag,
    this.mixIntro,
    this.fullIntro,
    this.transParam,
  });

  /// Creates a [LongaudioAlbumItem] from JSON data.
  factory LongaudioAlbumItem.fromJson(Map<String, dynamic> json) => _$LongaudioAlbumItemFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioAlbumItemToJson(this);
}

/// 长音频音频列表结果
@JsonSerializable()
class LongaudioAudiosResult {
  /// 音频列表
  final List<LongaudioAudioItem>? info;

  /// Creates a new [LongaudioAudiosResult] instance.
  LongaudioAudiosResult({this.info});

  /// Creates a [LongaudioAudiosResult] from JSON data.
  factory LongaudioAudiosResult.fromJson(Map<String, dynamic> json) => _$LongaudioAudiosResultFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioAudiosResultToJson(this);
}

/// 长音频音频条目
@JsonSerializable()
class LongaudioAudioItem {
  /// 音频ID
  @JsonKey(name: 'audio_id', fromJson: _parseInt)
  final int? audioId;

  /// 歌曲哈希值
  final String? hash;

  /// 文件名
  @JsonKey(name: 'file_name')
  final String? fileName;

  /// 时长（秒）
  @JsonKey(fromJson: _parseInt)
  final int? duration;

  /// 专辑ID
  @JsonKey(name: 'album_id', fromJson: _parseInt)
  final int? albumId;

  /// 音频名称
  @JsonKey(name: 'audio_name')
  final String? audioName;

  /// Creates a new [LongaudioAudioItem] instance.
  LongaudioAudioItem({
    this.audioId,
    this.hash,
    this.fileName,
    this.duration,
    this.albumId,
    this.audioName,
  });

  /// Creates a [LongaudioAudioItem] from JSON data.
  factory LongaudioAudioItem.fromJson(Map<String, dynamic> json) => _$LongaudioAudioItemFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioAudioItemToJson(this);
}

/// 长音频每日推荐结果
@JsonSerializable()
class LongaudioDailyResult {
  /// 每日推荐数据
  final Map<String, dynamic>? data;

  /// Creates a new [LongaudioDailyResult] instance.
  LongaudioDailyResult({this.data});

  /// Creates a [LongaudioDailyResult] from JSON data.
  factory LongaudioDailyResult.fromJson(Map<String, dynamic> json) => _$LongaudioDailyResultFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioDailyResultToJson(this);
}

/// 长音频排行结果
@JsonSerializable()
class LongaudioRankResult {
  /// 排行数据
  final dynamic data;

  /// Creates a new [LongaudioRankResult] instance.
  LongaudioRankResult({this.data});

  /// Creates a [LongaudioRankResult] from JSON data.
  factory LongaudioRankResult.fromJson(Map<String, dynamic> json) => _$LongaudioRankResultFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioRankResultToJson(this);
}

/// 长音频VIP推荐结果
@JsonSerializable()
class LongaudioVipResult {
  /// VIP推荐数据
  final Map<String, dynamic>? data;

  /// Creates a new [LongaudioVipResult] instance.
  LongaudioVipResult({this.data});

  /// Creates a [LongaudioVipResult] from JSON data.
  factory LongaudioVipResult.fromJson(Map<String, dynamic> json) => _$LongaudioVipResultFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioVipResultToJson(this);
}

/// 长音频每周推荐结果
@JsonSerializable()
class LongaudioWeekResult {
  /// 每周推荐数据
  final Map<String, dynamic>? data;

  /// Creates a new [LongaudioWeekResult] instance.
  LongaudioWeekResult({this.data});

  /// Creates a [LongaudioWeekResult] from JSON data.
  factory LongaudioWeekResult.fromJson(Map<String, dynamic> json) => _$LongaudioWeekResultFromJson(json);
  Map<String, dynamic> toJson() => _$LongaudioWeekResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
