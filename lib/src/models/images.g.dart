// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumImagesResult _$AlbumImagesResultFromJson(Map<String, dynamic> json) =>
    AlbumImagesResult(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AlbumImageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumImagesResultToJson(AlbumImagesResult instance) =>
    <String, dynamic>{'data': instance.data};

AlbumImageItem _$AlbumImageItemFromJson(Map<String, dynamic> json) =>
    AlbumImageItem(
      hash: json['hash'] as String?,
      albumId: _parseInt(json['album_id']),
      albumAudioId: _parseInt(json['album_audio_id']),
      images: json['images'],
    );

Map<String, dynamic> _$AlbumImageItemToJson(AlbumImageItem instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'album_id': instance.albumId,
      'album_audio_id': instance.albumAudioId,
      'images': instance.images,
    };

AudioImagesResult _$AudioImagesResultFromJson(Map<String, dynamic> json) =>
    AudioImagesResult(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AudioImageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AudioImagesResultToJson(AudioImagesResult instance) =>
    <String, dynamic>{'data': instance.data};

AudioImageItem _$AudioImageItemFromJson(Map<String, dynamic> json) =>
    AudioImageItem(
      hash: json['hash'] as String?,
      audioId: _parseInt(json['audio_id']),
      albumAudioId: _parseInt(json['album_audio_id']),
      filename: json['filename'] as String?,
      images: json['images'],
    );

Map<String, dynamic> _$AudioImageItemToJson(AudioImageItem instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'audio_id': instance.audioId,
      'album_audio_id': instance.albumAudioId,
      'filename': instance.filename,
      'images': instance.images,
    };
