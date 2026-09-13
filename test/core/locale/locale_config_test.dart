import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/locale/locale_config.dart';

void main() {
  group('LocaleConfig', () {
    test('supportedLocales contains en, ml, and sa', () {
      final codes = LocaleConfig.supportedLocales
          .map((l) => l.languageCode)
          .toList();
      expect(codes, containsAll(['en', 'ml', 'sa']));
    });

    group('resolve (device locale resolution)', () {
      test('Malayalam locale resolves to Malayalam', () {
        expect(
          LocaleConfig.resolve(const Locale('ml')),
          equals(LocaleConfig.malayalam),
        );
        expect(
          LocaleConfig.resolve(const Locale('ml', 'IN')),
          equals(LocaleConfig.malayalam),
        );
      });

      test('Sanskrit locale resolves to Sanskrit', () {
        expect(
          LocaleConfig.resolve(const Locale('sa')),
          equals(LocaleConfig.sanskrit),
        );
        expect(
          LocaleConfig.resolve(const Locale('sa', 'IN')),
          equals(LocaleConfig.sanskrit),
        );
      });

      test('Any other locale resolves to English fallback', () {
        expect(
          LocaleConfig.resolve(const Locale('en')),
          equals(LocaleConfig.english),
        );
        expect(
          LocaleConfig.resolve(const Locale('fr')),
          equals(LocaleConfig.english),
        );
        expect(
          LocaleConfig.resolve(const Locale('hi')),
          equals(LocaleConfig.english),
        );
        expect(
          LocaleConfig.resolve(const Locale('es')),
          equals(LocaleConfig.english),
        );
        expect(LocaleConfig.resolve(null), equals(LocaleConfig.english));
      });
    });

    group('resolveAppLocale (explicit user preference vs system default)', () {
      test('explicit en resolves to English regardless of device locale', () {
        expect(
          LocaleConfig.resolveAppLocale(
            languageCode: 'en',
            deviceLocale: const Locale('ml'),
          ),
          equals(LocaleConfig.english),
        );
      });

      test('explicit ml resolves to Malayalam regardless of device locale', () {
        expect(
          LocaleConfig.resolveAppLocale(
            languageCode: 'ml',
            deviceLocale: const Locale('en'),
          ),
          equals(LocaleConfig.malayalam),
        );
      });

      test('explicit sa resolves to Sanskrit regardless of device locale', () {
        expect(
          LocaleConfig.resolveAppLocale(
            languageCode: 'sa',
            deviceLocale: const Locale('en'),
          ),
          equals(LocaleConfig.sanskrit),
        );
      });

      test('null or system adheres to device locale resolution', () {
        expect(
          LocaleConfig.resolveAppLocale(
            languageCode: null,
            deviceLocale: const Locale('ml'),
          ),
          equals(LocaleConfig.malayalam),
        );
        expect(
          LocaleConfig.resolveAppLocale(
            languageCode: 'system',
            deviceLocale: const Locale('sa'),
          ),
          equals(LocaleConfig.sanskrit),
        );
        expect(
          LocaleConfig.resolveAppLocale(
            languageCode: 'system',
            deviceLocale: const Locale('de'),
          ),
          equals(LocaleConfig.english),
        );
      });
    });

    group('Fallback delegates for Sanskrit (sa)', () {
      test('FallbackMaterialLocalizationsDelegate supports sa only', () {
        const delegate = FallbackMaterialLocalizationsDelegate();
        expect(delegate.isSupported(const Locale('sa')), isTrue);
        expect(delegate.isSupported(const Locale('en')), isFalse);
        expect(delegate.isSupported(const Locale('ml')), isFalse);
      });

      test('FallbackCupertinoLocalizationsDelegate supports sa only', () {
        const delegate = FallbackCupertinoLocalizationsDelegate();
        expect(delegate.isSupported(const Locale('sa')), isTrue);
        expect(delegate.isSupported(const Locale('en')), isFalse);
        expect(delegate.isSupported(const Locale('ml')), isFalse);
      });

      test('Fallback delegates load default localizations', () async {
        const matDelegate = FallbackMaterialLocalizationsDelegate();
        final matLoc = await matDelegate.load(const Locale('sa'));
        expect(matLoc, isNotNull);

        const cupDelegate = FallbackCupertinoLocalizationsDelegate();
        final cupLoc = await cupDelegate.load(const Locale('sa'));
        expect(cupLoc, isNotNull);
      });
    });
  });
}
