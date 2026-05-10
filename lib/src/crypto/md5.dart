import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/digests/md5.dart';

/// 计算数据的 MD5 哈希值。
///
/// [data] 可以是字符串或其他可 JSON 序列化的类型。
/// 返回 32 位小写十六进制 MD5 字符串。
String cryptoMd5(dynamic data) {
  final input = data is String ? data : jsonEncode(data);
  final bytes = utf8.encode(input);
  final md5 = MD5Digest();
  md5.update(bytes, 0, bytes.length);
  final out = Uint8List(md5.digestSize);
  md5.doFinal(out, 0);
  return out.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
