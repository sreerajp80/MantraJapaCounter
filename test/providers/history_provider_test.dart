import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/daily_summary.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/history_provider.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';

void main() {
  late Directory tempDir;
  late Database db;
  late SharedPreferences prefs;
  late ProviderContainer container;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('japa_history_test');
    db = await databaseFactory.openDatabase(
      '${tempDir.path}/japa.db',
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: JapaCounterRepository.onCreate,
        onUpgrade: JapaCounterRepository.onUpgrade,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );

    final repo = container.read(japaCounterRepositoryProvider);
    for (final id in ['c1', 'c2']) {
      await repo.insertCounter(
        Counter(id: id, name: 'Counter $id', startDate: 0, createdAt: 0),
      );
    }
  });

  tearDown(() async {
    container.dispose();
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  int at(int year, int month, int day, [int hour = 9]) =>
      DateTime(year, month, day, hour).millisecondsSinceEpoch;

  Future<void> addSession(
    String id,
    String counterId,
    int timestamp, {
    int count = 108,
    int duration = 60000,
  }) => container
      .read(japaCounterRepositoryProvider)
      .insertSession(
        JapaSession(
          id: id,
          counterId: counterId,
          counterName: 'Counter $counterId',
          count: count,
          malas: count ~/ 108,
          chants: count % 108,
          timestamp: timestamp,
          duration: duration,
        ),
      );

  /// Reads an autoDispose provider while keeping it alive for the read.
  Future<List<DailySummary>> summaries([String? counterId]) async {
    final sub = container.listen(
      historySummariesProvider(counterId),
      (_, _) {},
    );
    try {
      return await container.read(historySummariesProvider(counterId).future);
    } finally {
      sub.close();
    }
  }

  test('empty history gives no days', () async {
    expect(await summaries(), isEmpty);
  });

  test('groups sessions by day, newest day first, with day totals', () async {
    await addSession('a', 'c1', at(2026, 10, 20), duration: 1000);
    await addSession('b', 'c2', at(2026, 10, 20, 18), count: 54, duration: 500);
    await addSession('c', 'c1', at(2026, 10, 21), count: 10, duration: 200);

    final days = await summaries();
    expect(days, hasLength(2));

    expect(days[0].sessions.map((s) => s.id), ['c']);
    expect(days[0].totalCount, 10);

    expect(days[1].sessions.map((s) => s.id).toSet(), {'a', 'b'});
    expect(days[1].totalCount, 162);
    expect(days[1].totalDuration, 1500);
  });

  test('filters to one counter', () async {
    await addSession('a', 'c1', at(2026, 10, 20));
    await addSession('b', 'c2', at(2026, 10, 20));

    final days = await summaries('c2');
    expect(days.single.sessions.map((s) => s.id), ['b']);
  });

  ActiveSession paused(String counterId) => ActiveSession(
    sessionId: 'p-$counterId',
    counterId: counterId,
    counterName: 'Counter $counterId',
    startTime: 1000,
    tapCount: 5,
    incrementStep: 1,
    lastResumeTimeMs: 1000,
    isPaused: true,
  );

  test('clearHistory for one counter keeps the others', () async {
    await addSession('a', 'c1', at(2026, 10, 20));
    await addSession('b', 'c2', at(2026, 10, 20));
    final settings = container.read(settingsRepositoryProvider);
    await settings.saveActiveSession(paused('c1'));
    await settings.saveActiveSession(paused('c2'));

    await container.read(historyActionsProvider).clearHistory(counterId: 'c1');

    expect(await summaries('c1'), isEmpty);
    expect((await summaries()).single.sessions.map((s) => s.id), ['b']);
    expect(settings.getActiveSession('c1'), isNull);
    expect(settings.getActiveSession('c2'), isNotNull);
  });

  test('clearHistory for all counters removes everything', () async {
    await addSession('a', 'c1', at(2026, 10, 20));
    await addSession('b', 'c2', at(2026, 10, 21));
    final settings = container.read(settingsRepositoryProvider);
    await settings.saveActiveSession(paused('c1'));

    await container.read(historyActionsProvider).clearHistory();

    expect(await summaries(), isEmpty);
    expect(settings.getAllActiveSessions(), isEmpty);
    // Counters themselves stay.
    final counters = await container
        .read(japaCounterRepositoryProvider)
        .getAllCounters();
    expect(counters, hasLength(2));
  });
}
