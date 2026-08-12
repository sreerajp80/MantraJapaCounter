// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mantra Japa Counter';

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
  String get backupShareSubject => 'Mantra Japa Counter Backup';
}
