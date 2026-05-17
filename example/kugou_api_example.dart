/// 酷狗音乐 API 交互式示例脚本
///
/// 本脚本演示 kugou_api 库的所有主要功能，包括：
/// - 登录（密码、验证码、二维码）
/// - 搜索（歌曲、歌手、专辑、歌单、综合）
/// - 歌曲（详情、URL、歌词）
/// - 歌单、专辑、歌手、评论、用户、推荐、排行榜
/// - 概念版接口（YouthApi）
library;

import 'dart:io';
import 'dart:async';
import 'package:kugou_api/kugou_api.dart';

const String tokenFile = 'token_cache.txt';

void main() async {
  final api = KuGouApi();

  print('\n╔════════════════════════════════════════════════════════════╗');
  print('║         酷狗音乐 API 交互式演示 (kugou_api)                 ║');
  print('╚════════════════════════════════════════════════════════════╝\n');

  try {
    while (true) {
      showMainMenu();
      stdout.write('\n请选择功能 (0-13): ');
      final choice = stdin.readLineSync()?.trim();

      switch (choice) {
        case '0':
          print('\n再见！感谢使用 kugou_api！');
          return;
        case '1':
          await loginMenu(api);
          break;
        case '2':
          await searchMenu(api);
          break;
        case '3':
          await songMenu(api);
          break;
        case '4':
          await playlistMenu(api);
          break;
        case '5':
          await albumMenu(api);
          break;
        case '6':
          await artistMenu(api);
          break;
        case '7':
          await commentMenu(api);
          break;
        case '8':
          await userMenu(api);
          break;
        case '9':
          await recommendMenu(api);
          break;
        case '10':
          await rankMenu(api);
          break;
        case '11':
          await miscMenu(api);
          break;
        case '12':
          await youthMenu(api);
          break;
        case '13':
          await fmMenu(api);
          break;
        default:
          print('\n无效选择，请重试。');
      }
    }
  } finally {
    api.dispose();
  }
}

void showMainMenu() {
  print('\n┌─────────────────────────────────────────────────────────────┐');
  print('│                        主菜单                                │');
  print('├─────────────────────────────────────────────────────────────┤');
  print('│  1. 登录功能        2. 搜索功能        3. 歌曲功能          │');
  print('│  4. 歌单功能        5. 专辑功能        6. 歌手功能          │');
  print('│  7. 评论功能        8. 用户功能        9. 推荐功能          │');
  print('│ 10. 排行榜功能     11. 杂项功能       12. 概念版功能        │');
  print('│ 13. FM 功能          0. 退出                               │');
  print('└─────────────────────────────────────────────────────────────┘');
}

Future<String?> loadToken() async {
  final file = File(tokenFile);
  if (await file.exists()) {
    return await file.readAsString();
  }
  return null;
}

Future<void> saveToken(String token) async {
  final file = File(tokenFile);
  await file.writeAsString(token);
}

Future<int?> loadUserId() async {
  final file = File('$tokenFile.userid');
  if (await file.exists()) {
    final content = await file.readAsString();
    return int.tryParse(content);
  }
  return null;
}

Future<void> saveUserId(int userId) async {
  final file = File('$tokenFile.userid');
  await file.writeAsString(userId.toString());
}

Future<void> loginMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            登录功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 密码登录                         │');
    print('│  2. 验证码登录                       │');
    print('│  3. 二维码登录                       │');
    print('│  4. 刷新 Token                       │');
    print('│  5. 查看登录状态                     │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-5): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await passwordLogin(api);
        break;
      case '2':
        await captchaLogin(api);
        break;
      case '3':
        await qrCodeLogin(api);
        break;
      case '4':
        await refreshToken(api);
        break;
      case '5':
        await checkLoginStatus(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> passwordLogin(KuGouApi api) async {
  stdout.write('\n请输入用户名/手机号: ');
  final username = stdin.readLineSync()?.trim();
  if (username == null || username.isEmpty) {
    print('用户名不能为空');
    return;
  }

  stdout.write('请输入密码: ');
  stdin.echoMode = false;
  final password = stdin.readLineSync()?.trim();
  stdin.echoMode = true;
  print('');

  if (password == null || password.isEmpty) {
    print('密码不能为空');
    return;
  }

  print('\n正在登录...');
  try {
    final result = await api.login.byPassword(
      username: username,
      password: password,
    );
    if (result.token != null && result.userId != null) {
      print('\n✅ 登录成功！');
      print('  用户ID: ${result.userId}');
      print('  Token: ${result.token!.substring(0, 20)}...');
      await saveToken(result.token!);
      await saveUserId(result.userId!);
    } else {
      print('\n❌ 登录失败: ${result.message ?? "未知错误"}');
    }
  } catch (e) {
    print('\n❌ 登录失败: $e');
  }
}

Future<void> captchaLogin(KuGouApi api) async {
  stdout.write('\n请输入手机号: ');
  final phone = stdin.readLineSync()?.trim();
  if (phone == null || phone.isEmpty) {
    print('手机号不能为空');
    return;
  }

  print('\n正在发送验证码...');
  try {
    final sendResult = await api.login.sendCaptcha(phone: phone);
    if (sendResult.success) {
      print('✅ 验证码已发送到 $phone');
      stdout.write('\n请输入验证码: ');
      final captcha = stdin.readLineSync()?.trim();
      if (captcha == null || captcha.isEmpty) {
        print('验证码不能为空');
        return;
      }

      print('\n正在登录...');
      final result = await api.login.byCaptcha(
        phone: phone,
        captcha: captcha,
      );
      if (result.token != null && result.userId != null) {
        print('\n✅ 登录成功！');
        print('  用户ID: ${result.userId}');
        print('  Token: ${result.token!.substring(0, 20)}...');
        await saveToken(result.token!);
        await saveUserId(result.userId!);
      } else {
        print('\n❌ 登录失败: ${result.message ?? "未知错误"}');
      }
    } else {
      print('\n❌ 发送验证码失败: ${sendResult.message ?? "未知错误"}');
    }
  } catch (e) {
    print('\n❌ 操作失败: $e');
  }
}

Future<void> qrCodeLogin(KuGouApi api) async {
  print('\n正在生成二维码...');
  try {
    await for (final state in api.login.qrCodeStream(qrimg: true)) {
      switch (state) {
        case QrCodeState.waiting:
          final qrInfo = api.login.qrInfo;
          if (qrInfo != null) {
            print('\n请使用酷狗音乐 APP 扫描二维码登录：');
            print('二维码链接: ${qrInfo.qrUrl}');
            if (qrInfo.qrImg != null) {
              print('二维码图片已生成 (base64)');
            }
          }
          print('等待扫码...');
        case QrCodeState.scanned:
          print('\n✅ 已扫描，请在手机上确认登录...');
        case QrCodeState.confirmed:
          print('\n✅ 登录成功！');
          final token = api.httpClient.token;
          final userId = api.httpClient.userid;
          if (token != null && userId != null) {
            print('  用户ID: $userId');
            print('  Token: ${token.substring(0, 20)}...');
            await saveToken(token);
            await saveUserId(userId);
          }
          return;
        case QrCodeState.expired:
          print('\n❌ 二维码已过期，请重新获取');
          return;
        case QrCodeState.error:
          print('\n❌ 二维码登录出错');
          return;
      }
      await Future.delayed(Duration(seconds: 2));
    }
  } catch (e) {
    print('\n❌ 二维码登录失败: $e');
  }
}

Future<void> refreshToken(KuGouApi api) async {
  final token = await loadToken();
  if (token == null) {
    print('\n❌ 未找到保存的 Token，请先登录');
    return;
  }

  print('\n正在刷新 Token...');
  try {
    api.httpClient.token = token;
    final userId = await loadUserId();
    if (userId != null) {
      api.httpClient.userid = userId;
    }
    final result = await api.login.refreshToken();
    if (result.token != null && result.userId != null) {
      print('\n✅ Token 刷新成功！');
      print('  用户ID: ${result.userId}');
      print('  Token: ${result.token!.substring(0, 20)}...');
      await saveToken(result.token!);
      await saveUserId(result.userId!);
    } else {
      print('\n❌ Token 刷新失败');
    }
  } catch (e) {
    print('\n❌ Token 刷新失败: $e');
  }
}

Future<void> checkLoginStatus(KuGouApi api) async {
  final token = await loadToken();
  final userId = await loadUserId();

  print('\n┌─────────────────────────────────────┐');
  print('│            登录状态                  │');
  print('├─────────────────────────────────────┤');
  if (token != null && userId != null) {
    print('│  状态: 已登录                        │');
    print('│  用户ID: $userId');
    print('│  Token: ${token.substring(0, 20)}...');
  } else {
    print('│  状态: 未登录                        │');
  }
  print('└─────────────────────────────────────┘');
}

Future<void> searchMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            搜索功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 搜索歌曲                         │');
    print('│  2. 搜索歌手                         │');
    print('│  3. 搜索专辑                         │');
    print('│  4. 搜索歌单                         │');
    print('│  5. 综合搜索                         │');
    print('│  6. 热搜榜                           │');
    print('│  7. 搜索建议                         │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-7): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await searchSongs(api);
        break;
      case '2':
        await searchArtists(api);
        break;
      case '3':
        await searchAlbums(api);
        break;
      case '4':
        await searchPlaylists(api);
        break;
      case '5':
        await complexSearch(api);
        break;
      case '6':
        await hotSearch(api);
        break;
      case '7':
        await searchSuggest(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> searchSongs(KuGouApi api) async {
  stdout.write('\n请输入搜索关键词: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('关键词不能为空');
    return;
  }

  stdout.write('页码 [默认 1]: ');
  final pageStr = stdin.readLineSync()?.trim();
  final page = int.tryParse(pageStr ?? '1') ?? 1;

  stdout.write('每页数量 [默认 20]: ');
  final pageSizeStr = stdin.readLineSync()?.trim();
  final pageSize = int.tryParse(pageSizeStr ?? '20') ?? 20;

  print('\n正在搜索 "$keyword"...');
  try {
    final result = await api.search.songs(
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
    final songs = result.songs;
    if (songs == null || songs.isEmpty) {
      print('\n未找到相关歌曲');
      return;
    }

    print('\n找到 ${result.total ?? songs.length} 首歌曲:\n');
    for (var i = 0; i < songs.length; i++) {
      final song = songs[i];
      print('  ${(page - 1) * pageSize + i + 1}. ${song.songName ?? song.name}');
      print('      歌手: ${song.singer}');
      print('      Hash: ${song.hash}');
      print('');
    }
  } catch (e) {
    print('\n❌ 搜索失败: $e');
  }
}

Future<void> searchArtists(KuGouApi api) async {
  stdout.write('\n请输入搜索关键词: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('关键词不能为空');
    return;
  }

  print('\n正在搜索歌手 "$keyword"...');
  try {
    final result = await api.search.mixed(keyword: keyword);
    final artists = result.artists;
    if (artists == null || artists.isEmpty) {
      print('\n未找到相关歌手');
      return;
    }

    print('\n找到 ${artists.length} 位歌手:\n');
    for (var i = 0; i < artists.length && i < 10; i++) {
      final artist = artists[i];
      print('  ${i + 1}. ${artist.artistName}');
      print('      ID: ${artist.artistId}');
      print('');
    }
  } catch (e) {
    print('\n❌ 搜索失败: $e');
  }
}

Future<void> searchAlbums(KuGouApi api) async {
  stdout.write('\n请输入搜索关键词: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('关键词不能为空');
    return;
  }

  print('\n正在搜索专辑 "$keyword"...');
  try {
    final result = await api.search.albums(keyword: keyword);
    final albums = result.albums;
    if (albums == null || albums.isEmpty) {
      print('\n未找到相关专辑');
      return;
    }

    print('\n找到 ${result.total ?? albums.length} 张专辑:\n');
    for (var i = 0; i < albums.length && i < 10; i++) {
      final album = albums[i];
      print('  ${i + 1}. ${album.albumName}');
      print('      歌手: ${album.singer}');
      print('      ID: ${album.albumId}');
      print('');
    }
  } catch (e) {
    print('\n❌ 搜索失败: $e');
  }
}

Future<void> searchPlaylists(KuGouApi api) async {
  stdout.write('\n请输入搜索关键词: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('关键词不能为空');
    return;
  }

  print('\n正在搜索歌单 "$keyword"...');
  try {
    final result = await api.search.playlists(keyword: keyword);
    final playlists = result.playlists;
    if (playlists == null || playlists.isEmpty) {
      print('\n未找到相关歌单');
      return;
    }

    print('\n找到 ${result.total ?? playlists.length} 个歌单:\n');
    for (var i = 0; i < playlists.length && i < 10; i++) {
      final playlist = playlists[i];
      print('  ${i + 1}. ${playlist.specialName}');
      print('      歌曲数: ${playlist.songCount ?? 0}');
      print('      ID: ${playlist.specialId}');
      print('');
    }
  } catch (e) {
    print('\n❌ 搜索失败: $e');
  }
}

Future<void> complexSearch(KuGouApi api) async {
  stdout.write('\n请输入搜索关键词: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('关键词不能为空');
    return;
  }

  print('\n正在进行综合搜索 "$keyword"...');
  try {
    final result = await api.search.complex(keyword: keyword);

    print('\n=== 综合搜索结果 ===\n');
    print('  返回数据: ${result.lists}');
    print('  状态码: ${result.code}');
  } catch (e) {
    print('\n❌ 搜索失败: $e');
  }
}

Future<void> hotSearch(KuGouApi api) async {
  print('\n正在获取热搜榜...');
  try {
    final result = await api.search.hotDetail();

    print('\n=== 热搜榜 ===\n');
    for (var i = 0; i < result.length && i < 20; i++) {
      final item = result[i];
      print('  ${i + 1}. ${item.displayText}');
      print('      热度: ${item.score ?? 0}');
      print('');
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> searchSuggest(KuGouApi api) async {
  stdout.write('\n请输入关键词: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('关键词不能为空');
    return;
  }

  print('\n正在获取搜索建议...');
  try {
    final result = await api.search.suggest(keyword: keyword);

    print('\n=== 搜索建议 ===\n');
    final songs = result.songs;
    if (songs != null && songs.isNotEmpty) {
      print('【歌曲】');
      for (final song in songs.take(5)) {
        print('  • $song');
      }
      print('');
    }

    final artists = result.artists;
    if (artists != null && artists.isNotEmpty) {
      print('【歌手】');
      for (final artist in artists.take(5)) {
        print('  • $artist');
      }
      print('');
    }

    final albums = result.albums;
    if (albums != null && albums.isNotEmpty) {
      print('【专辑】');
      for (final album in albums.take(5)) {
        print('  • $album');
      }
      print('');
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> songMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            歌曲功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取歌曲详情                     │');
    print('│  2. 获取歌曲 URL                     │');
    print('│  3. 获取歌词                         │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-3): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await songDetail(api);
        break;
      case '2':
        await songUrl(api);
        break;
      case '3':
        await songLyric(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> songDetail(KuGouApi api) async {
  stdout.write('\n请输入歌曲 Hash: ');
  final hash = stdin.readLineSync()?.trim();
  if (hash == null || hash.isEmpty) {
    print('Hash 不能为空');
    return;
  }

  print('\n正在获取歌曲详情...');
  try {
    final result = await api.song.detail(hashes: [hash]);
    if (result.isEmpty) {
      print('\n未找到歌曲');
      return;
    }

    final song = result.first;
    print('\n=== 歌曲详情 ===\n');
    print('  歌曲名: ${song.displayName}');
    print('  歌手: ${song.displaySinger}');
    print('  专辑: ${song.albumName ?? "未知"}');
    print('  时长: ${song.duration != null ? "${song.duration! ~/ 60}:${(song.duration! % 60).toString().padLeft(2, '0')}" : "未知"}');
    print('  文件大小:');
    print('    128K: ${song.filesize128 ?? 0} bytes');
    print('    320K: ${song.filesize320 ?? 0} bytes');
    print('    FLAC: ${song.filesizeFlac ?? 0} bytes');
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> songUrl(KuGouApi api) async {
  stdout.write('\n请输入歌曲 Hash: ');
  final hash = stdin.readLineSync()?.trim();
  if (hash == null || hash.isEmpty) {
    print('Hash 不能为空');
    return;
  }

  stdout.write('音质 (128/320/flac) [默认 320]: ');
  final qualityInput = stdin.readLineSync()?.trim() ?? '320';

  final quality = switch (qualityInput) {
    '128' => AudioQuality.standard,
    '320' => AudioQuality.high,
    'flac' => AudioQuality.lossless,
    _ => AudioQuality.high,
  };

  print('\n正在获取歌曲 URL...');
  try {
    final result = await api.song.url(hash: hash, quality: quality);
    if (result.url != null) {
      print('\n=== 歌曲信息 ===\n');
      print('  URL: ${result.url}');
      print('  文件大小: ${result.fileSize ?? 0} bytes');
      print('  比特率: ${result.bitRate ?? 0} kbps');
      print('  格式: ${result.extName ?? "未知"}');
      print('');
    } else {
      print('\n❌ 无法获取歌曲 URL，可能需要 VIP 权限');
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> songLyric(KuGouApi api) async {
  stdout.write('\n请输入歌曲名称: ');
  final keyword = stdin.readLineSync()?.trim();
  if (keyword == null || keyword.isEmpty) {
    print('歌曲名称不能为空');
    return;
  }

  print('\n正在搜索歌词...');
  try {
    final searchResult = await api.lyric.search(keyword: keyword);
    final candidates = searchResult.candidates;
    if (candidates == null || candidates.isEmpty) {
      print('\n未找到歌词');
      return;
    }

    final first = candidates.first;
    if (first.id == null || first.accesskey == null) {
      print('\n未找到歌词');
      return;
    }

    print('\n正在获取歌词内容...');
    final result = await api.lyric.get(id: first.id!, accesskey: first.accesskey!);
    if (result.content != null) {
      print('\n=== 歌词 ===\n');
      print(result.content!);
      print('');
    } else {
      print('\n未找到歌词内容');
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> playlistMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            歌单功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取歌单详情                     │');
    print('│  2. 获取歌单歌曲                     │');
    print('│  3. 获取歌单分类                     │');
    print('│  4. 获取热门歌单                     │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-4): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await playlistDetail(api);
        break;
      case '2':
        await playlistTracks(api);
        break;
      case '3':
        await playlistTags(api);
        break;
      case '4':
        await playlistTop(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> playlistDetail(KuGouApi api) async {
  stdout.write('\n请输入歌单 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取歌单详情...');
  try {
    final result = await api.playlist.detail(ids: id);
    if (result.list == null || result.list!.isEmpty) {
      print('\n未找到歌单');
      return;
    }

    final playlist = result.list!.first;
    print('\n=== 歌单详情 ===\n');
    print('  名称: ${playlist.name}');
    print('  描述: ${playlist.intro ?? "无"}');
    print('  播放量: ${playlist.playCount ?? 0}');
    print('  歌曲数: ${playlist.songCount ?? 0}');
    print('  创建者: ${playlist.nickname ?? "未知"}');
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> playlistTracks(KuGouApi api) async {
  stdout.write('\n请输入歌单 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取歌单歌曲...');
  try {
    final result = await api.playlist.tracks(id: id);
    final songs = result.songs;

    print('\n=== 歌单歌曲 ===\n');
    if (songs == null || songs.isEmpty) {
      print('  歌单为空');
    } else {
      for (var i = 0; i < songs.length && i < 20; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
      }
      if (songs.length > 20) {
        print('  ... 还有 ${songs.length - 20} 首歌曲');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> playlistTags(KuGouApi api) async {
  print('\n正在获取歌单分类...');
  try {
    final result = await api.playlist.tags();

    print('\n=== 歌单分类 ===\n');
    for (final tag in result) {
      print('  • ${tag.tagName} (ID: ${tag.tagId})');
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> playlistTop(KuGouApi api) async {
  print('\n正在获取热门歌单...');
  try {
    final result = await api.playlist.top();

    print('\n=== 热门歌单 ===\n');
    final playlists = result.specialList;
    if (playlists == null || playlists.isEmpty) {
      print('  暂无热门歌单');
    } else {
      for (var i = 0; i < playlists.length && i < 15; i++) {
        final playlist = playlists[i];
        print('  ${i + 1}. ${playlist.name}');
        print('      播放量: ${playlist.playCount ?? 0}');
        print('');
      }
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> albumMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            专辑功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取专辑详情                     │');
    print('│  2. 获取专辑歌曲                     │');
    print('│  3. 新碟上架                         │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-3): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await albumDetail(api);
        break;
      case '2':
        await albumSongs(api);
        break;
      case '3':
        await albumTop(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> albumDetail(KuGouApi api) async {
  stdout.write('\n请输入专辑 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取专辑详情...');
  try {
    final result = await api.album.detail(albumId: id);
    if (result.list == null || result.list!.isEmpty) {
      print('\n未找到专辑');
      return;
    }

    final album = result.list!.first;
    print('\n=== 专辑详情 ===\n');
    print('  名称: ${album.albumName}');
    print('  歌手: ${album.singerName}');
    print('  歌曲数: ${album.songCount ?? 0}');
    print('  发布时间: ${album.publishTime ?? "未知"}');
    if (album.intro != null) {
      print('  简介: ${album.intro}');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> albumSongs(KuGouApi api) async {
  stdout.write('\n请输入专辑 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取专辑歌曲...');
  try {
    final result = await api.album.songs(id: int.parse(id));
    final data = result['data'];

    print('\n=== 专辑歌曲 ===\n');
    if (data is List) {
      if (data.isEmpty) {
        print('  专辑为空');
      } else {
        for (var i = 0; i < data.length; i++) {
          final item = data[i] as Map<String, dynamic>;
          print('  ${i + 1}. ${item['songname'] ?? item['name']}');
        }
      }
    } else {
      print('  暂无歌曲数据');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> albumTop(KuGouApi api) async {
  print('\n正在获取新碟上架...');
  try {
    final result = await api.album.top();

    print('\n=== 新碟上架 ===\n');

    void printAlbums(List<AlbumInfo>? albums, String region) {
      if (albums == null || albums.isEmpty) return;
      print('【$region】');
      for (var i = 0; i < albums.length && i < 5; i++) {
        final album = albums[i];
        print('  ${i + 1}. ${album.albumName} - ${album.singerName}');
      }
      print('');
    }

    printAlbums(result.chn, '华语');
    printAlbums(result.eur, '欧美');
    printAlbums(result.jpn, '日本');
    printAlbums(result.kor, '韩国');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> artistMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            歌手功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取歌手详情                     │');
    print('│  2. 获取歌手歌曲                     │');
    print('│  3. 获取歌手专辑                     │');
    print('│  4. 获取歌手列表                     │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-4): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await artistDetail(api);
        break;
      case '2':
        await artistSongs(api);
        break;
      case '3':
        await artistAlbums(api);
        break;
      case '4':
        await artistList(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> artistDetail(KuGouApi api) async {
  stdout.write('\n请输入歌手 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取歌手详情...');
  try {
    final result = await api.artist.detail(id: int.parse(id));

    print('\n=== 歌手详情 ===\n');
    print('  名称: ${result.authorName}');
    print('  歌曲数: ${result.songCount ?? 0}');
    print('  专辑数: ${result.albumCount ?? 0}');
    print('  粉丝数: ${result.fansnums ?? 0}');
    if (result.intro != null) {
      print('  简介: ${result.intro}');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> artistSongs(KuGouApi api) async {
  stdout.write('\n请输入歌手 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取歌手歌曲...');
  try {
    final result = await api.artist.audios(id: int.parse(id));
    final songs = result.songs;

    print('\n=== 歌手歌曲 ===\n');
    if (songs == null || songs.isEmpty) {
      print('  暂无歌曲');
    } else {
      for (var i = 0; i < songs.length && i < 20; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name}');
      }
      if (songs.length > 20) {
        print('  ... 还有 ${songs.length - 20} 首歌曲');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> artistAlbums(KuGouApi api) async {
  stdout.write('\n请输入歌手 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取歌手专辑...');
  try {
    final result = await api.artist.albums(id: int.parse(id));
    final albums = result.albums;

    print('\n=== 歌手专辑 ===\n');
    if (albums == null || albums.isEmpty) {
      print('  暂无专辑');
    } else {
      for (var i = 0; i < albums.length && i < 15; i++) {
        final album = albums[i];
        print('  ${i + 1}. ${album.albumName}');
        print('      发布时间: ${album.publishTime ?? "未知"}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> artistList(KuGouApi api) async {
  print('\n正在获取歌手列表...');
  try {
    final result = await api.artist.list();

    print('\n=== 歌手列表 ===\n');
    final info = result.info;
    if (info == null || info.isEmpty) {
      print('  暂无歌手');
    } else {
      for (final group in info) {
        print('【${group.title}】');
        final singers = group.singer;
        if (singers != null) {
          for (var i = 0; i < singers.length && i < 10; i++) {
            final artist = singers[i];
            print('  ${i + 1}. ${artist.singerName}');
            print('      ID: ${artist.singerId}');
          }
        }
        print('');
      }
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> commentMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            评论功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取歌曲评论                     │');
    print('│  2. 获取评论数                       │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-2): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await songComments(api);
        break;
      case '2':
        await commentCount(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> songComments(KuGouApi api) async {
  stdout.write('\n请输入歌曲 mixSongId: ');
  final mixSongIdStr = stdin.readLineSync()?.trim();
  if (mixSongIdStr == null || mixSongIdStr.isEmpty) {
    print('mixSongId 不能为空');
    return;
  }
  final mixSongId = int.tryParse(mixSongIdStr);
  if (mixSongId == null) {
    print('mixSongId 必须是数字');
    return;
  }

  print('\n正在获取评论...');
  try {
    final result = await api.comment.music(mixSongId: mixSongId);
    final comments = result.list;

    print('\n=== 歌曲评论 ===\n');
    if (comments == null || comments.isEmpty) {
      print('  暂无评论');
    } else {
      for (var i = 0; i < comments.length && i < 10; i++) {
        final comment = comments[i];
        print('  ${i + 1}. ${comment.userName ?? "匿名用户"}');
        print('     ${comment.content}');
        print('     回复数: ${comment.replyCount ?? 0}  ${comment.addTime ?? ""}');
        print('');
      }
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> commentCount(KuGouApi api) async {
  stdout.write('\n请输入歌曲 Hash: ');
  final hash = stdin.readLineSync()?.trim();
  if (hash == null || hash.isEmpty) {
    print('Hash 不能为空');
    return;
  }

  print('\n正在获取评论数...');
  try {
    final result = await api.comment.count(hash: hash);

    print('\n=== 评论数 ===\n');
    print('  评论数: ${result.count ?? 0}');
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> userMenu(KuGouApi api) async {
  final token = await loadToken();
  if (token == null) {
    print('\n❌ 请先登录');
    return;
  }
  api.httpClient.token = token;
  final userId = await loadUserId();
  if (userId != null) {
    api.httpClient.userid = userId;
  }

  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            用户功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取用户信息                     │');
    print('│  2. 获取用户歌单                     │');
    print('│  3. 获取听歌历史                     │');
    print('│  4. 获取 VIP 信息                    │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-4): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await userDetail(api);
        break;
      case '2':
        await userPlaylists(api);
        break;
      case '3':
        await userHistory(api);
        break;
      case '4':
        await userVip(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> userDetail(KuGouApi api) async {
  print('\n正在获取用户信息...');
  try {
    final result = await api.user.detail();

    print('\n=== 用户信息 ===\n');
    print('  用户ID: ${result.userId}');
    print('  用户名: ${result.userName ?? result.nickname ?? "未知"}');
    print('  性别: ${result.gender == 1 ? "男" : result.gender == 2 ? "女" : "未知"}');
    print('  VIP类型: ${result.vipType ?? 0}');
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> userPlaylists(KuGouApi api) async {
  print('\n正在获取用户歌单...');
  try {
    final result = await api.user.playlists();
    final playlists = result.list;

    print('\n=== 用户歌单 ===\n');
    if (playlists == null || playlists.isEmpty) {
      print('  暂无歌单');
    } else {
      for (var i = 0; i < playlists.length; i++) {
        final playlist = playlists[i];
        print('  ${i + 1}. ${playlist.name}');
        print('      歌曲数: ${playlist.songCount ?? 0}');
        print('      ID: ${playlist.globalCollectionId}');
        print('');
      }
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> userHistory(KuGouApi api) async {
  print('\n正在获取听歌历史...');
  try {
    final result = await api.user.history();
    final list = result.list;

    print('\n=== 听歌历史 ===\n');
    if (list == null || list.isEmpty) {
      print('  暂无记录');
    } else {
      for (var i = 0; i < list.length && i < 20; i++) {
        final item = list[i];
        print('  ${i + 1}. ${item.songName} - ${item.authorName}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> userVip(KuGouApi api) async {
  print('\n正在获取 VIP 信息...');
  try {
    final result = await api.user.vipDetail();

    print('\n=== VIP 信息 ===\n');
    print('  VIP类型: ${result.vipType ?? 0}');
    print('  VIP名称: ${result.vipName ?? "无"}');
    print('  到期时间: ${result.expireTime != null ? DateTime.fromMillisecondsSinceEpoch(result.expireTime! * 1000) : "未知"}');
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> recommendMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            推荐功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 每日推荐                         │');
    print('│  2. AI 推荐                          │');
    print('│  3. 新歌速递                         │');
    print('│  4. 推荐歌单                         │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-4): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await everydayRecommend(api);
        break;
      case '2':
        await aiRecommend(api);
        break;
      case '3':
        await newSongs(api);
        break;
      case '4':
        await recommendPlaylists(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> everydayRecommend(KuGouApi api) async {
  print('\n正在获取每日推荐...');
  try {
    final result = await api.recommend.everyday();
    final songs = result.songs;

    print('\n=== 每日推荐 ===\n');
    if (songs == null || songs.isEmpty) {
      print('  暂无推荐');
    } else {
      for (var i = 0; i < songs.length && i < 15; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> aiRecommend(KuGouApi api) async {
  print('\n正在获取 AI 推荐...');
  try {
    final result = await api.recommend.ai();
    final songs = result.songs;

    print('\n=== AI 推荐 ===\n');
    if (songs == null || songs.isEmpty) {
      print('  暂无推荐');
    } else {
      for (var i = 0; i < songs.length && i < 15; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> newSongs(KuGouApi api) async {
  print('\n正在获取新歌速递...');
  try {
    final result = await api.recommend.newSongs();

    print('\n=== 新歌速递 ===\n');
    final songs = result.songs;
    if (songs == null || songs.isEmpty) {
      print('  暂无新歌');
    } else {
      for (var i = 0; i < songs.length && i < 15; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> recommendPlaylists(KuGouApi api) async {
  print('\n正在获取推荐歌单...');
  try {
    final result = await api.playlist.top();

    print('\n=== 推荐歌单 ===\n');
    final playlists = result.specialList;
    if (playlists == null || playlists.isEmpty) {
      print('  暂无推荐歌单');
    } else {
      for (var i = 0; i < playlists.length && i < 15; i++) {
        final playlist = playlists[i];
        print('  ${i + 1}. ${playlist.name}');
        print('      播放量: ${playlist.playCount ?? 0}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> rankMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            排行榜功能                │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取排行榜列表                   │');
    print('│  2. 获取排行榜歌曲                   │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-2): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await rankList(api);
        break;
      case '2':
        await rankInfo(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> rankList(KuGouApi api) async {
  print('\n正在获取排行榜列表...');
  try {
    final result = await api.rank.list();
    final ranks = result.info;

    print('\n=== 排行榜列表 ===\n');
    if (ranks == null || ranks.isEmpty) {
      print('  暂无排行榜');
    } else {
      for (var i = 0; i < ranks.length; i++) {
        final rank = ranks[i];
        print('  ${i + 1}. ${rank.rankname}');
        print('      ID: ${rank.rankId}');
        print('');
      }
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> rankInfo(KuGouApi api) async {
  stdout.write('\n请输入排行榜 ID: ');
  final id = stdin.readLineSync()?.trim();
  if (id == null || id.isEmpty) {
    print('ID 不能为空');
    return;
  }

  print('\n正在获取排行榜歌曲...');
  try {
    final result = await api.rank.info(rankId: int.parse(id));
    final songs = result.songinfo;

    print('\n=== 排行榜歌曲 ===\n');
    if (songs == null || songs.isEmpty) {
      print('  暂无歌曲');
    } else {
      for (var i = 0; i < songs.length && i < 20; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> miscMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            杂项功能                  │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取歌手列表                     │');
    print('│  2. 获取新歌速递                     │');
    print('│  3. 获取服务器时间                   │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-3): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await miscSingerList(api);
        break;
      case '2':
        await miscLatestSongs(api);
        break;
      case '3':
        await miscServerTime(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> miscSingerList(KuGouApi api) async {
  print('\n正在获取歌手列表...');
  try {
    final result = await api.misc.singerList();

    print('\n=== 歌手列表 ===\n');
    final data = result.data;
    if (data is List) {
      for (var i = 0; i < data.length && i < 20; i++) {
        final item = data[i] as Map<String, dynamic>;
        print('  ${i + 1}. ${item['singername'] ?? item['name']}');
        print('      ID: ${item['singerid'] ?? item['id']}');
      }
    } else {
      print('  暂无歌手数据');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> miscLatestSongs(KuGouApi api) async {
  print('\n正在获取新歌速递...');
  try {
    final result = await api.misc.latestSongs();

    print('\n=== 新歌速递 ===\n');
    final data = result.data;
    if (data is List) {
      for (var i = 0; i < data.length && i < 15; i++) {
        final item = data[i] as Map<String, dynamic>;
        print('  ${i + 1}. ${item['songname'] ?? item['name']} - ${item['singername'] ?? item['singer']}');
      }
    } else {
      print('  暂无新歌数据');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> miscServerTime(KuGouApi api) async {
  print('\n正在获取服务器时间...');
  try {
    final result = await api.misc.serverNow();

    print('\n=== 服务器时间 ===\n');
    final data = result.data;
    if (data is int) {
      print('  时间戳: $data');
      print('  日期: ${DateTime.fromMillisecondsSinceEpoch(data * 1000)}');
    } else if (data is Map) {
      final timestamp = data['now'] ?? data['timestamp'];
      print('  时间戳: $timestamp');
      if (timestamp is int) {
        print('  日期: ${DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)}');
      }
    } else {
      print('  数据: $data');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> youthMenu(KuGouApi api) async {
  final token = await loadToken();
  if (token == null) {
    print('\n❌ 请先登录');
    return;
  }
  api.httpClient.token = token;
  final userId = await loadUserId();
  if (userId != null) {
    api.httpClient.userid = userId;
  }

  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│        概念版功能 (YouthApi)         │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取用户频道                     │');
    print('│  2. 获取相似频道                     │');
    print('│  3. 获取用户动态                     │');
    print('│  4. 获取用户歌曲                     │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-4): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await youthChannelAll(api);
        break;
      case '2':
        await youthChannelSimilar(api);
        break;
      case '3':
        await youthDynamic(api);
        break;
      case '4':
        await youthUserSong(api, userId!);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> youthChannelAll(KuGouApi api) async {
  print('\n正在获取用户频道...');
  try {
    final result = await api.youth.channelAll();

    print('\n=== 用户频道 ===\n');
    final data = result['data'] as Map<String, dynamic>?;
    final info = data?['info'] as List?;
    if (info == null || info.isEmpty) {
      print('  暂无频道');
    } else {
      for (var i = 0; i < info.length && i < 15; i++) {
        final channel = info[i] as Map<String, dynamic>;
        print('  ${i + 1}. ${channel['name'] ?? channel['channel_name']}');
        print('      歌曲数: ${channel['song_count'] ?? 0}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> youthChannelSimilar(KuGouApi api) async {
  print('\n正在获取相似频道...');
  try {
    final result = await api.youth.channelSimilar(channelId: '1');

    print('\n=== 相似频道 ===\n');
    final data = result['data'] as Map<String, dynamic>?;
    final info = data?['info'] as List?;
    if (info == null || info.isEmpty) {
      print('  暂无频道');
    } else {
      for (var i = 0; i < info.length && i < 15; i++) {
        final channel = info[i] as Map<String, dynamic>;
        print('  ${i + 1}. ${channel['name'] ?? channel['channel_name']}');
        print('      歌曲数: ${channel['song_count'] ?? 0}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> youthDynamic(KuGouApi api) async {
  print('\n正在获取用户动态...');
  try {
    final result = await api.youth.dynamic$();

    print('\n=== 用户动态 ===\n');
    final data = result['data'] as Map<String, dynamic>?;
    if (data == null) {
      print('  暂无动态');
    } else {
      print('  数据: $data');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> youthUserSong(KuGouApi api, int userId) async {
  print('\n正在获取用户歌曲...');
  try {
    final result = await api.youth.userSong(userid: userId);

    print('\n=== 用户歌曲 ===\n');
    final data = result['data'] as Map<String, dynamic>?;
    if (data == null) {
      print('  暂无歌曲');
    } else {
      print('  数据: $data');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> fmMenu(KuGouApi api) async {
  while (true) {
    print('\n┌─────────────────────────────────────┐');
    print('│            FM 功能                   │');
    print('├─────────────────────────────────────┤');
    print('│  1. 获取 FM 分类                     │');
    print('│  2. 获取私人 FM                      │');
    print('│  3. 获取 FM 推荐                     │');
    print('│  0. 返回主菜单                       │');
    print('└─────────────────────────────────────┘');
    stdout.write('\n请选择 (0-3): ');
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '0':
        return;
      case '1':
        await fmClasses(api);
        break;
      case '2':
        await fmPersonal(api);
        break;
      case '3':
        await fmRecommend(api);
        break;
      default:
        print('\n无效选择，请重试。');
    }
  }
}

Future<void> fmClasses(KuGouApi api) async {
  print('\n正在获取 FM 分类...');
  try {
    final result = await api.fm.classes();

    print('\n=== FM 分类 ===\n');
    final classList = result.classList;
    if (classList == null || classList.isEmpty) {
      print('  暂无分类');
    } else {
      for (final group in classList) {
        print('【${group.className}】');
        final fmlist = group.fmlist;
        if (fmlist != null) {
          for (var i = 0; i < fmlist.length && i < 10; i++) {
            final fm = fmlist[i];
            print('  ${i + 1}. ${fm.fmName}');
            print('      ID: ${fm.fmId}');
          }
        }
        print('');
      }
    }
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> fmPersonal(KuGouApi api) async {
  print('\n正在获取私人 FM...');
  try {
    final result = await api.fm.personal();
    final songs = result.list;

    print('\n=== 私人 FM ===\n');
    if (songs == null || songs.isEmpty) {
      print('  暂无推荐');
    } else {
      for (var i = 0; i < songs.length && i < 10; i++) {
        final song = songs[i];
        print('  ${i + 1}. ${song.songName ?? song.name} - ${song.singer}');
      }
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}

Future<void> fmRecommend(KuGouApi api) async {
  print('\n正在获取 FM 推荐...');
  try {
    final result = await api.fm.recommend();

    print('\n=== FM 推荐 ===\n');
    final data = result['data'];
    if (data is List) {
      for (var i = 0; i < data.length && i < 15; i++) {
        final item = data[i] as Map<String, dynamic>;
        print('  ${i + 1}. ${item['fmname'] ?? item['name']}');
      }
    } else {
      print('  数据: $data');
    }
    print('');
  } catch (e) {
    print('\n❌ 获取失败: $e');
  }
}
