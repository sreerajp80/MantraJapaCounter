import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mantra_japa_counter/models/mala_sound.dart';
import 'package:mantra_japa_counter/services/sound_service.dart';

class FakeAudioPlayer extends AudioPlayer {
  Source? lastSource;

  @override
  Future<void> play(
    Source source, {
    double? volume,
    double? balance,
    AudioContext? ctx,
    Duration? position,
    PlayerMode? mode,
  }) async {
    lastSource = source;
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> setReleaseMode(ReleaseMode releaseMode) async {}

  @override
  Future<void> setAudioContext(AudioContext context) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAudioPlayer fakePlayer;
  late SoundService soundService;
  final List<MethodCall> methodCalls = [];

  setUp(() {
    methodCalls.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers.global'),
          (call) async => null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers'),
          (call) async => null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('com.sreerajp.mantrajapacounter/haptic'),
          (call) async {
            methodCalls.add(call);
            if (call.method == 'listNotificationRingtones') {
              return [
                {'title': 'Bell', 'uri': 'content://media/1'},
              ];
            }
            return null;
          },
        );
    fakePlayer = FakeAudioPlayer();
    soundService = SoundService(player: fakePlayer);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('com.sreerajp.mantrajapacounter/haptic'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers.global'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers'),
          null,
        );
    await soundService.dispose();
  });

  test('RingtoneOption holds title and uri', () {
    const opt = RingtoneOption(title: 'Chime', uri: 'content://chime');
    expect(opt.title, equals('Chime'));
    expect(opt.uri, equals('content://chime'));
  });

  test('listNotificationRingtones parses channel results', () async {
    final list = await soundService.listNotificationRingtones();
    expect(list, hasLength(1));
    expect(list.first.title, equals('Bell'));
    expect(list.first.uri, equals('content://media/1'));
  });

  test('playMalaSound invokes native channel for synthesizedTone', () async {
    await soundService.playMalaSound(MalaSound.synthesizedTone);
    expect(methodCalls.any((call) => call.method == 'playMalaTone'), isTrue);
  });

  test(
    'playMalaSound plays templeBell asset and boosts alarm volume',
    () async {
      await soundService.playMalaSound(MalaSound.templeBell);
      expect(
        methodCalls.any((call) => call.method == 'boostAlarmVolume'),
        isTrue,
      );
      expect(fakePlayer.lastSource, isA<AssetSource>());
      expect(
        (fakePlayer.lastSource as AssetSource).path,
        equals('audio/temple_bell.wav'),
      );
    },
  );

  test(
    'playMalaSound plays singingBowl asset and boosts alarm volume',
    () async {
      await soundService.playMalaSound(MalaSound.singingBowl);
      expect(
        methodCalls.any((call) => call.method == 'boostAlarmVolume'),
        isTrue,
      );
      expect(fakePlayer.lastSource, isA<AssetSource>());
      expect(
        (fakePlayer.lastSource as AssetSource).path,
        equals('audio/singing_bowl.wav'),
      );
    },
  );

  test('playSacredAsset plays given asset path', () async {
    await soundService.playSacredAsset('audio/shankha.wav');
    expect(
      methodCalls.any((call) => call.method == 'boostAlarmVolume'),
      isTrue,
    );
    expect(fakePlayer.lastSource, isA<AssetSource>());
    expect(
      (fakePlayer.lastSource as AssetSource).path,
      equals('audio/shankha.wav'),
    );
  });

  test('stop invokes native stopPreviewTone', () async {
    await soundService.stop();
    expect(methodCalls.any((call) => call.method == 'stopPreviewTone'), isTrue);
  });
}
