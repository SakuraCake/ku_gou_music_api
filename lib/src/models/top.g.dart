// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopCardResult _$TopCardResultFromJson(Map<String, dynamic> json) =>
    TopCardResult(
      cardInfo: json['cardInfo'],
      songList: (json['songList'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      cardId: _parseInt(json['card_id']),
      title: json['title'] as String?,
      extra: json['extra'],
    );

Map<String, dynamic> _$TopCardResultToJson(TopCardResult instance) =>
    <String, dynamic>{
      'cardInfo': instance.cardInfo,
      'songList': instance.songList,
      'modules': instance.modules,
      'card_id': instance.cardId,
      'title': instance.title,
      'extra': instance.extra,
    };

TopCardYouthResult _$TopCardYouthResultFromJson(Map<String, dynamic> json) =>
    TopCardYouthResult(
      cardInfo: json['cardInfo'],
      songList: (json['songList'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      cardId: _parseInt(json['card_id']),
      moduleId: _parseInt(json['module_id']),
      title: json['title'] as String?,
      extra: json['extra'],
    );

Map<String, dynamic> _$TopCardYouthResultToJson(TopCardYouthResult instance) =>
    <String, dynamic>{
      'cardInfo': instance.cardInfo,
      'songList': instance.songList,
      'modules': instance.modules,
      'card_id': instance.cardId,
      'module_id': instance.moduleId,
      'title': instance.title,
      'extra': instance.extra,
    };

TopIpResult _$TopIpResultFromJson(Map<String, dynamic> json) => TopIpResult(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => TopIpItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TopIpResultToJson(TopIpResult instance) =>
    <String, dynamic>{'list': instance.list};

TopIpItem _$TopIpItemFromJson(Map<String, dynamic> json) => TopIpItem(
  ipId: _parseInt(json['ip_id']),
  name: json['name'] as String?,
  cover: json['cover'] as String?,
  intro: json['intro'] as String?,
  innerUrl: json['inner_url'] as String?,
  extra: json['extra'],
);

Map<String, dynamic> _$TopIpItemToJson(TopIpItem instance) => <String, dynamic>{
  'ip_id': instance.ipId,
  'name': instance.name,
  'cover': instance.cover,
  'intro': instance.intro,
  'inner_url': instance.innerUrl,
  'extra': instance.extra,
};
