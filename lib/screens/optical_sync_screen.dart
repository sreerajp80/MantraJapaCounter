import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:mantra_japa_counter/theme/theme.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/providers/optical_sync_provider.dart';
import 'package:mantra_japa_counter/services/screen_service.dart';
import 'package:mantra_japa_counter/widgets/counter_selection_sheet.dart';
import 'package:mantra_japa_counter/widgets/optical_sync_import_preview_sheet.dart';
import 'package:mantra_japa_counter/widgets/qr_camera_view.dart';

class OpticalSyncScreen extends ConsumerStatefulWidget {
  final bool isTransmitter;

  const OpticalSyncScreen({super.key, required this.isTransmitter});

  @override
  ConsumerState<OpticalSyncScreen> createState() => _OpticalSyncScreenState();
}

class _OpticalSyncScreenState extends ConsumerState<OpticalSyncScreen>
    with WidgetsBindingObserver {
  Timer? _streamTimer;
  bool _sheetShown = false;
  bool _counterSelectionShown = false;

  /// Kept here so send mode can be turned off in [dispose], when `ref` can no
  /// longer be used.
  late final ScreenService _screenService;

  /// True while frames are streaming (send mode is on).
  bool _sending = false;

  /// The normal screen brightness (0..1), read when sending starts. Null
  /// until it is known.
  double? _normalBrightness;

  /// Brightness slider position: 0 = normal brightness, 1 = full. Starts at
  /// normal each time the screen opens; it is not saved.
  double _brightnessBoost = 0;

  @override
  void initState() {
    super.initState();
    _screenService = ref.read(screenServiceProvider);
    WidgetsBinding.instance.addObserver(this);
    if (widget.isTransmitter) {
      // Show counter selection after first frame renders.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCounterSelectionForTransmit();
      });
    }
  }

  /// Shows the counter selection sheet before starting QR stream.
  Future<void> _showCounterSelectionForTransmit() async {
    if (_counterSelectionShown) return;
    _counterSelectionShown = true;

    final repo = ref.read(japaCounterRepositoryProvider);
    final counters = await repo.getAllCounters();

    if (!mounted) return;

    if (counters.isEmpty) {
      // No counters — nothing to transmit.
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.noCountersSelected),
          backgroundColor: TempleColors.vermillion,
        ),
      );
      return;
    }

    final l = AppLocalizations.of(context);
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CounterSelectionSheet(
        counters: counters,
        title: l.selectCountersTitle,
        subtitle: l.opticalSelectCountersHint,
        onConfirm: (selectedIds) {
          Navigator.pop(context);
          ref
              .read(opticalSyncTransmitProvider.notifier)
              .initializeWithSelectedCounters(selectedIds);
          _startStreamTimer();
        },
      ),
    );
  }

  void _startStreamTimer() {
    if (!_sending) {
      _sending = true;
      unawaited(_screenService.setSendMode(true));
      unawaited(_loadNormalBrightness());
    }
    _streamTimer?.cancel();
    final fps = ref.read(opticalSyncTransmitProvider).fps;
    final intervalMs = (1000 / fps).round();
    _streamTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      ref.read(opticalSyncTransmitProvider.notifier).nextFrame();
    });
  }

  Future<void> _loadNormalBrightness() async {
    final normal = await _screenService.getCurrentBrightness();
    if (!mounted) return;
    setState(() => _normalBrightness = normal);
  }

  /// Applies the slider: 0 is the normal brightness, 1 is full brightness.
  Future<void> _applyBrightnessBoost() async {
    final normal = _normalBrightness;
    if (normal == null || _brightnessBoost <= 0) {
      await _screenService.setSendBrightness(-1);
      return;
    }
    await _screenService.setSendBrightness(
      normal + _brightnessBoost * (1 - normal),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_sending) return;
    // Always-on screen (and any extra brightness) only while the send screen
    // is in front. Leaving drops the boost; coming back applies it again.
    if (state == AppLifecycleState.paused) {
      unawaited(_screenService.setSendMode(false));
    } else if (state == AppLifecycleState.resumed) {
      unawaited(
        _screenService.setSendMode(true).then((_) => _applyBrightnessBoost()),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _streamTimer?.cancel();
    if (_sending) unawaited(_screenService.setSendMode(false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: TempleColors.bg,
      appBar: AppBar(
        title: Text(
          widget.isTransmitter ? l.opticalSendTitle : l.opticalReceiveTitle,
        ),
      ),
      body: widget.isTransmitter
          ? _buildTransmitterView(context)
          : _buildReceiverView(context),
    );
  }

  // ──────────────────────────── Transmitter View ────────────────────────────

  Widget _buildTransmitterView(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(opticalSyncTransmitProvider);
    final theme = Theme.of(context);

    if (!state.isInitialized && !state.isLoading) {
      // Waiting for counter selection
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.checklist_rounded,
              size: 48,
              color: TempleColors.sandal,
            ),
            const SizedBox(height: 12),
            Text(
              l.selectCountersTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: TempleColors.ink2,
              ),
            ),
          ],
        ),
      );
    }

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
      return Center(child: Text(l.opticalNoFrames));
    }

    // As big as the screen allows (page padding 24, box padding 16, border 2
    // on each side), up to 320 px. Bigger squares are easier to focus on.
    final qrSize = (MediaQuery.sizeOf(context).width - 2 * (24 + 16 + 2)).clamp(
      200.0,
      320.0,
    );

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
              l.opticalSessionId(state.sessionId),
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
            // Pure black on white: coloured corner squares look grey to the
            // scanner and are often missed.
            child: QrImageView(
              data: currentFrame.serialize(),
              size: qrSize,
              backgroundColor: Colors.white,
              // Default eye and data styles are plain black squares.
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.opticalFrameCounter(state.currentFrameIndex + 1),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: TempleColors.ink,
            ),
          ),
          Text(
            currentFrame.isSystematic
                ? l.opticalSystematicChunk(currentFrame.chunkIndices.first)
                : l.opticalParityFrame(currentFrame.frameIndex),
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
            l.opticalStreamRate,
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
          const SizedBox(height: 16),
          _brightnessSlider(l, theme),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              l.opticalSendHint,
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

  /// Slider from the normal brightness (left) up to full (right).
  Widget _brightnessSlider(AppLocalizations l, ThemeData theme) {
    final valueLabel = _brightnessBoost <= 0
        ? l.opticalBrightnessNormal
        : l.opticalBrightnessBoost((_brightnessBoost * 100).round());
    return Column(
      children: [
        Text(
          '${l.opticalBrightness} · $valueLabel',
          style: theme.textTheme.labelMedium?.copyWith(
            color: TempleColors.ink2,
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.brightness_low,
              size: 20,
              color: TempleColors.ink2,
            ),
            Expanded(
              child: Slider(
                value: _brightnessBoost,
                activeColor: TempleColors.vermillion,
                inactiveColor: TempleColors.line,
                semanticFormatterCallback: (_) => valueLabel,
                onChanged: _normalBrightness == null
                    ? null
                    : (value) {
                        setState(() => _brightnessBoost = value);
                        unawaited(_applyBrightnessBoost());
                      },
              ),
            ),
            const Icon(
              Icons.brightness_high,
              size: 20,
              color: TempleColors.sandal,
            ),
          ],
        ),
      ],
    );
  }

  // ──────────────────────────── Receiver View ────────────────────────────

  Widget _buildReceiverView(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(opticalSyncReceiveProvider);
    final theme = Theme.of(context);

    // Auto-trigger completion bottom sheet when payload 100% reconstructed
    if (state.progress.isComplete && !_sheetShown) {
      _sheetShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final imported = await showModalBottomSheet<bool>(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const OpticalSyncImportPreviewSheet(),
        );
        // Cancel or a failed import: clear the received data and scan again.
        // A successful import closes this screen instead.
        if (imported == true || !mounted) return;
        ref.read(opticalSyncReceiveProvider.notifier).reset();
        setState(() => _sheetShown = false);
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
                        ? l.opticalReconstructing(
                            state.progress.reconstructedChunksCount,
                            state.progress.totalOriginalChunks,
                          )
                        : l.opticalAlignCamera,
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
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l.opticalFramesReceived(state.progress.framesReceived),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: TempleColors.ink2,
                  ),
                ),
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
          child: QrCameraView(
            onDetect: (rawValue) {
              ref
                  .read(opticalSyncReceiveProvider.notifier)
                  .processScannedFrame(rawValue);
            },
          ),
        ),
      ],
    );
  }
}
