import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/counter_status.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counters_provider.dart';
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
    tempDir = await Directory.systemTemp.createTemp('japa_counters_test');
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
  });

  tearDown(() async {
    container.dispose();
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  JapaCounterRepository repo() => container.read(japaCounterRepositoryProvider);

  CountersNotifier notifier() =>
      container.read(countersNotifierProvider.notifier);

  Future<List<Counter>> counters() =>
      container.read(countersNotifierProvider.future);

  Counter counter(String id, {int createdAt = 100, bool active = true}) =>
      Counter(
        id: id,
        name: 'Counter $id',
        startDate: createdAt,
        createdAt: createdAt,
        status: active ? CounterStatus.active : CounterStatus.disabledSuccess,
      );

  JapaSession session(String id, String counterId) => JapaSession(
    id: id,
    counterId: counterId,
    counterName: 'Counter $counterId',
    count: 10,
    malas: 0,
    chants: 10,
    timestamp: 5000,
    duration: 1000,
  );

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

  test('lists active counters first, then newest first', () async {
    await repo().insertCounter(counter('old'));
    await repo().insertCounter(counter('new', createdAt: 300));
    await repo().insertCounter(counter('done', createdAt: 500, active: false));

    expect((await counters()).map((c) => c.id), ['new', 'old', 'done']);
  });

  test('addCounter saves all given fields', () async {
    await counters();
    await notifier().addCounter(
      name: 'Gayatri',
      startDate: 1234,
      initialCount: 7,
      incrementStep: 3,
      goal: 1000,
      dailyGoal: 108,
      malaSize: 0,
    );

    final list = await counters();
    expect(list, hasLength(1));
    final c = list.single;
    expect(c.name, 'Gayatri');
    expect(c.startDate, 1234);
    expect(c.initialCount, 7);
    expect(c.incrementStep, 3);
    expect(c.goal, 1000);
    expect(c.dailyGoal, 108);
    expect(c.malaSize, 0);
    expect(c.id, isNotEmpty);
  });

  test('updateCounter changes the stored counter', () async {
    await repo().insertCounter(counter('c1'));
    await counters();

    await notifier().updateCounter(counter('c1').copyWith(name: 'Renamed'));

    expect((await counters()).single.name, 'Renamed');
  });

  test('disableCounter sets status, reason and time', () async {
    await repo().insertCounter(counter('c1'));
    await counters();

    await notifier().disableCounter(
      'c1',
      CounterStatus.disabledSuccess,
      'Done',
    );

    final c = (await counters()).single;
    expect(c.status, CounterStatus.disabledSuccess);
    expect(c.disabledReason, 'Done');
    expect(c.disabledAt, isNotNull);
  });

  test('toggleLock flips the lock both ways', () async {
    await repo().insertCounter(counter('c1'));
    await counters();

    await notifier().toggleLock('c1');
    expect((await counters()).single.isLocked, isTrue);

    await notifier().toggleLock('c1');
    expect((await counters()).single.isLocked, isFalse);
  });

  test('disable and lock ignore an unknown counter', () async {
    await counters();
    await notifier().disableCounter(
      'missing',
      CounterStatus.disabledSuccess,
      null,
    );
    await notifier().toggleLock('missing');
    expect(await counters(), isEmpty);
  });

  test('deleteCounter removes its sessions and paused session', () async {
    await repo().insertCounter(counter('c1'));
    await repo().insertCounter(counter('c2'));
    await repo().insertSession(session('s1', 'c1'));
    await repo().insertSession(session('s2', 'c2'));
    final settings = container.read(settingsRepositoryProvider);
    await settings.saveActiveSession(paused('c1'));
    await settings.saveActiveSession(paused('c2'));
    await counters();

    await notifier().deleteCounter('c1');

    expect((await counters()).map((c) => c.id), ['c2']);
    expect((await repo().getAllSessions()).map((s) => s.id), ['s2']);
    expect(settings.getActiveSession('c1'), isNull);
    expect(settings.getActiveSession('c2'), isNotNull);
  });

  test('clearAllData removes counters, sessions and paused sessions', () async {
    await repo().insertCounter(counter('c1'));
    await repo().insertSession(session('s1', 'c1'));
    final settings = container.read(settingsRepositoryProvider);
    await settings.saveActiveSession(paused('c1'));
    await counters();

    await notifier().clearAllData();

    expect(await counters(), isEmpty);
    expect(await repo().getAllSessions(), isEmpty);
    expect(settings.getAllActiveSessions(), isEmpty);
  });
}
