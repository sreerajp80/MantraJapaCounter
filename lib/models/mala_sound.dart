/// Soundscapes available for mala completion (every 108 beads).
enum MalaSound {
  templeBell('temple_bell'),
  singingBowl('singing_bowl'),
  synthesizedTone('synthesized_tone');

  final String id;
  const MalaSound(this.id);

  /// Subpath inside the Flutter asset bundle for bundled acoustic audio files.
  /// Empty string for [synthesizedTone] which uses the native tone synthesizer.
  String get assetPath {
    switch (this) {
      case MalaSound.templeBell:
        return 'audio/temple_bell.wav';
      case MalaSound.singingBowl:
        return 'audio/singing_bowl.wav';
      case MalaSound.synthesizedTone:
        return '';
    }
  }

  /// Deserializes a stored string ID to [MalaSound].
  /// Defaults to [MalaSound.templeBell] when null or unrecognized.
  static MalaSound fromId(String? id) {
    if (id == null) return MalaSound.templeBell;
    return MalaSound.values.firstWhere(
      (e) => e.id == id,
      orElse: () => MalaSound.templeBell,
    );
  }
}
