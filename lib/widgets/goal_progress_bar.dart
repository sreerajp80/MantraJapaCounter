import 'package:flutter/material.dart';

/// Linear progress indicator for a goal (lifetime or daily).
class GoalProgressBar extends StatelessWidget {
  final String label;
  final double progress; // 0.0 – 1.0
  final int current;
  final int target;
  final bool isComplete;

  const GoalProgressBar({
    super.key,
    required this.label,
    required this.progress,
    required this.current,
    required this.target,
    required this.isComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isComplete ? '$label ✓' : label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isComplete ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              '$current / $target',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
              isComplete ? Colors.greenAccent : Colors.white),
          minHeight: isComplete ? 8 : 4,
        ),
      ],
    );
  }
}
