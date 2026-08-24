import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../config/theme.dart';
import '../providers/optical_sync_provider.dart';
import '../widgets/optical_sync_import_preview_sheet.dart';

class OpticalSyncScreen extends ConsumerStatefulWidget {
  final bool isTransmitter;

  const OpticalSyncScreen({super.key, required this.isTransmitter});

  @override
  ConsumerState<OpticalSyncScreen> createState() => _OpticalSyncScreenState();
}

class _OpticalSyncScreenState extends ConsumerState<OpticalSyncScreen> {
  Timer? _streamTimer;
  bool _sheetShown = false;

  @override
  void initState() {
    super.initState();
    if (widget.isTransmitter) {
      _startStreamTimer();
    }
  }

  void _startStreamTimer() {
    _streamTimer?.cancel();
    final fps = ref.read(opticalSyncTransmitProvider).fps;
    final intervalMs = (1000 / fps).round();
    _streamTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      ref.read(opticalSyncTransmitProvider.notifier).nextFrame();
    });
  }

  @override
  void dispose() {
    _streamTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TempleColors.bg,
      appBar: AppBar(
        title: Text(
          widget.isTransmitter
              ? 'Optical Sync Stream (Send)'
              : 'Optical Sync Receiver (Scan)',
        ),
      ),
      body: widget.isTransmitter
          ? _buildTransmitterView(context)
          : _buildReceiverView(context),
    );
  }

  // ──────────────────────────── Transmitter View ────────────────────────────

  Widget _buildTransmitterView(BuildContext context) {
    final state = ref.watch(opticalSyncTransmitProvider);
    final theme = Theme.of(context);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: TempleColors.vermillion),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            state.errorMessage!,
            style: const TextStyle(color: TempleColors.vermillion),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final currentFrame = state.currentFrame;
    if (currentFrame == null) {
      return const Center(child: Text('No data frames generated.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: TempleColors.sandal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'SESSION ID: ${state.sessionId}',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: TempleColors.vermillion,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Animated QR View Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: TempleColors.sandal.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: currentFrame.serialize(),
              version: QrVersions.auto,
              size: 260.0,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: TempleColors.vermillion,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Frame ${state.currentFrameIndex + 1} / ${state.frames.length}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: TempleColors.ink,
            ),
          ),
          Text(
            currentFrame.isSystematic
                ? 'Systematic Data Chunk #${currentFrame.frameIndex}'
                : 'Fountain Parity Frame #${currentFrame.frameIndex}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: TempleColors.ink2,
            ),
          ),
          const SizedBox(height: 24),
          // Stream Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 42,
                color: TempleColors.vermillion,
                icon: Icon(
                  state.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                onPressed: () {
                  ref
                      .read(opticalSyncTransmitProvider.notifier)
                      .togglePlayPause();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Speed Selectors
          Text(
            'Stream Rate (FPS)',
            style: theme.textTheme.labelMedium?.copyWith(
              color: TempleColors.ink2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [8, 12, 15].map((fps) {
              final isSelected = state.fps == fps;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text('$fps FPS'),
                  selected: isSelected,
                  selectedColor: TempleColors.vermillion,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : TempleColors.ink,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(opticalSyncTransmitProvider.notifier)
                          .setFps(fps);
                      _startStreamTimer();
                    }
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Point the receiving device\'s camera at this screen. The animated QR stream will transmit all counters and session history 100% offline.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: TempleColors.ink2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────── Receiver View ────────────────────────────

  Widget _buildReceiverView(BuildContext context) {
    final state = ref.watch(opticalSyncReceiveProvider);
    final theme = Theme.of(context);

    // Auto-trigger completion bottom sheet when payload 100% reconstructed
    if (state.progress.isComplete && !_sheetShown) {
      _sheetShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          builder: (_) => const OpticalSyncImportPreviewSheet(),
        );
      });
    }

    return Column(
      children: [
        // Live Reconstruction Progress Banner
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.progress.totalOriginalChunks > 0
                        ? 'Reconstructing: ${state.progress.reconstructedChunksCount} / ${state.progress.totalOriginalChunks} chunks'
                        : 'Align camera with animated QR stream...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TempleColors.vermillion,
                    ),
                  ),
                  Text(
                    '${(state.progress.completionPercentage * 100).toInt()}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TempleColors.tulsi,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: state.progress.completionPercentage,
                backgroundColor: TempleColors.line,
                color: TempleColors.tulsi,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        // Camera Viewfinder
        Expanded(
          child: Stack(
            children: [
              MobileScanner(
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    final rawValue = barcode.rawValue;
                    if (rawValue != null && rawValue.isNotEmpty) {
                      ref
                          .read(opticalSyncReceiveProvider.notifier)
                          .processScannedFrame(rawValue);
                    }
                  }
                },
              ),
              // Scanning Frame Guide Overlay
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: TempleColors.sandal, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
