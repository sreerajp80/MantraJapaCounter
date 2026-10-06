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
  String unfinishedMalaBanner(int chants) {
    return 'Unfinished mala from an earlier day: $chants/108';
  }

  @override
  String get startNewSession => 'Start new';

  @override
  String get finishAndStartNew => 'Finish & start new';

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
      'Guides for every part of the app: counters, counting, malas and goals, history, sound, display, backup, optical sync and privacy.';

  @override
  String get helpCategoryCounting => 'Counting & Meditation Practice';

  @override
  String get helpCategorySync => 'Data Sync & Backup';

  @override
  String get helpCategoryAudio => 'Sound, Display & Stillness';

  @override
  String get helpCategoryPrivacy => 'Privacy & Support';

  @override
  String get helpTopicCountingTitle => 'Counting & Gestures Guide';

  @override
  String get helpTopicCountingSub =>
      'Tap inside the circle, two-finger undo, the counting menu and auto save';

  @override
  String get helpTopicMalaTitle => '108 Mala Math & Goals';

  @override
  String get helpTopicMalaSub =>
      '108-bead rounds, extra counts, and daily and lifetime goals';

  @override
  String get helpTopicOpticalSyncTitle => 'Optical Air-Gap Sync';

  @override
  String get helpTopicOpticalSyncSub =>
      'Phone-to-phone transfer with a moving QR code, without internet';

  @override
  String get helpTopicBackupTitle => 'Backup & Restore';

  @override
  String get helpTopicBackupSub =>
      'Export to a file, encrypted backups, import and clear all data';

  @override
  String get helpTopicAudioTitle => 'Sound & Vibration Settings';

  @override
  String get helpTopicAudioSub =>
      'Mala sound, goal tones, notifications and vibration';

  @override
  String get helpTopicPrivacyTitle => 'Privacy & Offline-First Core';

  @override
  String get helpTopicPrivacySub =>
      'No internet permission, private storage, and the permissions used';

  @override
  String get helpTopicFaqTitle => 'FAQs & Troubleshooting';

  @override
  String get helpTopicFaqSub =>
      'Frequently asked questions, common issues, and helpful usage tips';

  @override
  String get helpCountingIntro =>
      'The counting screen is made for quiet focus. You do not need to look at it while you chant.';

  @override
  String get helpCountingTapSection => 'How to count';

  @override
  String get helpCountingTapBold1 => 'Tap inside the circle:';

  @override
  String get helpCountingTapBullet1 =>
      'Only taps inside the mala circle are counted. Taps outside it are ignored, so a stray touch does not add a count.';

  @override
  String get helpCountingTapBold2 => 'Increment step:';

  @override
  String get helpCountingTapBullet2 =>
      'Each tap adds the counter\'s step (1 by default). Change it by editing the counter.';

  @override
  String get helpCountingTapBold3 => 'Quiet taps:';

  @override
  String get helpCountingTapBullet3 =>
      'Taps do not vibrate. You feel a vibration on each full mala, on goals and on undo, if vibration is on.';

  @override
  String get helpCountingUndoSection => 'Undoing a count';

  @override
  String get helpCountingUndoBold1 => 'Two-finger swipe:';

  @override
  String get helpCountingUndoBullet1 =>
      'Place two fingers on the circle and slide them left or right. One swipe removes one step, and the phone vibrates once.';

  @override
  String get helpCountingUndoBold2 => 'Back to zero:';

  @override
  String get helpCountingUndoBullet2 =>
      'If the session count goes back to 0, the sitting is cleared and nothing is added to history.';

  @override
  String get helpMalaIntro =>
      'A traditional japa mala has 108 beads. The app counts in rounds of 108 and shows your goals on every card.';

  @override
  String get helpMalaBeadsSection => '108 beads';

  @override
  String get helpMalaBeadsBold1 => '1 mala = 108 counts:';

  @override
  String get helpMalaBeadsBullet1 =>
      'Every 108 counts make one full mala. The circle on the counting screen fills bead by bead and starts again after 108.';

  @override
  String get helpMalaBeadsBold2 => 'Extra counts:';

  @override
  String get helpMalaBeadsBullet2 =>
      'Counts past a full mala are kept and shown. For example, 115 counts = 1 mala and 7 counts.';

  @override
  String get helpMalaBeadsBold3 => 'Bigger steps:';

  @override
  String get helpMalaBeadsBullet3 =>
      'If your step is more than 1, each tap moves several beads at once. Malas are still worked out from the total count.';

  @override
  String get helpMalaGoalsSection => 'Daily and lifetime goals';

  @override
  String get helpMalaGoalsBold1 => 'Daily goal:';

  @override
  String get helpMalaGoalsBullet1 =>
      'The number of chants you want to offer each day (0 = no daily goal). It starts again from 0 at midnight, by your phone\'s clock.';

  @override
  String get helpMalaGoalsBold2 => 'Lifetime goal (vow):';

  @override
  String get helpMalaGoalsBullet2 =>
      'Your long-term target, for example 1,00,000 chants (0 = no lifetime goal). The daily goal cannot be more than it.';

  @override
  String get helpOpticalIntro =>
      'Optical Sync moves your counters and history from one phone to another using only the screen and the camera. No internet, Wi-Fi, Bluetooth or cable is needed.';

  @override
  String get helpOpticalHowSection => 'How to transfer';

  @override
  String get helpOpticalHowBold1 => 'Sender phone:';

  @override
  String get helpOpticalHowBullet1 =>
      'Settings → Data Backup & Optical Sync → Optical Air-Gap Sync (Send). Choose the counters to send. A moving QR code starts to play.';

  @override
  String get helpOpticalHowBold2 => 'Receiver phone:';

  @override
  String get helpOpticalHowBullet2 =>
      'Open Optical Air-Gap Sync (Receive), allow the camera, and point it at the sender\'s screen.';

  @override
  String get helpOpticalHowBold3 => 'Preview:';

  @override
  String get helpOpticalHowBullet3 =>
      'When all parts arrive, a preview shows the counters and sessions. Choose the counters to keep and tap the restore button.';

  @override
  String get helpOpticalTipsSection => 'Tips for fast scanning';

  @override
  String get helpOpticalTipsBold1 => 'Distance:';

  @override
  String get helpOpticalTipsBullet1 =>
      'Hold the receiving phone steady, about 15–25 cm from the sender\'s screen, with the code inside the guide box.';

  @override
  String get helpOpticalTipsBold2 => 'Glare:';

  @override
  String get helpOpticalTipsBullet2 =>
      'Avoid bright reflections on the sender\'s screen.';

  @override
  String get helpOpticalTipsBold3 => 'Missed frames:';

  @override
  String get helpOpticalTipsBullet3 =>
      'Missed frames are fine. The stream keeps repeating with extra mixed frames, so missing parts are rebuilt.';

  @override
  String get helpAudioIntro =>
      'Sounds and vibration mark the moments that matter: each full mala and each goal. Set them in Settings → Sound & Haptics.';

  @override
  String get helpAudioVibrationSection => 'Vibration';

  @override
  String get helpAudioVibrationBold1 => 'When it vibrates:';

  @override
  String get helpAudioVibrationBullet1 =>
      'One pulse on each full mala, three pulses when a goal is reached, and a short tap when you undo.';

  @override
  String get helpAudioVibrationBold2 => 'Turn off:';

  @override
  String get helpAudioVibrationBullet2 =>
      'Switch off Vibration in Settings → Sound & Haptics for fully silent practice.';

  @override
  String get helpBackupIntro =>
      'Your data belongs to you. Save it to a file at any time, and restore it on this phone or a new one.';

  @override
  String get helpBackupExportSection => 'Exporting a backup';

  @override
  String get helpBackupExportBold1 => 'One file:';

  @override
  String get helpBackupExportBullet1 =>
      'All counters, goals and session history go into one backup file.';

  @override
  String get helpBackupExportBold2 => 'Encrypt (optional):';

  @override
  String get helpBackupExportBullet2 =>
      'You can protect the file with a passphrase. It is locked with strong AES-256-GCM encryption.';

  @override
  String get helpBackupExportBold3 => 'Keep your passphrase safe:';

  @override
  String get helpBackupExportBullet3 =>
      'A lost passphrase cannot be recovered, and the file cannot be opened without it.';

  @override
  String get helpBackupImportSection => 'Restoring a backup';

  @override
  String get helpBackupImportBold1 => 'Pick the file:';

  @override
  String get helpBackupImportBullet1 =>
      'Choose Import and select your backup file in the system file picker.';

  @override
  String get helpBackupImportBold2 => 'Replaces all data:';

  @override
  String get helpBackupImportBullet2 =>
      'Import replaces ALL current counters and history with the data in the file. Export first if you want to keep what is on the phone.';

  @override
  String get helpBackupImportBold3 => 'Encrypted files:';

  @override
  String get helpBackupImportBullet3 =>
      'If the file is encrypted, you are asked for the passphrase.';

  @override
  String get helpPrivacyIntro =>
      'SreerajP MantraJapa Counter is private by design. Your practice stays on your phone.';

  @override
  String get helpPrivacyOfflineSection => 'Fully offline';

  @override
  String get helpPrivacyOfflineBold1 => 'No internet permission:';

  @override
  String get helpPrivacyOfflineBullet1 =>
      'The app does not have the Android internet permission, so it cannot send anything anywhere.';

  @override
  String get helpPrivacyOfflineBold2 => 'No tracking:';

  @override
  String get helpPrivacyOfflineBullet2 =>
      'No analytics, no crash reporters and no ads.';

  @override
  String get helpPrivacyOfflineBold3 => 'No account:';

  @override
  String get helpPrivacyOfflineBullet3 =>
      'You never need to sign up or give an email or phone number.';

  @override
  String get helpPrivacyStorageSection => 'Where your data is kept';

  @override
  String get helpPrivacyStorageBold1 => 'On your phone only:';

  @override
  String get helpPrivacyStorageBullet1 =>
      'Counters and history are kept in the app\'s private storage on your phone. Other apps cannot read it.';

  @override
  String get helpPrivacyStorageBold2 => 'No cloud backup:';

  @override
  String get helpPrivacyStorageBullet2 =>
      'Android\'s automatic cloud backup is turned off for this app. Use Export or Optical Sync to keep a copy.';

  @override
  String get helpFaqIntro => 'Quick answers to common questions.';

  @override
  String get helpFaqQ1Title => 'Why did my tap not count?';

  @override
  String get helpFaqQ1Answer =>
      'Only taps inside the mala circle count. If Meru pause is on, taps during the short pause after each mala are not counted either.';

  @override
  String get helpFaqQ2Title => 'How do I undo a wrong count?';

  @override
  String get helpFaqQ2Answer =>
      'Put two fingers on the mala circle and slide them left or right. Each swipe removes one step.';

  @override
  String get helpFaqQ3Title => 'Why does my counter not open?';

  @override
  String get helpFaqQ3Answer =>
      'It is either locked or disabled. Tap the lock icon on the card to unlock it. Disabled counters cannot be opened for counting.';

  @override
  String get helpFaqQ4Title =>
      'What happens if I stop in the middle of a mala?';

  @override
  String get helpFaqQ4Answer =>
      'Nothing is lost. The counts are saved, and the mala waits for you next time, even on another day. Tap Start new if you want to begin again at 0.';

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
  String opticalFrameCounter(int current) {
    return 'Frame $current';
  }

  @override
  String opticalFramesReceived(int count) {
    return 'Frames received: $count';
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
      'A step-by-step walk through every feature, from your first counter to backup and privacy.';

  @override
  String get tutorialStep1Title => 'Welcome';

  @override
  String get tutorialStep1Desc =>
      'This app helps you count your mantra japa. It counts malas of 108, keeps daily and lifetime goals, and saves a full history. It works fully offline.';

  @override
  String get tutorialStep2Title => 'Choose your language';

  @override
  String get tutorialStep2Desc =>
      'Go to Settings → Language. Pick English, Malayalam, Sanskrit, or System default.';

  @override
  String get tutorialStep3Title => 'Create a counter';

  @override
  String get tutorialStep3Desc =>
      'Tap the + button at the top of the home screen. Enter the mantra name. Then set the initial count, increment step, lifetime goal, daily goal and start date.';

  @override
  String get tutorialStep4Title => 'Read the counter card';

  @override
  String get tutorialStep4Desc =>
      'Each card shows total chants and malas, today\'s chants, a strip of 27 beads for today\'s progress, and a bar for your lifetime goal.';

  @override
  String get tutorialStep5Title => 'Today summary';

  @override
  String get tutorialStep5Desc =>
      'The pill at the top of the home screen adds up today\'s chants, malas and the counters you used today.';

  @override
  String get tutorialStep6Title => 'Counter options';

  @override
  String get tutorialStep6Desc =>
      'Long-press a card to see Counter info, History, Edit, Lock, Disable (success), Disable (not completed) and Delete.';

  @override
  String get tutorialStep7Title => 'Lock a counter';

  @override
  String get tutorialStep7Desc =>
      'Tap the lock icon on a card to lock it. A locked counter cannot be opened for counting. Tap the icon again to unlock.';

  @override
  String get opticalCameraDenied =>
      'Camera access was denied. To receive data, allow the camera permission for this app in Android Settings.';

  @override
  String get opticalCameraError =>
      'The camera could not be started. Close other apps that use the camera and try again.';

  @override
  String get opticalCameraUnavailable =>
      'The QR scanner is not available on this device.';

  @override
  String get opticalTorchOn => 'Turn on light';

  @override
  String get opticalTorchOff => 'Turn off light';

  @override
  String get opticalZoom => 'Zoom';

  @override
  String get opticalScanTip =>
      'Tap the code to focus. Use zoom if it looks blurred.';

  @override
  String get meruPauseTitle => 'Pause · Breathe';

  @override
  String get meruPauseMessage =>
      'You have reached the Meru bead. Rest in stillness.';

  @override
  String get pacingHintMessage => 'Slow down, breathe, feel the mantra.';

  @override
  String get sectionMindfulCounting => 'Mindful counting';

  @override
  String get sectionMindfulCountingSub => 'Gentle support for unhurried japa';

  @override
  String get meruPauseSettingTitle => 'Meru pause after each mala';

  @override
  String get meruPauseSettingSub =>
      'A short, quiet pause after 108. Taps during the pause are not counted.';

  @override
  String secondsShort(int seconds) {
    return '$seconds s';
  }

  @override
  String get pacingHintSettingTitle => 'Gentle pacing hint';

  @override
  String get pacingHintSettingSub =>
      'A soft glow when tapping very fast. Every tap still counts.';

  @override
  String get helpCountingMindfulSection => 'Mindful counting';

  @override
  String get sadhanaFlowTitle => 'SADHANA FLOW';

  @override
  String sadhanaFlowA11y(int weeks) {
    return 'Calendar of practice days for the last $weeks weeks';
  }

  @override
  String sadhanaFlowYearDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days of sacred remembrance this year.',
      one: '1 day of sacred remembrance this year.',
      zero: 'Every mantra you offer this year will glow here.',
    );
    return '$_temp0';
  }

  @override
  String get sadhanaFlowWelcomeBack =>
      'Welcome back to your sacred space. Every mantra offered is eternal.';

  @override
  String get sadhanaFlowLess => 'Less';

  @override
  String get sadhanaFlowMore => 'More';

  @override
  String get opticalBrightness => 'Brightness';

  @override
  String get opticalBrightnessNormal => 'Normal';

  @override
  String opticalBrightnessBoost(int percent) {
    return '+$percent%';
  }

  @override
  String get helpCategoryCounters => 'Your Counters & History';

  @override
  String get helpTopicCountersTitle => 'Counters & Home Screen';

  @override
  String get helpTopicCountersSub =>
      'Create, edit, lock, disable and delete counters, and read the cards';

  @override
  String get helpTopicHistoryTitle => 'History & Statistics';

  @override
  String get helpTopicHistorySub =>
      'Day-by-day history, the Sadhana Flow calendar and counter details';

  @override
  String get helpTopicDisplayTitle => 'Display, Stillness & Language';

  @override
  String get helpTopicDisplaySub =>
      'Brightness, dimmed mode, Do Not Disturb, Meru pause, language and appearance';

  @override
  String get tutorialChapter1 => 'Getting started';

  @override
  String get tutorialChapter2 => 'Your counters';

  @override
  String get tutorialChapter3 => 'Counting';

  @override
  String get tutorialChapter4 => 'Malas and goals';

  @override
  String get tutorialChapter5 => 'History and statistics';

  @override
  String get tutorialChapter6 => 'Sound, vibration and display';

  @override
  String get tutorialChapter7 => 'Your data';

  @override
  String get tutorialChapter8 => 'Privacy';

  @override
  String get tutorialStep1Tip =>
      'Open this guide any time from Settings → Help & User Guides.';

  @override
  String get tutorialStep2Tip =>
      'Mantra names can be typed in any script, whatever app language you choose.';

  @override
  String get tutorialStep3Tip =>
      'Use 0 for no goal. The daily goal cannot be more than the lifetime goal, and the step must be less than the daily goal.';

  @override
  String get tutorialStep4Tip =>
      'A green tick means today\'s goal is done. A gold trophy means the lifetime goal is reached.';

  @override
  String get tutorialStep5Tip =>
      'These totals start again from 0 each day at midnight, by your phone\'s clock.';

  @override
  String get tutorialStep6Tip =>
      'Delete removes the counter and all its history. It cannot be undone.';

  @override
  String get tutorialStep7Tip =>
      'Lock a finished or rarely used counter, so its count is never changed by mistake.';

  @override
  String get tutorialStep8Title => 'Open the counting screen';

  @override
  String get tutorialStep8Desc =>
      'Tap a counter card. The counting screen opens with a large mala circle.';

  @override
  String get tutorialStep8Tip =>
      'If Do Not Disturb is turned on in settings, the phone stays quiet while this screen is open.';

  @override
  String get tutorialStep9Title => 'Tap to count';

  @override
  String get tutorialStep9Desc =>
      'Tap inside the mala circle. Each tap adds the increment step (1 by default). Taps outside the circle are ignored.';

  @override
  String get tutorialStep9Tip =>
      'You can chant with your eyes closed. The circle is large, and a sound and vibration mark each full mala.';

  @override
  String get tutorialStep10Title => 'Undo a count';

  @override
  String get tutorialStep10Desc =>
      'Put two fingers on the circle and slide them left or right. One swipe removes one step.';

  @override
  String get tutorialStep10Tip =>
      'The phone vibrates once to confirm the undo.';

  @override
  String get tutorialStep11Title => 'Read the screen';

  @override
  String get tutorialStep11Desc =>
      'The top pill shows the time of this sitting. The centre shows your bead in the current mala, the beads left, and the malas done. The bottom row shows Session, Daily and Lifetime counts.';

  @override
  String get tutorialStep11Tip =>
      'The lamp icon at the top changes colour when a goal is reached.';

  @override
  String get tutorialStep12Title => 'Leave and come back';

  @override
  String get tutorialStep12Desc =>
      'Press back at any time. Your counts are saved quietly. The timer pauses while the app is in the background. An unfinished mala waits for you, even on another day.';

  @override
  String get tutorialStep12Tip =>
      'Tap Start new on the banner to keep the old counts and begin a new mala at 0.';

  @override
  String get tutorialStep13Title => 'The counting menu';

  @override
  String get tutorialStep13Desc =>
      'The ⋮ menu has History, About, Settings, Finish & start new, Reset session and Reset counter.';

  @override
  String get tutorialStep13Tip =>
      'Reset session clears only this sitting. Reset counter deletes all history of the counter.';

  @override
  String get tutorialStep14Title => '108 beads = 1 mala';

  @override
  String get tutorialStep14Desc =>
      'Every 108 counts make one mala. The circle fills bead by bead and starts again after 108.';

  @override
  String get tutorialStep14Tip =>
      '115 counts = 1 mala and 7 counts. Extra counts are never lost.';

  @override
  String get tutorialStep15Title => 'Reach your goals';

  @override
  String get tutorialStep15Desc =>
      'When you reach the daily goal, a tone plays, the phone vibrates and a notification appears. The lifetime goal has its own tone, notification and a gold trophy.';

  @override
  String get tutorialStep15Tip =>
      'Turn these on or off in Settings → Sound & Haptics.';

  @override
  String get tutorialStep16Title => 'Meru pause';

  @override
  String get tutorialStep16Desc =>
      'Turn it on in Settings → Display & Stillness. After each mala the app pauses for 3, 5 or 10 seconds, so you can rest and breathe.';

  @override
  String get tutorialStep16Tip =>
      'Taps during the pause are not counted, just as the Meru bead is never crossed.';

  @override
  String get tutorialStep17Title => 'Gentle pacing hint';

  @override
  String get tutorialStep17Desc =>
      'If you tap faster than about 3 times a second, the circle glows amber and a short reminder appears.';

  @override
  String get tutorialStep17Tip =>
      'Every tap still counts. You can turn the hint off in Settings → Display & Stillness.';

  @override
  String get tutorialStep18Title => 'History';

  @override
  String get tutorialStep18Desc =>
      'Open History from the counting menu or the long-press menu. Sittings are grouped by day, with time, length, count and malas.';

  @override
  String get tutorialStep18Tip =>
      'Tap the delete icon on a sitting to remove it. Totals update at once.';

  @override
  String get tutorialStep19Title => 'Sadhana Flow';

  @override
  String get tutorialStep19Desc =>
      'The calendar in History shows the last 16 weeks. Days with practice glow like a lamp. A brighter glow means more chanting.';

  @override
  String get tutorialStep19Tip =>
      'There are no streaks and no missed-day marks. Every day you return is welcome.';

  @override
  String get tutorialStep20Title => 'Counter statistics';

  @override
  String get tutorialStep20Desc =>
      'Choose Counter info (long-press menu) or About (counting menu) to see progress rings and all details of the counter.';

  @override
  String get tutorialStep20Tip =>
      'The average chants per day is worked out from the start date you set.';

  @override
  String get tutorialStep21Title => 'Sounds';

  @override
  String get tutorialStep21Desc =>
      'In Settings → Sound & Haptics choose the mala sound, the daily goal tone and the lifetime goal tone. Pick a built-in sound, a phone ringtone, or your own audio file.';

  @override
  String get tutorialStep21Tip =>
      'Tap Preview to hear the tone before you chant.';

  @override
  String get tutorialStep22Title => 'Vibration and notifications';

  @override
  String get tutorialStep22Desc =>
      'Vibration marks each mala, each goal and each undo. Goal notifications appear in the status bar.';

  @override
  String get tutorialStep22Tip =>
      'Sounds play through the alarm channel, so you hear them even when the phone is on silent.';

  @override
  String get tutorialStep23Title => 'Display and stillness';

  @override
  String get tutorialStep23Desc =>
      'In Settings → Display & Stillness set the brightness, turn on Dimmed chanting mode, or silence calls and alerts with Do Not Disturb.';

  @override
  String get tutorialStep23Tip =>
      'Do Not Disturb needs a one-time permission. It is turned off again when you leave the counting screen.';

  @override
  String get tutorialStep24Title => 'Appearance';

  @override
  String get tutorialStep24Desc =>
      'Settings → Appearance shows the temple colours and fonts used in the app.';

  @override
  String get tutorialStep24Tip =>
      'The app always stays upright (portrait), so you can count with one hand.';

  @override
  String get tutorialStep25Title => 'Back up to a file';

  @override
  String get tutorialStep25Desc =>
      'Use Settings → Data Backup & Optical Sync → Export, or Import / Export in the home menu. All counters and history are saved to one file, and the share sheet opens.';

  @override
  String get tutorialStep25Tip =>
      'You can lock the file with a passphrase (AES-256-GCM). A lost passphrase cannot be recovered.';

  @override
  String get tutorialStep26Title => 'Restore from a file';

  @override
  String get tutorialStep26Desc =>
      'Choose Import and pick your backup file. Enter the passphrase if the file is encrypted.';

  @override
  String get tutorialStep26Tip =>
      'Import replaces ALL current data on this phone. Export first if you want to keep it.';

  @override
  String get tutorialStep27Title => 'Phone-to-phone sync';

  @override
  String get tutorialStep27Desc =>
      'On the old phone choose Optical Sync (Send) and pick the counters. On the new phone choose Optical Sync (Receive) and point the camera at the moving QR code.';

  @override
  String get tutorialStep27Tip =>
      'No internet, Bluetooth or cable is used. Chosen counters are added; other counters on the receiving phone are kept.';

  @override
  String get tutorialStep28Title => 'Clear all data';

  @override
  String get tutorialStep28Desc =>
      'Settings → Data Backup & Optical Sync → Clear all data deletes every counter and all history.';

  @override
  String get tutorialStep28Tip => 'Make a backup first. This cannot be undone.';

  @override
  String get tutorialStep29Title => 'Fully offline and private';

  @override
  String get tutorialStep29Desc =>
      'The app has no internet permission, no ads, no tracking and no account. Your practice stays on your phone.';

  @override
  String get tutorialStep29Tip =>
      'Android cloud backup is off for this app, so use Export or Optical Sync to keep a copy.';

  @override
  String get tutorialStep30Title => 'Permissions';

  @override
  String get tutorialStep30Desc =>
      'The camera is used only to scan sync codes. Notifications show goal messages. Vibration and audio give feedback. Do Not Disturb access is asked only if you turn it on.';

  @override
  String get tutorialStep30Tip =>
      'See every permission and why it is used in Settings → Permissions.';

  @override
  String get helpCountersIntro =>
      'The home screen lists all your counters. Each counter is one mantra or practice, with its own goals and history.';

  @override
  String get helpCountersCreateSection => 'Creating a counter';

  @override
  String get helpCountersCreateBold1 => 'Add button:';

  @override
  String get helpCountersCreateBullet1 =>
      'Tap the + button at the top of the home screen to make a new counter.';

  @override
  String get helpCountersCreateBold2 => 'Name:';

  @override
  String get helpCountersCreateBullet2 =>
      'Type the mantra name in any language or script.';

  @override
  String get helpCountersCreateBold3 => 'Initial count:';

  @override
  String get helpCountersCreateBullet3 =>
      'Bring in counts you made before, for example from a paper log. The default is 0.';

  @override
  String get helpCountersCreateBold4 => 'Increment step:';

  @override
  String get helpCountersCreateBullet4 =>
      'How much one tap adds. The default is 1. It must be less than the daily goal.';

  @override
  String get helpCountersCreateBold5 => 'Goals:';

  @override
  String get helpCountersCreateBullet5 =>
      'Set a daily goal and a lifetime goal. Use 0 for no goal. The daily goal cannot be more than the lifetime goal.';

  @override
  String get helpCountersCreateBold6 => 'Start date:';

  @override
  String get helpCountersCreateBullet6 =>
      'The day you started this practice. It is used to work out your average chants per day.';

  @override
  String get helpCountersHomeSection => 'The home screen';

  @override
  String get helpCountersHomeBold1 => 'Today summary:';

  @override
  String get helpCountersHomeBullet1 =>
      'The pill at the top shows today\'s total chants, total malas, and how many counters you used today.';

  @override
  String get helpCountersHomeBold2 => 'Card progress:';

  @override
  String get helpCountersHomeBullet2 =>
      'Each card shows total chants and malas, today\'s chants, a strip of 27 beads for today\'s goal, and a bar for the lifetime goal.';

  @override
  String get helpCountersHomeBold3 => 'Badges:';

  @override
  String get helpCountersHomeBullet3 =>
      'A green tick appears when today\'s goal is done. A gold trophy appears when the lifetime goal is reached.';

  @override
  String get helpCountersHomeBold4 => 'Order:';

  @override
  String get helpCountersHomeBullet4 =>
      'Active counters come first, then disabled ones. Newer counters are shown first.';

  @override
  String get helpCountersHomeBold5 => 'Colours:';

  @override
  String get helpCountersHomeBullet5 =>
      'Each counter gets its own accent colour, and it always stays the same.';

  @override
  String get helpCountersHomeBold6 => 'Top menu:';

  @override
  String get helpCountersHomeBullet6 =>
      'The menu at the top has Import / Export, Settings and About.';

  @override
  String get helpCountersOptionsSection =>
      'Counter options (long-press a card)';

  @override
  String get helpCountersOptionsBold1 => 'About counter:';

  @override
  String get helpCountersOptionsBullet1 =>
      'Statistics and details of the counter.';

  @override
  String get helpCountersOptionsBold2 => 'History:';

  @override
  String get helpCountersOptionsBullet2 => 'All sittings of this counter.';

  @override
  String get helpCountersOptionsBold3 => 'Edit:';

  @override
  String get helpCountersOptionsBullet3 =>
      'Change the name, step, goals or start date.';

  @override
  String get helpCountersOptionsBold4 => 'Lock / Unlock:';

  @override
  String get helpCountersOptionsBullet4 => 'Same as the lock icon on the card.';

  @override
  String get helpCountersOptionsBold5 => 'Disable (success):';

  @override
  String get helpCountersOptionsBullet5 =>
      'Mark the counter as completed, for example when a vow is finished. You can add a reason.';

  @override
  String get helpCountersOptionsBold6 => 'Disable (not completed):';

  @override
  String get helpCountersOptionsBullet6 =>
      'Stop a counter that was not finished. You can add a reason.';

  @override
  String get helpCountersOptionsBold7 => 'Delete:';

  @override
  String get helpCountersOptionsBullet7 =>
      'Removes the counter and all its history after you confirm. This cannot be undone.';

  @override
  String get helpCountersLockSection => 'Locked and disabled counters';

  @override
  String get helpCountersLockBold1 => 'Lock icon:';

  @override
  String get helpCountersLockBullet1 =>
      'Tap the lock icon on a card to lock or unlock it.';

  @override
  String get helpCountersLockBold2 => 'Locked:';

  @override
  String get helpCountersLockBullet2 =>
      'A locked counter cannot be opened for counting, so its count cannot change by mistake. Tapping it shows a short message.';

  @override
  String get helpCountersLockBold3 => 'Disabled:';

  @override
  String get helpCountersLockBullet3 =>
      'Disabled counters stay in the list with a tick or cross mark, but cannot be opened for counting.';

  @override
  String get helpCountingScreenSection => 'Reading the screen';

  @override
  String get helpCountingScreenBold1 => 'Timer:';

  @override
  String get helpCountingScreenBullet1 =>
      'The pill at the top shows how long this sitting has lasted. It shows PAUSED when the app is in the background.';

  @override
  String get helpCountingScreenBold2 => 'Centre:';

  @override
  String get helpCountingScreenBullet2 =>
      'The big number is your place in the current mala (0–107). Below it are the beads left and the malas done in this sitting.';

  @override
  String get helpCountingScreenBold3 => 'Bottom row:';

  @override
  String get helpCountingScreenBullet3 =>
      'Shows the Session, Daily and Lifetime counts with progress towards your goals.';

  @override
  String get helpCountingScreenBold4 => 'Lamp:';

  @override
  String get helpCountingScreenBullet4 =>
      'The lamp icon at the top changes colour when your daily or lifetime goal is reached.';

  @override
  String get helpCountingSaveSection => 'Leaving and saving';

  @override
  String get helpCountingSaveBold1 => 'Auto save:';

  @override
  String get helpCountingSaveBullet1 =>
      'Press back at any time. Your counts are saved quietly; the app does not ask you to save.';

  @override
  String get helpCountingSaveBold2 => 'Crash safe:';

  @override
  String get helpCountingSaveBullet2 =>
      'Your count is saved every 5 taps or 5 seconds, and fully stored every 20 taps or 30 seconds. If the phone switches off, the count comes back when you open the app.';

  @override
  String get helpCountingSaveBold3 => 'Timer pause:';

  @override
  String get helpCountingSaveBullet3 =>
      'The timer stops while the app is in the background, so idle time is not added to your sitting.';

  @override
  String get helpCountingSaveBold4 => 'Unfinished mala:';

  @override
  String get helpCountingSaveBullet4 =>
      'If you stop before 108, the mala waits for you next time, even on another day, and a banner shows it. Taps always count on the day you make them. Tap Start new to keep those counts and begin a new mala at 0.';

  @override
  String get helpCountingMenuSection => 'The counting menu (⋮)';

  @override
  String get helpCountingMenuBold1 => 'History:';

  @override
  String get helpCountingMenuBullet1 => 'Opens the history of this counter.';

  @override
  String get helpCountingMenuBold2 => 'About:';

  @override
  String get helpCountingMenuBullet2 =>
      'Shows the statistics and details of this counter.';

  @override
  String get helpCountingMenuBold3 => 'Settings:';

  @override
  String get helpCountingMenuBullet3 => 'Opens the app settings.';

  @override
  String get helpCountingMenuBold4 => 'Finish & start new:';

  @override
  String get helpCountingMenuBullet4 =>
      'Closes the current unfinished mala. Its counts are kept in history, and the next tap starts a new mala at 0.';

  @override
  String get helpCountingMenuBold5 => 'Reset session:';

  @override
  String get helpCountingMenuBullet5 =>
      'Throws away the current sitting and sets it back to 0. Past history is kept.';

  @override
  String get helpCountingMenuBold6 => 'Reset counter:';

  @override
  String get helpCountingMenuBullet6 =>
      'Deletes all history of this counter. This cannot be undone.';

  @override
  String get helpCountingMindfulBold1 => 'Meru pause:';

  @override
  String get helpCountingMindfulBullet1 =>
      'When turned on in Settings → Display & Stillness, the app pauses for 3, 5 or 10 seconds after each mala. Taps in the pause are not counted. The pause ends by itself, or with the undo swipe.';

  @override
  String get helpCountingMindfulBold2 => 'Pacing hint:';

  @override
  String get helpCountingMindfulBullet2 =>
      'If you tap faster than about 3 times a second, the circle glows softly and a short reminder appears. It never blocks a count.';

  @override
  String get helpMalaBeadsBold4 => 'Mala sound:';

  @override
  String get helpMalaBeadsBullet4 =>
      'If it is on, a soft sound plays on every 108th count. It is skipped when the same tap also reaches a goal, so sounds do not overlap.';

  @override
  String get helpMalaGoalsBold3 => 'Daily goal reached:';

  @override
  String get helpMalaGoalsBullet3 =>
      'If the daily notification is on, the goal tone plays, the phone vibrates and a notification appears. A green tick shows on the card.';

  @override
  String get helpMalaGoalsBold4 => 'Lifetime goal reached:';

  @override
  String get helpMalaGoalsBullet4 =>
      'If the lifetime notification is on, the lifetime tone and notification play. A gold trophy shows and the card turns a soft sandal colour.';

  @override
  String get helpMalaCardSection => 'Progress on the card';

  @override
  String get helpMalaCardBold1 => 'Bead strip:';

  @override
  String get helpMalaCardBullet1 =>
      'The row of 27 small beads shows today\'s progress towards the daily goal. Each bead is 1/27 of the goal, like 4 beads of a mala.';

  @override
  String get helpMalaCardBold2 => 'Lifetime bar:';

  @override
  String get helpMalaCardBullet2 =>
      'The long bar shows how much of your lifetime goal is done.';

  @override
  String get helpMalaCardBold3 => 'Numbers:';

  @override
  String get helpMalaCardBullet3 =>
      'The card shows total chants, total malas, and today\'s chants and malas.';

  @override
  String get helpHistoryIntro =>
      'History keeps a record of every sitting. Open it from the counting menu, from the long-press menu of a counter, or from the counter\'s details page.';

  @override
  String get helpHistoryLogSection => 'The history list';

  @override
  String get helpHistoryLogBold1 => 'Summary:';

  @override
  String get helpHistoryLogBullet1 =>
      'The top card shows total chants, days of practice, and how much of your vow is done.';

  @override
  String get helpHistoryLogBold2 => 'Grouped by day:';

  @override
  String get helpHistoryLogBullet2 =>
      'Sittings are grouped by date, newest first. Each day shows its total and the running total at the end of that day.';

  @override
  String get helpHistoryLogBold3 => 'Sitting rows:';

  @override
  String get helpHistoryLogBullet3 =>
      'Each sitting shows the start time, how long it lasted, the count and the malas.';

  @override
  String get helpHistoryDeleteSection => 'Deleting history';

  @override
  String get helpHistoryDeleteBold1 => 'One sitting:';

  @override
  String get helpHistoryDeleteBullet1 =>
      'Tap the delete icon on a sitting and confirm. Totals are worked out again at once.';

  @override
  String get helpHistoryDeleteBold2 => 'Clear history:';

  @override
  String get helpHistoryDeleteBullet2 =>
      'The clear button at the top deletes all sittings of this counter after you confirm. This cannot be undone.';

  @override
  String get helpHistoryFlowSection => 'Sadhana Flow calendar';

  @override
  String get helpHistoryFlowBold1 => '16 weeks:';

  @override
  String get helpHistoryFlowBullet1 =>
      'A calendar of the last 16 weeks, with Monday at the top. Days with practice glow like a lamp, from soft sandal to deep saffron.';

  @override
  String get helpHistoryFlowBold2 => 'Glow:';

  @override
  String get helpHistoryFlowBullet2 =>
      'For a counter with a daily goal, the glow shows progress towards that goal. Otherwise it is compared with your busiest day shown.';

  @override
  String get helpHistoryFlowBold3 => 'No pressure:';

  @override
  String get helpHistoryFlowBullet3 =>
      'There are no streaks and no missed-day marks. If you return after 3 or more days, a warm welcome line appears.';

  @override
  String get helpHistoryStatsSection => 'Counter statistics';

  @override
  String get helpHistoryStatsBold1 => 'Open:';

  @override
  String get helpHistoryStatsBullet1 =>
      'Long-press a counter and choose About counter, or use About in the counting menu.';

  @override
  String get helpHistoryStatsBold2 => 'Rings:';

  @override
  String get helpHistoryStatsBullet2 =>
      'Three rings show lifetime progress, today\'s progress and total malas.';

  @override
  String get helpHistoryStatsBold3 => 'Details:';

  @override
  String get helpHistoryStatsBullet3 =>
      'Name, status, step, initial count, goals, start date, created date, average chants per day, and the disabled date and reason, if any.';

  @override
  String get helpAudioMalaSection => 'Mala sound';

  @override
  String get helpAudioMalaBold1 => 'Enable mala sound:';

  @override
  String get helpAudioMalaBullet1 =>
      'Plays a soft sound and a vibration on every 108th count.';

  @override
  String get helpAudioMalaBold2 => 'Choices:';

  @override
  String get helpAudioMalaBullet2 =>
      'Temple Bronze Bell, Tibetan Singing Bowl, or Synthesized Tone (a short beep).';

  @override
  String get helpAudioMalaBold3 => 'No overlap:';

  @override
  String get helpAudioMalaBullet3 =>
      'If the 108th count also reaches a goal, only the goal tone plays.';

  @override
  String get helpAudioGoalSection => 'Daily goal';

  @override
  String get helpAudioGoalBold1 => 'Enable notification:';

  @override
  String get helpAudioGoalBullet1 =>
      'When the daily goal is reached, a tone plays, the phone vibrates, and a notification appears in the status bar.';

  @override
  String get helpAudioGoalBold2 => 'Goal tone:';

  @override
  String get helpAudioGoalBullet2 =>
      'Pick System default, a phone ringtone, a built-in sound (Temple Bell, Singing Bowl, Synthesized Tone, Sacred Shankha), or your own audio file (MP3, WAV, AAC).';

  @override
  String get helpAudioGoalBold3 => 'Preview:';

  @override
  String get helpAudioGoalBullet3 =>
      'Tap Preview tone to hear the chosen tone.';

  @override
  String get helpAudioLifetimeSection => 'Lifetime goal';

  @override
  String get helpAudioLifetimeBold1 => 'Lifetime goal tone:';

  @override
  String get helpAudioLifetimeBullet1 =>
      'A separate tone for the moment your lifetime goal is reached.';

  @override
  String get helpAudioLifetimeBold2 => 'Lifetime goal notification:';

  @override
  String get helpAudioLifetimeBullet2 =>
      'Turn it on to get the tone, vibration and a notification when the lifetime goal is reached.';

  @override
  String get helpAudioVolumeSection => 'Loud enough to hear';

  @override
  String get helpAudioVolumeBold1 => 'Alarm channel:';

  @override
  String get helpAudioVolumeBullet1 =>
      'Completion sounds play through the alarm sound channel, so you hear them even when the phone is on silent. The volume goes back to normal after a few seconds.';

  @override
  String get helpDisplayIntro =>
      'These settings help you chant in a calm, quiet way, and let you choose how the app looks and speaks.';

  @override
  String get helpDisplayBrightSection => 'Brightness and dimming';

  @override
  String get helpDisplayBrightBold1 => 'Brightness level:';

  @override
  String get helpDisplayBrightBullet1 =>
      'In Settings → Display & Stillness, choose a level from \'still\' (dim) to \'full\'. It changes the app screen only, not your phone\'s brightness.';

  @override
  String get helpDisplayBrightBold2 => 'Use system:';

  @override
  String get helpDisplayBrightBullet2 =>
      'Tap \'use system\' to go back to your phone\'s normal brightness.';

  @override
  String get helpDisplayBrightBold3 => 'Dimmed chanting mode:';

  @override
  String get helpDisplayBrightBullet3 =>
      'Darkens the background of the counting screen while the mala circle stays clear. Good for dark rooms, and it saves battery.';

  @override
  String get helpDisplayDndSection => 'Do Not Disturb';

  @override
  String get helpDisplayDndBold1 => 'Silence alerts:';

  @override
  String get helpDisplayDndBullet1 =>
      'When on, the phone goes into Do Not Disturb while the counting screen is open, and goes back to normal when you leave it.';

  @override
  String get helpDisplayDndBold2 => 'Permission:';

  @override
  String get helpDisplayDndBullet2 =>
      'The first time, the app asks you to allow Do Not Disturb access. Tap Open Settings and allow it for this app.';

  @override
  String get helpDisplayMindfulSection => 'Mindful counting';

  @override
  String get helpDisplayMindfulBold1 => 'Meru pause:';

  @override
  String get helpDisplayMindfulBullet1 =>
      'A short pause of 3, 5 or 10 seconds after each mala. Taps during the pause are not counted. Off by default.';

  @override
  String get helpDisplayMindfulBold2 => 'Gentle pacing hint:';

  @override
  String get helpDisplayMindfulBullet2 =>
      'A soft glow when you tap very fast. Every tap still counts. On by default.';

  @override
  String get helpDisplayLangSection => 'Language';

  @override
  String get helpDisplayLangBold1 => 'Choose language:';

  @override
  String get helpDisplayLangBullet1 =>
      'In Settings → Language pick English, Malayalam, Sanskrit, or System default.';

  @override
  String get helpDisplayLangBold2 => 'Any script:';

  @override
  String get helpDisplayLangBullet2 =>
      'Counter names can be written in any script, whatever app language you choose.';

  @override
  String get helpDisplayLookSection => 'Appearance';

  @override
  String get helpDisplayLookBold1 => 'Temple theme:';

  @override
  String get helpDisplayLookBullet1 =>
      'Settings → Appearance shows the colours (cream, vermillion, sandal, tulsi, rose) and the fonts used in the app.';

  @override
  String get helpDisplayLookBold2 => 'Portrait only:';

  @override
  String get helpDisplayLookBullet2 =>
      'The app always stays upright, so you can count with one hand.';

  @override
  String get helpOpticalHowBold4 => 'Merge:';

  @override
  String get helpOpticalHowBullet4 =>
      'Chosen counters are added to the receiving phone. A counter that already exists there is replaced by the received copy. Other counters on that phone are not touched.';

  @override
  String get helpOpticalSendSection => 'Sender controls';

  @override
  String get helpOpticalSendBold1 => 'Speed:';

  @override
  String get helpOpticalSendBullet1 =>
      'Choose 8, 12 or 15 frames per second. 8 is the default and works best on most phones.';

  @override
  String get helpOpticalSendBold2 => 'Pause and play:';

  @override
  String get helpOpticalSendBullet2 =>
      'Pause the stream and play it again at any time.';

  @override
  String get helpOpticalSendBold3 => 'Brightness:';

  @override
  String get helpOpticalSendBullet3 =>
      'A slider can make the screen brighter if the other camera has trouble. It goes back to normal when sending stops. The screen stays on while sending.';

  @override
  String get helpOpticalReceiveSection => 'Receiver controls';

  @override
  String get helpOpticalReceiveBold1 => 'Tap to focus:';

  @override
  String get helpOpticalReceiveBullet1 =>
      'Tap the camera view to focus on the code.';

  @override
  String get helpOpticalReceiveBold2 => 'Zoom:';

  @override
  String get helpOpticalReceiveBullet2 =>
      'Use the zoom slider (up to 4×) if the code looks small.';

  @override
  String get helpOpticalReceiveBold3 => 'Light:';

  @override
  String get helpOpticalReceiveBullet3 => 'Turn on the torch in a dark room.';

  @override
  String get helpOpticalReceiveBold4 => 'Frames received:';

  @override
  String get helpOpticalReceiveBullet4 =>
      'This line shows that scanning is working, even before all parts are complete.';

  @override
  String get helpBackupWhereSection => 'Where to find it';

  @override
  String get helpBackupWhereBold1 => 'Settings:';

  @override
  String get helpBackupWhereBullet1 =>
      'Settings → Data Backup & Optical Sync has Export, Import, Optical Sync and Clear all data.';

  @override
  String get helpBackupWhereBold2 => 'Home menu:';

  @override
  String get helpBackupWhereBullet2 =>
      'The menu on the home screen also has Import / Export.';

  @override
  String get helpBackupExportBold4 => 'Share sheet:';

  @override
  String get helpBackupExportBullet4 =>
      'After export, the Android share sheet opens. Save the file to your files or a memory card, or send it with an app you trust.';

  @override
  String get helpBackupImportBold4 => 'Safe restore:';

  @override
  String get helpBackupImportBullet4 =>
      'The file is checked first. If it is damaged or the passphrase is wrong, nothing is changed and an error is shown.';

  @override
  String get helpBackupImportBold5 => 'Older backups:';

  @override
  String get helpBackupImportBullet5 =>
      'Backup files from the older Android version of this app can also be imported.';

  @override
  String get helpBackupClearSection => 'Clear all data';

  @override
  String get helpBackupClearBold1 => 'Erase everything:';

  @override
  String get helpBackupClearBullet1 =>
      'Clear all data deletes all counters and all history after you confirm. This cannot be undone, so make a backup first.';

  @override
  String get helpPrivacyStorageBold3 => 'Crash-safe saving:';

  @override
  String get helpPrivacyStorageBullet3 =>
      'Frequent save points keep your count safe if the app closes suddenly.';

  @override
  String get helpPrivacyPermsSection => 'Permissions the app uses';

  @override
  String get helpPrivacyPermsBold1 => 'Camera:';

  @override
  String get helpPrivacyPermsBullet1 =>
      'Only to scan the QR code when receiving Optical Sync. No photos or videos are taken.';

  @override
  String get helpPrivacyPermsBold2 => 'Notifications:';

  @override
  String get helpPrivacyPermsBullet2 =>
      'To show goal messages in the status bar. Asked on Android 13 and later.';

  @override
  String get helpPrivacyPermsBold3 => 'Vibration and audio:';

  @override
  String get helpPrivacyPermsBullet3 =>
      'For the mala, goal and undo feedback, and to play completion sounds clearly.';

  @override
  String get helpPrivacyPermsBold4 => 'Do Not Disturb access:';

  @override
  String get helpPrivacyPermsBullet4 =>
      'Asked only if you turn on Do Not Disturb in Display & Stillness.';

  @override
  String get helpPrivacyPermsBold5 => 'Your files:';

  @override
  String get helpPrivacyPermsBullet5 =>
      'The app does not read your files. Import and export use the Android file picker, where you choose the file.';

  @override
  String get helpPrivacyPermsBold6 => 'Full list:';

  @override
  String get helpPrivacyPermsBullet6 =>
      'Settings → Permissions lists every permission and why it is used.';

  @override
  String get helpFaqQ5Title => 'Which day do my counts go to?';

  @override
  String get helpFaqQ5Answer =>
      'Each tap counts on the day you make it, by your phone\'s clock. The daily goal starts again at midnight.';

  @override
  String get helpFaqQ6Title =>
      'What is the difference between Reset session and Reset counter?';

  @override
  String get helpFaqQ6Answer =>
      'Reset session throws away only the current sitting. Reset counter deletes all history of that counter and cannot be undone.';

  @override
  String get helpFaqQ7Title => 'Why did the mala sound not play?';

  @override
  String get helpFaqQ7Answer =>
      'Check that Enable mala sound is on. If the same tap also reached a goal, only the goal tone plays.';

  @override
  String get helpFaqQ8Title => 'Why do sounds play when my phone is on silent?';

  @override
  String get helpFaqQ8Answer =>
      'Completion sounds use the alarm channel so you do not miss them. Turn off the sounds in Settings → Sound & Haptics if you want silence.';

  @override
  String get helpFaqQ9Title => 'I forgot my backup passphrase. What can I do?';

  @override
  String get helpFaqQ9Answer =>
      'The passphrase cannot be recovered, and that file cannot be opened. Make a new backup from a phone that still has your data.';

  @override
  String get helpFaqQ10Title => 'Will import remove my current counters?';

  @override
  String get helpFaqQ10Answer =>
      'Importing a backup file replaces all current data. Optical Sync is different: it only adds or updates the counters you choose.';

  @override
  String get helpFaqQ11Title => 'Optical Sync scanning is slow. What helps?';

  @override
  String get helpFaqQ11Answer =>
      'Hold the phone steady 15–25 cm away, tap to focus, avoid glare, and raise the sender\'s brightness. Try a lower speed such as 8 frames per second.';

  @override
  String get helpFaqQ12Title => 'Can I move my data to a new phone?';

  @override
  String get helpFaqQ12Answer =>
      'Yes. Use Optical Sync with both phones side by side, or export a backup file and import it on the new phone.';

  @override
  String get helpFaqQ13Title => 'Why is the app fully offline?';

  @override
  String get helpFaqQ13Answer =>
      'Japa is personal and sacred. Staying offline keeps your practice private, saves battery, and removes distractions.';

  @override
  String get helpFaqQ14Title => 'Is my data shared with anyone?';

  @override
  String get helpFaqQ14Answer =>
      'No. Your data never leaves your phone unless you export it or send it with Optical Sync yourself.';
}
