import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/active_session.dart';

void main() {
  group('ActiveSession carried counts', () {
    test('old saved JSON without the new fields reads them as 0', () {
      final s = ActiveSession.fromJson(
        '{"sessionId":"a","counterId":"c1","counterName":"N",'
        '"startTime":1000,"tapCount":40,"incrementStep":1,'
        '"accumulatedMs":5000,"lastResumeTimeMs":1000,"isPaused":true}',
      );
      expect(s.carriedCount, 0);
      expect(s.carriedDurationMs, 0);
      expect(s.rowCount, 40);
      expect(s.rowDuration, 5000);
    });

    test('round-trips through JSON', () {
      const s = ActiveSession(
        sessionId: 'a',
        counterId: 'c1',
        counterName: 'N',
        startTime: 1000,
        tapCount: 70,
        incrementStep: 1,
        accumulatedMs: 9000,
        lastResumeTimeMs: 1000,
        isPaused: true,
        carriedCount: 45,
        carriedDurationMs: 6000,
      );
      final back = ActiveSession.fromJson(s.toJson());
      expect(back.carriedCount, 45);
      expect(back.carriedDurationMs, 6000);
      expect(back.rowCount, 25);
      expect(back.rowDuration, 3000);
    });
  });

  group('malaSize', () {
    ActiveSession make(int taps, int malaSize) => ActiveSession(
      sessionId: 'a',
      counterId: 'c1',
      counterName: 'N',
      startTime: 1000,
      tapCount: taps,
      incrementStep: 1,
      lastResumeTimeMs: 1000,
      malaSize: malaSize,
    );

    test('malas and chants use the custom mala count', () {
      final s = make(60, 27);
      expect(s.malas, 2);
      expect(s.chants, 6);
      expect(s.isMidMala, isTrue);
      expect(make(54, 27).isMidMala, isFalse);
    });

    test('no mala count: no malas, all counts are chants, never mid-mala', () {
      final s = make(60, 0);
      expect(s.hasMala, isFalse);
      expect(s.malas, 0);
      expect(s.chants, 60);
      expect(s.isMidMala, isFalse);
    });

    test('round-trips malaSize; old saved JSON means 108', () {
      expect(ActiveSession.fromJson(make(3, 5).toJson()).malaSize, 5);
      final map = make(3, 5).toMap()..remove('malaSize');
      expect(ActiveSession.fromMap(map).malaSize, 108);
    });
  });
}
