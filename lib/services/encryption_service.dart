import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Optional AES-256-GCM encryption for JSON export files.
///
/// Uses PBKDF2 (100,000 iterations, SHA-256) for key derivation from a
/// user-chosen passphrase. The encrypted output is a JSON envelope containing
/// the salt, IV, and ciphertext — all Base64-encoded.
///
/// Pure Dart — no Flutter, no network, no platform channels.
class EncryptionService {
  static const int _pbkdf2Iterations = 100000;
  static const int _saltLength = 16;
  static const int _ivLength = 12;
  static const int _keyLength = 32; // 256 bits
  static const int _envelopeVersion = 1;
  static const int _minPassphraseLength = 6;

  /// Minimum passphrase length enforced by the service.
  static int get minPassphraseLength => _minPassphraseLength;

  /// Encrypts [plaintext] with AES-256-GCM using a key derived from
  /// [passphrase] via PBKDF2.
  ///
  /// Returns a JSON envelope string:
  /// ```json
  /// {
  ///   "encrypted": true,
  ///   "version": 1,
  ///   "salt": "<base64>",
  ///   "iv": "<base64>",
  ///   "ciphertext": "<base64>"
  /// }
  /// ```
  Future<String> encrypt(String plaintext, String passphrase) async {
    if (passphrase.length < _minPassphraseLength) {
      throw ArgumentError(
        'Passphrase must be at least $_minPassphraseLength characters',
      );
    }

    final algorithm = AesGcm.with256bits();
    final secureRandom = Random.secure();

    // Generate random salt and IV
    final salt = Uint8List(_saltLength);
    final iv = Uint8List(_ivLength);
    for (int i = 0; i < _saltLength; i++) {
      salt[i] = secureRandom.nextInt(256);
    }
    for (int i = 0; i < _ivLength; i++) {
      iv[i] = secureRandom.nextInt(256);
    }

    // Derive key from passphrase using PBKDF2
    final secretKey = await _deriveKey(passphrase, salt);

    // Encrypt
    final plaintextBytes = utf8.encode(plaintext);
    final secretBox = await algorithm.encrypt(
      plaintextBytes,
      secretKey: secretKey,
      nonce: iv,
    );

    // Combine ciphertext and MAC tag for storage
    final ciphertextWithMac = Uint8List.fromList([
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);

    final envelope = {
      'encrypted': true,
      'version': _envelopeVersion,
      'salt': base64Encode(salt),
      'iv': base64Encode(iv),
      'ciphertext': base64Encode(ciphertextWithMac),
    };

    return jsonEncode(envelope);
  }

  /// Decrypts an encrypted envelope JSON string using [passphrase].
  ///
  /// Throws [ArgumentError] if the envelope is malformed.
  /// Throws an exception if the passphrase is wrong or the data is corrupted.
  Future<String> decrypt(String envelopeJson, String passphrase) async {
    final dynamic decoded;
    try {
      decoded = jsonDecode(envelopeJson);
    } catch (_) {
      throw ArgumentError('Encrypted envelope is not valid JSON');
    }

    if (decoded is! Map<String, dynamic> || decoded['encrypted'] != true) {
      throw ArgumentError('Content is not an encrypted envelope');
    }

    final version = decoded['version'] as int? ?? 1;
    if (version > _envelopeVersion) {
      throw ArgumentError(
        'Encrypted envelope version $version is not supported',
      );
    }

    final salt = base64Decode(decoded['salt'] as String);
    final iv = base64Decode(decoded['iv'] as String);
    final ciphertextWithMac = base64Decode(decoded['ciphertext'] as String);

    if (ciphertextWithMac.length < 16) {
      throw ArgumentError('Ciphertext is too short');
    }

    // Split ciphertext and MAC (last 16 bytes are the GCM authentication tag)
    final ciphertext = ciphertextWithMac.sublist(
      0,
      ciphertextWithMac.length - 16,
    );
    final mac = Mac(ciphertextWithMac.sublist(ciphertextWithMac.length - 16));

    // Derive key from passphrase using the stored salt
    final secretKey = await _deriveKey(passphrase, Uint8List.fromList(salt));

    // Decrypt
    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(ciphertext, nonce: iv, mac: mac);
    final plaintextBytes = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(plaintextBytes);
  }

  /// Returns true if [content] looks like an encrypted envelope
  /// (JSON object with `"encrypted": true`).
  bool isEncrypted(String content) {
    try {
      final decoded = jsonDecode(content);
      return decoded is Map<String, dynamic> && decoded['encrypted'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Derives a 256-bit AES key from [passphrase] and [salt] using PBKDF2
  /// with HMAC-SHA256.
  Future<SecretKey> _deriveKey(String passphrase, Uint8List salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _pbkdf2Iterations,
      bits: _keyLength * 8,
    );

    return pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(passphrase)),
      nonce: salt,
    );
  }
}
