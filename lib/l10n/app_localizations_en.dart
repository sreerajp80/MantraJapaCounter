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
  String get aboutMantraQuote =>
      'Ganeshaya Namah, Hare Krishna, Durgayei Namah';

  @override
  String get aboutMadeWithPrefix => 'Made with ';

  @override
  String get aboutMadeWithSuffix => ' from India';

  @override
  String madeWithLove(String heart) {
    return 'Made with $heart from India';
  }

  @override
  String get madeWithLoveA11y => 'Made with love from India';

  @override
  String get aboutDetailAuthor => 'Author';

  @override
  String get aboutDetailEmail => 'Email';

  @override
  String get aboutDetailLicense => 'License';

  @override
  String get aboutDetailAiUsed => 'AI used';

  @override
  String get aboutDetailIdeUsed => 'IDE used';

  @override
  String get aboutDescription =>
      'Offline-first application for tracking mantra recitation practice with customizable counters and session history.';

  @override
  String get aboutAuthor => 'Author';

  @override
  String get aboutAuthorValue => 'Sreeraj P';

  @override
  String get aboutEmail => 'Email';

  @override
  String get aboutLicense => 'License';

  @override
  String get aboutLicenseValue => 'All libraries used are open source.';

  @override
  String get aboutAiUsed => 'AI used';

  @override
  String get aboutAiUsedValue => 'Google Gemini / Anthropic Claude';

  @override
  String get aboutIdeUsed => 'IDE used';

  @override
  String get aboutIdeUsedValue => 'VS Code / Antigravity IDE';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get practiceEyebrow => 'PRACTICE';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get sectionLanguageSub => 'App display language';

  @override
  String get appLanguage => 'App language';

  @override
  String get systemDefault => 'System default';

  @override
  String get englishLanguage => 'English';

  @override
  String get malayalamLanguage => 'Malayalam';

  @override
  String get sanskritLanguage => 'Sanskrit';

  @override
  String get selectLanguageTitle => 'Select language';

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
  String get malaSoundTitle => 'Mala sound';

  @override
  String get malaSoundSub => 'Sacred sound played when completing 108 beads';

  @override
  String get soundTempleBell => 'Temple Bronze Bell';

  @override
  String get soundTempleBellSub => 'Deep, tranquil bronze resonance (Ghanta)';

  @override
  String get soundSingingBowl => 'Tibetan Singing Bowl';

  @override
  String get soundSingingBowlSub =>
      'Soothing harmonic overtone for quiet mindfulness';

  @override
  String get soundSynthesizedTone => 'Synthesized Tone';

  @override
  String get soundSynthesizedToneSub => 'Classic 100ms electronic beep (DTMF)';

  @override
  String get sectionStillness => 'Stillness';

  @override
  String get sectionStillnessSub => 'For longer sessions';

  @override
  String get dndTitle => 'Silence notifications (Do Not Disturb)';

  @override
  String get dndSub => 'Silence incoming alerts and calls while chanting';

  @override
  String get dndPermissionTitle => 'Do Not Disturb Permission';

  @override
  String get dndPermissionMessage =>
      'To automatically silence incoming calls and notifications during chanting, please allow Do Not Disturb access in Android settings.';

  @override
  String get dndOpenSettings => 'Open Settings';

  @override
  String get dimmedModeTitle => 'Dimmed Chanting Mode';

  @override
  String get dimmedModeSub =>
      'Darkens the background while keeping the mala circle clearly visible to save battery';

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

  @override
  String get settingsBackupTitle => 'Data Backup & Optical Sync';

  @override
  String get settingsBackupSub =>
      '100% offline device-to-device sync and backup';

  @override
  String get settingsOpticalSendTitle => 'Optical Air-Gap Sync (Send)';

  @override
  String get settingsOpticalSendSub =>
      'Transmit counters & history via animated QR stream';

  @override
  String get settingsOpticalReceiveTitle => 'Optical Air-Gap Sync (Receive)';

  @override
  String get settingsOpticalReceiveSub =>
      'Scan animated QR stream from another phone camera';

  @override
  String get settingsExportTitle => 'Export Backup File (JSON)';

  @override
  String get settingsExportSub =>
      'Export all data to a local JSON file & share sheet';

  @override
  String get settingsImportTitle => 'Import Backup File (JSON)';

  @override
  String get settingsImportSub =>
      'Restore counters and history from a backup file';

  @override
  String get dataRestoredSuccess => 'Data restored successfully!';

  @override
  String get opticalSendTitle => 'Optical Sync Stream (Send)';

  @override
  String get opticalReceiveTitle => 'Optical Sync Receiver (Scan)';

  @override
  String get opticalNoFrames => 'No data frames generated.';

  @override
  String opticalSessionId(String id) {
    return 'SESSION ID: $id';
  }

  @override
  String opticalFrameProgress(int current, int total) {
    return 'Frame $current / $total';
  }

  @override
  String opticalSystematicChunk(int index) {
    return 'Systematic Data Chunk #$index';
  }

  @override
  String opticalParityFrame(int index) {
    return 'Fountain Parity Frame #$index';
  }

  @override
  String get opticalStreamRate => 'Stream Rate (FPS)';

  @override
  String get opticalSendHint =>
      'Point the receiving device\'s camera at this screen. The animated QR stream will transmit all counters and session history 100% offline.';

  @override
  String opticalReconstructing(int done, int total) {
    return 'Reconstructing: $done / $total chunks';
  }

  @override
  String get opticalAlignCamera => 'Align camera with animated QR stream...';

  @override
  String get opticalStreamComplete => 'Optical Sync Stream Complete';

  @override
  String get opticalStatCounters => 'Counters';

  @override
  String get opticalStatSessionLogs => 'Session Logs';

  @override
  String get opticalImportRestore => 'Import & Restore Data';

  @override
  String get opticalImportSuccess =>
      'Optical sync import successful! Data restored.';

  @override
  String get opticalImportFailed => 'Failed to import data.';

  @override
  String get featCat1Name => 'Sacred Japa & Mala Counting';

  @override
  String get featCat1Sub =>
      'Distraction-free chanting, 108 mala mathematics, and fluid gestures';

  @override
  String get featCat2Name => 'Optical Air-Gap Sync & Data Safety';

  @override
  String get featCat2Sub =>
      '100% offline device-to-device synchronization via camera & QR streaming';

  @override
  String get featCat3Name => 'Practice Insights & History';

  @override
  String get featCat3Sub =>
      'Comprehensive daily logs, streak counters, and per-counter breakdowns';

  @override
  String get featCat4Name => 'Temple Aesthetics, Audio & Haptics';

  @override
  String get featCat4Sub =>
      'Peaceful devotional palette, resonant bell tones, and Malayalam support';

  @override
  String get featCat5Name => 'Privacy & Offline-First Core';

  @override
  String get featCat5Sub =>
      'Zero cloud tracking, zero network requests, and absolute data privacy';

  @override
  String get featMalaTitle => '108 Mala Beads Calculation';

  @override
  String get featMalaDesc =>
      'Automatically calculates completed malas (1 mala = 108 chants) and keeps track of excess counts and progress rings.';

  @override
  String get featMalaH1 => '108 beads formula';

  @override
  String get featMalaH2 => 'Excess counts counter';

  @override
  String get featMalaH3 => 'Mala completion chime';

  @override
  String get featImmersionTitle => 'Full-Screen Immersion & Tap Area';

  @override
  String get featImmersionDesc =>
      'Tap anywhere on the large sacred ring to increment your count effortlessly without needing to look at specific buttons.';

  @override
  String get featImmersionH1 => 'Large touch zone';

  @override
  String get featImmersionH2 => 'Subtle haptic pulse';

  @override
  String get featImmersionH3 => 'Distraction-free focus';

  @override
  String get featUndoTitle => 'Two-Finger Swipe Undo';

  @override
  String get featUndoDesc =>
      'Made an accidental count? Simply swipe left or right with two fingers on the ring to decrement the count cleanly.';

  @override
  String get featUndoH1 => 'Horizontal swipe gesture';

  @override
  String get featUndoH2 => 'Instant count reversal';

  @override
  String get featUndoH3 => 'Prevents over-counting';

  @override
  String get featTimerTitle => 'Persistent Session Timer & Goals';

  @override
  String get featTimerDesc =>
      'Tracks active sitting duration with automatic background pause. Configure daily goals and lifetime dedication targets per mantra.';

  @override
  String get featTimerH1 => 'Active duration timer';

  @override
  String get featTimerH2 => 'Per-mantra daily goals';

  @override
  String get featTimerH3 => 'Lifetime dedication target';

  @override
  String get featQrStreamTitle => 'High-Density Animated QR Stream';

  @override
  String get featQrStreamDesc =>
      'Transfer complete practice records, counters, and history between phones in seconds using a high-speed optical QR code stream.';

  @override
  String get featQrStreamH1 => 'Zero Wi-Fi / Bluetooth';

  @override
  String get featQrStreamH2 => '10-15 FPS animated stream';

  @override
  String get featQrStreamH3 => 'Instant phone transfer';

  @override
  String get featFountainTitle => 'Luby Transform Fountain Code Recovery';

  @override
  String get featFountainDesc =>
      'Transfers data using mathematical fountain codes and CRC32 verification so dropped camera frames are recovered automatically.';

  @override
  String get featFountainH1 => 'Loss-tolerant recovery';

  @override
  String get featFountainH2 => 'CRC32 checksums';

  @override
  String get featFountainH3 => 'Out-of-order frame assembly';

  @override
  String get featJsonExportTitle => 'Offline JSON Export & Restore';

  @override
  String get featJsonExportDesc =>
      'Export full database backups to a plain JSON file to save on your local storage, share sheet, or restore anytime.';

  @override
  String get featJsonExportH1 => 'Standard JSON schema';

  @override
  String get featJsonExportH2 => 'One-tap export/import';

  @override
  String get featJsonExportH3 => 'Room/Gson compatibility';

  @override
  String get featDailyLogTitle => 'Daily Practice Log & Breakdown';

  @override
  String get featDailyLogDesc =>
      'Review historical sittings grouped by date with start timestamps, sitting duration, counts chanted, and malas completed.';

  @override
  String get featDailyLogH1 => 'Date-wise grouping';

  @override
  String get featDailyLogH2 => 'Sitting duration breakdown';

  @override
  String get featDailyLogH3 => 'Daily mala tally';

  @override
  String get featFilterTitle => 'Per-Counter Filtering';

  @override
  String get featFilterDesc =>
      'Isolate and view history for individual mantras or view the combined sadhana across all active counters.';

  @override
  String get featFilterH1 => 'Specific mantra view';

  @override
  String get featFilterH2 => 'Combined daily view';

  @override
  String get featFilterH3 => 'Lifetime totals';

  @override
  String get featPaletteTitle => 'Temple Devotional Palette';

  @override
  String get featPaletteDesc =>
      'Authentic temple palette with sacred cream backgrounds and vermillion, sandal yellow, tulsi green, and rose accents.';

  @override
  String get featPaletteH1 => 'Cream & gold background';

  @override
  String get featPaletteH2 => 'Vermillion & Tulsi accents';

  @override
  String get featPaletteH3 => 'Serif numeral typography';

  @override
  String get featBellTitle => 'Peaceful Bell Tones & Audio Picker';

  @override
  String get featBellDesc =>
      'Gentle meditation chimes when completing malas or reaching daily goals. Choose system ringtones or pick custom local audio files.';

  @override
  String get featBellH1 => 'Mala & goal bell tones';

  @override
  String get featBellH2 => 'Custom audio picker';

  @override
  String get featBellH3 => 'Tone preview in settings';

  @override
  String get featBrightnessTitle => 'Stillness Brightness Mode';

  @override
  String get featBrightnessDesc =>
      'Dim screen brightness to minimal ambient levels for distraction-free early morning, temple, or late-night meditation.';

  @override
  String get featBrightnessH1 => 'Custom brightness slider';

  @override
  String get featBrightnessH2 => '1-tap system restore';

  @override
  String get featBrightnessH3 => 'OLED battery efficiency';

  @override
  String get featBilingualTitle => 'Bilingual Malayalam & English UI';

  @override
  String get featBilingualDesc =>
      'Full Malayalam scripture and interface support alongside English with bundled Noto Sans Malayalam fonts.';

  @override
  String get featBilingualH1 => 'Full Malayalam localization';

  @override
  String get featBilingualH2 => 'Authentic Indic font glyphs';

  @override
  String get featBilingualH3 => '1-tap language switch';

  @override
  String get featOfflineTitle => '100% Offline with Zero INTERNET Permission';

  @override
  String get featOfflineDesc =>
      'The application manifest completely lacks internet permissions. No telemetry, ads, or analytics can ever run.';

  @override
  String get featOfflineH1 => 'No INTERNET permission';

  @override
  String get featOfflineH2 => 'Zero cloud telemetry';

  @override
  String get featOfflineH3 => 'No tracking or ads';

  @override
  String get featSqliteTitle => 'Local SQLite Database & Crash Recovery';

  @override
  String get featSqliteDesc =>
      'Dual-layer persistence saves active counts every 5 taps/5 seconds to prevent accidental data loss during phone reboots.';

  @override
  String get featSqliteH1 => 'ACID-compliant SQLite v3';

  @override
  String get featSqliteH2 => '5-tap crash recovery';

  @override
  String get featSqliteH3 => 'Safe data migrations';

  @override
  String get opticalStreamCompleteSub =>
      '100% offline payload reconstructed via camera scanner.';

  @override
  String get selectCountersTitle => 'Select Counters';

  @override
  String get selectCountersSub => 'Choose which counters to include';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String selectedCountersCount(int count) {
    return '$count selected';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get noCountersSelected => 'Please select at least one counter';

  @override
  String get encryptBackup => 'Encrypt Backup';

  @override
  String get encryptBackupSub => 'Protect with a passphrase (AES-256-GCM)';

  @override
  String get enterPassphrase => 'Enter passphrase';

  @override
  String get confirmPassphrase => 'Confirm passphrase';

  @override
  String get passphraseMismatch => 'Passphrases do not match';

  @override
  String get passphraseTooShort => 'Passphrase must be at least 6 characters';

  @override
  String get decryptBackup => 'Decrypt & Import';

  @override
  String get decryptPassphrasePrompt =>
      'This backup is encrypted. Enter the passphrase to decrypt.';

  @override
  String get decryptFailed =>
      'Decryption failed. Wrong passphrase or corrupted file.';

  @override
  String get skipEncryption => 'Skip (export unencrypted)';

  @override
  String get opticalSelectCountersHint =>
      'Select which counters to transmit via optical sync';

  @override
  String get opticalImportSelectHint =>
      'Choose which counters to import from the received data';

  @override
  String get notifLifetimeGoalTitle => 'Lifetime Goal Achieved!';

  @override
  String get notifLifetimeGoalBody =>
      'Auspicious milestone reached. May your sadhana bring peace and liberation.';

  @override
  String get lifetimeSoundTitle => 'Lifetime goal tone';

  @override
  String get lifetimeSoundSub =>
      'Sacred chime played when lifetime target is reached';

  @override
  String get enableLifetimeNotification => 'Lifetime goal notification';

  @override
  String get enableLifetimeNotificationSub =>
      'Show notification when lifetime milestone is reached';

  @override
  String get soundSacredShankha => 'Sacred Shankha';

  @override
  String get soundSacredShankhaSub =>
      'Conch shell resonance sounding spiritual victory';

  @override
  String get settingsSoundTitle => 'Sound & Haptics';

  @override
  String get settingsSoundSub =>
      'Mala chimes, goal completion tones, and vibration';

  @override
  String get settingsDisplayTitle => 'Display & Stillness';

  @override
  String get settingsDisplaySub =>
      'Screen brightness and sacred stillness mode';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSub => 'App language, script, and numbering';

  @override
  String get settingsPermissionsTitle => 'Permissions';

  @override
  String get settingsPermissionsSub =>
      'What device capabilities the app uses and why';

  @override
  String get settingsClearDataTitle => 'Clear all data';

  @override
  String get settingsClearDataSub =>
      'Delete all counters and chanting sessions';

  @override
  String get permissionsExplicitHeader => 'Explicit Permissions';

  @override
  String get permissionsExplicitSub =>
      'Permissions requested at runtime only when you invoke specific features';

  @override
  String get permissionsImplicitHeader => 'Implicit Permissions';

  @override
  String get permissionsImplicitSub =>
      'Normal permissions granted automatically by Android to deliver core offline functions';

  @override
  String get permissionsPrivacyHeader => 'Zero-Trust Privacy Guarantee';

  @override
  String get permissionsPrivacySub =>
      'Permissions deliberately omitted to safeguard your spiritual practice';

  @override
  String get permCameraTitle => 'Camera';

  @override
  String get permCameraDesc =>
      'Used exclusively to scan animated QR fountain codes when receiving data via air-gapped Optical Sync. Never captures photos or videos.';

  @override
  String get permNotificationTitle => 'Notifications';

  @override
  String get permNotificationDesc =>
      'Used on Android 13+ to show milestone banners in the status bar when daily or lifetime mantra targets are completed.';

  @override
  String get permVibrationTitle => 'Vibration';

  @override
  String get permVibrationDesc =>
      'Delivers gentle haptic feedback on each chant tap, mala completion, and goal achievement, remaining tactile even in silent mode.';

  @override
  String get permAudioTitle => 'Audio Management';

  @override
  String get permAudioDesc =>
      'Temporarily routes completion chimes through the alarm audio stream so sacred bells remain audible during meditation.';

  @override
  String get permNoInternetTitle => 'Zero Internet Access';

  @override
  String get permNoInternetDesc =>
      'The app contains no internet permission. It cannot transmit data, connect to cloud servers, or track analytics.';

  @override
  String get permNoStorageTitle => 'No Broad Storage Access';

  @override
  String get permNoStorageDesc =>
      'Instead of accessing your personal files, exports and imports use Android\'s native system picker with user consent.';

  @override
  String get tutorialTitle => 'App Tutorial';

  @override
  String get tutorialSub =>
      'Step-by-step visual walkthrough of all app features';

  @override
  String get tutorialStep1Title => '1. Create Your First Counter';

  @override
  String get tutorialStep1Desc =>
      'Tap the add button (+) on the home screen. Enter the mantra name, choose an increment step, and set daily and lifetime goals.';

  @override
  String get tutorialStep2Title => '2. Sacred Fullscreen Counting';

  @override
  String get tutorialStep2Desc =>
      'Tap anywhere on the large counting surface to advance counts. Swipe downwards to undo an accidental tap. Use the stillness slider to dim the screen.';

  @override
  String get tutorialStep3Title => '3. 108 Beads Mala System';

  @override
  String get tutorialStep3Desc =>
      'Every 108 chants automatically complete one mala. The app chimes sacred temple bells and records your completed malas with precision.';

  @override
  String get tutorialStep4Title => '4. Daily & Lifetime Milestones';

  @override
  String get tutorialStep4Desc =>
      'When your daily or lifetime target is met, custom sacred tones and auspicious badges celebrate your spiritual milestone.';

  @override
  String get tutorialStep5Title => '5. Locking & Archiving';

  @override
  String get tutorialStep5Desc =>
      'Long-press any counter card to lock it against accidental touches, or retire completed mantras with a completion status.';

  @override
  String get tutorialStep6Title => '6. Air-Gapped Optical QR Sync';

  @override
  String get tutorialStep6Desc =>
      'Migrate your japa counters between devices without internet, Bluetooth, or cables using animated QR camera streaming.';

  @override
  String get tutorialStep7Title => '7. Encrypted Backups';

  @override
  String get tutorialStep7Desc =>
      'Export your entire sadhana history to a file protected by AES-256-GCM encryption with your personal passphrase.';
}
