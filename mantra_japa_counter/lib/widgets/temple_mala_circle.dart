import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Circular mala (108-bead rosary) visualization. Beads are drawn around a
/// circle; filled beads (count out of goal) use [TempleColors.sandal] while
/// the most recently filled bead gets a [TempleColors.vermillion] highlight
/// and a guru bead sits at the top of the ring.
///
/// The number displayed in the centre is supplied by the parent via [child]
/// so the parent can format it however it wishes.
class TempleMalaCircle extends StatelessWidget {
  final int count;
  final int goal;
  final int beadSegments;
  final double diameter;
  final bool goalReached;
  final Widget child;

  const TempleMalaCircle({
    super.key,
    required this.count,
    required this.goal,
    required this.child,
    this.beadSegments = 108,
    this.diameter = 280,
    this.goalReached = false,
  });

  @override
  Widget build(BuildContext context) {
    final filled = goal <= 0
        ? 0
        : ((count / goal).clamp(0.0, 1.0) * beadSegments).round();

    return SizedBox(
      width: diameter,
      height: diameter,
      child: CustomPaint(
        painter: _MalaPainter(
          beadSegments: beadSegments,
          filled: filled,
          goalReached: goalReached,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _MalaPainter extends CustomPainter {
  final int beadSegments;
  final int filled;
  final bool goalReached;

  _MalaPainter({
    required this.beadSegments,
    required this.filled,
    required this.goalReached,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    // The bead ring rides on the outer cardSoft circle (radius = size/2).
    // Bead centres are inset by the guru-bead radius so the largest bead's
    // outer edge sits exactly on that circle and the rest stay fully within
    // the canvas. The medallion's outer stroke uses the same radius so the
    // dotted ring and the outer ring share centre, radius, and diameter.
    const guruDiameter = 12.0;
    final radius = size.width / 2 - guruDiameter / 2;

    final filledBeadColor =
        goalReached ? TempleColors.vermillion : TempleColors.sandal;
    final activeBeadColor =
        goalReached ? TempleColors.vermillionDeep : TempleColors.vermillion;
    final unfilledBeadBase =
        goalReached ? TempleColors.vermillion : TempleColors.sandal;

    for (var i = 0; i < beadSegments; i++) {
      final angle = (i * (360 / beadSegments) - 90) * math.pi / 180;
      final x = cx + math.cos(angle) * radius;
      final y = cy + math.sin(angle) * radius;
      final isFilled = i < filled;
      final isLast = i == filled - 1 && filled > 0;

      final beadSize = isLast ? 8.0 : (isFilled ? 5.0 : 4.0);
      final color = isFilled
          ? (isLast ? activeBeadColor : filledBeadColor)
          : unfilledBeadBase.withValues(alpha: 0.45);

      // Soft shadow for the active "last filled" bead.
      if (isLast) {
        final glow = Paint()
          ..color = activeBeadColor.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), beadSize / 2 + 3, glow);
      }

      canvas.drawCircle(Offset(x, y), beadSize / 2, Paint()..color = color);

      if (isFilled) {
        final ring = Paint()
          ..color = TempleColors.vermillionDeep.withValues(alpha: 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(Offset(x, y), beadSize / 2, ring);
      }
    }

    // Guru bead — a circle on the same ring as the dots, just larger so it
    // reads as the marker bead. Its centre shares the bead-ring radius.
    final guruCenter = Offset(cx, cy - radius);
    canvas.drawCircle(
      guruCenter,
      guruDiameter / 2,
      Paint()..color = TempleColors.vermillionDeep,
    );
    canvas.drawCircle(
      guruCenter,
      guruDiameter / 2,
      Paint()
        ..color = TempleColors.sandal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _MalaPainter oldDelegate) =>
      oldDelegate.filled != filled ||
      oldDelegate.beadSegments != beadSegments ||
      oldDelegate.goalReached != goalReached;
}
