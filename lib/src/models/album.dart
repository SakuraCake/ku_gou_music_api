import 'package:json_annotation/json_annotation.dart';
import 'song.dart';

part 'album.g.dart';

/// 专辑详情结果
@JsonSerializable()
class AlbumDetailResult {
  /// 专辑信息列表
  final List<AlbumInfo>? list;

  /// Creates a new [AlbumDetailResult] instance.
  AlbumDetailResult({this.list});

  /// Creates a [AlbumDetailResult] from JSON data.
  factory AlbumDetailResult.fromJson(Map<String, dynamic> json) => _$AlbumDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumDetailResultToJson(this);
}

/// 专辑信息
@JsonSerializable()
class AlbumInfo {
  /// 专辑ID
  @JsonKey(name: 'albumid', fromJson: _parseInt)
  final int? albumId;

  /// 专辑名称
  @JsonKey(readValue: _readAlbumName)
  final String? albumName;

  /// 封面图片地址
  @JsonKey(readValue: _readImg)
  final String? img;

  /// 歌手ID
  @JsonKey(name: 'singerid', fromJson: _parseInt)
  final int? singerId;

  /// 歌手名称
  @JsonKey(readValue: _readSingerName)
  final String? singerName;

  /// 歌曲数量
  @JsonKey(readValue: _readSongCount)
  final int? songCount;

  /// 发布时间
  @JsonKey(readValue: _readPublishTime)
  final String? publishTime;

  /// 专辑简介
  final String? intro;

  /// 歌曲列表
  final List<Song>? songs;

  /// Creates a new [AlbumInfo] instance.
  AlbumInfo({this.albumId, this.albumName, this.img, this.singerId, this.singerName, this.songCount, this.publishTime, this.intro, this.songs});

  /// Creates a [AlbumInfo] from JSON data.
  factory AlbumInfo.fromJson(Map<String, dynamic> json) => _$AlbumInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AlbumInfoToJson(this);
}

String? _readAlbumName(Map<dynamic, dynamic> json, String key) {
  return json['album_name'] as String? ?? json['albumname'] as String?;
}

String? _readImg(Map<dynamic, dynamic> json, String key) {
  return json['sizable_cover'] as String? ?? json['imgurl'] as String?;
}

String? _readSingerName(Map<dynamic, dynamic> json, String key) {
  return json['author_name'] as String? ?? json['singername'] as String?;
}

int? _readSongCount(Map<dynamic, dynamic> json, String key) {
  final v = json['songcount'] ?? json['song_count'];
  if (v is int) return v;
  if (v is String) return int.tryParse(v);
  return null;
}

String? _readPublishTime(Map<dynamic, dynamic> json, String key) {
  return json['publish_date'] as String? ?? json['publishtime'] as String?;
}

/// 新碟上架结果
@JsonSerializable()
class TopAlbumResult {
  /// 华语专辑列表
  final List<AlbumInfo>? chn;

  /// 日本专辑列表
  final List<AlbumInfo>? jpn;

  /// 韩国专辑列表
  final List<AlbumInfo>? kor;

  /// 欧美专辑列表
  final List<AlbumInfo>? eur;

  /// 时间戳
  @JsonKey(name: 'timestamp', fromJson: _parseInt)
  final int? timestamp;

  /// Creates a new [TopAlbumResult] instance.
  TopAlbumResult({this.chn, this.jpn, this.kor, this.eur, this.timestamp});

  /// Creates a [TopAlbumResult] from JSON data.
  factory TopAlbumResult.fromJson(Map<String, dynamic> json) => _$TopAlbumResultFromJson(json);
  Map<String, dynamic> toJson() => _$TopAlbumResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
