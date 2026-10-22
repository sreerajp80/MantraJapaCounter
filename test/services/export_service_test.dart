import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';
import 'package:mantra_japa_counter/services/export_service.dart';

void main() {
  late Database db;
  late JapaCounterRepository repo;
  late EncryptionService encryptionService;
  late ExportService exportService;

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
    exportService = ExportService(repo, encryptionService);
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
}
