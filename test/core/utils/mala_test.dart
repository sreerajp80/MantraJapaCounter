import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/utils/mala.dart';

void main() {
  group('malaForCount', () {
    test('zero chants → 0 mala', () {
      expect(malaForCount(0, 108), 0);
    });

    test('negative input → 0 mala', () {
      expect(malaForCount(-5, 108), 0);
    });

    test('first chant → mala 1', () {
      expect(malaForCount(1, 108), 1);
    });

    test('108 chants (boundary) → mala 1', () {
      expect(malaForCount(108, 108), 1);
    });

    test('109 chants (just past boundary) → mala 2', () {
      expect(malaForCount(109, 108), 2);
    });

    test('216 chants → mala 2', () {
      expect(malaForCount(216, 108), 2);
    });

    test('217 chants → mala 3', () {
      expect(malaForCount(217, 108), 3);
    });

    test('exact mala multiple → that mala number', () {
      expect(malaForCount(2700, 108), 25);
    });

    test('one past exact mala → next mala', () {
      expect(malaForCount(2701, 108), 26);
    });

    test('daily goal 2,500 → 24 mala', () {
      expect(malaForCount(2500, 108), 24);
    });

    test('lifetime goal 1,200,000 → 11,112 mala', () {
      expect(malaForCount(1200000, 108), 11112);
    });
  });

  group('custom mala count', () {
    test('malaForCount uses the given size; 0 means no mala', () {
      expect(malaForCount(5, 5), 1);
      expect(malaForCount(6, 5), 2);
      expect(malaForCount(100, 0), 0);
    });

    test('malasOf / chantsOf keep malas * size + chants == count', () {
      expect(malasOf(13, 5), 2);
      expect(chantsOf(13, 5), 3);
      expect(malasOf(13, 0), 0);
      expect(chantsOf(13, 0), 13);
    });
  });

  group('malaRingFill', () {
    test('mala 1: one tap fills all 108 beads', () {
      final f = malaRingFill(1, 1);
      expect(f.mode, MalaRingMode.dots);
      expect(f.beads, 108);
    });

    test('mala 2: one tap fills 54 beads', () {
      final f = malaRingFill(1, 2);
      expect(f.mode, MalaRingMode.dots);
      expect(f.beads, 54);
    });

    test('mala 27: each tap fills 4 beads', () {
      expect(malaRingFill(10, 27).beads, 40);
    });

    test('mala 108: one bead per tap', () {
      final f = malaRingFill(50, 108);
      expect(f.mode, MalaRingMode.dots);
      expect(f.beads, 50);
    });

    test('mala 216: two taps fill one bead', () {
      expect(malaRingFill(1, 216).beads, 0);
      expect(malaRingFill(2, 216).beads, 1);
      expect(malaRingFill(215, 216).beads, 107);
    });

    test('mala 5, 100 and 360 use the percentage arc', () {
      for (final size in [5, 100, 360]) {
        expect(malaRingFill(0, size).mode, MalaRingMode.percent);
      }
      expect(malaRingFill(2, 5).fraction, closeTo(0.4, 1e-9));
      expect(malaRingFill(180, 360).fraction, closeTo(0.5, 1e-9));
    });
  });

  group('noMalaRingFill', () {
    test('uses the daily goal first', () {
      final f = noMalaRingFill(
        todayCount: 2,
        dailyGoal: 5,
        lifetimeCount: 50,
        lifetimeGoal: 100,
      );
      expect(f.mode, MalaRingMode.percent);
      expect(f.fraction, closeTo(0.4, 1e-9));
    });

    test('falls back to the lifetime goal', () {
      final f = noMalaRingFill(
        todayCount: 2,
        dailyGoal: 0,
        lifetimeCount: 25,
        lifetimeGoal: 100,
      );
      expect(f.fraction, closeTo(0.25, 1e-9));
    });

    test('is empty with no goals, and never above full', () {
      expect(
        noMalaRingFill(
          todayCount: 9,
          dailyGoal: 0,
          lifetimeCount: 9,
          lifetimeGoal: 0,
        ).fraction,
        0,
      );
      expect(
        noMalaRingFill(
          todayCount: 9,
          dailyGoal: 5,
          lifetimeCount: 9,
          lifetimeGoal: 0,
        ).fraction,
        1,
      );
    });
  });
}
