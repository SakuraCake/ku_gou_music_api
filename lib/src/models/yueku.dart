import 'package:json_annotation/json_annotation.dart';

part 'yueku.g.dart';

/// 乐库推荐结果
@JsonSerializable()
class YuekuRecommendResult {
  /// 推荐数据
  final Map<String, dynamic>? data;

  /// Creates a new [YuekuRecommendResult] instance.
  YuekuRecommendResult({this.data});

  /// Creates a [YuekuRecommendResult] from JSON data.
  factory YuekuRecommendResult.fromJson(Map<String, dynamic> json) => _$YuekuRecommendResultFromJson(json);
  Map<String, dynamic> toJson() => _$YuekuRecommendResultToJson(this);
}

/// 乐库轮播图结果
@JsonSerializable()
class YuekuBannerResult {
  /// 轮播图列表
  final List<YuekuBannerItem>? list;

  /// Creates a new [YuekuBannerResult] instance.
  YuekuBannerResult({this.list});

  /// Creates a [YuekuBannerResult] from JSON data.
  factory YuekuBannerResult.fromJson(Map<String, dynamic> json) => _$YuekuBannerResultFromJson(json);
  Map<String, dynamic> toJson() => _$YuekuBannerResultToJson(this);
}

/// 乐库轮播图条目
@JsonSerializable()
class YuekuBannerItem {
  /// 轮播图ID
  @JsonKey(name: 'id', fromJson: _parseInt)
  final int? id;

  /// 标题
  final String? title;

  /// 图片地址
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  /// 跳转链接
  @JsonKey(name: 'link_url')
  final String? linkUrl;

  /// 图片地址（备用字段）
  @JsonKey(name: 'image')
  final String? image;

  /// Creates a new [YuekuBannerItem] instance.
  YuekuBannerItem({this.id, this.title, this.imageUrl, this.linkUrl, this.image});

  /// Creates a [YuekuBannerItem] from JSON data.
  factory YuekuBannerItem.fromJson(Map<String, dynamic> json) => _$YuekuBannerItemFromJson(json);
  Map<String, dynamic> toJson() => _$YuekuBannerItemToJson(this);
}

/// 乐库电台结果
@JsonSerializable()
class YuekuFmResult {
  /// 电台数据
  final dynamic data;

  /// Creates a new [YuekuFmResult] instance.
  YuekuFmResult({this.data});

  /// Creates a [YuekuFmResult] from JSON data.
  factory YuekuFmResult.fromJson(Map<String, dynamic> json) => _$YuekuFmResultFromJson(json);
  Map<String, dynamic> toJson() => _$YuekuFmResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
