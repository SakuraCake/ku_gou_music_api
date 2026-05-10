/// 日志级别枚举，从低到高排列。
enum LogLevel {
  /// 不输出任何日志。
  none,

  /// 仅输出错误日志。
  error,

  /// 输出警告及以上级别日志。
  warning,

  /// 输出信息及以上级别日志。
  info,

  /// 输出所有级别日志。
  debug,
}

/// 日志回调函数类型。
///
/// [level] 日志级别，[message] 日志消息。
typedef LogCallback = void Function(LogLevel level, String message);

/// 简单的日志记录器，支持级别过滤和自定义回调。
class Logger {
  /// 最低日志输出级别，低于此级别的日志将被忽略。
  LogLevel minLevel;

  /// 自定义日志回调函数，为 null 时不输出日志。
  LogCallback? callback;

  /// 创建 [Logger] 实例。
  ///
  /// [minLevel] 默认为 [LogLevel.none]，即不输出任何日志。
  Logger({this.minLevel = LogLevel.none, this.callback});

  /// 输出调试级别日志。
  void debug(String message) => _log(LogLevel.debug, message);

  /// 输出信息级别日志。
  void info(String message) => _log(LogLevel.info, message);

  /// 输出警告级别日志。
  void warning(String message) => _log(LogLevel.warning, message);

  /// 输出错误级别日志。
  void error(String message) => _log(LogLevel.error, message);

  void _log(LogLevel level, String message) {
    if (minLevel != LogLevel.none && level.index > minLevel.index) return;
    callback?.call(level, message);
  }
}
