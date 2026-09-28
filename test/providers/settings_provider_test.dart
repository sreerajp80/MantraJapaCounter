import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mantra_japa_counter/core/constants/app_constants.dart';
import 'package:mantra_japa_counter/providers/settings_provider.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/services/screen_service.dart';

/// Records brightness values instead of calling the native side.
class _FakeScreenService extends ScreenService {
  final List<double> applied = [];

  @override
  Future<void> setAppBrightness(double value) async => applied.add(value);
}

void main() {
  group('SettingsNotifier - screen brightness', () {
    late _FakeScreenService screen;

    setUp(() => screen = _FakeScreenService());

    Future<SettingsRepository> repoWith(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      return SettingsRepository(await SharedPreferences.getInstance());
    }

    test('applies the saved brightness on creation', () async {
      final repo = await repoWith({AppConstants.prefsBrightnessKey: 0.3});
      SettingsNotifier(repo, null, screen);
      expect(screen.applied, [0.3]);
    });

    test('applies "follow system" (-1) when nothing is saved', () async {
      final repo = await repoWith({});
      SettingsNotifier(repo, null, screen);
      expect(screen.applied, [-1.0]);
    });

    test('setScreenBrightness saves and applies the value', () async {
      final repo = await repoWith({});
      final notifier = SettingsNotifier(repo, null, screen);

      await notifier.setScreenBrightness(0.8);
      expect(repo.screenBrightness, 0.8);
      expect(notifier.state.screenBrightness, 0.8);
      expect(screen.applied.last, 0.8);

      await notifier.setScreenBrightness(-1.0);
      expect(repo.screenBrightness, -1.0);
      expect(screen.applied.last, -1.0);
    });
  });
}
