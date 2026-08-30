import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/counter.dart';
import '../models/counter_status.dart';
import 'app_providers.dart';

/// Async list of all counters, sorted: active first, then by createdAt DESC.
final countersProvider = FutureProvider<List<Counter>>((ref) async {
  final repo = ref.watch(japaCounterRepositoryProvider);
  final all = await repo.getAllCounters();
  return all..sort((a, b) {
    if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
    return b.createdAt.compareTo(a.createdAt);
  });
});

/// Notifier for counter CRUD operations.
class CountersNotifier extends AsyncNotifier<List<Counter>> {
  @override
  Future<List<Counter>> build() async {
    final repo = ref.watch(japaCounterRepositoryProvider);
    final all = await repo.getAllCounters();
    return all..sort((a, b) {
      if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  Future<void> addCounter({
    required String name,
    required int startDate,
    int initialCount = 0,
    int incrementStep = 1,
    int goal = 0,
    int dailyGoal = 0,
  }) async {
    final repo = ref.read(japaCounterRepositoryProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final counter = Counter(
      id: _newId(),
      name: name,
      initialCount: initialCount,
      incrementStep: incrementStep,
      goal: goal,
      dailyGoal: dailyGoal,
      startDate: startDate,
      createdAt: now,
    );
    await repo.insertCounter(counter);
    ref.invalidateSelf();
  }

  Future<void> updateCounter(Counter updated) async {
    final repo = ref.read(japaCounterRepositoryProvider);
    await repo.updateCounter(updated);
    ref.invalidateSelf();
  }

  Future<void> deleteCounter(String id) async {
    final repo = ref.read(japaCounterRepositoryProvider);
    await repo.deleteCounter(id);
    ref.invalidateSelf();
  }

  Future<void> disableCounter(
    String id,
    CounterStatus status,
    String? reason,
  ) async {
    final repo = ref.read(japaCounterRepositoryProvider);
    final counter = await repo.getCounterById(id);
    if (counter == null) return;
    final updated = counter.copyWith(
      status: status,
      disabledAt: DateTime.now().millisecondsSinceEpoch,
      disabledReason: reason,
    );
    await repo.updateCounter(updated);
    ref.invalidateSelf();
  }

  Future<void> toggleLock(String id) async {
    final repo = ref.read(japaCounterRepositoryProvider);
    final counter = await repo.getCounterById(id);
    if (counter == null) return;
    final updated = counter.copyWith(isLocked: !counter.isLocked);
    await repo.updateCounter(updated);
    ref.invalidateSelf();
  }

  String _newId() {
    final r = DateTime.now().microsecondsSinceEpoch;
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.splitMapJoin(
      RegExp(r'[xy]'),
      onMatch: (m) {
        final c = m.group(0)!;
        final v = (r ^ (r >> 16)) & 0xf;
        return (c == 'x' ? v : (v & 0x3 | 0x8)).toRadixString(16);
      },
      onNonMatch: (s) => s,
    );
  }
}

final countersNotifierProvider =
    AsyncNotifierProvider<CountersNotifier, List<Counter>>(
      CountersNotifier.new,
    );
