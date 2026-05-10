import 'dart:convert';
import 'dart:io';

import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(
    platform: Platform.standard,
    logLevel: LogLevel.info,
  );

  print('========================================');
  print('   酷狗音乐 - 交互式登录测试');
  print('========================================\n');

  while (true) {
    print('请选择登录方式:');
    print('  1. 二维码登录');
    print('  2. 输入 Token');
    print('  3. 退出');
    stdout.write('\n请输入选项 (1-3): ');

    final choice = stdin.readLineSync()?.trim() ?? '';

    switch (choice) {
      case '1':
        await _qrCodeLogin(api);
        break;
      case '2':
        await _tokenLogin(api);
        break;
      case '3':
        print('再见！');
        api.httpClient.close();
        return;
      default:
        print('无效选项，请重新输入\n');
    }

    if (api.httpClient.token != null) {
      print('\n当前登录状态:');
      print('  Token: ${api.httpClient.token}');
      print('  UserID: ${api.httpClient.userid}');
      print('');

      stdout.write('是否测试需要登录的接口? (y/n): ');
      final testChoice = stdin.readLineSync()?.trim().toLowerCase() ?? 'n';
      if (testChoice == 'y') {
        await _testAuthenticatedApis(api);
      }
      break;
    }
  }

  api.httpClient.close();
}

Future<void> _tokenLogin(KuGouApi api) async {
  print('\n--- 输入 Token ---');
  stdout.write('请输入 Token: ');
  final token = stdin.readLineSync()?.trim() ?? '';
  stdout.write('请输入 UserID: ');
  final userIdStr = stdin.readLineSync()?.trim() ?? '';
  final userId = int.tryParse(userIdStr);

  if (token.isEmpty || userId == null) {
    print('Token 和 UserID 不能为空，且 UserID 必须为数字\n');
    return;
  }

  api.httpClient.token = token;
  api.httpClient.userid = userId;
  print('\n✅ Token 已设置');
  print('  Token: ${api.httpClient.token}');
  print('  UserID: ${api.httpClient.userid}');
}

Future<void> _qrCodeLogin(KuGouApi api) async {
  print('\n--- 二维码登录 ---');
  print('正在生成二维码...\n');

  try {
    bool firstState = true;
    await for (final state in api.login.qrCodeStream(
      interval: const Duration(seconds: 2),
    )) {
      switch (state) {
        case QrCodeState.waiting:
          if (firstState) {
            firstState = false;
            final qrInfo = api.login.qrInfo;
            if (qrInfo != null) {
              if (qrInfo.qrUrl != null) {
                print('二维码链接: ${qrInfo.qrUrl}');
              }
              if (qrInfo.qrImg != null && qrInfo.qrImg!.startsWith('data:image/png;base64,')) {
                final base64Data = qrInfo.qrImg!.substring('data:image/png;base64,'.length);
                final pngBytes = base64Decode(base64Data);
                final file = File('qrcode.png');
                await file.writeAsBytes(pngBytes);
                print('二维码图片已保存到: ${file.absolute.path}');
              }
              print('请用酷狗音乐APP扫描二维码\n');
            }
            stdout.write('等待扫码');
          }
          stdout.write('.');
          break;
        case QrCodeState.scanned:
          print('\n已扫码，请在手机上确认...');
          break;
        case QrCodeState.confirmed:
          print('\n✅ 二维码登录成功！');
          print('  Token: ${api.login.token}');
          print('  UserID: ${api.login.userid}');
          _cleanupQrCode();
          return;
        case QrCodeState.expired:
          print('\n二维码已过期，请重试\n');
          _cleanupQrCode();
          return;
        case QrCodeState.error:
          print('\n二维码登录出错\n');
          _cleanupQrCode();
          return;
      }
    }
  } catch (e) {
    print('\n二维码登录异常: $e\n');
    _cleanupQrCode();
  }
}

void _cleanupQrCode() {
  final file = File('qrcode.png');
  if (file.existsSync()) {
    file.deleteSync();
  }
}

Future<void> _testAuthenticatedApis(KuGouApi api) async {
  int passed = 0;
  int failed = 0;

  Future<void> test(String name, Future<void> Function() fn) async {
    try {
      await fn();
      passed++;
      print('  ✅ $name');
    } catch (e) {
      failed++;
      print('  ❌ $name: $e');
    }
  }

  print('\n========================================');
  print('   登录后接口测试');
  print('========================================\n');

  await test('用户详情', () async {
    final result = await api.user.detail();
    print('      用户名: ${result.userName}');
    print('      关注数: ${result.followCount}');
    print('      粉丝数: ${result.fansCount}');
  });

  await test('用户VIP信息', () async {
    final result = await api.user.vipDetail();
    print('      VIP类型: ${result.vipType}');
    print('      VIP名称: ${result.vipName}');
  });

  await test('用户歌单', () async {
    final result = await api.user.playlists(pageSize: 3);
    final list = result.list;
    print('      歌单数量: ${list?.length ?? 0}');
    if (list != null && list.isNotEmpty) {
      print('      第一个: ${list.first.name}');
    }
  });

  await test('用户听歌历史', () async {
    final result = await api.user.history();
    final list = result.list;
    print('      历史数量: ${list?.length ?? 0}');
    if (list != null && list.isNotEmpty) {
      print('      最近听过: ${list.first.songName}');
    }
  });

  await test('每日推荐', () async {
    try {
      final result = await api.recommend.everyday();
      final songs = result.songs;
      print('      推荐歌曲数量: ${songs?.length ?? 0}');
    } catch (e) {
      print('      (可能需要特定平台) $e');
      rethrow;
    }
  });

  await test('AI推荐', () async {
    try {
      final result = await api.recommend.ai();
      final songs = result.songs;
      print('      AI推荐数量: ${songs?.length ?? 0}');
    } catch (e) {
      print('      (可能需要特定参数) $e');
      rethrow;
    }
  });

  await test('关注歌手列表', () async {
    final result = await api.user.follow(pagesize: 5);
    final list = result.list;
    print('      关注数量: ${list?.length ?? 0}');
  });

  await test('搜索歌曲', () async {
    final result = await api.search.songs(keyword: '周杰伦', pageSize: 3);
    print('      搜索结果: ${result.total} 首');
    if (result.songs != null && result.songs!.isNotEmpty) {
      final song = result.songs!.first;
      print('      第一首: ${song.songName ?? song.name}');
    }
  });

  await test('获取歌曲URL', () async {
    final searchResult = await api.search.songs(keyword: '周杰伦', pageSize: 1);
    final song = searchResult.songs?.first;
    if (song?.hash == null) throw Exception('无法获取歌曲hash');
    final url = await api.song.url(hash: song!.hash!);
    print('      Hash: ${url.hash}');
    print('      bitRate: ${url.bitRate}');
    print('      extName: ${url.extName}');
  });

  print('\n========================================');
  print('  测试结果: ✅ $passed 通过, ❌ $failed 失败');
  print('========================================');
}
