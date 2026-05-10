import 'package:json_annotation/json_annotation.dart';
import 'song.dart';

part 'recommend.g.dart';

/// 推荐歌曲结果
@JsonSerializable()
class RecommendSongResult {
  /// 推荐歌曲列表
  final List<Song>? songs;

  /// 歌曲总数
  @JsonKey(name: 'song_count', fromJson: _parseInt)
  final int? songCount;

  /// Creates a new [RecommendSongResult] instance.
  RecommendSongResult({this.songs, this.songCount});

  /// Creates a [RecommendSongResult] from JSON data.
  factory RecommendSongResult.fromJson(Map<String, dynamic> json) => _$RecommendSongResultFromJson(json);
  Map<String, dynamic> toJson() => _$RecommendSongResultToJson(this);
}

/// 新歌速递结果
class NewSongResult {
  /// 新歌列表
  final List<Song>? songs;

  /// Creates a new [NewSongResult] instance.
  NewSongResult({this.songs});

  /// Creates a [NewSongResult] from JSON data.
  factory NewSongResult.fromJson(Map<String, dynamic> json) {
    final dataField = json['data'];
    if (dataField is List) {
      return NewSongResult(
        songs: dataField.whereType<Map<String, dynamic>>().map((e) => Song.fromJson(e)).toList(),
      );
    }
    return NewSongResult(songs: (json['songs'] as List<dynamic>?)?.whereType<Map<String, dynamic>>().map((e) => Song.fromJson(e)).toList());
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
