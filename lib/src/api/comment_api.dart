import '../client/base_api.dart';
import '../client/http_client.dart';
import '../models/comment.dart';

/// 评论相关接口
class CommentApi extends BaseApi {
  /// 构造评论 API 实例
  CommentApi(super.client);

  /// 获取歌曲评论列表，[mixSongId] 为混合歌曲 ID，[page] 为页码，[pageSize] 为每页数量
  Future<CommentListResult> music({
    required int mixSongId,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.post<CommentListResult>(
      '/mcomment/v1/cmtlist',
      params: {
        'mixsongid': mixSongId,
        'need_show_image': 1,
        'p': page,
        'pagesize': pageSize,
        'show_classify': 1,
        'show_hotword_list': 1,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
      },
      encryptType: EncryptType.android,
      fromJson: (json) {
        final dataField = json['data'];
        if (dataField is Map<String, dynamic>) {
          return CommentListResult.fromJson(dataField);
        }
        return CommentListResult.fromJson(json);
      },
    );
  }

  /// 获取评论数量，[hash] 为歌曲哈希值，[specialId] 为歌单 ID
  Future<CommentCountResult> count({
    String? hash,
    int? specialId,
  }) async {
    final params = <String, dynamic>{
      'r': 'comments/getcommentsnum',
      'code': 'fc4be23b4e972707f36b8a828a93ba8a',
    };
    if (hash != null) params['hash'] = hash;
    if (specialId != null) params['childrenid'] = specialId;
    return client.get<CommentCountResult>(
      '/index.php',
      params: params,
      router: 'sum.comment.service.kugou.com',
      encryptType: EncryptType.web,
      fromJson: CommentCountResult.fromJson,
    );
  }

  /// 获取楼中楼评论（回复列表），[tid] 为评论 ID，[resourceType] 为资源类型（song/playlist/album），[page] 为页码
  Future<FloorCommentResult> floor({
    required int tid,
    int? mixSongId,
    String resourceType = 'song',
    int page = 1,
    int pageSize = 30,
  }) async {
    final isServiceEndpoint = resourceType == 'playlist' || resourceType == 'album';
    final code = resourceType == 'playlist'
        ? 'ca53b96fe5a1d9c22d71c8f522ef7c4f'
        : resourceType == 'album'
            ? '94f1792ced1df89aa68a7939eaf2efca'
            : 'fc4be23b4e972707f36b8a828a93ba8a';
    final params = <String, dynamic>{
      'childrenid': tid,
      'need_show_image': 1,
      'p': page,
      'pagesize': pageSize,
      'show_classify': 1,
      'show_hotword_list': 1,
      'code': code,
      'tid': tid,
    };
    if (mixSongId != null) params['mixsongid'] = mixSongId;
    final url = isServiceEndpoint
        ? '/m.comment.service/v1/hot_replylist'
        : '/mcomment/v1/hot_replylist';
    return client.post<FloorCommentResult>(
      url,
      params: params,
      encryptType: EncryptType.android,
      fromJson: FloorCommentResult.fromJson,
    );
  }

  /// 获取评论热词搜索结果，[mixSongId] 为混合歌曲 ID，[hotWord] 为热词，[page] 为页码
  Future<HotWordResult> hotWord({
    required int mixSongId,
    required String hotWord,
    int page = 1,
    int pageSize = 30,
  }) async {
    return client.post<HotWordResult>(
      '/mcomment/v1/get_hot_word',
      params: {
        'mixsongid': mixSongId,
        'need_show_image': 1,
        'p': page,
        'pagesize': pageSize,
        'hot_word': hotWord,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
      },
      encryptType: EncryptType.android,
      fromJson: HotWordResult.fromJson,
    );
  }

  /// 获取分类评论列表，[mixSongId] 为混合歌曲 ID，[typeId] 为分类 ID，[sort] 为排序方式
  Future<ClassifyCommentResult> classify({
    required int mixSongId,
    required int typeId,
    int page = 1,
    int pageSize = 30,
    int sort = 1,
  }) async {
    return client.post<ClassifyCommentResult>(
      '/mcomment/v1/cmt_classify_list',
      params: {
        'mixsongid': mixSongId,
        'need_show_image': 1,
        'page': page,
        'pagesize': pageSize,
        'type_id': typeId,
        'extdata': '0',
        'code': 'fc4be23b4e972707f36b8a828a93ba8a',
        'sort_method': sort == 2 ? 2 : 1,
      },
      encryptType: EncryptType.android,
      fromJson: ClassifyCommentResult.fromJson,
    );
  }

  /// 获取专辑评论列表，[albumId] 为专辑 ID，[page] 为页码，[pagesize] 为每页数量
  Future<CommentAlbumResult> album({
    required int albumId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<CommentAlbumResult>(
      '/m.comment.service/v1/cmtlist',
      params: {
        'childrenid': albumId,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'show_classify': 1,
        'show_hotword_list': 1,
        'code': '94f1792ced1df89aa68a7939eaf2efca',
      },
      encryptType: EncryptType.android,
      fromJson: (json) => CommentAlbumResult.fromJson(json),
    );
  }

  /// 获取歌单评论列表，[playlistId] 为歌单 ID，[page] 为页码，[pagesize] 为每页数量
  Future<CommentPlaylistResult> playlist({
    required int playlistId,
    int page = 1,
    int pagesize = 30,
  }) async {
    return client.post<CommentPlaylistResult>(
      '/m.comment.service/v1/cmtlist',
      params: {
        'childrenid': playlistId,
        'need_show_image': 1,
        'p': page,
        'pagesize': pagesize,
        'show_classify': 1,
        'show_hotword_list': 1,
        'code': 'ca53b96fe5a1d9c22d71c8f522ef7c4f',
        'content_type': 0,
        'tag': 5,
      },
      encryptType: EncryptType.android,
      fromJson: (json) => CommentPlaylistResult.fromJson(json),
    );
  }
}
