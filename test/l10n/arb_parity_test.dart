import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every ARB file has the same keys as the template', () {
    final en = _keys('lib/l10n/app_en.arb');
    for (final locale in ['ml', 'sa']) {
      final other = _keys('lib/l10n/app_$locale.arb');
      expect(other.difference(en), isEmpty, reason: 'extra keys in $locale');
      expect(en.difference(other), isEmpty, reason: 'missing keys in $locale');
    }
  });

  test('no translation is an accidental copy of the English value', () {
    final enJson = _json('lib/l10n/app_en.arb');
    const allowedIdentical = {
      'appName',
      'appTitle',
      'devFlavorSuffix',
      'englishLanguage',
      'email',
      'aboutDetailEmail',
      'aboutDetailEmailValue',
    };

    for (final locale in ['ml', 'sa']) {
      final otherJson = _json('lib/l10n/app_$locale.arb');
      for (final key in otherJson.keys) {
        if (key.startsWith('@') || allowedIdentical.contains(key)) continue;
        final enVal = enJson[key];
        final otherVal = otherJson[key];
        if (enVal is String &&
            otherVal is String &&
            enVal.trim().length > 3 &&
            !enVal.contains('{') &&
            !RegExp(r'^[0-9\s.,:\-_\+]+$').hasMatch(enVal)) {
          expect(
            otherVal != enVal,
            isTrue,
            reason: 'Key "$key" in $locale is an untranslated copy of English',
          );
        }
      }
    }
  });
}

Set<String> _keys(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>).keys
        .where((k) => !k.startsWith('@'))
        .toSet();

Map<String, dynamic> _json(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
