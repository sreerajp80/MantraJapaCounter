import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
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

  ProviderContainer newContainer() {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificationServiceProvider.overrideWithValue(_FakeNotifications()),
        soundServiceProvider.overrideWithValue(_FakeSound()),
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
}
