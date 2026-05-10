import 'package:test/test.dart';
import 'package:kugou_api/src/util/cookie_jar.dart';

void main() {
  group('CookieJar', () {
    test('初始为空', () {
      final jar = CookieJar();
      expect(jar.isEmpty, isTrue);
      expect(jar.length, equals(0));
    });

    test('通过 initialCookies 初始化', () {
      final jar = CookieJar(initialCookies: {
        'kugou.com': 'token=abc; userid=123',
      });
      expect(jar.length, equals(2));
      final cookies = jar.getCookiesForUrl('https://kugou.com/api');
      expect(cookies, contains('token=abc'));
      expect(cookies, contains('userid=123'));
    });

    test('set 和 getCookiesForUrl', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc123');
      jar.set(domain: 'kugou.com', name: 'userid', value: '42');

      final cookies = jar.getCookiesForUrl('https://kugou.com/api');
      expect(cookies, contains('token=abc123'));
      expect(cookies, contains('userid=42'));
    });

    test('域名后缀匹配', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');

      expect(
        jar.getCookiesForUrl('https://www.kugou.com/api'),
        contains('token=abc'),
      );
      expect(
        jar.getCookiesForUrl('https://api.kugou.com/v1'),
        contains('token=abc'),
      );
    });

    test('不同域名不匹配', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');

      expect(jar.getCookiesForUrl('https://example.com/api'), isEmpty);
    });

    test('setFromHeader 解析 Set-Cookie', () {
      final jar = CookieJar();
      jar.setFromHeader(
        'https://kugou.com/login',
        'token=xyz; Domain=.kugou.com; Path=/; Max-Age=3600',
      );

      final cookies = jar.getCookiesForUrl('https://kugou.com/api');
      expect(cookies, contains('token=xyz'));
    });

    test('过期 Cookie 自动清除', () {
      final jar = CookieJar();
      jar.set(
        domain: 'kugou.com',
        name: 'token',
        value: 'expired',
        expiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );
      jar.set(
        domain: 'kugou.com',
        name: 'fresh',
        value: 'ok',
      );

      final cookies = jar.getCookiesForUrl('https://kugou.com/api');
      expect(cookies, isNot(contains('token=expired')));
      expect(cookies, contains('fresh=ok'));
    });

    test('secure Cookie 仅匹配 HTTPS', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'secure_token', value: 'abc', secure: true);

      expect(jar.getCookiesForUrl('https://kugou.com/api'), contains('secure_token=abc'));
      expect(jar.getCookiesForUrl('http://kugou.com/api'), isEmpty);
    });

    test('getAllForDomain', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');
      jar.set(domain: 'kugou.com', name: 'userid', value: '1');
      jar.set(domain: 'example.com', name: 'token', value: 'xyz');

      final kugouCookies = jar.getAllForDomain('kugou.com');
      expect(kugouCookies, equals({'token': 'abc', 'userid': '1'}));
    });

    test('getAll 按域名分组', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');
      jar.set(domain: 'example.com', name: 'session', value: 'xyz');

      final all = jar.getAll();
      expect(all.containsKey('kugou.com'), isTrue);
      expect(all.containsKey('example.com'), isTrue);
    });

    test('remove 移除指定 Cookie', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');
      jar.set(domain: 'kugou.com', name: 'userid', value: '1');

      jar.remove('kugou.com', 'token');
      expect(jar.length, equals(1));
      expect(jar.getCookiesForUrl('https://kugou.com/api'), isNot(contains('token=abc')));
    });

    test('removeForDomain 移除域名下所有 Cookie', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');
      jar.set(domain: 'kugou.com', name: 'userid', value: '1');
      jar.set(domain: 'example.com', name: 'session', value: 'xyz');

      jar.removeForDomain('kugou.com');
      expect(jar.length, equals(1));
    });

    test('clear 清空所有 Cookie', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');
      jar.clear();
      expect(jar.isEmpty, isTrue);
    });

    test('serialize 和 loadFromMap 持久化', () {
      final jar = CookieJar();
      jar.set(domain: 'kugou.com', name: 'token', value: 'abc');
      jar.set(domain: 'kugou.com', name: 'userid', value: '42');

      final serialized = jar.serialize();
      expect(serialized.length, equals(2));

      final jar2 = CookieJar();
      jar2.loadFromMap(serialized);
      expect(jar2.length, equals(2));

      final cookies = jar2.getCookiesForUrl('https://kugou.com/api');
      expect(cookies, contains('token=abc'));
      expect(cookies, contains('userid=42'));
    });

    test('Max-Age=0 立即过期', () {
      final jar = CookieJar();
      jar.setFromHeader(
        'https://kugou.com/login',
        'token=deleted; Max-Age=0',
      );
      final cookies = jar.getCookiesForUrl('https://kugou.com/api');
      expect(cookies, isNot(contains('token=deleted')));
    });
  });

  group('HttpDateParser', () {
    test('RFC 1123 格式', () {
      final dt = HttpDateParser.tryParse('Sun, 06 Nov 1994 08:49:37 GMT');
      expect(dt, isNotNull);
      expect(dt!.year, equals(1994));
      expect(dt.month, equals(11));
      expect(dt.day, equals(6));
      expect(dt.hour, equals(8));
      expect(dt.minute, equals(49));
      expect(dt.second, equals(37));
    });

    test('RFC 850 格式', () {
      final dt = HttpDateParser.tryParse('Sunday, 06-Nov-94 08:49:37 GMT');
      expect(dt, isNotNull);
      expect(dt!.year, equals(2094));
      expect(dt.month, equals(11));
      expect(dt.day, equals(6));
    });

    test('asctime 格式', () {
      final dt = HttpDateParser.tryParse('Sun Nov  6 08:49:37 1994');
      expect(dt, isNotNull);
      expect(dt!.year, equals(1994));
      expect(dt.month, equals(11));
    });

    test('无效格式返回 null', () {
      expect(HttpDateParser.tryParse('not a date'), isNull);
      expect(HttpDateParser.tryParse(''), isNull);
    });
  });
}
