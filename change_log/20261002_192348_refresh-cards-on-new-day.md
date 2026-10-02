# Refresh counter cards when a new day starts

Implements plan: `plans/20261002_191751_refresh-cards-on-new-day.md`

## Problem

When the app was opened again on the next day, the home screen cards still
showed yesterday's "today" counts. Cards that met their daily goal yesterday
kept the green tick. They only refreshed after the user tapped lock/unlock on
a card, because only a change to the counters list made the stats re-run.

## What changed

- `lib/providers/current_day_provider.dart` (new)
  - `clockProvider` — the time source (can be replaced in tests).
  - `currentDayProvider` — holds today's local date. Its `refresh()` method
    updates the value only when the date has really changed.
- `lib/providers/counter_stats_provider.dart`
  - `counterStatsProvider` and `todayAggregateProvider` now watch
    `currentDayProvider`, so they read fresh numbers from the database when
    the day changes.
- `lib/main.dart`
  - `MantraJapaCounterApp` is now a `ConsumerStatefulWidget` that listens to
    app lifecycle changes. On resume it calls `currentDayProvider.refresh()`.
  - A timer fires just after each local midnight and also calls `refresh()`,
    so the cards reset even if the app stays open across midnight. The timer
    is cancelled when the widget is disposed.
- `test/providers/current_day_provider_test.dart` (new)
  - Checks the date has no time part.
  - Checks `refresh()` only notifies on a real date change.
  - Checks card stats and the today summary keep their cached values on the
    same day and re-read the database on the next day.

No UI text, database schema, or export format changes.

## Checks

- `flutter analyze` — no issues.
- `flutter test` — all 212 tests passed.
