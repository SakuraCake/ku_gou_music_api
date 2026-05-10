// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistDetailResult _$PlaylistDetailResultFromJson(
  Map<String, dynamic> json,
) => PlaylistDetailResult(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => PlaylistInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlaylistDetailResultToJson(
  PlaylistDetailResult instance,
) => <String, dynamic>{'list': instance.list};

PlaylistInfo _$PlaylistInfoFromJson(Map<String, dynamic> json) => PlaylistInfo(
  globalCollectionId: json['global_collection_id'] as String?,
  specialId: _parseInt(json['specialid']),
  name: _readName(json, 'name') as String?,
  img: _readImg(json, 'img') as String?,
  singerName: json['singername'] as String?,
  nickname: json['nickname'] as String?,
  playCount: _parseInt(json['play_count']),
  collectCount: _parseInt(json['collectcount']),
  songCount: _parseInt(json['count']),
  intro: json['intro'] as String?,
  publishTime: json['publishtime'] as String?,
);

Map<String, dynamic> _$PlaylistInfoToJson(PlaylistInfo instance) =>
    <String, dynamic>{
      'global_collection_id': instance.globalCollectionId,
      'specialid': instance.specialId,
      'name': instance.name,
      'img': instance.img,
      'singername': instance.singerName,
      'nickname': instance.nickname,
      'play_count': instance.playCount,
      'collectcount': instance.collectCount,
      'count': instance.songCount,
      'intro': instance.intro,
      'publishtime': instance.publishTime,
    };

PlaylistTrackResult _$PlaylistTrackResultFromJson(Map<String, dynamic> json) =>
    PlaylistTrackResult(
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      songCount: _parseInt(json['song_count']),
    );

Map<String, dynamic> _$PlaylistTrackResultToJson(
  PlaylistTrackResult instance,
) => <String, dynamic>{
  'songs': instance.songs,
  'song_count': instance.songCount,
};

PlaylistTag _$PlaylistTagFromJson(Map<String, dynamic> json) => PlaylistTag(
  tagId: _parseInt(json['tag_id']),
  tagName: json['tag_name'] as String?,
  parentId: _parseInt(json['parent_id']),
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => PlaylistTag.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlaylistTagToJson(PlaylistTag instance) =>
    <String, dynamic>{
      'tag_id': instance.tagId,
      'tag_name': instance.tagName,
      'parent_id': instance.parentId,
      'children': instance.children,
    };

SimilarPlaylistResult _$SimilarPlaylistResultFromJson(
  Map<String, dynamic> json,
) => SimilarPlaylistResult(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => PlaylistInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SimilarPlaylistResultToJson(
  SimilarPlaylistResult instance,
) => <String, dynamic>{'list': instance.list};

TopPlaylistResult _$TopPlaylistResultFromJson(Map<String, dynamic> json) =>
    TopPlaylistResult(
      specialList: (json['special_list'] as List<dynamic>?)
          ?.map((e) => PlaylistInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: _parseInt(json['has_next']),
    );

Map<String, dynamic> _$TopPlaylistResultToJson(TopPlaylistResult instance) =>
    <String, dynamic>{
      'special_list': instance.specialList,
      'has_next': instance.hasNext,
    };

PlaylistDeleteResult _$PlaylistDeleteResultFromJson(
  Map<String, dynamic> json,
) => PlaylistDeleteResult(
  status: _parseInt(json['status']),
  error: json['error'] as String?,
);

Map<String, dynamic> _$PlaylistDeleteResultToJson(
  PlaylistDeleteResult instance,
) => <String, dynamic>{'status': instance.status, 'error': instance.error};
