// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo(
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  totalPage: (json['totalPage'] as num?)?.toInt(),
);

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'total': instance.total,
  'totalPage': instance.totalPage,
};

KuGouResponse _$KuGouResponseFromJson(Map<String, dynamic> json) =>
    KuGouResponse(
      status: (json['status'] as num?)?.toInt(),
      errorCode: (json['errorCode'] as num?)?.toInt(),
      errorMsg: json['errorMsg'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$KuGouResponseToJson(KuGouResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data,
    };
