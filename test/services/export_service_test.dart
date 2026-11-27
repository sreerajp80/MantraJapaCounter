import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';
import 'package:mantra_japa_counter/services/export_service.dart';

void main() {
  late Database db;
  late JapaCounterRepository repo;
  late EncryptionService encryptionService;
  late ExportService exportService;
  late SettingsRepository settings;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 4,
        onCreate: JapaCounterRepository.onCreate,
      ),
    );
    repo = JapaCounterRepository(db);
    encryptionService = EncryptionService();
    SharedPreferences.setMockInitialValues({});
    settings = SettingsRepository(await SharedPreferences.getInstance());
    exportService = ExportService(repo, encryptionService, settings);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExportService Tests', () {
    const counter1 = Counter(
      id: 'c1',
      name: 'Om Namah Shivaya',
      initialCount: 108,
      goal: 1000,
      dailyGoal: 108,
      startDate: 1000,
      createdAt: 1000,
    );

    const counter2 = Counter(
      id: 'c2',
      name: 'Hare Krishna',
      initialCount: 108,
      goal: 1000,
      dailyGoal: 108,
      startDate: 2000,
      createdAt: 2000,
    );

    test('parseExportData parses valid JSON', () {
      const exportData = ExportData(
        exportDate: 12345,
        counters: [counter1],
        sessions: [],
      );

      final parsed = exportService.parseExportData(exportData.toJsonString());
      expect(parsed.counters.length, equals(1));
      expect(parsed.counters.first.name, equals('Om Namah Shivaya'));
    });

    test('importFromJson detects encrypted content and throws EncryptedExportException', () async {
      const plaintext = '{"counters":[],"sessions":[],"exportDate":123}';
      final encrypted = await encryptionService.encrypt(
        plaintext,
        'secretKey123',
      );

      expect(
        () => exportService.importFromJson(encrypted),
        throwsA(isA<EncryptedExportException>()),
      );
    });

    test(
      'importEncryptedFromJson decrypts and imports data successfully',
      () async {
        const exportData = ExportData(
          exportDate: 12345,
          counters: [counter1],
          sessions: [],
        );
        final json = exportData.toJsonString();
        final encrypted = await encryptionService.encrypt(json, 'secretKey123');

        await exportService.importEncryptedFromJson(encrypted, 'secretKey123');

        final counters = await repo.getAllCounters();
        expect(counters.length, equals(1));
        expect(counters.first.name, equals('Om Namah Shivaya'));
      },
    );

    test('importSelectedFromJson only imports chosen counters', () async {
      await repo.insertCounter(counter1);

      final exportData = ExportData(
        exportDate: 12345,
        counters: [
          counter1.copyWith(name: 'Modified C1'),
          counter2,
        ],
        sessions: [],
      );

      await exportService.importSelectedFromJson(exportData.toJsonString(), [
        'c2',
      ]);

      final counters = await repo.getAllCounters();
      expect(counters.length, equals(2));
      // c1 untouched
      expect(
        counters.firstWhere((c) => c.id == 'c1').name,
        equals('Om Namah Shivaya'),
      );
      // c2 added
      expect(
        counters.firstWhere((c) => c.id == 'c2').name,
        equals('Hare Krishna'),
      );
    });

    test(
      'importSelectedEncryptedFromJson decrypts and selectively imports',
      () async {
        await repo.insertCounter(counter1);

        const exportData = ExportData(
          exportDate: 12345,
          counters: [counter2],
          sessions: [],
        );
        final encrypted = await encryptionService.encrypt(
          exportData.toJsonString(),
          'myPassphrase123',
        );

        await exportService.importSelectedEncryptedFromJson(
          encrypted,
          'myPassphrase123',
          ['c2'],
        );

        final counters = await repo.getAllCounters();
        expect(counters.length, equals(2));
      },
    );
  });

  group('Import value checks', () {
    Map<String, dynamic> counterJson([Map<String, dynamic> over = const {}]) =>
        {
          'id': 'c1',
          'name': 'Om Namah Shivaya',
          'initialCount': 0,
          'incrementStep': 1,
          'goal': 1000,
          'dailyGoal': 108,
          'startDate': 1000,
          'createdAt': 1000,
          'status': 'ACTIVE',
          ...over,
        };

    Map<String, dynamic> sessionJson([Map<String, dynamic> over = const {}]) =>
        {
          'id': 's1',
          'counterId': 'c1',
          'counterName': 'Om Namah Shivaya',
          'count': 108,
          'malas': 1,
          'chants': 0,
          'timestamp': 5000,
          'duration': 60000,
          ...over,
        };

    String fileJson({
      int exportVersion = 1,
      List<Map<String, dynamic>>? counters,
      List<Map<String, dynamic>>? sessions,
    }) => jsonEncode({
      'exportVersion': exportVersion,
      'exportDate': 12345,
      'counters': counters ?? [counterJson()],
      'sessions': sessions ?? [sessionJson()],
    });

    Matcher rejects(String part) => throwsA(
      isA<ValidationException>().having(
        (e) => e.message,
        'message',
        contains(part),
      ),
    );

    test('a valid file still imports', () async {
      await exportService.importFromJson(fileJson());
      expect((await repo.getAllCounters()).length, 1);
      expect((await repo.getAllSessions()).length, 1);
    });

    test('rejects a newer export version', () {
      expect(
        () => exportService.parseExportData(fileJson(exportVersion: 2)),
        rejects('newer'),
      );
    });

    test('rejects an empty counter id', () {
      expect(
        () => exportService.parseExportData(
          fileJson(
            counters: [
              counterJson({'id': ''}),
            ],
            sessions: [],
          ),
        ),
        rejects('empty id'),
      );
    });

    test('rejects a duplicate counter id', () {
      expect(
        () => exportService.parseExportData(
          fileJson(counters: [counterJson(), counterJson()]),
        ),
        rejects('Duplicate'),
      );
    });

    test('rejects an empty counter name', () {
      expect(
        () => exportService.parseExportData(
          fileJson(
            counters: [
              counterJson({'name': '  '}),
            ],
          ),
        ),
        rejects('empty name'),
      );
    });

    test('rejects an increment step below 1', () {
      expect(
        () => exportService.parseExportData(
          fileJson(
            counters: [
              counterJson({'incrementStep': 0}),
            ],
          ),
        ),
        rejects('increment step'),
      );
    });

    for (final field in ['initialCount', 'goal', 'dailyGoal', 'malaSize']) {
      test('rejects a negative counter $field', () {
        expect(
          () => exportService.parseExportData(
            fileJson(
              counters: [
                counterJson({field: -1}),
              ],
            ),
          ),
          rejects('negative'),
        );
      });
    }

    test('rejects a session for a counter not in the file', () {
      expect(
        () => exportService.parseExportData(
          fileJson(
            sessions: [
              sessionJson({'counterId': 'missing'}),
            ],
          ),
        ),
        rejects('not in the file'),
      );
    });

    for (final field in ['count', 'duration']) {
      test('rejects a negative session $field', () {
        expect(
          () => exportService.parseExportData(
            fileJson(
              sessions: [
                sessionJson({field: -5}),
              ],
            ),
          ),
          rejects('negative'),
        );
      });
    }

    test('a rejected file leaves existing data untouched', () async {
      await repo.insertCounter(
        Counter.fromJson(counterJson({'id': 'keep', 'name': 'Keep me'})),
      );
      await expectLater(
        exportService.importFromJson(
          fileJson(
            counters: [
              counterJson({'incrementStep': 0}),
            ],
          ),
        ),
        throwsA(isA<ValidationException>()),
      );
      final counters = await repo.getAllCounters();
      expect(counters.map((c) => c.id), ['keep']);
    });
  });

  group('readBackupFile', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('backup_read_test');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('reads a file within the size limit', () async {
      final file = File('${tempDir.path}/backup.json');
      await file.writeAsString('{"exportVersion": 1}');

      final content = await exportService.readBackupFile(file.path);

      expect(content, '{"exportVersion": 1}');
    });

    test('rejects a file larger than the limit without reading it', () async {
      final file = File('${tempDir.path}/big.json');
      await file.writeAsString('x' * 101);

      expect(
        () => exportService.readBackupFile(file.path, maxBytes: 100),
        throwsA(isA<BackupTooLargeException>()),
      );
    });
  });

  group('Settings and running counts in backups', () {
    const c1 = Counter(id: 'c1', name: 'One', startDate: 1000, createdAt: 1000);
    const c2 = Counter(id: 'c2', name: 'Two', startDate: 1000, createdAt: 1000);

    JapaSession row(String id, String counterId, int count) => JapaSession(
      id: id,
      counterId: counterId,
      counterName: counterId,
      count: count,
      malas: 0,
      chants: count,
      timestamp: 5000,
      duration: 1000,
    );

    ActiveSession running(
      String sessionId,
      String counterId,
      int taps, {
      bool paused = false,
    }) => ActiveSession(
      sessionId: sessionId,
      counterId: counterId,
      counterName: counterId,
      startTime: 5000,
      tapCount: taps,
      incrementStep: 1,
      accumulatedMs: 2000,
      lastResumeTimeMs: DateTime.now().millisecondsSinceEpoch - 3000,
      isPaused: paused,
    );

    Future<void> seed() async {
      await repo.insertCounter(c1);
      await repo.insertCounter(c2);
      await repo.insertSession(row('s1', 'c1', 40));
      await repo.insertSession(row('s2', 'c2', 7));
      await settings.saveActiveSession(running('s1', 'c1', 40));
      await settings.saveActiveSession(running('s2', 'c2', 7, paused: true));
      await settings.setMeruPauseEnabled(true);
      await settings.setMalaSound(MalaSound.values.last);
      await settings.setLanguageCode('ml');
      await settings.setDailyReminderMinutes(6 * 60);
    }

    /// Empties the database and SharedPreferences, like a new phone.
    Future<void> freshPhone() async {
      await db.delete('japa_sessions');
      await db.delete('counters');
      SharedPreferences.setMockInitialValues({});
      settings = SettingsRepository(await SharedPreferences.getInstance());
      exportService = ExportService(repo, encryptionService, settings);
    }

    test('export holds the settings and paused running counts', () async {
      await seed();
      final data = await exportService.buildExportData();

      expect(data.settings!.meruPauseEnabled, isTrue);
      expect(data.settings!.languageCode, 'ml');
      expect(data.settings!.malaSound, MalaSound.values.last.id);
      expect(data.activeSessions, hasLength(2));
      final a1 = data.activeSessions.firstWhere((a) => a.counterId == 'c1');
      expect(a1.isPaused, isTrue);
      expect(a1.tapCount, 40);
      // 2 s from earlier segments + about 3 s of the running segment.
      expect(a1.accumulatedMs, greaterThanOrEqualTo(5000));
    });

    test('device-only sound links are not exported', () async {
      await settings.setNotificationSound('content://x', 'X');
      final json = (await exportService.buildExportData()).toJsonString();
      expect(json, isNot(contains('content://x')));
    });

    test('selected export holds only the chosen running counts', () async {
      await seed();
      final data = await exportService.buildExportData(counterIds: ['c2']);
      expect(data.activeSessions.map((a) => a.counterId), ['c2']);
      expect(data.settings, isNotNull);
    });

    test('full import on a new phone restores everything', () async {
      await seed();
      final json = (await exportService.buildExportData()).toJsonString();
      await freshPhone();

      await exportService.importFromJson(json);

      expect(await repo.getAllCounters(), hasLength(2));
      expect(settings.getActiveSession('c1')!.tapCount, 40);
      expect(settings.getActiveSession('c1')!.isPaused, isTrue);
      expect(settings.getActiveSession('c2')!.tapCount, 7);
      expect(settings.meruPauseEnabled, isTrue);
      expect(settings.malaSound, MalaSound.values.last);
      expect(settings.languageCode, 'ml');
      expect(settings.dailyReminderMinutes, 6 * 60);
    });

    test('full import clears old running counts on the phone', () async {
      await seed();
      final data = await exportService.buildExportData(counterIds: ['c2']);
      await settings.saveActiveSession(running('s9', 'c9', 3));

      await exportService.importFromJson(data.toJsonString());

      expect(settings.getActiveSession('c1'), isNull);
      expect(settings.getActiveSession('c9'), isNull);
      expect(settings.getActiveSession('c2')!.tapCount, 7);
    });

    test('an old backup clears running counts and keeps settings', () async {
      await seed();
      const old = ExportData(exportDate: 1, counters: [c1], sessions: []);

      await exportService.importFromJson(old.toJsonString());

      expect(settings.getAllActiveSessions(), isEmpty);
      expect(settings.meruPauseEnabled, isTrue);
      expect(settings.languageCode, 'ml');
    });

    test('selected import keeps settings and other running counts', () async {
      await seed();
      final json = (await exportService.buildExportData()).toJsonString();
      await freshPhone();
      await settings.setLanguageCode('sa');
      await repo.insertCounter(c1);
      await settings.saveActiveSession(running('s5', 'c1', 3));

      await exportService.importSelectedFromJson(json, ['c2']);

      expect(settings.languageCode, 'sa');
      expect(settings.meruPauseEnabled, isFalse);
      expect(settings.getActiveSession('c1')!.tapCount, 3);
      expect(settings.getActiveSession('c2')!.tapCount, 7);
    });

    test('a chosen counter gets the running count from the file', () async {
      await seed();
      final json = (await exportService.buildExportData()).toJsonString();
      await settings.saveActiveSession(running('s1', 'c1', 99));

      await exportService.importSelectedFromJson(json, ['c1']);

      expect(settings.getActiveSession('c1')!.tapCount, 40);
    });

    String fileWith(Map<String, dynamic> extra) => jsonEncode({
      ...const ExportData(exportDate: 1, counters: [c1], sessions: []).toJson(),
      ...extra,
    });

    Matcher rejected() => throwsA(isA<ValidationException>());

    test('rejects a running count for a counter not in the file', () {
      final json = fileWith({
        'activeSessions': [running('s1', 'c2', 4).toMap()],
      });
      expect(() => exportService.importFromJson(json), rejected());
    });

    test('rejects two running counts for one counter', () {
      final json = fileWith({
        'activeSessions': [
          running('s1', 'c1', 4).toMap(),
          running('s2', 'c1', 5).toMap(),
        ],
      });
      expect(() => exportService.importFromJson(json), rejected());
    });

    test('rejects a running count with a negative tap count', () {
      final json = fileWith({
        'activeSessions': [running('s1', 'c1', -1).toMap()],
      });
      expect(() => exportService.importFromJson(json), rejected());
    });

    test('rejects an unknown language', () {
      final json = fileWith({
        'settings': {'languageCode': 'xx'},
      });
      expect(() => exportService.importFromJson(json), rejected());
    });

    test('rejects a setting with the wrong type', () {
      final json = fileWith({
        'settings': {'meruPauseEnabled': 'yes'},
      });
      expect(() => exportService.importFromJson(json), rejected());
    });

    test('a rejected file leaves settings and running counts alone', () async {
      await seed();
      final json = fileWith({
        'settings': {'languageCode': 'xx'},
      });
      await expectLater(exportService.importFromJson(json), rejected());
      expect(settings.languageCode, 'ml');
      expect(settings.getActiveSession('c1')!.tapCount, 40);
    });
  });
}
