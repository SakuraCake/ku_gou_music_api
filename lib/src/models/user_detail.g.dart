// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailResult _$UserDetailResultFromJson(Map<String, dynamic> json) =>
    UserDetailResult(
      userId: _parseInt(json['user_id']),
      userName: json['user_name'] as String?,
      nickname: json['nickname'] as String?,
      pic: json['pic'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      vipType: _parseInt(json['vip_type']),
      isVip: _parseInt(json['is_vip']),
      fans: (json['fans'] as num?)?.toInt(),
      follows: (json['follows'] as num?)?.toInt(),
      city: json['city'] as String?,
      province: json['province'] as String?,
      descri: json['descri'] as String?,
    );

Map<String, dynamic> _$UserDetailResultToJson(UserDetailResult instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'nickname': instance.nickname,
      'pic': instance.pic,
      'gender': instance.gender,
      'vip_type': instance.vipType,
      'is_vip': instance.isVip,
      'fans': instance.fans,
      'follows': instance.follows,
      'city': instance.city,
      'province': instance.province,
      'descri': instance.descri,
    };

UserPlaylistResult _$UserPlaylistResultFromJson(Map<String, dynamic> json) =>
    UserPlaylistResult(
      list: (json['info'] as List<dynamic>?)
          ?.map((e) => PlaylistInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: _parseInt(json['list_count']),
    );

Map<String, dynamic> _$UserPlaylistResultToJson(UserPlaylistResult instance) =>
    <String, dynamic>{'info': instance.list, 'list_count': instance.totalCount};

UserHistoryResult _$UserHistoryResultFromJson(Map<String, dynamic> json) =>
    UserHistoryResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => UserHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: _parseInt(json['total_count']),
    );

Map<String, dynamic> _$UserHistoryResultToJson(UserHistoryResult instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total_count': instance.totalCount,
    };

UserHistoryItem _$UserHistoryItemFromJson(Map<String, dynamic> json) =>
    UserHistoryItem(
      hash: json['hash'] as String?,
      songName: json['song_name'] as String?,
      authorName: json['author_name'] as String?,
      playCount: _parseInt(json['play_count']),
      albumId: _parseInt(json['album_id']),
      albumImg: json['album_img'] as String?,
    );

Map<String, dynamic> _$UserHistoryItemToJson(UserHistoryItem instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'song_name': instance.songName,
      'author_name': instance.authorName,
      'play_count': instance.playCount,
      'album_id': instance.albumId,
      'album_img': instance.albumImg,
    };

VipDetailResult _$VipDetailResultFromJson(Map<String, dynamic> json) =>
    VipDetailResult(
      vipType: _parseInt(json['vip_type']),
      vipName: json['vip_name'] as String?,
      expireTime: _parseInt(json['expire_time']),
      isVip: _parseInt(json['is_vip']),
    );

Map<String, dynamic> _$VipDetailResultToJson(VipDetailResult instance) =>
    <String, dynamic>{
      'vip_type': instance.vipType,
      'vip_name': instance.vipName,
      'expire_time': instance.expireTime,
      'is_vip': instance.isVip,
    };

FavoriteCountResult _$FavoriteCountResultFromJson(Map<String, dynamic> json) =>
    FavoriteCountResult(count: _parseInt(json['count']));

Map<String, dynamic> _$FavoriteCountResultToJson(
  FavoriteCountResult instance,
) => <String, dynamic>{'count': instance.count};

UserFollowResult _$UserFollowResultFromJson(Map<String, dynamic> json) =>
    UserFollowResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => UserFollowItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: _parseInt(json['has_next']),
    );

Map<String, dynamic> _$UserFollowResultToJson(UserFollowResult instance) =>
    <String, dynamic>{'list': instance.list, 'has_next': instance.hasNext};

UserFollowItem _$UserFollowItemFromJson(Map<String, dynamic> json) =>
    UserFollowItem(
      userId: _parseInt(json['userid']),
      userName: json['username'] as String?,
      avatar: json['avatar'] as String?,
      isFollow: _parseInt(json['is_follow']),
    );

Map<String, dynamic> _$UserFollowItemToJson(UserFollowItem instance) =>
    <String, dynamic>{
      'userid': instance.userId,
      'username': instance.userName,
      'avatar': instance.avatar,
      'is_follow': instance.isFollow,
    };

PlayHistoryUploadResult _$PlayHistoryUploadResultFromJson(
  Map<String, dynamic> json,
) => PlayHistoryUploadResult(
  status: _parseInt(json['status']),
  error: json['error'] as String?,
);

Map<String, dynamic> _$PlayHistoryUploadResultToJson(
  PlayHistoryUploadResult instance,
) => <String, dynamic>{'status': instance.status, 'error': instance.error};

ListenTimeResult _$ListenTimeResultFromJson(Map<String, dynamic> json) =>
    ListenTimeResult(data: json['data']);

Map<String, dynamic> _$ListenTimeResultToJson(ListenTimeResult instance) =>
    <String, dynamic>{'data': instance.data};
