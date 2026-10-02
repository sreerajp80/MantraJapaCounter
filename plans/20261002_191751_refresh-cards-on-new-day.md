# Refresh counter cards when a new day starts

**Status:** completed

## The issue

When the app is left open (or in the background) and opened again on the next
day, the home screen cards still show yesterday's "today" numbers. Cards whose
daily goal was met yesterday keep the green tick. The cards only update after
the user taps the lock/unlock button on any card.

## Why it happens

- `counterStatsProvider` and `todayAggregateProvider`
  (`lib/providers/counter_stats_provider.dart`) work out "today's count" once,
  and then keep the result in memory.
- They only re-run when something they watch changes. Today they watch only
  the repository and the counters list.
- The home screen stays alive while the app is in the background, so the
  cached values are never thrown away. Nothing tells these providers that the
  date has changed.
- Tapping lock/unlock changes the counters list. That makes every card's
  provider re-run, so all cards suddenly show the correct (new day) numbers.

## The fix

1. Add a small provider, `currentDayProvider`, that holds today's date
   (year-month-day only). It is a Riverpod `Notifier` with a `refresh()`
   method that updates the value only when the date has really changed.
2. Make `counterStatsProvider` and `todayAggregateProvider` watch
   `currentDayProvider`. When the day changes, they re-run and read fresh
   numbers from the database.
3. Keep `currentDayProvider` up to date from one place at app level
   (`MantraJapaCounterApp` in `lib/main.dart`, turned into a small stateful
   widget wrapper):
   - On app resume (`AppLifecycleState.resumed`) call `refresh()`.
   - Start a timer that fires just after the next local midnight, calls
     `refresh()`, and schedules the next one. This covers the case where the
     screen stays open across midnight.
   - Cancel the timer on dispose.
4. Add a unit test for `currentDayProvider` (value only changes when the
   date changes) and a test that `counterStatsProvider` re-runs after a day
   change.

No UI text, no database, no export format changes.

## Files to change

- `lib/providers/current_day_provider.dart` (new) — `currentDayProvider`.
- `lib/providers/counter_stats_provider.dart` — watch `currentDayProvider`.
- `lib/main.dart` — app-level lifecycle observer + midnight timer.
- `test/providers/current_day_provider_test.dart` (new) — tests.
- `change_log/<timestamp>_refresh-cards-on-new-day.md` (new) — change log.

## Checks

- `flutter analyze` clean.
- `flutter test` passes.
