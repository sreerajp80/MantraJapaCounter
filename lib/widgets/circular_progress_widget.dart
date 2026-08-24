import 'dart:math';
import 'package:flutter/material.dart';

/// Circular progress arc with a centered label.
class CircularProgressWidget extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final String centerText;
  final String bottomLabel;
  final Color color;
  final double size;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    required this.centerText,
    required this.bottomLabel,
    required this.color,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 20,
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _ArcPainter(progress: progress, color: color),
              child: Center(
                child: Text(
                  centerText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Text(
            bottomLabel,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawArc(rect, -pi / 2, 2 * pi, false, bgPaint);

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}
