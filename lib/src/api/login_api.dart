import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../config/constants.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../crypto/signature.dart';
import '../exception.dart';
import '../models/user.dart';
import '../util/random.dart';

/// 登录相关接口
class LoginApi extends BaseApi {
  /// 构造登录 API 实例
  LoginApi(super.client);

  /// 当前登录令牌
  String? _token;

  /// 当前登录用户 ID
  int? _userid;

  /// 获取登录令牌，优先使用本地缓存的令牌
  String? get token => _token ?? client.httpClient.token;

  /// 获取登录用户 ID，优先使用本地缓存的用户 ID
  int? get userid => _userid ?? client.httpClient.userid;

  /// 密码登录（已禁用，不可用）
  ///
  /// 该方法已禁用，调用将抛出 [UnsupportedError] 异常。
  /// 请使用二维码登录或直接设置 Token。
  @Deprecated('密码登录不可用，请使用二维码登录或直接设置 Token')
  Future<LoginResult> byPassword({
    required String username,
    required String password,
  }) async {
    throw UnsupportedError('密码登录不可用，请使用二维码登录或直接设置 Token');
  }

  /// 发送验证码（已禁用，不可用）
  ///
  /// 该方法已禁用，调用将抛出 [UnsupportedError] 异常。
  /// 请使用二维码登录或直接设置 Token。
  @Deprecated('验证码登录不可用，请使用二维码登录或直接设置 Token')
  Future<bool> sendCaptcha({required String phone}) async {
    throw UnsupportedError('验证码登录不可用，请使用二维码登录或直接设置 Token');
  }

  /// 验证码登录（已禁用，不可用）
  ///
  /// 该方法已禁用，调用将抛出 [UnsupportedError] 异常。
  /// 请使用二维码登录或直接设置 Token。
  @Deprecated('验证码登录不可用，请使用二维码登录或直接设置 Token')
  Future<LoginResult> byCaptcha({
    required String phone,
    required String captcha,
  }) async {
    throw UnsupportedError('验证码登录不可用，请使用二维码登录或直接设置 Token');
  }

  /// 二维码登录状态流，[interval] 为轮询间隔，自动获取二维码并持续检查扫码状态
  ///
  /// 首次 yield 会返回 [QrCodeState.waiting] 并附带 [QrCodeInfo] 中的二维码图片，
  /// 可通过 [qrInfo] 获取二维码信息（含 base64 图片）。
  Stream<QrCodeState> qrCodeStream({
    Duration interval = const Duration(seconds: 3),
  }) async* {
    _qrInfo = await _getQrCode();
    if (_qrInfo == null) {
      yield QrCodeState.error;
      return;
    }

    yield QrCodeState.waiting;

    while (true) {
      final state = await _checkQrCodeState(_qrInfo!);
      yield state;
      if (state == QrCodeState.confirmed ||
          state == QrCodeState.error ||
          state == QrCodeState.expired) {
        break;
      }
      await Future.delayed(interval);
    }
  }

  /// 最近一次二维码信息，二维码登录前为 null
  QrCodeInfo? _qrInfo;

  /// 获取当前二维码信息
  QrCodeInfo? get qrInfo => _qrInfo;

  Future<QrCodeInfo?> _getQrCode() async {
    try {
      final result = await client.get<Map<String, dynamic>>(
        '/v2/qrcode',
        params: {
          'appid': 1001,
          'type': 1,
          'plat': 4,
          'qrimg': 1,
          'qrcode_txt':
              'https://h5.kugou.com/apps/loginQRCode/html/index.html?appid=${client.httpClient.config.appid}&',
          'srcappid': kSrcAppid,
        },
        baseURL: 'https://login-user.kugou.com',
        encryptType: EncryptType.web,
      );
      final data = result['data'];
      if (data is Map<String, dynamic>) {
        return QrCodeInfo(
          qrCode: data['qrcode'] as String?,
          qrUrl: data['qrcode_txt'] as String?,
          qrImg: data['qrcode_img'] as String?,
          expire: (data['expire_time'] as num?)?.toInt(),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<QrCodeState> _checkQrCodeState(QrCodeInfo qrInfo) async {
    try {
      final result = await client.get<Map<String, dynamic>>(
        '/v2/get_userinfo_qrcode',
        params: {
          'plat': 4,
          'appid': client.httpClient.config.appid,
          'srcappid': kSrcAppid,
          'qrcode': qrInfo.qrCode,
        },
        baseURL: 'https://login-user.kugou.com',
        encryptType: EncryptType.web,
      );
      final data = result['data'] as Map<String, dynamic>?;
      final status = data?['status'] as int?;
      switch (status) {
        case 0:
          return QrCodeState.expired;
        case 1:
          return QrCodeState.waiting;
        case 2:
          return QrCodeState.scanned;
        case 4:
          final token = data?['token'] as String?;
          final userId = (data?['userid'] as num?)?.toInt();
          if (token != null) {
            _token = token;
            _userid = userId;
            client.httpClient.token = token;
            client.httpClient.userid = userId;
          }
          return QrCodeState.confirmed;
        default:
          return QrCodeState.error;
      }
    } catch (_) {
      return QrCodeState.error;
    }
  }
}
