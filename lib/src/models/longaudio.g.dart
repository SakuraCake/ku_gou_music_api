// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'longaudio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongaudioDetailResult _$LongaudioDetailResultFromJson(
  Map<String, dynamic> json,
) => LongaudioDetailResult(
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => LongaudioAlbumItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LongaudioDetailResultToJson(
  LongaudioDetailResult instance,
) => <String, dynamic>{'data': instance.data};

LongaudioAlbumItem _$LongaudioAlbumItemFromJson(Map<String, dynamic> json) =>
    LongaudioAlbumItem(
      albumId: _parseInt(json['album_id']),
      albumName: json['album_name'] as String?,
      category: json['category'] as String?,
      authors: json['authors'],
      sizableCover: json['sizable_cover'] as String?,
      intro: json['intro'] as String?,
      authorName: json['author_name'] as String?,
      isPublish: _parseInt(json['is_publish']),
      albumTag: json['album_tag'],
      mixIntro: json['mix_intro'] as String?,
      fullIntro: json['full_intro'] as String?,
      transParam: json['trans_param'],
    );

Map<String, dynamic> _$LongaudioAlbumItemToJson(LongaudioAlbumItem instance) =>
    <String, dynamic>{
      'album_id': instance.albumId,
      'album_name': instance.albumName,
      'category': instance.category,
      'authors': instance.authors,
      'sizable_cover': instance.sizableCover,
      'intro': instance.intro,
      'author_name': instance.authorName,
      'is_publish': instance.isPublish,
      'album_tag': instance.albumTag,
      'mix_intro': instance.mixIntro,
      'full_intro': instance.fullIntro,
      'trans_param': instance.transParam,
    };

LongaudioAudiosResult _$LongaudioAudiosResultFromJson(
  Map<String, dynamic> json,
) => LongaudioAudiosResult(
  info: (json['info'] as List<dynamic>?)
      ?.map((e) => LongaudioAudioItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LongaudioAudiosResultToJson(
  LongaudioAudiosResult instance,
) => <String, dynamic>{'info': instance.info};

LongaudioAudioItem _$LongaudioAudioItemFromJson(Map<String, dynamic> json) =>
    LongaudioAudioItem(
      audioId: _parseInt(json['audio_id']),
      hash: json['hash'] as String?,
      fileName: json['file_name'] as String?,
      duration: _parseInt(json['duration']),
      albumId: _parseInt(json['album_id']),
      audioName: json['audio_name'] as String?,
    );

Map<String, dynamic> _$LongaudioAudioItemToJson(LongaudioAudioItem instance) =>
    <String, dynamic>{
      'audio_id': instance.audioId,
      'hash': instance.hash,
      'file_name': instance.fileName,
      'duration': instance.duration,
      'album_id': instance.albumId,
      'audio_name': instance.audioName,
    };

LongaudioDailyResult _$LongaudioDailyResultFromJson(
  Map<String, dynamic> json,
) => LongaudioDailyResult(data: json['data'] as Map<String, dynamic>?);

Map<String, dynamic> _$LongaudioDailyResultToJson(
  LongaudioDailyResult instance,
) => <String, dynamic>{'data': instance.data};

LongaudioRankResult _$LongaudioRankResultFromJson(Map<String, dynamic> json) =>
    LongaudioRankResult(data: json['data']);

Map<String, dynamic> _$LongaudioRankResultToJson(
  LongaudioRankResult instance,
) => <String, dynamic>{'data': instance.data};

LongaudioVipResult _$LongaudioVipResultFromJson(Map<String, dynamic> json) =>
    LongaudioVipResult(data: json['data'] as Map<String, dynamic>?);

Map<String, dynamic> _$LongaudioVipResultToJson(LongaudioVipResult instance) =>
    <String, dynamic>{'data': instance.data};

LongaudioWeekResult _$LongaudioWeekResultFromJson(Map<String, dynamic> json) =>
    LongaudioWeekResult(data: json['data'] as Map<String, dynamic>?);

Map<String, dynamic> _$LongaudioWeekResultToJson(
  LongaudioWeekResult instance,
) => <String, dynamic>{'data': instance.data};
