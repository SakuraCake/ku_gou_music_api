import 'package:kugou_api/kugou_api.dart';

String _dataSummary(dynamic data) {
  if (data == null) return 'null';
  if (data is Map) return 'Map(${data.keys.toList()})';
  if (data is List) return 'List(${data.length})';
  return data.runtimeType.toString();
}

void main() async {
  final api = KuGouApi(logLevel: LogLevel.info);

  int passed = 0;
  int failed = 0;

  Future<void> test(String name, Future<void> Function() fn) async {
    try {
      await fn();
      passed++;
      print('✅ $name');
    } catch (e) {
      failed++;
      print('❌ $name: $e');
    }
  }

  print('========================================');
  print('  新增 API 集成测试 (IP/Top/Images/Yueku/Longaudio)');
  print('========================================\n');

  await test('IpApi.zone - IP专区列表', () async {
    final result = await api.ip.zone();
    final list = result.list;
    if (list == null || list.isEmpty) throw Exception('list 为空');
    print('   IP专区数量: ${list.length}');
    print('   第一个: ${list.first.name} (ipId=${list.first.ipId})');
  });

  await test('IpApi.detail - IP详情', () async {
    final zoneResult = await api.ip.zone();
    final ipId = zoneResult.list?.first.ipId;
    if (ipId == null || ipId == 0) throw Exception('无法获取 ipId');
    final result = await api.ip.detail(id: ipId.toString());
    final data = result.data;
    if (data == null || data.isEmpty) throw Exception('data 为空');
    print('   IP详情数量: ${data.length}');
    print('   第一个: ${data.first.name}');
  });

  await test('IpApi.content - IP内容(audios)', () async {
    final zoneResult = await api.ip.zone();
    final ipId = zoneResult.list?.first.ipId;
    if (ipId == null || ipId == 0) throw Exception('无法获取 ipId');
    final result = await api.ip.content(id: ipId.toString(), type: 'audios');
    final info = result.info;
    print('   IP音频数量: ${info?.length ?? 0}');
  });

  await test('IpApi.playlist - IP歌单', () async {
    final zoneResult = await api.ip.zone();
    final ipId = zoneResult.list?.first.ipId;
    if (ipId == null || ipId == 0) throw Exception('无法获取 ipId');
    final result = await api.ip.playlist(id: ipId.toString());
    final info = result.info;
    print('   IP歌单数量: ${info?.length ?? 0}');
  });

  await test('IpApi.zoneHome - IP专区首页', () async {
    final zoneResult = await api.ip.zone();
    final ipId = zoneResult.list?.first.ipId;
    if (ipId == null || ipId == 0) throw Exception('无法获取 ipId');
    final result = await api.ip.zoneHome(id: ipId.toString());
    print('   IP专区首页: modules=${result.modules?.length ?? 0}');
  });

  await test('TopApi.card - 热门好歌卡片', () async {
    final result = await api.top.card(cardId: 1);
    print('   卡片cardId: ${result.cardId}');
  });

  await test('TopApi.cardYouth - 少儿卡片', () async {
    final result = await api.top.cardYouth(cardId: 3005);
    print('   少儿卡片cardId: ${result.cardId}');
  });

  await test('TopApi.ip - IP每日推荐', () async {
    final result = await api.top.ip();
    final list = result.list;
    print('   IP推荐数量: ${list?.length ?? 0}');
  });

  await test('ImagesApi.albumImages - 专辑图片', () async {
    final result = await api.images.albumImages(hash: '1335f720c701863f127fb14ccc9c08a2');
    final data = result.data;
    print('   图片数据数量: ${data?.length ?? 0}');
  });

  await test('ImagesApi.audioImages - 音频作者图片', () async {
    final result = await api.images.audioImages(hash: '1335f720c701863f127fb14ccc9c08a2');
    final data = result.data;
    print('   音频图片数量: ${data?.length ?? 0}');
  });

  await test('YuekuApi.recommend - 乐库推荐', () async {
    final result = await api.yueku.recommend();
    print('   乐库推荐数据: ${_dataSummary(result.data)}');
  });

  await test('YuekuApi.banner - 乐库Banner', () async {
    try {
      final result = await api.yueku.banner();
      final list = result.list;
      print('   Banner数量: ${list?.length ?? 0}');
    } catch (e) {
      print('   (可能需要特定参数) $e');
      rethrow;
    }
  });

  await test('YuekuApi.fm - 乐库FM', () async {
    final result = await api.yueku.fm();
    print('   乐库FM数据: ${_dataSummary(result.data)}');
  });

  await test('LongaudioApi.rankRecommend - 有声书排行推荐', () async {
    final result = await api.longaudio.rankRecommend();
    print('   排行推荐数据: ${_dataSummary(result.data)}');
  });

  await test('LongaudioApi.dailyRecommend - 有声书每日推荐', () async {
    final result = await api.longaudio.dailyRecommend(pagesize: 5);
    print('   每日推荐数据: ${_dataSummary(result.data)}');
  });

  await test('LongaudioApi.albumDetail - 有声书专辑详情', () async {
    final result = await api.longaudio.albumDetail(albumId: '36988978');
    final data = result.data;
    print('   专辑详情数量: ${data?.length ?? 0}');
    if (data != null && data.isNotEmpty) {
      print('   第一个: ${data.first.albumName}');
    }
  });

  await test('LongaudioApi.albumAudios - 有声书专辑音频', () async {
    final result = await api.longaudio.albumAudios(albumId: '36988978', pagesize: 5);
    final info = result.info;
    print('   音频数量: ${info?.length ?? 0}');
  });

  await test('LongaudioApi.vipRecommend - VIP精选有声书', () async {
    final result = await api.longaudio.vipRecommend();
    print('   VIP推荐数据: ${_dataSummary(result.data)}');
  });

  await test('LongaudioApi.weekRecommend - 本周新上有声书', () async {
    final result = await api.longaudio.weekRecommend();
    print('   周推荐数据: ${_dataSummary(result.data)}');
  });

  api.httpClient.close();

  print('\n========================================');
  print('  测试结果: ✅ $passed 通过, ❌ $failed 失败');
  print('========================================');
}
