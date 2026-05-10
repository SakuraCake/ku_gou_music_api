import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import '../config/constants.dart';

/// 使用 RSA 公钥加密数据。
///
/// [data] 待加密的明文字符串，[publicKey] Base64 编码的 RSA 公钥，
/// 未提供时使用默认的标准版公钥。返回十六进制编码的密文。
String cryptoRSAEncrypt(String data, {String? publicKey}) {
  final key = _parseRsaPublicKey(publicKey ?? kStandardRsaPublicKey);
  final encryptor = PKCS1Encoding(RSAEngine())
    ..init(true, PublicKeyParameter<RSAPublicKey>(key));
  final input = utf8.encode(data);
  final output = encryptor.process(Uint8List.fromList(input));
  return output.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

RSAPublicKey _parseRsaPublicKey(String base64Key) {
  final bytes = base64Decode(base64Key);
  var offset = 0;
  offset += 1;
  offset += _derLengthSize(bytes, offset);
  offset = _skipElement(bytes, offset);
  offset += 1;
  offset += _derLengthSize(bytes, offset);
  offset += 1;
  offset += 1;
  offset += _derLengthSize(bytes, offset);
  final modulus = _readDerInteger(bytes, offset);
  offset = _skipElement(bytes, offset);
  final exponent = _readDerInteger(bytes, offset);
  return RSAPublicKey(modulus, exponent);
}

int _derLengthSize(List<int> bytes, int offset) {
  final b = bytes[offset];
  if (b < 0x80) return 1;
  return 1 + (b & 0x7f);
}

int _readDerLength(List<int> bytes, int offset) {
  final b = bytes[offset];
  if (b < 0x80) return b;
  final numBytes = b & 0x7f;
  int length = 0;
  for (int i = 0; i < numBytes; i++) {
    length = (length << 8) | bytes[offset + 1 + i];
  }
  return length;
}

int _skipElement(List<int> bytes, int offset) {
  offset += 1;
  final lengthSize = _derLengthSize(bytes, offset);
  final length = _readDerLength(bytes, offset);
  offset += lengthSize;
  return offset + length;
}

BigInt _readDerInteger(List<int> bytes, int offset) {
  offset += 1;
  final lengthSize = _derLengthSize(bytes, offset);
  final length = _readDerLength(bytes, offset);
  offset += lengthSize;
  final valueBytes = bytes.sublist(offset, offset + length);
  return BigInt.parse(
    valueBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
    radix: 16,
  );
}
