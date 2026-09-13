import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';

void main() {
  late EncryptionService service;

  setUp(() {
    service = EncryptionService();
  });

  group('EncryptionService', () {
    test('encrypt and decrypt round trip succeeds with correct passphrase', () async {
      const plaintext = '{"counters":[{"id":"c1","name":"Om Namah Shivaya"}],"sessions":[]}';
      const passphrase = 'sacredPassphrase108';

      final encrypted = await service.encrypt(plaintext, passphrase);

      expect(service.isEncrypted(encrypted), isTrue);

      final envelope = jsonDecode(encrypted) as Map<String, dynamic>;
      expect(envelope['encrypted'], isTrue);
      expect(envelope['version'], equals(1));
      expect(envelope['salt'], isNotEmpty);
      expect(envelope['iv'], isNotEmpty);
      expect(envelope['ciphertext'], isNotEmpty);

      final decrypted = await service.decrypt(encrypted, passphrase);
      expect(decrypted, equals(plaintext));
    });

    test('throws ArgumentError when passphrase is under 6 characters', () async {
      expect(
        () => service.encrypt('payload', 'short'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('decrypt fails with wrong passphrase', () async {
      const plaintext = 'topSecretMantraNotes';
      final encrypted = await service.encrypt(plaintext, 'correctPassword123');

      expect(
        () => service.decrypt(encrypted, 'wrongPassword123'),
        throwsA(anything),
      );
    });

    test('isEncrypted identifies envelopes correctly', () {
      expect(service.isEncrypted('{"encrypted":true,"salt":"abc"}'), isTrue);
      expect(service.isEncrypted('{"counters":[]}'), isFalse);
      expect(service.isEncrypted('not a json string'), isFalse);
      expect(service.isEncrypted('{"encrypted":false}'), isFalse);
    });

    test('decrypt throws ArgumentError on malformed envelopes', () async {
      expect(
        () => service.decrypt('not json', 'passphrase123'),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => service.decrypt('{"encrypted":false}', 'passphrase123'),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => service.decrypt('{"encrypted":true,"version":999}', 'passphrase123'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
