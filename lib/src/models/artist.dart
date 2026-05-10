import 'package:json_annotation/json_annotation.dart';
import 'album.dart';
import 'song.dart';

part 'artist.g.dart';

/// 歌手详情结果
@JsonSerializable()
class ArtistDetailResult {
  /// 歌手ID
  @JsonKey(name: 'author_id')
  final String? authorId;

  /// 歌手名称
  @JsonKey(name: 'author_name')
  final String? authorName;

  /// 高清头像地址
  @JsonKey(name: 'sizable_avatar')
  final String? sizableAvatar;

  /// 歌曲数量
  @JsonKey(name: 'song_count', fromJson: _parseInt)
  final int? songCount;

  /// 专辑数量
  @JsonKey(name: 'album_count', fromJson: _parseInt)
  final int? albumCount;

  /// 歌手简介
  final String? intro;

  /// 粉丝数
  @JsonKey(name: 'fansnums', fromJson: _parseInt)
  final int? fansnums;

  /// MV数量
  @JsonKey(name: 'mv_count', fromJson: _parseInt)
  final int? mvCount;

  /// 生日
  final String? birthday;

  /// 地区ID
  @JsonKey(name: 'area_id', fromJson: _parseInt)
  final int? areaId;

  /// 是否已发布
  @JsonKey(name: 'is_publish', fromJson: _parseInt)
  final int? isPublish;

  /// Creates a new [ArtistDetailResult] instance.
  ArtistDetailResult({this.authorId, this.authorName, this.sizableAvatar, this.songCount, this.albumCount, this.intro, this.fansnums, this.mvCount, this.birthday, this.areaId, this.isPublish});

  /// Creates a [ArtistDetailResult] from JSON data.
  factory ArtistDetailResult.fromJson(Map<String, dynamic> json) => _$ArtistDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistDetailResultToJson(this);
}

/// 歌手歌曲列表结果
@JsonSerializable()
class ArtistAudioResult {
  /// 歌曲列表
  final List<Song>? songs;

  /// 歌曲总数
  @JsonKey(name: 'total_count', fromJson: _parseInt)
  final int? totalCount;

  /// Creates a new [ArtistAudioResult] instance.
  ArtistAudioResult({this.songs, this.totalCount});

  /// Creates a [ArtistAudioResult] from JSON data.
  factory ArtistAudioResult.fromJson(Map<String, dynamic> json) => _$ArtistAudioResultFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistAudioResultToJson(this);
}

/// 歌手专辑列表结果
@JsonSerializable()
class ArtistAlbumResult {
  /// 专辑列表
  final List<AlbumInfo>? albums;

  /// 专辑总数
  @JsonKey(name: 'total_count', fromJson: _parseInt)
  final int? totalCount;

  /// Creates a new [ArtistAlbumResult] instance.
  ArtistAlbumResult({this.albums, this.totalCount});

  /// Creates a [ArtistAlbumResult] from JSON data.
  factory ArtistAlbumResult.fromJson(Map<String, dynamic> json) => _$ArtistAlbumResultFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistAlbumResultToJson(this);
}

/// 歌手列表条目
@JsonSerializable()
class ArtistListItem {
  /// 歌手ID
  @JsonKey(name: 'singerid', fromJson: _parseInt)
  final int? singerId;

  /// 歌手名称
  @JsonKey(name: 'singername')
  final String? singerName;

  /// 粉丝数
  @JsonKey(name: 'fanscount', fromJson: _parseInt)
  final int? fansCount;

  /// 歌曲数量
  @JsonKey(name: 'songcount', fromJson: _parseInt)
  final int? songCount;

  /// 专辑数量
  @JsonKey(name: 'albumcount', fromJson: _parseInt)
  final int? albumCount;

  /// Creates a new [ArtistListItem] instance.
  ArtistListItem({this.singerId, this.singerName, this.fansCount, this.songCount, this.albumCount});

  /// Creates a [ArtistListItem] from JSON data.
  factory ArtistListItem.fromJson(Map<String, dynamic> json) => _$ArtistListItemFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistListItemToJson(this);
}

/// 歌手分组
@JsonSerializable()
class ArtistListGroup {
  /// 分组标题
  final String? title;

  /// 歌手列表
  final List<ArtistListItem>? singer;

  /// Creates a new [ArtistListGroup] instance.
  ArtistListGroup({this.title, this.singer});

  /// Creates a [ArtistListGroup] from JSON data.
  factory ArtistListGroup.fromJson(Map<String, dynamic> json) => _$ArtistListGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistListGroupToJson(this);
}

/// 歌手列表结果
@JsonSerializable()
class ArtistListResult {
  /// 歌手分组列表
  final List<ArtistListGroup>? info;

  /// Creates a new [ArtistListResult] instance.
  ArtistListResult({this.info});

  /// Creates a [ArtistListResult] from JSON data.
  factory ArtistListResult.fromJson(Map<String, dynamic> json) => _$ArtistListResultFromJson(json);
  Map<String, dynamic> toJson() => _$ArtistListResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
