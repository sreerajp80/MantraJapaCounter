import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams, XFile;
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
  @override
  String toString() => 'ValidationException: $message';
}

class ImportParseException implements Exception {
  final String message;
  const ImportParseException(this.message);
  @override
  String toString() => 'ImportParseException: $message';
}

/// Thrown when an import file is detected as encrypted and needs a passphrase.
class EncryptedExportException implements Exception {
  final String content;
  const EncryptedExportException(this.content);
  @override
  String toString() => 'EncryptedExportException: File is encrypted';
}

/// JSON import / export for data backup and restore.
///
/// Export format is byte-compatible with the Android app's Gson export.
class ExportService {
  final JapaCounterRepository _repo;
  final EncryptionService _encryption;

  ExportService(this._repo, this._encryption);

  // ──────────────────────────── Full Export ──────────────────────────────────

  /// Exports all data to a JSON file and opens the share sheet.
  ///
  /// If [passphrase] is provided, the JSON is encrypted with AES-256-GCM
  /// before writing. The file extension is `.json.enc` for encrypted files.
  Future<void> exportAndShare({String? passphrase}) async {
    final data = await _repo.exportData();
    final json = data.toJsonString();

    final dir = await getApplicationDocumentsDirectory();

    String content;
    String filename;
    if (passphrase != null && passphrase.isNotEmpty) {
      content = await _encryption.encrypt(json, passphrase);
      filename = 'mantra_japa_counter_backup.json.enc';
    } else {
      content = json;
      filename = 'mantra_japa_counter_backup.json';
    }

    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: LocaleConfig.strings().backupShareSubject,
      ),
    );
  }

  // ──────────────────────────── Selective Export ─────────────────────────────

  /// Exports only the selected counters to a JSON file and shares it.
  ///
  /// If [passphrase] is provided, the output is encrypted.
  Future<void> exportSelectedAndShare(
    List<String> counterIds, {
    String? passphrase,
  }) async {
    final data = await _repo.exportSelectedData(counterIds);
    final json = data.toJsonString();

    final dir = await getApplicationDocumentsDirectory();

    String content;
    String filename;
    if (passphrase != null && passphrase.isNotEmpty) {
      content = await _encryption.encrypt(json, passphrase);
      filename = 'mantra_japa_counter_backup.json.enc';
    } else {
      content = json;
      filename = 'mantra_japa_counter_backup.json';
    }

    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: LocaleConfig.strings().backupShareSubject,
      ),
    );
  }

  // ──────────────────────────── Full Import ──────────────────────────────────

  /// Parses and validates JSON, then imports into the database.
  ///
  /// Throws [ImportParseException] if the JSON is malformed.
  /// Throws [ValidationException] if the structure is invalid.
  /// Throws [EncryptedExportException] if the file is encrypted.
  /// Never corrupts the existing database on failure — uses a transaction.
  Future<void> importFromJson(String jsonString) async {
    // Check if content is encrypted
    if (_encryption.isEncrypted(jsonString)) {
      throw EncryptedExportException(jsonString);
    }

    final data = _parseAndValidate(jsonString);
    await _repo.importData(data);
  }

  /// Decrypts an encrypted export file, then imports all data.
  Future<void> importEncryptedFromJson(
    String encryptedContent,
    String passphrase,
  ) async {
    final json = await _encryption.decrypt(encryptedContent, passphrase);
    final data = _parseAndValidate(json);
    await _repo.importData(data);
  }

  // ──────────────────────────── Selective Import ─────────────────────────────

  /// Parses JSON and imports only the selected counters (by ID) and their
  /// sessions. Uses merge strategy — existing data is not deleted.
  ///
  /// Throws [EncryptedExportException] if the file is encrypted.
  Future<void> importSelectedFromJson(
    String jsonString,
    List<String> counterIds,
  ) async {
    if (_encryption.isEncrypted(jsonString)) {
      throw EncryptedExportException(jsonString);
    }

    final data = _parseAndValidate(jsonString);
    await _repo.importSelectedData(data, counterIds);
  }

  /// Decrypts, then imports only the selected counters.
  Future<void> importSelectedEncryptedFromJson(
    String encryptedContent,
    String passphrase,
    List<String> counterIds,
  ) async {
    final json = await _encryption.decrypt(encryptedContent, passphrase);
    final data = _parseAndValidate(json);
    await _repo.importSelectedData(data, counterIds);
  }

  // ──────────────────────────── Parsing helpers ─────────────────────────────

  /// Parses an ExportData from a plain JSON string. Returns the parsed data.
  ExportData parseExportData(String jsonString) => _parseAndValidate(jsonString);

  ExportData _parseAndValidate(String jsonString) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (_) {
      throw const ImportParseException('JSON is malformed');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const ValidationException('Top-level JSON value must be an object');
    }

    if (!decoded.containsKey('counters') || !decoded.containsKey('sessions')) {
      throw const ValidationException(
        'Missing required fields: counters, sessions',
      );
    }

    try {
      return ExportData.fromJson(decoded);
    } catch (e) {
      throw ValidationException('Schema validation failed: $e');
    }
  }
}
