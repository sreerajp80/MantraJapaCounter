import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/services/qr_decoder_service.dart';
import 'package:mantra_japa_counter/theme/theme.dart';

/// Why the camera scanner cannot run.
enum _ScanProblem { none, permissionDenied, cameraFailed, unavailable }

/// Highest zoom offered on the slider. More than this makes the preview shake.
const double _maxUsefulZoom = 4.0;

/// Zoom the camera starts at (1×, no zoom). The user can zoom in with the
/// slider. Limited to the camera's own range.
const double _startZoom = 1.0;

/// Side of the orange guide box, in logical pixels (smaller on tiny views).
const double _guideBoxSize = 250.0;

/// Extra area decoded around the guide box, so a code a little outside it is
/// still read.
const double _cropMargin = 1.15;

/// How often auto focus is nudged again while no QR code is being read.
const Duration _refocusInterval = Duration(seconds: 3);

/// How long the focus ring stays on screen after a tap.
const Duration _focusRingDuration = Duration(milliseconds: 900);

/// Codes the `camera` plugin uses when camera access is refused.
const _deniedCameraCodes = {
  'CameraAccessDenied',
  'CameraAccessDeniedWithoutPrompt',
  'CameraAccessRestricted',
};

/// Live camera view that reads QR codes fully on the device.
///
/// The `camera` plugin streams frames; each frame's brightness plane goes to
/// [qrDecoderServiceProvider] (ZXing on the Android host). While one frame is
/// being decoded, new frames are skipped, so the camera never backs up.
/// Only the part of the frame under the orange guide box (plus a margin) is
/// sent and searched, which is much faster than the whole frame.
/// The camera is released when the app goes to the background and started
/// again when it comes back.
///
/// The user can tap to focus, zoom, and turn on the light. While no code is
/// read, auto focus is nudged every few seconds, because many phones do not
/// refocus on their own at close range.
class QrCameraView extends ConsumerStatefulWidget {
  /// Called with the text of every QR code read.
  final ValueChanged<String> onDetect;

  const QrCameraView({super.key, required this.onDetect});

  @override
  ConsumerState<QrCameraView> createState() => _QrCameraViewState();
}

class _QrCameraViewState extends ConsumerState<QrCameraView>
    with WidgetsBindingObserver {
  CameraController? _controller;
  _ScanProblem _problem = _ScanProblem.none;

  /// True while a frame is with the decoder.
  bool _decoding = false;

  /// True while the camera is being started, so it is not started twice.
  bool _starting = false;

  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _zoom = 1.0;

  bool _torchOn = false;

  /// False once the camera reports it has no light.
  bool _torchSupported = true;

  /// Focus point in 0–1 preview coordinates, used again by the refocus timer.
  Offset _focusPoint = const Offset(0.5, 0.5);

  /// Where the focus ring is drawn, in widget pixels; null when hidden.
  Offset? _focusRing;
  Timer? _focusRingTimer;

  /// Size of this view, saved on each layout for the frame crop.
  Size _viewSize = Size.zero;

  Timer? _refocusTimer;
  DateTime _lastDetect = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refocusTimer?.cancel();
    _focusRingTimer?.cancel();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      final controller = _controller;
      if (controller == null) return;
      _refocusTimer?.cancel();
      // Clear the field first, so build() never paints a disposed controller.
      // The light goes off with the camera.
      setState(() {
        _controller = null;
        _torchOn = false;
      });
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller == null && _problem == _ScanProblem.none) {
        _initializeCamera();
      }
    }
  }

  Future<void> _initializeCamera() async {
    if (_starting) return;
    // Live frames and the ZXing decoder exist on Android only.
    if (kIsWeb || !Platform.isAndroid) {
      setState(() => _problem = _ScanProblem.unavailable);
      return;
    }

    _starting = true;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _problem = _ScanProblem.cameraFailed);
        return;
      }
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // 1080p gives more pixels per QR square than 720p, so dense codes read.
      final controller = CameraController(
        camera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      await _setUpFocusAndZoom(controller);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _problem = _ScanProblem.none;
      });
      await controller.startImageStream(_onFrame);
      _refocusTimer?.cancel();
      _refocusTimer = Timer.periodic(_refocusInterval, (_) => _refocusIfIdle());
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _problem = _deniedCameraCodes.contains(e.code)
            ? _ScanProblem.permissionDenied
            : _ScanProblem.cameraFailed;
      });
    } catch (e) {
      debugPrint('QrCameraView: camera start failed ($e)');
      if (mounted) setState(() => _problem = _ScanProblem.cameraFailed);
    } finally {
      _starting = false;
    }
  }

  /// Turns on auto focus and exposure and reads the zoom range. Each step is
  /// optional: some cameras do not support it, and scanning still works.
  Future<void> _setUpFocusAndZoom(CameraController controller) async {
    try {
      await controller.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('QrCameraView: focus mode not supported ($e)');
    }
    try {
      await controller.setExposureMode(ExposureMode.auto);
    } catch (e) {
      debugPrint('QrCameraView: exposure mode not supported ($e)');
    }
    try {
      final minZoom = await controller.getMinZoomLevel();
      final maxZoom = await controller.getMaxZoomLevel();
      _minZoom = minZoom;
      _maxZoom = maxZoom.clamp(minZoom, math.max(minZoom, _maxUsefulZoom));
      _zoom = _startZoom.clamp(_minZoom, _maxZoom);
      // Always set it, so the camera opens at the start zoom every time.
      await controller.setZoomLevel(_zoom);
    } catch (e) {
      debugPrint('QrCameraView: zoom not supported ($e)');
      _minZoom = _maxZoom = _zoom = 1.0;
    }
    _focusPoint = const Offset(0.5, 0.5);
    _lastDetect = DateTime.now();
  }

  /// Asks the camera to focus and meter at [point] (0–1 preview coordinates).
  Future<void> _focusAt(Offset point) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    try {
      if (controller.value.focusPointSupported) {
        await controller.setFocusPoint(point);
      }
      if (controller.value.exposurePointSupported) {
        await controller.setExposurePoint(point);
      }
    } catch (e) {
      debugPrint('QrCameraView: focus point failed ($e)');
    }
  }

  /// Nudges auto focus again when no code has been read for a while.
  void _refocusIfIdle() {
    if (DateTime.now().difference(_lastDetect) < _refocusInterval) return;
    unawaited(_focusAt(_focusPoint));
  }

  void _onTapToFocus(Offset local, Size viewSize, Size? previewSize) {
    final point = _toPreviewPoint(local, viewSize, previewSize);
    if (point == null) return;
    _focusPoint = point;
    unawaited(_focusAt(point));
    _focusRingTimer?.cancel();
    setState(() => _focusRing = local);
    _focusRingTimer = Timer(_focusRingDuration, () {
      if (mounted) setState(() => _focusRing = null);
    });
  }

  /// Maps a tap on the cropped ("cover") preview to 0–1 coordinates of the
  /// full camera preview. Returns null when the view has no size.
  Offset? _toPreviewPoint(Offset local, Size viewSize, Size? previewSize) {
    if (viewSize.isEmpty) return null;
    if (previewSize == null) {
      return Offset(
        (local.dx / viewSize.width).clamp(0.0, 1.0),
        (local.dy / viewSize.height).clamp(0.0, 1.0),
      );
    }
    // The preview size is reported in landscape; this app is portrait.
    final childWidth = previewSize.height;
    final childHeight = previewSize.width;
    final scale = math.max(
      viewSize.width / childWidth,
      viewSize.height / childHeight,
    );
    final shownWidth = childWidth * scale;
    final shownHeight = childHeight * scale;
    final left = (viewSize.width - shownWidth) / 2;
    final top = (viewSize.height - shownHeight) / 2;
    return Offset(
      ((local.dx - left) / shownWidth).clamp(0.0, 1.0),
      ((local.dy - top) / shownHeight).clamp(0.0, 1.0),
    );
  }

  Future<void> _setZoom(double value) async {
    final controller = _controller;
    if (controller == null) return;
    setState(() => _zoom = value);
    try {
      await controller.setZoomLevel(value);
    } catch (e) {
      debugPrint('QrCameraView: zoom failed ($e)');
    }
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null) return;
    final turnOn = !_torchOn;
    try {
      await controller.setFlashMode(turnOn ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() => _torchOn = turnOn);
    } catch (e) {
      debugPrint('QrCameraView: light not supported ($e)');
      if (mounted) {
        setState(() {
          _torchOn = false;
          _torchSupported = false;
        });
      }
    }
  }

  /// Side of the guide box for the current view, in logical pixels.
  double get _boxSide => math.min(_guideBoxSize, _viewSize.shortestSide * 0.8);

  /// The centred square of the camera frame under the guide box (plus a
  /// margin), in frame pixels. Null when the whole frame should be used.
  ///
  /// The box is a centred square, so it maps to a centred square in the
  /// frame whatever way the sensor is turned; only the scale is needed.
  ({int left, int top, int side})? _cropFor(CameraImage image) {
    final previewSize = _controller?.value.previewSize;
    if (previewSize == null || _viewSize.isEmpty) return null;
    // The preview is shown turned to portrait and scaled to cover the view.
    final previewShort = previewSize.shortestSide;
    final previewLong = previewSize.longestSide;
    final viewScale = math.max(
      _viewSize.width / previewShort,
      _viewSize.height / previewLong,
    );
    // The frame stream can have another size than the preview.
    final frameShort = math.min(image.width, image.height);
    final frameScale = frameShort / previewShort;

    final side = (_boxSide * _cropMargin / viewScale * frameScale).round();
    if (side <= 0 || side >= frameShort) return null;
    return (
      left: (image.width - side) ~/ 2,
      top: (image.height - side) ~/ 2,
      side: side,
    );
  }

  void _onFrame(CameraImage image) {
    if (_decoding || image.planes.isEmpty) return;
    _decoding = true;

    final plane = image.planes.first;
    final stride = plane.bytesPerRow;
    var bytes = plane.bytes;
    var height = image.height;
    QrCropRect? crop;

    // Send only the rows that hold the guide box, not the whole frame.
    final square = _cropFor(image);
    if (square != null) {
      final end = math.min(bytes.length, (square.top + square.side) * stride);
      bytes = Uint8List.sublistView(bytes, square.top * stride, end);
      height = square.side;
      crop = QrCropRect(
        left: square.left,
        top: 0,
        width: square.side,
        height: square.side,
      );
    }

    ref
        .read(qrDecoderServiceProvider)
        .decodeFrame(
          bytes: bytes,
          width: image.width,
          height: height,
          rowStride: stride,
          crop: crop,
        )
        .then((text) {
          if (text != null && mounted) {
            final trimmed = text.trim();
            if (trimmed.isNotEmpty) {
              _lastDetect = DateTime.now();
              widget.onDetect(trimmed);
            }
          }
        })
        .catchError((Object e) {
          if (e is QrScannerUnavailableException) {
            final controller = _controller;
            if (controller != null && controller.value.isStreamingImages) {
              unawaited(controller.stopImageStream().catchError((_) {}));
            }
            if (mounted) setState(() => _problem = _ScanProblem.unavailable);
          } else {
            debugPrint('QrCameraView: frame decode failed ($e)');
          }
        })
        .whenComplete(() => _decoding = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_problem != _ScanProblem.none) return _buildProblem(context);

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Fill the area and crop the overflow, keeping the preview's own shape.
    // The preview size is reported in landscape, so width/height swap for
    // this portrait-only app.
    final previewSize = controller.value.previewSize;
    final preview = ClipRect(
      child: previewSize == null
          ? CameraPreview(controller)
          : FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewSize.height,
                height: previewSize.width,
                child: CameraPreview(controller),
              ),
            ),
    );

    return ColoredBox(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewSize = constraints.biggest;
          _viewSize = viewSize;
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) => _onTapToFocus(
                    details.localPosition,
                    viewSize,
                    previewSize,
                  ),
                  child: preview,
                ),
              ),
              // Guide box: the area that is decoded. Taps pass through.
              IgnorePointer(
                child: Center(
                  child: Container(
                    width: _boxSide,
                    height: _boxSide,
                    decoration: BoxDecoration(
                      border: Border.all(color: TempleColors.sandal, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              if (_focusRing != null) _buildFocusRing(_focusRing!),
              Positioned(
                top: 12,
                left: 16,
                right: 16,
                child: IgnorePointer(child: _buildTip(context)),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: _buildControls(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFocusRing(Offset center) {
    const size = 64.0;
    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          AppLocalizations.of(context).opticalScanTip,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    final l = AppLocalizations.of(context);
    final canZoom = _maxZoom > _minZoom;
    if (!canZoom && !_torchSupported) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          if (_torchSupported)
            IconButton(
              tooltip: _torchOn ? l.opticalTorchOff : l.opticalTorchOn,
              onPressed: _toggleTorch,
              icon: Icon(
                _torchOn ? Icons.flash_on : Icons.flash_off,
                color: _torchOn ? TempleColors.sandal : Colors.white,
              ),
            ),
          if (canZoom) ...[
            Tooltip(
              message: l.opticalZoom,
              child: const Icon(Icons.zoom_in, color: Colors.white, size: 20),
            ),
            Expanded(
              child: Slider(
                value: _zoom.clamp(_minZoom, _maxZoom),
                min: _minZoom,
                max: _maxZoom,
                activeColor: TempleColors.sandal,
                inactiveColor: Colors.white38,
                onChanged: _setZoom,
                semanticFormatterCallback: (v) =>
                    '${l.opticalZoom} ${v.toStringAsFixed(1)}×',
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                '${_zoom.toStringAsFixed(1)}×',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ] else
            const Spacer(),
        ],
      ),
    );
  }

  Widget _buildProblem(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (icon, message) = switch (_problem) {
      _ScanProblem.permissionDenied => (
        Icons.no_photography_outlined,
        l.opticalCameraDenied,
      ),
      _ScanProblem.unavailable => (
        Icons.qr_code_scanner,
        l.opticalCameraUnavailable,
      ),
      _ => (Icons.error_outline, l.opticalCameraError),
    };
    return ColoredBox(
      color: TempleColors.bg,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: TempleColors.vermillion),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: TempleColors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
