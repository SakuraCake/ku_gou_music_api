// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FmClassResult _$FmClassResultFromJson(Map<String, dynamic> json) =>
    FmClassResult(
      classList: (json['class_list'] as List<dynamic>?)
          ?.map((e) => FmClassGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      classTotal: _parseInt(json['class_total']),
      updateTime: _parseInt(json['update_time']),
    );

Map<String, dynamic> _$FmClassResultToJson(FmClassResult instance) =>
    <String, dynamic>{
      'class_list': instance.classList,
      'class_total': instance.classTotal,
      'update_time': instance.updateTime,
    };

FmClassGroup _$FmClassGroupFromJson(Map<String, dynamic> json) => FmClassGroup(
  classId: _parseInt(json['classid']),
  className: json['classname'] as String?,
  classCount: _parseInt(json['class_count']),
  fmlist: (json['fmlist'] as List<dynamic>?)
      ?.map((e) => FmClassItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FmClassGroupToJson(FmClassGroup instance) =>
    <String, dynamic>{
      'classid': instance.classId,
      'classname': instance.className,
      'class_count': instance.classCount,
      'fmlist': instance.fmlist,
    };

FmClassItem _$FmClassItemFromJson(Map<String, dynamic> json) => FmClassItem(
  fmId: _parseInt(json['fmid']),
  fmType: _parseInt(json['fmtype']),
  fmName: json['fmname'] as String?,
  img: json['imgurl'] as String?,
  parentId: _parseInt(json['parentId']),
);

Map<String, dynamic> _$FmClassItemToJson(FmClassItem instance) =>
    <String, dynamic>{
      'fmid': instance.fmId,
      'fmtype': instance.fmType,
      'fmname': instance.fmName,
      'imgurl': instance.img,
      'parentId': instance.parentId,
    };

FmSongResult _$FmSongResultFromJson(Map<String, dynamic> json) => FmSongResult(
  songs: (json['songs'] as List<dynamic>?)
      ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FmSongResultToJson(FmSongResult instance) =>
    <String, dynamic>{'songs': instance.songs};

PersonalFmResult _$PersonalFmResultFromJson(Map<String, dynamic> json) =>
    PersonalFmResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: _parseInt(json['has_next']),
    );

Map<String, dynamic> _$PersonalFmResultToJson(PersonalFmResult instance) =>
    <String, dynamic>{'list': instance.list, 'has_next': instance.hasNext};
