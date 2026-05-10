import 'package:json_annotation/json_annotation.dart';
import 'song.dart';

part 'playlist.g.dart';

/// 歌单详情结果
@JsonSerializable()
class PlaylistDetailResult {
  /// 歌单信息列表
  final List<PlaylistInfo>? list;

  /// Creates a new [PlaylistDetailResult] instance.
  PlaylistDetailResult({this.list});

  /// Creates a [PlaylistDetailResult] from JSON data.
  factory PlaylistDetailResult.fromJson(Map<String, dynamic> json) => _$PlaylistDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistDetailResultToJson(this);
}

/// 歌单信息
@JsonSerializable()
class PlaylistInfo {
  /// 全局收藏ID
  @JsonKey(name: 'global_collection_id')
  final String? globalCollectionId;

  /// 歌单ID
  @JsonKey(name: 'specialid', fromJson: _parseInt)
  final int? specialId;

  /// 歌单名称
  @JsonKey(readValue: _readName)
  final String? name;

  /// 封面图片地址
  @JsonKey(readValue: _readImg)
  final String? img;

  /// 歌手名称
  @JsonKey(name: 'singername')
  final String? singerName;

  /// 创建者昵称
  @JsonKey(name: 'nickname')
  final String? nickname;

  /// 播放次数
  @JsonKey(name: 'play_count', fromJson: _parseInt)
  final int? playCount;

  /// 收藏次数
  @JsonKey(name: 'collectcount', fromJson: _parseInt)
  final int? collectCount;

  /// 歌曲数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? songCount;

  /// 歌单简介
  final String? intro;

  /// 发布时间
  @JsonKey(name: 'publishtime')
  final String? publishTime;

  /// Creates a new [PlaylistInfo] instance.
  PlaylistInfo({this.globalCollectionId, this.specialId, this.name, this.img, this.singerName, this.nickname, this.playCount, this.collectCount, this.songCount, this.intro, this.publishTime});

  /// Creates a [PlaylistInfo] from JSON data.
  factory PlaylistInfo.fromJson(Map<String, dynamic> json) => _$PlaylistInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistInfoToJson(this);
}

String? _readName(Map<dynamic, dynamic> json, String key) {
  return json['name'] as String? ?? json['specialname'] as String?;
}

String? _readImg(Map<dynamic, dynamic> json, String key) {
  return json['pic'] as String? ?? json['imgurl'] as String?;
}

/// 歌单曲目列表结果
@JsonSerializable()
class PlaylistTrackResult {
  /// 歌曲列表
  final List<Song>? songs;

  /// 歌曲总数
  @JsonKey(name: 'song_count', fromJson: _parseInt)
  final int? songCount;

  /// Creates a new [PlaylistTrackResult] instance.
  PlaylistTrackResult({this.songs, this.songCount});

  /// Creates a [PlaylistTrackResult] from JSON data.
  factory PlaylistTrackResult.fromJson(Map<String, dynamic> json) => _$PlaylistTrackResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistTrackResultToJson(this);
}

/// 歌单分类标签
@JsonSerializable()
class PlaylistTag {
  /// 标签ID
  @JsonKey(name: 'tag_id', fromJson: _parseInt)
  final int? tagId;

  /// 标签名称
  @JsonKey(name: 'tag_name')
  final String? tagName;

  /// 父级标签ID
  @JsonKey(name: 'parent_id', fromJson: _parseInt)
  final int? parentId;

  /// 子标签列表
  final List<PlaylistTag>? children;

  /// Creates a new [PlaylistTag] instance.
  PlaylistTag({this.tagId, this.tagName, this.parentId, this.children});

  /// Creates a [PlaylistTag] from JSON data.
  factory PlaylistTag.fromJson(Map<String, dynamic> json) => _$PlaylistTagFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistTagToJson(this);
}

/// 相似歌单结果
@JsonSerializable()
class SimilarPlaylistResult {
  /// 相似歌单列表
  final List<PlaylistInfo>? list;

  /// Creates a new [SimilarPlaylistResult] instance.
  SimilarPlaylistResult({this.list});

  /// Creates a [SimilarPlaylistResult] from JSON data.
  factory SimilarPlaylistResult.fromJson(Map<String, dynamic> json) => _$SimilarPlaylistResultFromJson(json);
  Map<String, dynamic> toJson() => _$SimilarPlaylistResultToJson(this);
}

/// 热门歌单结果
@JsonSerializable()
class TopPlaylistResult {
  /// 歌单列表
  @JsonKey(name: 'special_list')
  final List<PlaylistInfo>? specialList;

  /// 是否有下一页
  @JsonKey(name: 'has_next', fromJson: _parseInt)
  final int? hasNext;

  /// Creates a new [TopPlaylistResult] instance.
  TopPlaylistResult({this.specialList, this.hasNext});

  /// Creates a [TopPlaylistResult] from JSON data.
  factory TopPlaylistResult.fromJson(Map<String, dynamic> json) => _$TopPlaylistResultFromJson(json);
  Map<String, dynamic> toJson() => _$TopPlaylistResultToJson(this);
}

/// 歌单删除结果
@JsonSerializable()
class PlaylistDeleteResult {
  /// 状态码
  @JsonKey(fromJson: _parseInt)
  final int? status;

  /// 错误信息
  final String? error;

  /// Creates a new [PlaylistDeleteResult] instance.
  PlaylistDeleteResult({this.status, this.error});

  /// Creates a [PlaylistDeleteResult] from JSON data.
  factory PlaylistDeleteResult.fromJson(Map<String, dynamic> json) => _$PlaylistDeleteResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistDeleteResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
