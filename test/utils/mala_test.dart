import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/utils/mala.dart';

void main() {
  group('malaForCount', () {
    test('zero chants → 0 mala', () {
      expect(malaForCount(0), 0);
    });

    test('negative input → 0 mala', () {
      expect(malaForCount(-5), 0);
    });

    test('first chant → mala 1', () {
      expect(malaForCount(1), 1);
    });

    test('108 chants (boundary) → mala 1', () {
      expect(malaForCount(108), 1);
    });

    test('109 chants (just past boundary) → mala 2', () {
      expect(malaForCount(109), 2);
    });

    test('216 chants → mala 2', () {
      expect(malaForCount(216), 2);
    });

    test('217 chants → mala 3', () {
      expect(malaForCount(217), 3);
    });

    test('exact mala multiple → that mala number', () {
      expect(malaForCount(2700), 25);
    });

    test('one past exact mala → next mala', () {
      expect(malaForCount(2701), 26);
    });

    test('daily goal 2,500 → 24 mala', () {
      expect(malaForCount(2500), 24);
    });

    test('lifetime goal 1,200,000 → 11,112 mala', () {
      expect(malaForCount(1200000), 11112);
    });
  });
}
