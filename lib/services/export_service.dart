import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show SharePlus, ShareParams, XFile;
import '../config/locale_config.dart';
import '../models/export_data.dart';
import '../repositories/japa_counter_repository.dart';

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

/// JSON import / export for data backup and restore.
///
/// Export format is byte-compatible with the Android app's Gson export.
class ExportService {
  final JapaCounterRepository _repo;

  ExportService(this._repo);

  /// Exports all data to a JSON file and opens the share sheet.
  Future<void> exportAndShare() async {
    final data = await _repo.exportData();
    final json = data.toJsonString();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mantra_japa_counter_backup.json');
    await file.writeAsString(json, encoding: utf8);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: LocaleConfig.strings().backupShareSubject,
      ),
    );
  }

  /// Parses and validates JSON, then imports into the database.
  ///
  /// Throws [ImportParseException] if the JSON is malformed.
  /// Throws [ValidationException] if the structure is invalid.
  /// Never corrupts the existing database on failure — uses a transaction.
  Future<void> importFromJson(String jsonString) async {
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

    await _repo.importData(data);
  }
}
