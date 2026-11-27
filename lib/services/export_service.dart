import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams, XFile;
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
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

/// Thrown when a picked import file is larger than any real backup
/// ([AppConstants.maxBackupImportBytes]). The file is not read.
class BackupTooLargeException implements Exception {
  final int sizeBytes;
  const BackupTooLargeException(this.sizeBytes);
  @override
  String toString() => 'BackupTooLargeException: $sizeBytes bytes';
}

/// JSON import / export for data backup and restore.
///
/// Backups from any earlier app version must always import.
///
/// Every export also holds the user settings and the running counts
/// (part-done malas) of the exported counters. Only a full import applies
/// the settings; a selected import keeps the phone's own settings.
class ExportService {
  final JapaCounterRepository _repo;
  final EncryptionService _encryption;
  final SettingsRepository _settings;

  ExportService(this._repo, this._encryption, this._settings);

  // ──────────────────────────── Building the export ──────────────────────────

  /// Builds the data for a backup: counters and sessions from the database,
  /// plus the settings and running counts.
  ///
  /// When [counterIds] is null or empty, all counters are exported.
  /// Running counts are saved paused, with their active time up to now, so
  /// the gap until the next import is not counted as chanting time.
  Future<ExportData> buildExportData({List<String>? counterIds}) async {
    final base = (counterIds == null || counterIds.isEmpty)
        ? await _repo.exportData()
        : await _repo.exportSelectedData(counterIds);
    final exportedIds = {for (final c in base.counters) c.id};

    final active = <ActiveSession>[];
    for (final s in _settings.getAllActiveSessions()) {
      if (!exportedIds.contains(s.counterId)) continue;
      if (s.tapCount <= 0 || s.sessionId.isEmpty) continue;
      active.add(
        s.isPaused ? s : s.copyWith(isPaused: true, accumulatedMs: s.duration),
      );
    }

    return base.copyWith(
      settings: _settings.exportSettings(),
      activeSessions: active,
    );
  }

  /// Writes the parts of a full import that live outside the database.
  /// Old running counts are always cleared, even when the file has none,
  /// because the database sessions they point at were just replaced.
  Future<void> _applyFullImportExtras(ExportData data) async {
    await _settings.replaceActiveSessions(data.activeSessions);
    final settings = data.settings;
    if (settings != null) await _settings.importSettings(settings);
  }

  /// Writes the running counts of the chosen counters. Settings are not
  /// touched on a selected import.
  Future<void> _applySelectedImportExtras(
    ExportData data,
    List<String> counterIds,
  ) async {
    if (counterIds.isEmpty) return;
    await _settings.replaceActiveSessions(
      data.activeSessions,
      counterIds: counterIds.toSet(),
    );
  }

  // ──────────────────────────── Full Export ──────────────────────────────────

  /// Exports all data to a JSON file and opens the share sheet.
  ///
  /// If [passphrase] is provided, the JSON is encrypted with AES-256-GCM
  /// before writing. The file extension is `.json.enc` for encrypted files.
  Future<void> exportAndShare({String? passphrase}) async {
    final data = await buildExportData();
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
    final data = await buildExportData(counterIds: counterIds);
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

  /// Reads a picked backup file as text. Checks the size first, so a huge
  /// file is never loaded into memory (engineering standard §15.1).
  ///
  /// Throws [BackupTooLargeException] if the file is too large.
  Future<String> readBackupFile(
    String path, {
    int maxBytes = AppConstants.maxBackupImportBytes,
  }) async {
    final file = File(path);
    final size = await file.length();
    if (size > maxBytes) throw BackupTooLargeException(size);
    return file.readAsString();
  }

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
    await _applyFullImportExtras(data);
  }

  /// Decrypts an encrypted export file, then imports all data.
  Future<void> importEncryptedFromJson(
    String encryptedContent,
    String passphrase,
  ) async {
    final json = await _encryption.decrypt(encryptedContent, passphrase);
    final data = _parseAndValidate(json);
    await _repo.importData(data);
    await _applyFullImportExtras(data);
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
    await _applySelectedImportExtras(data, counterIds);
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
    await _applySelectedImportExtras(data, counterIds);
  }

  // ──────────────────────────── Parsing helpers ─────────────────────────────

  /// Parses an ExportData from a plain JSON string. Returns the parsed data.
  ExportData parseExportData(String jsonString) =>
      _parseAndValidate(jsonString);

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

    final ExportData data;
    try {
      data = ExportData.fromJson(decoded);
    } catch (e) {
      throw ValidationException('Schema validation failed: $e');
    }

    _validateValues(data);
    return data;
  }

  /// Rejects values that parse fine but make no sense, so a bad file is
  /// refused as a whole before anything is written.
  void _validateValues(ExportData data) {
    if (data.exportVersion > AppConstants.exportFormatVersion) {
      throw ValidationException(
        'Export version ${data.exportVersion} is newer than this app supports '
        '(${AppConstants.exportFormatVersion})',
      );
    }

    final counterIds = <String>{};
    for (final c in data.counters) {
      if (c.id.isEmpty) {
        throw const ValidationException('A counter has an empty id');
      }
      if (!counterIds.add(c.id)) {
        throw ValidationException('Duplicate counter id: ${c.id}');
      }
      if (c.name.trim().isEmpty) {
        throw ValidationException('Counter ${c.id} has an empty name');
      }
      if (c.incrementStep < 1) {
        throw ValidationException(
          'Counter ${c.id} has an increment step below 1',
        );
      }
      if (c.initialCount < 0 ||
          c.goal < 0 ||
          c.dailyGoal < 0 ||
          c.malaSize < 0) {
        throw ValidationException('Counter ${c.id} has a negative value');
      }
    }

    for (final s in data.sessions) {
      if (!counterIds.contains(s.counterId)) {
        throw ValidationException(
          'Session ${s.id} belongs to a counter not in the file',
        );
      }
      if (s.count < 0 || s.duration < 0) {
        throw ValidationException('Session ${s.id} has a negative value');
      }
    }

    final activeCounterIds = <String>{};
    for (final a in data.activeSessions) {
      if (!counterIds.contains(a.counterId)) {
        throw const ValidationException(
          'A running count belongs to a counter not in the file',
        );
      }
      if (!activeCounterIds.add(a.counterId)) {
        throw ValidationException(
          'Counter ${a.counterId} has more than one running count',
        );
      }
      if (a.sessionId.isEmpty) {
        throw const ValidationException('A running count has an empty id');
      }
      if (a.incrementStep < 1) {
        throw ValidationException(
          'Running count ${a.sessionId} has an increment step below 1',
        );
      }
      if (a.startTime < 0 ||
          a.tapCount < 0 ||
          a.accumulatedMs < 0 ||
          a.lastResumeTimeMs < 0 ||
          a.carriedCount < 0 ||
          a.carriedCount > a.tapCount ||
          a.carriedDurationMs < 0 ||
          a.malaSize < 0) {
        throw ValidationException(
          'Running count ${a.sessionId} has a bad value',
        );
      }
    }

    final language = data.settings?.languageCode;
    if (language != null &&
        language.isNotEmpty &&
        !LocaleConfig.supportedLocales.any((l) => l.languageCode == language)) {
      throw const ValidationException('Settings have an unknown language');
    }
  }
}
