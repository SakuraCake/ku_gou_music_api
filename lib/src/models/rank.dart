import 'package:json_annotation/json_annotation.dart';
import 'song.dart';

part 'rank.g.dart';

/// 排行榜列表结果
@JsonSerializable()
class RankListResult {
  /// 排行榜列表
  final List<RankItem>? info;

  /// 总数
  final int? total;

  /// Creates a new [RankListResult] instance.
  RankListResult({this.info, this.total});

  /// Creates a [RankListResult] from JSON data.
  factory RankListResult.fromJson(Map<String, dynamic> json) => _$RankListResultFromJson(json);
  Map<String, dynamic> toJson() => _$RankListResultToJson(this);
}

/// 排行榜条目
@JsonSerializable()
class RankItem {
  /// 排行榜ID
  @JsonKey(name: 'rankid', fromJson: _parseInt)
  final int? rankId;

  /// 排行榜分类ID
  @JsonKey(name: 'rank_cid', fromJson: _parseInt)
  final int? rankCid;

  /// 排行榜名称
  final String? rankname;

  /// 封面图片地址
  @JsonKey(name: 'imgurl')
  final String? img;

  /// 排行榜简介
  final String? intro;

  /// 更新频率
  @JsonKey(name: 'update_frequency')
  final String? updateFrequency;

  /// 播放次数
  @JsonKey(name: 'play_times', fromJson: _parseInt)
  final int? playTimes;

  /// 是否有子排行榜
  @JsonKey(name: 'haschildren', fromJson: _parseInt)
  final int? hasChildren;

  /// 子排行榜列表
  final List<RankItem>? children;

  /// Creates a new [RankItem] instance.
  RankItem({this.rankId, this.rankCid, this.rankname, this.img, this.intro, this.updateFrequency, this.playTimes, this.hasChildren, this.children});

  /// Creates a [RankItem] from JSON data.
  factory RankItem.fromJson(Map<String, dynamic> json) => _$RankItemFromJson(json);
  Map<String, dynamic> toJson() => _$RankItemToJson(this);
}

/// 排行榜详情结果
@JsonSerializable()
class RankInfoResult {
  /// 排行榜ID
  @JsonKey(name: 'rankid', fromJson: _parseInt)
  final int? rankId;

  /// 排行榜名称
  final String? rankname;

  /// 封面图片地址
  @JsonKey(name: 'imgurl')
  final String? img;

  /// 排行榜简介
  final String? intro;

  /// 更新频率
  @JsonKey(name: 'update_frequency')
  final String? updateFrequency;

  /// 排行榜分类ID
  @JsonKey(name: 'rank_cid', fromJson: _parseInt)
  final int? rankCid;

  /// 排行榜歌曲列表
  @JsonKey(name: 'songinfo')
  final List<Song>? songinfo;

  /// Creates a new [RankInfoResult] instance.
  RankInfoResult({this.rankId, this.rankname, this.img, this.intro, this.updateFrequency, this.rankCid, this.songinfo});

  /// Creates a [RankInfoResult] from JSON data.
  factory RankInfoResult.fromJson(Map<String, dynamic> json) => _$RankInfoResultFromJson(json);
  Map<String, dynamic> toJson() => _$RankInfoResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
