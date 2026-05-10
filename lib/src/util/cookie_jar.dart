/// Cookie 管理器，负责存储、匹配和序列化 HTTP Cookie。
///
/// 支持按域名匹配 Cookie、自动解析 Set-Cookie 响应头、
/// Cookie 过期检查以及序列化/反序列化以便持久化存储。
class CookieJar {
  final Map<String, _CookieEntry> _cookies = {};

  /// 创建 [CookieJar] 实例。
  ///
  /// [initialCookies] 可传入初始 Cookie 映射，键为域名（如 `kugou.com`），
  /// 值为 Cookie 字符串（如 `token=abc; userid=123`）。
  CookieJar({Map<String, String>? initialCookies}) {
    if (initialCookies != null) {
      initialCookies.forEach((domain, cookieStr) {
        final pairs = cookieStr.split(';');
        for (final pair in pairs) {
          final trimmed = pair.trim();
          if (trimmed.isEmpty) continue;
          final eqIndex = trimmed.indexOf('=');
          if (eqIndex <= 0) continue;
          final name = trimmed.substring(0, eqIndex).trim();
          final value = trimmed.substring(eqIndex + 1).trim();
          set(domain: domain, name: name, value: value);
        }
      });
    }
  }

  /// 根据请求 URL 获取匹配的 Cookie 字符串。
  ///
  /// 遍历所有已存储的 Cookie，匹配域名后缀，返回拼接后的 Cookie 值。
  /// 过期的 Cookie 会被自动清除。
  String getCookiesForUrl(String url) {
    final uri = Uri.parse(url);
    final host = uri.host;
    final now = DateTime.now();
    final matched = <String>[];

    final expiredKeys = <String>[];
    for (final entry in _cookies.entries) {
      final cookie = entry.value;
      if (cookie.isExpired(now)) {
        expiredKeys.add(entry.key);
        continue;
      }
      if (_domainMatches(cookie.domain, host)) {
        if (cookie.secure && uri.scheme != 'https') continue;
        if (cookie.path != '/' && !uri.path.startsWith(cookie.path)) continue;
        matched.add('${cookie.name}=${cookie.value}');
      }
    }

    for (final key in expiredKeys) {
      _cookies.remove(key);
    }

    return matched.join('; ');
  }

  /// 从 Set-Cookie 响应头解析并存储 Cookie。
  ///
  /// [url] 请求 URL，用于确定默认域名，
  /// [setCookieHeader] Set-Cookie 头的值。
  void setFromHeader(String url, String setCookieHeader) {
    final uri = Uri.parse(url);
    final host = uri.host;
    final cookies = setCookieHeader.split(',');
    final now = DateTime.now();

    for (final cookieStr in cookies) {
      final parts = cookieStr.trim().split(';');
      if (parts.isEmpty) continue;

      final nameValue = parts[0].trim();
      final eqIndex = nameValue.indexOf('=');
      if (eqIndex <= 0) continue;

      final name = nameValue.substring(0, eqIndex).trim();
      final value = nameValue.substring(eqIndex + 1).trim();

      var domain = host;
      var path = '/';
      DateTime? expiresAt;
      var secure = false;
      var httpOnly = false;

      for (var i = 1; i < parts.length; i++) {
        final part = parts[i].trim().toLowerCase();
        if (part.startsWith('domain=')) {
          domain = parts[i].trim().substring(7).trim();
          if (domain.startsWith('.')) domain = domain.substring(1);
        } else if (part.startsWith('path=')) {
          path = parts[i].trim().substring(5).trim();
        } else if (part.startsWith('expires=')) {
          final expiresStr = parts[i].trim().substring(8).trim();
          final parsed = HttpDateParser.tryParse(expiresStr);
          if (parsed != null) expiresAt = parsed;
        } else if (part.startsWith('max-age=')) {
          final maxAge = int.tryParse(part.substring(8));
          if (maxAge != null && maxAge > 0) {
            expiresAt = now.add(Duration(seconds: maxAge));
          } else if (maxAge != null && maxAge <= 0) {
            expiresAt = DateTime.fromMillisecondsSinceEpoch(1);
          }
        } else if (part == 'secure') {
          secure = true;
        } else if (part == 'httponly') {
          httpOnly = true;
        }
      }

      final key = '$domain:$name';
      _cookies[key] = _CookieEntry(
        name: name,
        value: value,
        domain: domain,
        path: path,
        expiresAt: expiresAt,
        secure: secure,
        httpOnly: httpOnly,
      );
    }
  }

  /// 直接设置一个 Cookie。
  ///
  /// [domain] 域名，[name] Cookie 名称，[value] Cookie 值，
  /// [path] 路径，[expiresAt] 过期时间，[secure] 是否仅 HTTPS，
  /// [httpOnly] 是否禁止 JS 访问。
  void set({
    required String domain,
    required String name,
    required String value,
    String path = '/',
    DateTime? expiresAt,
    bool secure = false,
    bool httpOnly = false,
  }) {
    final key = '$domain:$name';
    _cookies[key] = _CookieEntry(
      name: name,
      value: value,
      domain: domain,
      path: path,
      expiresAt: expiresAt,
      secure: secure,
      httpOnly: httpOnly,
    );
  }

  /// 获取指定域名的所有 Cookie 条目。
  ///
  /// [domain] 域名，返回该域名下所有未过期的 Cookie 映射。
  Map<String, String> getAllForDomain(String domain) {
    final now = DateTime.now();
    final result = <String, String>{};
    final expiredKeys = <String>[];

    for (final entry in _cookies.entries) {
      final cookie = entry.value;
      if (cookie.isExpired(now)) {
        expiredKeys.add(entry.key);
        continue;
      }
      if (_domainMatches(cookie.domain, domain)) {
        result[cookie.name] = cookie.value;
      }
    }

    for (final key in expiredKeys) {
      _cookies.remove(key);
    }

    return result;
  }

  /// 获取所有已存储的 Cookie，按域名分组。
  ///
  /// 返回映射，键为域名，值为该域名下的所有 Cookie 字符串。
  Map<String, String> getAll() {
    final now = DateTime.now();
    final result = <String, String>{};
    final expiredKeys = <String>[];

    for (final entry in _cookies.entries) {
      final cookie = entry.value;
      if (cookie.isExpired(now)) {
        expiredKeys.add(entry.key);
        continue;
      }
      final domain = cookie.domain;
      final existing = result[domain];
      result[domain] = existing != null
          ? '$existing; ${cookie.name}=${cookie.value}'
          : '${cookie.name}=${cookie.value}';
    }

    for (final key in expiredKeys) {
      _cookies.remove(key);
    }

    return result;
  }

  /// 清除所有 Cookie。
  void clear() {
    _cookies.clear();
  }

  /// 移除指定域名的所有 Cookie。
  void removeForDomain(String domain) {
    _cookies.removeWhere((key, _) => key.startsWith('$domain:'));
  }

  /// 移除指定域名的指定 Cookie。
  void remove(String domain, String name) {
    _cookies.remove('$domain:$name');
  }

  /// 将 Cookie 序列化为 JSON 可存储的映射。
  ///
  /// 返回映射，键为 `domain:name`，值为包含所有属性的映射，
  /// 可用于持久化存储后通过 [loadFromMap] 恢复。
  Map<String, Map<String, dynamic>> serialize() {
    final result = <String, Map<String, dynamic>>{};
    for (final entry in _cookies.entries) {
      final cookie = entry.value;
      result[entry.key] = {
        'name': cookie.name,
        'value': cookie.value,
        'domain': cookie.domain,
        'path': cookie.path,
        'expiresAt': cookie.expiresAt?.millisecondsSinceEpoch,
        'secure': cookie.secure,
        'httpOnly': cookie.httpOnly,
      };
    }
    return result;
  }

  /// 从序列化映射恢复 Cookie。
  ///
  /// [data] 为 [serialize] 方法返回的映射。
  void loadFromMap(Map<String, Map<String, dynamic>> data) {
    for (final entry in data.entries) {
      final v = entry.value;
      _cookies[entry.key] = _CookieEntry(
        name: v['name'] as String,
        value: v['value'] as String,
        domain: v['domain'] as String,
        path: v['path'] as String? ?? '/',
        expiresAt: v['expiresAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(v['expiresAt'] as int)
            : null,
        secure: v['secure'] as bool? ?? false,
        httpOnly: v['httpOnly'] as bool? ?? false,
      );
    }
  }

  /// 已存储的 Cookie 数量。
  int get length => _cookies.length;

  /// 是否为空。
  bool get isEmpty => _cookies.isEmpty;

  static bool _domainMatches(String cookieDomain, String host) {
    if (cookieDomain == host) return true;
    if (host.endsWith('.$cookieDomain')) return true;
    return false;
  }
}

class _CookieEntry {
  final String name;
  final String value;
  final String domain;
  final String path;
  final DateTime? expiresAt;
  final bool secure;
  final bool httpOnly;

  _CookieEntry({
    required this.name,
    required this.value,
    required this.domain,
    required this.path,
    required this.expiresAt,
    required this.secure,
    required this.httpOnly,
  });

  bool isExpired(DateTime now) {
    if (expiresAt == null) return false;
    return now.isAfter(expiresAt!);
  }
}

/// HTTP 日期解析器，用于解析 Set-Cookie 中的 expires 值。
///
/// 所有方法均为静态方法，无需实例化。
class HttpDateParser {
  /// Creates a new [HttpDateParser] instance.
  HttpDateParser();

  static final _months = <String, int>{
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };

  /// 尝试解析 HTTP 日期字符串，失败返回 null。
  ///
  /// 支持的格式：
  /// - `Sun, 06 Nov 1994 08:49:37 GMT` (RFC 1123)
  /// - `Sunday, 06-Nov-94 08:49:37 GMT` (RFC 850)
  /// - `Sun Nov  6 08:49:37 1994` (asctime)
  static DateTime? tryParse(String dateStr) {
    try {
      final trimmed = dateStr.trim();

      final rfc1123 = RegExp(
        r'^\w{3},\s+(\d{1,2})\s+(\w{3})\s+(\d{2,4})\s+(\d{2}):(\d{2}):(\d{2})',
      );
      var match = rfc1123.firstMatch(trimmed);
      if (match != null) {
        return _buildDate(
          day: int.parse(match.group(1)!),
          month: _months[match.group(2)!.toLowerCase()],
          year: _fixYear(int.parse(match.group(3)!)),
          hour: int.parse(match.group(4)!),
          minute: int.parse(match.group(5)!),
          second: int.parse(match.group(6)!),
        );
      }

      final rfc850 = RegExp(
        r'^\w+,\s+(\d{1,2})-(\w{3})-(\d{2})\s+(\d{2}):(\d{2}):(\d{2})',
      );
      match = rfc850.firstMatch(trimmed);
      if (match != null) {
        return _buildDate(
          day: int.parse(match.group(1)!),
          month: _months[match.group(2)!.toLowerCase()],
          year: _fixYear(int.parse(match.group(3)!)),
          hour: int.parse(match.group(4)!),
          minute: int.parse(match.group(5)!),
          second: int.parse(match.group(6)!),
        );
      }

      final asctime = RegExp(
        r'^\w{3}\s+(\w{3})\s+(\d{1,2})\s+(\d{2}):(\d{2}):(\d{2})\s+(\d{4})',
      );
      match = asctime.firstMatch(trimmed);
      if (match != null) {
        return _buildDate(
          day: int.parse(match.group(2)!),
          month: _months[match.group(1)!.toLowerCase()],
          year: int.parse(match.group(6)!),
          hour: int.parse(match.group(3)!),
          minute: int.parse(match.group(4)!),
          second: int.parse(match.group(5)!),
        );
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static DateTime? _buildDate({
    required int day,
    required int? month,
    required int year,
    required int hour,
    required int minute,
    required int second,
  }) {
    if (month == null) return null;
    return DateTime(year, month, day, hour, minute, second);
  }

  static int _fixYear(int year) {
    if (year < 100) return 2000 + year;
    return year;
  }
}
