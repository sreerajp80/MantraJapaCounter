# Fix low-contrast "mala this session" text on the counting screen

**Status:** completed

## The issue

On the counting screen, the small caption at the centre of the mala circle that
reads "ഈ സെഷനിൽ +1 മാല" ("+1 mala this session") is very hard to read. It is
drawn in `TempleColors.sandal` (`0xFFD8A13A`, a light golden), which sits on the
light peach/cream medallion background. The measured contrast ratio is about
**2:1** — well below the WCAG AA minimum of **4.5:1** for small text.

## Where

- File: `mantra_japa_counter/lib/screens/counting_screen.dart`
- Widget: `_centerNumber(...)`, the `malaThisSession` `Text` at lines 416–423.
- Current style: `AppTheme.serif(fontSize: 11, color: TempleColors.sandal, ...)`.

Only this one text uses `sandal` as a foreground colour on the light medallion,
so the change is isolated. No theme constant needs to change.

## The fix

Change the text colour from `TempleColors.sandal` to `TempleColors.vermillionDeep`
(`0xFF9A2C10`).

Why this colour:
- Contrast against the medallion rises from ~2:1 to about **6.6:1** — passes AA.
- It stays on-theme: `vermillionDeep` is already the app's "achievement /
  completion" accent (used for reached goals), which fits a "+1 mala completed"
  message.
- It matches the deep-red accent already used for the goal dot/label just above
  it when a goal is reached, so the centre stack reads as one family.

Alternative considered: `TempleColors.ink2` (`0xFF5A4429`) also passes AA and is
more neutral, but `vermillionDeep` keeps the devotional accent and ties the
"mala completed" idea to the existing achievement colour.

## Files to change

1. `mantra_japa_counter/lib/screens/counting_screen.dart` — one-line colour change
   in `_centerNumber`.

## Verification

- Run the app (dev flavour), start a session, and count past 108 so the
  "+1 mala this session" caption appears; confirm it is clearly legible.
- `flutter analyze` stays clean.
