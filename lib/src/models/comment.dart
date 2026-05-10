import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// 评论列表结果
@JsonSerializable()
class CommentListResult {
  /// 评论列表
  final List<CommentItem>? list;

  /// 评论总数
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// 热门评论列表
  @JsonKey(name: 'hot_comment_list')
  final List<CommentItem>? hotComments;

  /// Creates a new [CommentListResult] instance.
  CommentListResult({this.list, this.count, this.hotComments});

  /// Creates a [CommentListResult] from JSON data.
  factory CommentListResult.fromJson(Map<String, dynamic> json) => _$CommentListResultFromJson(json);
  Map<String, dynamic> toJson() => _$CommentListResultToJson(this);
}

/// 评论条目
@JsonSerializable()
class CommentItem {
  /// 评论ID
  @JsonKey(name: 'id', fromJson: _parseInt)
  final int? commentId;

  /// 评论内容
  final String? content;

  /// 用户名
  @JsonKey(name: 'user_name')
  final String? userName;

  /// 用户头像
  @JsonKey(name: 'user_pic')
  final String? userImg;

  /// 回复数量
  @JsonKey(name: 'reply_num', fromJson: _parseInt)
  final int? replyCount;

  /// 评论时间
  @JsonKey(name: 'addtime')
  final String? addTime;

  /// 关联歌曲ID
  @JsonKey(name: 'mixsongid', fromJson: _parseInt)
  final int? mixSongId;

  /// 回复评论列表
  @JsonKey(name: 'at_comment_list')
  final List<CommentItem>? atComments;

  /// Creates a new [CommentItem] instance.
  CommentItem({this.commentId, this.content, this.userName, this.userImg, this.replyCount, this.addTime, this.mixSongId, this.atComments});

  /// Creates a [CommentItem] from JSON data.
  factory CommentItem.fromJson(Map<String, dynamic> json) => _$CommentItemFromJson(json);
  Map<String, dynamic> toJson() => _$CommentItemToJson(this);
}

/// 评论数量结果
@JsonSerializable()
class CommentCountResult {
  /// 评论数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// Creates a new [CommentCountResult] instance.
  CommentCountResult({this.count});

  /// Creates a [CommentCountResult] from JSON data.
  factory CommentCountResult.fromJson(Map<String, dynamic> json) => _$CommentCountResultFromJson(json);
  Map<String, dynamic> toJson() => _$CommentCountResultToJson(this);
}

/// 楼层评论结果
@JsonSerializable()
class FloorCommentResult {
  /// 评论列表
  final List<CommentItem>? list;

  /// 评论数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// Creates a new [FloorCommentResult] instance.
  FloorCommentResult({this.list, this.count});

  /// Creates a [FloorCommentResult] from JSON data.
  factory FloorCommentResult.fromJson(Map<String, dynamic> json) => _$FloorCommentResultFromJson(json);
  Map<String, dynamic> toJson() => _$FloorCommentResultToJson(this);
}

/// 热词结果
@JsonSerializable()
class HotWordResult {
  /// 评论列表
  final List<CommentItem>? list;

  /// Creates a new [HotWordResult] instance.
  HotWordResult({this.list});

  /// Creates a [HotWordResult] from JSON data.
  factory HotWordResult.fromJson(Map<String, dynamic> json) => _$HotWordResultFromJson(json);
  Map<String, dynamic> toJson() => _$HotWordResultToJson(this);
}

/// 分类评论结果
@JsonSerializable()
class ClassifyCommentResult {
  /// 评论列表
  final List<CommentItem>? list;

  /// 评论数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// Creates a new [ClassifyCommentResult] instance.
  ClassifyCommentResult({this.list, this.count});

  /// Creates a [ClassifyCommentResult] from JSON data.
  factory ClassifyCommentResult.fromJson(Map<String, dynamic> json) => _$ClassifyCommentResultFromJson(json);
  Map<String, dynamic> toJson() => _$ClassifyCommentResultToJson(this);
}

/// 专辑评论结果
@JsonSerializable()
class CommentAlbumResult {
  /// 评论列表
  final List<CommentItem>? list;

  /// 评论数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// 热门评论列表
  @JsonKey(name: 'hot_comment_list')
  final List<CommentItem>? hotComments;

  /// Creates a new [CommentAlbumResult] instance.
  CommentAlbumResult({this.list, this.count, this.hotComments});

  /// Creates a [CommentAlbumResult] from JSON data.
  factory CommentAlbumResult.fromJson(Map<String, dynamic> json) => _$CommentAlbumResultFromJson(json);
  Map<String, dynamic> toJson() => _$CommentAlbumResultToJson(this);
}

/// 歌单评论结果
@JsonSerializable()
class CommentPlaylistResult {
  /// 评论列表
  final List<CommentItem>? list;

  /// 评论数量
  @JsonKey(name: 'count', fromJson: _parseInt)
  final int? count;

  /// 热门评论列表
  @JsonKey(name: 'hot_comment_list')
  final List<CommentItem>? hotComments;

  /// Creates a new [CommentPlaylistResult] instance.
  CommentPlaylistResult({this.list, this.count, this.hotComments});

  /// Creates a [CommentPlaylistResult] from JSON data.
  factory CommentPlaylistResult.fromJson(Map<String, dynamic> json) => _$CommentPlaylistResultFromJson(json);
  Map<String, dynamic> toJson() => _$CommentPlaylistResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
