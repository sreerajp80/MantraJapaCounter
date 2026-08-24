import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_summary.dart';
import 'app_providers.dart';

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
