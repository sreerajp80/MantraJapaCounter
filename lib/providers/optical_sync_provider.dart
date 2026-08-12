import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/optical_sync_frame.dart';
import '../services/optical_sync_service.dart';
import 'app_providers.dart';
import 'counters_provider.dart';

// ────────────────────────── Transmit State & Notifier ──────────────────────────

class OpticalSyncTransmitState {
  final bool isLoading;
  final String sessionId;
  final List<OpticalSyncFrame> frames;
  final int currentFrameIndex;
  final int fps;
  final bool isPlaying;
  final String? errorMessage;

  const OpticalSyncTransmitState({
    this.isLoading = true,
    this.sessionId = '',
    this.frames = const [],
    this.currentFrameIndex = 0,
    this.fps = 12,
    this.isPlaying = true,
    this.errorMessage,
  });

  OpticalSyncTransmitState copyWith({
    bool? isLoading,
    String? sessionId,
    List<OpticalSyncFrame>? frames,
    int? currentFrameIndex,
    int? fps,
    bool? isPlaying,
    String? errorMessage,
  }) {
    return OpticalSyncTransmitState(
      isLoading: isLoading ?? this.isLoading,
      sessionId: sessionId ?? this.sessionId,
      frames: frames ?? this.frames,
      currentFrameIndex: currentFrameIndex ?? this.currentFrameIndex,
      fps: fps ?? this.fps,
      isPlaying: isPlaying ?? this.isPlaying,
      errorMessage: errorMessage,
    );
  }

  OpticalSyncFrame? get currentFrame {
    if (frames.isEmpty) return null;
    return frames[currentFrameIndex % frames.length];
  }
}

class OpticalSyncTransmitNotifier extends Notifier<OpticalSyncTransmitState> {
  @override
  OpticalSyncTransmitState build() {
    initializeTransmitter();
    return const OpticalSyncTransmitState();
  }

  Future<void> initializeTransmitter() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(japaCounterRepositoryProvider);
      final exportData = await repo.exportData();
      final jsonPayload = exportData.toJsonString();

      final sessionId = const Uuid().v4().substring(0, 8);
      final frames = OpticalSyncService.generateFrames(
        jsonPayload,
        sessionId: sessionId,
        maxFramesToGenerate: 120,
      );

      state = state.copyWith(
        isLoading: false,
        sessionId: sessionId,
        frames: frames,
        currentFrameIndex: 0,
        isPlaying: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to prepare transmission data: $e',
      );
    }
  }

  void setFps(int newFps) {
    if (newFps > 0 && newFps <= 30) {
      state = state.copyWith(fps: newFps);
    }
  }

  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void nextFrame() {
    if (state.frames.isNotEmpty && state.isPlaying) {
      state = state.copyWith(
        currentFrameIndex: (state.currentFrameIndex + 1) % state.frames.length,
      );
    }
  }
}

final opticalSyncTransmitProvider = NotifierProvider<
    OpticalSyncTransmitNotifier, OpticalSyncTransmitState>(
  OpticalSyncTransmitNotifier.new,
);

// ────────────────────────── Receive State & Notifier ──────────────────────────

class OpticalSyncReceiveState {
  final bool isScanning;
  final OpticalSyncReceiveProgress progress;
  final String? errorMessage;
  final Map<String, dynamic>? decodedJsonMap;

  const OpticalSyncReceiveState({
    this.isScanning = true,
    this.progress = const OpticalSyncReceiveProgress(
      sessionId: '',
      totalOriginalChunks: 0,
      totalPayloadLength: 0,
      reconstructedChunksCount: 0,
      completionPercentage: 0.0,
      isComplete: false,
    ),
    this.errorMessage,
    this.decodedJsonMap,
  });

  OpticalSyncReceiveState copyWith({
    bool? isScanning,
    OpticalSyncReceiveProgress? progress,
    String? errorMessage,
    Map<String, dynamic>? decodedJsonMap,
  }) {
    return OpticalSyncReceiveState(
      isScanning: isScanning ?? this.isScanning,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      decodedJsonMap: decodedJsonMap ?? this.decodedJsonMap,
    );
  }

  int get counterCount {
    if (decodedJsonMap == null) return 0;
    final counters = decodedJsonMap!['counters'] as List?;
    return counters?.length ?? 0;
  }

  int get sessionCount {
    if (decodedJsonMap == null) return 0;
    final sessions = decodedJsonMap!['sessions'] as List?;
    return sessions?.length ?? 0;
  }
}

class OpticalSyncReceiveNotifier extends Notifier<OpticalSyncReceiveState> {
  late final OpticalSyncDecoder _decoder;

  @override
  OpticalSyncReceiveState build() {
    _decoder = OpticalSyncDecoder();
    return const OpticalSyncReceiveState();
  }

  void processScannedFrame(String rawText) {
    if (!state.isScanning || state.progress.isComplete) return;

    final frame = OpticalSyncFrame.parse(rawText);
    if (frame == null) return;

    final progress = _decoder.processFrame(frame);
    Map<String, dynamic>? jsonMap;

    if (progress.isComplete && progress.decodedJsonPayload != null) {
      try {
        jsonMap = jsonDecode(progress.decodedJsonPayload!) as Map<String, dynamic>;
      } catch (e) {
        state = state.copyWith(
          errorMessage: 'Corrupted payload format: $e',
        );
        return;
      }
    }

    state = state.copyWith(
      progress: progress,
      isScanning: !progress.isComplete,
      decodedJsonMap: jsonMap,
    );
  }

  Future<bool> importData() async {
    if (state.progress.decodedJsonPayload == null) return false;
    try {
      final exportSvc = ref.read(exportServiceProvider);
      await exportSvc.importFromJson(state.progress.decodedJsonPayload!);
      ref.invalidate(countersNotifierProvider);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Import failed: $e');
      return false;
    }
  }

  void reset() {
    _decoder.reset();
    state = const OpticalSyncReceiveState();
  }
}

final opticalSyncReceiveProvider = NotifierProvider<
    OpticalSyncReceiveNotifier, OpticalSyncReceiveState>(
  OpticalSyncReceiveNotifier.new,
);
