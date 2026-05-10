import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

/// 使用 AES-CBC 模式加密数据。
///
/// [data] 待加密数据，可以是字符串或可 JSON 序列化的对象。
/// [key] 加密密钥（十六进制字符串），未提供时自动生成随机密钥。
/// [iv] 初始化向量（十六进制字符串），未提供时使用全零 IV。
/// 返回包含加密结果 `str` 和密钥 `key` 的映射。
Map<String, String> cryptoAesEncrypt(dynamic data, {String? key, String? iv}) {
  final tempKey = key ?? _randomHex(16);
  final tempIv = iv ?? '00000000000000000000000000000000';
  final input = data is String ? data : jsonEncode(data);
  final keyBytes = Uint8List.fromList(_hexToBytes(tempKey));
  final ivBytes = Uint8List.fromList(_hexToBytes(tempIv));
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
  return {
    'str': output.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
    'key': tempKey,
  };
}

/// 使用 AES-CBC 模式解密数据。
///
/// [data] 十六进制编码的密文，[key] 加密密钥（十六进制字符串），
/// [iv] 初始化向量（十六进制字符串），未提供时使用全零 IV。
/// 返回解密后的数据，优先尝试 JSON 解析，失败则返回原始字符串。
dynamic cryptoAesDecrypt(String data, String key, {String? iv}) {
  final tempIv = iv ?? '00000000000000000000000000000000';
  final keyBytes = Uint8List.fromList(_hexToBytes(key));
  final ivBytes = Uint8List.fromList(_hexToBytes(tempIv));
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

String _randomHex(int byteCount) {
  final random = Random.secure();
  return List.generate(
    byteCount,
    (_) => random.nextInt(256),
  ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

List<int> _hexToBytes(String hex) {
  final bytes = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return bytes;
}
