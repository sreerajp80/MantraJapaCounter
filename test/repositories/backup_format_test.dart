import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/models/counter_status.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/models/meru_pause_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';
import 'package:mantra_japa_counter/services/export_service.dart';

/// Locks the backup file format.
///
/// Every app version must import backups made by any earlier version. The
/// fixture is a made-up backup in format `exportVersion` 1. Never edit it to
/// make a test pass — if the format grows, add a new fixture instead.
void main() {
  late Directory tempDir;
  late Database db;
  late JapaCounterRepository repo;
  late ExportService exportService;
  late SettingsRepository settings;

  final fixtureText = File('test/fixtures/backup_format_v1.json')
      .readAsStringSync();
  final fixture = jsonDecode(fixtureText) as Map<String, dynamic>;

  Map<String, Map<String, dynamic>> byId(List<dynamic> rows) => {
    for (final r in rows.cast<Map<String, dynamic>>()) r['id'] as String: r,
  };

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('japa_backup_format');
    db = await databaseFactory.openDatabase(
      '${tempDir.path}/japa.db',
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: JapaCounterRepository.onCreate,
        onUpgrade: JapaCounterRepository.onUpgrade,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    repo = JapaCounterRepository(db);
    SharedPreferences.setMockInitialValues({});
    settings = SettingsRepository(await SharedPreferences.getInstance());
    exportService = ExportService(repo, EncryptionService(), settings);
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('the fixture is still format version 1', () {
    expect(fixture['exportVersion'], 1);
    expect(AppConstants.exportFormatVersion, greaterThanOrEqualTo(1));
  });

  test('imports every counter and session with the right values', () async {
    await exportService.importFromJson(fixtureText);

    final counters = {for (final c in await repo.getAllCounters()) c.id: c};
    expect(counters, hasLength(5));

    final plain = counters['11111111-1111-4111-8111-111111111111']!;
    expect(plain.name, 'Test Counter Default');
    expect(plain.isLocked, isFalse);
    expect(plain.malaSize, AppConstants.defaultMalaSize);
    expect(plain.status, CounterStatus.active);

    final locked = counters['22222222-2222-4222-8222-222222222222']!;
    expect(locked.name, 'ടെസ്റ്റ് മന്ത്രം');
    expect(locked.isLocked, isTrue);
    expect(locked.dailyGoal, 108);
    expect(locked.goal, 100000);

    expect(counters['33333333-3333-4333-8333-333333333333']!.malaSize, 0);

    final finished = counters['44444444-4444-4444-8444-444444444444']!;
    expect(finished.status, CounterStatus.disabledSuccess);
    expect(finished.disabledAt, 1789000000000);
    expect(finished.disabledReason, 'Goal reached');

    final custom = counters['55555555-5555-4555-8555-555555555555']!;
    expect(custom.initialCount, 500);
    expect(custom.incrementStep, 2);
    expect(custom.malaSize, 27);
    expect(custom.startDate, 1784000000000);
    expect(custom.createdAt, 1784000000500);

    final sessions = await repo.getAllSessions();
    expect(sessions, hasLength(6));
    final s = sessions.firstWhere(
      (s) => s.id == 'aaaaaaa1-0000-4000-8000-000000000002',
    );
    expect(s.counterId, '11111111-1111-4111-8111-111111111111');
    expect(s.count, 150);
    expect(s.malas, 1);
    expect(s.chants, 42);
    expect(s.timestamp, 1785090000000);
    expect(s.duration, 840000);
  });

  test('export after import gives back the same fields and values', () async {
    await exportService.importFromJson(fixtureText);

    final exported = jsonDecode(
      (await repo.exportData()).toJsonString(),
    ) as Map<String, dynamic>;

    expect(exported.keys.toSet(), fixture.keys.toSet());
    expect(exported['exportVersion'], fixture['exportVersion']);
    expect(
      byId(exported['counters'] as List),
      byId(fixture['counters'] as List),
    );
    expect(
      byId(exported['sessions'] as List),
      byId(fixture['sessions'] as List),
    );
  });

  test(
    'a counter written before lock and mala size existed still imports',
    () async {
      final minimal = jsonEncode({
        'exportVersion': 1,
        'exportDate': 1,
        'counters': [
          {
            'id': 'old-1',
            'name': 'Older backup counter',
            'initialCount': 0,
            'incrementStep': 1,
            'goal': 0,
            'dailyGoal': 0,
            'startDate': 1000,
            'createdAt': 1000,
            'status': 'ACTIVE',
          },
        ],
        'sessions': <Object>[],
      });

      await exportService.importFromJson(minimal);

      final c = (await repo.getAllCounters()).single;
      expect(c.isLocked, isFalse);
      expect(c.malaSize, AppConstants.defaultMalaSize);
    },
  );

  group('format with settings and running counts', () {
    final text = File('test/fixtures/backup_format_v1_settings.json')
        .readAsStringSync();

    test('the fixture is still format version 1', () {
      final json = jsonDecode(text) as Map<String, dynamic>;
      expect(json['exportVersion'], 1);
    });

    test('a full import restores the settings and the running count', () async {
      await settings.setLanguageCode('sa');

      await exportService.importFromJson(text);

      expect(settings.screenBrightness, 0.6);
      expect(settings.dailyGoalNotificationsEnabled, isFalse);
      expect(settings.malaSound, MalaSound.singingBowl);
      expect(settings.vibrationEnabled, isFalse);
      expect(settings.tapVibrationEnabled, isTrue);
      expect(settings.feedbackVolumePercent, 60);
      expect(settings.vibrationStrengthPercent, 80);
      expect(settings.languageCode, 'ml');
      expect(settings.dimmedChantingMode, isTrue);
      expect(settings.meruPauseEnabled, isTrue);
      expect(settings.meruPauseSeconds, 10);
      expect(settings.meruPauseMode, MeruPauseMode.time);
      expect(settings.meruPauseTaps, 3);
      expect(settings.pacingHintEnabled, isFalse);
      expect(settings.dailyReminderEnabled, isTrue);
      expect(settings.dailyReminderMinutes, 330);

      final running = settings.getActiveSession(
        '66666666-6666-4666-8666-666666666666',
      )!;
      expect(running.sessionId, '77777777-7777-4777-8777-777777777777');
      expect(running.tapCount, 45);
      expect(running.accumulatedMs, 300000);
      expect(running.isPaused, isTrue);
      expect(running.malaSize, 108);
    });

    test('a selected import keeps the phone settings', () async {
      await settings.setLanguageCode('sa');

      await exportService.importSelectedFromJson(text, [
        '66666666-6666-4666-8666-666666666666',
      ]);

      expect(settings.languageCode, 'sa');
      expect(settings.meruPauseEnabled, isFalse);
      expect(
        settings
            .getActiveSession('66666666-6666-4666-8666-666666666666')!
            .tapCount,
        45,
      );
    });
  });
}
