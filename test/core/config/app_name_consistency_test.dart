import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The launcher name in every Android `strings.xml` must match `appName` in
/// `assets/config/app_config.json` (guideline.md §1.8). Dev builds add the
/// dev suffix after the name.
void main() {
  final config = jsonDecode(
    File('assets/config/app_config.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final appName = (config['appName'] as Map<String, dynamic>).map(
    (k, v) => MapEntry(k, v as String),
  );

  String launcherName(String flavor, String lang) {
    final folder = lang == 'en' ? 'values' : 'values-$lang';
    final xml = File('android/app/src/$flavor/res/$folder/strings.xml')
        .readAsStringSync();
    final match = RegExp(r'<string name="app_name">([^<]*)</string>')
        .firstMatch(xml);
    expect(match, isNotNull, reason: '$flavor/$folder has no app_name');
    return match!.group(1)!;
  }

  for (final lang in ['en', 'ml', 'sa']) {
    test('prod launcher name matches appName ($lang)', () {
      expect(launcherName('prod', lang), appName[lang]);
    });

    test('dev launcher name starts with appName plus a suffix ($lang)', () {
      final name = launcherName('dev', lang);
      expect(name.startsWith('${appName[lang]} '), isTrue, reason: name);
    });
  }
}
