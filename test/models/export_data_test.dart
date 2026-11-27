import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/active_session.dart';
import 'package:mantra_japa_counter/models/backup_settings.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';

void main() {
  group('ExportData JSON round-trip', () {
    const data = ExportData(
      exportDate: 1700000000000,
      counters: [
        Counter(id: 'c1', name: 'Gayatri', startDate: 1000, createdAt: 1000),
      ],
      sessions: [
        JapaSession(
          id: 's1',
          counterId: 'c1',
          counterName: 'Gayatri',
          count: 108,
          malas: 1,
          chants: 0,
          timestamp: 1700000000000,
          duration: 600000,
        ),
      ],
    );

    test('toJsonString / fromJsonString round-trip', () {
      final json = data.toJsonString();
      final restored = ExportData.fromJsonString(json);

      expect(restored.counters.length, 1);
      expect(restored.counters.first.name, 'Gayatri');
      expect(restored.sessions.length, 1);
      expect(restored.sessions.first.malas, 1);
    });

    test('fromJson tolerates missing exportVersion', () {
      const json = '{"counters":[],"sessions":[]}';
      final d = ExportData.fromJsonString(json);
      expect(d.exportVersion, 1);
      expect(d.counters, isEmpty);
    });

    test('fromJson throws on malformed JSON', () {
      expect(
        () => ExportData.fromJsonString('{bad json'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('ExportData settings and running counts', () {
    const running = ActiveSession(
      sessionId: 's1',
      counterId: 'c1',
      counterName: 'Gayatri',
      startTime: 1000,
      tapCount: 50,
      incrementStep: 1,
      accumulatedMs: 9000,
      lastResumeTimeMs: 1000,
      isPaused: true,
    );

    test('a file without them reads as no settings, no running counts', () {
      final d = ExportData.fromJsonString('{"counters":[],"sessions":[]}');
      expect(d.settings, isNull);
      expect(d.activeSessions, isEmpty);
    });

    test('they are left out of the JSON when empty', () {
      const d = ExportData(exportDate: 1, counters: [], sessions: []);
      final json = d.toJson();
      expect(json.containsKey('settings'), isFalse);
      expect(json.containsKey('activeSessions'), isFalse);
    });

    test('round-trip keeps settings and running counts', () {
      const d = ExportData(
        exportDate: 1,
        counters: [],
        sessions: [],
        settings: BackupSettings(meruPauseEnabled: true, languageCode: ''),
        activeSessions: [running],
      );

      final r = ExportData.fromJsonString(d.toJsonString());

      expect(r.exportVersion, 1);
      expect(r.settings!.meruPauseEnabled, isTrue);
      expect(r.settings!.languageCode, '');
      expect(r.activeSessions, hasLength(1));
      expect(r.activeSessions.first.tapCount, 50);
      expect(r.activeSessions.first.accumulatedMs, 9000);
      expect(r.activeSessions.first.isPaused, isTrue);
    });
  });
}
