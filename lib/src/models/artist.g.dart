// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistDetailResult _$ArtistDetailResultFromJson(Map<String, dynamic> json) =>
    ArtistDetailResult(
      authorId: json['author_id'] as String?,
      authorName: json['author_name'] as String?,
      sizableAvatar: json['sizable_avatar'] as String?,
      songCount: _parseInt(json['song_count']),
      albumCount: _parseInt(json['album_count']),
      intro: json['intro'] as String?,
      fansnums: _parseInt(json['fansnums']),
      mvCount: _parseInt(json['mv_count']),
      birthday: json['birthday'] as String?,
      areaId: _parseInt(json['area_id']),
      isPublish: _parseInt(json['is_publish']),
    );

Map<String, dynamic> _$ArtistDetailResultToJson(ArtistDetailResult instance) =>
    <String, dynamic>{
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'sizable_avatar': instance.sizableAvatar,
      'song_count': instance.songCount,
      'album_count': instance.albumCount,
      'intro': instance.intro,
      'fansnums': instance.fansnums,
      'mv_count': instance.mvCount,
      'birthday': instance.birthday,
      'area_id': instance.areaId,
      'is_publish': instance.isPublish,
    };

ArtistAudioResult _$ArtistAudioResultFromJson(Map<String, dynamic> json) =>
    ArtistAudioResult(
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: _parseInt(json['total_count']),
    );

Map<String, dynamic> _$ArtistAudioResultToJson(ArtistAudioResult instance) =>
    <String, dynamic>{
      'songs': instance.songs,
      'total_count': instance.totalCount,
    };

ArtistAlbumResult _$ArtistAlbumResultFromJson(Map<String, dynamic> json) =>
    ArtistAlbumResult(
      albums: (json['albums'] as List<dynamic>?)
          ?.map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: _parseInt(json['total_count']),
    );

Map<String, dynamic> _$ArtistAlbumResultToJson(ArtistAlbumResult instance) =>
    <String, dynamic>{
      'albums': instance.albums,
      'total_count': instance.totalCount,
    };

ArtistListItem _$ArtistListItemFromJson(Map<String, dynamic> json) =>
    ArtistListItem(
      singerId: _parseInt(json['singerid']),
      singerName: json['singername'] as String?,
      fansCount: _parseInt(json['fanscount']),
      songCount: _parseInt(json['songcount']),
      albumCount: _parseInt(json['albumcount']),
    );

Map<String, dynamic> _$ArtistListItemToJson(ArtistListItem instance) =>
    <String, dynamic>{
      'singerid': instance.singerId,
      'singername': instance.singerName,
      'fanscount': instance.fansCount,
      'songcount': instance.songCount,
      'albumcount': instance.albumCount,
    };

ArtistListGroup _$ArtistListGroupFromJson(Map<String, dynamic> json) =>
    ArtistListGroup(
      title: json['title'] as String?,
      singer: (json['singer'] as List<dynamic>?)
          ?.map((e) => ArtistListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistListGroupToJson(ArtistListGroup instance) =>
    <String, dynamic>{'title': instance.title, 'singer': instance.singer};

ArtistListResult _$ArtistListResultFromJson(Map<String, dynamic> json) =>
    ArtistListResult(
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => ArtistListGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistListResultToJson(ArtistListResult instance) =>
    <String, dynamic>{'info': instance.info};
