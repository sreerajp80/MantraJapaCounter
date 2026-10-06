# Add "Settings" to the counting screen menu

**Status:** completed

## Files to change

- `lib/screens/counting_screen.dart`

## The issue

The three-dot (more) menu on the counting screen has History, About, Finish and start new,
Reset session, and Reset counter. There is no way to open Settings from here. The user has
to leave the counting screen and go back to the counter list to change settings (for
example sound, vibration, or display options).

## The plan

1. In the popup menu `itemBuilder` of `counting_screen.dart`, add a new item
   `PopupMenuItem(value: 'settings', child: Text(l.menuSettings))`.
   Place it right after "About", so the navigation items (History, About, Settings) stay
   together above the session actions.
2. In `_onMenu`, add `case 'settings': context.push('/settings');` — the same route the
   counter list menu already uses.

No new text is needed. The `menuSettings` key already exists in `app_en.arb`,
`app_ml.arb`, and `app_sa.arb`, so no `.arb` change and no `flutter gen-l10n` run.

The counting screen stays on the navigation stack (we use `push`, just like History), so
the current session is not touched. When the user presses back, they return to counting.
Settings changes (sound, haptics, display) are read through Riverpod providers, so they
apply when the user comes back.

## Checks

- `dart format`, `flutter analyze` (must be clean), `flutter test`.
