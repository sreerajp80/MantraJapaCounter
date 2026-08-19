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
