import 'package:json_annotation/json_annotation.dart';

part 'misc.g.dart';

/// 歌手列表结果
@JsonSerializable()
class SingerListResult {
  /// 歌手列表数据
  final dynamic data;

  /// Creates a new [SingerListResult] instance.
  SingerListResult({this.data});

  /// Creates a [SingerListResult] from JSON data.
  factory SingerListResult.fromJson(Map<String, dynamic> json) => _$SingerListResultFromJson(json);
  Map<String, dynamic> toJson() => _$SingerListResultToJson(this);
}

/// 最新歌曲结果
@JsonSerializable()
class LatestSongsResult {
  /// 最新歌曲数据
  final dynamic data;

  /// Creates a new [LatestSongsResult] instance.
  LatestSongsResult({this.data});

  /// Creates a [LatestSongsResult] from JSON data.
  factory LatestSongsResult.fromJson(Map<String, dynamic> json) => _$LatestSongsResultFromJson(json);
  Map<String, dynamic> toJson() => _$LatestSongsResultToJson(this);
}

/// 服务器时间结果
@JsonSerializable()
class ServerNowResult {
  /// 服务器时间数据
  final dynamic data;

  /// Creates a new [ServerNowResult] instance.
  ServerNowResult({this.data});

  /// Creates a [ServerNowResult] from JSON data.
  factory ServerNowResult.fromJson(Map<String, dynamic> json) => _$ServerNowResultFromJson(json);
  Map<String, dynamic> toJson() => _$ServerNowResultToJson(this);
}

/// 轻量级权限结果
@JsonSerializable()
class PrivilegeLiteResult {
  /// 权限数据
  final dynamic data;

  /// Creates a new [PrivilegeLiteResult] instance.
  PrivilegeLiteResult({this.data});

  /// Creates a [PrivilegeLiteResult] from JSON data.
  factory PrivilegeLiteResult.fromJson(Map<String, dynamic> json) => _$PrivilegeLiteResultFromJson(json);
  Map<String, dynamic> toJson() => _$PrivilegeLiteResultToJson(this);
}

/// 刷一刷结果
@JsonSerializable()
class BrushResult {
  /// 刷一刷数据
  final dynamic data;

  /// Creates a new [BrushResult] instance.
  BrushResult({this.data});

  /// Creates a [BrushResult] from JSON data.
  factory BrushResult.fromJson(Map<String, dynamic> json) => _$BrushResultFromJson(json);
  Map<String, dynamic> toJson() => _$BrushResultToJson(this);
}
