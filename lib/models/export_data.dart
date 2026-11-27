import 'dart:convert';

import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/backup_settings.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';

/// Top-level wrapper for JSON import/export.
///
/// Every later app version must still read this format — never rename or
/// remove a field. [settings] and [activeSessions] are optional: backups
/// made before they existed have neither.
class ExportData {
  final int exportVersion;
  final int exportDate; // epoch ms
  final List<Counter> counters;
  final List<JapaSession> sessions;

  /// User settings. Null when the file has none (older backups).
  final BackupSettings? settings;

  /// Running counts (part-done malas) on the counting screen, one per
  /// counter at most. Saved paused. Empty when the file has none.
  final List<ActiveSession> activeSessions;

  const ExportData({
    this.exportVersion = 1,
    required this.exportDate,
    required this.counters,
    required this.sessions,
    this.settings,
    this.activeSessions = const [],
  });

  ExportData copyWith({
    BackupSettings? settings,
    List<ActiveSession>? activeSessions,
  }) => ExportData(
    exportVersion: exportVersion,
    exportDate: exportDate,
    counters: counters,
    sessions: sessions,
    settings: settings ?? this.settings,
    activeSessions: activeSessions ?? this.activeSessions,
  );

  Map<String, dynamic> toJson() => {
    'exportVersion': exportVersion,
    'exportDate': exportDate,
    'counters': counters.map((c) => c.toJson()).toList(),
    'sessions': sessions.map((s) => s.toJson()).toList(),
    if (settings != null) 'settings': settings!.toJson(),
    if (activeSessions.isNotEmpty)
      'activeSessions': activeSessions.map((a) => a.toMap()).toList(),
  };

  factory ExportData.fromJson(Map<String, dynamic> json) => ExportData(
    exportVersion: (json['exportVersion'] as num?)?.toInt() ?? 1,
    exportDate:
        (json['exportDate'] as num?)?.toInt() ??
        DateTime.now().millisecondsSinceEpoch,
    counters: (json['counters'] as List<dynamic>)
        .map((e) => Counter.fromJson(e as Map<String, dynamic>))
        .toList(),
    sessions: (json['sessions'] as List<dynamic>)
        .map((e) => JapaSession.fromJson(e as Map<String, dynamic>))
        .toList(),
    settings: json['settings'] == null
        ? null
        : BackupSettings.fromJson(json['settings'] as Map<String, dynamic>),
    activeSessions: ((json['activeSessions'] as List<dynamic>?) ?? const [])
        .map((e) => ActiveSession.fromMap(e as Map<String, dynamic>))
        .toList(),
  );

  String toJsonString() => jsonEncode(toJson());

  static ExportData fromJsonString(String source) =>
      ExportData.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
