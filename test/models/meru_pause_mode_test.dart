import 'package:flutter_test/flutter_test.dart';

import 'package:mantra_japa_counter/models/meru_pause_mode.dart';

void main() {
  group('MeruPauseMode', () {
    test('fromId reads back every mode by its id', () {
      for (final mode in MeruPauseMode.values) {
        expect(MeruPauseMode.fromId(mode.id), mode);
      }
    });

    test('null or unknown ids fall back to time', () {
      expect(MeruPauseMode.fromId(null), MeruPauseMode.time);
      expect(MeruPauseMode.fromId(''), MeruPauseMode.time);
      expect(MeruPauseMode.fromId('beads'), MeruPauseMode.time);
    });

    test('stored ids stay stable', () {
      expect(MeruPauseMode.time.id, 'time');
      expect(MeruPauseMode.taps.id, 'taps');
    });
  });
}
