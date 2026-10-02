import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/counter_stats_provider.dart';
import 'package:mantra_japa_counter/providers/current_day_provider.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';

void main() {
  group('CurrentDayNotifier', () {
    test('holds the local date without the time part', () {
      final container = ProviderContainer(
        overrides: [
          clockProvider.overrideWithValue(() => DateTime(2026, 10, 2, 23, 59)),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(currentDayProvider), DateTime(2026, 10, 2));
    });

    test('refresh changes the state only when the date changes', () {
      var now = DateTime(2026, 10, 2, 8);
      final container = ProviderContainer(
        overrides: [clockProvider.overrideWithValue(() => now)],
      );
      addTearDown(container.dispose);

      final seen = <DateTime>[];
      container.listen(currentDayProvider, (_, next) => seen.add(next));

      now = DateTime(2026, 10, 2, 22); // same day, later time
      container.read(currentDayProvider.notifier).refresh();
      expect(seen, isEmpty);

      now = DateTime(2026, 10, 3, 0, 0, 1); // next day
      container.read(currentDayProvider.notifier).refresh();
      expect(seen, [DateTime(2026, 10, 3)]);
    });
  });

  group('counter stats on a new day', () {
    late Directory tempDir;
    late Database db;

    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('japa_current_day_test');
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
        'dailyGoal': 108,
        'startDate': 0,
        'createdAt': 100,
        'status': 'ACTIVE',
      });
      await db.insert('japa_sessions', {
        'id': 's1',
        'counterId': 'c1',
        'counterName': 'Om Namah Shivaya',
        'count': 108,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    });

    tearDown(() async {
      await db.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'today stats re-read from the database when the day changes',
      () async {
        var now = DateTime(2026, 10, 2, 21);
        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(db),
            clockProvider.overrideWithValue(() => now),
          ],
        );
        addTearDown(container.dispose);
        // Keep the autoDispose providers alive, like the home screen does.
        container.listen(counterStatsProvider('c1'), (_, _) {});
        container.listen(todayAggregateProvider, (_, _) {});

        expect(
          (await container.read(counterStatsProvider('c1').future)).todayCount,
          108,
        );
        expect(
          (await container.read(todayAggregateProvider.future)).chants,
          108,
        );

        // Yesterday's session is no longer "today" in the database.
        await db.delete('japa_sessions');

        // Same day: cached values are kept.
        container.read(currentDayProvider.notifier).refresh();
        expect(
          (await container.read(counterStatsProvider('c1').future)).todayCount,
          108,
        );

        // Next day: the providers re-run and show fresh numbers.
        now = DateTime(2026, 10, 3, 6);
        container.read(currentDayProvider.notifier).refresh();
        expect(
          (await container.read(counterStatsProvider('c1').future)).todayCount,
          0,
        );
        expect((await container.read(todayAggregateProvider.future)).chants, 0);
      },
    );
  });
}
