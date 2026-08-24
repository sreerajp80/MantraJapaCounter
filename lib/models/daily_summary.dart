import 'japa_session.dart';

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
}
