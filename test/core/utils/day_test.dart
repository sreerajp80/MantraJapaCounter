import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/utils/day.dart';

void main() {
  group('isEarlierLocalDay', () {
    int ms(int y, int m, int d, [int h = 0, int min = 0]) =>
        DateTime(y, m, d, h, min).millisecondsSinceEpoch;

    test('same day is not earlier', () {
      expect(
        isEarlierLocalDay(ms(2026, 10, 6, 0, 1), ms(2026, 10, 6, 23)),
        isFalse,
      );
    });

    test('one minute before midnight is earlier', () {
      expect(
        isEarlierLocalDay(ms(2026, 10, 5, 23, 59), ms(2026, 10, 6)),
        isTrue,
      );
    });

    test('a later day is not earlier', () {
      expect(isEarlierLocalDay(ms(2026, 10, 7), ms(2026, 10, 6)), isFalse);
    });

    test('across a month and year change', () {
      expect(
        isEarlierLocalDay(ms(2026, 12, 31, 22), ms(2027, 1, 1, 1)),
        isTrue,
      );
    });
  });
}
