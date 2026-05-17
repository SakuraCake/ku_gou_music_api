import 'package:test/test.dart';
import 'package:kugou_api/src/crypto.dart';

void main() {
  group('cryptoMd5', () {
    test('hashes empty string', () {
      expect(cryptoMd5(''), equals('d41d8cd98f00b204e9800998ecf8427e'));
    });

    test('hashes normal string', () {
      expect(cryptoMd5('hello'), equals('5d41402abc4b2a76b9719d911017c592'));
    });

    test('hashes JSON object', () {
      final result = cryptoMd5({'key': 'value'});
      expect(result, isA<String>());
      expect(result.length, equals(32));
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(result), isTrue);
    });
  });

  group('cryptoAesEncrypt & cryptoAesDecrypt', () {
    test('encrypt and decrypt string round-trip', () {
      const original = 'Hello, KuGou!';
      final encrypted = cryptoAesEncrypt(original);
      final decrypted = cryptoAesDecrypt(encrypted['str']!, encrypted['key']!);
      expect(decrypted, equals(original));
    });

    test('encrypt and decrypt JSON round-trip', () {
      final original = {'name': 'test', 'value': 42};
      final encrypted = cryptoAesEncrypt(original);
      final decrypted = cryptoAesDecrypt(encrypted['str']!, encrypted['key']!);
      expect(decrypted, isA<Map>());
      expect((decrypted as Map)['name'], equals('test'));
      expect(decrypted['value'], equals(42));
    });

    test('encrypt with custom key and iv', () {
      const key = '0011223344556677';
      const iv = 'ffeeddccbbaa9988';
      const original = 'test data';
      final encrypted = cryptoAesEncrypt(original, key: key, iv: iv);
      expect(encrypted, isA<String>());
      final decrypted = cryptoAesDecrypt(encrypted as String, key, iv: iv);
      expect(decrypted, equals(original));
    });
  });

  group('signatureAndroidParams', () {
    test('produces 32-char hex string', () {
      final result = signatureAndroidParams({
        'appid': 1005,
        'clientver': 20489,
      });
      expect(result.length, equals(32));
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(result), isTrue);
    });

    test('is deterministic', () {
      final params = {'appid': 1005, 'clientver': 20489};
      expect(
        signatureAndroidParams(params),
        equals(signatureAndroidParams(params)),
      );
    });
  });

  group('signatureWebParams', () {
    test('produces 32-char hex string', () {
      final result = signatureWebParams({'key': 'value'});
      expect(result.length, equals(32));
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(result), isTrue);
    });

    test('is deterministic', () {
      final params = {'key': 'value'};
      expect(signatureWebParams(params), equals(signatureWebParams(params)));
    });
  });

  group('signKey', () {
    test('produces 32-char hex string', () {
      final result = signKey('abc123', 'mid456');
      expect(result.length, equals(32));
      expect(RegExp(r'^[0-9a-f]{32}$').hasMatch(result), isTrue);
    });

    test('is deterministic', () {
      expect(signKey('abc123', 'mid456'), equals(signKey('abc123', 'mid456')));
    });
  });

  group('decryptKrc', () {
    test('returns empty string for empty data', () {
      expect(decryptKrc([]), equals(''));
    });

    test('returns empty string for invalid header', () {
      expect(decryptKrc([0x00, 0x00, 0x00, 0x00]), equals(''));
    });
  });

  group('playlistAesEncrypt & playlistAesDecrypt', () {
    test('encrypt and decrypt string round-trip', () {
      const original = 'Hello, Playlist!';
      final encrypted = playlistAesEncrypt(original);
      final decrypted = playlistAesDecrypt(encrypted['str']!, encrypted['key']!);
      expect(decrypted, equals(original));
    });

    test('encrypt and decrypt JSON round-trip', () {
      final original = {'name': 'playlist', 'id': 42};
      final encrypted = playlistAesEncrypt(original);
      final decrypted = playlistAesDecrypt(encrypted['str']!, encrypted['key']!);
      expect(decrypted, isA<Map>());
      expect((decrypted as Map)['name'], equals('playlist'));
      expect(decrypted['id'], equals(42));
    });

    test('encrypt returns map with key and str', () {
      final encrypted = playlistAesEncrypt('test');
      expect(encrypted, isA<Map<String, String>>());
      expect(encrypted.containsKey('key'), isTrue);
      expect(encrypted.containsKey('str'), isTrue);
      expect(encrypted['key']!.length, equals(6));
    });

    test('encrypt str is base64 encoded', () {
      final encrypted = playlistAesEncrypt('test data');
      expect(RegExp(r'^[A-Za-z0-9+/]+=*$').hasMatch(encrypted['str']!), isTrue);
    });

    test('different calls produce different keys', () {
      final encrypted1 = playlistAesEncrypt('test');
      final encrypted2 = playlistAesEncrypt('test');
      expect(encrypted1['key'], isNot(equals(encrypted2['key'])));
    });
  });

  group('rsaEncrypt2', () {
    test('produces non-empty hex string', () {
      final result = rsaEncrypt2('test data');
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(result), isTrue);
    });

    test('produces different output for different input', () {
      final result1 = rsaEncrypt2('hello');
      final result2 = rsaEncrypt2('world');
      expect(result1, isNot(equals(result2)));
    });

    test('uses lite key when isLite is true', () {
      final standardResult = rsaEncrypt2('test');
      final liteResult = rsaEncrypt2('test', isLite: true);
      expect(standardResult, isNot(equals(liteResult)));
    });

    test('accepts JSON-serializable data', () {
      final result = rsaEncrypt2({'key': 'value'});
      expect(result, isA<String>());
      expect(result.isNotEmpty, isTrue);
    });
  });

  group('cryptoSha1', () {
    test('hashes empty string', () {
      expect(cryptoSha1(''), equals('da39a3ee5e6b4b0d3255bfef95601890afd80709'));
    });

    test('hashes normal string', () {
      expect(cryptoSha1('hello'), equals('aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d'));
    });

    test('produces 40-char hex string', () {
      final result = cryptoSha1('test data');
      expect(result.length, equals(40));
      expect(RegExp(r'^[0-9a-f]{40}$').hasMatch(result), isTrue);
    });

    test('is deterministic', () {
      expect(cryptoSha1('test'), equals(cryptoSha1('test')));
    });

    test('hashes JSON object', () {
      final result = cryptoSha1({'key': 'value'});
      expect(result, isA<String>());
      expect(result.length, equals(40));
      expect(RegExp(r'^[0-9a-f]{40}$').hasMatch(result), isTrue);
    });
  });
}
