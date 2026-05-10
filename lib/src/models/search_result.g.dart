// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  keyword: json['keyword'] as String?,
  songs: (json['songs'] as List<dynamic>?)
      ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
      .toList(),
  albums: (json['albums'] as List<dynamic>?)
      ?.map((e) => SearchAlbum.fromJson(e as Map<String, dynamic>))
      .toList(),
  artists: (json['artists'] as List<dynamic>?)
      ?.map((e) => SearchArtist.fromJson(e as Map<String, dynamic>))
      .toList(),
  playlists: (json['playlists'] as List<dynamic>?)
      ?.map((e) => SearchPlaylist.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'songs': instance.songs,
      'albums': instance.albums,
      'artists': instance.artists,
      'playlists': instance.playlists,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

SearchAlbum _$SearchAlbumFromJson(Map<String, dynamic> json) => SearchAlbum(
  albumId: (json['albumId'] as num?)?.toInt(),
  albumName: json['albumName'] as String?,
  img: json['img'] as String?,
  singer: json['singer'] as String?,
  songCount: (json['songCount'] as num?)?.toInt(),
  publishDate: json['publishDate'] as String?,
);

Map<String, dynamic> _$SearchAlbumToJson(SearchAlbum instance) =>
    <String, dynamic>{
      'albumId': instance.albumId,
      'albumName': instance.albumName,
      'img': instance.img,
      'singer': instance.singer,
      'songCount': instance.songCount,
      'publishDate': instance.publishDate,
    };

SearchArtist _$SearchArtistFromJson(Map<String, dynamic> json) => SearchArtist(
  artistId: (json['artistId'] as num?)?.toInt(),
  artistName: json['artistName'] as String?,
  img: json['img'] as String?,
  songCount: (json['songCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchArtistToJson(SearchArtist instance) =>
    <String, dynamic>{
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'img': instance.img,
      'songCount': instance.songCount,
    };

SearchPlaylist _$SearchPlaylistFromJson(Map<String, dynamic> json) =>
    SearchPlaylist(
      specialId: (json['specialId'] as num?)?.toInt(),
      specialName: json['specialName'] as String?,
      img: json['img'] as String?,
      songCount: (json['songCount'] as num?)?.toInt(),
      author: json['author'] as String?,
    );

Map<String, dynamic> _$SearchPlaylistToJson(SearchPlaylist instance) =>
    <String, dynamic>{
      'specialId': instance.specialId,
      'specialName': instance.specialName,
      'img': instance.img,
      'songCount': instance.songCount,
      'author': instance.author,
    };

HotSearchItem _$HotSearchItemFromJson(Map<String, dynamic> json) =>
    HotSearchItem(
      searchWord: json['searchWord'] as String?,
      keyword: json['keyword'] as String?,
      score: (json['score'] as num?)?.toInt(),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$HotSearchItemToJson(HotSearchItem instance) =>
    <String, dynamic>{
      'searchWord': instance.searchWord,
      'keyword': instance.keyword,
      'score': instance.score,
      'content': instance.content,
    };

SearchSuggest _$SearchSuggestFromJson(
  Map<String, dynamic> json,
) => SearchSuggest(
  keyword: json['keyword'] as String?,
  songs: (json['songs'] as List<dynamic>?)?.map((e) => e as String).toList(),
  albums: (json['albums'] as List<dynamic>?)?.map((e) => e as String).toList(),
  artists: (json['artists'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SearchSuggestToJson(SearchSuggest instance) =>
    <String, dynamic>{
      'keyword': instance.keyword,
      'songs': instance.songs,
      'albums': instance.albums,
      'artists': instance.artists,
    };

SearchComplexResult _$SearchComplexResultFromJson(Map<String, dynamic> json) =>
    SearchComplexResult(lists: json['lists'], code: _parseInt(json['code']));

Map<String, dynamic> _$SearchComplexResultToJson(
  SearchComplexResult instance,
) => <String, dynamic>{'lists': instance.lists, 'code': instance.code};

SearchDefaultResult _$SearchDefaultResultFromJson(Map<String, dynamic> json) =>
    SearchDefaultResult(data: json['data']);

Map<String, dynamic> _$SearchDefaultResultToJson(
  SearchDefaultResult instance,
) => <String, dynamic>{'data': instance.data};
