// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendSongResult _$RecommendSongResultFromJson(Map<String, dynamic> json) =>
    RecommendSongResult(
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      songCount: _parseInt(json['song_count']),
    );

Map<String, dynamic> _$RecommendSongResultToJson(
  RecommendSongResult instance,
) => <String, dynamic>{
  'songs': instance.songs,
  'song_count': instance.songCount,
};
