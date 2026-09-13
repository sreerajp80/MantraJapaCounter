import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';

void main() {
  late Database db;
  late JapaCounterRepository repo;

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
  });

  tearDown(() async {
    await db.close();
  });

  group('JapaCounterRepository Selective Export & Import', () {
    const counter1 = Counter(
      id: 'c1',
      name: 'Gayatri Mantra',
      initialCount: 108,
      goal: 1000,
      dailyGoal: 108,
      startDate: 1000,
      createdAt: 1000,
    );

    const counter2 = Counter(
      id: 'c2',
      name: 'Maha Mrityunjaya',
      initialCount: 54,
      goal: 500,
      dailyGoal: 54,
      startDate: 2000,
      createdAt: 2000,
    );

    const session1 = JapaSession(
      id: 's1',
      counterId: 'c1',
      counterName: 'Gayatri Mantra',
      count: 108,
      timestamp: 1005,
      duration: 60,
      malas: 1,
      chants: 0,
    );

    const session2 = JapaSession(
      id: 's2',
      counterId: 'c2',
      counterName: 'Maha Mrityunjaya',
      count: 54,
      timestamp: 2005,
      duration: 30,
      malas: 0,
      chants: 54,
    );

    test('exportSelectedData returns only specified counters and their sessions', () async {
      await repo.insertCounter(counter1);
      await repo.insertCounter(counter2);
      await repo.insertSession(session1);
      await repo.insertSession(session2);

      final exported = await repo.exportSelectedData(['c1']);

      expect(exported.counters.length, equals(1));
      expect(exported.counters.first.id, equals('c1'));
      expect(exported.counters.first.name, equals('Gayatri Mantra'));

      expect(exported.sessions.length, equals(1));
      expect(exported.sessions.first.id, equals('s1'));
      expect(exported.sessions.first.counterId, equals('c1'));
    });

    test('exportSelectedData with empty list returns all data', () async {
      await repo.insertCounter(counter1);
      await repo.insertCounter(counter2);

      final exported = await repo.exportSelectedData([]);
      expect(exported.counters.length, equals(2));
    });

    test('importSelectedData merges selected counters without deleting existing counters', () async {
      // Existing state on device: has c1
      await repo.insertCounter(counter1);
      await repo.insertSession(session1);

      // Incoming payload: has c2 and an updated c1
      final updatedCounter1 = counter1.copyWith(name: 'Gayatri Mantra Updated', initialCount: 216);
      final importPayload = ExportData(
        exportDate: 5000,
        counters: [updatedCounter1, counter2],
        sessions: [session1, session2],
      );

      // Selectively import only c2
      await repo.importSelectedData(importPayload, ['c2']);

      final allCounters = await repo.getAllCounters();
      expect(allCounters.length, equals(2));
      // c1 should remain untouched with original name
      final foundC1 = allCounters.firstWhere((c) => c.id == 'c1');
      expect(foundC1.name, equals('Gayatri Mantra'));
      expect(foundC1.initialCount, equals(108));

      // c2 was imported
      final foundC2 = allCounters.firstWhere((c) => c.id == 'c2');
      expect(foundC2.name, equals('Maha Mrityunjaya'));

      final allSessions = await repo.getAllSessions();
      expect(allSessions.length, equals(2));
    });

    test('importSelectedData updates existing counter when selected', () async {
      await repo.insertCounter(counter1);

      final updatedCounter1 = counter1.copyWith(name: 'Gayatri Mantra New Name');
      final importPayload = ExportData(
        exportDate: 5000,
        counters: [updatedCounter1],
        sessions: [session1],
      );

      // Selectively import c1
      await repo.importSelectedData(importPayload, ['c1']);

      final allCounters = await repo.getAllCounters();
      expect(allCounters.length, equals(1));
      expect(allCounters.first.name, equals('Gayatri Mantra New Name'));
    });
  });
}
