import 'package:json_annotation/json_annotation.dart';
import 'playlist.dart';

part 'user_detail.g.dart';

/// 用户详情结果
@JsonSerializable()
class UserDetailResult {
  /// 用户ID
  @JsonKey(name: 'user_id', fromJson: _parseInt)
  final int? userId;

  /// 用户名
  @JsonKey(name: 'user_name')
  final String? userName;

  /// 昵称
  final String? nickname;

  /// 头像地址
  final String? pic;

  /// 性别 (1: 男, 2: 女)
  final int? gender;

  /// VIP类型
  @JsonKey(name: 'vip_type', fromJson: _parseInt)
  final int? vipType;

  /// 是否为VIP用户
  @JsonKey(name: 'is_vip', fromJson: _parseInt)
  final int? isVip;

  /// 粉丝数
  final int? fans;

  /// 关注数
  final int? follows;

  /// 城市
  final String? city;

  /// 省份
  final String? province;

  /// 签名
  final String? descri;

  /// Creates a new [UserDetailResult] instance.
  UserDetailResult({
    this.userId,
    this.userName,
    this.nickname,
    this.pic,
    this.gender,
    this.vipType,
    this.isVip,
    this.fans,
    this.follows,
    this.city,
    this.province,
    this.descri,
  });

  /// Creates a [UserDetailResult] from JSON data.
  factory UserDetailResult.fromJson(Map<String, dynamic> json) =>
      _$UserDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailResultToJson(this);
}

/// 用户歌单列表结果
@JsonSerializable()
class UserPlaylistResult {
  /// 歌单列表
  final List<PlaylistInfo>? list;

  /// 歌单总数
  @JsonKey(name: 'total_count', fromJson: _parseInt)
  final int? totalCount;

  /// Creates a new [UserPlaylistResult] instance.
  UserPlaylistResult({this.list, this.totalCount});

  /// Creates a [UserPlaylistResult] from JSON data.
  factory UserPlaylistResult.fromJson(Map<String, dynamic> json) => _$UserPlaylistResultFromJson(json);
  Map<String, dynamic> toJson() => _$UserPlaylistResultToJson(this);
}

/// 用户播放历史结果
@JsonSerializable()
class UserHistoryResult {
  /// 播放历史列表
  final List<UserHistoryItem>? list;

  /// 总数
  @JsonKey(name: 'total_count', fromJson: _parseInt)
  final int? totalCount;

  /// Creates a new [UserHistoryResult] instance.
  UserHistoryResult({this.list, this.totalCount});

  /// Creates a [UserHistoryResult] from JSON data.
  factory UserHistoryResult.fromJson(Map<String, dynamic> json) => _$UserHistoryResultFromJson(json);
  Map<String, dynamic> toJson() => _$UserHistoryResultToJson(this);
}

/// 播放历史条目
@JsonSerializable()
class UserHistoryItem {
  /// 歌曲哈希值
  final String? hash;

  /// 歌曲名称
  @JsonKey(name: 'song_name')
  final String? songName;

  /// 作者名称
  @JsonKey(name: 'author_name')
  final String? authorName;

  /// 播放次数
  @JsonKey(name: 'play_count', fromJson: _parseInt)
  final int? playCount;

  /// 专辑ID
  @JsonKey(name: 'album_id', fromJson: _parseInt)
  final int? albumId;

  /// 专辑封面地址
  @JsonKey(name: 'album_img')
  final String? albumImg;

  /// Creates a new [UserHistoryItem] instance.
  UserHistoryItem({this.hash, this.songName, this.authorName, this.playCount, this.albumId, this.albumImg});

  /// Creates a [UserHistoryItem] from JSON data.
  factory UserHistoryItem.fromJson(Map<String, dynamic> json) => _$UserHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$UserHistoryItemToJson(this);
}

/// VIP详情结果
@JsonSerializable()
class VipDetailResult {
  /// VIP类型
  @JsonKey(name: 'vip_type', fromJson: _parseInt)
  final int? vipType;

  /// VIP名称
  @JsonKey(name: 'vip_name')
  final String? vipName;

  /// 过期时间（时间戳）
  @JsonKey(name: 'expire_time', fromJson: _parseInt)
  final int? expireTime;

  /// 是否为VIP用户
  @JsonKey(name: 'is_vip', fromJson: _parseInt)
  final int? isVip;

  /// Creates a new [VipDetailResult] instance.
  VipDetailResult({this.vipType, this.vipName, this.expireTime, this.isVip});

  /// Creates a [VipDetailResult] from JSON data.
  factory VipDetailResult.fromJson(Map<String, dynamic> json) => _$VipDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$VipDetailResultToJson(this);
}

/// 收藏数量结果
@JsonSerializable()
class FavoriteCountResult {
  /// 收藏数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// Creates a new [FavoriteCountResult] instance.
  FavoriteCountResult({this.count});

  /// Creates a [FavoriteCountResult] from JSON data.
  factory FavoriteCountResult.fromJson(Map<String, dynamic> json) => _$FavoriteCountResultFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteCountResultToJson(this);
}

/// 用户关注列表结果
@JsonSerializable()
class UserFollowResult {
  /// 关注用户列表
  final List<UserFollowItem>? list;

  /// 是否有下一页
  @JsonKey(name: 'has_next', fromJson: _parseInt)
  final int? hasNext;

  /// Creates a new [UserFollowResult] instance.
  UserFollowResult({this.list, this.hasNext});

  /// Creates a [UserFollowResult] from JSON data.
  factory UserFollowResult.fromJson(Map<String, dynamic> json) => _$UserFollowResultFromJson(json);
  Map<String, dynamic> toJson() => _$UserFollowResultToJson(this);
}

/// 关注用户条目
@JsonSerializable()
class UserFollowItem {
  /// 用户ID
  @JsonKey(name: 'userid', fromJson: _parseInt)
  final int? userId;

  /// 用户名
  @JsonKey(name: 'username')
  final String? userName;

  /// 头像地址
  final String? avatar;

  /// 是否已关注
  @JsonKey(name: 'is_follow', fromJson: _parseInt)
  final int? isFollow;

  /// Creates a new [UserFollowItem] instance.
  UserFollowItem({this.userId, this.userName, this.avatar, this.isFollow});

  /// Creates a [UserFollowItem] from JSON data.
  factory UserFollowItem.fromJson(Map<String, dynamic> json) => _$UserFollowItemFromJson(json);
  Map<String, dynamic> toJson() => _$UserFollowItemToJson(this);
}

/// 播放历史上传结果
@JsonSerializable()
class PlayHistoryUploadResult {
  /// 状态码
  @JsonKey(fromJson: _parseInt)
  final int? status;

  /// 错误信息
  final String? error;

  /// Creates a new [PlayHistoryUploadResult] instance.
  PlayHistoryUploadResult({this.status, this.error});

  /// Creates a [PlayHistoryUploadResult] from JSON data.
  factory PlayHistoryUploadResult.fromJson(Map<String, dynamic> json) => _$PlayHistoryUploadResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlayHistoryUploadResultToJson(this);
}

/// 听歌时长结果
@JsonSerializable()
class ListenTimeResult {
  /// 听歌时长数据
  final dynamic data;

  /// Creates a new [ListenTimeResult] instance.
  ListenTimeResult({this.data});

  /// Creates a [ListenTimeResult] from JSON data.
  factory ListenTimeResult.fromJson(Map<String, dynamic> json) => _$ListenTimeResultFromJson(json);
  Map<String, dynamic> toJson() => _$ListenTimeResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
