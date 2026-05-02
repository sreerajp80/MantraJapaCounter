import '../config/app_constants.dart';

/// Mala number that the given chant count *belongs to* (ceiling).
///
/// Returns 0 for 0 chants. Returns 1 for chants 1..108. Returns 2 for 109..216.
/// Use this for any user-visible "X mala" label. Do NOT use it for the
/// (malas, chants) split persisted to JapaSession — that must stay as floor
/// division so `malas * 108 + chants == count` holds.
int malaForCount(int count) {
  if (count <= 0) return 0;
  return ((count - 1) ~/ AppConstants.malaSize) + 1;
}
