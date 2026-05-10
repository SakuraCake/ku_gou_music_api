import 'package:json_annotation/json_annotation.dart';

part 'images.g.dart';

/// 专辑图片列表结果
@JsonSerializable()
class AlbumImagesResult {
  /// 专辑图片列表
  final List<AlbumImageItem>? data;

  /// Creates a new [AlbumImagesResult] instance.
  AlbumImagesResult({this.data});

  /// Creates a [AlbumImagesResult] from JSON data.
  factory AlbumImagesResult.fromJson(Map<String, dynamic> json) => _$AlbumImagesResultFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumImagesResultToJson(this);
}

/// 专辑图片条目
@JsonSerializable()
class AlbumImageItem {
  /// 歌曲哈希值
  final String? hash;

  /// 专辑ID
  @JsonKey(name: 'album_id', fromJson: _parseInt)
  final int? albumId;

  /// 专辑音频ID
  @JsonKey(name: 'album_audio_id', fromJson: _parseInt)
  final int? albumAudioId;

  /// 图片数据
  final dynamic images;

  /// Creates a new [AlbumImageItem] instance.
  AlbumImageItem({this.hash, this.albumId, this.albumAudioId, this.images});

  /// Creates a [AlbumImageItem] from JSON data.
  factory AlbumImageItem.fromJson(Map<String, dynamic> json) => _$AlbumImageItemFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumImageItemToJson(this);
}

/// 音频图片列表结果
@JsonSerializable()
class AudioImagesResult {
  /// 音频图片列表
  final List<AudioImageItem>? data;

  /// Creates a new [AudioImagesResult] instance.
  AudioImagesResult({this.data});

  /// Creates a [AudioImagesResult] from JSON data.
  factory AudioImagesResult.fromJson(Map<String, dynamic> json) => _$AudioImagesResultFromJson(json);
  Map<String, dynamic> toJson() => _$AudioImagesResultToJson(this);
}

/// 音频图片条目
@JsonSerializable()
class AudioImageItem {
  /// 歌曲哈希值
  final String? hash;

  /// 音频ID
  @JsonKey(name: 'audio_id', fromJson: _parseInt)
  final int? audioId;

  /// 专辑音频ID
  @JsonKey(name: 'album_audio_id', fromJson: _parseInt)
  final int? albumAudioId;

  /// 文件名
  final String? filename;

  /// 图片数据
  final dynamic images;

  /// Creates a new [AudioImageItem] instance.
  AudioImageItem({this.hash, this.audioId, this.albumAudioId, this.filename, this.images});

  /// Creates a [AudioImageItem] from JSON data.
  factory AudioImageItem.fromJson(Map<String, dynamic> json) => _$AudioImageItemFromJson(json);
  Map<String, dynamic> toJson() => _$AudioImageItemToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
