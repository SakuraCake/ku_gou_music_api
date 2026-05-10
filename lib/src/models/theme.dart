import 'package:json_annotation/json_annotation.dart';

part 'theme.g.dart';

/// 主题音乐结果
@JsonSerializable()
class ThemeMusicResult {
  /// 主题音乐数据
  final dynamic data;

  /// Creates a new [ThemeMusicResult] instance.
  ThemeMusicResult({this.data});

  /// Creates a [ThemeMusicResult] from JSON data.
  factory ThemeMusicResult.fromJson(Map<String, dynamic> json) => _$ThemeMusicResultFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeMusicResultToJson(this);
}

/// 主题音乐详情结果
@JsonSerializable()
class ThemeMusicDetailResult {
  /// 主题音乐详情数据
  final dynamic data;

  /// Creates a new [ThemeMusicDetailResult] instance.
  ThemeMusicDetailResult({this.data});

  /// Creates a [ThemeMusicDetailResult] from JSON data.
  factory ThemeMusicDetailResult.fromJson(Map<String, dynamic> json) => _$ThemeMusicDetailResultFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeMusicDetailResultToJson(this);
}

/// 主题歌单结果
@JsonSerializable()
class ThemePlaylistResult {
  /// 主题歌单数据
  final dynamic data;

  /// Creates a new [ThemePlaylistResult] instance.
  ThemePlaylistResult({this.data});

  /// Creates a [ThemePlaylistResult] from JSON data.
  factory ThemePlaylistResult.fromJson(Map<String, dynamic> json) => _$ThemePlaylistResultFromJson(json);
  Map<String, dynamic> toJson() => _$ThemePlaylistResultToJson(this);
}

/// 主题歌单曲目结果
@JsonSerializable()
class ThemePlaylistTrackResult {
  /// 主题歌单曲目数据
  final dynamic data;

  /// Creates a new [ThemePlaylistTrackResult] instance.
  ThemePlaylistTrackResult({this.data});

  /// Creates a [ThemePlaylistTrackResult] from JSON data.
  factory ThemePlaylistTrackResult.fromJson(Map<String, dynamic> json) => _$ThemePlaylistTrackResultFromJson(json);
  Map<String, dynamic> toJson() => _$ThemePlaylistTrackResultToJson(this);
}
