import 'dart:convert';
import 'md5.dart';
import '../config/constants.dart';

/// 使用 Android 客户端签名算法计算参数签名。
///
/// [params] 请求参数映射，[data] 请求体数据，[isLite] 是否使用轻量版盐值。
/// 返回 MD5 签名字符串。
String signatureAndroidParams(Map<String, dynamic> params, [String? data, bool isLite = false]) {
  final salt = isLite ? kLiteSignatureSalt : kStandardSignatureSalt;
  final sortedKeys = params.keys.toList()..sort();
  final paramsStr = sortedKeys
      .map((key) {
        final value = params[key];
        return '$key=${value is Map || value is List ? jsonEncode(value) : value}';
      })
      .join('');
  return cryptoMd5('$salt$paramsStr${data ?? ''}$salt');
}

/// 使用 Web 端签名算法计算参数签名。
///
/// [params] 请求参数映射。返回 MD5 签名字符串。
String signatureWebParams(Map<String, dynamic> params) {
  final paramsString = params.keys.map((key) => '$key=${params[key]}').toList()
    ..sort();
  return cryptoMd5(
    '$kWebSignatureSalt${paramsString.join('')}$kWebSignatureSalt',
  );
}

/// 使用注册签名算法计算参数签名。
///
/// [params] 请求参数映射。返回 MD5 签名字符串。
String signatureRegisterParams(Map<String, dynamic> params) {
  final paramsString = params.values.map((v) => v.toString()).toList()..sort();
  return cryptoMd5(
    '$kRegisterSignatureSalt${paramsString.join('')}$kRegisterSignatureSalt',
  );
}

/// 计算请求 key 签名。
///
/// [hash] 资源哈希值，[mid] 设备标识，[userid] 用户 ID，
/// [appid] 应用 ID，[isLite] 是否使用轻量版盐值。
/// 返回 MD5 签名字符串。
String signKey(
  String hash,
  String mid, {
  int? userid,
  int? appid,
  bool isLite = false,
}) {
  final salt = isLite ? kLiteSignKeySalt : kStandardSignKeySalt;
  final effectiveAppid = appid ?? (isLite ? kLiteAppid : kStandardAppid);
  return cryptoMd5('$hash$salt$effectiveAppid$mid${userid ?? 0}');
}

/// 计算通用参数签名。
///
/// [data] 待签名数据，[appid] 应用 ID，[clientver] 客户端版本号，
/// [isLite] 是否使用轻量版盐值。返回 MD5 签名字符串。
String signParams(
  String data, {
  int? appid,
  int? clientver,
  bool isLite = false,
}) {
  final salt = isLite ? kLiteSignatureSalt : kStandardSignatureSalt;
  final effectiveAppid = appid ?? (isLite ? kLiteAppid : kStandardAppid);
  final effectiveClientver =
      clientver ?? (isLite ? kLiteClientver : kStandardClientver);
  return cryptoMd5('$effectiveAppid$salt$effectiveClientver$data');
}

/// 计算云端 key 签名。
///
/// [hash] 资源哈希值，[pid] 项目标识。返回 MD5 签名字符串。
String signCloudKey(String hash, String pid) {
  return cryptoMd5('musicclound$hash$pid$kCloudKeySalt');
}
