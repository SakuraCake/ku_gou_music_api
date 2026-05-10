import 'package:json_annotation/json_annotation.dart';

part 'song.g.dart';

/// 音频音质枚举
enum AudioQuality {
  /// 标准音质 128kbps
  @JsonValue(128)
  standard(128, '标准'),

  /// 超高音质 320kbps
  @JsonValue(320)
  high(320, '超高'),

  /// 无损音质 FLAC
  @JsonValue(999)
  lossless(999, '无损'),

  /// 魔法音效
  magic(0, '魔法音效');

  const AudioQuality(this.value, this.label);

  /// 音质对应的比特率值
  final int value;

  /// 音质显示名称
  final String label;
}

/// 歌曲基本信息
@JsonSerializable()
class Song {
  /// 歌曲哈希值
  final String? hash;

  /// 专辑ID
  @JsonKey(name: 'album_id', fromJson: _parseInt)
  final int? albumId;

  /// 专辑音频ID
  @JsonKey(name: 'album_audio_id', fromJson: _parseInt)
  final int? albumAudioId;

  /// 歌曲名称
  final String? name;

  /// 歌手名称
  final String? singer;

  /// 歌曲时长（秒）
  @JsonKey(fromJson: _parseInt)
  final int? duration;

  /// 歌曲名
  @JsonKey(name: 'song_name')
  final String? songName;

  /// 所属者名称
  @JsonKey(name: 'owner_name')
  final String? ownerName;

  /// 封面图片地址
  final String? img;

  /// 320kbps音质哈希值
  @JsonKey(name: '320hash')
  final String? hash320;

  /// 无损音质哈希值
  @JsonKey(name: 'sqhash')
  final String? sqHash;

  /// Creates a new [Song] instance.
  Song({
    this.hash,
    this.albumId,
    this.albumAudioId,
    this.name,
    this.singer,
    this.duration,
    this.songName,
    this.ownerName,
    this.img,
    this.hash320,
    this.sqHash,
  });

  /// Creates a [Song] from JSON data.
  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
  Map<String, dynamic> toJson() => _$SongToJson(this);
}

/// 歌曲详细信息
@JsonSerializable()
class SongDetail {
  /// 歌曲哈希值
  final String? hash;

  /// 专辑ID
  @JsonKey(name: 'album_id', fromJson: _parseInt)
  final int? albumId;

  /// 音频名称
  @JsonKey(name: 'audio_name')
  final String? audioName;

  /// 歌曲名称
  final String? name;

  /// 歌手名称
  final String? singer;

  /// 歌曲时长（秒）
  @JsonKey(fromJson: _parseInt)
  final int? duration;

  /// 封面图片地址
  final String? img;

  /// 歌词内容
  final String? lyrics;

  /// 作者名称
  @JsonKey(name: 'author_name')
  final String? authorName;

  /// 专辑名称
  @JsonKey(name: 'album_name')
  final String? albumName;

  /// 音频ID
  @JsonKey(name: 'audio_id', fromJson: _parseInt)
  final int? audioId;

  /// 比特率
  @JsonKey(fromJson: _parseInt)
  final int? bitrate;

  /// 128kbps文件大小
  @JsonKey(name: 'filesize_128', fromJson: _parseInt)
  final int? filesize128;

  /// 320kbps文件大小
  @JsonKey(name: 'filesize_320', fromJson: _parseInt)
  final int? filesize320;

  /// FLAC文件大小
  @JsonKey(name: 'filesize_flac', fromJson: _parseInt)
  final int? filesizeFlac;

  /// 320kbps音质哈希值
  @JsonKey(name: 'hash_320')
  final String? hash320;

  /// FLAC音质哈希值
  @JsonKey(name: 'hash_flac')
  final String? hashFlac;

  /// 128kbps音质哈希值
  @JsonKey(name: 'hash_128')
  final String? hash128;

  /// 文件扩展名
  final String? extname;

  /// Creates a new [SongDetail] instance.
  SongDetail({
    this.hash,
    this.albumId,
    this.audioName,
    this.name,
    this.singer,
    this.duration,
    this.img,
    this.lyrics,
    this.authorName,
    this.albumName,
    this.audioId,
    this.bitrate,
    this.filesize128,
    this.filesize320,
    this.filesizeFlac,
    this.hash320,
    this.hashFlac,
    this.hash128,
    this.extname,
  });

  /// 显示名称，优先使用audioName
  String? get displayName => audioName ?? name;

  /// 显示歌手名，优先使用authorName
  String? get displaySinger => authorName ?? singer;

  /// Creates a [SongDetail] from JSON data.
  factory SongDetail.fromJson(Map<String, dynamic> json) =>
      _$SongDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SongDetailToJson(this);
}

/// 歌曲高潮部分结果
@JsonSerializable()
class SongClimaxResult {
  /// 高潮数据
  final dynamic data;

  /// Creates a new [SongClimaxResult] instance.
  SongClimaxResult({this.data});

  /// Creates a [SongClimaxResult] from JSON data.
  factory SongClimaxResult.fromJson(Map<String, dynamic> json) =>
      _$SongClimaxResultFromJson(json);
  Map<String, dynamic> toJson() => _$SongClimaxResultToJson(this);
}

/// 歌曲排行结果
@JsonSerializable()
class SongRankingResult {
  /// 排行数据
  final dynamic data;

  /// Creates a new [SongRankingResult] instance.
  SongRankingResult({this.data});

  /// Creates a [SongRankingResult] from JSON data.
  factory SongRankingResult.fromJson(Map<String, dynamic> json) =>
      _$SongRankingResultFromJson(json);
  Map<String, dynamic> toJson() => _$SongRankingResultToJson(this);
}

/// 歌曲排行筛选结果
@JsonSerializable()
class SongRankingFilterResult {
  /// 筛选数据
  final dynamic data;

  /// Creates a new [SongRankingFilterResult] instance.
  SongRankingFilterResult({this.data});

  /// Creates a [SongRankingFilterResult] from JSON data.
  factory SongRankingFilterResult.fromJson(Map<String, dynamic> json) =>
      _$SongRankingFilterResultFromJson(json);
  Map<String, dynamic> toJson() => _$SongRankingFilterResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

/// 歌曲播放地址信息
@JsonSerializable()
class SongUrl {
  /// 播放地址
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  final String? url;

  /// 备用播放地址列表
  @JsonKey(name: 'backupUrl', fromJson: _urlListFromJson)
  final List<String>? backupUrls;

  /// 歌曲哈希值
  final String? hash;

  /// 文件大小（字节）
  @JsonKey(fromJson: _parseInt)
  final int? fileSize;

  /// 文件扩展名
  final String? extName;

  /// 比特率
  @JsonKey(fromJson: _parseInt)
  final int? bitRate;

  /// 类型
  final int? type;

  /// 状态码
  final int? status;

  /// 权限状态
  @JsonKey(name: 'priv_status')
  final int? privStatus;

  /// 歌曲时长（毫秒）
  @JsonKey(name: 'timeLength', fromJson: _parseInt)
  final int? timeLength;

  /// 文件名
  final String? fileName;

  /// 哈希偏移信息
  @JsonKey(name: 'hash_offset')
  final HashOffset? hashOffset;

  /// Creates a new [SongUrl] instance.
  SongUrl({
    this.url,
    this.backupUrls,
    this.hash,
    this.fileSize,
    this.extName,
    this.bitRate,
    this.type,
    this.status,
    this.privStatus,
    this.timeLength,
    this.fileName,
    this.hashOffset,
  });

  /// 是否为VIP歌曲
  bool get isVip => status == 2;

  /// 是否为免费歌曲
  bool get isFree => status == 1;

  /// 是否有可用播放地址
  bool get hasUrl => url != null && url!.isNotEmpty;

  /// Creates a [SongUrl] from JSON data.
  factory SongUrl.fromJson(Map<String, dynamic> json) =>
      _$SongUrlFromJson(json);
  Map<String, dynamic> toJson() => _$SongUrlToJson(this);
}

String? _urlFromJson(dynamic value) {
  if (value is String) return value;
  if (value is List && value.isNotEmpty) return value.first as String;
  return null;
}

dynamic _urlToJson(String? value) => value;

List<String>? _urlListFromJson(dynamic value) {
  if (value is List) return value.whereType<String>().toList();
  return null;
}

/// 哈希偏移信息
@JsonSerializable()
class HashOffset {
  /// 起始字节位置
  @JsonKey(name: 'start_byte', fromJson: _parseInt)
  final int? startByte;

  /// 结束字节位置
  @JsonKey(name: 'end_byte', fromJson: _parseInt)
  final int? endByte;

  /// 起始时间（毫秒）
  @JsonKey(name: 'start_ms', fromJson: _parseInt)
  final int? startMs;

  /// 结束时间（毫秒）
  @JsonKey(name: 'end_ms', fromJson: _parseInt)
  final int? endMs;

  /// 文件类型
  @JsonKey(name: 'file_type', fromJson: _parseInt)
  final int? fileType;

  /// 偏移哈希值
  @JsonKey(name: 'offset_hash')
  final String? offsetHash;

  /// Creates a new [HashOffset] instance.
  HashOffset({
    this.startByte,
    this.endByte,
    this.startMs,
    this.endMs,
    this.fileType,
    this.offsetHash,
  });

  /// Creates a [HashOffset] from JSON data.
  factory HashOffset.fromJson(Map<String, dynamic> json) =>
      _$HashOffsetFromJson(json);
  Map<String, dynamic> toJson() => _$HashOffsetToJson(this);
}
