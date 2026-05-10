// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LyricSearchResult _$LyricSearchResultFromJson(Map<String, dynamic> json) =>
    LyricSearchResult(
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) => LyricItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LyricSearchResultToJson(LyricSearchResult instance) =>
    <String, dynamic>{
      'candidates': instance.candidates,
      'count': instance.count,
    };

LyricItem _$LyricItemFromJson(Map<String, dynamic> json) => LyricItem(
  id: json['id'] as String?,
  accesskey: json['accesskey'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  song: json['song'] as String?,
  singer: json['singer'] as String?,
  lrcContent: json['lrc_content'] as String?,
);

Map<String, dynamic> _$LyricItemToJson(LyricItem instance) => <String, dynamic>{
  'id': instance.id,
  'accesskey': instance.accesskey,
  'duration': instance.duration,
  'song': instance.song,
  'singer': instance.singer,
  'lrc_content': instance.lrcContent,
};

LyricResult _$LyricResultFromJson(Map<String, dynamic> json) => LyricResult(
  content: json['content'] as String?,
  format: json['format'] as String?,
  info: json['info'] as String?,
  status: (json['status'] as num?)?.toInt(),
  errorCode: (json['error_code'] as num?)?.toInt(),
  charset: json['charset'] as String?,
  contenttype: (json['contenttype'] as num?)?.toInt(),
  fmt: json['fmt'] as String?,
);

Map<String, dynamic> _$LyricResultToJson(LyricResult instance) =>
    <String, dynamic>{
      'content': instance.content,
      'format': instance.format,
      'info': instance.info,
      'status': instance.status,
      'error_code': instance.errorCode,
      'charset': instance.charset,
      'contenttype': instance.contenttype,
      'fmt': instance.fmt,
    };
