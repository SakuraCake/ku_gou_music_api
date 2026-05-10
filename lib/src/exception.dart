/// 酷狗 API 业务异常，表示接口返回了错误状态。
class KuGouApiException implements Exception {
  /// 响应状态码。
  final int? status;

  /// 错误代码。
  final int? code;

  /// 错误消息。
  final String? message;

  /// 响应中的原始数据。
  final dynamic data;

  /// 创建 [KuGouApiException] 实例。
  KuGouApiException({this.status, this.code, this.message, this.data});

  @override
  String toString() =>
      'KuGouApiException(status: $status, code: $code, message: $message)';
}

/// 酷狗网络异常，表示 HTTP 请求过程中发生错误。
class KuGouNetworkException implements Exception {
  /// 错误消息。
  final String? message;

  /// HTTP 状态码。
  final int? statusCode;

  /// 原始异常对象。
  final dynamic originalError;

  /// 创建 [KuGouNetworkException] 实例。
  KuGouNetworkException({this.message, this.statusCode, this.originalError});

  @override
  String toString() =>
      'KuGouNetworkException(message: $message, statusCode: $statusCode)';
}
