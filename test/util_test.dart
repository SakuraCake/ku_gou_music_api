import 'dart:math';

import 'package:test/test.dart';
import 'package:kugou_api/src/util.dart';

void main() {
  group('Logger', () {
    test('各级别日志输出', () {
      final logs = <(LogLevel, String)>[];
      final logger = Logger(
        minLevel: LogLevel.debug,
        callback: (level, message) => logs.add((level, message)),
      );

      logger.debug('debug msg');
      logger.info('info msg');
      logger.warning('warning msg');
      logger.error('error msg');

      expect(logs.length, equals(4));
      expect(logs[0].$1, equals(LogLevel.debug));
      expect(logs[0].$2, equals('debug msg'));
      expect(logs[1].$1, equals(LogLevel.info));
      expect(logs[1].$2, equals('info msg'));
      expect(logs[2].$1, equals(LogLevel.warning));
      expect(logs[2].$2, equals('warning msg'));
      expect(logs[3].$1, equals(LogLevel.error));
      expect(logs[3].$2, equals('error msg'));
    });

    test('minLevel 过滤低级别日志', () {
      final logs = <(LogLevel, String)>[];
      final logger = Logger(
        minLevel: LogLevel.warning,
        callback: (level, message) => logs.add((level, message)),
      );

      logger.debug('debug msg');
      logger.info('info msg');
      logger.warning('warning msg');
      logger.error('error msg');

      expect(logs.length, equals(2));
      expect(logs[0].$1, equals(LogLevel.warning));
      expect(logs[1].$1, equals(LogLevel.error));
    });

    test('minLevel 为 none 时不过滤任何日志', () {
      final logs = <(LogLevel, String)>[];
      final logger = Logger(
        minLevel: LogLevel.none,
        callback: (level, message) => logs.add((level, message)),
      );

      logger.debug('msg');
      logger.info('msg');
      logger.warning('msg');
      logger.error('msg');

      expect(logs.length, equals(4));
    });

    test('无 callback 时不报错', () {
      final logger = Logger(minLevel: LogLevel.debug);
      expect(() => logger.debug('msg'), returnsNormally);
    });
  });

  group('withRetry', () {
    test('成功不重试', () async {
      var callCount = 0;
      final result = await withRetry(() async {
        callCount++;
        return 42;
      });
      expect(result, equals(42));
      expect(callCount, equals(1));
    });

    test('失败重试后成功', () async {
      var callCount = 0;
      final result = await withRetry(
        () async {
          callCount++;
          if (callCount < 3) throw Exception('fail');
          return 'ok';
        },
        options: const RetryOptions(
          maxAttempts: 3,
          baseDelay: Duration(milliseconds: 1),
        ),
      );
      expect(result, equals('ok'));
      expect(callCount, equals(3));
    });

    test('超过最大次数抛异常', () async {
      expect(
        () => withRetry(
          () async {
            throw Exception('always fail');
          },
          options: const RetryOptions(
            maxAttempts: 3,
            baseDelay: Duration(milliseconds: 1),
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('retryIf 返回 false 不重试', () async {
      expect(
        () => withRetry(
          () async {
            throw FormatException('no retry');
          },
          options: const RetryOptions(
            maxAttempts: 3,
            baseDelay: Duration(milliseconds: 1),
          ),
          retryIf: (e) => e is! FormatException,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('MemoryCache', () {
    test('set/get 基本操作', () {
      final cache = MemoryCache();
      cache.set('key1', 'value1', const Duration(minutes: 5));
      expect(cache.get<String>('key1'), equals('value1'));
      expect(cache.get<String>('nonexistent'), isNull);
    });

    test('TTL 过期返回 null', () async {
      final cache = MemoryCache();
      cache.set('key1', 'value1', const Duration(milliseconds: 50));
      expect(cache.get<String>('key1'), equals('value1'));
      await Future.delayed(const Duration(milliseconds: 60));
      expect(cache.get<String>('key1'), isNull);
    });

    test('remove 删除缓存', () {
      final cache = MemoryCache();
      cache.set('key1', 'value1', const Duration(minutes: 5));
      cache.remove('key1');
      expect(cache.get<String>('key1'), isNull);
    });

    test('clear 清空缓存', () {
      final cache = MemoryCache();
      cache.set('key1', 'value1', const Duration(minutes: 5));
      cache.set('key2', 'value2', const Duration(minutes: 5));
      cache.clear();
      expect(cache.get<String>('key1'), isNull);
      expect(cache.get<String>('key2'), isNull);
    });

    test('maxSize 淘汰策略', () {
      final cache = MemoryCache(maxSize: 2);
      cache.set('key1', 'value1', const Duration(minutes: 5));
      cache.set('key2', 'value2', const Duration(minutes: 5));
      cache.set('key3', 'value3', const Duration(minutes: 5));
      expect(cache.get<String>('key1'), isNull);
      expect(cache.get<String>('key2'), isNotNull);
      expect(cache.get<String>('key3'), isNotNull);
    });

    test('generateKey 生成一致的键', () {
      final cache = MemoryCache();
      final key1 = cache.generateKey('search', {'q': 'test', 'page': 1});
      final key2 = cache.generateKey('search', {'page': 1, 'q': 'test'});
      expect(key1, equals(key2));
    });
  });

  group('randomString', () {
    test('生成指定长度的字符串', () {
      final result = randomString(16);
      expect(result.length, equals(16));
    });

    test('字符范围正确', () {
      final validChars = RegExp(r'^[A-Za-z0-9]+$');
      final result = randomString(100);
      expect(validChars.hasMatch(result), isTrue);
    });

    test('长度为 0 返回空字符串', () {
      final result = randomString(0);
      expect(result, equals(''));
    });

    test('使用自定义 Random', () {
      final rng = Random(42);
      final result1 = randomString(8, random: rng);
      final rng2 = Random(42);
      final result2 = randomString(8, random: rng2);
      expect(result1, equals(result2));
    });
  });
}
