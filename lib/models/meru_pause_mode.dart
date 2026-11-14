/// How the Meru pause after each mala ends.
enum MeruPauseMode {
  /// The pause ends after a set number of seconds.
  time('time'),

  /// The pause ends after a set number of taps. Those taps are not counted.
  taps('taps');

  final String id;
  const MeruPauseMode(this.id);

  /// Reads a stored id. Null or unknown ids fall back to [MeruPauseMode.time].
  static MeruPauseMode fromId(String? id) {
    return MeruPauseMode.values.firstWhere(
      (e) => e.id == id,
      orElse: () => MeruPauseMode.time,
    );
  }
}
