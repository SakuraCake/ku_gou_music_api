import 'dart:convert';
import 'dart:io';

/// KRC 歌词文件的解密密钥。
const _krcKey = [
  0x40,
  0x47,
  0x61,
  0x77,
  0x5e,
  0x32,
  0x74,
  0x47,
  0x51,
  0x36,
  0x31,
  0x2d,
  0xce,
  0xd2,
  0x6e,
  0x69,
];

/// 解密 KRC 格式的歌词数据。
///
/// [data] KRC 文件的原始字节数据。仅支持 `krc1` 格式头部，
/// 解密过程包括 zlib 解压和异或运算。返回解密后的歌词文本。
String decryptKrc(List<int> data) {
  if (data.length < 4) return '';
  final header = String.fromCharCodes(data.sublist(0, 4));
  if (header != 'krc1') return '';
  final compressed = data.sublist(4);
  final decompressed = zlib.decode(compressed);
  final decrypted = List<int>.generate(
    decompressed.length,
    (i) => decompressed[i] ^ _krcKey[i % _krcKey.length],
  );
  return utf8.decode(decrypted);
}
