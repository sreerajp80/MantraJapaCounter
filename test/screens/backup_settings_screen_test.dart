import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mantra_japa_counter/core/locale/locale_config.dart';
import 'package:mantra_japa_counter/l10n/app_localizations.dart';
import 'package:mantra_japa_counter/models/counter.dart';
import 'package:mantra_japa_counter/providers/app_providers.dart';
import 'package:mantra_japa_counter/repositories/settings_repository.dart';
import 'package:mantra_japa_counter/screens/settings/backup_settings_screen.dart';
import 'package:mantra_japa_counter/services/export_service.dart';
import 'package:mantra_japa_counter/services/encryption_service.dart';

import '../helpers/fake_japa_counter_repository.dart';

base class _PickedFile extends PlatformFile {
  _PickedFile(String path) : uri = Uri.file(path);

  @override
  final Uri uri;

  @override
  String get name => uri.pathSegments.last;

  @override
  get xFile => throw UnimplementedError();

  @override
  int? lengthSync() => null;

  @override
  Future<int?> length() async => null;

  @override
  Future<Uint8List> readAsBytes() async => Uint8List(0);

  @override
  Stream<Uint8List> readAsByteStream() => const Stream.empty();
}

/// Returns a fixed file (or null for "cancelled") instead of opening the
/// system picker.
class _FakePicker extends FilePickerPlatform {
  _FakePicker(this.path);

  final String? path;

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async => path == null ? null : _PickedFile(path!);
}

const _counter = Counter(
  id: 'c1',
  name: 'Om Namah Shivaya',
  startDate: 1000,
  createdAt: 1000,
);

void main() {
  late FakeJapaCounterRepository repo;
  late Directory tempDir;
  final original = FilePickerPlatform.instance;
  final l = lookupAppLocalizations(const Locale('en'));

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = FakeJapaCounterRepository(counters: [_counter]);
    tempDir = Directory.systemTemp.createTempSync('japa_backup_test');
  });

  tearDown(() {
    FilePickerPlatform.instance = original;
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Future<void> pumpBackup(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(prefs),
          ),
          japaCounterRepositoryProvider.overrideWithValue(repo),
          exportServiceProvider.overrideWithValue(
            ExportService(repo, EncryptionService()),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: LocaleConfig.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BackupSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Taps import while letting real file reads finish.
  Future<void> tapImport(WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.tap(find.text(l.settingsImportTitle));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();
  }

  testWidgets('shows sync, export, import and clear actions', (tester) async {
    await pumpBackup(tester);

    expect(find.text(l.settingsOpticalSendTitle), findsOneWidget);
    expect(find.text(l.settingsOpticalReceiveTitle), findsOneWidget);
    expect(find.text(l.settingsExportTitle), findsOneWidget);
    expect(find.text(l.settingsImportTitle), findsOneWidget);
    expect(find.text(l.clearAllDataTitle), findsOneWidget);
  });

  testWidgets('cancelling the file picker changes nothing', (tester) async {
    FilePickerPlatform.instance = _FakePicker(null);
    await pumpBackup(tester);

    await tapImport(tester);

    expect(find.byType(SnackBar), findsNothing);
    expect(repo.counters.map((c) => c.id), ['c1']);
  });

  testWidgets('a bad backup file shows the error and keeps data', (
    tester,
  ) async {
    final file = File('${tempDir.path}/bad.json')
      ..writeAsStringSync(
        jsonEncode({
          'exportVersion': 1,
          'exportDate': 1,
          'counters': [
            {..._counter.toJson(), 'id': 'x', 'incrementStep': 0},
          ],
          'sessions': [],
        }),
      );
    FilePickerPlatform.instance = _FakePicker(file.path);
    await pumpBackup(tester);

    await tapImport(tester);

    expect(find.textContaining('Import failed'), findsOneWidget);
    expect(repo.counters.map((c) => c.id), ['c1']);
  });

  testWidgets('clear all asks first, then removes every counter', (
    tester,
  ) async {
    await pumpBackup(tester);

    await tester.tap(find.text(l.clearAllDataTitle));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text(l.cancel));
    await tester.pumpAndSettle();
    expect(repo.counters, hasLength(1));

    await tester.tap(find.text(l.clearAllDataTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.clearAllButton));
    await tester.pumpAndSettle();

    expect(repo.counters, isEmpty);
    expect(find.text(l.allDataCleared), findsOneWidget);
  });
}
