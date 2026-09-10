# Bigger tap area for the counter card lock button

Implements `plans/20260910_093008_bigger_lock_tap_target.md`.

## Why

The lock / unlock button on each counter card was only about 28 x 28 pixels.
The whole card is wrapped in an `InkWell` that opens the counting screen, so a
tap that missed the small lock fell through to the card and opened it instead of
toggling the lock.

## What changed

`lib/widgets/counter_card.dart` — lock button in the card badge row:

- icon size `18` -> `20`
- icon padding `EdgeInsets.all(5)` -> `EdgeInsets.all(8)`, so the drawn circle is
  now about `36 x 36`
- the button is wrapped in a `SizedBox(width: 48, height: 48)` with a `Center`,
  so the real touch area is a full `48 x 48` (the Material minimum) even though
  the drawn circle stays small
- `InkResponse` `radius` `18` -> `24` and `containedInkWell: false`, so the ripple
  matches the new touch area
- spacer before the lock reduced from `6` to `2`, because the touch box already
  carries its own padding

No change to colours, tooltips, localisation, or behaviour. Only the size and the
hit area changed.

## Checks

- `dart format` — clean
- `flutter analyze` — no issues found
- `flutter test` — all 62 tests pass
