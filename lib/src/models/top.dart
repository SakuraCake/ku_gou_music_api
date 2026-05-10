import 'package:json_annotation/json_annotation.dart';

part 'top.g.dart';

/// 置顶卡片结果
@JsonSerializable()
class TopCardResult {
  /// 卡片信息
  final dynamic cardInfo;

  /// 歌曲列表
  final List<Map<String, dynamic>>? songList;

  /// 模块列表
  final List<Map<String, dynamic>>? modules;

  /// 卡片ID
  @JsonKey(name: 'card_id', fromJson: _parseInt)
  final int? cardId;

  /// 标题
  final String? title;

  /// 扩展数据
  final dynamic extra;

  /// Creates a new [TopCardResult] instance.
  TopCardResult({
    this.cardInfo,
    this.songList,
    this.modules,
    this.cardId,
    this.title,
    this.extra,
  });

  /// Creates a [TopCardResult] from JSON data.
  factory TopCardResult.fromJson(Map<String, dynamic> json) => _$TopCardResultFromJson(json);
  Map<String, dynamic> toJson() => _$TopCardResultToJson(this);
}

/// 置顶青年卡片结果
@JsonSerializable()
class TopCardYouthResult {
  /// 卡片信息
  final dynamic cardInfo;

  /// 歌曲列表
  final List<Map<String, dynamic>>? songList;

  /// 模块列表
  final List<Map<String, dynamic>>? modules;

  /// 卡片ID
  @JsonKey(name: 'card_id', fromJson: _parseInt)
  final int? cardId;

  /// 模块ID
  @JsonKey(name: 'module_id', fromJson: _parseInt)
  final int? moduleId;

  /// 标题
  final String? title;

  /// 扩展数据
  final dynamic extra;

  /// Creates a new [TopCardYouthResult] instance.
  TopCardYouthResult({
    this.cardInfo,
    this.songList,
    this.modules,
    this.cardId,
    this.moduleId,
    this.title,
    this.extra,
  });

  /// Creates a [TopCardYouthResult] from JSON data.
  factory TopCardYouthResult.fromJson(Map<String, dynamic> json) => _$TopCardYouthResultFromJson(json);
  Map<String, dynamic> toJson() => _$TopCardYouthResultToJson(this);
}

/// 置顶IP结果
@JsonSerializable()
class TopIpResult {
  /// IP列表
  final List<TopIpItem>? list;

  /// Creates a new [TopIpResult] instance.
  TopIpResult({this.list});

  /// Creates a [TopIpResult] from JSON data.
  factory TopIpResult.fromJson(Map<String, dynamic> json) => _$TopIpResultFromJson(json);
  Map<String, dynamic> toJson() => _$TopIpResultToJson(this);
}

/// 置顶IP条目
@JsonSerializable()
class TopIpItem {
  /// IP标识
  @JsonKey(name: 'ip_id', fromJson: _parseInt)
  final int? ipId;

  /// IP名称
  final String? name;

  /// 封面图片地址
  final String? cover;

  /// IP简介
  final String? intro;

  /// 内部链接
  @JsonKey(name: 'inner_url')
  final String? innerUrl;

  /// 扩展数据
  final dynamic extra;

  /// Creates a new [TopIpItem] instance.
  TopIpItem({
    this.ipId,
    this.name,
    this.cover,
    this.intro,
    this.innerUrl,
    this.extra,
  });

  /// 提取IP标识，优先使用ipId，其次从innerUrl中解析
  int? get extractedIpId {
    if (ipId != null) return ipId;
    if (innerUrl != null) {
      final match = RegExp(r'ip_id=(\d+)').firstMatch(innerUrl!);
      if (match != null) return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }

  /// Creates a [TopIpItem] from JSON data.
  factory TopIpItem.fromJson(Map<String, dynamic> json) => _$TopIpItemFromJson(json);
  Map<String, dynamic> toJson() => _$TopIpItemToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
