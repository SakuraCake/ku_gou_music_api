import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kugou_api/kugou_api.dart';

void main() async {
  final api = KuGouApi(
    platform: Platform.standard,
    logLevel: LogLevel.info,
  );

  print('========================================');
  print('   酷狗音乐扫码登录测试');
  print('========================================\n');

  print('正在获取二维码...\n');

  final qrInfo = await _fetchQrCode(api);
  if (qrInfo == null) {
    print('获取二维码失败！');
    api.httpClient.close();
    exit(1);
  }

  final qrcode = qrInfo['qrcode'] as String?;
  final qrcodeImg = qrInfo['qrcode_img'] as String?;

  if (qrcodeImg != null && qrcodeImg.startsWith('data:image/png;base64,')) {
    final base64Data = qrcodeImg.substring('data:image/png;base64,'.length);
    final pngBytes = base64Decode(base64Data);
    final file = File('qrcode.png');
    await file.writeAsBytes(pngBytes);
    print('二维码图片已保存到: ${file.absolute.path}');
    print('请用酷狗音乐APP扫描此二维码图片\n');
  }

  print('二维码ID: $qrcode');
  print('等待扫码中...');

  while (true) {
    await Future.delayed(const Duration(seconds: 3));
    final state = await _checkQrCodeState(api, qrcode!);
    switch (state['state']) {
      case 'waiting':
        stdout.write('.');
        break;
      case 'scanned':
        print('\n已扫码！请在手机上确认登录...');
        break;
      case 'confirmed':
        print('\n\n登录成功！');
        final token = state['token'] as String?;
        final userId = state['userId'] as int?;
        print('Token: $token');
        print('UserID: $userId');

        if (token != null) {
          api.httpClient.token = token;
          api.httpClient.userid = userId;
        }

        final qrcodeFile = File('qrcode.png');
        if (await qrcodeFile.exists()) {
          await qrcodeFile.delete();
        }

        print('\n========================================');
        print('   登录后接口测试');
        print('========================================\n');

        await _testAuthenticatedApis(api);
        api.httpClient.close();
        exit(0);
      case 'expired':
        print('\n二维码已过期，请重新运行脚本');
        final qrcodeFile = File('qrcode.png');
        if (await qrcodeFile.exists()) {
          await qrcodeFile.delete();
        }
        api.httpClient.close();
        exit(1);
      default:
        print('\n发生错误: ${state['state']}');
        api.httpClient.close();
        exit(1);
    }
  }
}

Future<Map<String, dynamic>?> _fetchQrCode(KuGouApi api) async {
  try {
    final client = api.httpClient;
    final params = <String, dynamic>{
      'appid': 1001,
      'type': 1,
      'plat': 4,
      'qrcode_txt':
          'https://h5.kugou.com/apps/loginQRCode/html/index.html?appid=${client.config.appid}&',
      'srcappid': kSrcAppid,
      'dfid': client.dfid,
      'mid': client.mid,
      'uuid': '-',
      'appid_client': client.config.appid,
      'clientver': client.config.clientver,
      'clienttime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    final sig = signatureWebParams(params);
    params['signature'] = sig;
    final qs = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}').join('&');
    final r = await http.get(Uri.parse('https://login-user.kugou.com/v2/qrcode?$qs'));
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    if (body['data'] != null) {
      return body['data'] as Map<String, dynamic>;
    }
    return null;
  } catch (e) {
    print('获取二维码失败: $e');
    return null;
  }
}

Future<Map<String, dynamic>> _checkQrCodeState(KuGouApi api, String qrcode) async {
  try {
    final client = api.httpClient;
    final params = <String, dynamic>{
      'plat': 4,
      'appid': client.config.appid,
      'srcappid': kSrcAppid,
      'qrcode': qrcode,
      'dfid': client.dfid,
      'mid': client.mid,
      'uuid': '-',
      'clientver': client.config.clientver,
      'clienttime': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
    final sig = signatureWebParams(params);
    params['signature'] = sig;
    final qs = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}').join('&');
    final r = await http.get(Uri.parse('https://login-user.kugou.com/v2/get_userinfo_qrcode?$qs'));
    final body = jsonDecode(r.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>?;
    final status = data?['status'] as int?;
    switch (status) {
      case 0:
        return {'state': 'expired'};
      case 1:
        return {'state': 'waiting'};
      case 2:
        return {'state': 'scanned'};
      case 4:
        return {
          'state': 'confirmed',
          'token': data?['token'] as String?,
          'userId': (data?['userid'] as num?)?.toInt(),
        };
      default:
        return {'state': 'error: status=$status'};
    }
  } catch (e) {
    return {'state': 'error: $e'};
  }
}

Future<void> _testAuthenticatedApis(KuGouApi api) async {
  print('=== 1. 搜索歌曲 ===');
  try {
    final result = await api.search.songs(keyword: '周杰伦', pageSize: 3);
    print('搜索结果: ${result.total} 首');
    if (result.songs != null && result.songs!.isNotEmpty) {
      final song = result.songs!.first;
      print('第一首: ${song.songName ?? song.name} - ${song.ownerName ?? song.singer}');
      print('Hash: ${song.hash}');

      print('\n=== 2. 获取歌曲URL（登录状态）===');
      try {
        final url = await api.song.url(hash: song.hash!);
        print('URL: ${url.url != null ? "${url.url!.substring(0, 80)}..." : "null"}');
        print('fileSize: ${url.fileSize}');
        print('bitRate: ${url.bitRate}');
        print('extName: ${url.extName}');
      } catch (e) {
        print('歌曲URL失败: $e');
      }

      print('\n=== 3. 歌曲详情 ===');
      try {
        final details = await api.song.detail(hashes: [song.hash!]);
        if (details.isNotEmpty) {
          final d = details.first;
          print('名称: ${d.displayName}');
          print('歌手: ${d.displaySinger}');
          print('专辑: ${d.albumName}');
          print('比特率: ${d.bitrate}');
          print('128K: ${d.filesize128}');
          print('320K: ${d.filesize320}');
          print('FLAC: ${d.filesizeFlac}');
        }
      } catch (e) {
        print('歌曲详情失败: $e');
      }

      print('\n=== 4. 歌词 ===');
      try {
        final lyricSearch = await api.lyric.search(
          keyword: song.songName ?? song.name ?? '',
          hash: song.hash,
        );
        if (lyricSearch.candidates != null && lyricSearch.candidates!.isNotEmpty) {
          final first = lyricSearch.candidates!.first;
          final lyric = await api.lyric.get(
            id: first.id!,
            accesskey: first.accesskey!,
            format: LyricFormat.lrc,
          );
          final content = lyric.content ?? '';
          print('歌词(前100字): ${content.substring(0, content.length > 100 ? 100 : content.length)}');
        }
      } catch (e) {
        print('歌词失败: $e');
      }
    }
  } catch (e) {
    print('搜索失败: $e');
  }
}
