import 'package:json_annotation/json_annotation.dart';
import 'song.dart';

part 'fm.g.dart';

/// 电台分类结果
@JsonSerializable()
class FmClassResult {
  /// 电台分类列表
  @JsonKey(name: 'class_list')
  final List<FmClassGroup>? classList;

  /// 分类总数
  @JsonKey(name: 'class_total', fromJson: _parseInt)
  final int? classTotal;

  /// 更新时间
  @JsonKey(name: 'update_time', fromJson: _parseInt)
  final int? updateTime;

  /// Creates a new [FmClassResult] instance.
  FmClassResult({this.classList, this.classTotal, this.updateTime});

  /// Creates a [FmClassResult] from JSON data.
  factory FmClassResult.fromJson(Map<String, dynamic> json) => _$FmClassResultFromJson(json);
  Map<String, dynamic> toJson() => _$FmClassResultToJson(this);
}

/// 电台分类分组
@JsonSerializable()
class FmClassGroup {
  /// 分类ID
  @JsonKey(name: 'classid', fromJson: _parseInt)
  final int? classId;

  /// 分类名称
  @JsonKey(name: 'classname')
  final String? className;

  /// 分类下电台数量
  @JsonKey(name: 'class_count', fromJson: _parseInt)
  final int? classCount;

  /// 电台列表
  final List<FmClassItem>? fmlist;

  /// Creates a new [FmClassGroup] instance.
  FmClassGroup({this.classId, this.className, this.classCount, this.fmlist});

  /// Creates a [FmClassGroup] from JSON data.
  factory FmClassGroup.fromJson(Map<String, dynamic> json) => _$FmClassGroupFromJson(json);
  Map<String, dynamic> toJson() => _$FmClassGroupToJson(this);
}

/// 电台分类条目
@JsonSerializable()
class FmClassItem {
  /// 电台ID
  @JsonKey(name: 'fmid', fromJson: _parseInt)
  final int? fmId;

  /// 电台类型
  @JsonKey(name: 'fmtype', fromJson: _parseInt)
  final int? fmType;

  /// 电台名称
  @JsonKey(name: 'fmname')
  final String? fmName;

  /// 封面图片地址
  @JsonKey(name: 'imgurl')
  final String? img;

  /// 父级分类ID
  @JsonKey(name: 'parentId', fromJson: _parseInt)
  final int? parentId;

  /// Creates a new [FmClassItem] instance.
  FmClassItem({this.fmId, this.fmType, this.fmName, this.img, this.parentId});

  /// Creates a [FmClassItem] from JSON data.
  factory FmClassItem.fromJson(Map<String, dynamic> json) => _$FmClassItemFromJson(json);
  Map<String, dynamic> toJson() => _$FmClassItemToJson(this);
}

/// 电台歌曲结果
@JsonSerializable()
class FmSongResult {
  /// 歌曲列表
  final List<Song>? songs;

  /// Creates a new [FmSongResult] instance.
  FmSongResult({this.songs});

  /// Creates a [FmSongResult] from JSON data.
  factory FmSongResult.fromJson(Map<String, dynamic> json) {
    final songlist = json['songlist'];
    if (songlist is List) {
      return FmSongResult(
        songs: songlist.whereType<Map<String, dynamic>>().map((e) => Song.fromJson(e)).toList(),
      );
    }
    return _$FmSongResultFromJson(json);
  }
  Map<String, dynamic> toJson() => _$FmSongResultToJson(this);
}

/// 个性化电台结果
@JsonSerializable()
class PersonalFmResult {
  /// 歌曲列表
  final List<Song>? list;

  /// 是否有下一页
  @JsonKey(name: 'has_next', fromJson: _parseInt)
  final int? hasNext;

  /// Creates a new [PersonalFmResult] instance.
  PersonalFmResult({this.list, this.hasNext});

  /// Creates a [PersonalFmResult] from JSON data.
  factory PersonalFmResult.fromJson(Map<String, dynamic> json) => _$PersonalFmResultFromJson(json);
  Map<String, dynamic> toJson() => _$PersonalFmResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
