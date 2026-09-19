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

    test(
      'importFromJson detects encrypted content and throws EncryptedExportException',
      () async {
        const plaintext = '{"counters":[],"sessions":[],"exportDate":123}';
        final encrypted = await encryptionService.encrypt(
          plaintext,
          'secretKey123',
        );

        expect(
          () => exportService.importFromJson(encrypted),
          throwsA(isA<EncryptedExportException>()),
        );
      },
    );

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
}
