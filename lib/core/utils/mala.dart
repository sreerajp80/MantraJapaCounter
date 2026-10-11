import 'package:mantra_japa_counter/core/constants/app_constants.dart';

/// Mala number that the given chant count *belongs to* (ceiling).
///
/// With a mala of 108: returns 0 for 0 chants, 1 for chants 1..108, 2 for
/// 109..216. Returns 0 when [malaSize] is 0 (the counter has no mala count).
/// Use this for any user-visible "X mala" label. Do NOT use it for the
/// (malas, chants) split persisted to JapaSession — that must stay as floor
/// division (see [malasOf] / [chantsOf]).
int malaForCount(int count, int malaSize) {
  if (count <= 0 || malaSize <= 0) return 0;
  return ((count - 1) ~/ malaSize) + 1;
}

/// Whole malas in [count] (floor). 0 when there is no mala count.
int malasOf(int count, int malaSize) => malaSize <= 0 ? 0 : count ~/ malaSize;

/// Counts left over after whole malas. All of [count] when there is no mala
/// count, so `malas * malaSize + chants == count` always holds.
int chantsOf(int count, int malaSize) =>
    malaSize <= 0 ? count : count % malaSize;

/// How the counting-screen ring shows progress.
enum MalaRingMode {
  /// Beads fill in whole steps.
  dots,

  /// A smooth arc fills by fraction.
  percent,
}

/// What the ring draws: the [mode], the [beads] to fill in
/// [MalaRingMode.dots] mode, and the [fraction] (0..1) to fill in
/// [MalaRingMode.percent] mode.
class MalaRingFill {
  final MalaRingMode mode;
  final int beads;
  final double fraction;

  const MalaRingFill.dots(this.beads) : mode = MalaRingMode.dots, fraction = 0;

  const MalaRingFill.percent(this.fraction)
    : mode = MalaRingMode.percent,
      beads = 0;
}

/// Ring fill for [inMala] counts done in the current mala of [malaSize].
///
/// The ring has [AppConstants.ringBeads] (108) beads. When the mala count
/// divides 108, each count fills `108 / malaSize` beads. When it is a
/// multiple of 108, every `malaSize / 108` counts fill one bead. Any other
/// mala count uses a smooth percentage arc.
MalaRingFill malaRingFill(int inMala, int malaSize) {
  const ring = AppConstants.ringBeads;
  if (malaSize <= 0) return const MalaRingFill.percent(0);
  final n = inMala.clamp(0, malaSize);
  if (ring % malaSize == 0) return MalaRingFill.dots(n * (ring ~/ malaSize));
  if (malaSize % ring == 0) return MalaRingFill.dots(n ~/ (malaSize ~/ ring));
  return MalaRingFill.percent(n / malaSize);
}

/// Ring fill for a counter with no mala count: today's count against the
/// daily goal, else the lifetime count against the lifetime goal, else an
/// empty ring.
MalaRingFill noMalaRingFill({
  required int todayCount,
  required int dailyGoal,
  required int lifetimeCount,
  required int lifetimeGoal,
}) {
  if (dailyGoal > 0) {
    return MalaRingFill.percent((todayCount / dailyGoal).clamp(0.0, 1.0));
  }
  if (lifetimeGoal > 0) {
    return MalaRingFill.percent((lifetimeCount / lifetimeGoal).clamp(0.0, 1.0));
  }
  return const MalaRingFill.percent(0);
}
