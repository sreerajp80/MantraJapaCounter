import 'package:flutter/material.dart';
import 'help/help_home_screen.dart';

/// Legacy HelpScreen export mapping to the new HelpHomeScreen hub.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HelpHomeScreen();
  }
}
