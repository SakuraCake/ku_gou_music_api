// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  userId: (json['userId'] as num?)?.toInt(),
  userName: json['userName'] as String?,
  img: json['img'] as String?,
  vipType: (json['vipType'] as num?)?.toInt(),
  token: json['token'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'img': instance.img,
      'vipType': instance.vipType,
      'token': instance.token,
    };

LoginResult _$LoginResultFromJson(Map<String, dynamic> json) => LoginResult(
  userId: (json['userId'] as num?)?.toInt(),
  token: json['token'] as String?,
  userName: json['userName'] as String?,
  vipType: (json['vipType'] as num?)?.toInt(),
  success: json['success'] as bool?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$LoginResultToJson(LoginResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'token': instance.token,
      'userName': instance.userName,
      'vipType': instance.vipType,
      'success': instance.success,
      'message': instance.message,
    };

QrCodeInfo _$QrCodeInfoFromJson(Map<String, dynamic> json) => QrCodeInfo(
  qrCode: json['qrCode'] as String?,
  qrUrl: json['qrUrl'] as String?,
  expire: (json['expire'] as num?)?.toInt(),
  qrImg: json['qrImg'] as String?,
);

Map<String, dynamic> _$QrCodeInfoToJson(QrCodeInfo instance) =>
    <String, dynamic>{
      'qrCode': instance.qrCode,
      'qrUrl': instance.qrUrl,
      'expire': instance.expire,
      'qrImg': instance.qrImg,
    };

CaptchaResult _$CaptchaResultFromJson(Map<String, dynamic> json) =>
    CaptchaResult(
      success: json['success'] as bool,
      errorCode: (json['errorCode'] as num?)?.toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$CaptchaResultToJson(CaptchaResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };
