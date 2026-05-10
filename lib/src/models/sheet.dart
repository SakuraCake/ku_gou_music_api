import 'package:json_annotation/json_annotation.dart';

part 'sheet.g.dart';

/// 曲谱合集结果
@JsonSerializable()
class SheetCollectionResult {
  /// 曲谱合集数据
  final dynamic data;

  /// Creates a new [SheetCollectionResult] instance.
  SheetCollectionResult({this.data});

  /// Creates a [SheetCollectionResult] from JSON data.
  factory SheetCollectionResult.fromJson(Map<String, dynamic> json) => _$SheetCollectionResultFromJson(json);
  Map<String, dynamic> toJson() => _$SheetCollectionResultToJson(this);
}

/// 曲谱合集详情结果
@JsonSerializable()
class SheetCollectionDetailResult {
  /// 曲谱合集详情数据
  final dynamic data;

  /// Creates a new [SheetCollectionDetailResult] instance.
  SheetCollectionDetailResult({this.data});

  /// Creates a [SheetCollectionDetailResult] from JSON data.
  factory SheetCollectionDetailResult.fromJson(Map<String, dynamic> json) => _$SheetCollectionDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$SheetCollectionDetailResultToJson(this);
}

/// 曲谱详情结果
@JsonSerializable()
class SheetDetailResult {
  /// 曲谱详情数据
  final dynamic data;

  /// Creates a new [SheetDetailResult] instance.
  SheetDetailResult({this.data});

  /// Creates a [SheetDetailResult] from JSON data.
  factory SheetDetailResult.fromJson(Map<String, dynamic> json) => _$SheetDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$SheetDetailResultToJson(this);
}

/// 热门曲谱结果
@JsonSerializable()
class SheetHotResult {
  /// 热门曲谱数据
  final dynamic data;

  /// Creates a new [SheetHotResult] instance.
  SheetHotResult({this.data});

  /// Creates a [SheetHotResult] from JSON data.
  factory SheetHotResult.fromJson(Map<String, dynamic> json) => _$SheetHotResultFromJson(json);
  Map<String, dynamic> toJson() => _$SheetHotResultToJson(this);
}

/// 曲谱列表结果
@JsonSerializable()
class SheetListResult {
  /// 曲谱列表数据
  final dynamic data;

  /// Creates a new [SheetListResult] instance.
  SheetListResult({this.data});

  /// Creates a [SheetListResult] from JSON data.
  factory SheetListResult.fromJson(Map<String, dynamic> json) => _$SheetListResultFromJson(json);
  Map<String, dynamic> toJson() => _$SheetListResultToJson(this);
}
