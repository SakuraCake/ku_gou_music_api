import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

import 'md5.dart';

/// 使用 AES-CBC 模式加密数据。
///
/// [data] 待加密数据，可以是字符串或可 JSON 序列化的对象。
/// [key] 加密密钥（可选），未提供时自动生成随机密钥。
/// [iv] 初始化向量（可选）。
/// 当 [key] 和 [iv] 都提供时，返回十六进制字符串；
/// 否则自动生成 tempKey，实际加密 key = MD5(tempKey)，iv = key 的后 16 位。
/// 返回包含加密结果 `str` 和密钥 `key` 的映射。
dynamic cryptoAesEncrypt(dynamic data, {String? key, String? iv}) {
  final input = data is String ? data : jsonEncode(data);

  Uint8List keyBytes;
  Uint8List ivBytes;
  String? returnKey;

  if (key != null && iv != null) {
    keyBytes = Uint8List.fromList(utf8.encode(key));
    ivBytes = Uint8List.fromList(utf8.encode(iv));
  } else {
    final tempKey = key ?? _randomHexString(16).toLowerCase();
    final md5Key = cryptoMd5(tempKey);
    keyBytes = Uint8List.fromList(utf8.encode(md5Key));
    ivBytes = Uint8List.fromList(utf8.encode(md5Key.substring(16)));
    returnKey = tempKey;
  }

  final cipher =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()))..init(
        true,
        PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
          ParametersWithIV<KeyParameter>(KeyParameter(keyBytes), ivBytes),
          null,
        ),
      );
  final inputBytes = utf8.encode(input);
  final output = cipher.process(Uint8List.fromList(inputBytes));
  final hex = output.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  
  if (key != null && iv != null) {
    return hex;
  }
  return {'str': hex, 'key': returnKey};
}

/// 使用 AES-CBC 模式解密数据。
///
/// [data] 十六进制编码的密文。
/// [key] 加密密钥。
/// [iv] 初始化向量（可选），未提供时从 key 计算。
/// 返回解密后的数据，优先尝试 JSON 解析，失败则返回原始字符串。
dynamic cryptoAesDecrypt(String data, String key, {String? iv}) {
  Uint8List keyBytes;
  Uint8List ivBytes;

  if (iv != null) {
    keyBytes = Uint8List.fromList(utf8.encode(key));
    ivBytes = Uint8List.fromList(utf8.encode(iv));
  } else {
    final md5Key = cryptoMd5(key);
    keyBytes = Uint8List.fromList(utf8.encode(md5Key));
    ivBytes = Uint8List.fromList(utf8.encode(md5Key.substring(16)));
  }

  final dataBytes = Uint8List.fromList(_hexToBytes(data));
  final cipher =
      PaddedBlockCipherImpl(PKCS7Padding(), CBCBlockCipher(AESEngine()))..init(
        false,
        PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
          ParametersWithIV<KeyParameter>(KeyParameter(keyBytes), ivBytes),
          null,
        ),
      );
  final output = cipher.process(dataBytes);
  final decrypted = utf8.decode(output);
  try {
    return jsonDecode(decrypted);
  } catch (_) {
    return decrypted;
  }
}

String _randomHexString(int length) {
  final random = Random.secure();
  const chars = '0123456789abcdef';
  return List.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}

List<int> _hexToBytes(String hex) {
  final bytes = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return bytes;
}
