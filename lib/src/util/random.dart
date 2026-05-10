import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/digests/md5.dart';

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

/// 生成指定长度的随机字符串。
///
/// [length] 字符串长度，[random] 可选的随机数生成器，默认使用安全随机。
/// 返回由大小写字母和数字组成的随机字符串。
String randomString(int length, {Random? random}) {
  final rng = random ?? Random.secure();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(rng.nextInt(_chars.length)),
    ),
  );
}

/// 生成随机 GUID（UUID v4 格式）。
///
/// [random] 可选的随机数生成器，默认使用安全随机。
/// 返回格式如 `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` 的字符串。
String generateGuid({Random? random}) {
  final rng = random ?? Random.secure();
  String e() => (65536 * (1 + rng.nextDouble())).toInt().toRadixString(16).substring(1);
  return '${e()}${e()}-${e()}-${e()}-${e()}-${e()}${e()}${e()}';
}

/// 根据字符串的 MD5 哈希计算设备 mid 标识。
///
/// [str] 输入字符串，通常为 GUID 的 MD5 哈希。
/// 返回大整数形式的十进制字符串。
String calculateMid(String str) {
  final hexStr = _md5Hex(str);
  final base = BigInt.from(16);
  var result = BigInt.zero;
  for (var i = 0; i < hexStr.length; i++) {
    final charValue = BigInt.from(int.parse(hexStr[i], radix: 16));
    final powerValue = base.pow(hexStr.length - 1 - i);
    result += charValue * powerValue;
  }
  return result.toString();
}

String _md5Hex(String input) {
  final bytes = utf8.encode(input);
  final md5 = MD5Digest();
  md5.update(bytes, 0, bytes.length);
  final out = Uint8List(md5.digestSize);
  md5.doFinal(out, 0);
  return out.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
