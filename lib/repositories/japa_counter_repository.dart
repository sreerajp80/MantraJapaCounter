import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../models/counter.dart';
import '../models/daily_summary.dart';
import '../models/export_data.dart';
import '../models/japa_session.dart';

/// All sqflite access for counters and sessions.
///
/// Widgets and services must not reference SQL, table names, or column names
/// directly — they go through this repository.
class JapaCounterRepository {
  final Database _db;

  JapaCounterRepository(this._db);

  // ──────────────────────────── Schema ────────────────────────────────────────

  static Future<void> onCreate(Database db, int version) async {
    await _createV1(db);
    await _createV2(db);
    await _createV3(db);
    await _createV4(db);
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) await _createV2(db);
    if (oldVersion < 3) await _createV3(db);
    if (oldVersion < 4) await _createV4(db);
  }

  static Future<void> _createV1(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS counters (
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

  static Future<void> _createV2(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS japa_sessions (
        id TEXT PRIMARY KEY NOT NULL,
        counterId TEXT NOT NULL,
        counterName TEXT NOT NULL,
        count INTEGER NOT NULL,
        timestamp INTEGER NOT NULL,
        duration INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (counterId) REFERENCES counters(id) ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sessions_counterId ON japa_sessions(counterId)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_sessions_timestamp ON japa_sessions(timestamp)',
    );
  }

  static Future<void> _createV3(Database db) async {
    // Add malas and chants columns to japa_sessions
    await _addColumnIfMissing(
      db,
      'japa_sessions',
      'malas',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _addColumnIfMissing(
      db,
      'japa_sessions',
      'chants',
      'INTEGER NOT NULL DEFAULT 0',
    );
    // Add disabledAt and disabledReason columns to counters
    await _addColumnIfMissing(db, 'counters', 'disabledAt', 'INTEGER');
    await _addColumnIfMissing(db, 'counters', 'disabledReason', 'TEXT');
  }

  static Future<void> _createV4(Database db) async {
    // Add isLocked column to counters
    await _addColumnIfMissing(
      db,
      'counters',
      'isLocked',
      'INTEGER NOT NULL DEFAULT 0',
    );
  }

  static Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) async {
    final cols = await db.rawQuery('PRAGMA table_info($table)');
    final exists = cols.any((c) => c['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
    }
  }

  // ──────────────────────────── Counter CRUD ──────────────────────────────────

  Future<List<Counter>> getAllCounters() async {
    final rows = await _db.query('counters', orderBy: 'createdAt DESC');
    return rows.map(Counter.fromMap).toList();
  }

  /// Stream of all counters. Re-emits on every mutation via the returned
  /// [StreamController]. Callers must call [watchCounters] and listen.
  Stream<List<Counter>> watchCounters() {
    final controller = StreamController<List<Counter>>.broadcast();
    _refreshCounterStream(controller);
    return controller.stream;
  }

  Future<void> _refreshCounterStream(StreamController<List<Counter>> c) async {
    c.add(await getAllCounters());
  }

  Future<Counter?> getCounterById(String id) async {
    final rows = await _db.query('counters', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Counter.fromMap(rows.first);
  }

  Future<void> insertCounter(Counter counter) async {
    await _db.insert(
      'counters',
      counter.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCounter(Counter counter) async {
    await _db.update(
      'counters',
      counter.toMap(),
      where: 'id = ?',
      whereArgs: [counter.id],
    );
  }

  Future<void> deleteCounter(String id) async {
    await _db.delete('counters', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllCounters() async {
    await _db.delete('counters');
  }

  // ──────────────────────────── Session CRUD ──────────────────────────────────

  Future<List<JapaSession>> getAllSessions() async {
    final rows = await _db.query('japa_sessions', orderBy: 'timestamp DESC');
    return rows.map(JapaSession.fromMap).toList();
  }

  Future<List<JapaSession>> getSessionsByCounterId(String counterId) async {
    final rows = await _db.query(
      'japa_sessions',
      where: 'counterId = ?',
      whereArgs: [counterId],
      orderBy: 'timestamp DESC',
    );
    return rows.map(JapaSession.fromMap).toList();
  }

  Future<JapaSession?> getSessionById(String id) async {
    final rows = await _db.query(
      'japa_sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return JapaSession.fromMap(rows.first);
  }

  Future<void> insertSession(JapaSession session) async {
    await _db.insert(
      'japa_sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSession(JapaSession session) async {
    await _db.update(
      'japa_sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<void> deleteSession(String id) async {
    await _db.delete('japa_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllSessions() async {
    await _db.delete('japa_sessions');
  }

  Future<void> deleteSessionsByCounterId(String counterId) async {
    await _db.delete(
      'japa_sessions',
      where: 'counterId = ?',
      whereArgs: [counterId],
    );
  }

  // ──────────────────────────── Aggregation ───────────────────────────────────

  Future<int> getTotalCountForCounter(String counterId) async {
    final result = await _db.rawQuery(
      'SELECT SUM(count) as total FROM japa_sessions WHERE counterId = ?',
      [counterId],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  Future<int> getTodayCountForCounter(String counterId) async {
    final todayStart = _todayStartMs();
    final result = await _db.rawQuery(
      'SELECT SUM(count) as total FROM japa_sessions WHERE counterId = ? AND timestamp >= ?',
      [counterId, todayStart],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  Future<double> getAverageDailyCountForCounter(
    String counterId,
    int startDateMs,
  ) async {
    final rows = await _db.query(
      'japa_sessions',
      where: 'counterId = ? AND timestamp >= ?',
      whereArgs: [counterId, startDateMs],
    );
    if (rows.isEmpty) return 0.0;
    final sessions = rows.map(JapaSession.fromMap).toList();

    final dailyCounts = <String, int>{};
    for (final s in sessions) {
      final dt = DateTime.fromMillisecondsSinceEpoch(s.timestamp);
      final key = '${dt.year}-${dt.month}-${dt.day}';
      dailyCounts[key] = (dailyCounts[key] ?? 0) + s.count;
    }

    final total = dailyCounts.values.fold(0, (a, b) => a + b);
    return dailyCounts.isEmpty ? 0.0 : total / dailyCounts.length;
  }

  // ──────────────────────────── History ───────────────────────────────────────

  /// Groups all sessions (or sessions for [counterId]) into [DailySummary] list.
  Future<List<DailySummary>> getDailySummaries({String? counterId}) async {
    final List<JapaSession> sessions;
    if (counterId != null) {
      sessions = await getSessionsByCounterId(counterId);
    } else {
      sessions = await getAllSessions();
    }

    final grouped = <String, List<JapaSession>>{};
    for (final s in sessions) {
      final dt = DateTime.fromMillisecondsSinceEpoch(s.timestamp);
      final key = _formatDate(dt);
      grouped.putIfAbsent(key, () => []).add(s);
    }

    return grouped.entries.map((e) {
      final total = e.value.fold(0, (sum, s) => sum + s.count);
      final duration = e.value.fold(0, (sum, s) => sum + s.duration);
      return DailySummary(
        date: e.key,
        totalCount: total,
        totalDuration: duration,
        sessions: e.value,
      );
    }).toList();
  }

  // ──────────────────────────── Import / Export ────────────────────────────────

  Future<ExportData> exportData() async {
    final counters = await getAllCounters();
    final sessions = await getAllSessions();
    return ExportData(
      exportDate: DateTime.now().millisecondsSinceEpoch,
      counters: counters,
      sessions: sessions,
    );
  }

  Future<void> importData(ExportData data) async {
    await _db.transaction((txn) async {
      await txn.delete('japa_sessions');
      await txn.delete('counters');

      final now = DateTime.now().millisecondsSinceEpoch;
      for (final c in data.counters) {
        final fixed = c.startDate == 0
            ? c.copyWith(startDate: c.createdAt > 0 ? c.createdAt : now)
            : c;
        await txn.insert(
          'counters',
          fixed.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      for (final s in data.sessions) {
        await txn.insert(
          'japa_sessions',
          s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // ──────────────────────────── Helpers ───────────────────────────────────────

  static int _todayStartMs() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = dt.day.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} $day, ${dt.year}';
  }
}
