import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';

/// Daily summaries for the history screen, optionally filtered to one counter.
///
/// `autoDispose` so the provider re-fetches from the DB every time the
/// history screen is mounted (matches Kotlin behaviour where the session
/// list is collected as a Flow and reflects the latest DB state on entry).
final historySummariesProvider = FutureProvider.autoDispose
    .family<List<DailySummary>, String?>((ref, counterId) async {
      final repo = ref.watch(japaCounterRepositoryProvider);
      return repo.getDailySummaries(counterId: counterId);
    });

/// History actions that change data. Screens call these instead of the
/// repository.
class HistoryActions {
  final Ref _ref;

  HistoryActions(this._ref);

  /// Deletes the session history for one counter, or for all counters when
  /// [counterId] is null. Saved (paused) sessions are cleared as well, so
  /// startup recovery cannot bring the deleted sessions back.
  Future<void> clearHistory({String? counterId}) async {
    final repo = _ref.read(japaCounterRepositoryProvider);
    final settings = _ref.read(settingsRepositoryProvider);
    if (counterId == null) {
      await repo.deleteAllSessions();
      await settings.clearAllActiveSessions();
    } else {
      await repo.deleteSessionsByCounterId(counterId);
      await settings.clearActiveSession(counterId);
    }
    _ref.invalidate(historySummariesProvider(counterId));
  }
}

final historyActionsProvider = Provider<HistoryActions>(
  (ref) => HistoryActions(ref),
);
