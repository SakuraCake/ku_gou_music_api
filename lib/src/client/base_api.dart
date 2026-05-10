import 'api_client.dart';

/// 所有 API 模块的基类，持有 [ApiClient] 实例供子类使用。
abstract class BaseApi {
  /// API 客户端实例。
  final ApiClient client;

  /// 创建 [BaseApi] 实例，子类需传入 [client]。
  BaseApi(this.client);
}
