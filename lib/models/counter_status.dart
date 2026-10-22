/// Status of a named mantra counter.
enum CounterStatus {
  active,
  disabledSuccess,
  disabledFailure;

  /// Round-trip with the string stored in the SQLite `status` column.
  /// These strings are part of the backup format — never change them.
  static CounterStatus fromDb(String value) {
    switch (value) {
      case 'ACTIVE':
        return CounterStatus.active;
      case 'DISABLED_SUCCESS':
        return CounterStatus.disabledSuccess;
      case 'DISABLED_FAILURE':
        return CounterStatus.disabledFailure;
      default:
        return CounterStatus.active;
    }
  }

  String toDb() {
    switch (this) {
      case CounterStatus.active:
        return 'ACTIVE';
      case CounterStatus.disabledSuccess:
        return 'DISABLED_SUCCESS';
      case CounterStatus.disabledFailure:
        return 'DISABLED_FAILURE';
    }
  }
}
