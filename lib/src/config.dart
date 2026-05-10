import 'config/constants.dart';

/// 平台类型枚举，区分标准版与轻量版。
enum Platform {
  /// 标准版酷狗客户端。
  standard,

  /// 轻量版酷狗客户端。
  lite,
}

/// 酷狗 API 配置类，包含平台、应用标识、签名盐值和 RSA 公钥等信息。
class KuGouConfig {
  /// 平台类型，决定默认参数和签名盐值。
  final Platform platform;

  /// 应用 ID。
  final int appid;

  /// 客户端版本号。
  final int clientver;

  /// Android 签名算法盐值。
  final String signatureSalt;

  /// key 签名算法盐值。
  final String signKeySalt;

  /// RSA 公钥，用于数据加密。
  final String rsaPublicKey;

  /// API 基础 URL。
  final String baseUrl;

  /// HTTP 请求 User-Agent。
  final String userAgent;

  /// 创建 [KuGouConfig] 实例。
  ///
  /// 未提供的参数将根据 [platform] 自动选择标准版或轻量版的默认值。
  KuGouConfig({
    required this.platform,
    int? appid,
    int? clientver,
    String? signatureSalt,
    String? signKeySalt,
    String? rsaPublicKey,
    String? baseUrl,
    String? userAgent,
  }) : appid =
           appid ?? (platform == Platform.lite ? kLiteAppid : kStandardAppid),
       clientver =
           clientver ??
           (platform == Platform.lite ? kLiteClientver : kStandardClientver),
       signatureSalt =
           signatureSalt ??
           (platform == Platform.lite
               ? kLiteSignatureSalt
               : kStandardSignatureSalt),
       signKeySalt =
           signKeySalt ??
           (platform == Platform.lite
               ? kLiteSignKeySalt
               : kStandardSignKeySalt),
       rsaPublicKey =
           rsaPublicKey ??
           (platform == Platform.lite
               ? kLiteRsaPublicKey
               : kStandardRsaPublicKey),
       baseUrl = baseUrl ?? kDefaultBaseUrl,
       userAgent = userAgent ?? kDefaultUserAgent;

  /// 是否为轻量版平台。
  bool get isLite => platform == Platform.lite;
}
