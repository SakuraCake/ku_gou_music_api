import 'package:test/test.dart';
import 'package:kugou_api/src/config/constants.dart';

void main() {
  group('WeChat constants', () {
    test('kWxAppid has expected value', () {
      expect(kWxAppid, equals('wx79f2c4418704b4f8'));
    });

    test('kWxSecret has expected value', () {
      expect(kWxSecret, equals('4efcab88b700769e376e3f6087b8abc9'));
    });

    test('kWxLiteAppid has expected value', () {
      expect(kWxLiteAppid, equals('wx72b795aca60ad321'));
    });

    test('kWxLiteSecret has expected value', () {
      expect(kWxLiteSecret, equals('33e486041e5e25729a4e3d2da7502f9a'));
    });
  });

  group('Salt constants', () {
    test('kAudioRelatedSalt has expected value', () {
      expect(kAudioRelatedSalt, equals('OIlwieks28dk2k092lksi2UIkp'));
    });

    test('kKtvSignSalt has expected value', () {
      expect(kKtvSignSalt, equals('*s&iN#G70*'));
    });
  });

  group('Standard platform constants', () {
    test('kStandardAppid has expected value', () {
      expect(kStandardAppid, equals(1005));
    });

    test('kStandardClientver has expected value', () {
      expect(kStandardClientver, equals(20489));
    });

    test('kStandardSignatureSalt is non-empty', () {
      expect(kStandardSignatureSalt, isNotEmpty);
    });

    test('kStandardSignKeySalt is non-empty', () {
      expect(kStandardSignKeySalt, isNotEmpty);
    });

    test('kStandardRsaPublicKey is non-empty base64', () {
      expect(kStandardRsaPublicKey, isNotEmpty);
      expect(RegExp(r'^[A-Za-z0-9+/]+=*$').hasMatch(kStandardRsaPublicKey), isTrue);
    });
  });

  group('Lite platform constants', () {
    test('kLiteAppid has expected value', () {
      expect(kLiteAppid, equals(3116));
    });

    test('kLiteClientver has expected value', () {
      expect(kLiteClientver, equals(11440));
    });

    test('kLiteSignatureSalt is non-empty', () {
      expect(kLiteSignatureSalt, isNotEmpty);
    });

    test('kLiteSignKeySalt is non-empty', () {
      expect(kLiteSignKeySalt, isNotEmpty);
    });

    test('kLiteRsaPublicKey is non-empty base64', () {
      expect(kLiteRsaPublicKey, isNotEmpty);
      expect(RegExp(r'^[A-Za-z0-9+/]+=*$').hasMatch(kLiteRsaPublicKey), isTrue);
    });
  });

  group('Other constants', () {
    test('kWebSignatureSalt is non-empty', () {
      expect(kWebSignatureSalt, isNotEmpty);
    });

    test('kRegisterSignatureSalt is non-empty', () {
      expect(kRegisterSignatureSalt, isNotEmpty);
    });

    test('kDefaultBaseUrl is valid URL', () {
      expect(kDefaultBaseUrl, equals('https://gateway.kugou.com'));
    });

    test('kSrcAppid has expected value', () {
      expect(kSrcAppid, equals(2919));
    });

    test('kDefaultUserAgent is non-empty', () {
      expect(kDefaultUserAgent, isNotEmpty);
    });
  });
}
