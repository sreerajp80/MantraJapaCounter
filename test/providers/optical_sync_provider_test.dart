import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mantra_japa_counter/providers/optical_sync_provider.dart';
import 'package:mantra_japa_counter/services/optical_sync_service.dart';

void main() {
  final payload = jsonEncode({
    'counters': [
      for (int i = 0; i < 6; i++)
        {'id': 'cnt-$i', 'name': 'Counter $i', 'initialCount': i * 108},
    ],
    'sessions': <Object>[],
  });

  /// QR texts of the first plain chunks, enough to rebuild [payload].
  List<String> fullStream(String sessionId) {
    final encoder = OpticalSyncEncoder(payload, sessionId: sessionId);
    return [
      for (int i = 0; i < encoder.totalOriginalChunks; i++)
        encoder.frameAt(i).serialize(),
    ];
  }

  test('reset after a full receive starts a new scan', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // Keep the auto-dispose provider alive, as the screen does.
    final sub = container.listen(opticalSyncReceiveProvider, (_, _) {});
    addTearDown(sub.close);
    final notifier = container.read(opticalSyncReceiveProvider.notifier);

    for (final text in fullStream('sess-one')) {
      notifier.processScannedFrame(text);
    }
    var state = container.read(opticalSyncReceiveProvider);
    expect(state.progress.isComplete, isTrue);
    expect(state.isScanning, isFalse);

    notifier.reset();
    state = container.read(opticalSyncReceiveProvider);
    expect(state.progress.isComplete, isFalse);
    expect(state.progress.reconstructedChunksCount, 0);
    expect(state.progress.framesReceived, 0);
    expect(state.isScanning, isTrue);

    // New frames (even from another session) are accepted again.
    notifier.processScannedFrame(fullStream('sess-two').first);
    state = container.read(opticalSyncReceiveProvider);
    expect(state.progress.sessionId, 'sess-two');
    expect(state.progress.framesReceived, 1);
  });

  test('receive state is dropped when no one listens', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(opticalSyncReceiveProvider, (_, _) {});
    container
        .read(opticalSyncReceiveProvider.notifier)
        .processScannedFrame(fullStream('sess-one').first);
    expect(
      container.read(opticalSyncReceiveProvider).progress.framesReceived,
      1,
    );

    // The screen closes.
    sub.close();
    await container.pump();

    // Opening it again starts from 0.
    final again = container.listen(opticalSyncReceiveProvider, (_, _) {});
    addTearDown(again.close);
    expect(again.read().progress.framesReceived, 0);
    expect(again.read().progress.totalOriginalChunks, 0);
  });
}
