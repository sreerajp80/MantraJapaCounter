import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_sa.dart';

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
    Locale('sa'),
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

  /// Banner on the counting screen when an unfinished mala from an earlier day is resumed
  ///
  /// In en, this message translates to:
  /// **'Unfinished mala from an earlier day: {chants}/108'**
  String unfinishedMalaBanner(int chants);

  /// Banner button that keeps the unfinished counts and starts a fresh session at 0
  ///
  /// In en, this message translates to:
  /// **'Start new'**
  String get startNewSession;

  /// Menu option that closes the current session, keeping its counts, and starts a fresh one
  ///
  /// In en, this message translates to:
  /// **'Finish & start new'**
  String get finishAndStartNew;

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

  /// Build date label on the about screen
  ///
  /// In en, this message translates to:
  /// **'Build date: {date}'**
  String aboutBuildDate(String date);

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
  /// **'Ganeshaya Namah, Hare Krishna, Durgayei Namah'**
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

  /// About-screen signature badge. {heart} is a red heart glyph.
  ///
  /// In en, this message translates to:
  /// **'Made with {heart} from India'**
  String madeWithLove(String heart);

  /// Screen-reader text for the About badge
  ///
  /// In en, this message translates to:
  /// **'Made with love from India'**
  String get madeWithLoveA11y;

  /// About screen author detail row label
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get aboutDetailAuthor;

  /// About screen email detail row label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutDetailEmail;

  /// About screen license detail row label
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get aboutDetailLicense;

  /// About screen AI used detail row label
  ///
  /// In en, this message translates to:
  /// **'AI used'**
  String get aboutDetailAiUsed;

  /// About screen IDE used detail row label
  ///
  /// In en, this message translates to:
  /// **'IDE used'**
  String get aboutDetailIdeUsed;

  /// App description shown under version on About screen
  ///
  /// In en, this message translates to:
  /// **'Offline-first application for tracking mantra recitation practice with customizable counters and session history.'**
  String get aboutDescription;

  /// Label for author row on About screen
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get aboutAuthor;

  /// Author name on About screen
  ///
  /// In en, this message translates to:
  /// **'Sreeraj P'**
  String get aboutAuthorValue;

  /// Label for email row on About screen
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutEmail;

  /// Label for license row on About screen
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get aboutLicense;

  /// License description value on About screen
  ///
  /// In en, this message translates to:
  /// **'All libraries used are open source.'**
  String get aboutLicenseValue;

  /// Label for AI used row on About screen
  ///
  /// In en, this message translates to:
  /// **'AI used'**
  String get aboutAiUsed;

  /// AI models used on About screen
  ///
  /// In en, this message translates to:
  /// **'Google Gemini / Anthropic Claude'**
  String get aboutAiUsedValue;

  /// Label for IDE used row on About screen
  ///
  /// In en, this message translates to:
  /// **'IDE used'**
  String get aboutIdeUsed;

  /// IDE tools used on About screen
  ///
  /// In en, this message translates to:
  /// **'VS Code / Antigravity IDE'**
  String get aboutIdeUsedValue;

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

  /// Settings section title for language options
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// Subtitle for language settings section
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get sectionLanguageSub;

  /// Setting label for selecting app language
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// Option to follow device system language
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// English language display name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Malayalam language display name
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get malayalamLanguage;

  /// Sanskrit language display name
  ///
  /// In en, this message translates to:
  /// **'Sanskrit'**
  String get sanskritLanguage;

  /// Title of the language picker dialog or sheet
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguageTitle;

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

  /// Setting label for mala completion soundscape
  ///
  /// In en, this message translates to:
  /// **'Mala sound'**
  String get malaSoundTitle;

  /// Subtitle describing mala completion soundscape setting
  ///
  /// In en, this message translates to:
  /// **'Sacred sound played when completing 108 beads'**
  String get malaSoundSub;

  /// Name of Temple Bronze Bell (Ghanta) soundscape
  ///
  /// In en, this message translates to:
  /// **'Temple Bronze Bell'**
  String get soundTempleBell;

  /// Description of Temple Bronze Bell soundscape
  ///
  /// In en, this message translates to:
  /// **'Deep, tranquil bronze resonance (Ghanta)'**
  String get soundTempleBellSub;

  /// Name of Tibetan Singing Bowl soundscape
  ///
  /// In en, this message translates to:
  /// **'Tibetan Singing Bowl'**
  String get soundSingingBowl;

  /// Description of Tibetan Singing Bowl soundscape
  ///
  /// In en, this message translates to:
  /// **'Soothing harmonic overtone for quiet mindfulness'**
  String get soundSingingBowlSub;

  /// Name of legacy synthesized tone soundscape
  ///
  /// In en, this message translates to:
  /// **'Synthesized Tone'**
  String get soundSynthesizedTone;

  /// Description of synthesized electronic beep
  ///
  /// In en, this message translates to:
  /// **'Classic 100ms electronic beep (DTMF)'**
  String get soundSynthesizedToneSub;

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

  /// Title for Do Not Disturb setting toggle
  ///
  /// In en, this message translates to:
  /// **'Silence notifications (Do Not Disturb)'**
  String get dndTitle;

  /// Subtitle for Do Not Disturb setting toggle
  ///
  /// In en, this message translates to:
  /// **'Silence incoming alerts and calls while chanting'**
  String get dndSub;

  /// Title for DND permission dialog
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb Permission'**
  String get dndPermissionTitle;

  /// Message explaining why DND permission is needed
  ///
  /// In en, this message translates to:
  /// **'To automatically silence incoming calls and notifications during chanting, please allow Do Not Disturb access in Android settings.'**
  String get dndPermissionMessage;

  /// Button to open system DND settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get dndOpenSettings;

  /// Title for dimmed chanting mode
  ///
  /// In en, this message translates to:
  /// **'Dimmed Chanting Mode'**
  String get dimmedModeTitle;

  /// Subtitle for dimmed chanting mode
  ///
  /// In en, this message translates to:
  /// **'Darkens the background while keeping the mala circle clearly visible to save battery'**
  String get dimmedModeSub;

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

  /// Help hub header subtitle listing all topics
  ///
  /// In en, this message translates to:
  /// **'Guides for every part of the app: counters, counting, malas and goals, history, sound, display, backup, optical sync and privacy.'**
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

  /// Help hub category: sound, display and stillness
  ///
  /// In en, this message translates to:
  /// **'Sound, Display & Stillness'**
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

  /// Help topic subtitle: counting
  ///
  /// In en, this message translates to:
  /// **'Tap inside the circle, two-finger undo, the counting menu and auto save'**
  String get helpTopicCountingSub;

  /// Mala topic title in help
  ///
  /// In en, this message translates to:
  /// **'108 Mala Math & Goals'**
  String get helpTopicMalaTitle;

  /// Help topic subtitle: mala and goals
  ///
  /// In en, this message translates to:
  /// **'108-bead rounds, extra counts, and daily and lifetime goals'**
  String get helpTopicMalaSub;

  /// Optical sync topic title in help
  ///
  /// In en, this message translates to:
  /// **'Optical Air-Gap Sync'**
  String get helpTopicOpticalSyncTitle;

  /// Help topic subtitle: optical sync
  ///
  /// In en, this message translates to:
  /// **'Phone-to-phone transfer with a moving QR code, without internet'**
  String get helpTopicOpticalSyncSub;

  /// Help topic title: backup and restore
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get helpTopicBackupTitle;

  /// Help topic subtitle: backup and restore
  ///
  /// In en, this message translates to:
  /// **'Export to a file, encrypted backups, import and clear all data'**
  String get helpTopicBackupSub;

  /// Audio topic title in help
  ///
  /// In en, this message translates to:
  /// **'Sound & Vibration Settings'**
  String get helpTopicAudioTitle;

  /// Help topic subtitle: sound and vibration
  ///
  /// In en, this message translates to:
  /// **'Mala sound, goal tones, notifications and vibration'**
  String get helpTopicAudioSub;

  /// Privacy topic title in help
  ///
  /// In en, this message translates to:
  /// **'Privacy & Offline-First Core'**
  String get helpTopicPrivacyTitle;

  /// Help topic subtitle: privacy
  ///
  /// In en, this message translates to:
  /// **'No internet permission, private storage, and the permissions used'**
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

  /// Help counting guide: intro text
  ///
  /// In en, this message translates to:
  /// **'The counting screen is made for quiet focus. You do not need to look at it while you chant.'**
  String get helpCountingIntro;

  /// Help counting guide: Tap section title
  ///
  /// In en, this message translates to:
  /// **'How to count'**
  String get helpCountingTapSection;

  /// Help counting guide: Tap bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Tap inside the circle:'**
  String get helpCountingTapBold1;

  /// Help counting guide: Tap bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Only taps inside the mala circle are counted. Taps outside it are ignored, so a stray touch does not add a count.'**
  String get helpCountingTapBullet1;

  /// Help counting guide: Tap bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Increment step:'**
  String get helpCountingTapBold2;

  /// Help counting guide: Tap bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Each tap adds the counter\'s step (1 by default). Change it by editing the counter.'**
  String get helpCountingTapBullet2;

  /// Help counting guide: Tap bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Quiet taps:'**
  String get helpCountingTapBold3;

  /// Help counting guide: Tap bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Taps do not vibrate. You feel a vibration on each full mala, on goals and on undo, if vibration is on.'**
  String get helpCountingTapBullet3;

  /// Help counting guide: Undo section title
  ///
  /// In en, this message translates to:
  /// **'Undoing a count'**
  String get helpCountingUndoSection;

  /// Help counting guide: Undo bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Two-finger swipe:'**
  String get helpCountingUndoBold1;

  /// Help counting guide: Undo bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Place two fingers on the circle and slide them left or right. One swipe removes one step, and the phone vibrates once.'**
  String get helpCountingUndoBullet1;

  /// Help counting guide: Undo bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Back to zero:'**
  String get helpCountingUndoBold2;

  /// Help counting guide: Undo bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'If the session count goes back to 0, the sitting is cleared and nothing is added to history.'**
  String get helpCountingUndoBullet2;

  /// Help mala and goals guide: intro text
  ///
  /// In en, this message translates to:
  /// **'A traditional japa mala has 108 beads. The app counts in rounds of 108 and shows your goals on every card.'**
  String get helpMalaIntro;

  /// Help mala and goals guide: Beads section title
  ///
  /// In en, this message translates to:
  /// **'108 beads'**
  String get helpMalaBeadsSection;

  /// Help mala and goals guide: Beads bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'1 mala = 108 counts:'**
  String get helpMalaBeadsBold1;

  /// Help mala and goals guide: Beads bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Every 108 counts make one full mala. The circle on the counting screen fills bead by bead and starts again after 108.'**
  String get helpMalaBeadsBullet1;

  /// Help mala and goals guide: Beads bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Extra counts:'**
  String get helpMalaBeadsBold2;

  /// Help mala and goals guide: Beads bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Counts past a full mala are kept and shown. For example, 115 counts = 1 mala and 7 counts.'**
  String get helpMalaBeadsBullet2;

  /// Help mala and goals guide: Beads bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Bigger steps:'**
  String get helpMalaBeadsBold3;

  /// Help mala and goals guide: Beads bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'If your step is more than 1, each tap moves several beads at once. Malas are still worked out from the total count.'**
  String get helpMalaBeadsBullet3;

  /// Help mala and goals guide: Goals section title
  ///
  /// In en, this message translates to:
  /// **'Daily and lifetime goals'**
  String get helpMalaGoalsSection;

  /// Help mala and goals guide: Goals bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Daily goal:'**
  String get helpMalaGoalsBold1;

  /// Help mala and goals guide: Goals bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'The number of chants you want to offer each day (0 = no daily goal). It starts again from 0 at midnight, by your phone\'s clock.'**
  String get helpMalaGoalsBullet1;

  /// Help mala and goals guide: Goals bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal (vow):'**
  String get helpMalaGoalsBold2;

  /// Help mala and goals guide: Goals bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Your long-term target, for example 1,00,000 chants (0 = no lifetime goal). The daily goal cannot be more than it.'**
  String get helpMalaGoalsBullet2;

  /// Help optical sync guide: intro text
  ///
  /// In en, this message translates to:
  /// **'Optical Sync moves your counters and history from one phone to another using only the screen and the camera. No internet, Wi-Fi, Bluetooth or cable is needed.'**
  String get helpOpticalIntro;

  /// Help optical sync guide: How section title
  ///
  /// In en, this message translates to:
  /// **'How to transfer'**
  String get helpOpticalHowSection;

  /// Help optical sync guide: How bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Sender phone:'**
  String get helpOpticalHowBold1;

  /// Help optical sync guide: How bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Settings → Data Backup & Optical Sync → Optical Air-Gap Sync (Send). Choose the counters to send. A moving QR code starts to play.'**
  String get helpOpticalHowBullet1;

  /// Help optical sync guide: How bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Receiver phone:'**
  String get helpOpticalHowBold2;

  /// Help optical sync guide: How bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Open Optical Air-Gap Sync (Receive), allow the camera, and point it at the sender\'s screen.'**
  String get helpOpticalHowBullet2;

  /// Help optical sync guide: How bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Preview:'**
  String get helpOpticalHowBold3;

  /// Help optical sync guide: How bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'When all parts arrive, a preview shows the counters and sessions. Choose the counters to keep and tap the restore button.'**
  String get helpOpticalHowBullet3;

  /// Help optical sync guide: Tips section title
  ///
  /// In en, this message translates to:
  /// **'Tips for fast scanning'**
  String get helpOpticalTipsSection;

  /// Help optical sync guide: Tips bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Distance:'**
  String get helpOpticalTipsBold1;

  /// Help optical sync guide: Tips bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Hold the receiving phone steady, about 15–25 cm from the sender\'s screen, with the code inside the guide box.'**
  String get helpOpticalTipsBullet1;

  /// Help optical sync guide: Tips bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Glare:'**
  String get helpOpticalTipsBold2;

  /// Help optical sync guide: Tips bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Avoid bright reflections on the sender\'s screen.'**
  String get helpOpticalTipsBullet2;

  /// Help optical sync guide: Tips bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Missed frames:'**
  String get helpOpticalTipsBold3;

  /// Help optical sync guide: Tips bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Missed frames are fine. The stream keeps repeating with extra mixed frames, so missing parts are rebuilt.'**
  String get helpOpticalTipsBullet3;

  /// Help sound and vibration guide: intro text
  ///
  /// In en, this message translates to:
  /// **'Sounds and vibration mark the moments that matter: each full mala and each goal. Set them in Settings → Sound & Haptics.'**
  String get helpAudioIntro;

  /// Help sound and vibration guide: Vibration section title
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get helpAudioVibrationSection;

  /// Help sound and vibration guide: Vibration bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'When it vibrates:'**
  String get helpAudioVibrationBold1;

  /// Help sound and vibration guide: Vibration bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'One pulse on each full mala, three pulses when a goal is reached, and a short tap when you undo.'**
  String get helpAudioVibrationBullet1;

  /// Help sound and vibration guide: Vibration bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Turn off:'**
  String get helpAudioVibrationBold2;

  /// Help sound and vibration guide: Vibration bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Switch off Vibration in Settings → Sound & Haptics for fully silent practice.'**
  String get helpAudioVibrationBullet2;

  /// Help backup and restore guide: intro text
  ///
  /// In en, this message translates to:
  /// **'Your data belongs to you. Save it to a file at any time, and restore it on this phone or a new one.'**
  String get helpBackupIntro;

  /// Help backup and restore guide: Export section title
  ///
  /// In en, this message translates to:
  /// **'Exporting a backup'**
  String get helpBackupExportSection;

  /// Help backup and restore guide: Export bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'One file:'**
  String get helpBackupExportBold1;

  /// Help backup and restore guide: Export bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'All counters, goals and session history go into one backup file.'**
  String get helpBackupExportBullet1;

  /// Help backup and restore guide: Export bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Encrypt (optional):'**
  String get helpBackupExportBold2;

  /// Help backup and restore guide: Export bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'You can protect the file with a passphrase. It is locked with strong AES-256-GCM encryption.'**
  String get helpBackupExportBullet2;

  /// Help backup and restore guide: Export bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Keep your passphrase safe:'**
  String get helpBackupExportBold3;

  /// Help backup and restore guide: Export bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'A lost passphrase cannot be recovered, and the file cannot be opened without it.'**
  String get helpBackupExportBullet3;

  /// Help backup and restore guide: Import section title
  ///
  /// In en, this message translates to:
  /// **'Restoring a backup'**
  String get helpBackupImportSection;

  /// Help backup and restore guide: Import bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Pick the file:'**
  String get helpBackupImportBold1;

  /// Help backup and restore guide: Import bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Choose Import and select your backup file in the system file picker.'**
  String get helpBackupImportBullet1;

  /// Help backup and restore guide: Import bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Replaces all data:'**
  String get helpBackupImportBold2;

  /// Help backup and restore guide: Import bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Import replaces ALL current counters and history with the data in the file. Export first if you want to keep what is on the phone.'**
  String get helpBackupImportBullet2;

  /// Help backup and restore guide: Import bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Encrypted files:'**
  String get helpBackupImportBold3;

  /// Help backup and restore guide: Import bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'If the file is encrypted, you are asked for the passphrase.'**
  String get helpBackupImportBullet3;

  /// Help privacy guide: intro text
  ///
  /// In en, this message translates to:
  /// **'SreerajP MantraJapa Counter is private by design. Your practice stays on your phone.'**
  String get helpPrivacyIntro;

  /// Help privacy guide: Offline section title
  ///
  /// In en, this message translates to:
  /// **'Fully offline'**
  String get helpPrivacyOfflineSection;

  /// Help privacy guide: Offline bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'No internet permission:'**
  String get helpPrivacyOfflineBold1;

  /// Help privacy guide: Offline bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'The app does not have the Android internet permission, so it cannot send anything anywhere.'**
  String get helpPrivacyOfflineBullet1;

  /// Help privacy guide: Offline bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'No tracking:'**
  String get helpPrivacyOfflineBold2;

  /// Help privacy guide: Offline bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'No analytics, no crash reporters and no ads.'**
  String get helpPrivacyOfflineBullet2;

  /// Help privacy guide: Offline bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'No account:'**
  String get helpPrivacyOfflineBold3;

  /// Help privacy guide: Offline bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'You never need to sign up or give an email or phone number.'**
  String get helpPrivacyOfflineBullet3;

  /// Help privacy guide: Storage section title
  ///
  /// In en, this message translates to:
  /// **'Where your data is kept'**
  String get helpPrivacyStorageSection;

  /// Help privacy guide: Storage bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'On your phone only:'**
  String get helpPrivacyStorageBold1;

  /// Help privacy guide: Storage bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Counters and history are kept in the app\'s private storage on your phone. Other apps cannot read it.'**
  String get helpPrivacyStorageBullet1;

  /// Help privacy guide: Storage bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'No cloud backup:'**
  String get helpPrivacyStorageBold2;

  /// Help privacy guide: Storage bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Android\'s automatic cloud backup is turned off for this app. Use Export or Optical Sync to keep a copy.'**
  String get helpPrivacyStorageBullet2;

  /// Help FAQ: intro text
  ///
  /// In en, this message translates to:
  /// **'Quick answers to common questions.'**
  String get helpFaqIntro;

  /// Help FAQ: question 1
  ///
  /// In en, this message translates to:
  /// **'Why did my tap not count?'**
  String get helpFaqQ1Title;

  /// Help FAQ: answer 1
  ///
  /// In en, this message translates to:
  /// **'Only taps inside the mala circle count. If Meru pause is on, taps during the short pause after each mala are not counted either.'**
  String get helpFaqQ1Answer;

  /// Help FAQ: question 2
  ///
  /// In en, this message translates to:
  /// **'How do I undo a wrong count?'**
  String get helpFaqQ2Title;

  /// Help FAQ: answer 2
  ///
  /// In en, this message translates to:
  /// **'Put two fingers on the mala circle and slide them left or right. Each swipe removes one step.'**
  String get helpFaqQ2Answer;

  /// Help FAQ: question 3
  ///
  /// In en, this message translates to:
  /// **'Why does my counter not open?'**
  String get helpFaqQ3Title;

  /// Help FAQ: answer 3
  ///
  /// In en, this message translates to:
  /// **'It is either locked or disabled. Tap the lock icon on the card to unlock it. Disabled counters cannot be opened for counting.'**
  String get helpFaqQ3Answer;

  /// Help FAQ: question 4
  ///
  /// In en, this message translates to:
  /// **'What happens if I stop in the middle of a mala?'**
  String get helpFaqQ4Title;

  /// Help FAQ: answer 4
  ///
  /// In en, this message translates to:
  /// **'Nothing is lost. The counts are saved, and the mala waits for you next time, even on another day. Tap Start new if you want to begin again at 0.'**
  String get helpFaqQ4Answer;

  /// Action label to lock a counter
  ///
  /// In en, this message translates to:
  /// **'Lock counter'**
  String get lockCounter;

  /// Action label to unlock a counter
  ///
  /// In en, this message translates to:
  /// **'Unlock counter'**
  String get unlockCounter;

  /// Notice shown when tapping a locked counter card
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" is locked. Unlock to start chanting.'**
  String counterLockedNotice(String name);

  /// Tooltip for locked button on counter card
  ///
  /// In en, this message translates to:
  /// **'Locked — tap to unlock'**
  String get counterLockedTooltip;

  /// Tooltip for unlocked button on counter card
  ///
  /// In en, this message translates to:
  /// **'Unlocked — tap to lock'**
  String get counterUnlockedTooltip;

  /// Status text indicating counter is locked
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get statusLocked;

  /// Settings section title for backup and optical sync
  ///
  /// In en, this message translates to:
  /// **'Data Backup & Optical Sync'**
  String get settingsBackupTitle;

  /// Settings section subtitle for backup and optical sync
  ///
  /// In en, this message translates to:
  /// **'100% offline device-to-device sync and backup'**
  String get settingsBackupSub;

  /// Settings row title to start an optical sync transmission
  ///
  /// In en, this message translates to:
  /// **'Optical Air-Gap Sync (Send)'**
  String get settingsOpticalSendTitle;

  /// Settings row subtitle for optical sync send
  ///
  /// In en, this message translates to:
  /// **'Transmit counters & history via animated QR stream'**
  String get settingsOpticalSendSub;

  /// Settings row title to start an optical sync reception
  ///
  /// In en, this message translates to:
  /// **'Optical Air-Gap Sync (Receive)'**
  String get settingsOpticalReceiveTitle;

  /// Settings row subtitle for optical sync receive
  ///
  /// In en, this message translates to:
  /// **'Scan animated QR stream from another phone camera'**
  String get settingsOpticalReceiveSub;

  /// Settings row title to export a JSON backup
  ///
  /// In en, this message translates to:
  /// **'Export Backup File (JSON)'**
  String get settingsExportTitle;

  /// Settings row subtitle for JSON export
  ///
  /// In en, this message translates to:
  /// **'Export all data to a local JSON file & share sheet'**
  String get settingsExportSub;

  /// Settings row title to import a JSON backup
  ///
  /// In en, this message translates to:
  /// **'Import Backup File (JSON)'**
  String get settingsImportTitle;

  /// Settings row subtitle for JSON import
  ///
  /// In en, this message translates to:
  /// **'Restore counters and history from a backup file'**
  String get settingsImportSub;

  /// Snackbar shown after a backup file is imported successfully
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully!'**
  String get dataRestoredSuccess;

  /// App bar title on the optical sync transmit screen
  ///
  /// In en, this message translates to:
  /// **'Optical Sync Stream (Send)'**
  String get opticalSendTitle;

  /// App bar title on the optical sync receive screen
  ///
  /// In en, this message translates to:
  /// **'Optical Sync Receiver (Scan)'**
  String get opticalReceiveTitle;

  /// Empty state shown when no QR frames could be generated
  ///
  /// In en, this message translates to:
  /// **'No data frames generated.'**
  String get opticalNoFrames;

  /// Label showing the optical sync session identifier
  ///
  /// In en, this message translates to:
  /// **'SESSION ID: {id}'**
  String opticalSessionId(String id);

  /// Label showing the number of the QR frame now on screen (the stream has no end)
  ///
  /// In en, this message translates to:
  /// **'Frame {current}'**
  String opticalFrameCounter(int current);

  /// Optical Sync receiver line showing how many different QR frames have been read so far
  ///
  /// In en, this message translates to:
  /// **'Frames received: {count}'**
  String opticalFramesReceived(int count);

  /// Label for a systematic (original) data frame
  ///
  /// In en, this message translates to:
  /// **'Systematic Data Chunk #{index}'**
  String opticalSystematicChunk(int index);

  /// Label for a fountain-code parity frame
  ///
  /// In en, this message translates to:
  /// **'Fountain Parity Frame #{index}'**
  String opticalParityFrame(int index);

  /// Label for the QR stream frames-per-second slider
  ///
  /// In en, this message translates to:
  /// **'Stream Rate (FPS)'**
  String get opticalStreamRate;

  /// Instruction text on the optical sync transmit screen
  ///
  /// In en, this message translates to:
  /// **'Point the receiving device\'s camera at this screen. The animated QR stream will transmit all counters and session history 100% offline.'**
  String get opticalSendHint;

  /// Progress text while rebuilding data from scanned QR frames
  ///
  /// In en, this message translates to:
  /// **'Reconstructing: {done} / {total} chunks'**
  String opticalReconstructing(int done, int total);

  /// Hint shown while the receiver is waiting to detect QR frames
  ///
  /// In en, this message translates to:
  /// **'Align camera with animated QR stream...'**
  String get opticalAlignCamera;

  /// Title of the sheet shown when a QR stream has been fully received
  ///
  /// In en, this message translates to:
  /// **'Optical Sync Stream Complete'**
  String get opticalStreamComplete;

  /// Stat label for the number of counters received
  ///
  /// In en, this message translates to:
  /// **'Counters'**
  String get opticalStatCounters;

  /// Stat label for the number of session logs received
  ///
  /// In en, this message translates to:
  /// **'Session Logs'**
  String get opticalStatSessionLogs;

  /// Button that imports the received optical sync data
  ///
  /// In en, this message translates to:
  /// **'Import & Restore Data'**
  String get opticalImportRestore;

  /// Snackbar shown after optical sync data is imported
  ///
  /// In en, this message translates to:
  /// **'Optical sync import successful! Data restored.'**
  String get opticalImportSuccess;

  /// Snackbar shown when optical sync import fails
  ///
  /// In en, this message translates to:
  /// **'Failed to import data.'**
  String get opticalImportFailed;

  /// Features screen category name: japa and mala counting
  ///
  /// In en, this message translates to:
  /// **'Sacred Japa & Mala Counting'**
  String get featCat1Name;

  /// Features screen category subtitle: japa and mala counting
  ///
  /// In en, this message translates to:
  /// **'Distraction-free chanting, 108 mala mathematics, and fluid gestures'**
  String get featCat1Sub;

  /// Features screen category name: optical sync and data safety
  ///
  /// In en, this message translates to:
  /// **'Optical Air-Gap Sync & Data Safety'**
  String get featCat2Name;

  /// Features screen category subtitle: optical sync and data safety
  ///
  /// In en, this message translates to:
  /// **'100% offline device-to-device synchronization via camera & QR streaming'**
  String get featCat2Sub;

  /// Features screen category name: practice insights and history
  ///
  /// In en, this message translates to:
  /// **'Practice Insights & History'**
  String get featCat3Name;

  /// Features screen category subtitle: practice insights and history
  ///
  /// In en, this message translates to:
  /// **'Comprehensive daily logs, streak counters, and per-counter breakdowns'**
  String get featCat3Sub;

  /// Features screen category name: aesthetics, audio and haptics
  ///
  /// In en, this message translates to:
  /// **'Temple Aesthetics, Audio & Haptics'**
  String get featCat4Name;

  /// Features screen category subtitle: aesthetics, audio and haptics
  ///
  /// In en, this message translates to:
  /// **'Peaceful devotional palette, resonant bell tones, and Malayalam support'**
  String get featCat4Sub;

  /// Features screen category name: privacy and offline-first core
  ///
  /// In en, this message translates to:
  /// **'Privacy & Offline-First Core'**
  String get featCat5Name;

  /// Features screen category subtitle: privacy and offline-first core
  ///
  /// In en, this message translates to:
  /// **'Zero cloud tracking, zero network requests, and absolute data privacy'**
  String get featCat5Sub;

  /// Features screen feature title: 108 Mala Beads Calculation
  ///
  /// In en, this message translates to:
  /// **'108 Mala Beads Calculation'**
  String get featMalaTitle;

  /// Features screen feature description: 108 Mala Beads Calculation
  ///
  /// In en, this message translates to:
  /// **'Automatically calculates completed malas (1 mala = 108 chants) and keeps track of excess counts and progress rings.'**
  String get featMalaDesc;

  /// Features screen highlight 1 for: 108 Mala Beads Calculation
  ///
  /// In en, this message translates to:
  /// **'108 beads formula'**
  String get featMalaH1;

  /// Features screen highlight 2 for: 108 Mala Beads Calculation
  ///
  /// In en, this message translates to:
  /// **'Excess counts counter'**
  String get featMalaH2;

  /// Features screen highlight 3 for: 108 Mala Beads Calculation
  ///
  /// In en, this message translates to:
  /// **'Mala completion chime'**
  String get featMalaH3;

  /// Features screen feature title: Full-Screen Immersion & Tap Area
  ///
  /// In en, this message translates to:
  /// **'Full-Screen Immersion & Tap Area'**
  String get featImmersionTitle;

  /// Features screen feature description: Full-Screen Immersion & Tap Area
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere on the large sacred ring to increment your count effortlessly without needing to look at specific buttons.'**
  String get featImmersionDesc;

  /// Features screen highlight 1 for: Full-Screen Immersion & Tap Area
  ///
  /// In en, this message translates to:
  /// **'Large touch zone'**
  String get featImmersionH1;

  /// Features screen highlight 2 for: Full-Screen Immersion & Tap Area
  ///
  /// In en, this message translates to:
  /// **'Subtle haptic pulse'**
  String get featImmersionH2;

  /// Features screen highlight 3 for: Full-Screen Immersion & Tap Area
  ///
  /// In en, this message translates to:
  /// **'Distraction-free focus'**
  String get featImmersionH3;

  /// Features screen feature title: Two-Finger Swipe Undo
  ///
  /// In en, this message translates to:
  /// **'Two-Finger Swipe Undo'**
  String get featUndoTitle;

  /// Features screen feature description: Two-Finger Swipe Undo
  ///
  /// In en, this message translates to:
  /// **'Made an accidental count? Simply swipe left or right with two fingers on the ring to decrement the count cleanly.'**
  String get featUndoDesc;

  /// Features screen highlight 1 for: Two-Finger Swipe Undo
  ///
  /// In en, this message translates to:
  /// **'Horizontal swipe gesture'**
  String get featUndoH1;

  /// Features screen highlight 2 for: Two-Finger Swipe Undo
  ///
  /// In en, this message translates to:
  /// **'Instant count reversal'**
  String get featUndoH2;

  /// Features screen highlight 3 for: Two-Finger Swipe Undo
  ///
  /// In en, this message translates to:
  /// **'Prevents over-counting'**
  String get featUndoH3;

  /// Features screen feature title: Persistent Session Timer & Goals
  ///
  /// In en, this message translates to:
  /// **'Persistent Session Timer & Goals'**
  String get featTimerTitle;

  /// Features screen feature description: Persistent Session Timer & Goals
  ///
  /// In en, this message translates to:
  /// **'Tracks active sitting duration with automatic background pause. Configure daily goals and lifetime dedication targets per mantra.'**
  String get featTimerDesc;

  /// Features screen highlight 1 for: Persistent Session Timer & Goals
  ///
  /// In en, this message translates to:
  /// **'Active duration timer'**
  String get featTimerH1;

  /// Features screen highlight 2 for: Persistent Session Timer & Goals
  ///
  /// In en, this message translates to:
  /// **'Per-mantra daily goals'**
  String get featTimerH2;

  /// Features screen highlight 3 for: Persistent Session Timer & Goals
  ///
  /// In en, this message translates to:
  /// **'Lifetime dedication target'**
  String get featTimerH3;

  /// Features screen feature title: High-Density Animated QR Stream
  ///
  /// In en, this message translates to:
  /// **'High-Density Animated QR Stream'**
  String get featQrStreamTitle;

  /// Features screen feature description: High-Density Animated QR Stream
  ///
  /// In en, this message translates to:
  /// **'Transfer complete practice records, counters, and history between phones in seconds using a high-speed optical QR code stream.'**
  String get featQrStreamDesc;

  /// Features screen highlight 1 for: High-Density Animated QR Stream
  ///
  /// In en, this message translates to:
  /// **'Zero Wi-Fi / Bluetooth'**
  String get featQrStreamH1;

  /// Features screen highlight 2 for: High-Density Animated QR Stream
  ///
  /// In en, this message translates to:
  /// **'10-15 FPS animated stream'**
  String get featQrStreamH2;

  /// Features screen highlight 3 for: High-Density Animated QR Stream
  ///
  /// In en, this message translates to:
  /// **'Instant phone transfer'**
  String get featQrStreamH3;

  /// Features screen feature title: Luby Transform Fountain Code Recovery
  ///
  /// In en, this message translates to:
  /// **'Luby Transform Fountain Code Recovery'**
  String get featFountainTitle;

  /// Features screen feature description: Luby Transform Fountain Code Recovery
  ///
  /// In en, this message translates to:
  /// **'Transfers data using mathematical fountain codes and CRC32 verification so dropped camera frames are recovered automatically.'**
  String get featFountainDesc;

  /// Features screen highlight 1 for: Luby Transform Fountain Code Recovery
  ///
  /// In en, this message translates to:
  /// **'Loss-tolerant recovery'**
  String get featFountainH1;

  /// Features screen highlight 2 for: Luby Transform Fountain Code Recovery
  ///
  /// In en, this message translates to:
  /// **'CRC32 checksums'**
  String get featFountainH2;

  /// Features screen highlight 3 for: Luby Transform Fountain Code Recovery
  ///
  /// In en, this message translates to:
  /// **'Out-of-order frame assembly'**
  String get featFountainH3;

  /// Features screen feature title: Offline JSON Export & Restore
  ///
  /// In en, this message translates to:
  /// **'Offline JSON Export & Restore'**
  String get featJsonExportTitle;

  /// Features screen feature description: Offline JSON Export & Restore
  ///
  /// In en, this message translates to:
  /// **'Export full database backups to a plain JSON file to save on your local storage, share sheet, or restore anytime.'**
  String get featJsonExportDesc;

  /// Features screen highlight 1 for: Offline JSON Export & Restore
  ///
  /// In en, this message translates to:
  /// **'Standard JSON schema'**
  String get featJsonExportH1;

  /// Features screen highlight 2 for: Offline JSON Export & Restore
  ///
  /// In en, this message translates to:
  /// **'One-tap export/import'**
  String get featJsonExportH2;

  /// Features screen highlight 3 for: Offline JSON Export & Restore
  ///
  /// In en, this message translates to:
  /// **'Room/Gson compatibility'**
  String get featJsonExportH3;

  /// Features screen feature title: Daily Practice Log & Breakdown
  ///
  /// In en, this message translates to:
  /// **'Daily Practice Log & Breakdown'**
  String get featDailyLogTitle;

  /// Features screen feature description: Daily Practice Log & Breakdown
  ///
  /// In en, this message translates to:
  /// **'Review historical sittings grouped by date with start timestamps, sitting duration, counts chanted, and malas completed.'**
  String get featDailyLogDesc;

  /// Features screen highlight 1 for: Daily Practice Log & Breakdown
  ///
  /// In en, this message translates to:
  /// **'Date-wise grouping'**
  String get featDailyLogH1;

  /// Features screen highlight 2 for: Daily Practice Log & Breakdown
  ///
  /// In en, this message translates to:
  /// **'Sitting duration breakdown'**
  String get featDailyLogH2;

  /// Features screen highlight 3 for: Daily Practice Log & Breakdown
  ///
  /// In en, this message translates to:
  /// **'Daily mala tally'**
  String get featDailyLogH3;

  /// Features screen feature title: Per-Counter Filtering
  ///
  /// In en, this message translates to:
  /// **'Per-Counter Filtering'**
  String get featFilterTitle;

  /// Features screen feature description: Per-Counter Filtering
  ///
  /// In en, this message translates to:
  /// **'Isolate and view history for individual mantras or view the combined sadhana across all active counters.'**
  String get featFilterDesc;

  /// Features screen highlight 1 for: Per-Counter Filtering
  ///
  /// In en, this message translates to:
  /// **'Specific mantra view'**
  String get featFilterH1;

  /// Features screen highlight 2 for: Per-Counter Filtering
  ///
  /// In en, this message translates to:
  /// **'Combined daily view'**
  String get featFilterH2;

  /// Features screen highlight 3 for: Per-Counter Filtering
  ///
  /// In en, this message translates to:
  /// **'Lifetime totals'**
  String get featFilterH3;

  /// Features screen feature title: Temple Devotional Palette
  ///
  /// In en, this message translates to:
  /// **'Temple Devotional Palette'**
  String get featPaletteTitle;

  /// Features screen feature description: Temple Devotional Palette
  ///
  /// In en, this message translates to:
  /// **'Authentic temple palette with sacred cream backgrounds and vermillion, sandal yellow, tulsi green, and rose accents.'**
  String get featPaletteDesc;

  /// Features screen highlight 1 for: Temple Devotional Palette
  ///
  /// In en, this message translates to:
  /// **'Cream & gold background'**
  String get featPaletteH1;

  /// Features screen highlight 2 for: Temple Devotional Palette
  ///
  /// In en, this message translates to:
  /// **'Vermillion & Tulsi accents'**
  String get featPaletteH2;

  /// Features screen highlight 3 for: Temple Devotional Palette
  ///
  /// In en, this message translates to:
  /// **'Serif numeral typography'**
  String get featPaletteH3;

  /// Features screen feature title: Peaceful Bell Tones & Audio Picker
  ///
  /// In en, this message translates to:
  /// **'Peaceful Bell Tones & Audio Picker'**
  String get featBellTitle;

  /// Features screen feature description: Peaceful Bell Tones & Audio Picker
  ///
  /// In en, this message translates to:
  /// **'Gentle meditation chimes when completing malas or reaching daily goals. Choose system ringtones or pick custom local audio files.'**
  String get featBellDesc;

  /// Features screen highlight 1 for: Peaceful Bell Tones & Audio Picker
  ///
  /// In en, this message translates to:
  /// **'Mala & goal bell tones'**
  String get featBellH1;

  /// Features screen highlight 2 for: Peaceful Bell Tones & Audio Picker
  ///
  /// In en, this message translates to:
  /// **'Custom audio picker'**
  String get featBellH2;

  /// Features screen highlight 3 for: Peaceful Bell Tones & Audio Picker
  ///
  /// In en, this message translates to:
  /// **'Tone preview in settings'**
  String get featBellH3;

  /// Features screen feature title: Stillness Brightness Mode
  ///
  /// In en, this message translates to:
  /// **'Stillness Brightness Mode'**
  String get featBrightnessTitle;

  /// Features screen feature description: Stillness Brightness Mode
  ///
  /// In en, this message translates to:
  /// **'Dim screen brightness to minimal ambient levels for distraction-free early morning, temple, or late-night meditation.'**
  String get featBrightnessDesc;

  /// Features screen highlight 1 for: Stillness Brightness Mode
  ///
  /// In en, this message translates to:
  /// **'Custom brightness slider'**
  String get featBrightnessH1;

  /// Features screen highlight 2 for: Stillness Brightness Mode
  ///
  /// In en, this message translates to:
  /// **'1-tap system restore'**
  String get featBrightnessH2;

  /// Features screen highlight 3 for: Stillness Brightness Mode
  ///
  /// In en, this message translates to:
  /// **'OLED battery efficiency'**
  String get featBrightnessH3;

  /// Features screen feature title: Bilingual Malayalam & English UI
  ///
  /// In en, this message translates to:
  /// **'Bilingual Malayalam & English UI'**
  String get featBilingualTitle;

  /// Features screen feature description: Bilingual Malayalam & English UI
  ///
  /// In en, this message translates to:
  /// **'Full Malayalam scripture and interface support alongside English with bundled Noto Sans Malayalam fonts.'**
  String get featBilingualDesc;

  /// Features screen highlight 1 for: Bilingual Malayalam & English UI
  ///
  /// In en, this message translates to:
  /// **'Full Malayalam localization'**
  String get featBilingualH1;

  /// Features screen highlight 2 for: Bilingual Malayalam & English UI
  ///
  /// In en, this message translates to:
  /// **'Authentic Indic font glyphs'**
  String get featBilingualH2;

  /// Features screen highlight 3 for: Bilingual Malayalam & English UI
  ///
  /// In en, this message translates to:
  /// **'1-tap language switch'**
  String get featBilingualH3;

  /// Features screen feature title: 100% Offline with Zero INTERNET Permission
  ///
  /// In en, this message translates to:
  /// **'100% Offline with Zero INTERNET Permission'**
  String get featOfflineTitle;

  /// Features screen feature description: 100% Offline with Zero INTERNET Permission
  ///
  /// In en, this message translates to:
  /// **'The application manifest completely lacks internet permissions. No telemetry, ads, or analytics can ever run.'**
  String get featOfflineDesc;

  /// Features screen highlight 1 for: 100% Offline with Zero INTERNET Permission
  ///
  /// In en, this message translates to:
  /// **'No INTERNET permission'**
  String get featOfflineH1;

  /// Features screen highlight 2 for: 100% Offline with Zero INTERNET Permission
  ///
  /// In en, this message translates to:
  /// **'Zero cloud telemetry'**
  String get featOfflineH2;

  /// Features screen highlight 3 for: 100% Offline with Zero INTERNET Permission
  ///
  /// In en, this message translates to:
  /// **'No tracking or ads'**
  String get featOfflineH3;

  /// Features screen feature title: Local SQLite Database & Crash Recovery
  ///
  /// In en, this message translates to:
  /// **'Local SQLite Database & Crash Recovery'**
  String get featSqliteTitle;

  /// Features screen feature description: Local SQLite Database & Crash Recovery
  ///
  /// In en, this message translates to:
  /// **'Dual-layer persistence saves active counts every 5 taps/5 seconds to prevent accidental data loss during phone reboots.'**
  String get featSqliteDesc;

  /// Features screen highlight 1 for: Local SQLite Database & Crash Recovery
  ///
  /// In en, this message translates to:
  /// **'ACID-compliant SQLite v3'**
  String get featSqliteH1;

  /// Features screen highlight 2 for: Local SQLite Database & Crash Recovery
  ///
  /// In en, this message translates to:
  /// **'5-tap crash recovery'**
  String get featSqliteH2;

  /// Features screen highlight 3 for: Local SQLite Database & Crash Recovery
  ///
  /// In en, this message translates to:
  /// **'Safe data migrations'**
  String get featSqliteH3;

  /// Subtitle of the sheet shown when a QR stream has been fully received
  ///
  /// In en, this message translates to:
  /// **'100% offline payload reconstructed via camera scanner.'**
  String get opticalStreamCompleteSub;

  /// Title of the counter selection sheet
  ///
  /// In en, this message translates to:
  /// **'Select Counters'**
  String get selectCountersTitle;

  /// Subtitle of the counter selection sheet
  ///
  /// In en, this message translates to:
  /// **'Choose which counters to include'**
  String get selectCountersSub;

  /// Label for select all action
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// Label for deselect all action
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// Count badge showing number of selected counters
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCountersCount(int count);

  /// Label for continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Warning shown when no counters are selected
  ///
  /// In en, this message translates to:
  /// **'Please select at least one counter'**
  String get noCountersSelected;

  /// Toggle label and dialog title for encrypting a backup export
  ///
  /// In en, this message translates to:
  /// **'Encrypt Backup'**
  String get encryptBackup;

  /// Subtitle explaining the encryption option
  ///
  /// In en, this message translates to:
  /// **'Protect with a passphrase (AES-256-GCM)'**
  String get encryptBackupSub;

  /// Text field label for passphrase entry
  ///
  /// In en, this message translates to:
  /// **'Enter passphrase'**
  String get enterPassphrase;

  /// Text field label for confirming the passphrase
  ///
  /// In en, this message translates to:
  /// **'Confirm passphrase'**
  String get confirmPassphrase;

  /// Error message when two passphrase entries do not match
  ///
  /// In en, this message translates to:
  /// **'Passphrases do not match'**
  String get passphraseMismatch;

  /// Error message when the passphrase is too short
  ///
  /// In en, this message translates to:
  /// **'Passphrase must be at least 6 characters'**
  String get passphraseTooShort;

  /// Button and dialog title for decrypting an encrypted backup
  ///
  /// In en, this message translates to:
  /// **'Decrypt & Import'**
  String get decryptBackup;

  /// Explanation shown in the decrypt passphrase dialog
  ///
  /// In en, this message translates to:
  /// **'This backup is encrypted. Enter the passphrase to decrypt.'**
  String get decryptPassphrasePrompt;

  /// Error message when decryption fails
  ///
  /// In en, this message translates to:
  /// **'Decryption failed. Wrong passphrase or corrupted file.'**
  String get decryptFailed;

  /// Button to skip encryption and export as plain JSON
  ///
  /// In en, this message translates to:
  /// **'Skip (export unencrypted)'**
  String get skipEncryption;

  /// Hint text on the counter selection sheet before optical sync transmit
  ///
  /// In en, this message translates to:
  /// **'Select which counters to transmit via optical sync'**
  String get opticalSelectCountersHint;

  /// Hint text on the import preview sheet for selecting counters to import
  ///
  /// In en, this message translates to:
  /// **'Choose which counters to import from the received data'**
  String get opticalImportSelectHint;

  /// Status bar notification title when lifetime goal is reached
  ///
  /// In en, this message translates to:
  /// **'Lifetime Goal Achieved!'**
  String get notifLifetimeGoalTitle;

  /// Status bar notification body when lifetime goal is reached
  ///
  /// In en, this message translates to:
  /// **'Auspicious milestone reached. May your sadhana bring peace and liberation.'**
  String get notifLifetimeGoalBody;

  /// Setting title for lifetime goal completion tone
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal tone'**
  String get lifetimeSoundTitle;

  /// Setting subtitle explaining lifetime goal chime
  ///
  /// In en, this message translates to:
  /// **'Sacred chime played when lifetime target is reached'**
  String get lifetimeSoundSub;

  /// Toggle title for lifetime goal milestone notification
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal notification'**
  String get enableLifetimeNotification;

  /// Toggle subtitle for lifetime goal milestone notification
  ///
  /// In en, this message translates to:
  /// **'Show notification when lifetime milestone is reached'**
  String get enableLifetimeNotificationSub;

  /// Name of the sacred conch shell audio tone
  ///
  /// In en, this message translates to:
  /// **'Sacred Shankha'**
  String get soundSacredShankha;

  /// Description of the sacred conch shell audio tone
  ///
  /// In en, this message translates to:
  /// **'Conch shell resonance sounding spiritual victory'**
  String get soundSacredShankhaSub;

  /// Title of sound settings card
  ///
  /// In en, this message translates to:
  /// **'Sound & Haptics'**
  String get settingsSoundTitle;

  /// Subtitle of sound settings card
  ///
  /// In en, this message translates to:
  /// **'Mala chimes, goal completion tones, and vibration'**
  String get settingsSoundSub;

  /// Title of display settings card
  ///
  /// In en, this message translates to:
  /// **'Display & Stillness'**
  String get settingsDisplayTitle;

  /// Subtitle of display settings card
  ///
  /// In en, this message translates to:
  /// **'Screen brightness and sacred stillness mode'**
  String get settingsDisplaySub;

  /// Title of language settings card
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Subtitle of language settings card
  ///
  /// In en, this message translates to:
  /// **'App language, script, and numbering'**
  String get settingsLanguageSub;

  /// Title of permissions card in settings
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsPermissionsTitle;

  /// Subtitle of permissions card in settings
  ///
  /// In en, this message translates to:
  /// **'What device capabilities the app uses and why'**
  String get settingsPermissionsSub;

  /// Title for data clear action card
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearDataTitle;

  /// Subtitle for data clear action card
  ///
  /// In en, this message translates to:
  /// **'Delete all counters and chanting sessions'**
  String get settingsClearDataSub;

  /// Header for explicit runtime permissions
  ///
  /// In en, this message translates to:
  /// **'Explicit Permissions'**
  String get permissionsExplicitHeader;

  /// Subtitle explaining explicit permissions
  ///
  /// In en, this message translates to:
  /// **'Permissions requested at runtime only when you invoke specific features'**
  String get permissionsExplicitSub;

  /// Header for implicit normal permissions
  ///
  /// In en, this message translates to:
  /// **'Implicit Permissions'**
  String get permissionsImplicitHeader;

  /// Subtitle explaining implicit permissions
  ///
  /// In en, this message translates to:
  /// **'Normal permissions granted automatically by Android to deliver core offline functions'**
  String get permissionsImplicitSub;

  /// Header for excluded permissions highlighting privacy
  ///
  /// In en, this message translates to:
  /// **'Zero-Trust Privacy Guarantee'**
  String get permissionsPrivacyHeader;

  /// Subtitle for privacy section
  ///
  /// In en, this message translates to:
  /// **'Permissions deliberately omitted to safeguard your spiritual practice'**
  String get permissionsPrivacySub;

  /// Title for camera permission
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get permCameraTitle;

  /// Description of camera permission
  ///
  /// In en, this message translates to:
  /// **'Used exclusively to scan animated QR fountain codes when receiving data via air-gapped Optical Sync. Never captures photos or videos.'**
  String get permCameraDesc;

  /// Title for notification permission
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permNotificationTitle;

  /// Description of notification permission
  ///
  /// In en, this message translates to:
  /// **'Used on Android 13+ to show milestone banners in the status bar when daily or lifetime mantra targets are completed.'**
  String get permNotificationDesc;

  /// Title for vibration permission
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get permVibrationTitle;

  /// Description of vibration permission
  ///
  /// In en, this message translates to:
  /// **'Delivers gentle haptic feedback on each chant tap, mala completion, and goal achievement, remaining tactile even in silent mode.'**
  String get permVibrationDesc;

  /// Title for audio settings permission
  ///
  /// In en, this message translates to:
  /// **'Audio Management'**
  String get permAudioTitle;

  /// Description of audio settings permission
  ///
  /// In en, this message translates to:
  /// **'Temporarily routes completion chimes through the alarm audio stream so sacred bells remain audible during meditation.'**
  String get permAudioDesc;

  /// Title explaining absence of internet permission
  ///
  /// In en, this message translates to:
  /// **'Zero Internet Access'**
  String get permNoInternetTitle;

  /// Description explaining absence of internet permission
  ///
  /// In en, this message translates to:
  /// **'The app contains no internet permission. It cannot transmit data, connect to cloud servers, or track analytics.'**
  String get permNoInternetDesc;

  /// Title explaining storage access privacy
  ///
  /// In en, this message translates to:
  /// **'No Broad Storage Access'**
  String get permNoStorageTitle;

  /// Description explaining storage access privacy
  ///
  /// In en, this message translates to:
  /// **'Instead of accessing your personal files, exports and imports use Android\'s native system picker with user consent.'**
  String get permNoStorageDesc;

  /// Title for app tutorial screen
  ///
  /// In en, this message translates to:
  /// **'App Tutorial'**
  String get tutorialTitle;

  /// App tutorial subtitle
  ///
  /// In en, this message translates to:
  /// **'A step-by-step walk through every feature, from your first counter to backup and privacy.'**
  String get tutorialSub;

  /// Tutorial step 1 title
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get tutorialStep1Title;

  /// Tutorial step 1 description
  ///
  /// In en, this message translates to:
  /// **'This app helps you count your mantra japa. It counts malas of 108, keeps daily and lifetime goals, and saves a full history. It works fully offline.'**
  String get tutorialStep1Desc;

  /// Tutorial step 2 title
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get tutorialStep2Title;

  /// Tutorial step 2 description
  ///
  /// In en, this message translates to:
  /// **'Go to Settings → Language. Pick English, Malayalam, Sanskrit, or System default.'**
  String get tutorialStep2Desc;

  /// Tutorial step 3 title
  ///
  /// In en, this message translates to:
  /// **'Create a counter'**
  String get tutorialStep3Title;

  /// Tutorial step 3 description
  ///
  /// In en, this message translates to:
  /// **'Tap the + button at the top of the home screen. Enter the mantra name. Then set the initial count, increment step, lifetime goal, daily goal and start date.'**
  String get tutorialStep3Desc;

  /// Tutorial step 4 title
  ///
  /// In en, this message translates to:
  /// **'Read the counter card'**
  String get tutorialStep4Title;

  /// Tutorial step 4 description
  ///
  /// In en, this message translates to:
  /// **'Each card shows total chants and malas, today\'s chants, a strip of 27 beads for today\'s progress, and a bar for your lifetime goal.'**
  String get tutorialStep4Desc;

  /// Tutorial step 5 title
  ///
  /// In en, this message translates to:
  /// **'Today summary'**
  String get tutorialStep5Title;

  /// Tutorial step 5 description
  ///
  /// In en, this message translates to:
  /// **'The pill at the top of the home screen adds up today\'s chants, malas and the counters you used today.'**
  String get tutorialStep5Desc;

  /// Tutorial step 6 title
  ///
  /// In en, this message translates to:
  /// **'Counter options'**
  String get tutorialStep6Title;

  /// Tutorial step 6 description
  ///
  /// In en, this message translates to:
  /// **'Long-press a card to see Counter info, History, Edit, Lock, Disable (success), Disable (not completed) and Delete.'**
  String get tutorialStep6Desc;

  /// Tutorial step 7 title
  ///
  /// In en, this message translates to:
  /// **'Lock a counter'**
  String get tutorialStep7Title;

  /// Tutorial step 7 description
  ///
  /// In en, this message translates to:
  /// **'Tap the lock icon on a card to lock it. A locked counter cannot be opened for counting. Tap the icon again to unlock.'**
  String get tutorialStep7Desc;

  /// Shown on the Optical Sync receiver when camera permission is denied
  ///
  /// In en, this message translates to:
  /// **'Camera access was denied. To receive data, allow the camera permission for this app in Android Settings.'**
  String get opticalCameraDenied;

  /// Shown on the Optical Sync receiver when the camera fails to start
  ///
  /// In en, this message translates to:
  /// **'The camera could not be started. Close other apps that use the camera and try again.'**
  String get opticalCameraError;

  /// Shown on the Optical Sync receiver when no native QR decoder exists
  ///
  /// In en, this message translates to:
  /// **'The QR scanner is not available on this device.'**
  String get opticalCameraUnavailable;

  /// Tooltip for the button that turns the camera light on in the Optical Sync receiver
  ///
  /// In en, this message translates to:
  /// **'Turn on light'**
  String get opticalTorchOn;

  /// Tooltip for the button that turns the camera light off in the Optical Sync receiver
  ///
  /// In en, this message translates to:
  /// **'Turn off light'**
  String get opticalTorchOff;

  /// Label for the camera zoom slider in the Optical Sync receiver
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get opticalZoom;

  /// Hint shown over the camera in the Optical Sync receiver
  ///
  /// In en, this message translates to:
  /// **'Tap the code to focus. Use zoom if it looks blurred.'**
  String get opticalScanTip;

  /// Title shown inside the mala during the Meru pause
  ///
  /// In en, this message translates to:
  /// **'Pause · Breathe'**
  String get meruPauseTitle;

  /// Gentle line shown during the Meru pause after a full mala
  ///
  /// In en, this message translates to:
  /// **'You have reached the Meru bead. Rest in stillness.'**
  String get meruPauseMessage;

  /// Soft hint shown when the user taps faster than a natural chanting pace
  ///
  /// In en, this message translates to:
  /// **'Slow down, breathe, feel the mantra.'**
  String get pacingHintMessage;

  /// Settings section title for Meru pause and pacing hint
  ///
  /// In en, this message translates to:
  /// **'Mindful counting'**
  String get sectionMindfulCounting;

  /// Settings section subtitle for Meru pause and pacing hint
  ///
  /// In en, this message translates to:
  /// **'Gentle support for unhurried japa'**
  String get sectionMindfulCountingSub;

  /// Settings toggle title for the Meru pause
  ///
  /// In en, this message translates to:
  /// **'Meru pause after each mala'**
  String get meruPauseSettingTitle;

  /// Settings toggle subtitle for the Meru pause
  ///
  /// In en, this message translates to:
  /// **'A short, quiet pause after 108. Taps during the pause are not counted.'**
  String get meruPauseSettingSub;

  /// Short label for a number of seconds, used on Meru pause length chips
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String secondsShort(int seconds);

  /// Settings toggle title for the pacing hint
  ///
  /// In en, this message translates to:
  /// **'Gentle pacing hint'**
  String get pacingHintSettingTitle;

  /// Settings toggle subtitle for the pacing hint
  ///
  /// In en, this message translates to:
  /// **'A soft glow when tapping very fast. Every tap still counts.'**
  String get pacingHintSettingSub;

  /// Help counting guide: Mindful section title
  ///
  /// In en, this message translates to:
  /// **'Mindful counting'**
  String get helpCountingMindfulSection;

  /// Title of the Sadhana Flow calendar heat-map on the History screen
  ///
  /// In en, this message translates to:
  /// **'SADHANA FLOW'**
  String get sadhanaFlowTitle;

  /// Screen reader label for the Sadhana Flow calendar grid
  ///
  /// In en, this message translates to:
  /// **'Calendar of practice days for the last {weeks} weeks'**
  String sadhanaFlowA11y(int weeks);

  /// Uplifting line: number of practice days in the current year
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Every mantra you offer this year will glow here.} =1{1 day of sacred remembrance this year.} other{{count} days of sacred remembrance this year.}}'**
  String sadhanaFlowYearDays(int count);

  /// Warm message when the user returns after a break of a few days
  ///
  /// In en, this message translates to:
  /// **'Welcome back to your sacred space. Every mantra offered is eternal.'**
  String get sadhanaFlowWelcomeBack;

  /// Legend label for the dimmest cells of the Sadhana Flow grid
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get sadhanaFlowLess;

  /// Legend label for the brightest cells of the Sadhana Flow grid
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get sadhanaFlowMore;

  /// Label for the brightness slider on the Optical Sync send screen
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get opticalBrightness;

  /// Brightness slider value when at the normal brightness
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get opticalBrightnessNormal;

  /// Brightness slider value: how much brighter than normal, in percent
  ///
  /// In en, this message translates to:
  /// **'+{percent}%'**
  String opticalBrightnessBoost(int percent);

  /// Help hub category: counters and history
  ///
  /// In en, this message translates to:
  /// **'Your Counters & History'**
  String get helpCategoryCounters;

  /// Help topic title: counters and home screen
  ///
  /// In en, this message translates to:
  /// **'Counters & Home Screen'**
  String get helpTopicCountersTitle;

  /// Help topic subtitle: counters and home screen
  ///
  /// In en, this message translates to:
  /// **'Create, edit, lock, disable and delete counters, and read the cards'**
  String get helpTopicCountersSub;

  /// Help topic title: history and statistics
  ///
  /// In en, this message translates to:
  /// **'History & Statistics'**
  String get helpTopicHistoryTitle;

  /// Help topic subtitle: history and statistics
  ///
  /// In en, this message translates to:
  /// **'Day-by-day history, the Sadhana Flow calendar and counter details'**
  String get helpTopicHistorySub;

  /// Help topic title: display, stillness and language
  ///
  /// In en, this message translates to:
  /// **'Display, Stillness & Language'**
  String get helpTopicDisplayTitle;

  /// Help topic subtitle: display, stillness and language
  ///
  /// In en, this message translates to:
  /// **'Brightness, dimmed mode, Do Not Disturb, Meru pause, language and appearance'**
  String get helpTopicDisplaySub;

  /// Tutorial chapter 1 heading
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get tutorialChapter1;

  /// Tutorial chapter 2 heading
  ///
  /// In en, this message translates to:
  /// **'Your counters'**
  String get tutorialChapter2;

  /// Tutorial chapter 3 heading
  ///
  /// In en, this message translates to:
  /// **'Counting'**
  String get tutorialChapter3;

  /// Tutorial chapter 4 heading
  ///
  /// In en, this message translates to:
  /// **'Malas and goals'**
  String get tutorialChapter4;

  /// Tutorial chapter 5 heading
  ///
  /// In en, this message translates to:
  /// **'History and statistics'**
  String get tutorialChapter5;

  /// Tutorial chapter 6 heading
  ///
  /// In en, this message translates to:
  /// **'Sound, vibration and display'**
  String get tutorialChapter6;

  /// Tutorial chapter 7 heading
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get tutorialChapter7;

  /// Tutorial chapter 8 heading
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get tutorialChapter8;

  /// Tutorial step 1 tip
  ///
  /// In en, this message translates to:
  /// **'Open this guide any time from Settings → Help & User Guides.'**
  String get tutorialStep1Tip;

  /// Tutorial step 2 tip
  ///
  /// In en, this message translates to:
  /// **'Mantra names can be typed in any script, whatever app language you choose.'**
  String get tutorialStep2Tip;

  /// Tutorial step 3 tip
  ///
  /// In en, this message translates to:
  /// **'Use 0 for no goal. The daily goal cannot be more than the lifetime goal, and the step must be less than the daily goal.'**
  String get tutorialStep3Tip;

  /// Tutorial step 4 tip
  ///
  /// In en, this message translates to:
  /// **'A green tick means today\'s goal is done. A gold trophy means the lifetime goal is reached.'**
  String get tutorialStep4Tip;

  /// Tutorial step 5 tip
  ///
  /// In en, this message translates to:
  /// **'These totals start again from 0 each day at midnight, by your phone\'s clock.'**
  String get tutorialStep5Tip;

  /// Tutorial step 6 tip
  ///
  /// In en, this message translates to:
  /// **'Delete removes the counter and all its history. It cannot be undone.'**
  String get tutorialStep6Tip;

  /// Tutorial step 7 tip
  ///
  /// In en, this message translates to:
  /// **'Lock a finished or rarely used counter, so its count is never changed by mistake.'**
  String get tutorialStep7Tip;

  /// Tutorial step 8 title
  ///
  /// In en, this message translates to:
  /// **'Open the counting screen'**
  String get tutorialStep8Title;

  /// Tutorial step 8 description
  ///
  /// In en, this message translates to:
  /// **'Tap a counter card. The counting screen opens with a large mala circle.'**
  String get tutorialStep8Desc;

  /// Tutorial step 8 tip
  ///
  /// In en, this message translates to:
  /// **'If Do Not Disturb is turned on in settings, the phone stays quiet while this screen is open.'**
  String get tutorialStep8Tip;

  /// Tutorial step 9 title
  ///
  /// In en, this message translates to:
  /// **'Tap to count'**
  String get tutorialStep9Title;

  /// Tutorial step 9 description
  ///
  /// In en, this message translates to:
  /// **'Tap inside the mala circle. Each tap adds the increment step (1 by default). Taps outside the circle are ignored.'**
  String get tutorialStep9Desc;

  /// Tutorial step 9 tip
  ///
  /// In en, this message translates to:
  /// **'You can chant with your eyes closed. The circle is large, and a sound and vibration mark each full mala.'**
  String get tutorialStep9Tip;

  /// Tutorial step 10 title
  ///
  /// In en, this message translates to:
  /// **'Undo a count'**
  String get tutorialStep10Title;

  /// Tutorial step 10 description
  ///
  /// In en, this message translates to:
  /// **'Put two fingers on the circle and slide them left or right. One swipe removes one step.'**
  String get tutorialStep10Desc;

  /// Tutorial step 10 tip
  ///
  /// In en, this message translates to:
  /// **'The phone vibrates once to confirm the undo.'**
  String get tutorialStep10Tip;

  /// Tutorial step 11 title
  ///
  /// In en, this message translates to:
  /// **'Read the screen'**
  String get tutorialStep11Title;

  /// Tutorial step 11 description
  ///
  /// In en, this message translates to:
  /// **'The top pill shows the time of this sitting. The centre shows your bead in the current mala, the beads left, and the malas done. The bottom row shows Session, Daily and Lifetime counts.'**
  String get tutorialStep11Desc;

  /// Tutorial step 11 tip
  ///
  /// In en, this message translates to:
  /// **'The lamp icon at the top changes colour when a goal is reached.'**
  String get tutorialStep11Tip;

  /// Tutorial step 12 title
  ///
  /// In en, this message translates to:
  /// **'Leave and come back'**
  String get tutorialStep12Title;

  /// Tutorial step 12 description
  ///
  /// In en, this message translates to:
  /// **'Press back at any time. Your counts are saved quietly. The timer pauses while the app is in the background. An unfinished mala waits for you, even on another day.'**
  String get tutorialStep12Desc;

  /// Tutorial step 12 tip
  ///
  /// In en, this message translates to:
  /// **'Tap Start new on the banner to keep the old counts and begin a new mala at 0.'**
  String get tutorialStep12Tip;

  /// Tutorial step 13 title
  ///
  /// In en, this message translates to:
  /// **'The counting menu'**
  String get tutorialStep13Title;

  /// Tutorial step 13 description
  ///
  /// In en, this message translates to:
  /// **'The ⋮ menu has History, About, Settings, Finish & start new, Reset session and Reset counter.'**
  String get tutorialStep13Desc;

  /// Tutorial step 13 tip
  ///
  /// In en, this message translates to:
  /// **'Reset session clears only this sitting. Reset counter deletes all history of the counter.'**
  String get tutorialStep13Tip;

  /// Tutorial step 14 title
  ///
  /// In en, this message translates to:
  /// **'108 beads = 1 mala'**
  String get tutorialStep14Title;

  /// Tutorial step 14 description
  ///
  /// In en, this message translates to:
  /// **'Every 108 counts make one mala. The circle fills bead by bead and starts again after 108.'**
  String get tutorialStep14Desc;

  /// Tutorial step 14 tip
  ///
  /// In en, this message translates to:
  /// **'115 counts = 1 mala and 7 counts. Extra counts are never lost.'**
  String get tutorialStep14Tip;

  /// Tutorial step 15 title
  ///
  /// In en, this message translates to:
  /// **'Reach your goals'**
  String get tutorialStep15Title;

  /// Tutorial step 15 description
  ///
  /// In en, this message translates to:
  /// **'When you reach the daily goal, a tone plays, the phone vibrates and a notification appears. The lifetime goal has its own tone, notification and a gold trophy.'**
  String get tutorialStep15Desc;

  /// Tutorial step 15 tip
  ///
  /// In en, this message translates to:
  /// **'Turn these on or off in Settings → Sound & Haptics.'**
  String get tutorialStep15Tip;

  /// Tutorial step 16 title
  ///
  /// In en, this message translates to:
  /// **'Meru pause'**
  String get tutorialStep16Title;

  /// Tutorial step 16 description
  ///
  /// In en, this message translates to:
  /// **'Turn it on in Settings → Display & Stillness. After each mala the app pauses for 3, 5 or 10 seconds, so you can rest and breathe.'**
  String get tutorialStep16Desc;

  /// Tutorial step 16 tip
  ///
  /// In en, this message translates to:
  /// **'Taps during the pause are not counted, just as the Meru bead is never crossed.'**
  String get tutorialStep16Tip;

  /// Tutorial step 17 title
  ///
  /// In en, this message translates to:
  /// **'Gentle pacing hint'**
  String get tutorialStep17Title;

  /// Tutorial step 17 description
  ///
  /// In en, this message translates to:
  /// **'If you tap faster than about 3 times a second, the circle glows amber and a short reminder appears.'**
  String get tutorialStep17Desc;

  /// Tutorial step 17 tip
  ///
  /// In en, this message translates to:
  /// **'Every tap still counts. You can turn the hint off in Settings → Display & Stillness.'**
  String get tutorialStep17Tip;

  /// Tutorial step 18 title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tutorialStep18Title;

  /// Tutorial step 18 description
  ///
  /// In en, this message translates to:
  /// **'Open History from the counting menu or the long-press menu. Sittings are grouped by day, with time, length, count and malas.'**
  String get tutorialStep18Desc;

  /// Tutorial step 18 tip
  ///
  /// In en, this message translates to:
  /// **'Tap the delete icon on a sitting to remove it. Totals update at once.'**
  String get tutorialStep18Tip;

  /// Tutorial step 19 title
  ///
  /// In en, this message translates to:
  /// **'Sadhana Flow'**
  String get tutorialStep19Title;

  /// Tutorial step 19 description
  ///
  /// In en, this message translates to:
  /// **'The calendar in History shows the last 16 weeks. Days with practice glow like a lamp. A brighter glow means more chanting.'**
  String get tutorialStep19Desc;

  /// Tutorial step 19 tip
  ///
  /// In en, this message translates to:
  /// **'There are no streaks and no missed-day marks. Every day you return is welcome.'**
  String get tutorialStep19Tip;

  /// Tutorial step 20 title
  ///
  /// In en, this message translates to:
  /// **'Counter statistics'**
  String get tutorialStep20Title;

  /// Tutorial step 20 description
  ///
  /// In en, this message translates to:
  /// **'Choose Counter info (long-press menu) or About (counting menu) to see progress rings and all details of the counter.'**
  String get tutorialStep20Desc;

  /// Tutorial step 20 tip
  ///
  /// In en, this message translates to:
  /// **'The average chants per day is worked out from the start date you set.'**
  String get tutorialStep20Tip;

  /// Tutorial step 21 title
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get tutorialStep21Title;

  /// Tutorial step 21 description
  ///
  /// In en, this message translates to:
  /// **'In Settings → Sound & Haptics choose the mala sound, the daily goal tone and the lifetime goal tone. Pick a built-in sound, a phone ringtone, or your own audio file.'**
  String get tutorialStep21Desc;

  /// Tutorial step 21 tip
  ///
  /// In en, this message translates to:
  /// **'Tap Preview to hear the tone before you chant.'**
  String get tutorialStep21Tip;

  /// Tutorial step 22 title
  ///
  /// In en, this message translates to:
  /// **'Vibration and notifications'**
  String get tutorialStep22Title;

  /// Tutorial step 22 description
  ///
  /// In en, this message translates to:
  /// **'Vibration marks each mala, each goal and each undo. Goal notifications appear in the status bar.'**
  String get tutorialStep22Desc;

  /// Tutorial step 22 tip
  ///
  /// In en, this message translates to:
  /// **'Sounds play through the alarm channel, so you hear them even when the phone is on silent.'**
  String get tutorialStep22Tip;

  /// Tutorial step 23 title
  ///
  /// In en, this message translates to:
  /// **'Display and stillness'**
  String get tutorialStep23Title;

  /// Tutorial step 23 description
  ///
  /// In en, this message translates to:
  /// **'In Settings → Display & Stillness set the brightness, turn on Dimmed chanting mode, or silence calls and alerts with Do Not Disturb.'**
  String get tutorialStep23Desc;

  /// Tutorial step 23 tip
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb needs a one-time permission. It is turned off again when you leave the counting screen.'**
  String get tutorialStep23Tip;

  /// Tutorial step 24 title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get tutorialStep24Title;

  /// Tutorial step 24 description
  ///
  /// In en, this message translates to:
  /// **'Settings → Appearance shows the temple colours and fonts used in the app.'**
  String get tutorialStep24Desc;

  /// Tutorial step 24 tip
  ///
  /// In en, this message translates to:
  /// **'The app always stays upright (portrait), so you can count with one hand.'**
  String get tutorialStep24Tip;

  /// Tutorial step 25 title
  ///
  /// In en, this message translates to:
  /// **'Back up to a file'**
  String get tutorialStep25Title;

  /// Tutorial step 25 description
  ///
  /// In en, this message translates to:
  /// **'Use Settings → Data Backup & Optical Sync → Export, or Import / Export in the home menu. All counters and history are saved to one file, and the share sheet opens.'**
  String get tutorialStep25Desc;

  /// Tutorial step 25 tip
  ///
  /// In en, this message translates to:
  /// **'You can lock the file with a passphrase (AES-256-GCM). A lost passphrase cannot be recovered.'**
  String get tutorialStep25Tip;

  /// Tutorial step 26 title
  ///
  /// In en, this message translates to:
  /// **'Restore from a file'**
  String get tutorialStep26Title;

  /// Tutorial step 26 description
  ///
  /// In en, this message translates to:
  /// **'Choose Import and pick your backup file. Enter the passphrase if the file is encrypted.'**
  String get tutorialStep26Desc;

  /// Tutorial step 26 tip
  ///
  /// In en, this message translates to:
  /// **'Import replaces ALL current data on this phone. Export first if you want to keep it.'**
  String get tutorialStep26Tip;

  /// Tutorial step 27 title
  ///
  /// In en, this message translates to:
  /// **'Phone-to-phone sync'**
  String get tutorialStep27Title;

  /// Tutorial step 27 description
  ///
  /// In en, this message translates to:
  /// **'On the old phone choose Optical Sync (Send) and pick the counters. On the new phone choose Optical Sync (Receive) and point the camera at the moving QR code.'**
  String get tutorialStep27Desc;

  /// Tutorial step 27 tip
  ///
  /// In en, this message translates to:
  /// **'No internet, Bluetooth or cable is used. Chosen counters are added; other counters on the receiving phone are kept.'**
  String get tutorialStep27Tip;

  /// Tutorial step 28 title
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get tutorialStep28Title;

  /// Tutorial step 28 description
  ///
  /// In en, this message translates to:
  /// **'Settings → Data Backup & Optical Sync → Clear all data deletes every counter and all history.'**
  String get tutorialStep28Desc;

  /// Tutorial step 28 tip
  ///
  /// In en, this message translates to:
  /// **'Make a backup first. This cannot be undone.'**
  String get tutorialStep28Tip;

  /// Tutorial step 29 title
  ///
  /// In en, this message translates to:
  /// **'Fully offline and private'**
  String get tutorialStep29Title;

  /// Tutorial step 29 description
  ///
  /// In en, this message translates to:
  /// **'The app has no internet permission, no ads, no tracking and no account. Your practice stays on your phone.'**
  String get tutorialStep29Desc;

  /// Tutorial step 29 tip
  ///
  /// In en, this message translates to:
  /// **'Android cloud backup is off for this app, so use Export or Optical Sync to keep a copy.'**
  String get tutorialStep29Tip;

  /// Tutorial step 30 title
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get tutorialStep30Title;

  /// Tutorial step 30 description
  ///
  /// In en, this message translates to:
  /// **'The camera is used only to scan sync codes. Notifications show goal messages. Vibration and audio give feedback. Do Not Disturb access is asked only if you turn it on.'**
  String get tutorialStep30Desc;

  /// Tutorial step 30 tip
  ///
  /// In en, this message translates to:
  /// **'See every permission and why it is used in Settings → Permissions.'**
  String get tutorialStep30Tip;

  /// Help counters guide: intro text
  ///
  /// In en, this message translates to:
  /// **'The home screen lists all your counters. Each counter is one mantra or practice, with its own goals and history.'**
  String get helpCountersIntro;

  /// Help counters guide: Create section title
  ///
  /// In en, this message translates to:
  /// **'Creating a counter'**
  String get helpCountersCreateSection;

  /// Help counters guide: Create bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Add button:'**
  String get helpCountersCreateBold1;

  /// Help counters guide: Create bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Tap the + button at the top of the home screen to make a new counter.'**
  String get helpCountersCreateBullet1;

  /// Help counters guide: Create bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get helpCountersCreateBold2;

  /// Help counters guide: Create bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Type the mantra name in any language or script.'**
  String get helpCountersCreateBullet2;

  /// Help counters guide: Create bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Initial count:'**
  String get helpCountersCreateBold3;

  /// Help counters guide: Create bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Bring in counts you made before, for example from a paper log. The default is 0.'**
  String get helpCountersCreateBullet3;

  /// Help counters guide: Create bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Increment step:'**
  String get helpCountersCreateBold4;

  /// Help counters guide: Create bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'How much one tap adds. The default is 1. It must be less than the daily goal.'**
  String get helpCountersCreateBullet4;

  /// Help counters guide: Create bullet 5 bold label
  ///
  /// In en, this message translates to:
  /// **'Goals:'**
  String get helpCountersCreateBold5;

  /// Help counters guide: Create bullet 5 text
  ///
  /// In en, this message translates to:
  /// **'Set a daily goal and a lifetime goal. Use 0 for no goal. The daily goal cannot be more than the lifetime goal.'**
  String get helpCountersCreateBullet5;

  /// Help counters guide: Create bullet 6 bold label
  ///
  /// In en, this message translates to:
  /// **'Start date:'**
  String get helpCountersCreateBold6;

  /// Help counters guide: Create bullet 6 text
  ///
  /// In en, this message translates to:
  /// **'The day you started this practice. It is used to work out your average chants per day.'**
  String get helpCountersCreateBullet6;

  /// Help counters guide: Home section title
  ///
  /// In en, this message translates to:
  /// **'The home screen'**
  String get helpCountersHomeSection;

  /// Help counters guide: Home bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Today summary:'**
  String get helpCountersHomeBold1;

  /// Help counters guide: Home bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'The pill at the top shows today\'s total chants, total malas, and how many counters you used today.'**
  String get helpCountersHomeBullet1;

  /// Help counters guide: Home bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Card progress:'**
  String get helpCountersHomeBold2;

  /// Help counters guide: Home bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Each card shows total chants and malas, today\'s chants, a strip of 27 beads for today\'s goal, and a bar for the lifetime goal.'**
  String get helpCountersHomeBullet2;

  /// Help counters guide: Home bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Badges:'**
  String get helpCountersHomeBold3;

  /// Help counters guide: Home bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'A green tick appears when today\'s goal is done. A gold trophy appears when the lifetime goal is reached.'**
  String get helpCountersHomeBullet3;

  /// Help counters guide: Home bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Order:'**
  String get helpCountersHomeBold4;

  /// Help counters guide: Home bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'Active counters come first, then disabled ones. Newer counters are shown first.'**
  String get helpCountersHomeBullet4;

  /// Help counters guide: Home bullet 5 bold label
  ///
  /// In en, this message translates to:
  /// **'Colours:'**
  String get helpCountersHomeBold5;

  /// Help counters guide: Home bullet 5 text
  ///
  /// In en, this message translates to:
  /// **'Each counter gets its own accent colour, and it always stays the same.'**
  String get helpCountersHomeBullet5;

  /// Help counters guide: Home bullet 6 bold label
  ///
  /// In en, this message translates to:
  /// **'Top menu:'**
  String get helpCountersHomeBold6;

  /// Help counters guide: Home bullet 6 text
  ///
  /// In en, this message translates to:
  /// **'The menu at the top has Import / Export, Settings and About.'**
  String get helpCountersHomeBullet6;

  /// Help counters guide: Options section title
  ///
  /// In en, this message translates to:
  /// **'Counter options (long-press a card)'**
  String get helpCountersOptionsSection;

  /// Help counters guide: Options bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'About counter:'**
  String get helpCountersOptionsBold1;

  /// Help counters guide: Options bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Statistics and details of the counter.'**
  String get helpCountersOptionsBullet1;

  /// Help counters guide: Options bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'History:'**
  String get helpCountersOptionsBold2;

  /// Help counters guide: Options bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'All sittings of this counter.'**
  String get helpCountersOptionsBullet2;

  /// Help counters guide: Options bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Edit:'**
  String get helpCountersOptionsBold3;

  /// Help counters guide: Options bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Change the name, step, goals or start date.'**
  String get helpCountersOptionsBullet3;

  /// Help counters guide: Options bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Lock / Unlock:'**
  String get helpCountersOptionsBold4;

  /// Help counters guide: Options bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'Same as the lock icon on the card.'**
  String get helpCountersOptionsBullet4;

  /// Help counters guide: Options bullet 5 bold label
  ///
  /// In en, this message translates to:
  /// **'Disable (success):'**
  String get helpCountersOptionsBold5;

  /// Help counters guide: Options bullet 5 text
  ///
  /// In en, this message translates to:
  /// **'Mark the counter as completed, for example when a vow is finished. You can add a reason.'**
  String get helpCountersOptionsBullet5;

  /// Help counters guide: Options bullet 6 bold label
  ///
  /// In en, this message translates to:
  /// **'Disable (not completed):'**
  String get helpCountersOptionsBold6;

  /// Help counters guide: Options bullet 6 text
  ///
  /// In en, this message translates to:
  /// **'Stop a counter that was not finished. You can add a reason.'**
  String get helpCountersOptionsBullet6;

  /// Help counters guide: Options bullet 7 bold label
  ///
  /// In en, this message translates to:
  /// **'Delete:'**
  String get helpCountersOptionsBold7;

  /// Help counters guide: Options bullet 7 text
  ///
  /// In en, this message translates to:
  /// **'Removes the counter and all its history after you confirm. This cannot be undone.'**
  String get helpCountersOptionsBullet7;

  /// Help counters guide: Lock section title
  ///
  /// In en, this message translates to:
  /// **'Locked and disabled counters'**
  String get helpCountersLockSection;

  /// Help counters guide: Lock bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Lock icon:'**
  String get helpCountersLockBold1;

  /// Help counters guide: Lock bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Tap the lock icon on a card to lock or unlock it.'**
  String get helpCountersLockBullet1;

  /// Help counters guide: Lock bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Locked:'**
  String get helpCountersLockBold2;

  /// Help counters guide: Lock bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'A locked counter cannot be opened for counting, so its count cannot change by mistake. Tapping it shows a short message.'**
  String get helpCountersLockBullet2;

  /// Help counters guide: Lock bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Disabled:'**
  String get helpCountersLockBold3;

  /// Help counters guide: Lock bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Disabled counters stay in the list with a tick or cross mark, but cannot be opened for counting.'**
  String get helpCountersLockBullet3;

  /// Help counting guide: Screen section title
  ///
  /// In en, this message translates to:
  /// **'Reading the screen'**
  String get helpCountingScreenSection;

  /// Help counting guide: Screen bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Timer:'**
  String get helpCountingScreenBold1;

  /// Help counting guide: Screen bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'The pill at the top shows how long this sitting has lasted. It shows PAUSED when the app is in the background.'**
  String get helpCountingScreenBullet1;

  /// Help counting guide: Screen bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Centre:'**
  String get helpCountingScreenBold2;

  /// Help counting guide: Screen bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'The big number is your place in the current mala (0–107). Below it are the beads left and the malas done in this sitting.'**
  String get helpCountingScreenBullet2;

  /// Help counting guide: Screen bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Bottom row:'**
  String get helpCountingScreenBold3;

  /// Help counting guide: Screen bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Shows the Session, Daily and Lifetime counts with progress towards your goals.'**
  String get helpCountingScreenBullet3;

  /// Help counting guide: Screen bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Lamp:'**
  String get helpCountingScreenBold4;

  /// Help counting guide: Screen bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'The lamp icon at the top changes colour when your daily or lifetime goal is reached.'**
  String get helpCountingScreenBullet4;

  /// Help counting guide: Save section title
  ///
  /// In en, this message translates to:
  /// **'Leaving and saving'**
  String get helpCountingSaveSection;

  /// Help counting guide: Save bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Auto save:'**
  String get helpCountingSaveBold1;

  /// Help counting guide: Save bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Press back at any time. Your counts are saved quietly; the app does not ask you to save.'**
  String get helpCountingSaveBullet1;

  /// Help counting guide: Save bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Crash safe:'**
  String get helpCountingSaveBold2;

  /// Help counting guide: Save bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Your count is saved every 5 taps or 5 seconds, and fully stored every 20 taps or 30 seconds. If the phone switches off, the count comes back when you open the app.'**
  String get helpCountingSaveBullet2;

  /// Help counting guide: Save bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Timer pause:'**
  String get helpCountingSaveBold3;

  /// Help counting guide: Save bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'The timer stops while the app is in the background, so idle time is not added to your sitting.'**
  String get helpCountingSaveBullet3;

  /// Help counting guide: Save bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Unfinished mala:'**
  String get helpCountingSaveBold4;

  /// Help counting guide: Save bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'If you stop before 108, the mala waits for you next time, even on another day, and a banner shows it. Taps always count on the day you make them. Tap Start new to keep those counts and begin a new mala at 0.'**
  String get helpCountingSaveBullet4;

  /// Help counting guide: Menu section title
  ///
  /// In en, this message translates to:
  /// **'The counting menu (⋮)'**
  String get helpCountingMenuSection;

  /// Help counting guide: Menu bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'History:'**
  String get helpCountingMenuBold1;

  /// Help counting guide: Menu bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Opens the history of this counter.'**
  String get helpCountingMenuBullet1;

  /// Help counting guide: Menu bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'About:'**
  String get helpCountingMenuBold2;

  /// Help counting guide: Menu bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Shows the statistics and details of this counter.'**
  String get helpCountingMenuBullet2;

  /// Help counting guide: Menu bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Settings:'**
  String get helpCountingMenuBold3;

  /// Help counting guide: Menu bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Opens the app settings.'**
  String get helpCountingMenuBullet3;

  /// Help counting guide: Menu bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Finish & start new:'**
  String get helpCountingMenuBold4;

  /// Help counting guide: Menu bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'Closes the current unfinished mala. Its counts are kept in history, and the next tap starts a new mala at 0.'**
  String get helpCountingMenuBullet4;

  /// Help counting guide: Menu bullet 5 bold label
  ///
  /// In en, this message translates to:
  /// **'Reset session:'**
  String get helpCountingMenuBold5;

  /// Help counting guide: Menu bullet 5 text
  ///
  /// In en, this message translates to:
  /// **'Throws away the current sitting and sets it back to 0. Past history is kept.'**
  String get helpCountingMenuBullet5;

  /// Help counting guide: Menu bullet 6 bold label
  ///
  /// In en, this message translates to:
  /// **'Reset counter:'**
  String get helpCountingMenuBold6;

  /// Help counting guide: Menu bullet 6 text
  ///
  /// In en, this message translates to:
  /// **'Deletes all history of this counter. This cannot be undone.'**
  String get helpCountingMenuBullet6;

  /// Help counting guide: Mindful bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Meru pause:'**
  String get helpCountingMindfulBold1;

  /// Help counting guide: Mindful bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'When turned on in Settings → Display & Stillness, the app pauses for 3, 5 or 10 seconds after each mala. Taps in the pause are not counted. The pause ends by itself, or with the undo swipe.'**
  String get helpCountingMindfulBullet1;

  /// Help counting guide: Mindful bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Pacing hint:'**
  String get helpCountingMindfulBold2;

  /// Help counting guide: Mindful bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'If you tap faster than about 3 times a second, the circle glows softly and a short reminder appears. It never blocks a count.'**
  String get helpCountingMindfulBullet2;

  /// Help mala and goals guide: Beads bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Mala sound:'**
  String get helpMalaBeadsBold4;

  /// Help mala and goals guide: Beads bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'If it is on, a soft sound plays on every 108th count. It is skipped when the same tap also reaches a goal, so sounds do not overlap.'**
  String get helpMalaBeadsBullet4;

  /// Help mala and goals guide: Goals bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached:'**
  String get helpMalaGoalsBold3;

  /// Help mala and goals guide: Goals bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'If the daily notification is on, the goal tone plays, the phone vibrates and a notification appears. A green tick shows on the card.'**
  String get helpMalaGoalsBullet3;

  /// Help mala and goals guide: Goals bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal reached:'**
  String get helpMalaGoalsBold4;

  /// Help mala and goals guide: Goals bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'If the lifetime notification is on, the lifetime tone and notification play. A gold trophy shows and the card turns a soft sandal colour.'**
  String get helpMalaGoalsBullet4;

  /// Help mala and goals guide: Card section title
  ///
  /// In en, this message translates to:
  /// **'Progress on the card'**
  String get helpMalaCardSection;

  /// Help mala and goals guide: Card bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Bead strip:'**
  String get helpMalaCardBold1;

  /// Help mala and goals guide: Card bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'The row of 27 small beads shows today\'s progress towards the daily goal. Each bead is 1/27 of the goal, like 4 beads of a mala.'**
  String get helpMalaCardBullet1;

  /// Help mala and goals guide: Card bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Lifetime bar:'**
  String get helpMalaCardBold2;

  /// Help mala and goals guide: Card bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'The long bar shows how much of your lifetime goal is done.'**
  String get helpMalaCardBullet2;

  /// Help mala and goals guide: Card bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Numbers:'**
  String get helpMalaCardBold3;

  /// Help mala and goals guide: Card bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'The card shows total chants, total malas, and today\'s chants and malas.'**
  String get helpMalaCardBullet3;

  /// Help history guide: intro text
  ///
  /// In en, this message translates to:
  /// **'History keeps a record of every sitting. Open it from the counting menu, from the long-press menu of a counter, or from the counter\'s details page.'**
  String get helpHistoryIntro;

  /// Help history guide: Log section title
  ///
  /// In en, this message translates to:
  /// **'The history list'**
  String get helpHistoryLogSection;

  /// Help history guide: Log bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Summary:'**
  String get helpHistoryLogBold1;

  /// Help history guide: Log bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'The top card shows total chants, days of practice, and how much of your vow is done.'**
  String get helpHistoryLogBullet1;

  /// Help history guide: Log bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Grouped by day:'**
  String get helpHistoryLogBold2;

  /// Help history guide: Log bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Sittings are grouped by date, newest first. Each day shows its total and the running total at the end of that day.'**
  String get helpHistoryLogBullet2;

  /// Help history guide: Log bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Sitting rows:'**
  String get helpHistoryLogBold3;

  /// Help history guide: Log bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Each sitting shows the start time, how long it lasted, the count and the malas.'**
  String get helpHistoryLogBullet3;

  /// Help history guide: Delete section title
  ///
  /// In en, this message translates to:
  /// **'Deleting history'**
  String get helpHistoryDeleteSection;

  /// Help history guide: Delete bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'One sitting:'**
  String get helpHistoryDeleteBold1;

  /// Help history guide: Delete bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Tap the delete icon on a sitting and confirm. Totals are worked out again at once.'**
  String get helpHistoryDeleteBullet1;

  /// Help history guide: Delete bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Clear history:'**
  String get helpHistoryDeleteBold2;

  /// Help history guide: Delete bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'The clear button at the top deletes all sittings of this counter after you confirm. This cannot be undone.'**
  String get helpHistoryDeleteBullet2;

  /// Help history guide: Flow section title
  ///
  /// In en, this message translates to:
  /// **'Sadhana Flow calendar'**
  String get helpHistoryFlowSection;

  /// Help history guide: Flow bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'16 weeks:'**
  String get helpHistoryFlowBold1;

  /// Help history guide: Flow bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'A calendar of the last 16 weeks, with Monday at the top. Days with practice glow like a lamp, from soft sandal to deep saffron.'**
  String get helpHistoryFlowBullet1;

  /// Help history guide: Flow bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Glow:'**
  String get helpHistoryFlowBold2;

  /// Help history guide: Flow bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'For a counter with a daily goal, the glow shows progress towards that goal. Otherwise it is compared with your busiest day shown.'**
  String get helpHistoryFlowBullet2;

  /// Help history guide: Flow bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'No pressure:'**
  String get helpHistoryFlowBold3;

  /// Help history guide: Flow bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'There are no streaks and no missed-day marks. If you return after 3 or more days, a warm welcome line appears.'**
  String get helpHistoryFlowBullet3;

  /// Help history guide: Stats section title
  ///
  /// In en, this message translates to:
  /// **'Counter statistics'**
  String get helpHistoryStatsSection;

  /// Help history guide: Stats bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Open:'**
  String get helpHistoryStatsBold1;

  /// Help history guide: Stats bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Long-press a counter and choose About counter, or use About in the counting menu.'**
  String get helpHistoryStatsBullet1;

  /// Help history guide: Stats bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Rings:'**
  String get helpHistoryStatsBold2;

  /// Help history guide: Stats bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Three rings show lifetime progress, today\'s progress and total malas.'**
  String get helpHistoryStatsBullet2;

  /// Help history guide: Stats bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Details:'**
  String get helpHistoryStatsBold3;

  /// Help history guide: Stats bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Name, status, step, initial count, goals, start date, created date, average chants per day, and the disabled date and reason, if any.'**
  String get helpHistoryStatsBullet3;

  /// Help sound and vibration guide: Mala section title
  ///
  /// In en, this message translates to:
  /// **'Mala sound'**
  String get helpAudioMalaSection;

  /// Help sound and vibration guide: Mala bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Enable mala sound:'**
  String get helpAudioMalaBold1;

  /// Help sound and vibration guide: Mala bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Plays a soft sound and a vibration on every 108th count.'**
  String get helpAudioMalaBullet1;

  /// Help sound and vibration guide: Mala bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Choices:'**
  String get helpAudioMalaBold2;

  /// Help sound and vibration guide: Mala bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Temple Bronze Bell, Tibetan Singing Bowl, or Synthesized Tone (a short beep).'**
  String get helpAudioMalaBullet2;

  /// Help sound and vibration guide: Mala bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'No overlap:'**
  String get helpAudioMalaBold3;

  /// Help sound and vibration guide: Mala bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'If the 108th count also reaches a goal, only the goal tone plays.'**
  String get helpAudioMalaBullet3;

  /// Help sound and vibration guide: Goal section title
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get helpAudioGoalSection;

  /// Help sound and vibration guide: Goal bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Enable notification:'**
  String get helpAudioGoalBold1;

  /// Help sound and vibration guide: Goal bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'When the daily goal is reached, a tone plays, the phone vibrates, and a notification appears in the status bar.'**
  String get helpAudioGoalBullet1;

  /// Help sound and vibration guide: Goal bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Goal tone:'**
  String get helpAudioGoalBold2;

  /// Help sound and vibration guide: Goal bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Pick System default, a phone ringtone, a built-in sound (Temple Bell, Singing Bowl, Synthesized Tone, Sacred Shankha), or your own audio file (MP3, WAV, AAC).'**
  String get helpAudioGoalBullet2;

  /// Help sound and vibration guide: Goal bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Preview:'**
  String get helpAudioGoalBold3;

  /// Help sound and vibration guide: Goal bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Tap Preview tone to hear the chosen tone.'**
  String get helpAudioGoalBullet3;

  /// Help sound and vibration guide: Lifetime section title
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal'**
  String get helpAudioLifetimeSection;

  /// Help sound and vibration guide: Lifetime bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal tone:'**
  String get helpAudioLifetimeBold1;

  /// Help sound and vibration guide: Lifetime bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'A separate tone for the moment your lifetime goal is reached.'**
  String get helpAudioLifetimeBullet1;

  /// Help sound and vibration guide: Lifetime bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Lifetime goal notification:'**
  String get helpAudioLifetimeBold2;

  /// Help sound and vibration guide: Lifetime bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Turn it on to get the tone, vibration and a notification when the lifetime goal is reached.'**
  String get helpAudioLifetimeBullet2;

  /// Help sound and vibration guide: Volume section title
  ///
  /// In en, this message translates to:
  /// **'Loud enough to hear'**
  String get helpAudioVolumeSection;

  /// Help sound and vibration guide: Volume bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Alarm channel:'**
  String get helpAudioVolumeBold1;

  /// Help sound and vibration guide: Volume bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Completion sounds play through the alarm sound channel, so you hear them even when the phone is on silent. The volume goes back to normal after a few seconds.'**
  String get helpAudioVolumeBullet1;

  /// Help display, stillness and language guide: intro text
  ///
  /// In en, this message translates to:
  /// **'These settings help you chant in a calm, quiet way, and let you choose how the app looks and speaks.'**
  String get helpDisplayIntro;

  /// Help display, stillness and language guide: Bright section title
  ///
  /// In en, this message translates to:
  /// **'Brightness and dimming'**
  String get helpDisplayBrightSection;

  /// Help display, stillness and language guide: Bright bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Brightness level:'**
  String get helpDisplayBrightBold1;

  /// Help display, stillness and language guide: Bright bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'In Settings → Display & Stillness, choose a level from \'still\' (dim) to \'full\'. It changes the app screen only, not your phone\'s brightness.'**
  String get helpDisplayBrightBullet1;

  /// Help display, stillness and language guide: Bright bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Use system:'**
  String get helpDisplayBrightBold2;

  /// Help display, stillness and language guide: Bright bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Tap \'use system\' to go back to your phone\'s normal brightness.'**
  String get helpDisplayBrightBullet2;

  /// Help display, stillness and language guide: Bright bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Dimmed chanting mode:'**
  String get helpDisplayBrightBold3;

  /// Help display, stillness and language guide: Bright bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Darkens the background of the counting screen while the mala circle stays clear. Good for dark rooms, and it saves battery.'**
  String get helpDisplayBrightBullet3;

  /// Help display, stillness and language guide: Dnd section title
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get helpDisplayDndSection;

  /// Help display, stillness and language guide: Dnd bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Silence alerts:'**
  String get helpDisplayDndBold1;

  /// Help display, stillness and language guide: Dnd bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'When on, the phone goes into Do Not Disturb while the counting screen is open, and goes back to normal when you leave it.'**
  String get helpDisplayDndBullet1;

  /// Help display, stillness and language guide: Dnd bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Permission:'**
  String get helpDisplayDndBold2;

  /// Help display, stillness and language guide: Dnd bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'The first time, the app asks you to allow Do Not Disturb access. Tap Open Settings and allow it for this app.'**
  String get helpDisplayDndBullet2;

  /// Help display, stillness and language guide: Mindful section title
  ///
  /// In en, this message translates to:
  /// **'Mindful counting'**
  String get helpDisplayMindfulSection;

  /// Help display, stillness and language guide: Mindful bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Meru pause:'**
  String get helpDisplayMindfulBold1;

  /// Help display, stillness and language guide: Mindful bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'A short pause of 3, 5 or 10 seconds after each mala. Taps during the pause are not counted. Off by default.'**
  String get helpDisplayMindfulBullet1;

  /// Help display, stillness and language guide: Mindful bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Gentle pacing hint:'**
  String get helpDisplayMindfulBold2;

  /// Help display, stillness and language guide: Mindful bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'A soft glow when you tap very fast. Every tap still counts. On by default.'**
  String get helpDisplayMindfulBullet2;

  /// Help display, stillness and language guide: Lang section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get helpDisplayLangSection;

  /// Help display, stillness and language guide: Lang bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Choose language:'**
  String get helpDisplayLangBold1;

  /// Help display, stillness and language guide: Lang bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'In Settings → Language pick English, Malayalam, Sanskrit, or System default.'**
  String get helpDisplayLangBullet1;

  /// Help display, stillness and language guide: Lang bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Any script:'**
  String get helpDisplayLangBold2;

  /// Help display, stillness and language guide: Lang bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Counter names can be written in any script, whatever app language you choose.'**
  String get helpDisplayLangBullet2;

  /// Help display, stillness and language guide: Look section title
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get helpDisplayLookSection;

  /// Help display, stillness and language guide: Look bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Temple theme:'**
  String get helpDisplayLookBold1;

  /// Help display, stillness and language guide: Look bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Settings → Appearance shows the colours (cream, vermillion, sandal, tulsi, rose) and the fonts used in the app.'**
  String get helpDisplayLookBullet1;

  /// Help display, stillness and language guide: Look bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Portrait only:'**
  String get helpDisplayLookBold2;

  /// Help display, stillness and language guide: Look bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'The app always stays upright, so you can count with one hand.'**
  String get helpDisplayLookBullet2;

  /// Help optical sync guide: How bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Merge:'**
  String get helpOpticalHowBold4;

  /// Help optical sync guide: How bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'Chosen counters are added to the receiving phone. A counter that already exists there is replaced by the received copy. Other counters on that phone are not touched.'**
  String get helpOpticalHowBullet4;

  /// Help optical sync guide: Send section title
  ///
  /// In en, this message translates to:
  /// **'Sender controls'**
  String get helpOpticalSendSection;

  /// Help optical sync guide: Send bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Speed:'**
  String get helpOpticalSendBold1;

  /// Help optical sync guide: Send bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Choose 8, 12 or 15 frames per second. 8 is the default and works best on most phones.'**
  String get helpOpticalSendBullet1;

  /// Help optical sync guide: Send bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Pause and play:'**
  String get helpOpticalSendBold2;

  /// Help optical sync guide: Send bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Pause the stream and play it again at any time.'**
  String get helpOpticalSendBullet2;

  /// Help optical sync guide: Send bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Brightness:'**
  String get helpOpticalSendBold3;

  /// Help optical sync guide: Send bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'A slider can make the screen brighter if the other camera has trouble. It goes back to normal when sending stops. The screen stays on while sending.'**
  String get helpOpticalSendBullet3;

  /// Help optical sync guide: Receive section title
  ///
  /// In en, this message translates to:
  /// **'Receiver controls'**
  String get helpOpticalReceiveSection;

  /// Help optical sync guide: Receive bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Tap to focus:'**
  String get helpOpticalReceiveBold1;

  /// Help optical sync guide: Receive bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Tap the camera view to focus on the code.'**
  String get helpOpticalReceiveBullet1;

  /// Help optical sync guide: Receive bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Zoom:'**
  String get helpOpticalReceiveBold2;

  /// Help optical sync guide: Receive bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'Use the zoom slider (up to 4×) if the code looks small.'**
  String get helpOpticalReceiveBullet2;

  /// Help optical sync guide: Receive bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Light:'**
  String get helpOpticalReceiveBold3;

  /// Help optical sync guide: Receive bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Turn on the torch in a dark room.'**
  String get helpOpticalReceiveBullet3;

  /// Help optical sync guide: Receive bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Frames received:'**
  String get helpOpticalReceiveBold4;

  /// Help optical sync guide: Receive bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'This line shows that scanning is working, even before all parts are complete.'**
  String get helpOpticalReceiveBullet4;

  /// Help backup and restore guide: Where section title
  ///
  /// In en, this message translates to:
  /// **'Where to find it'**
  String get helpBackupWhereSection;

  /// Help backup and restore guide: Where bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Settings:'**
  String get helpBackupWhereBold1;

  /// Help backup and restore guide: Where bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Settings → Data Backup & Optical Sync has Export, Import, Optical Sync and Clear all data.'**
  String get helpBackupWhereBullet1;

  /// Help backup and restore guide: Where bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Home menu:'**
  String get helpBackupWhereBold2;

  /// Help backup and restore guide: Where bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'The menu on the home screen also has Import / Export.'**
  String get helpBackupWhereBullet2;

  /// Help backup and restore guide: Export bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Share sheet:'**
  String get helpBackupExportBold4;

  /// Help backup and restore guide: Export bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'After export, the Android share sheet opens. Save the file to your files or a memory card, or send it with an app you trust.'**
  String get helpBackupExportBullet4;

  /// Help backup and restore guide: Import bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Safe restore:'**
  String get helpBackupImportBold4;

  /// Help backup and restore guide: Import bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'The file is checked first. If it is damaged or the passphrase is wrong, nothing is changed and an error is shown.'**
  String get helpBackupImportBullet4;

  /// Help backup and restore guide: Import bullet 5 bold label
  ///
  /// In en, this message translates to:
  /// **'Older backups:'**
  String get helpBackupImportBold5;

  /// Help backup and restore guide: Import bullet 5 text
  ///
  /// In en, this message translates to:
  /// **'Backup files from the older Android version of this app can also be imported.'**
  String get helpBackupImportBullet5;

  /// Help backup and restore guide: Clear section title
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get helpBackupClearSection;

  /// Help backup and restore guide: Clear bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Erase everything:'**
  String get helpBackupClearBold1;

  /// Help backup and restore guide: Clear bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Clear all data deletes all counters and all history after you confirm. This cannot be undone, so make a backup first.'**
  String get helpBackupClearBullet1;

  /// Help privacy guide: Storage bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Crash-safe saving:'**
  String get helpPrivacyStorageBold3;

  /// Help privacy guide: Storage bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'Frequent save points keep your count safe if the app closes suddenly.'**
  String get helpPrivacyStorageBullet3;

  /// Help privacy guide: Perms section title
  ///
  /// In en, this message translates to:
  /// **'Permissions the app uses'**
  String get helpPrivacyPermsSection;

  /// Help privacy guide: Perms bullet 1 bold label
  ///
  /// In en, this message translates to:
  /// **'Camera:'**
  String get helpPrivacyPermsBold1;

  /// Help privacy guide: Perms bullet 1 text
  ///
  /// In en, this message translates to:
  /// **'Only to scan the QR code when receiving Optical Sync. No photos or videos are taken.'**
  String get helpPrivacyPermsBullet1;

  /// Help privacy guide: Perms bullet 2 bold label
  ///
  /// In en, this message translates to:
  /// **'Notifications:'**
  String get helpPrivacyPermsBold2;

  /// Help privacy guide: Perms bullet 2 text
  ///
  /// In en, this message translates to:
  /// **'To show goal messages in the status bar. Asked on Android 13 and later.'**
  String get helpPrivacyPermsBullet2;

  /// Help privacy guide: Perms bullet 3 bold label
  ///
  /// In en, this message translates to:
  /// **'Vibration and audio:'**
  String get helpPrivacyPermsBold3;

  /// Help privacy guide: Perms bullet 3 text
  ///
  /// In en, this message translates to:
  /// **'For the mala, goal and undo feedback, and to play completion sounds clearly.'**
  String get helpPrivacyPermsBullet3;

  /// Help privacy guide: Perms bullet 4 bold label
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb access:'**
  String get helpPrivacyPermsBold4;

  /// Help privacy guide: Perms bullet 4 text
  ///
  /// In en, this message translates to:
  /// **'Asked only if you turn on Do Not Disturb in Display & Stillness.'**
  String get helpPrivacyPermsBullet4;

  /// Help privacy guide: Perms bullet 5 bold label
  ///
  /// In en, this message translates to:
  /// **'Your files:'**
  String get helpPrivacyPermsBold5;

  /// Help privacy guide: Perms bullet 5 text
  ///
  /// In en, this message translates to:
  /// **'The app does not read your files. Import and export use the Android file picker, where you choose the file.'**
  String get helpPrivacyPermsBullet5;

  /// Help privacy guide: Perms bullet 6 bold label
  ///
  /// In en, this message translates to:
  /// **'Full list:'**
  String get helpPrivacyPermsBold6;

  /// Help privacy guide: Perms bullet 6 text
  ///
  /// In en, this message translates to:
  /// **'Settings → Permissions lists every permission and why it is used.'**
  String get helpPrivacyPermsBullet6;

  /// Help FAQ: question 5
  ///
  /// In en, this message translates to:
  /// **'Which day do my counts go to?'**
  String get helpFaqQ5Title;

  /// Help FAQ: answer 5
  ///
  /// In en, this message translates to:
  /// **'Each tap counts on the day you make it, by your phone\'s clock. The daily goal starts again at midnight.'**
  String get helpFaqQ5Answer;

  /// Help FAQ: question 6
  ///
  /// In en, this message translates to:
  /// **'What is the difference between Reset session and Reset counter?'**
  String get helpFaqQ6Title;

  /// Help FAQ: answer 6
  ///
  /// In en, this message translates to:
  /// **'Reset session throws away only the current sitting. Reset counter deletes all history of that counter and cannot be undone.'**
  String get helpFaqQ6Answer;

  /// Help FAQ: question 7
  ///
  /// In en, this message translates to:
  /// **'Why did the mala sound not play?'**
  String get helpFaqQ7Title;

  /// Help FAQ: answer 7
  ///
  /// In en, this message translates to:
  /// **'Check that Enable mala sound is on. If the same tap also reached a goal, only the goal tone plays.'**
  String get helpFaqQ7Answer;

  /// Help FAQ: question 8
  ///
  /// In en, this message translates to:
  /// **'Why do sounds play when my phone is on silent?'**
  String get helpFaqQ8Title;

  /// Help FAQ: answer 8
  ///
  /// In en, this message translates to:
  /// **'Completion sounds use the alarm channel so you do not miss them. Turn off the sounds in Settings → Sound & Haptics if you want silence.'**
  String get helpFaqQ8Answer;

  /// Help FAQ: question 9
  ///
  /// In en, this message translates to:
  /// **'I forgot my backup passphrase. What can I do?'**
  String get helpFaqQ9Title;

  /// Help FAQ: answer 9
  ///
  /// In en, this message translates to:
  /// **'The passphrase cannot be recovered, and that file cannot be opened. Make a new backup from a phone that still has your data.'**
  String get helpFaqQ9Answer;

  /// Help FAQ: question 10
  ///
  /// In en, this message translates to:
  /// **'Will import remove my current counters?'**
  String get helpFaqQ10Title;

  /// Help FAQ: answer 10
  ///
  /// In en, this message translates to:
  /// **'Importing a backup file replaces all current data. Optical Sync is different: it only adds or updates the counters you choose.'**
  String get helpFaqQ10Answer;

  /// Help FAQ: question 11
  ///
  /// In en, this message translates to:
  /// **'Optical Sync scanning is slow. What helps?'**
  String get helpFaqQ11Title;

  /// Help FAQ: answer 11
  ///
  /// In en, this message translates to:
  /// **'Hold the phone steady 15–25 cm away, tap to focus, avoid glare, and raise the sender\'s brightness. Try a lower speed such as 8 frames per second.'**
  String get helpFaqQ11Answer;

  /// Help FAQ: question 12
  ///
  /// In en, this message translates to:
  /// **'Can I move my data to a new phone?'**
  String get helpFaqQ12Title;

  /// Help FAQ: answer 12
  ///
  /// In en, this message translates to:
  /// **'Yes. Use Optical Sync with both phones side by side, or export a backup file and import it on the new phone.'**
  String get helpFaqQ12Answer;

  /// Help FAQ: question 13
  ///
  /// In en, this message translates to:
  /// **'Why is the app fully offline?'**
  String get helpFaqQ13Title;

  /// Help FAQ: answer 13
  ///
  /// In en, this message translates to:
  /// **'Japa is personal and sacred. Staying offline keeps your practice private, saves battery, and removes distractions.'**
  String get helpFaqQ13Answer;

  /// Help FAQ: question 14
  ///
  /// In en, this message translates to:
  /// **'Is my data shared with anyone?'**
  String get helpFaqQ14Title;

  /// Help FAQ: answer 14
  ///
  /// In en, this message translates to:
  /// **'No. Your data never leaves your phone unless you export it or send it with Optical Sync yourself.'**
  String get helpFaqQ14Answer;
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
      <String>['en', 'ml', 'sa'].contains(locale.languageCode);

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
    case 'sa':
      return AppLocalizationsSa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
