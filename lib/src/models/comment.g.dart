// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentListResult _$CommentListResultFromJson(Map<String, dynamic> json) =>
    CommentListResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: _parseInt(json['count']),
      hotComments: (json['hot_comment_list'] as List<dynamic>?)
          ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentListResultToJson(CommentListResult instance) =>
    <String, dynamic>{
      'list': instance.list,
      'count': instance.count,
      'hot_comment_list': instance.hotComments,
    };

CommentItem _$CommentItemFromJson(Map<String, dynamic> json) => CommentItem(
  commentId: _parseInt(json['id']),
  content: json['content'] as String?,
  userName: json['user_name'] as String?,
  userImg: json['user_pic'] as String?,
  replyCount: _parseInt(json['reply_num']),
  addTime: json['addtime'] as String?,
  mixSongId: _parseInt(json['mixsongid']),
  atComments: (json['at_comment_list'] as List<dynamic>?)
      ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CommentItemToJson(CommentItem instance) =>
    <String, dynamic>{
      'id': instance.commentId,
      'content': instance.content,
      'user_name': instance.userName,
      'user_pic': instance.userImg,
      'reply_num': instance.replyCount,
      'addtime': instance.addTime,
      'mixsongid': instance.mixSongId,
      'at_comment_list': instance.atComments,
    };

CommentCountResult _$CommentCountResultFromJson(Map<String, dynamic> json) =>
    CommentCountResult(count: _parseInt(json['count']));

Map<String, dynamic> _$CommentCountResultToJson(CommentCountResult instance) =>
    <String, dynamic>{'count': instance.count};

FloorCommentResult _$FloorCommentResultFromJson(Map<String, dynamic> json) =>
    FloorCommentResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: _parseInt(json['count']),
    );

Map<String, dynamic> _$FloorCommentResultToJson(FloorCommentResult instance) =>
    <String, dynamic>{'list': instance.list, 'count': instance.count};

HotWordResult _$HotWordResultFromJson(Map<String, dynamic> json) =>
    HotWordResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HotWordResultToJson(HotWordResult instance) =>
    <String, dynamic>{'list': instance.list};

ClassifyCommentResult _$ClassifyCommentResultFromJson(
  Map<String, dynamic> json,
) => ClassifyCommentResult(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: _parseInt(json['count']),
);

Map<String, dynamic> _$ClassifyCommentResultToJson(
  ClassifyCommentResult instance,
) => <String, dynamic>{'list': instance.list, 'count': instance.count};

CommentAlbumResult _$CommentAlbumResultFromJson(Map<String, dynamic> json) =>
    CommentAlbumResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: _parseInt(json['count']),
      hotComments: (json['hot_comment_list'] as List<dynamic>?)
          ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentAlbumResultToJson(CommentAlbumResult instance) =>
    <String, dynamic>{
      'list': instance.list,
      'count': instance.count,
      'hot_comment_list': instance.hotComments,
    };

CommentPlaylistResult _$CommentPlaylistResultFromJson(
  Map<String, dynamic> json,
) => CommentPlaylistResult(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: _parseInt(json['count']),
  hotComments: (json['hot_comment_list'] as List<dynamic>?)
      ?.map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CommentPlaylistResultToJson(
  CommentPlaylistResult instance,
) => <String, dynamic>{
  'list': instance.list,
  'count': instance.count,
  'hot_comment_list': instance.hotComments,
};
