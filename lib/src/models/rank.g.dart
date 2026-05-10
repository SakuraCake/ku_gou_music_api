// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankListResult _$RankListResultFromJson(Map<String, dynamic> json) =>
    RankListResult(
      info: (json['info'] as List<dynamic>?)
          ?.map((e) => RankItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RankListResultToJson(RankListResult instance) =>
    <String, dynamic>{'info': instance.info, 'total': instance.total};

RankItem _$RankItemFromJson(Map<String, dynamic> json) => RankItem(
  rankId: _parseInt(json['rankid']),
  rankCid: _parseInt(json['rank_cid']),
  rankname: json['rankname'] as String?,
  img: json['imgurl'] as String?,
  intro: json['intro'] as String?,
  updateFrequency: json['update_frequency'] as String?,
  playTimes: _parseInt(json['play_times']),
  hasChildren: _parseInt(json['haschildren']),
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => RankItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RankItemToJson(RankItem instance) => <String, dynamic>{
  'rankid': instance.rankId,
  'rank_cid': instance.rankCid,
  'rankname': instance.rankname,
  'imgurl': instance.img,
  'intro': instance.intro,
  'update_frequency': instance.updateFrequency,
  'play_times': instance.playTimes,
  'haschildren': instance.hasChildren,
  'children': instance.children,
};

RankInfoResult _$RankInfoResultFromJson(Map<String, dynamic> json) =>
    RankInfoResult(
      rankId: _parseInt(json['rankid']),
      rankname: json['rankname'] as String?,
      img: json['imgurl'] as String?,
      intro: json['intro'] as String?,
      updateFrequency: json['update_frequency'] as String?,
      rankCid: _parseInt(json['rank_cid']),
      songinfo: (json['songinfo'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RankInfoResultToJson(RankInfoResult instance) =>
    <String, dynamic>{
      'rankid': instance.rankId,
      'rankname': instance.rankname,
      'imgurl': instance.img,
      'intro': instance.intro,
      'update_frequency': instance.updateFrequency,
      'rank_cid': instance.rankCid,
      'songinfo': instance.songinfo,
    };
