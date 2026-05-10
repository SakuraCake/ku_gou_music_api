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
      const key = '00112233445566778899aabbccddeeff';
      const iv = 'ffeeddccbbaa99887766554433221100';
      const original = 'test data';
      final encrypted = cryptoAesEncrypt(original, key: key, iv: iv);
      expect(encrypted['key'], equals(key));
      final decrypted = cryptoAesDecrypt(encrypted['str']!, key, iv: iv);
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
}
