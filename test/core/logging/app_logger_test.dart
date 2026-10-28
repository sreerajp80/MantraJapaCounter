import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/flavor/flavor_config.dart';
import 'package:mantra_japa_counter/core/logging/app_logger.dart';

void main() {
  final written = <(String, LogLevel)>[];
  late void Function(String, LogLevel, StackTrace?) originalSink;

  setUp(() {
    written.clear();
    originalSink = AppLogger.sink;
    AppLogger.sink = (message, level, _) => written.add((message, level));
  });

  tearDown(() {
    AppLogger.sink = originalSink;
    AppFlavorConfig.setFlavorForTesting(AppFlavor.prod);
  });

  test('trace and debug write nothing in prod', () {
    AppFlavorConfig.setFlavorForTesting(AppFlavor.prod);

    AppLogger.trace('t');
    AppLogger.debug('d');
    AppLogger.info('i');

    expect(written, [('i', LogLevel.info)]);
  });

  test('trace and debug write in dev', () {
    AppFlavorConfig.setFlavorForTesting(AppFlavor.dev);

    AppLogger.trace('t');
    AppLogger.debug('d');

    expect(written, [('t', LogLevel.trace), ('d', LogLevel.debug)]);
  });

  test('errors write the error type, never its message', () {
    AppLogger.error(
      'Import failed',
      error: const FormatException('private counter name'),
      stackTrace: StackTrace.current,
    );

    expect(written.single.$1, 'Import failed (FormatException)');
    expect(written.single.$2, LogLevel.error);
  });

  test('a failing sink never throws to the caller', () {
    AppLogger.sink = (_, _, _) => throw StateError('sink broken');

    expect(() => AppLogger.warning('w'), returnsNormally);
  });
}
