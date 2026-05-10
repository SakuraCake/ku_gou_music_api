import 'package:json_annotation/json_annotation.dart';

part 'common.g.dart';

/// 分页信息
@JsonSerializable()
class PageInfo {
  /// 当前页码
  final int? page;

  /// 每页数量
  final int? pageSize;

  /// 总条数
  final int? total;

  /// 总页数
  final int? totalPage;

  /// Creates a new [PageInfo] instance.
  PageInfo({this.page, this.pageSize, this.total, this.totalPage});

  /// Creates a [PageInfo] from JSON data.
  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}

/// 酷狗通用响应结果
@JsonSerializable()
class KuGouResponse {
  /// 响应状态码
  final int? status;

  /// 错误码
  final int? errorCode;

  /// 错误信息
  final String? errorMsg;

  /// 响应数据
  final dynamic data;

  /// Creates a new [KuGouResponse] instance.
  KuGouResponse({this.status, this.errorCode, this.errorMsg, this.data});

  /// Creates a [KuGouResponse] from JSON data.
  factory KuGouResponse.fromJson(Map<String, dynamic> json) =>
      _$KuGouResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KuGouResponseToJson(this);

  /// 请求是否成功
  bool get isSuccess => status == 1 || status == 200;
}
