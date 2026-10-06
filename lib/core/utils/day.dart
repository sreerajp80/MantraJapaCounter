/// True when [ms] falls on an earlier local calendar day than [nowMs].
///
/// Both values are epoch milliseconds. Uses the device's local time zone,
/// the same way the "today" totals are worked out.
bool isEarlierLocalDay(int ms, int nowMs) {
  final a = DateTime.fromMillisecondsSinceEpoch(ms);
  final b = DateTime.fromMillisecondsSinceEpoch(nowMs);
  return DateTime(
    a.year,
    a.month,
    a.day,
  ).isBefore(DateTime(b.year, b.month, b.day));
}
