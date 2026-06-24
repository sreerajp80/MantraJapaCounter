import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mantra Japa Counter'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get resetAll;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @mantraCounters.
  ///
  /// In en, this message translates to:
  /// **'Mantra Counters'**
  String get mantraCounters;

  /// No description provided for @menuImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import / Export'**
  String get menuImportExport;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @todayChants.
  ///
  /// In en, this message translates to:
  /// **'chants'**
  String get todayChants;

  /// No description provided for @todayMalas.
  ///
  /// In en, this message translates to:
  /// **'malas'**
  String get todayMalas;

  /// No description provided for @todayActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get todayActive;

  /// No description provided for @noCountersYet.
  ///
  /// In en, this message translates to:
  /// **'No counters yet'**
  String get noCountersYet;

  /// No description provided for @noCountersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + above to begin your first offering'**
  String get noCountersSubtitle;

  /// No description provided for @aboutCounter.
  ///
  /// In en, this message translates to:
  /// **'About counter'**
  String get aboutCounter;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @disableSuccess.
  ///
  /// In en, this message translates to:
  /// **'Disable (success)'**
  String get disableSuccess;

  /// No description provided for @disableFailure.
  ///
  /// In en, this message translates to:
  /// **'Disable (not completed)'**
  String get disableFailure;

  /// No description provided for @deleteCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete counter?'**
  String get deleteCounterTitle;

  /// No description provided for @deleteCounterMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\" and all its history? This cannot be undone.'**
  String deleteCounterMessage(String name);

  /// No description provided for @disableAsCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable as completed?'**
  String get disableAsCompletedTitle;

  /// No description provided for @disableCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable counter?'**
  String get disableCounterTitle;

  /// No description provided for @reasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get reasonOptional;

  /// No description provided for @reasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Completed 1 lakh'**
  String get reasonHint;

  /// No description provided for @editCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Counter'**
  String get editCounterTitle;

  /// No description provided for @newCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'New Counter'**
  String get newCounterTitle;

  /// No description provided for @counterNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Counter name *'**
  String get counterNameLabel;

  /// No description provided for @initialCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial count (default 0)'**
  String get initialCountLabel;

  /// No description provided for @incrementStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Increment step (default 1)'**
  String get incrementStepLabel;

  /// No description provided for @lifetimeGoalFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal (0 = none)'**
  String get lifetimeGoalFieldLabel;

  /// No description provided for @dailyGoalFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily goal (0 = none)'**
  String get dailyGoalFieldLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date: '**
  String get startDateLabel;

  /// No description provided for @dailyExceedsLifetime.
  ///
  /// In en, this message translates to:
  /// **'Daily goal cannot exceed lifetime goal'**
  String get dailyExceedsLifetime;

  /// No description provided for @stepExceedsDaily.
  ///
  /// In en, this message translates to:
  /// **'Increment step must be less than daily goal'**
  String get stepExceedsDaily;

  /// No description provided for @importExportBody.
  ///
  /// In en, this message translates to:
  /// **'Export backs up all counters and sessions to a JSON file.\n\nImport replaces ALL current data with the selected file.'**
  String get importExportBody;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {message}'**
  String exportFailed(String message);

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {message}'**
  String importFailed(String message);

  /// No description provided for @importSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccessful;

  /// No description provided for @pausedWithTime.
  ///
  /// In en, this message translates to:
  /// **'PAUSED · {time}'**
  String pausedWithTime(String time);

  /// No description provided for @resetSession.
  ///
  /// In en, this message translates to:
  /// **'Reset session'**
  String get resetSession;

  /// No description provided for @resetCounter.
  ///
  /// In en, this message translates to:
  /// **'Reset counter'**
  String get resetCounter;

  /// No description provided for @ofOneHundredEight.
  ///
  /// In en, this message translates to:
  /// **'of one hundred eight'**
  String get ofOneHundredEight;

  /// No description provided for @lifetimeGoalCaps.
  ///
  /// In en, this message translates to:
  /// **'LIFETIME GOAL'**
  String get lifetimeGoalCaps;

  /// No description provided for @dailyGoalCaps.
  ///
  /// In en, this message translates to:
  /// **'DAILY GOAL'**
  String get dailyGoalCaps;

  /// No description provided for @beadsRemainCaps.
  ///
  /// In en, this message translates to:
  /// **'{count} BEADS REMAIN'**
  String beadsRemainCaps(int count);

  /// No description provided for @malaThisSession.
  ///
  /// In en, this message translates to:
  /// **'+{count} mala this session'**
  String malaThisSession(int count);

  /// No description provided for @footerLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get footerLifetime;

  /// No description provided for @footerDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get footerDaily;

  /// No description provided for @footerSession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get footerSession;

  /// No description provided for @resetSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset session?'**
  String get resetSessionTitle;

  /// No description provided for @resetSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Current session will be discarded and the counter reset to 0.'**
  String get resetSessionMessage;

  /// No description provided for @resetCounterTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset counter?'**
  String get resetCounterTitle;

  /// No description provided for @resetCounterMessage.
  ///
  /// In en, this message translates to:
  /// **'All history for this counter will be deleted. This cannot be undone.'**
  String get resetCounterMessage;

  /// No description provided for @noSessionsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded yet.'**
  String get noSessionsRecorded;

  /// No description provided for @recentOfferings.
  ///
  /// In en, this message translates to:
  /// **'RECENT OFFERINGS'**
  String get recentOfferings;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @sessionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String sessionCount(int count);

  /// No description provided for @labelChants.
  ///
  /// In en, this message translates to:
  /// **'chants'**
  String get labelChants;

  /// No description provided for @labelMala.
  ///
  /// In en, this message translates to:
  /// **'mala'**
  String get labelMala;

  /// No description provided for @clearAllHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all history?'**
  String get clearAllHistoryTitle;

  /// No description provided for @clearCounterHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear this counter\'s history?'**
  String get clearCounterHistoryTitle;

  /// No description provided for @clearHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Sessions will be permanently deleted.'**
  String get clearHistoryMessage;

  /// No description provided for @recordOfDevotion.
  ///
  /// In en, this message translates to:
  /// **'a record of devotion'**
  String get recordOfDevotion;

  /// No description provided for @allCounters.
  ///
  /// In en, this message translates to:
  /// **'All counters'**
  String get allCounters;

  /// No description provided for @chantsOfferedDays.
  ///
  /// In en, this message translates to:
  /// **'CHANTS OFFERED · {count, plural, =1{1 DAY} other{{count} DAYS}}'**
  String chantsOfferedDays(int count);

  /// No description provided for @chantsOfferedPercent.
  ///
  /// In en, this message translates to:
  /// **'CHANTS OFFERED · {percent}% OF VOW'**
  String chantsOfferedPercent(String percent);

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This session of 1 chant will be permanently removed.} other{This session of {count} chants will be permanently removed.}}'**
  String deleteSessionMessage(int count);

  /// No description provided for @deleteSessionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get deleteSessionTooltip;

  /// No description provided for @chantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} chants'**
  String chantsCount(String count);

  /// No description provided for @malaCount.
  ///
  /// In en, this message translates to:
  /// **'{count} mala'**
  String malaCount(int count);

  /// No description provided for @counterDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Counter Details'**
  String get counterDetailsTitle;

  /// No description provided for @counterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Counter not found'**
  String get counterNotFound;

  /// No description provided for @completedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Completed successfully'**
  String get completedSuccessfully;

  /// No description provided for @statusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// No description provided for @labelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// No description provided for @labelTodayCap.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get labelTodayCap;

  /// No description provided for @labelMalas.
  ///
  /// In en, this message translates to:
  /// **'Malas'**
  String get labelMalas;

  /// No description provided for @infoName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get infoName;

  /// No description provided for @infoStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get infoStatus;

  /// No description provided for @infoIncrementStep.
  ///
  /// In en, this message translates to:
  /// **'Increment step'**
  String get infoIncrementStep;

  /// No description provided for @infoInitialCount.
  ///
  /// In en, this message translates to:
  /// **'Initial count'**
  String get infoInitialCount;

  /// No description provided for @infoLifetimeGoal.
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal'**
  String get infoLifetimeGoal;

  /// No description provided for @infoDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get infoDailyGoal;

  /// No description provided for @infoStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get infoStarted;

  /// No description provided for @infoCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get infoCreated;

  /// No description provided for @infoAvgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg daily count'**
  String get infoAvgDaily;

  /// No description provided for @infoDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get infoDisabled;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @aboutPurposeTitle.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get aboutPurposeTitle;

  /// No description provided for @aboutPurposeBody.
  ///
  /// In en, this message translates to:
  /// **'Track your mantra recitation practice with mala (108-bead round) counting, daily and lifetime goals, and full session history.'**
  String get aboutPurposeBody;

  /// No description provided for @aboutOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Fully offline'**
  String get aboutOfflineTitle;

  /// No description provided for @aboutOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'No network access. All data stored only on your device.'**
  String get aboutOfflineBody;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'No analytics, no tracking, no data shared with anyone.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get aboutBackupTitle;

  /// No description provided for @aboutBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Use Import / Export to back up your data to a JSON file.'**
  String get aboutBackupBody;

  /// No description provided for @aboutMantraQuote.
  ///
  /// In en, this message translates to:
  /// **'Om Namah Shivaya'**
  String get aboutMantraQuote;

  /// No description provided for @aboutMadeWithPrefix.
  ///
  /// In en, this message translates to:
  /// **'Made with '**
  String get aboutMadeWithPrefix;

  /// No description provided for @aboutMadeWithSuffix.
  ///
  /// In en, this message translates to:
  /// **' from India'**
  String get aboutMadeWithSuffix;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @practiceEyebrow.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE'**
  String get practiceEyebrow;

  /// No description provided for @sectionDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get sectionDailyGoal;

  /// No description provided for @sectionDailyGoalSub.
  ///
  /// In en, this message translates to:
  /// **'When the offering is complete'**
  String get sectionDailyGoalSub;

  /// No description provided for @enableNotification.
  ///
  /// In en, this message translates to:
  /// **'Enable notification'**
  String get enableNotification;

  /// No description provided for @enableNotificationSub.
  ///
  /// In en, this message translates to:
  /// **'Vibrate and sound on completion'**
  String get enableNotificationSub;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrationSub.
  ///
  /// In en, this message translates to:
  /// **'A gentle hum on completion'**
  String get vibrationSub;

  /// No description provided for @notificationSound.
  ///
  /// In en, this message translates to:
  /// **'Notification sound'**
  String get notificationSound;

  /// No description provided for @previewTone.
  ///
  /// In en, this message translates to:
  /// **'Preview tone'**
  String get previewTone;

  /// No description provided for @previewToneSub.
  ///
  /// In en, this message translates to:
  /// **'Hear what plays on completion'**
  String get previewToneSub;

  /// No description provided for @sectionMala.
  ///
  /// In en, this message translates to:
  /// **'Mala completion'**
  String get sectionMala;

  /// No description provided for @sectionMalaSub.
  ///
  /// In en, this message translates to:
  /// **'The closing of every 108 beads'**
  String get sectionMalaSub;

  /// No description provided for @enableMalaSound.
  ///
  /// In en, this message translates to:
  /// **'Enable mala sound'**
  String get enableMalaSound;

  /// No description provided for @enableMalaSoundSub.
  ///
  /// In en, this message translates to:
  /// **'A soft tick on each full mala'**
  String get enableMalaSoundSub;

  /// No description provided for @sectionStillness.
  ///
  /// In en, this message translates to:
  /// **'Stillness'**
  String get sectionStillness;

  /// No description provided for @sectionStillnessSub.
  ///
  /// In en, this message translates to:
  /// **'For longer sessions'**
  String get sectionStillnessSub;

  /// No description provided for @brightnessLevel.
  ///
  /// In en, this message translates to:
  /// **'Brightness level'**
  String get brightnessLevel;

  /// No description provided for @followingSystem.
  ///
  /// In en, this message translates to:
  /// **'Following system'**
  String get followingSystem;

  /// No description provided for @overrideActive.
  ///
  /// In en, this message translates to:
  /// **'Override active'**
  String get overrideActive;

  /// No description provided for @brightnessStill.
  ///
  /// In en, this message translates to:
  /// **'still'**
  String get brightnessStill;

  /// No description provided for @brightnessUseSystem.
  ///
  /// In en, this message translates to:
  /// **'use system'**
  String get brightnessUseSystem;

  /// No description provided for @brightnessFull.
  ///
  /// In en, this message translates to:
  /// **'full'**
  String get brightnessFull;

  /// No description provided for @sectionPracticeGuide.
  ///
  /// In en, this message translates to:
  /// **'Practice guide'**
  String get sectionPracticeGuide;

  /// No description provided for @sectionPracticeGuideSub.
  ///
  /// In en, this message translates to:
  /// **'Gestures and rhythms of use'**
  String get sectionPracticeGuideSub;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @howItWorksSub.
  ///
  /// In en, this message translates to:
  /// **'Counting, undo, and the menu — explained'**
  String get howItWorksSub;

  /// No description provided for @settingsGuidanceBody.
  ///
  /// In en, this message translates to:
  /// **'The daily-goal sound plays when your goal is reached. The mala sound rings softly after every 108 chants — except when that count also completes the daily offering.'**
  String get settingsGuidanceBody;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllData;

  /// No description provided for @clearAllDataSub.
  ///
  /// In en, this message translates to:
  /// **'Delete all counters and session history permanently'**
  String get clearAllDataSub;

  /// No description provided for @soundSystemDefaultTapToChange.
  ///
  /// In en, this message translates to:
  /// **'System default — tap to change'**
  String get soundSystemDefaultTapToChange;

  /// No description provided for @soundNamedTapToChange.
  ///
  /// In en, this message translates to:
  /// **'{name} — tap to change'**
  String soundNamedTapToChange(String name);

  /// No description provided for @soundCustomTapToChange.
  ///
  /// In en, this message translates to:
  /// **'Custom audio — tap to change'**
  String get soundCustomTapToChange;

  /// No description provided for @soundSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get soundSystemDefault;

  /// No description provided for @browseAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Browse audio file…'**
  String get browseAudioFile;

  /// No description provided for @clearAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get clearAllDataTitle;

  /// No description provided for @clearAllDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all counters and all session history. This cannot be undone.'**
  String get clearAllDataMessage;

  /// No description provided for @clearAllButton.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllButton;

  /// No description provided for @allDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get allDataCleared;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @helpCountingTitle.
  ///
  /// In en, this message translates to:
  /// **'Counting'**
  String get helpCountingTitle;

  /// No description provided for @helpCountingBody.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the bead circle to count one chant. Each 108 chants completes one mala — the ring fills as the beads pass.'**
  String get helpCountingBody;

  /// No description provided for @helpUndoTitle.
  ///
  /// In en, this message translates to:
  /// **'Undoing a tap'**
  String get helpUndoTitle;

  /// No description provided for @helpUndoBody.
  ///
  /// In en, this message translates to:
  /// **'Place two fingers on the bead circle and swipe — left or right — to undo your last chant. The session ends gracefully if the count returns to zero.'**
  String get helpUndoBody;

  /// No description provided for @helpTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer & status'**
  String get helpTimerTitle;

  /// No description provided for @helpTimerBody.
  ///
  /// In en, this message translates to:
  /// **'The pill at the top shows the time spent in this session. The green marker below the count tells you how many beads remain in the current mala, or that the daily offering is complete.'**
  String get helpTimerBody;

  /// No description provided for @helpResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Resetting'**
  String get helpResetTitle;

  /// No description provided for @helpResetBody.
  ///
  /// In en, this message translates to:
  /// **'Open the menu (the three dots, top right of the counting screen) for Reset session and Reset counter. Reset session discards the current sitting; Reset counter clears all history for that mantra.'**
  String get helpResetBody;

  /// No description provided for @cardChantsMala.
  ///
  /// In en, this message translates to:
  /// **'chants · {malas} mala'**
  String cardChantsMala(int malas);

  /// No description provided for @cardComplete.
  ///
  /// In en, this message translates to:
  /// **'✓ complete'**
  String get cardComplete;

  /// No description provided for @cardPercentDaily.
  ///
  /// In en, this message translates to:
  /// **'{percent}% daily'**
  String cardPercentDaily(int percent);

  /// No description provided for @cardNoDaily.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get cardNoDaily;

  /// No description provided for @cardTodayPrefix.
  ///
  /// In en, this message translates to:
  /// **'TODAY · '**
  String get cardTodayPrefix;

  /// No description provided for @cardChants.
  ///
  /// In en, this message translates to:
  /// **'{count} chants'**
  String cardChants(String count);

  /// No description provided for @cardMala.
  ///
  /// In en, this message translates to:
  /// **'{count} mala'**
  String cardMala(int count);

  /// No description provided for @cardMalaProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} mala'**
  String cardMalaProgress(int current, int target);

  /// No description provided for @cardLifetimePercent.
  ///
  /// In en, this message translates to:
  /// **'lifetime · {percent}%'**
  String cardLifetimePercent(String percent);

  /// No description provided for @cardLifetimePercentComplete.
  ///
  /// In en, this message translates to:
  /// **'lifetime · {percent}% ✓'**
  String cardLifetimePercentComplete(String percent);

  /// No description provided for @notifDailyGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal Achieved'**
  String get notifDailyGoalTitle;

  /// No description provided for @notifDailyGoalBody.
  ///
  /// In en, this message translates to:
  /// **'You have reached your daily mantra count goal!'**
  String get notifDailyGoalBody;

  /// No description provided for @backupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Mantra Japa Counter Backup'**
  String get backupShareSubject;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
