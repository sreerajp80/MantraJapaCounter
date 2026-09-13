import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';

void main() {
  group('MalaSound enum', () {
    test('fromId returns corresponding enum', () {
      expect(MalaSound.fromId('temple_bell'), equals(MalaSound.templeBell));
      expect(MalaSound.fromId('singing_bowl'), equals(MalaSound.singingBowl));
      expect(
        MalaSound.fromId('synthesized_tone'),
        equals(MalaSound.synthesizedTone),
      );
    });

    test('fromId defaults to templeBell for null or unknown id', () {
      expect(MalaSound.fromId(null), equals(MalaSound.templeBell));
      expect(MalaSound.fromId('unknown'), equals(MalaSound.templeBell));
      expect(MalaSound.fromId(''), equals(MalaSound.templeBell));
    });

    test('assetPath returns proper audio path or empty string', () {
      expect(MalaSound.templeBell.assetPath, equals('audio/temple_bell.wav'));
      expect(MalaSound.singingBowl.assetPath, equals('audio/singing_bowl.wav'));
      expect(MalaSound.synthesizedTone.assetPath, isEmpty);
    });
  });
}
