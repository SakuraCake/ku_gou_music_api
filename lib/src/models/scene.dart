import 'package:json_annotation/json_annotation.dart';

part 'scene.g.dart';

/// 场景列表结果
@JsonSerializable()
class SceneListResult {
  /// 场景列表数据
  final dynamic data;

  /// Creates a new [SceneListResult] instance.
  SceneListResult({this.data});

  /// Creates a [SceneListResult] from JSON data.
  factory SceneListResult.fromJson(Map<String, dynamic> json) => _$SceneListResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneListResultToJson(this);
}

/// 场景模块结果
@JsonSerializable()
class SceneModuleResult {
  /// 场景模块数据
  final dynamic data;

  /// Creates a new [SceneModuleResult] instance.
  SceneModuleResult({this.data});

  /// Creates a [SceneModuleResult] from JSON data.
  factory SceneModuleResult.fromJson(Map<String, dynamic> json) => _$SceneModuleResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneModuleResultToJson(this);
}

/// 场景模块详情结果
@JsonSerializable()
class SceneModuleInfoResult {
  /// 场景模块详情数据
  final dynamic data;

  /// Creates a new [SceneModuleInfoResult] instance.
  SceneModuleInfoResult({this.data});

  /// Creates a [SceneModuleInfoResult] from JSON data.
  factory SceneModuleInfoResult.fromJson(Map<String, dynamic> json) => _$SceneModuleInfoResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneModuleInfoResultToJson(this);
}

/// 场景音频列表结果
@JsonSerializable()
class SceneAudioListResult {
  /// 场景音频列表数据
  final dynamic data;

  /// Creates a new [SceneAudioListResult] instance.
  SceneAudioListResult({this.data});

  /// Creates a [SceneAudioListResult] from JSON data.
  factory SceneAudioListResult.fromJson(Map<String, dynamic> json) => _$SceneAudioListResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneAudioListResultToJson(this);
}

/// 场景音乐结果
@JsonSerializable()
class SceneMusicResult {
  /// 场景音乐数据
  final dynamic data;

  /// Creates a new [SceneMusicResult] instance.
  SceneMusicResult({this.data});

  /// Creates a [SceneMusicResult] from JSON data.
  factory SceneMusicResult.fromJson(Map<String, dynamic> json) => _$SceneMusicResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneMusicResultToJson(this);
}

/// 场景收藏列表结果
@JsonSerializable()
class SceneCollectionListResult {
  /// 场景收藏列表数据
  final dynamic data;

  /// Creates a new [SceneCollectionListResult] instance.
  SceneCollectionListResult({this.data});

  /// Creates a [SceneCollectionListResult] from JSON data.
  factory SceneCollectionListResult.fromJson(Map<String, dynamic> json) => _$SceneCollectionListResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneCollectionListResultToJson(this);
}

/// 场景视频列表结果
@JsonSerializable()
class SceneVideoListResult {
  /// 场景视频列表数据
  final dynamic data;

  /// Creates a new [SceneVideoListResult] instance.
  SceneVideoListResult({this.data});

  /// Creates a [SceneVideoListResult] from JSON data.
  factory SceneVideoListResult.fromJson(Map<String, dynamic> json) => _$SceneVideoListResultFromJson(json);
  Map<String, dynamic> toJson() => _$SceneVideoListResultToJson(this);
}
