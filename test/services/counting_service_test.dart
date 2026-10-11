import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/services/counting_service.dart';

void main() {
  group('Mala calculation', () {
    test('0 counts = 0 malas, 0 chants', () {
      expect(CountingService.calculateMalas(0, 108), 0);
      expect(CountingService.calculateChants(0, 108), 0);
    });

    test('107 counts = 0 malas, 107 chants', () {
      expect(CountingService.calculateMalas(107, 108), 0);
      expect(CountingService.calculateChants(107, 108), 107);
    });

    test('108 counts = 1 mala, 0 chants', () {
      expect(CountingService.calculateMalas(108, 108), 1);
      expect(CountingService.calculateChants(108, 108), 0);
    });

    test('216 counts = 2 malas, 0 chants', () {
      expect(CountingService.calculateMalas(216, 108), 2);
      expect(CountingService.calculateChants(216, 108), 0);
    });

    test('217 counts = 2 malas, 1 chant', () {
      expect(CountingService.calculateMalas(217, 108), 2);
      expect(CountingService.calculateChants(217, 108), 1);
    });

    test('1080 counts = 10 malas', () {
      expect(CountingService.calculateMalas(1080, 108), 10);
    });

    test('100000 counts integer division', () {
      expect(CountingService.calculateMalas(100000, 108), 100000 ~/ 108);
    });
  });

  group('custom mala count', () {
    test('mala of 27', () {
      expect(CountingService.calculateMalas(60, 27), 2);
      expect(CountingService.calculateChants(60, 27), 6);
    });

    test('no mala count', () {
      expect(CountingService.calculateMalas(60, 0), 0);
      expect(CountingService.calculateChants(60, 0), 60);
    });
  });
}
