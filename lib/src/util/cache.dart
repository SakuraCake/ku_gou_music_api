import 'dart:collection';

/// 缓存条目，包含值和过期时间。
class CacheEntry<T> {
  /// 缓存的值。
  final T value;

  /// 过期时间。
  final DateTime expiresAt;

  /// 创建 [CacheEntry] 实例。
  CacheEntry(this.value, this.expiresAt);

  /// 是否已过期。
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// 基于内存的 LRU 缓存，支持 TTL 过期策略。
class MemoryCache {
  /// 缓存最大条目数。
  final int maxSize;

  final LinkedHashMap<String, CacheEntry<dynamic>> _cache = LinkedHashMap();

  /// 创建 [MemoryCache] 实例。
  ///
  /// [maxSize] 默认为 100，超出时淘汰最早或已过期的条目。
  MemoryCache({this.maxSize = 100});

  /// 获取缓存值。
  ///
  /// [key] 缓存键，已过期或不存在时返回 null。
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T;
  }

  /// 设置缓存值。
  ///
  /// [key] 缓存键，[value] 缓存值，[ttl] 存活时间。
  /// 缓存满时优先清除过期条目，仍满则淘汰最早的条目。
  void set<T>(String key, T value, Duration ttl) {
    if (_cache.length >= maxSize && !_cache.containsKey(key)) {
      _removeExpired();
      if (_cache.length >= maxSize) {
        _cache.remove(_cache.keys.first);
      }
    }
    _cache[key] = CacheEntry(value, DateTime.now().add(ttl));
  }

  /// 移除指定键的缓存条目。
  void remove(String key) {
    _cache.remove(key);
  }

  /// 清空所有缓存条目。
  void clear() {
    _cache.clear();
  }

  void _removeExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }

  /// 根据请求方法和参数生成缓存键。
  ///
  /// [method] 请求方法标识（如 `GET:/api/xxx`），
  /// [params] 请求参数，按键名排序后拼接。
  String generateKey(String method, Map<String, dynamic> params) {
    final sortedKeys = params.keys.toList()..sort();
    final paramsStr = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    return '$method:$paramsStr';
  }
}
