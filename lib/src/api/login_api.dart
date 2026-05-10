import 'dart:convert';

import '../client/base_api.dart';
import '../client/http_client.dart';
import '../config/constants.dart';
import '../crypto/aes.dart';
import '../crypto/rsa.dart';
import '../models/user.dart';

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

  /// 密码登录，[username] 为用户名，[password] 为密码
  Future<LoginResult> byPassword({
    required String username,
    required String password,
  }) async {
    final dateNow = DateTime.now().millisecondsSinceEpoch;
    final encrypt = cryptoAesEncrypt({
      'pwd': password,
      'code': '',
      'clienttime_ms': dateNow,
    });
    final pk = cryptoRSAEncrypt(
      jsonEncode({'clienttime_ms': dateNow, 'key': encrypt['key']}),
      publicKey: client.httpClient.config.rsaPublicKey,
    ).toUpperCase();
    return client.post<LoginResult>(
      '/v9/login_by_pwd',
      body: {
        'plat': 1,
        'support_multi': 1,
        'clienttime_ms': dateNow,
        't1': '562a6f12a6e803453647d16a08f5f0c2ff7eee692cba2ab74cc4c8ab47fc467561a7c6b586ce7dc46a63613b246737c03a1dc8f8d162d8ce1d2c71893d19f1d4b797685a4c6d3d81341cbde65e488c4829a9b4d42ef2df470eb102979fa5adcdd9b4eecfea8b909ff7599abeb49867640f10c3c70fc444effca9d15db44a9a6c907731e2bb0f22cd9b3536380169995693e5f0e2424e3378097d3813186e3fe96bbe7023808a0981b4e2b6135a76faac',
        't2': '31c4daf4cf480169ccea1cb7d4a209295865a9d2b788510301694db229b87807469ea0d41b4d4b9173c2151da7294aeebfc9738df154bbdf11a4e117bb5dff6a3af8ce5ce333e681c1f29a44038f27567d58992eb81283e080778ac77db1400fdf49b7cf7e26be2e5af4da7830cc3be4',
        't3': 'MCwwLDAsMCwwLDAsMCwwLDA=',
        'username': username,
        'params': encrypt['str'],
        'pk': pk,
      },
      router: 'login.user.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) {
        if (json['secu_params'] != null) {
          final decrypted = cryptoAesDecrypt(
            json['secu_params'] as String,
            encrypt['key']!,
          );
          if (decrypted is Map) {
            json.addAll(Map<String, dynamic>.from(decrypted));
          } else {
            json['token'] = decrypted.toString();
          }
        }
        final result = LoginResult.fromJson(json);
        if (result.token != null) {
          _token = result.token;
          _userid = result.userId;
          client.httpClient.token = result.token;
          client.httpClient.userid = result.userId;
        }
        return result;
      },
    );
  }

  /// 发送验证码，[phone] 为手机号码
  Future<bool> sendCaptcha({required String phone}) async {
    return client.post<bool>(
      '/v1/login/captcha',
      body: {'phone': phone, 'appid': client.httpClient.config.appid},
      router: 'loginuser.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) => json['status'] == 1,
    );
  }

  /// 验证码登录，[phone] 为手机号码，[captcha] 为验证码
  Future<LoginResult> byCaptcha({
    required String phone,
    required String captcha,
  }) async {
    return client.post<LoginResult>(
      '/v1/login/by_captcha',
      body: {
        'phone': phone,
        'captcha': captcha,
        'appid': client.httpClient.config.appid,
      },
      router: 'loginuser.kugou.com',
      encryptType: EncryptType.android,
      fromJson: (json) {
        final result = LoginResult.fromJson(json);
        if (result.token != null) {
          _token = result.token;
          _userid = result.userId;
          client.httpClient.token = result.token;
          client.httpClient.userid = result.userId;
        }
        return result;
      },
    );
  }

  /// 二维码登录状态流，[interval] 为轮询间隔，自动获取二维码并持续检查扫码状态
  Stream<QrCodeState> qrCodeStream({
    Duration interval = const Duration(seconds: 3),
  }) async* {
    final qrInfo = await _getQrCode();
    if (qrInfo == null) {
      yield QrCodeState.error;
      return;
    }

    while (true) {
      final state = await _checkQrCodeState(qrInfo);
      yield state;
      if (state == QrCodeState.confirmed ||
          state == QrCodeState.error ||
          state == QrCodeState.expired) {
        break;
      }
      await Future.delayed(interval);
    }
  }

  Future<QrCodeInfo?> _getQrCode() async {
    try {
      final result = await client.get<Map<String, dynamic>>(
        '/v2/qrcode',
        params: {
          'appid': 1001,
          'type': 1,
          'plat': 4,
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
