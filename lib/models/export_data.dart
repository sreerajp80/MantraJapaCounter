import 'dart:convert';
import 'counter.dart';
import 'japa_session.dart';

/// Top-level wrapper for JSON import/export.
///
/// Must be byte-compatible with the Android app's Gson export format.
class ExportData {
  final int exportVersion;
  final int exportDate; // epoch ms
  final List<Counter> counters;
  final List<JapaSession> sessions;

  const ExportData({
    this.exportVersion = 1,
    required this.exportDate,
    required this.counters,
    required this.sessions,
  });

  Map<String, dynamic> toJson() => {
    'exportVersion': exportVersion,
    'exportDate': exportDate,
    'counters': counters.map((c) => c.toJson()).toList(),
    'sessions': sessions.map((s) => s.toJson()).toList(),
  };

  factory ExportData.fromJson(Map<String, dynamic> json) => ExportData(
    exportVersion: (json['exportVersion'] as num?)?.toInt() ?? 1,
    exportDate: (json['exportDate'] as num?)?.toInt() ??
        DateTime.now().millisecondsSinceEpoch,
    counters: (json['counters'] as List<dynamic>)
        .map((e) => Counter.fromJson(e as Map<String, dynamic>))
        .toList(),
    sessions: (json['sessions'] as List<dynamic>)
        .map((e) => JapaSession.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  String toJsonString() => jsonEncode(toJson());

  static ExportData fromJsonString(String source) =>
      ExportData.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
