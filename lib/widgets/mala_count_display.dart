import 'package:flutter/material.dart';

/// Displays a count + mala pair (e.g. "Count: 216  Malas: 2").
class MalaCountDisplay extends StatelessWidget {
  final String countLabel;
  final int count;
  final String malaLabel;
  final int malas;
  final Color textColor;

  const MalaCountDisplay({
    super.key,
    required this.countLabel,
    required this.count,
    required this.malaLabel,
    required this.malas,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('$countLabel: $count', style: style.copyWith(color: textColor)),
        Text('$malaLabel: $malas', style: style.copyWith(color: textColor)),
      ],
    );
  }
}
