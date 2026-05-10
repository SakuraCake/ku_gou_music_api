import 'package:json_annotation/json_annotation.dart';

part 'ip.g.dart';

/// IP内容列表结果
@JsonSerializable()
class IpContentResult {
  /// 内容信息列表
  final List<Map<String, dynamic>>? info;

  /// 总数
  @JsonKey(fromJson: _parseInt)
  final int? total;

  /// 是否有下一页
  @JsonKey(name: 'has_next', fromJson: _parseInt)
  final int? hasNext;

  /// Creates a new [IpContentResult] instance.
  IpContentResult({this.info, this.total, this.hasNext});

  /// Creates a [IpContentResult] from JSON data.
  factory IpContentResult.fromJson(Map<String, dynamic> json) => _$IpContentResultFromJson(json);
  Map<String, dynamic> toJson() => _$IpContentResultToJson(this);
}

/// IP详情结果
@JsonSerializable()
class IpDetailResult {
  /// IP详情数据列表
  final List<IpDetailItem>? data;

  /// Creates a new [IpDetailResult] instance.
  IpDetailResult({this.data});

  /// Creates a [IpDetailResult] from JSON data.
  factory IpDetailResult.fromJson(Map<String, dynamic> json) => _$IpDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$IpDetailResultToJson(this);
}

/// IP详情条目
@JsonSerializable()
class IpDetailItem {
  /// IP标识
  @JsonKey(name: 'ip_id', fromJson: _parseInt)
  final int? ipId;

  /// IP名称
  final String? name;

  /// 封面图片地址
  final String? cover;

  /// IP简介
  final String? intro;

  /// 是否已发布
  @JsonKey(name: 'is_publish', fromJson: _parseInt)
  final int? isPublish;

  /// 作者名称
  @JsonKey(name: 'author_name')
  final String? authorName;

  /// 歌曲数量
  @JsonKey(name: 'song_count', fromJson: _parseInt)
  final int? songCount;

  /// 专辑数量
  @JsonKey(name: 'album_count', fromJson: _parseInt)
  final int? albumCount;

  /// 视频数量
  @JsonKey(name: 'video_count', fromJson: _parseInt)
  final int? videoCount;

  /// 扩展数据
  final dynamic extra;

  /// Creates a new [IpDetailItem] instance.
  IpDetailItem({
    this.ipId,
    this.name,
    this.cover,
    this.intro,
    this.isPublish,
    this.authorName,
    this.songCount,
    this.albumCount,
    this.videoCount,
    this.extra,
  });

  /// Creates a [IpDetailItem] from JSON data.
  factory IpDetailItem.fromJson(Map<String, dynamic> json) => _$IpDetailItemFromJson(json);
  Map<String, dynamic> toJson() => _$IpDetailItemToJson(this);
}

/// IP歌单列表结果
@JsonSerializable()
class IpPlaylistResult {
  /// 歌单列表
  final List<IpPlaylistItem>? info;

  /// 总数
  @JsonKey(fromJson: _parseInt)
  final int? total;

  /// 是否有下一页
  @JsonKey(name: 'has_next', fromJson: _parseInt)
  final int? hasNext;

  /// Creates a new [IpPlaylistResult] instance.
  IpPlaylistResult({this.info, this.total, this.hasNext});

  /// Creates a [IpPlaylistResult] from JSON data.
  factory IpPlaylistResult.fromJson(Map<String, dynamic> json) => _$IpPlaylistResultFromJson(json);
  Map<String, dynamic> toJson() => _$IpPlaylistResultToJson(this);
}

/// IP歌单条目
@JsonSerializable()
class IpPlaylistItem {
  /// 歌单ID
  @JsonKey(name: 'specialid', fromJson: _parseInt)
  final int? specialId;

  /// 歌单名称
  @JsonKey(name: 'special_name')
  final String? specialName;

  /// 封面图片地址
  final String? img;

  /// 播放次数
  @JsonKey(name: 'play_count', fromJson: _parseInt)
  final int? playCount;

  /// 歌曲数量
  @JsonKey(name: 'song_count', fromJson: _parseInt)
  final int? songCount;

  /// 歌单简介
  final String? intro;

  /// 全局收藏ID
  @JsonKey(name: 'global_collection_id')
  final String? globalCollectionId;

  /// 歌手名称
  final String? singerName;

  /// Creates a new [IpPlaylistItem] instance.
  IpPlaylistItem({
    this.specialId,
    this.specialName,
    this.img,
    this.playCount,
    this.songCount,
    this.intro,
    this.globalCollectionId,
    this.singerName,
  });

  /// Creates a [IpPlaylistItem] from JSON data.
  factory IpPlaylistItem.fromJson(Map<String, dynamic> json) => _$IpPlaylistItemFromJson(json);
  Map<String, dynamic> toJson() => _$IpPlaylistItemToJson(this);
}

/// IP专区结果
@JsonSerializable()
class IpZoneResult {
  /// IP专区列表
  final List<IpZoneItem>? list;

  /// Creates a new [IpZoneResult] instance.
  IpZoneResult({this.list});

  /// Creates a [IpZoneResult] from JSON data.
  factory IpZoneResult.fromJson(Map<String, dynamic> json) => _$IpZoneResultFromJson(json);
  Map<String, dynamic> toJson() => _$IpZoneResultToJson(this);
}

/// IP专区条目
@JsonSerializable()
class IpZoneItem {
  /// IP标识
  @JsonKey(name: 'ip_id', fromJson: _parseInt)
  final int? ipId;

  /// IP名称
  final String? name;

  /// 封面图片地址
  final String? cover;

  /// 专题链接
  @JsonKey(name: 'special_link')
  final String? specialLink;

  /// IP简介
  final String? intro;

  /// 是否已发布
  @JsonKey(name: 'is_publish', fromJson: _parseInt)
  final int? isPublish;

  /// 扩展数据
  final dynamic extra;

  /// Creates a new [IpZoneItem] instance.
  IpZoneItem({
    this.ipId,
    this.name,
    this.cover,
    this.specialLink,
    this.intro,
    this.isPublish,
    this.extra,
  });

  /// Creates a [IpZoneItem] from JSON data.
  factory IpZoneItem.fromJson(Map<String, dynamic> json) {
    final mutableJson = Map<String, dynamic>.from(json);
    if (mutableJson['ip_id'] == null && mutableJson['special_link'] != null) {
      final ipId = _extractIpIdFromSpecialLink(mutableJson['special_link'] as String);
      if (ipId != null) {
        mutableJson['ip_id'] = ipId;
      }
    }
    return _$IpZoneItemFromJson(mutableJson);
  }
  Map<String, dynamic> toJson() => _$IpZoneItemToJson(this);
}

/// IP专区首页结果
@JsonSerializable()
class IpZoneHomeResult {
  /// IP标识
  @JsonKey(name: 'ip_id', fromJson: _parseInt)
  final int? ipId;

  /// IP名称
  final String? name;

  /// 封面图片地址
  final String? cover;

  /// IP简介
  final String? intro;

  /// 横幅数据
  final dynamic banner;

  /// 模块列表
  final List<Map<String, dynamic>>? modules;

  /// 扩展数据
  final dynamic extra;

  /// Creates a new [IpZoneHomeResult] instance.
  IpZoneHomeResult({
    this.ipId,
    this.name,
    this.cover,
    this.intro,
    this.banner,
    this.modules,
    this.extra,
  });

  /// Creates a [IpZoneHomeResult] from JSON data.
  factory IpZoneHomeResult.fromJson(Map<String, dynamic> json) => _$IpZoneHomeResultFromJson(json);
  Map<String, dynamic> toJson() => _$IpZoneHomeResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

int? _extractIpIdFromSpecialLink(String specialLink) {
  try {
    final outerParams = Uri.splitQueryString(specialLink);
    final path = outerParams['path'];
    if (path != null) {
      final queryStart = path.indexOf('?');
      if (queryStart >= 0) {
        final queryParams = Uri.splitQueryString(path.substring(queryStart + 1));
        final ipIdStr = queryParams['ip_id'];
        if (ipIdStr != null) {
          return int.tryParse(ipIdStr);
        }
      }
    }
  } catch (_) {}
  return null;
}
