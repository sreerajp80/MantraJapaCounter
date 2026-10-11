# Paused session uses the counter's new mala count

Implements plan: `plans/20261011_130204_resume_uses_new_mala_count.md`

## What changed

- `lib/providers/counting_provider.dart`: when a saved (paused) session is
  resumed and the counter's mala count has changed, the session now takes the
  counter's new mala count. The updated session is written back to prefs right
  away. If the session's DB row already exists, its malas / chants split is
  re-worked with the new mala count. The earlier-day banner check uses the
  updated session, so a mala that is now complete shows no banner.
- `test/providers/counting_provider_test.dart`: two new tests — a session
  paused with 1 tap at mala 108 is resumed after the mala count is changed to
  1 (centre count 0, 1 mala, row split 1 / 0, exit finishes) and to 0 (no
  mala; exit finishes).
- `docs/architecture.md`: noted the new rule in "Per-Counter Mala Count".
  This replaces the earlier choice that a paused session keeps the mala count
  it started with.

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 318 tests pass.
