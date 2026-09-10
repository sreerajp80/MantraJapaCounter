import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/session_recovery_service.dart';

/// Session recovery tests.
///
/// These cover the "zero data loss" rule from the other side: if the app dies
/// between a SharedPreferences write and the next database flush, the taps the
/// user already made must still reach the database on the next start.
void main() {
  late Directory tempDir;
  late Database db;
  late JapaCounterRepository repo;
  late SettingsRepository settings;
  late SessionRecoveryService service;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  /// Writes an active session straight into SharedPreferences, the way the
  /// counting screen would have done before a crash.
  Future<void> savePrefsSession(ActiveSession session) =>
      settings.saveActiveSession(session);

  ActiveSession activeSession({
    String sessionId = 's1',
    String counterId = 'c1',
    String counterName = 'Om Namah Shivaya',
    int tapCount = 50,
    int startTime = 1000,
  }) {
    return ActiveSession(
      sessionId: sessionId,
      counterId: counterId,
      counterName: counterName,
      startTime: startTime,
      tapCount: tapCount,
      incrementStep: 1,
      accumulatedMs: 60000,
      lastResumeTimeMs: startTime,
      isPaused: true, // keeps `duration` deterministic (== accumulatedMs)
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('japa_recovery_test');
    db = await databaseFactory.openDatabase(
      '${tempDir.path}/japa.db',
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: JapaCounterRepository.onCreate,
        onUpgrade: JapaCounterRepository.onUpgrade,
      ),
    );
    repo = JapaCounterRepository(db);

    SharedPreferences.setMockInitialValues({});
    settings = SettingsRepository(await SharedPreferences.getInstance());

    service = SessionRecoveryService(repo, settings);

    // Every session needs its parent counter — the foreign key demands it.
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
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('nothing to recover', () {
    test('does nothing when no active session is stored', () async {
      await service.recoverIfNeeded();
      expect(await db.query('japa_sessions'), isEmpty);
    });

    test('clears a zero-tap placeholder instead of writing a row', () async {
      await savePrefsSession(activeSession(tapCount: 0));

      await service.recoverIfNeeded();

      expect(
        await db.query('japa_sessions'),
        isEmpty,
        reason: 'a zero-tap session is not worth a database row',
      );
      expect(
        settings.getActiveSession('c1'),
        isNull,
        reason: 'the placeholder must be cleared so it is not resumed later',
      );
    });
  });

  group('crash between a prefs write and a database flush', () {
    test('writes the missing session row', () async {
      await savePrefsSession(activeSession(tapCount: 150));

      await service.recoverIfNeeded();

      final recovered = await repo.getSessionById('s1');
      expect(recovered, isNotNull);
      expect(recovered!.count, 150);
      expect(recovered.counterId, 'c1');
      expect(recovered.timestamp, 1000);
      // 150 taps = 1 mala of 108, with 42 left over.
      expect(recovered.malas, 1);
      expect(recovered.chants, 42);
    });

    test('keeps the prefs entry so the screen can resume it', () async {
      await savePrefsSession(activeSession(tapCount: 150));

      await service.recoverIfNeeded();

      expect(
        settings.getActiveSession('c1'),
        isNotNull,
        reason: 'CountingNotifier.init() consumes this, recovery must not',
      );
    });

    test('recovers every counter that has a pending session', () async {
      await db.insert('counters', {
        'id': 'c2',
        'name': 'Gayatri',
        'initialCount': 0,
        'incrementStep': 1,
        'goal': 0,
        'dailyGoal': 0,
        'startDate': 0,
        'createdAt': 200,
        'status': 'ACTIVE',
      });
      await savePrefsSession(activeSession(tapCount: 108));
      await savePrefsSession(
        activeSession(
          sessionId: 's2',
          counterId: 'c2',
          counterName: 'Gayatri',
          tapCount: 216,
        ),
      );

      await service.recoverIfNeeded();

      expect((await repo.getSessionById('s1'))!.count, 108);
      expect((await repo.getSessionById('s2'))!.count, 216);
    });
  });

  group('prefs ahead of the database', () {
    test('syncs the higher tap count forward', () async {
      // The database flush landed at 100, then 20 more taps only reached prefs.
      await savePrefsSession(activeSession(tapCount: 120));
      await service.recoverIfNeeded();
      // Simulate the stale row by rewriting it lower, then recovering again.
      await db.update(
        'japa_sessions',
        {'count': 100, 'malas': 0, 'chants': 100},
        where: 'id = ?',
        whereArgs: ['s1'],
      );

      await service.recoverIfNeeded();

      final synced = await repo.getSessionById('s1');
      expect(synced!.count, 120);
      expect(synced.malas, 1);
      expect(synced.chants, 12);
    });

    test('leaves the row alone when the database is already ahead', () async {
      await savePrefsSession(activeSession());
      await service.recoverIfNeeded();
      // The database legitimately holds more than prefs remembered.
      await db.update(
        'japa_sessions',
        {'count': 80, 'malas': 0, 'chants': 80},
        where: 'id = ?',
        whereArgs: ['s1'],
      );

      await service.recoverIfNeeded();

      expect(
        (await repo.getSessionById('s1'))!.count,
        80,
        reason: 'recovery must never walk a count backwards',
      );
    });
  });

  group('malformed input', () {
    test('drops unparseable JSON without throwing', () async {
      // Rule 4: never crash on malformed input.
      SharedPreferences.setMockInitialValues({
        '${AppConstants.prefsActiveSessionPrefix}c1': 'not valid json at all',
      });
      settings = SettingsRepository(await SharedPreferences.getInstance());
      service = SessionRecoveryService(repo, settings);

      await expectLater(service.recoverIfNeeded(), completes);
      expect(await db.query('japa_sessions'), isEmpty);
    });
  });
}
