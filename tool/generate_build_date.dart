// Generates lib/utils/build_date.g.dart with the current date.
// Run before release builds:  dart run tool/generate_build_date.dart

// ignore_for_file: avoid_print

import 'dart:io';

void main() {
  final date = DateTime.now().toIso8601String().substring(0, 10);
  final file = File('lib/utils/build_date.g.dart');

  file.writeAsStringSync(
    '// GENERATED FILE — DO NOT EDIT.\n'
    '// Run: dart run tool/generate_build_date.dart\n'
    '\n'
    "const String kBuildDate = '$date';\n",
  );

  print('build_date.g.dart updated → $date');
}
