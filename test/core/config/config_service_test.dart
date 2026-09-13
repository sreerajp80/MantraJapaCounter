import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/core/config/app_config.dart';
import 'package:mantra_japa_counter/core/config/config_service.dart';

void main() {
  group('AppConfig', () {
    test('fallback contains safe default values', () {
      expect(
        AppConfig.fallback.appName.resolve('en'),
        equals('SreerajP MantraJapa Counter'),
      );
      expect(AppConfig.fallback.version, equals('0.0.0'));
      expect(AppConfig.fallback.build, equals('0'));
      expect(AppConfig.fallback.details, isNotEmpty);
    });

    test('fromJson parses valid JSON map correctly', () {
      final jsonMap = {
        'appName': 'Test App',
        'description': 'A test app description',
        'version': '1.2.3',
        'build': '45',
        'details': {'Author': 'Test Author', 'License': 'MIT'},
      };

      final config = AppConfig.fromJson(jsonMap);
      expect(config.appName.resolve('en'), equals('Test App'));
      expect(
        config.description.resolve('en'),
        equals('A test app description'),
      );
      expect(config.version, equals('1.2.3'));
      expect(config.build, equals('45'));
      expect(config.details['Author']?.resolve('en'), equals('Test Author'));
      expect(config.details['License']?.resolve('en'), equals('MIT'));
    });

    test('fromJson parses localized appName map correctly', () {
      final jsonMap = {
        'appName': {
          'en': 'English App',
          'ml': 'മലയാളം ആപ്പ്',
          'sa': 'संस्कृत-अनुप्रयोगः',
        },
      };

      final config = AppConfig.fromJson(jsonMap);
      expect(config.appName.resolve('en'), equals('English App'));
      expect(config.appName.resolve('ml'), equals('മലയാളം ആപ്പ്'));
      expect(config.appName.resolve('sa'), equals('संस्कृत-अनुप्रयोगः'));
    });

    test('fromJson falls back safely on missing or invalid types', () {
      final jsonMap = {
        'appName': 123, // invalid type
        'details': 'not a map', // invalid type
      };

      final config = AppConfig.fromJson(jsonMap);
      expect(
        config.appName.resolve('en'),
        equals(AppConfig.fallback.appName.resolve('en')),
      );
      expect(config.version, equals(AppConfig.fallback.version));
      expect(config.details, isEmpty);
    });
  });

  group('ConfigService', () {
    test('load() returns parsed AppConfig on valid asset text', () async {
      final validJsonText = jsonEncode({
        'appName': 'Mock App',
        'description': 'Mock Description',
        'version': '2.0.0',
        'build': '10',
        'details': {'Developer': 'Test Dev'},
      });

      final service = ConfigService(loadAsset: (path) async => validJsonText);

      final config = await service.load();
      expect(config.appName.resolve('en'), equals('Mock App'));
      expect(config.version, equals('2.0.0'));
      expect(config.build, equals('10'));
      expect(config.details['Developer']?.resolve('en'), equals('Test Dev'));
    });

    test(
      'load() returns fallback on asset load error or malformed JSON',
      () async {
        final serviceWithError = ConfigService(
          loadAsset: (path) async => throw Exception('Asset missing'),
        );

        final config1 = await serviceWithError.load();
        expect(
          config1.appName.resolve('en'),
          equals(AppConfig.fallback.appName.resolve('en')),
        );

        final serviceWithBadJson = ConfigService(
          loadAsset: (path) async => 'invalid json {',
        );

        final config2 = await serviceWithBadJson.load();
        expect(
          config2.appName.resolve('en'),
          equals(AppConfig.fallback.appName.resolve('en')),
        );
      },
    );
  });
}
