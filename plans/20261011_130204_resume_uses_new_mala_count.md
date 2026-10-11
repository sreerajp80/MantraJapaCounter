# Fix: a paused session must use the counter's new mala count

**Status:** completed

## Files to change

- `lib/providers/counting_provider.dart`
- `test/providers/counting_provider_test.dart`
- `docs/architecture.md` (one line in the "Per-Counter Mala Count" section)

## The issue

The user set the mala count of a counter to 1. When they opened the counter,
the centre still showed `1` and "of one hundred eight", not `0`.

Cause: the counter had a **paused** session from before the edit (1 count,
started with a mala count of 108). A paused session keeps the mala count it
started with (this was a choice in
`plans/20261011_070315_per_counter_mala_count.md`). So the screen still used
108:

- centre: 1 of 108,
- footer malas: lifetime `1/10 m`, today `1/1 m`, session `1 m` — all worked
  out with 108.

With a mala count of 1, the 1 count is already a full mala. The centre
should show `0` and the session should not be "mid-mala" any more.

## The fix

When the counting screen resumes a saved (paused) session, and the counter's
mala count is now different from the session's, switch the session to the
counter's current mala count:

1. In `CountingNotifier` load (the resume branch), if
   `saved.malaSize != counter.malaSize`, use
   `saved.copyWith(malaSize: counter.malaSize)` as the session.
2. Use that updated session for everything after it in the resume branch:
   the recovery DB writes (malas / chants split), and the earlier-day banner
   check (`_holdsEarlierDayTaps`). So if the new count makes the mala
   complete, no "unfinished mala" banner shows.
3. If the DB row already exists, update its malas / chants split with the new
   mala count, and write the updated session back to prefs, so a crash right
   after does not bring back 108.

Result for the user's case: tap count 1, mala count 1 → centre shows `0`,
1 mala done this session, footer malas use 1. Leaving the screen now finishes
the session (it is no longer mid-mala).

Other cases:
- Larger new mala count (e.g. 108 → 216 with 150 taps): centre shows 150 of
  216. Session stays paused on exit.
- "No mala count" (0): centre shows the whole session; exit finishes it.
- Saved history rows of **finished** sessions are not changed.

## Tests

In `test/providers/counting_provider_test.dart`, add:
- A paused session saved with mala count 108 and 1 tap; counter edited to
  mala count 1; on load the session's `malaSize` is 1, `chants` is 0,
  `malas` is 1, and no earlier-day banner.
- Same with mala count changed to 0 (no mala).

Then run `flutter analyze` and `flutter test`.
