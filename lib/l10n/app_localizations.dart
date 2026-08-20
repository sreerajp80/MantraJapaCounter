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

  /// Application title displayed across the app
  ///
  /// In en, this message translates to:
  /// **'SreerajP MantraJapa Counter'**
  String get appTitle;

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Generic save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Generic create button label
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Generic confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Generic clear button label
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Generic reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Generic reset all button label
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get resetAll;

  /// Export action button label
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Import action button label
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// Play action button label
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// More options button or tooltip label
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Label indicating a value is not set
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Error message with dynamic error details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// Title of the home screen showing the list of mantra counters
  ///
  /// In en, this message translates to:
  /// **'Mantra Counters'**
  String get mantraCounters;

  /// Menu option to navigate to Import / Export screen
  ///
  /// In en, this message translates to:
  /// **'Import / Export'**
  String get menuImportExport;

  /// Menu option to navigate to Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// Menu option to navigate to About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// Summary card label for chants counted today
  ///
  /// In en, this message translates to:
  /// **'chants'**
  String get todayChants;

  /// Summary card label for malas completed today
  ///
  /// In en, this message translates to:
  /// **'malas'**
  String get todayMalas;

  /// Summary card label for number of active counters today
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get todayActive;

  /// Empty state title when no counters exist
  ///
  /// In en, this message translates to:
  /// **'No counters yet'**
  String get noCountersYet;

  /// Empty state subtitle prompting the user to create a counter
  ///
  /// In en, this message translates to:
  /// **'Tap the + above to begin your first offering'**
  String get noCountersSubtitle;

  /// Menu item to open the counter details screen
  ///
  /// In en, this message translates to:
  /// **'About counter'**
  String get aboutCounter;

  /// Menu item to open the counter history screen
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Menu item or button to edit a counter
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Action label to disable counter as successfully completed
  ///
  /// In en, this message translates to:
  /// **'Disable (success)'**
  String get disableSuccess;

  /// Action label to disable counter before goal completion
  ///
  /// In en, this message translates to:
  /// **'Disable (not completed)'**
  String get disableFailure;

  /// Title for delete counter confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete counter?'**
  String get deleteCounterTitle;

  /// Message for delete counter confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\" and all its history? This cannot be undone.'**
  String deleteCounterMessage(String name);

  /// Dialog title for marking counter as completed
  ///
  /// In en, this message translates to:
  /// **'Disable as completed?'**
  String get disableAsCompletedTitle;

  /// Dialog title for disabling a counter
  ///
  /// In en, this message translates to:
  /// **'Disable counter?'**
  String get disableCounterTitle;

  /// Label for optional reason text field when disabling counter
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get reasonOptional;

  /// Hint text for optional reason input field
  ///
  /// In en, this message translates to:
  /// **'e.g. Completed 1 lakh'**
  String get reasonHint;

  /// Title of the screen or dialog for editing a counter
  ///
  /// In en, this message translates to:
  /// **'Edit Counter'**
  String get editCounterTitle;

  /// Title of the screen or dialog for creating a new counter
  ///
  /// In en, this message translates to:
  /// **'New Counter'**
  String get newCounterTitle;

  /// Form label for the counter name field
  ///
  /// In en, this message translates to:
  /// **'Counter name *'**
  String get counterNameLabel;

  /// Form label for initial count field
  ///
  /// In en, this message translates to:
  /// **'Initial count (default 0)'**
  String get initialCountLabel;

  /// Form label for increment step field
  ///
  /// In en, this message translates to:
  /// **'Increment step (default 1)'**
  String get incrementStepLabel;

  /// Form label for lifetime goal field
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal (0 = none)'**
  String get lifetimeGoalFieldLabel;

  /// Form label for daily goal field
  ///
  /// In en, this message translates to:
  /// **'Daily goal (0 = none)'**
  String get dailyGoalFieldLabel;

  /// Label prefix for the start date field
  ///
  /// In en, this message translates to:
  /// **'Start date: '**
  String get startDateLabel;

  /// Validation error when daily goal exceeds lifetime goal
  ///
  /// In en, this message translates to:
  /// **'Daily goal cannot exceed lifetime goal'**
  String get dailyExceedsLifetime;

  /// Validation error when step is greater than or equal to daily goal
  ///
  /// In en, this message translates to:
  /// **'Increment step must be less than daily goal'**
  String get stepExceedsDaily;

  /// Exploratory description on the import/export screen
  ///
  /// In en, this message translates to:
  /// **'Export backs up all counters and sessions to a JSON file.\n\nImport replaces ALL current data with the selected file.'**
  String get importExportBody;

  /// Error notification when export operation fails
  ///
  /// In en, this message translates to:
  /// **'Export failed: {message}'**
  String exportFailed(String message);

  /// Error notification when import operation fails
  ///
  /// In en, this message translates to:
  /// **'Import failed: {message}'**
  String importFailed(String message);

  /// Notification message when data import succeeds
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccessful;

  /// Status banner text showing elapsed time when counting session is paused
  ///
  /// In en, this message translates to:
  /// **'PAUSED · {time}'**
  String pausedWithTime(String time);

  /// Menu option to reset current sitting session
  ///
  /// In en, this message translates to:
  /// **'Reset session'**
  String get resetSession;

  /// Menu option to reset counter and clear its history
  ///
  /// In en, this message translates to:
  /// **'Reset counter'**
  String get resetCounter;

  /// Subtitle on the counting bead circle indicating 108 beads per mala
  ///
  /// In en, this message translates to:
  /// **'of one hundred eight'**
  String get ofOneHundredEight;

  /// Header title for lifetime goal progress bar
  ///
  /// In en, this message translates to:
  /// **'LIFETIME GOAL'**
  String get lifetimeGoalCaps;

  /// Header title for daily goal progress bar
  ///
  /// In en, this message translates to:
  /// **'DAILY GOAL'**
  String get dailyGoalCaps;

  /// Text showing beads remaining in current mala
  ///
  /// In en, this message translates to:
  /// **'{count} BEADS REMAIN'**
  String beadsRemainCaps(int count);

  /// Indicator of malas completed in current session
  ///
  /// In en, this message translates to:
  /// **'+{count} mala this session'**
  String malaThisSession(int count);

  /// Footer column header for lifetime count
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get footerLifetime;

  /// Footer column header for daily count
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get footerDaily;

  /// Footer column header for session count
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get footerSession;

  /// Title for reset session confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset session?'**
  String get resetSessionTitle;

  /// Confirmation message explaining effect of resetting a session
  ///
  /// In en, this message translates to:
  /// **'Current session will be discarded and the counter reset to 0.'**
  String get resetSessionMessage;

  /// Title for reset counter confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset counter?'**
  String get resetCounterTitle;

  /// Confirmation message explaining effect of resetting a counter
  ///
  /// In en, this message translates to:
  /// **'All history for this counter will be deleted. This cannot be undone.'**
  String get resetCounterMessage;

  /// Empty state text on history screen when no sessions exist
  ///
  /// In en, this message translates to:
  /// **'No sessions recorded yet.'**
  String get noSessionsRecorded;

  /// Section header for history session list
  ///
  /// In en, this message translates to:
  /// **'RECENT OFFERINGS'**
  String get recentOfferings;

  /// Date label for today's session entries
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Pluralized count of sessions
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String sessionCount(int count);

  /// Unit label for chants
  ///
  /// In en, this message translates to:
  /// **'chants'**
  String get labelChants;

  /// Unit label for singular mala
  ///
  /// In en, this message translates to:
  /// **'mala'**
  String get labelMala;

  /// Dialog title for clearing all history across counters
  ///
  /// In en, this message translates to:
  /// **'Clear all history?'**
  String get clearAllHistoryTitle;

  /// Dialog title for clearing history of a specific counter
  ///
  /// In en, this message translates to:
  /// **'Clear this counter\'s history?'**
  String get clearCounterHistoryTitle;

  /// Confirmation body text warning about permanent deletion of sessions
  ///
  /// In en, this message translates to:
  /// **'Sessions will be permanently deleted.'**
  String get clearHistoryMessage;

  /// Subtitle on the history screen
  ///
  /// In en, this message translates to:
  /// **'a record of devotion'**
  String get recordOfDevotion;

  /// Dropdown or filter option for selecting all counters
  ///
  /// In en, this message translates to:
  /// **'All counters'**
  String get allCounters;

  /// Header statistic showing total days chants were offered
  ///
  /// In en, this message translates to:
  /// **'CHANTS OFFERED · {count, plural, =1{1 DAY} other{{count} DAYS}}'**
  String chantsOfferedDays(int count);

  /// Header statistic showing percentage progress of lifetime vow
  ///
  /// In en, this message translates to:
  /// **'CHANTS OFFERED · {percent}% OF VOW'**
  String chantsOfferedPercent(String percent);

  /// Title for delete individual session dialog
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get deleteSessionTitle;

  /// Confirmation message for deleting a single session
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This session of 1 chant will be permanently removed.} other{This session of {count} chants will be permanently removed.}}'**
  String deleteSessionMessage(int count);

  /// Tooltip for session delete button
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get deleteSessionTooltip;

  /// Formatted number of chants with unit label
  ///
  /// In en, this message translates to:
  /// **'{count} chants'**
  String chantsCount(String count);

  /// Formatted number of malas with unit label
  ///
  /// In en, this message translates to:
  /// **'{count} mala'**
  String malaCount(int count);

  /// Screen title for Counter Details
  ///
  /// In en, this message translates to:
  /// **'Counter Details'**
  String get counterDetailsTitle;

  /// Error message when requested counter is not found
  ///
  /// In en, this message translates to:
  /// **'Counter not found'**
  String get counterNotFound;

  /// Status text for counter that reached its lifetime goal
  ///
  /// In en, this message translates to:
  /// **'Completed successfully'**
  String get completedSuccessfully;

  /// Status text for disabled counter
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// Total count metric label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// Today count metric label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get labelTodayCap;

  /// Malas metric label
  ///
  /// In en, this message translates to:
  /// **'Malas'**
  String get labelMalas;

  /// Details row label for name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get infoName;

  /// Details row label for status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get infoStatus;

  /// Details row label for increment step
  ///
  /// In en, this message translates to:
  /// **'Increment step'**
  String get infoIncrementStep;

  /// Details row label for initial count
  ///
  /// In en, this message translates to:
  /// **'Initial count'**
  String get infoInitialCount;

  /// Details row label for lifetime goal
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal'**
  String get infoLifetimeGoal;

  /// Details row label for daily goal
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get infoDailyGoal;

  /// Details row label for started date
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get infoStarted;

  /// Details row label for created date
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get infoCreated;

  /// Details row label for average daily count
  ///
  /// In en, this message translates to:
  /// **'Avg daily count'**
  String get infoAvgDaily;

  /// Details row label for disabled date
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get infoDisabled;

  /// Status text for active counter
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// Status text for completed counter
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Screen title for About screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// App version label on the about screen
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// Header for Purpose section in About screen
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get aboutPurposeTitle;

  /// Description of app purpose in About screen
  ///
  /// In en, this message translates to:
  /// **'Track your mantra recitation practice with mala (108-bead round) counting, daily and lifetime goals, and full session history.'**
  String get aboutPurposeBody;

  /// Header for Offline section in About screen
  ///
  /// In en, this message translates to:
  /// **'Fully offline'**
  String get aboutOfflineTitle;

  /// Description of offline storage in About screen
  ///
  /// In en, this message translates to:
  /// **'No network access. All data stored only on your device.'**
  String get aboutOfflineBody;

  /// Header for Privacy section in About screen
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// Description of privacy policy in About screen
  ///
  /// In en, this message translates to:
  /// **'No analytics, no tracking, no data shared with anyone.'**
  String get aboutPrivacyBody;

  /// Header for Backup section in About screen
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get aboutBackupTitle;

  /// Description of backup functionality in About screen
  ///
  /// In en, this message translates to:
  /// **'Use Import / Export to back up your data to a JSON file.'**
  String get aboutBackupBody;

  /// Devotional mantra quote shown on About screen
  ///
  /// In en, this message translates to:
  /// **'Om Namah Shivaya'**
  String get aboutMantraQuote;

  /// Prefix for Made with love footer in About screen
  ///
  /// In en, this message translates to:
  /// **'Made with '**
  String get aboutMadeWithPrefix;

  /// Suffix for Made with love from India footer in About screen
  ///
  /// In en, this message translates to:
  /// **' from India'**
  String get aboutMadeWithSuffix;

  /// Screen title for Settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Eyebrow header on settings screen
  ///
  /// In en, this message translates to:
  /// **'PRACTICE'**
  String get practiceEyebrow;

  /// Settings section title for daily goal notification options
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get sectionDailyGoal;

  /// Subtitle for daily goal settings section
  ///
  /// In en, this message translates to:
  /// **'When the offering is complete'**
  String get sectionDailyGoalSub;

  /// Setting label to toggle daily goal notification
  ///
  /// In en, this message translates to:
  /// **'Enable notification'**
  String get enableNotification;

  /// Subtitle describing daily goal notification toggle
  ///
  /// In en, this message translates to:
  /// **'Vibrate and sound on completion'**
  String get enableNotificationSub;

  /// Setting label for daily goal vibration feedback
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// Subtitle describing vibration behavior on goal completion
  ///
  /// In en, this message translates to:
  /// **'A gentle hum on completion'**
  String get vibrationSub;

  /// Setting label for daily goal completion sound
  ///
  /// In en, this message translates to:
  /// **'Notification sound'**
  String get notificationSound;

  /// Setting button to test and hear the notification tone
  ///
  /// In en, this message translates to:
  /// **'Preview tone'**
  String get previewTone;

  /// Subtitle for preview tone action
  ///
  /// In en, this message translates to:
  /// **'Hear what plays on completion'**
  String get previewToneSub;

  /// Settings section title for mala completion feedback
  ///
  /// In en, this message translates to:
  /// **'Mala completion'**
  String get sectionMala;

  /// Subtitle for mala completion settings section
  ///
  /// In en, this message translates to:
  /// **'The closing of every 108 beads'**
  String get sectionMalaSub;

  /// Setting label to toggle mala completion sound
  ///
  /// In en, this message translates to:
  /// **'Enable mala sound'**
  String get enableMalaSound;

  /// Subtitle describing mala completion sound
  ///
  /// In en, this message translates to:
  /// **'A soft tick on each full mala'**
  String get enableMalaSoundSub;

  /// Settings section title for screen brightness control
  ///
  /// In en, this message translates to:
  /// **'Stillness'**
  String get sectionStillness;

  /// Subtitle for screen stillness settings section
  ///
  /// In en, this message translates to:
  /// **'For longer sessions'**
  String get sectionStillnessSub;

  /// Setting label for screen brightness adjustment
  ///
  /// In en, this message translates to:
  /// **'Brightness level'**
  String get brightnessLevel;

  /// Status indicating app uses system brightness
  ///
  /// In en, this message translates to:
  /// **'Following system'**
  String get followingSystem;

  /// Status indicating app overrides system brightness
  ///
  /// In en, this message translates to:
  /// **'Override active'**
  String get overrideActive;

  /// Label for dimmed/still brightness level
  ///
  /// In en, this message translates to:
  /// **'still'**
  String get brightnessStill;

  /// Label for default system brightness
  ///
  /// In en, this message translates to:
  /// **'use system'**
  String get brightnessUseSystem;

  /// Label for maximum brightness level
  ///
  /// In en, this message translates to:
  /// **'full'**
  String get brightnessFull;

  /// Settings section title for practice guide & help
  ///
  /// In en, this message translates to:
  /// **'Practice guide'**
  String get sectionPracticeGuide;

  /// Subtitle for practice guide settings section
  ///
  /// In en, this message translates to:
  /// **'Gestures and rhythms of use'**
  String get sectionPracticeGuideSub;

  /// Settings item to view guide on how counting works
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// Subtitle for How it works help guide
  ///
  /// In en, this message translates to:
  /// **'Counting, undo, and the menu — explained'**
  String get howItWorksSub;

  /// Informational guidance paragraph in sound settings
  ///
  /// In en, this message translates to:
  /// **'The daily-goal sound plays when your goal is reached. The mala sound rings softly after every 108 chants — except when that count also completes the daily offering.'**
  String get settingsGuidanceBody;

  /// Setting item title to delete all data
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearAllData;

  /// Subtitle warning for clear all data setting
  ///
  /// In en, this message translates to:
  /// **'Delete all counters and session history permanently'**
  String get clearAllDataSub;

  /// Subtitle when system default sound is active
  ///
  /// In en, this message translates to:
  /// **'System default — tap to change'**
  String get soundSystemDefaultTapToChange;

  /// Subtitle when named custom sound is active
  ///
  /// In en, this message translates to:
  /// **'{name} — tap to change'**
  String soundNamedTapToChange(String name);

  /// Subtitle when generic custom audio is active
  ///
  /// In en, this message translates to:
  /// **'Custom audio — tap to change'**
  String get soundCustomTapToChange;

  /// Option label for system default notification tone
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get soundSystemDefault;

  /// Option label to choose a custom audio file
  ///
  /// In en, this message translates to:
  /// **'Browse audio file…'**
  String get browseAudioFile;

  /// Confirmation dialog title for clearing all app data
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get clearAllDataTitle;

  /// Confirmation dialog message for clearing all app data
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all counters and all session history. This cannot be undone.'**
  String get clearAllDataMessage;

  /// Button label to confirm clearing all data
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllButton;

  /// Confirmation snackbar when all app data is cleared
  ///
  /// In en, this message translates to:
  /// **'All data cleared'**
  String get allDataCleared;

  /// Screen title for Help guide
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// Section header for counting gestures in Help screen
  ///
  /// In en, this message translates to:
  /// **'Counting'**
  String get helpCountingTitle;

  /// Instructions for counting chants in Help screen
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the bead circle to count one chant. Each 108 chants completes one mala — the ring fills as the beads pass.'**
  String get helpCountingBody;

  /// Section header for undo gesture in Help screen
  ///
  /// In en, this message translates to:
  /// **'Undoing a tap'**
  String get helpUndoTitle;

  /// Instructions for undo gesture in Help screen
  ///
  /// In en, this message translates to:
  /// **'Place two fingers on the bead circle and swipe — left or right — to undo your last chant. The session ends gracefully if the count returns to zero.'**
  String get helpUndoBody;

  /// Section header for session timer in Help screen
  ///
  /// In en, this message translates to:
  /// **'Timer & status'**
  String get helpTimerTitle;

  /// Instructions for timer and status indicators in Help screen
  ///
  /// In en, this message translates to:
  /// **'The pill at the top shows the time spent in this session. The green marker below the count tells you how many beads remain in the current mala, or that the daily offering is complete.'**
  String get helpTimerBody;

  /// Section header for reset options in Help screen
  ///
  /// In en, this message translates to:
  /// **'Resetting'**
  String get helpResetTitle;

  /// Instructions for resetting sessions and counters in Help screen
  ///
  /// In en, this message translates to:
  /// **'Open the menu (the three dots, top right of the counting screen) for Reset session and Reset counter. Reset session discards the current sitting; Reset counter clears all history for that mantra.'**
  String get helpResetBody;

  /// Compact card metric format showing chants and malas
  ///
  /// In en, this message translates to:
  /// **'chants · {malas} mala'**
  String cardChantsMala(int malas);

  /// Card badge indicating daily goal is complete
  ///
  /// In en, this message translates to:
  /// **'✓ complete'**
  String get cardComplete;

  /// Card badge showing daily progress percentage
  ///
  /// In en, this message translates to:
  /// **'{percent}% daily'**
  String cardPercentDaily(int percent);

  /// Placeholder on counter card when no daily goal is configured
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get cardNoDaily;

  /// Prefix for today's statistics on counter card
  ///
  /// In en, this message translates to:
  /// **'TODAY · '**
  String get cardTodayPrefix;

  /// Chant count with label on counter card
  ///
  /// In en, this message translates to:
  /// **'{count} chants'**
  String cardChants(String count);

  /// Mala count with label on counter card
  ///
  /// In en, this message translates to:
  /// **'{count} mala'**
  String cardMala(int count);

  /// Mala progress format showing current vs target malas
  ///
  /// In en, this message translates to:
  /// **'{current} / {target} mala'**
  String cardMalaProgress(int current, int target);

  /// Lifetime percentage progress on counter card
  ///
  /// In en, this message translates to:
  /// **'lifetime · {percent}%'**
  String cardLifetimePercent(String percent);

  /// Completed lifetime percentage progress on counter card
  ///
  /// In en, this message translates to:
  /// **'lifetime · {percent}% ✓'**
  String cardLifetimePercentComplete(String percent);

  /// Notification title fired when daily goal is reached
  ///
  /// In en, this message translates to:
  /// **'Daily Goal Achieved'**
  String get notifDailyGoalTitle;

  /// Notification body fired when daily goal is reached
  ///
  /// In en, this message translates to:
  /// **'You have reached your daily mantra count goal!'**
  String get notifDailyGoalBody;

  /// Email/share subject line when sharing exported backup file
  ///
  /// In en, this message translates to:
  /// **'SreerajP MantraJapa Counter Backup'**
  String get backupShareSubject;

  /// Title for the Appearance card in settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// Subtitle for the Appearance card in settings
  ///
  /// In en, this message translates to:
  /// **'Screen brightness, stillness mode & temple theme'**
  String get settingsAppearanceSub;

  /// Title for the Features card in settings
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get settingsFeaturesTitle;

  /// Subtitle for the Features card in settings
  ///
  /// In en, this message translates to:
  /// **'Explore all features of SreerajP MantraJapa Counter'**
  String get settingsFeaturesSub;

  /// Title for the Help card in settings
  ///
  /// In en, this message translates to:
  /// **'Help & User Guides'**
  String get settingsHelpTitle;

  /// Subtitle for the Help card in settings
  ///
  /// In en, this message translates to:
  /// **'How features like optical sync, mala counting & backup work'**
  String get settingsHelpSub;

  /// Subtitle for the About card in settings
  ///
  /// In en, this message translates to:
  /// **'Version, developer details & spiritual purpose'**
  String get settingsAboutSub;

  /// Title for Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// Header title on Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Temple Devotional Theme'**
  String get appearanceHeaderTitle;

  /// Header subtitle on Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Custom stillness brightness, sacred South Indian temple palette, and classical typography for distraction-free chanting.'**
  String get appearanceHeaderSub;

  /// Brightness section header on Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Screen Brightness & Stillness'**
  String get appearanceBrightnessSection;

  /// Palette section header on Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Sacred Temple Palette'**
  String get appearancePaletteSection;

  /// Typography section header on Appearance screen
  ///
  /// In en, this message translates to:
  /// **'Typography & Scripts'**
  String get appearanceTypographySection;

  /// Vermillion color name
  ///
  /// In en, this message translates to:
  /// **'Vermillion (Sindoor)'**
  String get paletteVermillionName;

  /// Vermillion color role description
  ///
  /// In en, this message translates to:
  /// **'Primary sacred accent, lotus motifs, active progress'**
  String get paletteVermillionRole;

  /// Tulsi color name
  ///
  /// In en, this message translates to:
  /// **'Tulsi Green'**
  String get paletteTulsiName;

  /// Tulsi color role description
  ///
  /// In en, this message translates to:
  /// **'Daily goal completed, auspicious success indicator'**
  String get paletteTulsiRole;

  /// Sandalwood color name
  ///
  /// In en, this message translates to:
  /// **'Sandalwood (Chandan)'**
  String get paletteSandalName;

  /// Sandalwood color role description
  ///
  /// In en, this message translates to:
  /// **'Peaceful highlights, lifetime milestones, bead markers'**
  String get paletteSandalRole;

  /// Rose color name
  ///
  /// In en, this message translates to:
  /// **'Rose Devotion'**
  String get paletteRoseName;

  /// Rose color role description
  ///
  /// In en, this message translates to:
  /// **'Soft devotional accents, multi-counter rotation'**
  String get paletteRoseRole;

  /// Cream background color name
  ///
  /// In en, this message translates to:
  /// **'Temple Sanctum Cream'**
  String get paletteCreamName;

  /// Cream background color role description
  ///
  /// In en, this message translates to:
  /// **'Warm background reducing eye strain during long sittings'**
  String get paletteCreamRole;

  /// Serif font title
  ///
  /// In en, this message translates to:
  /// **'EB Garamond (Devotional Serif)'**
  String get typographySerifTitle;

  /// Serif font subtitle
  ///
  /// In en, this message translates to:
  /// **'Classical italic numerals, mala totals, and sacred headers'**
  String get typographySerifSub;

  /// Sans font title
  ///
  /// In en, this message translates to:
  /// **'Inter (Clean UI Sans)'**
  String get typographySansTitle;

  /// Sans font subtitle
  ///
  /// In en, this message translates to:
  /// **'Legible labels, practice history, and settings controls'**
  String get typographySansSub;

  /// Malayalam font title
  ///
  /// In en, this message translates to:
  /// **'Noto Sans Malayalam (Indic Script)'**
  String get typographyMalTitle;

  /// Malayalam font subtitle
  ///
  /// In en, this message translates to:
  /// **'Authentic Malayalam mantra titles and stotram rendering'**
  String get typographyMalSub;

  /// Title for Features screen
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// Header title on Features screen
  ///
  /// In en, this message translates to:
  /// **'SreerajP MantraJapa Counter Features'**
  String get featuresHeaderTitle;

  /// Header subtitle on Features screen
  ///
  /// In en, this message translates to:
  /// **'Explore every sacred counting tool, air-gap sync safeguard, and temple aesthetic feature designed for your daily sadhana.'**
  String get featuresHeaderSub;

  /// Header title on Help hub screen
  ///
  /// In en, this message translates to:
  /// **'Help & User Guides'**
  String get helpHeaderTitle;

  /// Header subtitle on Help hub screen
  ///
  /// In en, this message translates to:
  /// **'Comprehensive guides to counting gestures, 108 mala calculations, optical air-gap sync, and privacy safeguards.'**
  String get helpHeaderSub;

  /// Counting category header in help
  ///
  /// In en, this message translates to:
  /// **'Counting & Meditation Practice'**
  String get helpCategoryCounting;

  /// Sync category header in help
  ///
  /// In en, this message translates to:
  /// **'Data Sync & Backup'**
  String get helpCategorySync;

  /// Audio category header in help
  ///
  /// In en, this message translates to:
  /// **'Audio & Feedback'**
  String get helpCategoryAudio;

  /// Privacy category header in help
  ///
  /// In en, this message translates to:
  /// **'Privacy & Support'**
  String get helpCategoryPrivacy;

  /// Counting topic title in help
  ///
  /// In en, this message translates to:
  /// **'Counting & Gestures Guide'**
  String get helpTopicCountingTitle;

  /// Counting topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the ring, two-finger swipe undo, and session persistence'**
  String get helpTopicCountingSub;

  /// Mala topic title in help
  ///
  /// In en, this message translates to:
  /// **'108 Mala Math & Goals'**
  String get helpTopicMalaTitle;

  /// Mala topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'How 108 bead cycles are calculated, excess counts, and daily goal targets'**
  String get helpTopicMalaSub;

  /// Optical sync topic title in help
  ///
  /// In en, this message translates to:
  /// **'Optical Air-Gap Sync'**
  String get helpTopicOpticalSyncTitle;

  /// Optical sync topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'Offline phone-to-phone data transfer via animated QR camera stream'**
  String get helpTopicOpticalSyncSub;

  /// Backup topic title in help
  ///
  /// In en, this message translates to:
  /// **'JSON Backup & Restore'**
  String get helpTopicBackupTitle;

  /// Backup topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'Exporting local backup files, sharing, and safe database restoration'**
  String get helpTopicBackupSub;

  /// Audio topic title in help
  ///
  /// In en, this message translates to:
  /// **'Sound & Vibration Settings'**
  String get helpTopicAudioTitle;

  /// Audio topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'Temple bell tones, mala chimes, custom audio files, and haptic feedback'**
  String get helpTopicAudioSub;

  /// Privacy topic title in help
  ///
  /// In en, this message translates to:
  /// **'Privacy & Offline-First Core'**
  String get helpTopicPrivacyTitle;

  /// Privacy topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'Zero internet permissions, local SQLite storage, and zero telemetry'**
  String get helpTopicPrivacySub;

  /// FAQ topic title in help
  ///
  /// In en, this message translates to:
  /// **'FAQs & Troubleshooting'**
  String get helpTopicFaqTitle;

  /// FAQ topic subtitle in help
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions, common issues, and helpful usage tips'**
  String get helpTopicFaqSub;

  /// Intro text on Counting Help screen
  ///
  /// In en, this message translates to:
  /// **'The counting screen is intentionally designed for quiet, mindful focus. You do not need to look at the screen while chanting.'**
  String get helpCountingIntro;

  /// Tap section title on Counting Help screen
  ///
  /// In en, this message translates to:
  /// **'How to Count'**
  String get helpCountingTapSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere:'**
  String get helpCountingTapBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Tap inside the large circle or anywhere on the central screen to increment by 1 count.'**
  String get helpCountingTapBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Haptic pulse:'**
  String get helpCountingTapBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'A gentle vibration confirms every chant so you can keep your eyes closed during meditation.'**
  String get helpCountingTapBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Crash recovery:'**
  String get helpCountingTapBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'Every 5 taps are automatically saved to local storage. If your battery dies, not a single count is lost.'**
  String get helpCountingTapBullet3;

  /// Undo section title on Counting Help screen
  ///
  /// In en, this message translates to:
  /// **'Undoing an Accidental Count'**
  String get helpCountingUndoSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Two-finger swipe:'**
  String get helpCountingUndoBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Swipe left or right across the mala circle with two fingers to decrement the count by 1.'**
  String get helpCountingUndoBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Zero count threshold:'**
  String get helpCountingUndoBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'If you reduce the session count to zero, the sitting session is gracefully cleared without polluting history.'**
  String get helpCountingUndoBullet2;

  /// Timer section title on Counting Help screen
  ///
  /// In en, this message translates to:
  /// **'Session Timing & Status'**
  String get helpCountingTimerSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Active timer:'**
  String get helpCountingTimerBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'The top capsule displays the active duration spent in this sitting.'**
  String get helpCountingTimerBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Progress badge:'**
  String get helpCountingTimerBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Shows remaining beads to complete the current 108 cycle or confirms daily goal completion.'**
  String get helpCountingTimerBullet2;

  /// Intro text on Mala Help screen
  ///
  /// In en, this message translates to:
  /// **'In traditional Vedic and Buddhist practices, a Japa Mala consists of 108 beads. The app faithfully calculates rounds and progress based on this sacred principle.'**
  String get helpMalaIntro;

  /// Mala calculation section title
  ///
  /// In en, this message translates to:
  /// **'108 Beads Calculation'**
  String get helpMalaBeadsSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'1 Mala = 108 counts:'**
  String get helpMalaBeadsBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Every 108 counts automatically completes 1 full mala round.'**
  String get helpMalaBeadsBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Excess counts:'**
  String get helpMalaBeadsBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Counts between mala multiples (e.g. 115 counts = 1 mala + 7 counts) are clearly shown.'**
  String get helpMalaBeadsBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Mala chime:'**
  String get helpMalaBeadsBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'When enabled, a gentle bell sounds on the exact 108th bead of each round.'**
  String get helpMalaBeadsBullet3;

  /// Mala goals section title
  ///
  /// In en, this message translates to:
  /// **'Setting Goals & Dedications'**
  String get helpMalaGoalsSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Daily target:'**
  String get helpMalaGoalsBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Set how many malas you commit to chanting every day. The card turns green upon reaching the target.'**
  String get helpMalaGoalsBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Lifetime target:'**
  String get helpMalaGoalsBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Set long-term sadhana goals (e.g. 100,000 chants or 1,000 malas) to track your cumulative spiritual journey.'**
  String get helpMalaGoalsBullet2;

  /// Intro text on Optical Sync Help screen
  ///
  /// In en, this message translates to:
  /// **'Optical Air-Gap Sync allows you to migrate all your counters and history between two phones without Wi-Fi, Bluetooth, or cloud servers.'**
  String get helpOpticalIntro;

  /// Optical how section title
  ///
  /// In en, this message translates to:
  /// **'How to Transfer'**
  String get helpOpticalHowSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'On the sender phone:'**
  String get helpOpticalHowBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Go to Settings -> Optical Air-Gap Sync (Send). An animated QR stream will begin playing.'**
  String get helpOpticalHowBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'On the receiver phone:'**
  String get helpOpticalHowBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Go to Settings -> Optical Air-Gap Sync (Receive) and point the camera at the sender phone\'s screen.'**
  String get helpOpticalHowBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Automatic assembly:'**
  String get helpOpticalHowBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'The receiver collects stream packets and reconstructs the full database with zero data corruption.'**
  String get helpOpticalHowBullet3;

  /// Optical tips section title
  ///
  /// In en, this message translates to:
  /// **'Tips for Fast Scanning'**
  String get helpOpticalTipsSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Screen brightness:'**
  String get helpOpticalTipsBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Ensure the sending screen is at moderate-to-high brightness without screen glare.'**
  String get helpOpticalTipsBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Steady distance:'**
  String get helpOpticalTipsBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Hold the receiving phone steadily 15 to 25 cm away from the sender screen.'**
  String get helpOpticalTipsBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Fountain codes:'**
  String get helpOpticalTipsBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'Even if the camera drops a few frames, fountain parity packets will recover the missing data.'**
  String get helpOpticalTipsBullet3;

  /// Intro text on Audio Help screen
  ///
  /// In en, this message translates to:
  /// **'Personalize the soundscape of your practice with gentle bells, temple chimes, and haptic vibrations.'**
  String get helpAudioIntro;

  /// Audio tones section title
  ///
  /// In en, this message translates to:
  /// **'Chimes & Notification Tones'**
  String get helpAudioTonesSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Daily goal tone:'**
  String get helpAudioTonesBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Plays a peaceful bell tone when you reach your daily target for any mantra.'**
  String get helpAudioTonesBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Mala chime:'**
  String get helpAudioTonesBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Plays a soft chime on the 108th bead of every round.'**
  String get helpAudioTonesBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Custom audio picker:'**
  String get helpAudioTonesBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'Choose any MP3, WAV, or ringtone audio file from your device.'**
  String get helpAudioTonesBullet3;

  /// Audio vibration section title
  ///
  /// In en, this message translates to:
  /// **'Haptic Vibration'**
  String get helpAudioVibrationSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Count pulse:'**
  String get helpAudioVibrationBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Subtle tactile pulse with every chant to keep track without looking.'**
  String get helpAudioVibrationBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Disable anytime:'**
  String get helpAudioVibrationBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Turn off vibration under Settings if you prefer silent meditation.'**
  String get helpAudioVibrationBullet2;

  /// Intro text on Backup Help screen
  ///
  /// In en, this message translates to:
  /// **'Your practice data is 100% owned by you. You can export complete backups to JSON files at any time.'**
  String get helpBackupIntro;

  /// Backup export section title
  ///
  /// In en, this message translates to:
  /// **'Exporting Data'**
  String get helpBackupExportSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'Standard JSON file:'**
  String get helpBackupExportBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Exports all counters, daily goals, lifetime progress, and session history into one clean file.'**
  String get helpBackupExportBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'System share sheet:'**
  String get helpBackupExportBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Save the exported file to your local files, SD card, or share it via your favorite offline file transfer app.'**
  String get helpBackupExportBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Room & Gson compatible:'**
  String get helpBackupExportBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'Fully compatible with existing and future versions of the app.'**
  String get helpBackupExportBullet3;

  /// Backup import section title
  ///
  /// In en, this message translates to:
  /// **'Restoring Data'**
  String get helpBackupImportSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'File picker:'**
  String get helpBackupImportBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'Tap \'Import Backup File\' and select your previously saved JSON file.'**
  String get helpBackupImportBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Safe validation:'**
  String get helpBackupImportBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'The file is verified for integrity before restoring to prevent corrupted entries.'**
  String get helpBackupImportBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'Instant refresh:'**
  String get helpBackupImportBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'Counters and session history update immediately across the app.'**
  String get helpBackupImportBullet3;

  /// Intro text on Privacy Help screen
  ///
  /// In en, this message translates to:
  /// **'SreerajP MantraJapa Counter is built with a strict privacy-first and offline-first ethos.'**
  String get helpPrivacyIntro;

  /// Privacy offline section title
  ///
  /// In en, this message translates to:
  /// **'100% Offline by Design'**
  String get helpPrivacyOfflineSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'No INTERNET permission:'**
  String get helpPrivacyOfflineBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'The app does not declare the Android INTERNET permission and cannot access the web.'**
  String get helpPrivacyOfflineBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Zero telemetry & tracking:'**
  String get helpPrivacyOfflineBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'No analytics SDKs, crash reporters, or background advertising services are bundled.'**
  String get helpPrivacyOfflineBullet2;

  /// Bold prefix 3
  ///
  /// In en, this message translates to:
  /// **'No cloud login:'**
  String get helpPrivacyOfflineBold3;

  /// Bullet 3
  ///
  /// In en, this message translates to:
  /// **'You never need to create an account or provide an email or phone number.'**
  String get helpPrivacyOfflineBullet3;

  /// Privacy storage section title
  ///
  /// In en, this message translates to:
  /// **'Local Storage & Data Integrity'**
  String get helpPrivacyStorageSection;

  /// Bold prefix 1
  ///
  /// In en, this message translates to:
  /// **'SQLite database:'**
  String get helpPrivacyStorageBold1;

  /// Bullet 1
  ///
  /// In en, this message translates to:
  /// **'All counters and session history reside inside an encrypted/isolated SQLite database on your device.'**
  String get helpPrivacyStorageBullet1;

  /// Bold prefix 2
  ///
  /// In en, this message translates to:
  /// **'Crash-proof writes:'**
  String get helpPrivacyStorageBold2;

  /// Bullet 2
  ///
  /// In en, this message translates to:
  /// **'Frequent recovery checkpoints ensure your count is preserved during sudden app switches.'**
  String get helpPrivacyStorageBullet2;

  /// Intro text on FAQ Help screen
  ///
  /// In en, this message translates to:
  /// **'Quick answers to common questions about SreerajP MantraJapa Counter.'**
  String get helpFaqIntro;

  /// FAQ Q1 title
  ///
  /// In en, this message translates to:
  /// **'Why is the app completely offline?'**
  String get helpFaqQ1Title;

  /// FAQ Q1 answer
  ///
  /// In en, this message translates to:
  /// **'Japa meditation is a deeply personal and sacred practice. By running strictly offline with no network permissions, we ensure complete privacy, battery efficiency, and zero distractions.'**
  String get helpFaqQ1Answer;

  /// FAQ Q2 title
  ///
  /// In en, this message translates to:
  /// **'How does Optical Air-Gap Sync work without internet?'**
  String get helpFaqQ2Title;

  /// FAQ Q2 answer
  ///
  /// In en, this message translates to:
  /// **'The sending phone converts your backup into an animated stream of QR codes displayed on screen. The receiving phone\'s camera reads these frames and reassembles the complete database locally in seconds.'**
  String get helpFaqQ2Answer;

  /// FAQ Q3 title
  ///
  /// In en, this message translates to:
  /// **'What does Stillness Brightness mode do?'**
  String get helpFaqQ3Title;

  /// FAQ Q3 answer
  ///
  /// In en, this message translates to:
  /// **'It allows you to dim the screen to minimal ambient brightness so you can chant in dark rooms or temples without glaring light disturbing others.'**
  String get helpFaqQ3Answer;

  /// FAQ Q4 title
  ///
  /// In en, this message translates to:
  /// **'Can I transfer my data when upgrading to a new phone?'**
  String get helpFaqQ4Title;

  /// FAQ Q4 answer
  ///
  /// In en, this message translates to:
  /// **'Yes! You can either use Optical Air-Gap Sync between both phones side-by-side or export a JSON backup file to restore on the new device.'**
  String get helpFaqQ4Answer;
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
