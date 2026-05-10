// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpContentResult _$IpContentResultFromJson(Map<String, dynamic> json) =>
    IpContentResult(
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      total: _parseInt(json['total']),
      hasNext: _parseInt(json['has_next']),
    );

Map<String, dynamic> _$IpContentResultToJson(IpContentResult instance) =>
    <String, dynamic>{
      'info': instance.info,
      'total': instance.total,
      'has_next': instance.hasNext,
    };

IpDetailResult _$IpDetailResultFromJson(Map<String, dynamic> json) =>
    IpDetailResult(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IpDetailItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IpDetailResultToJson(IpDetailResult instance) =>
    <String, dynamic>{'data': instance.data};

IpDetailItem _$IpDetailItemFromJson(Map<String, dynamic> json) => IpDetailItem(
  ipId: _parseInt(json['ip_id']),
  name: json['name'] as String?,
  cover: json['cover'] as String?,
  intro: json['intro'] as String?,
  isPublish: _parseInt(json['is_publish']),
  authorName: json['author_name'] as String?,
  songCount: _parseInt(json['song_count']),
  albumCount: _parseInt(json['album_count']),
  videoCount: _parseInt(json['video_count']),
  extra: json['extra'],
);

Map<String, dynamic> _$IpDetailItemToJson(IpDetailItem instance) =>
    <String, dynamic>{
      'ip_id': instance.ipId,
      'name': instance.name,
      'cover': instance.cover,
      'intro': instance.intro,
      'is_publish': instance.isPublish,
      'author_name': instance.authorName,
      'song_count': instance.songCount,
      'album_count': instance.albumCount,
      'video_count': instance.videoCount,
      'extra': instance.extra,
    };

IpPlaylistResult _$IpPlaylistResultFromJson(Map<String, dynamic> json) =>
    IpPlaylistResult(
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => IpPlaylistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: _parseInt(json['total']),
      hasNext: _parseInt(json['has_next']),
    );

Map<String, dynamic> _$IpPlaylistResultToJson(IpPlaylistResult instance) =>
    <String, dynamic>{
      'info': instance.info,
      'total': instance.total,
      'has_next': instance.hasNext,
    };

IpPlaylistItem _$IpPlaylistItemFromJson(Map<String, dynamic> json) =>
    IpPlaylistItem(
      specialId: _parseInt(json['specialid']),
      specialName: json['special_name'] as String?,
      img: json['img'] as String?,
      playCount: _parseInt(json['play_count']),
      songCount: _parseInt(json['song_count']),
      intro: json['intro'] as String?,
      globalCollectionId: json['global_collection_id'] as String?,
      singerName: json['singerName'] as String?,
    );

Map<String, dynamic> _$IpPlaylistItemToJson(IpPlaylistItem instance) =>
    <String, dynamic>{
      'specialid': instance.specialId,
      'special_name': instance.specialName,
      'img': instance.img,
      'play_count': instance.playCount,
      'song_count': instance.songCount,
      'intro': instance.intro,
      'global_collection_id': instance.globalCollectionId,
      'singerName': instance.singerName,
    };

IpZoneResult _$IpZoneResultFromJson(Map<String, dynamic> json) => IpZoneResult(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => IpZoneItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IpZoneResultToJson(IpZoneResult instance) =>
    <String, dynamic>{'list': instance.list};

IpZoneItem _$IpZoneItemFromJson(Map<String, dynamic> json) => IpZoneItem(
  ipId: _parseInt(json['ip_id']),
  name: json['name'] as String?,
  cover: json['cover'] as String?,
  specialLink: json['special_link'] as String?,
  intro: json['intro'] as String?,
  isPublish: _parseInt(json['is_publish']),
  extra: json['extra'],
);

Map<String, dynamic> _$IpZoneItemToJson(IpZoneItem instance) =>
    <String, dynamic>{
      'ip_id': instance.ipId,
      'name': instance.name,
      'cover': instance.cover,
      'special_link': instance.specialLink,
      'intro': instance.intro,
      'is_publish': instance.isPublish,
      'extra': instance.extra,
    };

IpZoneHomeResult _$IpZoneHomeResultFromJson(Map<String, dynamic> json) =>
    IpZoneHomeResult(
      ipId: _parseInt(json['ip_id']),
      name: json['name'] as String?,
      cover: json['cover'] as String?,
      intro: json['intro'] as String?,
      banner: json['banner'],
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      extra: json['extra'],
    );

Map<String, dynamic> _$IpZoneHomeResultToJson(IpZoneHomeResult instance) =>
    <String, dynamic>{
      'ip_id': instance.ipId,
      'name': instance.name,
      'cover': instance.cover,
      'intro': instance.intro,
      'banner': instance.banner,
      'modules': instance.modules,
      'extra': instance.extra,
    };
