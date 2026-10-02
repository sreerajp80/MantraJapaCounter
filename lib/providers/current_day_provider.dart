import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Source of the current time. Overridden in tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Today's local date (time part dropped).
///
/// Providers that show "today" numbers watch this so they re-run when the
/// date changes. [CurrentDayNotifier.refresh] is called on app resume and
/// just after midnight (see `main.dart`).
class CurrentDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => _today();

  /// Updates the state only when the local date has really changed.
  void refresh() {
    final today = _today();
    if (today != state) state = today;
  }

  DateTime _today() {
    final now = ref.read(clockProvider)();
    return DateTime(now.year, now.month, now.day);
  }
}

final currentDayProvider = NotifierProvider<CurrentDayNotifier, DateTime>(
  CurrentDayNotifier.new,
);
