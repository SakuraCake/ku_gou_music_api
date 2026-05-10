import 'dart:async';
import 'dart:math';

/// 重试配置选项。
class RetryOptions {
  /// 最大重试次数。
  final int maxAttempts;

  /// 基础延迟时间。
  final Duration baseDelay;

  /// 延迟倍数，用于指数退避。
  final double multiplier;

  /// 创建 [RetryOptions] 实例。
  ///
  /// 默认最多重试 3 次，基础延迟 1 秒，倍数 2.0。
  const RetryOptions({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.multiplier = 2.0,
  });

  /// 计算第 [attempt] 次重试的延迟时间，采用指数退避策略。
  Duration delayForAttempt(int attempt) {
    final delayMs = baseDelay.inMilliseconds * pow(multiplier, attempt);
    return Duration(milliseconds: delayMs.round());
  }
}

/// 带重试逻辑的异步执行器。
///
/// [fn] 待执行的异步函数，[options] 重试配置，
/// [retryIf] 可选的异常判断函数，返回 true 时才重试。
/// 达到最大重试次数后仍失败则重新抛出异常。
Future<T> withRetry<T>(
  Future<T> Function() fn, {
  RetryOptions options = const RetryOptions(),
  bool Function(Object error)? retryIf,
}) async {
  int attempt = 0;
  while (true) {
    try {
      return await fn();
    } catch (e) {
      attempt++;
      if (attempt >= options.maxAttempts) rethrow;
      if (retryIf != null && !retryIf(e)) rethrow;
      await Future.delayed(options.delayForAttempt(attempt - 1));
    }
  }
}
