import 'package:json_annotation/json_annotation.dart';

part 'video.g.dart';

/// 视频详情结果
@JsonSerializable()
class VideoDetailResult {
  /// 视频详情数据
  final dynamic data;

  /// Creates a new [VideoDetailResult] instance.
  VideoDetailResult({this.data});

  /// Creates a [VideoDetailResult] from JSON data.
  factory VideoDetailResult.fromJson(Map<String, dynamic> json) => _$VideoDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$VideoDetailResultToJson(this);
}

/// 视频权限结果
@JsonSerializable()
class VideoPrivilegeResult {
  /// 视频权限数据
  final dynamic data;

  /// Creates a new [VideoPrivilegeResult] instance.
  VideoPrivilegeResult({this.data});

  /// Creates a [VideoPrivilegeResult] from JSON data.
  factory VideoPrivilegeResult.fromJson(Map<String, dynamic> json) => _$VideoPrivilegeResultFromJson(json);
  Map<String, dynamic> toJson() => _$VideoPrivilegeResultToJson(this);
}

/// 视频播放地址结果
@JsonSerializable()
class VideoUrlResult {
  /// 视频播放地址数据
  final dynamic data;

  /// Creates a new [VideoUrlResult] instance.
  VideoUrlResult({this.data});

  /// Creates a [VideoUrlResult] from JSON data.
  factory VideoUrlResult.fromJson(Map<String, dynamic> json) => _$VideoUrlResultFromJson(json);
  Map<String, dynamic> toJson() => _$VideoUrlResultToJson(this);
}
