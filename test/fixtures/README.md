# Test Fixtures

Made-up backup files used to lock the backup (JSON export) format.

## Files

| File | Used by | What it is |
|------|---------|------------|
| `backup_format_v1.json` | `test/repositories/backup_format_test.dart` | A small made-up backup in format `exportVersion` 1: a default counter, a locked counter with a Malayalam name, a counter with no mala count (`malaSize` 0), a finished (disabled) counter, a counter with custom step / initial count / mala size, and their sessions. |

## Rules

- **No real data.** Fixtures are committed to the repository. Never put a real backup
  (your own counters or practice history) here.
- **Never edit a fixture to make a test pass.** Every app version must import backups
  made by any earlier version. If the test fails, the code broke the format — fix the
  code. If the format grows (a new optional field), add a new fixture file and test
  instead of changing this one.
