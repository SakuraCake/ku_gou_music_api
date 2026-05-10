// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yueku.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YuekuRecommendResult _$YuekuRecommendResultFromJson(
  Map<String, dynamic> json,
) => YuekuRecommendResult(data: json['data'] as Map<String, dynamic>?);

Map<String, dynamic> _$YuekuRecommendResultToJson(
  YuekuRecommendResult instance,
) => <String, dynamic>{'data': instance.data};

YuekuBannerResult _$YuekuBannerResultFromJson(Map<String, dynamic> json) =>
    YuekuBannerResult(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => YuekuBannerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YuekuBannerResultToJson(YuekuBannerResult instance) =>
    <String, dynamic>{'list': instance.list};

YuekuBannerItem _$YuekuBannerItemFromJson(Map<String, dynamic> json) =>
    YuekuBannerItem(
      id: _parseInt(json['id']),
      title: json['title'] as String?,
      imageUrl: json['image_url'] as String?,
      linkUrl: json['link_url'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$YuekuBannerItemToJson(YuekuBannerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image_url': instance.imageUrl,
      'link_url': instance.linkUrl,
      'image': instance.image,
    };

YuekuFmResult _$YuekuFmResultFromJson(Map<String, dynamic> json) =>
    YuekuFmResult(data: json['data']);

Map<String, dynamic> _$YuekuFmResultToJson(YuekuFmResult instance) =>
    <String, dynamic>{'data': instance.data};
