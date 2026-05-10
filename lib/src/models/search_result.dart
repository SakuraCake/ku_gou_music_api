import 'package:json_annotation/json_annotation.dart';
import 'song.dart';

part 'search_result.g.dart';

/// 搜索类型枚举
enum SearchType {
  /// 歌曲
  song,

  /// 歌单
  special,

  /// 专辑
  album,

  /// 歌手
  author,

  /// 歌词
  lyric,

  /// MV
  mv
}

/// 搜索结果
@JsonSerializable()
class SearchResult {
  /// 搜索关键词
  final String? keyword;

  /// 歌曲列表
  final List<Song>? songs;

  /// 专辑列表
  final List<SearchAlbum>? albums;

  /// 歌手列表
  final List<SearchArtist>? artists;

  /// 歌单列表
  final List<SearchPlaylist>? playlists;

  /// 总条数
  final int? total;

  /// 当前页码
  final int? page;

  /// 每页数量
  final int? pageSize;

  /// Creates a new [SearchResult] instance.
  SearchResult({
    this.keyword,
    this.songs,
    this.albums,
    this.artists,
    this.playlists,
    this.total,
    this.page,
    this.pageSize,
  });

  /// Creates a [SearchResult] from JSON data.
  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);
}

/// 搜索结果中的专辑信息
@JsonSerializable()
class SearchAlbum {
  /// 专辑ID
  final int? albumId;

  /// 专辑名称
  final String? albumName;

  /// 封面图片地址
  final String? img;

  /// 歌手名称
  final String? singer;

  /// 歌曲数量
  final int? songCount;

  /// 发布日期
  final String? publishDate;

  /// Creates a new [SearchAlbum] instance.
  SearchAlbum({
    this.albumId,
    this.albumName,
    this.img,
    this.singer,
    this.songCount,
    this.publishDate,
  });

  /// Creates a [SearchAlbum] from JSON data.
  factory SearchAlbum.fromJson(Map<String, dynamic> json) =>
      _$SearchAlbumFromJson(json);
  Map<String, dynamic> toJson() => _$SearchAlbumToJson(this);
}

/// 搜索结果中的歌手信息
@JsonSerializable()
class SearchArtist {
  /// 歌手ID
  final int? artistId;

  /// 歌手名称
  final String? artistName;

  /// 头像图片地址
  final String? img;

  /// 歌曲数量
  final int? songCount;

  /// Creates a new [SearchArtist] instance.
  SearchArtist({this.artistId, this.artistName, this.img, this.songCount});

  /// Creates a [SearchArtist] from JSON data.
  factory SearchArtist.fromJson(Map<String, dynamic> json) =>
      _$SearchArtistFromJson(json);
  Map<String, dynamic> toJson() => _$SearchArtistToJson(this);
}

/// 搜索结果中的歌单信息
@JsonSerializable()
class SearchPlaylist {
  /// 歌单ID
  final int? specialId;

  /// 歌单名称
  final String? specialName;

  /// 封面图片地址
  final String? img;

  /// 歌曲数量
  final int? songCount;

  /// 作者
  final String? author;

  /// Creates a new [SearchPlaylist] instance.
  SearchPlaylist({
    this.specialId,
    this.specialName,
    this.img,
    this.songCount,
    this.author,
  });

  /// Creates a [SearchPlaylist] from JSON data.
  factory SearchPlaylist.fromJson(Map<String, dynamic> json) =>
      _$SearchPlaylistFromJson(json);
  Map<String, dynamic> toJson() => _$SearchPlaylistToJson(this);
}

/// 热搜词条
@JsonSerializable()
class HotSearchItem {
  /// 搜索词
  final String? searchWord;

  /// 关键词
  final String? keyword;

  /// 热度分数
  final int? score;

  /// 内容描述
  final String? content;

  /// Creates a new [HotSearchItem] instance.
  HotSearchItem({this.searchWord, this.keyword, this.score, this.content});

  /// 显示文本，优先使用content
  String? get displayText => content ?? keyword ?? searchWord;

  /// Creates a [HotSearchItem] from JSON data.
  factory HotSearchItem.fromJson(Map<String, dynamic> json) =>
      _$HotSearchItemFromJson(json);
  Map<String, dynamic> toJson() => _$HotSearchItemToJson(this);
}

/// 搜索建议
@JsonSerializable()
class SearchSuggest {
  /// 关键词
  final String? keyword;

  /// 建议歌曲列表
  final List<String>? songs;

  /// 建议专辑列表
  final List<String>? albums;

  /// 建议歌手列表
  final List<String>? artists;

  /// Creates a new [SearchSuggest] instance.
  SearchSuggest({this.keyword, this.songs, this.albums, this.artists});

  /// Creates a [SearchSuggest] from JSON data.
  factory SearchSuggest.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestFromJson(json);
  Map<String, dynamic> toJson() => _$SearchSuggestToJson(this);
}

/// 综合搜索结果
@JsonSerializable()
class SearchComplexResult {
  /// 列表数据
  final dynamic lists;

  /// 响应码
  @JsonKey(fromJson: _parseInt)
  final int? code;

  /// Creates a new [SearchComplexResult] instance.
  SearchComplexResult({this.lists, this.code});

  /// Creates a [SearchComplexResult] from JSON data.
  factory SearchComplexResult.fromJson(Map<String, dynamic> json) =>
      _$SearchComplexResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchComplexResultToJson(this);
}

/// 默认搜索词结果
@JsonSerializable()
class SearchDefaultResult {
  /// 默认搜索词数据
  final dynamic data;

  /// Creates a new [SearchDefaultResult] instance.
  SearchDefaultResult({this.data});

  /// Creates a [SearchDefaultResult] from JSON data.
  factory SearchDefaultResult.fromJson(Map<String, dynamic> json) =>
      _$SearchDefaultResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchDefaultResultToJson(this);
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
