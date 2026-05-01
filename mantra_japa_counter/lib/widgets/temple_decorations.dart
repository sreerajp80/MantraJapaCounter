import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Decorative temple gateway arch — two concentric arches with a finial dot.
/// Used at the top of the counter list and active counter screens.
class TempleArch extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double opacity;

  const TempleArch({
    super.key,
    this.width = 240,
    this.height = 50,
    this.color = TempleColors.vermillion,
    this.opacity = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(width, height),
        painter: _ArchPainter(color: color),
      ),
    );
  }
}

class _ArchPainter extends CustomPainter {
  final Color color;
  const _ArchPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Scale design coords (200 × 80) to widget size.
    final sx = size.width / 200.0;
    final sy = size.height / 80.0;
    Offset p(double x, double y) => Offset(x * sx, y * sy);

    final outer = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final inner = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final outerPath = Path()
      ..moveTo(p(10, 80).dx, p(10, 80).dy)
      ..lineTo(p(10, 40).dx, p(10, 40).dy)
      ..quadraticBezierTo(p(10, 10).dx, p(10, 10).dy, p(100, 10).dx, p(100, 10).dy)
      ..quadraticBezierTo(p(190, 10).dx, p(190, 10).dy, p(190, 40).dx, p(190, 40).dy)
      ..lineTo(p(190, 80).dx, p(190, 80).dy);
    canvas.drawPath(outerPath, outer);

    final innerPath = Path()
      ..moveTo(p(30, 80).dx, p(30, 80).dy)
      ..lineTo(p(30, 50).dx, p(30, 50).dy)
      ..quadraticBezierTo(p(30, 25).dx, p(30, 25).dy, p(100, 25).dx, p(100, 25).dy)
      ..quadraticBezierTo(p(170, 25).dx, p(170, 25).dy, p(170, 50).dx, p(170, 50).dy)
      ..lineTo(p(170, 80).dx, p(170, 80).dy);
    canvas.drawPath(innerPath, inner);

    // Finial dot at the top.
    canvas.drawCircle(p(100, 22), 3 * sx, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ArchPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Lotus medallion — concentric rings with eight petal-like ellipses.
/// Used as a soft watermark on cards and behind the active counter.
class TempleMedallion extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const TempleMedallion({
    super.key,
    this.size = 80,
    this.color = TempleColors.vermillion,
    this.opacity = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(size, size),
        painter: _MedallionPainter(color: color),
      ),
    );
  }
}

class _MedallionPainter extends CustomPainter {
  final Color color;
  const _MedallionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100.0;
    final cx = 50.0 * scale;
    final cy = 50.0 * scale;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * scale;

    // Outer ring — must coincide with TempleMalaCircle's bead ring so the
    // dotted ring and the outer circle share centre, radius, and diameter.
    // Keep this formula in sync with _MalaPainter.paint() in
    // temple_mala_circle.dart.
    const guruDiameter = 12.0;
    final outerRingRadius = size.width / 2 - guruDiameter / 2;
    canvas.drawCircle(Offset(cx, cy), outerRingRadius, stroke);
    canvas.drawCircle(Offset(cx, cy), 32 * scale, stroke);

    for (var i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      final x = cx + math.cos(angle) * 24 * scale;
      final y = cy + math.sin(angle) * 24 * scale;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(i * 45 * math.pi / 180);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: 12 * scale,
        height: 28 * scale,
      );
      canvas.drawOval(rect, stroke);
      canvas.restore();
    }

    canvas.drawCircle(Offset(cx, cy), 6 * scale, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MedallionPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Stylised lotus blossom outline icon.
class TempleLotusIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const TempleLotusIcon({
    super.key,
    this.size = 18,
    this.color = TempleColors.vermillion,
    this.strokeWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LotusPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _LotusPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _LotusPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(12 * s, 20 * s)
      ..cubicTo(5 * s, 15 * s, 4 * s, 8 * s, 4 * s, 3 * s)
      ..cubicTo(8 * s, 5 * s, 11 * s, 11 * s, 12 * s, 17 * s)
      ..cubicTo(13 * s, 11 * s, 16 * s, 5 * s, 20 * s, 3 * s)
      ..cubicTo(20 * s, 8 * s, 19 * s, 15 * s, 12 * s, 20 * s)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LotusPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}

/// Diya (oil lamp) outline icon — used for "daily goal" and timer accents.
class TempleDiyaIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const TempleDiyaIcon({
    super.key,
    this.size = 18,
    this.color = TempleColors.vermillion,
    this.strokeWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DiyaPainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _DiyaPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _DiyaPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Bowl ellipses (lower curve approximated with cubic).
    final bowl = Path()
      ..moveTo(3 * s, 14 * s)
      ..cubicTo(3 * s, 16 * s, 7 * s, 18 * s, 12 * s, 18 * s)
      ..cubicTo(17 * s, 18 * s, 21 * s, 16 * s, 21 * s, 14 * s);
    canvas.drawPath(bowl, paint);

    final rim = Path()
      ..moveTo(5 * s, 14 * s)
      ..cubicTo(5 * s, 12 * s, 8 * s, 11 * s, 12 * s, 11 * s)
      ..cubicTo(16 * s, 11 * s, 19 * s, 12 * s, 19 * s, 14 * s);
    canvas.drawPath(rim, paint);

    // Wick + flame accents.
    canvas.drawLine(Offset(12 * s, 11 * s), Offset(12 * s, 8 * s), paint);
    final flame = Path()
      ..moveTo(11 * s, 5 * s)
      ..cubicTo(11 * s, 6 * s, 12 * s, 7 * s, 12 * s, 8 * s)
      ..cubicTo(12 * s, 7 * s, 13 * s, 6 * s, 13 * s, 5 * s);
    canvas.drawPath(flame, paint);
  }

  @override
  bool shouldRepaint(covariant _DiyaPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}

/// Decorative "॥ ॐ ॥" badge — shown in the top bar above the arch.
class TempleOmBadge extends StatelessWidget {
  final Color color;
  final double fontSize;

  const TempleOmBadge({
    super.key,
    this.color = TempleColors.vermillion,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '॥ ॐ ॥',
      style: AppTheme.sans(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 4,
      ),
    );
  }
}

/// Pill-shaped icon button used for top-bar actions on the counter list and
/// active counter screens.
class TempleIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double size;

  const TempleIconButton({
    super.key,
    required this.child,
    this.onTap,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TempleColors.card,
      shape: const CircleBorder(side: BorderSide(color: TempleColors.line)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}
