import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 用户资料信息
@JsonSerializable()
class UserProfile {
  /// 用户ID
  final int? userId;

  /// 用户名
  final String? userName;

  /// 头像地址
  final String? img;

  /// VIP类型
  final int? vipType;

  /// 登录令牌
  final String? token;

  /// Creates a new [UserProfile] instance.
  UserProfile({this.userId, this.userName, this.img, this.vipType, this.token});

  /// Creates a [UserProfile] from JSON data.
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

/// 登录结果
@JsonSerializable()
class LoginResult {
  /// 用户ID
  final int? userId;

  /// 登录令牌
  final String? token;

  /// 用户名
  final String? userName;

  /// VIP类型
  final int? vipType;

  /// 是否登录成功
  final bool? success;

  /// 提示消息
  final String? message;

  /// Creates a new [LoginResult] instance.
  LoginResult({
    this.userId,
    this.token,
    this.userName,
    this.vipType,
    this.success,
    this.message,
  });

  /// Creates a [LoginResult] from JSON data.
  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResultToJson(this);
}

/// 二维码扫码状态枚举
enum QrCodeState {
  /// 等待扫码
  waiting,

  /// 已扫码待确认
  scanned,

  /// 已确认
  confirmed,

  /// 已过期
  expired,

  /// 错误
  error,
}

/// 二维码信息
@JsonSerializable()
class QrCodeInfo {
  /// 二维码内容
  final String? qrCode;

  /// 二维码链接
  final String? qrUrl;

  /// 过期时间（秒）
  final int? expire;

  /// 二维码图片 base64
  final String? qrImg;

  /// Creates a new [QrCodeInfo] instance.
  QrCodeInfo({this.qrCode, this.qrUrl, this.expire, this.qrImg});

  /// Creates a [QrCodeInfo] from JSON data.
  factory QrCodeInfo.fromJson(Map<String, dynamic> json) =>
      _$QrCodeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$QrCodeInfoToJson(this);
}

/// 验证码发送结果
@JsonSerializable()
class CaptchaResult {
  /// 是否发送成功
  final bool success;

  /// 错误码
  final int? errorCode;

  /// 提示消息
  final String? message;

  /// Creates a new [CaptchaResult] instance.
  CaptchaResult({required this.success, this.errorCode, this.message});

  /// Creates a [CaptchaResult] from JSON data.
  factory CaptchaResult.fromJson(Map<String, dynamic> json) =>
      _$CaptchaResultFromJson(json);
  Map<String, dynamic> toJson() => _$CaptchaResultToJson(this);
}
