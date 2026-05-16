// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
  hash: json['hash'] as String?,
  albumId: _parseInt(json['album_id']),
  albumAudioId: _parseInt(json['album_audio_id']),
  name: json['name'] as String?,
  singer: json['singer'] as String?,
  duration: _parseInt(json['duration']),
  songName: json['song_name'] as String?,
  ownerName: json['owner_name'] as String?,
  img: json['img'] as String?,
  hash320: json['320hash'] as String?,
  sqHash: json['sqhash'] as String?,
);

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
  'hash': instance.hash,
  'album_id': instance.albumId,
  'album_audio_id': instance.albumAudioId,
  'name': instance.name,
  'singer': instance.singer,
  'duration': instance.duration,
  'song_name': instance.songName,
  'owner_name': instance.ownerName,
  'img': instance.img,
  '320hash': instance.hash320,
  'sqhash': instance.sqHash,
};

SongDetail _$SongDetailFromJson(Map<String, dynamic> json) => SongDetail(
  hash: json['hash'] as String?,
  albumId: _parseInt(json['album_id']),
  audioName: json['audio_name'] as String?,
  name: json['name'] as String?,
  singer: json['singer'] as String?,
  duration: _parseInt(json['duration']),
  img: json['img'] as String?,
  lyrics: json['lyrics'] as String?,
  authorName: json['author_name'] as String?,
  albumName: json['album_name'] as String?,
  audioId: _parseInt(json['audio_id']),
  bitrate: _parseInt(json['bitrate']),
  filesize128: _parseInt(json['filesize_128']),
  filesize320: _parseInt(json['filesize_320']),
  filesizeFlac: _parseInt(json['filesize_flac']),
  hash320: json['hash_320'] as String?,
  hashFlac: json['hash_flac'] as String?,
  hash128: json['hash_128'] as String?,
  extname: json['extname'] as String?,
);

Map<String, dynamic> _$SongDetailToJson(SongDetail instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'album_id': instance.albumId,
      'audio_name': instance.audioName,
      'name': instance.name,
      'singer': instance.singer,
      'duration': instance.duration,
      'img': instance.img,
      'lyrics': instance.lyrics,
      'author_name': instance.authorName,
      'album_name': instance.albumName,
      'audio_id': instance.audioId,
      'bitrate': instance.bitrate,
      'filesize_128': instance.filesize128,
      'filesize_320': instance.filesize320,
      'filesize_flac': instance.filesizeFlac,
      'hash_320': instance.hash320,
      'hash_flac': instance.hashFlac,
      'hash_128': instance.hash128,
      'extname': instance.extname,
    };

SongClimaxResult _$SongClimaxResultFromJson(Map<String, dynamic> json) =>
    SongClimaxResult(data: json['data']);

Map<String, dynamic> _$SongClimaxResultToJson(SongClimaxResult instance) =>
    <String, dynamic>{'data': instance.data};

SongRankingResult _$SongRankingResultFromJson(Map<String, dynamic> json) =>
    SongRankingResult(data: json['data']);

Map<String, dynamic> _$SongRankingResultToJson(SongRankingResult instance) =>
    <String, dynamic>{'data': instance.data};

SongRankingFilterResult _$SongRankingFilterResultFromJson(
  Map<String, dynamic> json,
) => SongRankingFilterResult(data: json['data']);

Map<String, dynamic> _$SongRankingFilterResultToJson(
  SongRankingFilterResult instance,
) => <String, dynamic>{'data': instance.data};

SongUrl _$SongUrlFromJson(Map<String, dynamic> json) => SongUrl(
  url: _urlFromJson(json['url']),
  backupUrls: _urlListFromJson(json['backupUrl']),
  hash: json['hash'] as String?,
  fileSize: _parseInt(json['fileSize']),
  extName: json['extName'] as String?,
  bitRate: _parseInt(json['bitRate']),
  type: (json['type'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt(),
  privStatus: (json['priv_status'] as num?)?.toInt(),
  timeLength: _parseInt(json['timeLength']),
  fileName: json['fileName'] as String?,
  hashOffset: json['hash_offset'] == null
      ? null
      : HashOffset.fromJson(json['hash_offset'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SongUrlToJson(SongUrl instance) => <String, dynamic>{
  'url': _urlToJson(instance.url),
  'backupUrl': instance.backupUrls,
  'hash': instance.hash,
  'fileSize': instance.fileSize,
  'extName': instance.extName,
  'bitRate': instance.bitRate,
  'type': instance.type,
  'status': instance.status,
  'priv_status': instance.privStatus,
  'timeLength': instance.timeLength,
  'fileName': instance.fileName,
  'hash_offset': instance.hashOffset,
};

HashOffset _$HashOffsetFromJson(Map<String, dynamic> json) => HashOffset(
  startByte: _parseInt(json['start_byte']),
  endByte: _parseInt(json['end_byte']),
  startMs: _parseInt(json['start_ms']),
  endMs: _parseInt(json['end_ms']),
  fileType: _parseInt(json['file_type']),
  offsetHash: json['offset_hash'] as String?,
);

Map<String, dynamic> _$HashOffsetToJson(HashOffset instance) =>
    <String, dynamic>{
      'start_byte': instance.startByte,
      'end_byte': instance.endByte,
      'start_ms': instance.startMs,
      'end_ms': instance.endMs,
      'file_type': instance.fileType,
      'offset_hash': instance.offsetHash,
    };

SongPrivUrlResult _$SongPrivUrlResultFromJson(Map<String, dynamic> json) =>
    SongPrivUrlResult(
      status: (json['status'] as num?)?.toInt(),
      errorCode: (json['errorCode'] as num?)?.toInt(),
      errorMsg: json['errorMsg'] as String?,
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => SongPrivUrlItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SongPrivUrlResultToJson(SongPrivUrlResult instance) =>
    <String, dynamic>{
      'status': instance.status,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'songs': instance.songs,
    };

SongPrivUrlItem _$SongPrivUrlItemFromJson(Map<String, dynamic> json) =>
    SongPrivUrlItem(
      hash: json['hash'] as String?,
      audioName: json['audioName'] as String?,
      singerName: json['singerName'] as String?,
      albumName: json['albumName'] as String?,
      timeLen: _parseInt(json['time_len']),
      qualities: (json['qualities'] as List<dynamic>?)
          ?.map((e) => AudioQualityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SongPrivUrlItemToJson(SongPrivUrlItem instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'audioName': instance.audioName,
      'singerName': instance.singerName,
      'albumName': instance.albumName,
      'time_len': instance.timeLen,
      'qualities': instance.qualities,
    };

AudioQualityItem _$AudioQualityItemFromJson(Map<String, dynamic> json) =>
    AudioQualityItem(
      quality: json['quality'] as String?,
      bitrate: _parseInt(json['bitrate']),
      fileSize: _parseInt(json['file_size']),
      extName: json['extName'] as String?,
      url: json['url'] as String?,
      backupUrl: (json['backup_url'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      privStatus: _parseInt(json['priv_status']),
    );

Map<String, dynamic> _$AudioQualityItemToJson(AudioQualityItem instance) =>
    <String, dynamic>{
      'quality': instance.quality,
      'bitrate': instance.bitrate,
      'file_size': instance.fileSize,
      'extName': instance.extName,
      'url': instance.url,
      'backup_url': instance.backupUrl,
      'priv_status': instance.privStatus,
    };
