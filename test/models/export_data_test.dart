import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/models/export_data.dart';
import 'package:mantra_japa_counter/models/japa_session.dart';

void main() {
  group('ExportData JSON round-trip', () {
    final data = ExportData(
      exportVersion: 1,
      exportDate: 1700000000000,
      counters: [
        Counter(id: 'c1', name: 'Gayatri', startDate: 1000, createdAt: 1000),
      ],
      sessions: [
        const JapaSession(
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
      final json = '{"counters":[],"sessions":[]}';
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
}
