# Make the counter card lock button bigger and easier to tap

**Status:** completed

## Files to be changed

- `lib/widgets/counter_card.dart`

## The issue

On the counter list, each card has a small lock / unlock button in its badge row.
Right now that button is very small:

- icon size `18`
- padding `EdgeInsets.all(5)` around the icon
- so the visible button is only about `28 x 28` logical pixels
- the `InkResponse` uses `radius: 18`, so the real touch area is also small

The whole card is wrapped in an `InkWell` that opens the counting screen (or shows
the "locked" notice). When the user aims at the lock but misses by a few pixels,
the tap falls through to the card `InkWell`, so the card opens instead of the lock
toggling.

Material guidance asks for a touch target of at least `48 x 48`. The current button
is far below that, which is why the mis-taps happen.

## The plan for the fix

In `lib/widgets/counter_card.dart`, in the lock button block:

1. Grow the visible button a little:
   - icon size `18` -> `20`
   - icon padding `EdgeInsets.all(5)` -> `EdgeInsets.all(8)`
   - visible circle becomes about `36 x 36`
2. Grow the real touch area well past the visible circle:
   - wrap the button in a `SizedBox` of `48 x 48` and center the icon inside it,
     so the tappable region is a full `48 x 48` even though the drawn circle stays small
   - set `InkResponse` `radius: 24` and `containedInkWell: false` so the ripple
     matches the new size
3. Keep the spacing tidy:
   - because the touch box is now wider, reduce the `SizedBox(width: 6)` spacer
     before the lock to `2`, and add a small negative-free right alignment so the
     badge row does not shift visually
4. No change to behaviour, colours, tooltips, or localisation. Only size and hit area.

## Testing

- `flutter analyze` must stay clean
- `flutter test` must stay green
- Manual check: tap near the edge of the lock icon; the lock must toggle and the
  card must not open
