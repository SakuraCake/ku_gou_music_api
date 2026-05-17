import 'package:test/test.dart';
import 'package:kugou_api/kugou_api.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient()
      : super(
          httpClient: KuGouHttpClient(
            config: KuGouConfig(platform: Platform.standard),
          ),
        );

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    String? router,
    EncryptType encryptType = EncryptType.android,
    bool encryptKey = false,
    bool notSignature = false,
    bool clearDefaultParams = false,
    String? baseURL,
    T Function(Map<String, dynamic>)? fromJson,
    bool useCache = false,
  }) async {
    return {'status': 1, 'data': {}} as T;
  }

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? params,
    dynamic body,
    Map<String, String>? headers,
    String? router,
    EncryptType encryptType = EncryptType.android,
    bool encryptKey = false,
    bool notSignature = false,
    bool clearDefaultParams = false,
    String? baseURL,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return {'status': 1, 'data': {}} as T;
  }
}

void main() {
  group('KuGouApi API properties', () {
    late KuGouApi api;

    setUp(() {
      api = KuGouApi();
    });

    tearDown(() {
      api.dispose();
    });

    test('has search property of type SearchApi', () {
      expect(api.search, isA<SearchApi>());
    });

    test('has song property of type SongApi', () {
      expect(api.song, isA<SongApi>());
    });

    test('has lyric property of type LyricApi', () {
      expect(api.lyric, isA<LyricApi>());
    });

    test('has login property of type LoginApi', () {
      expect(api.login, isA<LoginApi>());
    });

    test('has rank property of type RankApi', () {
      expect(api.rank, isA<RankApi>());
    });

    test('has playlist property of type PlaylistApi', () {
      expect(api.playlist, isA<PlaylistApi>());
    });

    test('has album property of type AlbumApi', () {
      expect(api.album, isA<AlbumApi>());
    });

    test('has artist property of type ArtistApi', () {
      expect(api.artist, isA<ArtistApi>());
    });

    test('has recommend property of type RecommendApi', () {
      expect(api.recommend, isA<RecommendApi>());
    });

    test('has comment property of type CommentApi', () {
      expect(api.comment, isA<CommentApi>());
    });

    test('has user property of type UserApi', () {
      expect(api.user, isA<UserApi>());
    });

    test('has fm property of type FmApi', () {
      expect(api.fm, isA<FmApi>());
    });

    test('has ip property of type IpApi', () {
      expect(api.ip, isA<IpApi>());
    });

    test('has top property of type TopApi', () {
      expect(api.top, isA<TopApi>());
    });

    test('has images property of type ImagesApi', () {
      expect(api.images, isA<ImagesApi>());
    });

    test('has yueku property of type YuekuApi', () {
      expect(api.yueku, isA<YuekuApi>());
    });

    test('has longaudio property of type LongaudioApi', () {
      expect(api.longaudio, isA<LongaudioApi>());
    });

    test('has video property of type VideoApi', () {
      expect(api.video, isA<VideoApi>());
    });

    test('has scene property of type SceneApi', () {
      expect(api.scene, isA<SceneApi>());
    });

    test('has sheet property of type SheetApi', () {
      expect(api.sheet, isA<SheetApi>());
    });

    test('has theme property of type ThemeApi', () {
      expect(api.theme, isA<ThemeApi>());
    });

    test('has misc property of type MiscApi', () {
      expect(api.misc, isA<MiscApi>());
    });

    test('has youth property of type YouthApi', () {
      expect(api.youth, isA<YouthApi>());
    });
  });

  group('YouthApi methods', () {
    late YouthApi youthApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      youthApi = YouthApi(fakeClient);
    });

    test('channelAll is callable', () async {
      final result = await youthApi.channelAll();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelAll accepts expected parameters', () async {
      final result = await youthApi.channelAll(page: 2, pagesize: 10, type: 2);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelAmway is callable', () async {
      final result = await youthApi.channelAmway(globalCollectionId: 'test_id');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelDetail is callable', () async {
      final result = await youthApi.channelDetail(globalCollectionId: 'id1,id2');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelSimilar is callable', () async {
      final result = await youthApi.channelSimilar(channelId: 'ch1');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelSubscribe is callable', () async {
      final result = await youthApi.channelSubscribe(
        globalCollectionId: 'id1',
        subscribe: true,
      );
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelSong is callable', () async {
      final result = await youthApi.channelSong(globalCollectionId: 'id1');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('channelSongDetail is callable', () async {
      final result = await youthApi.channelSongDetail(
        globalCollectionId: 'id1',
        fileId: 'f1',
      );
      expect(result, isA<Map<String, dynamic>>());
    });

    test('dayVip is callable', () async {
      final result = await youthApi.dayVip(receiveDay: 1);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('dayVipUpgrade is callable', () async {
      final result = await youthApi.dayVipUpgrade();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('dynamic dollar method is callable', () async {
      final result = await youthApi.dynamic$();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('dynamicRecent is callable', () async {
      final result = await youthApi.dynamicRecent();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('listenSong is callable', () async {
      final result = await youthApi.listenSong();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('monthVipRecord is callable', () async {
      final result = await youthApi.monthVipRecord();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('unionVip is callable', () async {
      final result = await youthApi.unionVip();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('vip is callable', () async {
      final result = await youthApi.vip();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('userSong is callable', () async {
      final result = await youthApi.userSong(userid: 123);
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('PlaylistApi new methods', () {
    late PlaylistApi playlistApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      playlistApi = PlaylistApi(fakeClient);
    });

    test('trackAllNew is callable', () async {
      final result = await playlistApi.trackAllNew(listId: 'list1');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('effect is callable', () async {
      final result = await playlistApi.effect();
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('RankApi new methods', () {
    late RankApi rankApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      rankApi = RankApi(fakeClient);
    });

    test('audio is callable', () async {
      final result = await rankApi.audio(rankId: 1);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('top is callable', () async {
      final result = await rankApi.top();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('vol is callable', () async {
      final result = await rankApi.vol(rankId: 1);
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('AlbumApi new methods', () {
    late AlbumApi albumApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      albumApi = AlbumApi(fakeClient);
    });

    test('oldDetail is callable', () async {
      final result = await albumApi.oldDetail(albumId: '1');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('songs is callable', () async {
      final result = await albumApi.songs(id: 1);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('shop is callable', () async {
      final result = await albumApi.shop();
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('ArtistApi new methods', () {
    late ArtistApi artistApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      artistApi = ArtistApi(fakeClient);
    });

    test('videos is callable', () async {
      final result = await artistApi.videos(id: 1);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('followNewSongs is callable', () async {
      final result = await artistApi.followNewSongs();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('honour is callable', () async {
      final result = await artistApi.honour(id: 1);
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('RecommendApi new methods', () {
    late RecommendApi recommendApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      recommendApi = RecommendApi(fakeClient);
    });

    test('everydayFriend is callable', () async {
      final result = await recommendApi.everydayFriend();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('everydayHistory is callable', () async {
      final result = await recommendApi.everydayHistory();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('everydayStyleRecommend is callable', () async {
      final result = await recommendApi.everydayStyleRecommend();
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('FmApi new methods', () {
    late FmApi fmApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      fmApi = FmApi(fakeClient);
    });

    test('recommend is callable', () async {
      final result = await fmApi.recommend();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('image is callable', () async {
      final result = await fmApi.image(fmId: '1');
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('VideoApi new methods', () {
    late VideoApi videoApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      videoApi = VideoApi(fakeClient);
    });

    test('audioMv is callable', () async {
      final result = await videoApi.audioMv(albumAudioId: '1');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('audioDetail is callable', () async {
      final result = await videoApi.audioDetail(albumAudioId: '1');
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('SceneApi new methods', () {
    late SceneApi sceneApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      sceneApi = SceneApi(fakeClient);
    });

    test('listsV2 is callable', () async {
      final result = await sceneApi.listsV2(id: 1);
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('SearchApi new methods', () {
    late SearchApi searchApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      searchApi = SearchApi(fakeClient);
    });

    test('mixedSearch is callable', () async {
      final result = await searchApi.mixedSearch(keyword: 'test');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('suggestV2 is callable', () async {
      final result = await searchApi.suggestV2(keyword: 'test');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('hotTab is callable', () async {
      final result = await searchApi.hotTab();
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('SongApi new methods', () {
    late SongApi songApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      songApi = SongApi(fakeClient);
    });

    test('climax is callable', () async {
      final result = await songApi.climax(hash: 'abc123');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('rankingFilter is callable', () async {
      final result = await songApi.rankingFilter(albumAudioId: 1);
      expect(result, isA<Map<String, dynamic>>());
    });
  });

  group('LoginApi new methods', () {
    late LoginApi loginApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      loginApi = LoginApi(fakeClient);
    });

    test('deviceLogin is callable', () async {
      final result = await loginApi.deviceLogin();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('deviceKick is callable', () async {
      final result = await loginApi.deviceKick(tMid: 'mid1', guid: 'guid1');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('openplatLogin is callable', () {
      expect(loginApi.openplatLogin, isA<Function>());
    });

    test('wxCreate is callable', () {
      expect(loginApi.wxCreate, isA<Function>());
    });

    test('wxCheck is callable', () {
      expect(loginApi.wxCheck, isA<Function>());
    });
  });

  group('UserApi new methods', () {
    late UserApi userApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      userApi = UserApi(fakeClient);
    });

    test('listen is callable', () async {
      final result = await userApi.listen();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('followMessage is callable', () async {
      final result = await userApi.followMessage(id: 1);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('videoCollect is callable', () async {
      final result = await userApi.videoCollect();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('videoLove is callable', () async {
      final result = await userApi.videoLove();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('cloudUrl is callable', () async {
      final result = await userApi.cloudUrl(hash: 'abc123');
      expect(result, isA<Map<String, dynamic>>());
    });

    test('cloud is callable', () {
      expect(userApi.cloud, isA<Function>());
    });
  });

  group('MiscApi new methods', () {
    late MiscApi miscApi;

    setUp(() {
      final fakeClient = _FakeApiClient();
      miscApi = MiscApi(fakeClient);
    });

    test('pcDiantai is callable', () async {
      final result = await miscApi.pcDiantai();
      expect(result, isA<Map<String, dynamic>>());
    });

    test('registerDev is callable', () {
      expect(miscApi.registerDev, isA<Function>());
    });
  });
}
