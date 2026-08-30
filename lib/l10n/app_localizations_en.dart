// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SreerajP MantraJapa Counter';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

  @override
  String get confirm => 'Confirm';

  @override
  String get clear => 'Clear';

  @override
  String get reset => 'Reset';

  @override
  String get resetAll => 'Reset all';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get play => 'Play';

  @override
  String get more => 'More';

  @override
  String get notSet => 'Not set';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get mantraCounters => 'Mantra Counters';

  @override
  String get menuImportExport => 'Import / Export';

  @override
  String get menuSettings => 'Settings';

  @override
  String get menuAbout => 'About';

  @override
  String get todayChants => 'chants';

  @override
  String get todayMalas => 'malas';

  @override
  String get todayActive => 'active';

  @override
  String get noCountersYet => 'No counters yet';

  @override
  String get noCountersSubtitle =>
      'Tap the + above to begin your first offering';

  @override
  String get aboutCounter => 'About counter';

  @override
  String get history => 'History';

  @override
  String get edit => 'Edit';

  @override
  String get disableSuccess => 'Disable (success)';

  @override
  String get disableFailure => 'Disable (not completed)';

  @override
  String get deleteCounterTitle => 'Delete counter?';

  @override
  String deleteCounterMessage(String name) {
    return 'Delete \"$name\" and all its history? This cannot be undone.';
  }

  @override
  String get disableAsCompletedTitle => 'Disable as completed?';

  @override
  String get disableCounterTitle => 'Disable counter?';

  @override
  String get reasonOptional => 'Reason (optional)';

  @override
  String get reasonHint => 'e.g. Completed 1 lakh';

  @override
  String get editCounterTitle => 'Edit Counter';

  @override
  String get newCounterTitle => 'New Counter';

  @override
  String get counterNameLabel => 'Counter name *';

  @override
  String get initialCountLabel => 'Initial count (default 0)';

  @override
  String get incrementStepLabel => 'Increment step (default 1)';

  @override
  String get lifetimeGoalFieldLabel => 'Lifetime goal (0 = none)';

  @override
  String get dailyGoalFieldLabel => 'Daily goal (0 = none)';

  @override
  String get startDateLabel => 'Start date: ';

  @override
  String get dailyExceedsLifetime => 'Daily goal cannot exceed lifetime goal';

  @override
  String get stepExceedsDaily => 'Increment step must be less than daily goal';

  @override
  String get importExportBody =>
      'Export backs up all counters and sessions to a JSON file.\n\nImport replaces ALL current data with the selected file.';

  @override
  String exportFailed(String message) {
    return 'Export failed: $message';
  }

  @override
  String importFailed(String message) {
    return 'Import failed: $message';
  }

  @override
  String get importSuccessful => 'Import successful';

  @override
  String pausedWithTime(String time) {
    return 'PAUSED · $time';
  }

  @override
  String get resetSession => 'Reset session';

  @override
  String get resetCounter => 'Reset counter';

  @override
  String get ofOneHundredEight => 'of one hundred eight';

  @override
  String get lifetimeGoalCaps => 'LIFETIME GOAL';

  @override
  String get dailyGoalCaps => 'DAILY GOAL';

  @override
  String beadsRemainCaps(int count) {
    return '$count BEADS REMAIN';
  }

  @override
  String malaThisSession(int count) {
    return '+$count mala this session';
  }

  @override
  String get footerLifetime => 'Lifetime';

  @override
  String get footerDaily => 'Daily';

  @override
  String get footerSession => 'Session';

  @override
  String get resetSessionTitle => 'Reset session?';

  @override
  String get resetSessionMessage =>
      'Current session will be discarded and the counter reset to 0.';

  @override
  String get resetCounterTitle => 'Reset counter?';

  @override
  String get resetCounterMessage =>
      'All history for this counter will be deleted. This cannot be undone.';

  @override
  String get noSessionsRecorded => 'No sessions recorded yet.';

  @override
  String get recentOfferings => 'RECENT OFFERINGS';

  @override
  String get today => 'Today';

  @override
  String sessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String get labelChants => 'chants';

  @override
  String get labelMala => 'mala';

  @override
  String get clearAllHistoryTitle => 'Clear all history?';

  @override
  String get clearCounterHistoryTitle => 'Clear this counter\'s history?';

  @override
  String get clearHistoryMessage => 'Sessions will be permanently deleted.';

  @override
  String get recordOfDevotion => 'a record of devotion';

  @override
  String get allCounters => 'All counters';

  @override
  String chantsOfferedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count DAYS',
      one: '1 DAY',
    );
    return 'CHANTS OFFERED · $_temp0';
  }

  @override
  String chantsOfferedPercent(String percent) {
    return 'CHANTS OFFERED · $percent% OF VOW';
  }

  @override
  String get deleteSessionTitle => 'Delete session?';

  @override
  String deleteSessionMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This session of $count chants will be permanently removed.',
      one: 'This session of 1 chant will be permanently removed.',
    );
    return '$_temp0';
  }

  @override
  String get deleteSessionTooltip => 'Delete session';

  @override
  String chantsCount(String count) {
    return '$count chants';
  }

  @override
  String malaCount(int count) {
    return '$count mala';
  }

  @override
  String get counterDetailsTitle => 'Counter Details';

  @override
  String get counterNotFound => 'Counter not found';

  @override
  String get completedSuccessfully => 'Completed successfully';

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get labelTotal => 'Total';

  @override
  String get labelTodayCap => 'Today';

  @override
  String get labelMalas => 'Malas';

  @override
  String get infoName => 'Name';

  @override
  String get infoStatus => 'Status';

  @override
  String get infoIncrementStep => 'Increment step';

  @override
  String get infoInitialCount => 'Initial count';

  @override
  String get infoLifetimeGoal => 'Lifetime goal';

  @override
  String get infoDailyGoal => 'Daily goal';

  @override
  String get infoStarted => 'Started';

  @override
  String get infoCreated => 'Created';

  @override
  String get infoAvgDaily => 'Avg daily count';

  @override
  String get infoDisabled => 'Disabled';

  @override
  String get statusActive => 'Active';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get aboutTitle => 'About';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String aboutBuildDate(String date) {
    return 'Build date: $date';
  }

  @override
  String get aboutPurposeTitle => 'Purpose';

  @override
  String get aboutPurposeBody =>
      'Track your mantra recitation practice with mala (108-bead round) counting, daily and lifetime goals, and full session history.';

  @override
  String get aboutOfflineTitle => 'Fully offline';

  @override
  String get aboutOfflineBody =>
      'No network access. All data stored only on your device.';

  @override
  String get aboutPrivacyTitle => 'Privacy';

  @override
  String get aboutPrivacyBody =>
      'No analytics, no tracking, no data shared with anyone.';

  @override
  String get aboutBackupTitle => 'Backup';

  @override
  String get aboutBackupBody =>
      'Use Import / Export to back up your data to a JSON file.';

  @override
  String get aboutMantraQuote => 'Om Namah Shivaya';

  @override
  String get aboutMadeWithPrefix => 'Made with ';

  @override
  String get aboutMadeWithSuffix => ' from India';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get practiceEyebrow => 'PRACTICE';

  @override
  String get sectionDailyGoal => 'Daily goal';

  @override
  String get sectionDailyGoalSub => 'When the offering is complete';

  @override
  String get enableNotification => 'Enable notification';

  @override
  String get enableNotificationSub => 'Vibrate and sound on completion';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationSub => 'A gentle hum on completion';

  @override
  String get notificationSound => 'Notification sound';

  @override
  String get previewTone => 'Preview tone';

  @override
  String get previewToneSub => 'Hear what plays on completion';

  @override
  String get sectionMala => 'Mala completion';

  @override
  String get sectionMalaSub => 'The closing of every 108 beads';

  @override
  String get enableMalaSound => 'Enable mala sound';

  @override
  String get enableMalaSoundSub => 'A soft tick on each full mala';

  @override
  String get sectionStillness => 'Stillness';

  @override
  String get sectionStillnessSub => 'For longer sessions';

  @override
  String get brightnessLevel => 'Brightness level';

  @override
  String get followingSystem => 'Following system';

  @override
  String get overrideActive => 'Override active';

  @override
  String get brightnessStill => 'still';

  @override
  String get brightnessUseSystem => 'use system';

  @override
  String get brightnessFull => 'full';

  @override
  String get sectionPracticeGuide => 'Practice guide';

  @override
  String get sectionPracticeGuideSub => 'Gestures and rhythms of use';

  @override
  String get howItWorks => 'How it works';

  @override
  String get howItWorksSub => 'Counting, undo, and the menu — explained';

  @override
  String get settingsGuidanceBody =>
      'The daily-goal sound plays when your goal is reached. The mala sound rings softly after every 108 chants — except when that count also completes the daily offering.';

  @override
  String get clearAllData => 'Clear all data';

  @override
  String get clearAllDataSub =>
      'Delete all counters and session history permanently';

  @override
  String get soundSystemDefaultTapToChange => 'System default — tap to change';

  @override
  String soundNamedTapToChange(String name) {
    return '$name — tap to change';
  }

  @override
  String get soundCustomTapToChange => 'Custom audio — tap to change';

  @override
  String get soundSystemDefault => 'System default';

  @override
  String get browseAudioFile => 'Browse audio file…';

  @override
  String get clearAllDataTitle => 'Clear all data?';

  @override
  String get clearAllDataMessage =>
      'This will permanently delete all counters and all session history. This cannot be undone.';

  @override
  String get clearAllButton => 'Clear all';

  @override
  String get allDataCleared => 'All data cleared';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpCountingTitle => 'Counting';

  @override
  String get helpCountingBody =>
      'Tap anywhere on the bead circle to count one chant. Each 108 chants completes one mala — the ring fills as the beads pass.';

  @override
  String get helpUndoTitle => 'Undoing a tap';

  @override
  String get helpUndoBody =>
      'Place two fingers on the bead circle and swipe — left or right — to undo your last chant. The session ends gracefully if the count returns to zero.';

  @override
  String get helpTimerTitle => 'Timer & status';

  @override
  String get helpTimerBody =>
      'The pill at the top shows the time spent in this session. The green marker below the count tells you how many beads remain in the current mala, or that the daily offering is complete.';

  @override
  String get helpResetTitle => 'Resetting';

  @override
  String get helpResetBody =>
      'Open the menu (the three dots, top right of the counting screen) for Reset session and Reset counter. Reset session discards the current sitting; Reset counter clears all history for that mantra.';

  @override
  String cardChantsMala(int malas) {
    return 'chants · $malas mala';
  }

  @override
  String get cardComplete => '✓ complete';

  @override
  String cardPercentDaily(int percent) {
    return '$percent% daily';
  }

  @override
  String get cardNoDaily => '—';

  @override
  String get cardTodayPrefix => 'TODAY · ';

  @override
  String cardChants(String count) {
    return '$count chants';
  }

  @override
  String cardMala(int count) {
    return '$count mala';
  }

  @override
  String cardMalaProgress(int current, int target) {
    return '$current / $target mala';
  }

  @override
  String cardLifetimePercent(String percent) {
    return 'lifetime · $percent%';
  }

  @override
  String cardLifetimePercentComplete(String percent) {
    return 'lifetime · $percent% ✓';
  }

  @override
  String get notifDailyGoalTitle => 'Daily Goal Achieved';

  @override
  String get notifDailyGoalBody =>
      'You have reached your daily mantra count goal!';

  @override
  String get backupShareSubject => 'SreerajP MantraJapa Counter Backup';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsAppearanceSub =>
      'Screen brightness, stillness mode & temple theme';

  @override
  String get settingsFeaturesTitle => 'Features';

  @override
  String get settingsFeaturesSub =>
      'Explore all features of SreerajP MantraJapa Counter';

  @override
  String get settingsHelpTitle => 'Help & User Guides';

  @override
  String get settingsHelpSub =>
      'How features like optical sync, mala counting & backup work';

  @override
  String get settingsAboutSub =>
      'Version, developer details & spiritual purpose';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get appearanceHeaderTitle => 'Temple Devotional Theme';

  @override
  String get appearanceHeaderSub =>
      'Custom stillness brightness, sacred South Indian temple palette, and classical typography for distraction-free chanting.';

  @override
  String get appearanceBrightnessSection => 'Screen Brightness & Stillness';

  @override
  String get appearancePaletteSection => 'Sacred Temple Palette';

  @override
  String get appearanceTypographySection => 'Typography & Scripts';

  @override
  String get paletteVermillionName => 'Vermillion (Sindoor)';

  @override
  String get paletteVermillionRole =>
      'Primary sacred accent, lotus motifs, active progress';

  @override
  String get paletteTulsiName => 'Tulsi Green';

  @override
  String get paletteTulsiRole =>
      'Daily goal completed, auspicious success indicator';

  @override
  String get paletteSandalName => 'Sandalwood (Chandan)';

  @override
  String get paletteSandalRole =>
      'Peaceful highlights, lifetime milestones, bead markers';

  @override
  String get paletteRoseName => 'Rose Devotion';

  @override
  String get paletteRoseRole =>
      'Soft devotional accents, multi-counter rotation';

  @override
  String get paletteCreamName => 'Temple Sanctum Cream';

  @override
  String get paletteCreamRole =>
      'Warm background reducing eye strain during long sittings';

  @override
  String get typographySerifTitle => 'EB Garamond (Devotional Serif)';

  @override
  String get typographySerifSub =>
      'Classical italic numerals, mala totals, and sacred headers';

  @override
  String get typographySansTitle => 'Inter (Clean UI Sans)';

  @override
  String get typographySansSub =>
      'Legible labels, practice history, and settings controls';

  @override
  String get typographyMalTitle => 'Noto Sans Malayalam (Indic Script)';

  @override
  String get typographyMalSub =>
      'Authentic Malayalam mantra titles and stotram rendering';

  @override
  String get featuresTitle => 'Features';

  @override
  String get featuresHeaderTitle => 'SreerajP MantraJapa Counter Features';

  @override
  String get featuresHeaderSub =>
      'Explore every sacred counting tool, air-gap sync safeguard, and temple aesthetic feature designed for your daily sadhana.';

  @override
  String get helpHeaderTitle => 'Help & User Guides';

  @override
  String get helpHeaderSub =>
      'Comprehensive guides to counting gestures, 108 mala calculations, optical air-gap sync, and privacy safeguards.';

  @override
  String get helpCategoryCounting => 'Counting & Meditation Practice';

  @override
  String get helpCategorySync => 'Data Sync & Backup';

  @override
  String get helpCategoryAudio => 'Audio & Feedback';

  @override
  String get helpCategoryPrivacy => 'Privacy & Support';

  @override
  String get helpTopicCountingTitle => 'Counting & Gestures Guide';

  @override
  String get helpTopicCountingSub =>
      'Tap anywhere on the ring, two-finger swipe undo, and session persistence';

  @override
  String get helpTopicMalaTitle => '108 Mala Math & Goals';

  @override
  String get helpTopicMalaSub =>
      'How 108 bead cycles are calculated, excess counts, and daily goal targets';

  @override
  String get helpTopicOpticalSyncTitle => 'Optical Air-Gap Sync';

  @override
  String get helpTopicOpticalSyncSub =>
      'Offline phone-to-phone data transfer via animated QR camera stream';

  @override
  String get helpTopicBackupTitle => 'JSON Backup & Restore';

  @override
  String get helpTopicBackupSub =>
      'Exporting local backup files, sharing, and safe database restoration';

  @override
  String get helpTopicAudioTitle => 'Sound & Vibration Settings';

  @override
  String get helpTopicAudioSub =>
      'Temple bell tones, mala chimes, custom audio files, and haptic feedback';

  @override
  String get helpTopicPrivacyTitle => 'Privacy & Offline-First Core';

  @override
  String get helpTopicPrivacySub =>
      'Zero internet permissions, local SQLite storage, and zero telemetry';

  @override
  String get helpTopicFaqTitle => 'FAQs & Troubleshooting';

  @override
  String get helpTopicFaqSub =>
      'Frequently asked questions, common issues, and helpful usage tips';

  @override
  String get helpCountingIntro =>
      'The counting screen is intentionally designed for quiet, mindful focus. You do not need to look at the screen while chanting.';

  @override
  String get helpCountingTapSection => 'How to Count';

  @override
  String get helpCountingTapBold1 => 'Tap anywhere:';

  @override
  String get helpCountingTapBullet1 =>
      'Tap inside the large circle or anywhere on the central screen to increment by 1 count.';

  @override
  String get helpCountingTapBold2 => 'Haptic pulse:';

  @override
  String get helpCountingTapBullet2 =>
      'A gentle vibration confirms every chant so you can keep your eyes closed during meditation.';

  @override
  String get helpCountingTapBold3 => 'Crash recovery:';

  @override
  String get helpCountingTapBullet3 =>
      'Every 5 taps are automatically saved to local storage. If your battery dies, not a single count is lost.';

  @override
  String get helpCountingUndoSection => 'Undoing an Accidental Count';

  @override
  String get helpCountingUndoBold1 => 'Two-finger swipe:';

  @override
  String get helpCountingUndoBullet1 =>
      'Swipe left or right across the mala circle with two fingers to decrement the count by 1.';

  @override
  String get helpCountingUndoBold2 => 'Zero count threshold:';

  @override
  String get helpCountingUndoBullet2 =>
      'If you reduce the session count to zero, the sitting session is gracefully cleared without polluting history.';

  @override
  String get helpCountingTimerSection => 'Session Timing & Status';

  @override
  String get helpCountingTimerBold1 => 'Active timer:';

  @override
  String get helpCountingTimerBullet1 =>
      'The top capsule displays the active duration spent in this sitting.';

  @override
  String get helpCountingTimerBold2 => 'Progress badge:';

  @override
  String get helpCountingTimerBullet2 =>
      'Shows remaining beads to complete the current 108 cycle or confirms daily goal completion.';

  @override
  String get helpMalaIntro =>
      'In traditional Vedic and Buddhist practices, a Japa Mala consists of 108 beads. The app faithfully calculates rounds and progress based on this sacred principle.';

  @override
  String get helpMalaBeadsSection => '108 Beads Calculation';

  @override
  String get helpMalaBeadsBold1 => '1 Mala = 108 counts:';

  @override
  String get helpMalaBeadsBullet1 =>
      'Every 108 counts automatically completes 1 full mala round.';

  @override
  String get helpMalaBeadsBold2 => 'Excess counts:';

  @override
  String get helpMalaBeadsBullet2 =>
      'Counts between mala multiples (e.g. 115 counts = 1 mala + 7 counts) are clearly shown.';

  @override
  String get helpMalaBeadsBold3 => 'Mala chime:';

  @override
  String get helpMalaBeadsBullet3 =>
      'When enabled, a gentle bell sounds on the exact 108th bead of each round.';

  @override
  String get helpMalaGoalsSection => 'Setting Goals & Dedications';

  @override
  String get helpMalaGoalsBold1 => 'Daily target:';

  @override
  String get helpMalaGoalsBullet1 =>
      'Set how many malas you commit to chanting every day. The card turns green upon reaching the target.';

  @override
  String get helpMalaGoalsBold2 => 'Lifetime target:';

  @override
  String get helpMalaGoalsBullet2 =>
      'Set long-term sadhana goals (e.g. 100,000 chants or 1,000 malas) to track your cumulative spiritual journey.';

  @override
  String get helpOpticalIntro =>
      'Optical Air-Gap Sync allows you to migrate all your counters and history between two phones without Wi-Fi, Bluetooth, or cloud servers.';

  @override
  String get helpOpticalHowSection => 'How to Transfer';

  @override
  String get helpOpticalHowBold1 => 'On the sender phone:';

  @override
  String get helpOpticalHowBullet1 =>
      'Go to Settings -> Optical Air-Gap Sync (Send). An animated QR stream will begin playing.';

  @override
  String get helpOpticalHowBold2 => 'On the receiver phone:';

  @override
  String get helpOpticalHowBullet2 =>
      'Go to Settings -> Optical Air-Gap Sync (Receive) and point the camera at the sender phone\'s screen.';

  @override
  String get helpOpticalHowBold3 => 'Automatic assembly:';

  @override
  String get helpOpticalHowBullet3 =>
      'The receiver collects stream packets and reconstructs the full database with zero data corruption.';

  @override
  String get helpOpticalTipsSection => 'Tips for Fast Scanning';

  @override
  String get helpOpticalTipsBold1 => 'Screen brightness:';

  @override
  String get helpOpticalTipsBullet1 =>
      'Ensure the sending screen is at moderate-to-high brightness without screen glare.';

  @override
  String get helpOpticalTipsBold2 => 'Steady distance:';

  @override
  String get helpOpticalTipsBullet2 =>
      'Hold the receiving phone steadily 15 to 25 cm away from the sender screen.';

  @override
  String get helpOpticalTipsBold3 => 'Fountain codes:';

  @override
  String get helpOpticalTipsBullet3 =>
      'Even if the camera drops a few frames, fountain parity packets will recover the missing data.';

  @override
  String get helpAudioIntro =>
      'Personalize the soundscape of your practice with gentle bells, temple chimes, and haptic vibrations.';

  @override
  String get helpAudioTonesSection => 'Chimes & Notification Tones';

  @override
  String get helpAudioTonesBold1 => 'Daily goal tone:';

  @override
  String get helpAudioTonesBullet1 =>
      'Plays a peaceful bell tone when you reach your daily target for any mantra.';

  @override
  String get helpAudioTonesBold2 => 'Mala chime:';

  @override
  String get helpAudioTonesBullet2 =>
      'Plays a soft chime on the 108th bead of every round.';

  @override
  String get helpAudioTonesBold3 => 'Custom audio picker:';

  @override
  String get helpAudioTonesBullet3 =>
      'Choose any MP3, WAV, or ringtone audio file from your device.';

  @override
  String get helpAudioVibrationSection => 'Haptic Vibration';

  @override
  String get helpAudioVibrationBold1 => 'Count pulse:';

  @override
  String get helpAudioVibrationBullet1 =>
      'Subtle tactile pulse with every chant to keep track without looking.';

  @override
  String get helpAudioVibrationBold2 => 'Disable anytime:';

  @override
  String get helpAudioVibrationBullet2 =>
      'Turn off vibration under Settings if you prefer silent meditation.';

  @override
  String get helpBackupIntro =>
      'Your practice data is 100% owned by you. You can export complete backups to JSON files at any time.';

  @override
  String get helpBackupExportSection => 'Exporting Data';

  @override
  String get helpBackupExportBold1 => 'Standard JSON file:';

  @override
  String get helpBackupExportBullet1 =>
      'Exports all counters, daily goals, lifetime progress, and session history into one clean file.';

  @override
  String get helpBackupExportBold2 => 'System share sheet:';

  @override
  String get helpBackupExportBullet2 =>
      'Save the exported file to your local files, SD card, or share it via your favorite offline file transfer app.';

  @override
  String get helpBackupExportBold3 => 'Room & Gson compatible:';

  @override
  String get helpBackupExportBullet3 =>
      'Fully compatible with existing and future versions of the app.';

  @override
  String get helpBackupImportSection => 'Restoring Data';

  @override
  String get helpBackupImportBold1 => 'File picker:';

  @override
  String get helpBackupImportBullet1 =>
      'Tap \'Import Backup File\' and select your previously saved JSON file.';

  @override
  String get helpBackupImportBold2 => 'Safe validation:';

  @override
  String get helpBackupImportBullet2 =>
      'The file is verified for integrity before restoring to prevent corrupted entries.';

  @override
  String get helpBackupImportBold3 => 'Instant refresh:';

  @override
  String get helpBackupImportBullet3 =>
      'Counters and session history update immediately across the app.';

  @override
  String get helpPrivacyIntro =>
      'SreerajP MantraJapa Counter is built with a strict privacy-first and offline-first ethos.';

  @override
  String get helpPrivacyOfflineSection => '100% Offline by Design';

  @override
  String get helpPrivacyOfflineBold1 => 'No INTERNET permission:';

  @override
  String get helpPrivacyOfflineBullet1 =>
      'The app does not declare the Android INTERNET permission and cannot access the web.';

  @override
  String get helpPrivacyOfflineBold2 => 'Zero telemetry & tracking:';

  @override
  String get helpPrivacyOfflineBullet2 =>
      'No analytics SDKs, crash reporters, or background advertising services are bundled.';

  @override
  String get helpPrivacyOfflineBold3 => 'No cloud login:';

  @override
  String get helpPrivacyOfflineBullet3 =>
      'You never need to create an account or provide an email or phone number.';

  @override
  String get helpPrivacyStorageSection => 'Local Storage & Data Integrity';

  @override
  String get helpPrivacyStorageBold1 => 'SQLite database:';

  @override
  String get helpPrivacyStorageBullet1 =>
      'All counters and session history reside inside an encrypted/isolated SQLite database on your device.';

  @override
  String get helpPrivacyStorageBold2 => 'Crash-proof writes:';

  @override
  String get helpPrivacyStorageBullet2 =>
      'Frequent recovery checkpoints ensure your count is preserved during sudden app switches.';

  @override
  String get helpFaqIntro =>
      'Quick answers to common questions about SreerajP MantraJapa Counter.';

  @override
  String get helpFaqQ1Title => 'Why is the app completely offline?';

  @override
  String get helpFaqQ1Answer =>
      'Japa meditation is a deeply personal and sacred practice. By running strictly offline with no network permissions, we ensure complete privacy, battery efficiency, and zero distractions.';

  @override
  String get helpFaqQ2Title =>
      'How does Optical Air-Gap Sync work without internet?';

  @override
  String get helpFaqQ2Answer =>
      'The sending phone converts your backup into an animated stream of QR codes displayed on screen. The receiving phone\'s camera reads these frames and reassembles the complete database locally in seconds.';

  @override
  String get helpFaqQ3Title => 'What does Stillness Brightness mode do?';

  @override
  String get helpFaqQ3Answer =>
      'It allows you to dim the screen to minimal ambient brightness so you can chant in dark rooms or temples without glaring light disturbing others.';

  @override
  String get helpFaqQ4Title =>
      'Can I transfer my data when upgrading to a new phone?';

  @override
  String get helpFaqQ4Answer =>
      'Yes! You can either use Optical Air-Gap Sync between both phones side-by-side or export a JSON backup file to restore on the new device.';

  @override
  String get lockCounter => 'Lock counter';

  @override
  String get unlockCounter => 'Unlock counter';

  @override
  String counterLockedNotice(String name) {
    return '\"$name\" is locked. Unlock to start chanting.';
  }

  @override
  String get counterLockedTooltip => 'Locked — tap to unlock';

  @override
  String get counterUnlockedTooltip => 'Unlocked — tap to lock';

  @override
  String get statusLocked => 'Locked';
}
