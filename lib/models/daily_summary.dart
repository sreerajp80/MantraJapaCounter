import 'package:mantra_japa_counter/models/japa_session.dart';

/// Aggregated view of all sessions on a single calendar day.
///
/// Computed at read time — not stored in the database.
class DailySummary {
  final String date; // Formatted: "Jan 23, 2025"
  final int totalCount;
  final int totalDuration; // ms
  final List<JapaSession> sessions;

  const DailySummary({
    required this.date,
    required this.totalCount,
    required this.totalDuration,
    required this.sessions,
  });

  /// The calendar day (local time, midnight) these sessions belong to.
  /// All sessions in a summary share the same day, so the first one is used.
  /// Null only for an empty summary, which the repository never builds.
  DateTime? get day {
    if (sessions.isEmpty) return null;
    final dt = DateTime.fromMillisecondsSinceEpoch(sessions.first.timestamp);
    return DateTime(dt.year, dt.month, dt.day);
  }
}
