// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumDetailResult _$AlbumDetailResultFromJson(Map<String, dynamic> json) =>
    AlbumDetailResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumDetailResultToJson(AlbumDetailResult instance) =>
    <String, dynamic>{'list': instance.list};

AlbumInfo _$AlbumInfoFromJson(Map<String, dynamic> json) => AlbumInfo(
  albumId: _parseInt(json['albumid']),
  albumName: _readAlbumName(json, 'albumName') as String?,
  img: _readImg(json, 'img') as String?,
  singerId: _parseInt(json['singerid']),
  singerName: _readSingerName(json, 'singerName') as String?,
  songCount: (_readSongCount(json, 'songCount') as num?)?.toInt(),
  publishTime: _readPublishTime(json, 'publishTime') as String?,
  intro: json['intro'] as String?,
  songs: (json['songs'] as List<dynamic>?)
      ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AlbumInfoToJson(AlbumInfo instance) => <String, dynamic>{
  'albumid': instance.albumId,
  'albumName': instance.albumName,
  'img': instance.img,
  'singerid': instance.singerId,
  'singerName': instance.singerName,
  'songCount': instance.songCount,
  'publishTime': instance.publishTime,
  'intro': instance.intro,
  'songs': instance.songs,
};

TopAlbumResult _$TopAlbumResultFromJson(Map<String, dynamic> json) =>
    TopAlbumResult(
      chn: (json['chn'] as List<dynamic>?)
          ?.map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      jpn: (json['jpn'] as List<dynamic>?)
          ?.map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      kor: (json['kor'] as List<dynamic>?)
          ?.map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      eur: (json['eur'] as List<dynamic>?)
          ?.map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: _parseInt(json['timestamp']),
    );

Map<String, dynamic> _$TopAlbumResultToJson(TopAlbumResult instance) =>
    <String, dynamic>{
      'chn': instance.chn,
      'jpn': instance.jpn,
      'kor': instance.kor,
      'eur': instance.eur,
      'timestamp': instance.timestamp,
    };
