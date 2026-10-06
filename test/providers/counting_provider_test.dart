import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counting_provider.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/notification_service.dart';
import 'package:mantra_japa_counter/services/session_recovery_service.dart';
import 'package:mantra_japa_counter/services/sound_service.dart';

/// Notifications and sound talk to the platform; these tests only need the
/// counting and saving logic, so both are silent fakes.
class _FakeNotifications implements NotificationService {
  @override
  Future<void> notifyDailyGoalReached() async {}

  @override
  Future<void> notifyLifetimeGoalReached() async {}

  @override
  Future<bool> requestPermissionIfNeeded() async => true;

  @override
  Future<void> cancelAll() async {}
}

class _FakeSound implements SoundService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

void main() {
  late Directory tempDir;
  late Database db;
  late SharedPreferences prefs;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('japa_counting_test');
    db = await databaseFactory.openDatabase(
      '${tempDir.path}/japa.db',
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: JapaCounterRepository.onCreate,
        onUpgrade: JapaCounterRepository.onUpgrade,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    await db.insert('counters', {
      'id': 'c1',
      'name': 'Om Namah Shivaya',
      'initialCount': 0,
      'incrementStep': 1,
      'goal': 0,
      'dailyGoal': 0,
      'startDate': 0,
      'createdAt': 100,
      'status': 'ACTIVE',
    });
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  ProviderContainer newContainer({int Function()? clock}) {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificationServiceProvider.overrideWithValue(_FakeNotifications()),
        soundServiceProvider.overrideWithValue(_FakeSound()),
        if (clock != null) countingClockProvider.overrideWithValue(clock),
      ],
    );
    // Keep the autoDispose provider alive for the whole test.
    container.listen(countingNotifierProvider('c1'), (_, _) {});
    return container;
  }

  Future<int> dbTotal() async {
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(count), 0) AS total FROM japa_sessions',
    );
    return rows.first['total'] as int;
  }

  test('down to zero and up again is never counted twice', () async {
    final container = newContainer();
    final notifier = container.read(countingNotifierProvider('c1').notifier);
    await notifier.init();

    await notifier.tap(); // 1 — first tap inserts the row
    await notifier.decrement(); // 0 — session cancelled
    await notifier.tap(); // 1 — new session
    await notifier.tap(); // 2
    await notifier.tap(); // 3
    await notifier.onPause(); // flush prefs + DB as when the app is left
    container.dispose();

    expect(await dbTotal(), 3);

    // Simulate the next app start: recovery reconciles prefs with the DB.
    final repo = JapaCounterRepository(db);
    await SessionRecoveryService(
      repo,
      SettingsRepository(prefs),
    ).recoverIfNeeded();

    expect(
      await dbTotal(),
      3,
      reason: 'prefs and the DB row must share one session id',
    );

    // Re-entering the counter must resume the same 3 taps, not add more.
    final again = newContainer();
    final resumed = again.read(countingNotifierProvider('c1').notifier);
    await resumed.init();
    expect(again.read(countingNotifierProvider('c1')).session!.tapCount, 3);
    expect(again.read(countingNotifierProvider('c1')).liveLifetimeTotal, 3);
    again.dispose();
    expect(await dbTotal(), 3);
  });

  test('prefs session id matches the DB row after going to zero', () async {
    final container = newContainer();
    final notifier = container.read(countingNotifierProvider('c1').notifier);
    await notifier.init();

    await notifier.tap();
    await notifier.decrement();
    await notifier.tap();

    final saved = SettingsRepository(prefs).getActiveSession('c1');
    final rows = await db.query('japa_sessions');
    expect(rows, hasLength(1));
    expect(saved, isNotNull);
    expect(saved!.sessionId, rows.single['id']);
    container.dispose();
  });

  test(
    'leaving mid-mala after the daily goal is met keeps the count',
    () async {
      await db.update(
        'counters',
        {'dailyGoal': 50},
        where: 'id = ?',
        whereArgs: ['c1'],
      );
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();
      for (var i = 0; i < 60; i++) {
        await notifier.tap();
      }
      expect(container.read(countingNotifierProvider('c1')).liveTodayTotal, 60);
      await notifier.completeSession(); // goal met, mid-mala — still paused
      container.dispose();

      final again = newContainer();
      await again.read(countingNotifierProvider('c1').notifier).init();
      final state = again.read(countingNotifierProvider('c1'));
      expect(state.session!.tapCount, 60);
      expect(state.liveTodayTotal, 60);
      again.dispose();
      expect(await dbTotal(), 60);
    },
  );

  group('Meru pause', () {
    Future<void> tapTimes(CountingNotifier notifier, int times) async {
      for (var i = 0; i < times; i++) {
        await notifier.tap();
      }
    }

    test('is off by default: counting rolls into the next mala', () async {
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      await tapTimes(notifier, 109);

      final state = container.read(countingNotifierProvider('c1'));
      expect(state.isMeruPause, isFalse);
      expect(state.session!.tapCount, 109);
      await notifier.onPause(); // wait for pending DB writes
      container.dispose();
    });

    test('starts after 108 and ignores taps until it ends', () async {
      await prefs.setBool(AppConstants.prefsMeruPauseKey, true);
      await prefs.setInt(AppConstants.prefsMeruPauseSecondsKey, 3);
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      await tapTimes(notifier, 107);
      expect(
        container.read(countingNotifierProvider('c1')).isMeruPause,
        isFalse,
      );

      await notifier.tap(); // 108: mala complete
      var state = container.read(countingNotifierProvider('c1'));
      expect(state.isMeruPause, isTrue);
      expect(state.meruPauseSeconds, 3);

      await notifier.tap(); // ignored during the pause
      expect(
        container.read(countingNotifierProvider('c1')).session!.tapCount,
        108,
      );

      notifier.endMeruPause();
      await notifier.tap();
      state = container.read(countingNotifierProvider('c1'));
      expect(state.isMeruPause, isFalse);
      expect(state.session!.tapCount, 109);
      await notifier.onPause(); // wait for pending DB writes
      container.dispose();
    });

    test('undo ends the pause', () async {
      await prefs.setBool(AppConstants.prefsMeruPauseKey, true);
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      await tapTimes(notifier, 108);
      expect(
        container.read(countingNotifierProvider('c1')).isMeruPause,
        isTrue,
      );

      await notifier.decrement();
      final state = container.read(countingNotifierProvider('c1'));
      expect(state.isMeruPause, isFalse);
      expect(state.session!.tapCount, 107);
      await notifier.onPause(); // wait for pending DB writes
      container.dispose();
    });
  });

  group('Pacing hint', () {
    Future<CountingState> tapEvery(int gapMs, {int taps = 6}) async {
      var now = 1000000;
      final container = newContainer(clock: () => now);
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();
      for (var i = 0; i < taps; i++) {
        await notifier.tap();
        now += gapMs;
      }
      final state = container.read(countingNotifierProvider('c1'));
      await notifier.onPause(); // wait for pending DB writes
      container.dispose();
      return state;
    }

    test('fast taps turn the hint on and still count every tap', () async {
      final state = await tapEvery(100);
      expect(state.isRushing, isTrue);
      expect(state.session!.tapCount, 6);
    });

    test('a natural pace does not show the hint', () async {
      final state = await tapEvery(500);
      expect(state.isRushing, isFalse);
    });

    test('no hint when the setting is off', () async {
      await prefs.setBool(AppConstants.prefsPacingHintKey, false);
      final state = await tapEvery(100);
      expect(state.isRushing, isFalse);
      expect(state.session!.tapCount, 6);
    });
  });

  group('Unfinished mala across days', () {
    const yesterdayId = 'yesterday-row';
    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .millisecondsSinceEpoch;

    /// Yesterday the user stopped at 45 — the row is stored and the
    /// session is paused in prefs, as `completeSession` leaves it.
    Future<void> seedYesterday({int count = 45}) async {
      await db.insert(
        'japa_sessions',
        JapaSession(
          id: yesterdayId,
          counterId: 'c1',
          counterName: 'Om Namah Shivaya',
          count: count,
          malas: count ~/ 108,
          chants: count % 108,
          timestamp: yesterday,
          duration: 60000,
        ).toMap(),
      );
      await SettingsRepository(prefs).saveActiveSession(
        ActiveSession(
          sessionId: yesterdayId,
          counterId: 'c1',
          counterName: 'Om Namah Shivaya',
          startTime: yesterday,
          tapCount: count,
          incrementStep: 1,
          accumulatedMs: 60000,
          lastResumeTimeMs: yesterday,
          isPaused: true,
        ),
      );
    }

    Future<List<Map<String, Object?>>> rows() =>
        db.query('japa_sessions', orderBy: 'timestamp ASC');

    test('opening shows the banner and today starts at 0', () async {
      await seedYesterday();
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      final state = container.read(countingNotifierProvider('c1'));
      expect(state.resumedFromEarlierDay, isTrue);
      expect(state.session!.tapCount, 45);
      expect(state.liveTodayTotal, 0);
      expect(state.liveLifetimeTotal, 45);
      container.dispose();
    });

    test('today\'s taps go into a new row dated today', () async {
      await seedYesterday();
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      for (var i = 1; i <= 63; i++) {
        await notifier.tap();
        final state = container.read(countingNotifierProvider('c1'));
        // The Daily card counts today's taps and never drops back.
        expect(state.liveTodayTotal, i);
      }
      final state = container.read(countingNotifierProvider('c1'));
      expect(state.resumedFromEarlierDay, isFalse);
      expect(state.session!.tapCount, 108, reason: 'the mala is finished');
      expect(state.liveLifetimeTotal, 108);

      await notifier.completeSession();
      container.dispose();

      final all = await rows();
      expect(all, hasLength(2));
      expect(all[0]['id'], yesterdayId);
      expect(all[0]['count'], 45);
      expect(all[1]['count'], 63);
      expect(
        all[1]['timestamp'] as int,
        greaterThan(yesterday),
        reason: 'the new row is dated today',
      );
      final repo = JapaCounterRepository(db);
      expect(await repo.getTodayCountForCounter('c1'), 63);
      expect(await dbTotal(), 108);
      expect(
        SettingsRepository(prefs).getActiveSession('c1'),
        isNull,
        reason: 'a finished mala is closed',
      );
    });

    test('leaving mid-mala again keeps the carry-over on resume', () async {
      await seedYesterday();
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();
      for (var i = 0; i < 10; i++) {
        await notifier.tap();
      }
      await notifier.completeSession(); // 55 — mid-mala, so paused
      container.dispose();

      final again = newContainer();
      final resumed = again.read(countingNotifierProvider('c1').notifier);
      await resumed.init();
      final state = again.read(countingNotifierProvider('c1'));
      expect(state.session!.tapCount, 55);
      expect(state.session!.carriedCount, 45);
      expect(state.resumedFromEarlierDay, isFalse);
      expect(state.liveTodayTotal, 10);
      expect(state.liveLifetimeTotal, 55);

      await resumed.tap();
      await resumed.onPause();
      again.dispose();
      expect(await dbTotal(), 56);
      expect(await rows(), hasLength(2));
    });

    test('counting past midnight without stopping splits the rows', () async {
      var now = DateTime.now().millisecondsSinceEpoch;
      final container = newContainer(clock: () => now);
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();
      for (var i = 0; i < 20; i++) {
        await notifier.tap();
      }
      now += const Duration(days: 1).inMilliseconds; // midnight has passed
      for (var i = 0; i < 5; i++) {
        await notifier.tap();
      }
      expect(
        container.read(countingNotifierProvider('c1')).session!.tapCount,
        25,
      );
      await notifier.onPause();
      container.dispose();

      final all = await rows();
      expect(all.map((r) => r['count']), [20, 5]);
      expect(all[1]['timestamp'], now);
    });

    test('undo cannot remove taps stored on an earlier day', () async {
      await seedYesterday();
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      await notifier.decrement(); // blocked: nothing counted today yet
      expect(
        container.read(countingNotifierProvider('c1')).session!.tapCount,
        45,
      );

      await notifier.tap();
      await notifier.tap();
      await notifier.decrement();
      await notifier.decrement();
      await notifier.decrement(); // blocked at the carried count
      final state = container.read(countingNotifierProvider('c1'));
      expect(state.session!.tapCount, 45);
      expect(state.liveTodayTotal, 0);
      expect(await rows(), hasLength(1), reason: 'today\'s row is dropped');

      await notifier.tap();
      expect(container.read(countingNotifierProvider('c1')).liveTodayTotal, 1);
      await notifier.onPause();
      container.dispose();
      expect(await dbTotal(), 46);
    });

    test('Start new keeps yesterday\'s counts and starts at 0', () async {
      await seedYesterday();
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();

      await notifier.finishAndStartNew();
      var state = container.read(countingNotifierProvider('c1'));
      expect(state.session!.tapCount, 0);
      expect(state.session!.carriedCount, 0);
      expect(state.resumedFromEarlierDay, isFalse);
      expect(state.liveLifetimeTotal, 45);
      expect(SettingsRepository(prefs).getActiveSession('c1'), isNull);

      await notifier.tap();
      state = container.read(countingNotifierProvider('c1'));
      expect(state.liveTodayTotal, 1);
      await notifier.onPause();
      container.dispose();

      final all = await rows();
      expect(all, hasLength(2));
      expect(all[0]['count'], 45);
      expect(all[1]['count'], 1);
    });

    test('Finish & start new on a same-day session keeps its row', () async {
      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();
      for (var i = 0; i < 30; i++) {
        await notifier.tap();
      }
      await notifier.finishAndStartNew();
      expect(
        container.read(countingNotifierProvider('c1')).session!.tapCount,
        0,
      );
      container.dispose();
      expect(await dbTotal(), 30);
      expect(await rows(), hasLength(1));
    });

    test('crash recovery writes only today\'s part of the session', () async {
      await seedYesterday();
      // Today's row was never written (crash right after the prefs write).
      await SettingsRepository(prefs).saveActiveSession(
        ActiveSession(
          sessionId: 'today-row',
          counterId: 'c1',
          counterName: 'Om Namah Shivaya',
          startTime: DateTime.now().millisecondsSinceEpoch,
          tapCount: 50,
          incrementStep: 1,
          lastResumeTimeMs: DateTime.now().millisecondsSinceEpoch,
          carriedCount: 45,
          carriedDurationMs: 60000,
        ),
      );
      await SessionRecoveryService(
        JapaCounterRepository(db),
        SettingsRepository(prefs),
      ).recoverIfNeeded();

      expect(await dbTotal(), 50);
      final today = await db.query(
        'japa_sessions',
        where: 'id = ?',
        whereArgs: ['today-row'],
      );
      expect(today.single['count'], 5);

      final container = newContainer();
      final notifier = container.read(countingNotifierProvider('c1').notifier);
      await notifier.init();
      final state = container.read(countingNotifierProvider('c1'));
      expect(state.liveLifetimeTotal, 50);
      expect(state.liveTodayTotal, 5);
      container.dispose();
      expect(await dbTotal(), 50);
    });
  });
}
