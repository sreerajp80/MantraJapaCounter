import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/repositories/japa_counter_repository.dart';

/// Database migration tests (v1 → v2 → v3 → v4).
///
/// These guard the "zero data loss" rule: a user upgrading from any older
/// schema must end up with the same tables and columns as a fresh install,
/// and must keep the rows they already had.
///
/// The old schemas below are written out as raw SQL on purpose. They are a
/// frozen record of what each shipped version actually looked like, so a later
/// edit to the repository cannot quietly rewrite history and still pass.
void main() {
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('japa_migration_test');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  // ───────────────────────── historical schemas ─────────────────────────────

  Future<void> createV1Schema(Database db) async {
    await db.execute('''
      CREATE TABLE counters (
        id TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        initialCount INTEGER NOT NULL DEFAULT 0,
        incrementStep INTEGER NOT NULL DEFAULT 1,
        goal INTEGER NOT NULL DEFAULT 0,
        dailyGoal INTEGER NOT NULL DEFAULT 0,
        startDate INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'ACTIVE'
      )
    ''');
  }

  Future<void> createV2Schema(Database db) async {
    await createV1Schema(db);
    await db.execute('''
      CREATE TABLE japa_sessions (
        id TEXT PRIMARY KEY NOT NULL,
        counterId TEXT NOT NULL,
        counterName TEXT NOT NULL,
        count INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        duration INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (counterId) REFERENCES counters(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> createV3Schema(Database db) async {
    await createV2Schema(db);
    await db.execute(
      'ALTER TABLE japa_sessions ADD COLUMN malas '
      'INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute(
      'ALTER TABLE japa_sessions ADD COLUMN chants '
      'INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute('ALTER TABLE counters ADD COLUMN disabledAt INTEGER');
    await db.execute('ALTER TABLE counters ADD COLUMN disabledReason TEXT');
  }

  final historicalSchemas = <int, Future<void> Function(Database)>{
    1: createV1Schema,
    2: createV2Schema,
    3: createV3Schema,
  };

  // ───────────────────────────── helpers ────────────────────────────────────

  /// Column names of [table], read straight from SQLite.
  Future<Set<String>> columnsOf(Database db, String table) async {
    final rows = await db.rawQuery('PRAGMA table_info($table)');
    return rows.map((r) => r['name'] as String).toSet();
  }

  Future<Set<String>> tablesOf(Database db) async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    return rows.map((r) => r['name'] as String).toSet();
  }

  /// Creates a real on-disk database carrying the [from] schema, runs [seed]
  /// against it, then reopens it at the current version so `onUpgrade` runs.
  ///
  /// A file is used rather than `:memory:` because an in-memory database is
  /// discarded on close, which would defeat the point of an upgrade test.
  Future<Database> upgradeFrom(
    int from,
    Future<void> Function(Database db) seed,
  ) async {
    final path = '${tempDir.path}/japa_v$from.db';

    final old = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: from,
        onCreate: (db, _) async => historicalSchemas[from]!(db),
      ),
    );
    await seed(old);
    await old.close();

    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: JapaCounterRepository.onCreate,
        onUpgrade: JapaCounterRepository.onUpgrade,
      ),
    );
  }

  /// A fresh install at the current schema version.
  Future<Database> openFresh() {
    return databaseFactory.openDatabase(
      '${tempDir.path}/japa_fresh.db',
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: JapaCounterRepository.onCreate,
        onUpgrade: JapaCounterRepository.onUpgrade,
      ),
    );
  }

  const counterRow = {
    'id': 'c1',
    'name': 'Om Namah Shivaya',
    'initialCount': 0,
    'incrementStep': 1,
    'goal': 0,
    'dailyGoal': 0,
    'startDate': 0,
    'createdAt': 100,
    'status': 'ACTIVE',
  };

  // ────────────────────────────── tests ─────────────────────────────────────

  group('schema version', () {
    test('AppConstants.dbVersion covers the newest migration step', () async {
      // If a _createVN is added without bumping dbVersion, onUpgrade never runs
      // for existing users and their database silently falls behind a fresh
      // install. This test is the guard against that.
      final db = await openFresh();
      addTearDown(db.close);

      expect(
        await columnsOf(db, 'counters'),
        contains('isLocked'),
        reason: 'isLocked arrives in _createV4',
      );
      expect(AppConstants.dbVersion, greaterThanOrEqualTo(4));
    });
  });

  group('fresh install (onCreate)', () {
    test('creates both tables', () async {
      final db = await openFresh();
      addTearDown(db.close);
      expect(await tablesOf(db), containsAll(['counters', 'japa_sessions']));
    });

    test('counters has every column through v4', () async {
      final db = await openFresh();
      addTearDown(db.close);
      expect(
        await columnsOf(db, 'counters'),
        containsAll([
          'id',
          'name',
          'initialCount',
          'incrementStep',
          'goal',
          'dailyGoal',
          'startDate',
          'createdAt',
          'status',
          'disabledAt', // v3
          'disabledReason', // v3
          'isLocked', // v4
        ]),
      );
    });

    test('japa_sessions has every column through v3', () async {
      final db = await openFresh();
      addTearDown(db.close);
      expect(
        await columnsOf(db, 'japa_sessions'),
        containsAll([
          'id',
          'counterId',
          'counterName',
          'count',
          'timestamp',
          'duration',
          'malas', // v3
          'chants', // v3
        ]),
      );
    });
  });

  group('upgrades', () {
    test('v1 → current adds japa_sessions and all later columns', () async {
      final db = await upgradeFrom(1, (old) async {
        // A v1 database has counters only.
        expect(await tablesOf(old), isNot(contains('japa_sessions')));
        await old.insert('counters', counterRow);
      });
      addTearDown(db.close);

      expect(await tablesOf(db), containsAll(['counters', 'japa_sessions']));
      expect(
        await columnsOf(db, 'counters'),
        containsAll(['disabledAt', 'disabledReason', 'isLocked']),
      );
      expect(
        await columnsOf(db, 'japa_sessions'),
        containsAll(['malas', 'chants']),
      );

      // The pre-existing row survives, and the new column takes its default.
      final rows = await db.query('counters');
      expect(rows, hasLength(1));
      expect(rows.single['id'], 'c1');
      expect(rows.single['name'], 'Om Namah Shivaya');
      expect(rows.single['isLocked'], 0);
    });

    test('v2 → current keeps sessions and adds v3/v4 columns', () async {
      final db = await upgradeFrom(2, (old) async {
        await old.insert('counters', counterRow);
        await old.insert('japa_sessions', {
          'id': 's1',
          'counterId': 'c1',
          'counterName': 'Om Namah Shivaya',
          'count': 108,
          'timestamp': 500,
          'duration': 60,
        });
      });
      addTearDown(db.close);

      final sessions = await db.query('japa_sessions');
      expect(sessions, hasLength(1));
      expect(sessions.single['count'], 108);
      // v3 columns default to 0 for rows written before the migration.
      expect(sessions.single['malas'], 0);
      expect(sessions.single['chants'], 0);
      expect(await columnsOf(db, 'counters'), contains('isLocked'));
    });

    test('v3 → current adds isLocked defaulting to unlocked', () async {
      final db = await upgradeFrom(3, (old) async {
        expect(await columnsOf(old, 'counters'), isNot(contains('isLocked')));
        await old.insert('counters', counterRow);
      });
      addTearDown(db.close);

      final rows = await db.query('counters');
      expect(rows, hasLength(1));
      expect(
        rows.single['isLocked'],
        0,
        reason: 'existing counters must not come back locked',
      );
    });

    test('an upgraded v1 database matches a fresh install', () async {
      // The whole point of the migration chain: however you got here, the
      // schema must be identical.
      final upgraded = await upgradeFrom(1, (old) async {});
      addTearDown(upgraded.close);
      final fresh = await openFresh();
      addTearDown(fresh.close);

      expect(
        await columnsOf(upgraded, 'counters'),
        await columnsOf(fresh, 'counters'),
      );
      expect(
        await columnsOf(upgraded, 'japa_sessions'),
        await columnsOf(fresh, 'japa_sessions'),
      );
    });

    test('re-running onUpgrade on a current database is a no-op', () async {
      // Every step is IF NOT EXISTS or guarded by _addColumnIfMissing, so a
      // repeated run must not throw or change the shape.
      final db = await openFresh();
      addTearDown(db.close);

      final before = await columnsOf(db, 'counters');
      await JapaCounterRepository.onUpgrade(db, 1, AppConstants.dbVersion);
      await JapaCounterRepository.onUpgrade(db, 1, AppConstants.dbVersion);
      expect(await columnsOf(db, 'counters'), before);
    });
  });
}
