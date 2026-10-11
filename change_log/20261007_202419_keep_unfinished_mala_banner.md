# Keep the "Unfinished mala" banner visible until the mala is done

Implements plan: `plans/20261007_201744_keep_unfinished_mala_banner.md`

## What changed

### `lib/providers/counting_provider.dart`
- Added `_holdsEarlierDayTaps(session)`. It is true when the mala in progress is not finished
  and still holds taps from an earlier day (either nothing is tapped today yet, or the taps
  carried from earlier-day rows belong to the same mala).
- `init()` now uses this helper. The banner shows again when the user leaves mid-mala and
  comes back, even on the same day.
- `tap()` no longer hides the banner on the first tap. It sets the flag from the helper, so the
  banner goes away only when the mala reaches 108.
- `_startNewDayRow()` no longer clears the flag.
- `decrement()` also refreshes the flag from the helper.
- `finishAndStartNew()` (banner **Start new** and menu **Finish & start new**) still clears it.
- Updated the doc comment on `CountingState.resumedFromEarlierDay`.

### `test/providers/counting_provider_test.dart`
- "today's taps go into a new row dated today": checks the banner stays on while counting and
  turns off at 108.
- "leaving mid-mala again keeps the carry-over on resume": the banner now shows on reopen.
- New test: finish the mala, keep counting, leave and reopen — the banner does not show.

### `docs/architecture.md`
- Noted that the banner stays until the mala reaches 108 or a new session is started.

## Checks
- `flutter analyze`: no issues.
- `flutter test`: all 281 tests passed.

No storage, schema, export or UI text changes.
