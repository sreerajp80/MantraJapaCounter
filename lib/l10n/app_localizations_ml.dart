// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'മന്ത്ര ജപ കൗണ്ടർ';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get save => 'സംരക്ഷിക്കുക';

  @override
  String get create => 'സൃഷ്ടിക്കുക';

  @override
  String get confirm => 'സ്ഥിരീകരിക്കുക';

  @override
  String get clear => 'മായ്ക്കുക';

  @override
  String get reset => 'പുനഃസജ്ജമാക്കുക';

  @override
  String get resetAll => 'എല്ലാം പുനഃസജ്ജമാക്കുക';

  @override
  String get export => 'എക്സ്പോർട്ട്';

  @override
  String get import => 'ഇംപോർട്ട്';

  @override
  String get play => 'പ്ലേ';

  @override
  String get more => 'കൂടുതൽ';

  @override
  String get notSet => 'സജ്ജമാക്കിയിട്ടില്ല';

  @override
  String errorWithMessage(String message) {
    return 'പിശക്: $message';
  }

  @override
  String get mantraCounters => 'മന്ത്ര കൗണ്ടറുകൾ';

  @override
  String get menuImportExport => 'ഇംപോർട്ട് / എക്സ്പോർട്ട്';

  @override
  String get menuSettings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get menuAbout => 'ആപ്പിനെക്കുറിച്ച്';

  @override
  String get todayChants => 'ജപങ്ങൾ';

  @override
  String get todayMalas => 'മാലകൾ';

  @override
  String get todayActive => 'സജീവം';

  @override
  String get noCountersYet => 'ഇതുവരെ കൗണ്ടറുകൾ ഇല്ല';

  @override
  String get noCountersSubtitle =>
      'നിങ്ങളുടെ ആദ്യ സമർപ്പണം ആരംഭിക്കാൻ മുകളിലെ + അമർത്തുക';

  @override
  String get aboutCounter => 'കൗണ്ടറിനെക്കുറിച്ച്';

  @override
  String get history => 'ചരിത്രം';

  @override
  String get edit => 'എഡിറ്റ് ചെയ്യുക';

  @override
  String get disableSuccess => 'പ്രവർത്തനരഹിതമാക്കുക (വിജയം)';

  @override
  String get disableFailure => 'പ്രവർത്തനരഹിതമാക്കുക (പൂർത്തിയായില്ല)';

  @override
  String get deleteCounterTitle => 'കൗണ്ടർ ഇല്ലാതാക്കണോ?';

  @override
  String deleteCounterMessage(String name) {
    return '\"$name\" ഉം അതിന്റെ എല്ലാ ചരിത്രവും ഇല്ലാതാക്കണോ? ഇത് പഴയപടിയാക്കാനാവില്ല.';
  }

  @override
  String get disableAsCompletedTitle => 'പൂർത്തിയായതായി പ്രവർത്തനരഹിതമാക്കണോ?';

  @override
  String get disableCounterTitle => 'കൗണ്ടർ പ്രവർത്തനരഹിതമാക്കണോ?';

  @override
  String get reasonOptional => 'കാരണം (ഐച്ഛികം)';

  @override
  String get reasonHint => 'ഉദാ. 1 ലക്ഷം പൂർത്തിയാക്കി';

  @override
  String get editCounterTitle => 'കൗണ്ടർ എഡിറ്റ് ചെയ്യുക';

  @override
  String get newCounterTitle => 'പുതിയ കൗണ്ടർ';

  @override
  String get counterNameLabel => 'കൗണ്ടറിന്റെ പേര് *';

  @override
  String get initialCountLabel => 'പ്രാരംഭ എണ്ണം (സ്ഥിരസ്ഥിതി 0)';

  @override
  String get incrementStepLabel => 'വർദ്ധന ഘട്ടം (സ്ഥിരസ്ഥിതി 1)';

  @override
  String get lifetimeGoalFieldLabel => 'ആജീവനാന്ത ലക്ഷ്യം (0 = ഇല്ല)';

  @override
  String get dailyGoalFieldLabel => 'ദൈനംദിന ലക്ഷ്യം (0 = ഇല്ല)';

  @override
  String get startDateLabel => 'ആരംഭ തീയതി: ';

  @override
  String get dailyExceedsLifetime =>
      'ദൈനംദിന ലക്ഷ്യം ആജീവനാന്ത ലക്ഷ്യത്തേക്കാൾ കൂടാൻ പാടില്ല';

  @override
  String get stepExceedsDaily =>
      'വർദ്ധന ഘട്ടം ദൈനംദിന ലക്ഷ്യത്തേക്കാൾ കുറവായിരിക്കണം';

  @override
  String get importExportBody =>
      'എക്സ്പോർട്ട് എല്ലാ കൗണ്ടറുകളും സെഷനുകളും ഒരു JSON ഫയലിലേക്ക് ബാക്കപ്പ് ചെയ്യുന്നു.\n\nഇംപോർട്ട് നിലവിലെ എല്ലാ ഡാറ്റയും തിരഞ്ഞെടുത്ത ഫയൽ ഉപയോഗിച്ച് മാറ്റിസ്ഥാപിക്കുന്നു.';

  @override
  String exportFailed(String message) {
    return 'എക്സ്പോർട്ട് പരാജയപ്പെട്ടു: $message';
  }

  @override
  String importFailed(String message) {
    return 'ഇംപോർട്ട് പരാജയപ്പെട്ടു: $message';
  }

  @override
  String get importSuccessful => 'ഇംപോർട്ട് വിജയകരം';

  @override
  String pausedWithTime(String time) {
    return 'താൽക്കാലികം · $time';
  }

  @override
  String get resetSession => 'സെഷൻ പുനഃസജ്ജമാക്കുക';

  @override
  String unfinishedMalaBanner(int chants) {
    return 'മുൻ ദിവസത്തെ പൂർത്തിയാകാത്ത മാല: $chants/108';
  }

  @override
  String get startNewSession => 'പുതിയത് തുടങ്ങുക';

  @override
  String get finishAndStartNew => 'പൂർത്തിയാക്കി പുതിയത് തുടങ്ങുക';

  @override
  String get resetCounter => 'കൗണ്ടർ പുനഃസജ്ജമാക്കുക';

  @override
  String get ofOneHundredEight => 'നൂറ്റിയെട്ടിൽ';

  @override
  String get lifetimeGoalCaps => 'ആജീവനാന്ത ലക്ഷ്യം';

  @override
  String get dailyGoalCaps => 'ദൈനംദിന ലക്ഷ്യം';

  @override
  String beadsRemainCaps(int count) {
    return '$count മണികൾ ബാക്കി';
  }

  @override
  String malaThisSession(int count) {
    return 'ഈ സെഷനിൽ +$count മാല';
  }

  @override
  String get footerLifetime => 'ആജീവനാന്തം';

  @override
  String get footerDaily => 'ദൈനംദിനം';

  @override
  String get footerSession => 'സെഷൻ';

  @override
  String get resetSessionTitle => 'സെഷൻ പുനഃസജ്ജമാക്കണോ?';

  @override
  String get resetSessionMessage =>
      'നിലവിലെ സെഷൻ ഉപേക്ഷിക്കുകയും കൗണ്ടർ 0 ആയി പുനഃസജ്ജമാക്കുകയും ചെയ്യും.';

  @override
  String get resetCounterTitle => 'കൗണ്ടർ പുനഃസജ്ജമാക്കണോ?';

  @override
  String get resetCounterMessage =>
      'ഈ കൗണ്ടറിന്റെ എല്ലാ ചരിത്രവും ഇല്ലാതാക്കും. ഇത് പഴയപടിയാക്കാനാവില്ല.';

  @override
  String get noSessionsRecorded =>
      'ഇതുവരെ സെഷനുകളൊന്നും രേഖപ്പെടുത്തിയിട്ടില്ല.';

  @override
  String get recentOfferings => 'സമീപകാല സമർപ്പണങ്ങൾ';

  @override
  String get today => 'ഇന്ന്';

  @override
  String sessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count സെഷനുകൾ',
      one: '1 സെഷൻ',
    );
    return '$_temp0';
  }

  @override
  String get labelChants => 'ജപങ്ങൾ';

  @override
  String get labelMala => 'മാല';

  @override
  String get clearAllHistoryTitle => 'എല്ലാ ചരിത്രവും മായ്ക്കണോ?';

  @override
  String get clearCounterHistoryTitle => 'ഈ കൗണ്ടറിന്റെ ചരിത്രം മായ്ക്കണോ?';

  @override
  String get clearHistoryMessage => 'സെഷനുകൾ ശാശ്വതമായി ഇല്ലാതാക്കും.';

  @override
  String get recordOfDevotion => 'ഭക്തിയുടെ ഒരു രേഖ';

  @override
  String get allCounters => 'എല്ലാ കൗണ്ടറുകളും';

  @override
  String chantsOfferedDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ദിവസങ്ങൾ',
      one: '1 ദിവസം',
    );
    return 'ജപങ്ങൾ സമർപ്പിച്ചു · $_temp0';
  }

  @override
  String chantsOfferedPercent(String percent) {
    return 'ജപങ്ങൾ സമർപ്പിച്ചു · പ്രതിജ്ഞയുടെ $percent%';
  }

  @override
  String get deleteSessionTitle => 'സെഷൻ ഇല്ലാതാക്കണോ?';

  @override
  String deleteSessionMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ജപങ്ങളുടെ ഈ സെഷൻ ശാശ്വതമായി നീക്കം ചെയ്യും.',
      one: '1 ജപത്തിന്റെ ഈ സെഷൻ ശാശ്വതമായി നീക്കം ചെയ്യും.',
    );
    return '$_temp0';
  }

  @override
  String get deleteSessionTooltip => 'സെഷൻ ഇല്ലാതാക്കുക';

  @override
  String chantsCount(String count) {
    return '$count ജപങ്ങൾ';
  }

  @override
  String malaCount(int count) {
    return '$count മാല';
  }

  @override
  String get counterDetailsTitle => 'കൗണ്ടർ വിശദാംശങ്ങൾ';

  @override
  String get counterNotFound => 'കൗണ്ടർ കണ്ടെത്തിയില്ല';

  @override
  String get completedSuccessfully => 'വിജയകരമായി പൂർത്തിയാക്കി';

  @override
  String get statusDisabled => 'പ്രവർത്തനരഹിതം';

  @override
  String get labelTotal => 'ആകെ';

  @override
  String get labelTodayCap => 'ഇന്ന്';

  @override
  String get labelMalas => 'മാലകൾ';

  @override
  String get infoName => 'പേര്';

  @override
  String get infoStatus => 'നില';

  @override
  String get infoIncrementStep => 'വർദ്ധന ഘട്ടം';

  @override
  String get infoInitialCount => 'പ്രാരംഭ എണ്ണം';

  @override
  String get infoLifetimeGoal => 'ആജീവനാന്ത ലക്ഷ്യം';

  @override
  String get infoDailyGoal => 'ദൈനംദിന ലക്ഷ്യം';

  @override
  String get infoStarted => 'ആരംഭിച്ചത്';

  @override
  String get infoCreated => 'സൃഷ്ടിച്ചത്';

  @override
  String get infoAvgDaily => 'ശരാശരി ദൈനംദിന എണ്ണം';

  @override
  String get infoDisabled => 'പ്രവർത്തനരഹിതമാക്കിയത്';

  @override
  String get statusActive => 'സജീവം';

  @override
  String get statusCompleted => 'പൂർത്തിയായി';

  @override
  String get aboutTitle => 'ആപ്പിനെക്കുറിച്ച്';

  @override
  String versionLabel(String version) {
    return 'പതിപ്പ് $version';
  }

  @override
  String aboutBuildDate(String date) {
    return 'ബിൽഡ് തീയതി: $date';
  }

  @override
  String get aboutPurposeTitle => 'ഉദ്ദേശ്യം';

  @override
  String get aboutPurposeBody =>
      'മാല (108-മണി വട്ടം) എണ്ണൽ, ദൈനംദിന, ആജീവനാന്ത ലക്ഷ്യങ്ങൾ, പൂർണ്ണ സെഷൻ ചരിത്രം എന്നിവയോടെ നിങ്ങളുടെ മന്ത്ര ജപാഭ്യാസം ട്രാക്ക് ചെയ്യുക.';

  @override
  String get aboutOfflineTitle => 'പൂർണ്ണമായും ഓഫ്‌ലൈൻ';

  @override
  String get aboutOfflineBody =>
      'നെറ്റ്‌വർക്ക് ആക്സസ് ഇല്ല. എല്ലാ ഡാറ്റയും നിങ്ങളുടെ ഉപകരണത്തിൽ മാത്രം സംഭരിക്കുന്നു.';

  @override
  String get aboutPrivacyTitle => 'സ്വകാര്യത';

  @override
  String get aboutPrivacyBody =>
      'അനലിറ്റിക്സ് ഇല്ല, ട്രാക്കിംഗ് ഇല്ല, ആരുമായും ഡാറ്റ പങ്കിടുന്നില്ല.';

  @override
  String get aboutBackupTitle => 'ബാക്കപ്പ്';

  @override
  String get aboutBackupBody =>
      'നിങ്ങളുടെ ഡാറ്റ ഒരു JSON ഫയലിലേക്ക് ബാക്കപ്പ് ചെയ്യാൻ ഇംപോർട്ട് / എക്സ്പോർട്ട് ഉപയോഗിക്കുക.';

  @override
  String get aboutMantraQuote => 'ഗണേശായ നമഃ · ഹരേ കൃഷ്ണ · ദുർഗായൈ നമഃ';

  @override
  String get aboutMadeWithPrefix => 'സ്നേഹത്തോടെ ';

  @override
  String get aboutMadeWithSuffix => ' ഇന്ത്യയിൽ നിന്ന്';

  @override
  String madeWithLove(String heart) {
    return 'സ്നേഹത്തോടെ $heart ഇന്ത്യയിൽ നിന്ന്';
  }

  @override
  String get madeWithLoveA11y => 'സ്നേഹത്തോടെ ഇന്ത്യയിൽ നിന്ന്';

  @override
  String get aboutDetailAuthor => 'രചയിതാവ്';

  @override
  String get aboutDetailEmail => 'ഇമെയിൽ';

  @override
  String get aboutDetailLicense => 'ലൈസൻസ്';

  @override
  String get aboutDetailAiUsed => 'ഉപയോഗിച്ച AI';

  @override
  String get aboutDetailIdeUsed => 'ഉപയോഗിച്ച IDE';

  @override
  String get aboutDescription =>
      'മാല (108-മണി വട്ടം) എണ്ണൽ, ക്രമീകരിക്കാവുന്ന കൗണ്ടറുകൾ, സെഷൻ ചരിത്രം എന്നിവയോടെ മന്ത്രജപാഭ്യാസം ട്രാക്ക് ചെയ്യാനുള്ള ഓഫ്‌ലൈൻ ആപ്പ്.';

  @override
  String get aboutAuthor => 'രചയിതാവ്';

  @override
  String get aboutAuthorValue => 'ശ്രീരാജ് പി';

  @override
  String get aboutEmail => 'ഇമെയിൽ';

  @override
  String get aboutLicense => 'ലൈസൻസ്';

  @override
  String get aboutLicenseValue =>
      'ഉപയോഗിച്ചിരിക്കുന്ന എല്ലാ ലൈബ്രറികളും ഓപ്പൺ സോഴ്സ് ആണ്.';

  @override
  String get aboutAiUsed => 'ഉപയോഗിച്ച AI';

  @override
  String get aboutAiUsedValue => 'ഗൂഗിൾ ജെമിനി / ആന്ത്രോപിക് ക്ലോഡ്';

  @override
  String get aboutIdeUsed => 'ഉപയോഗിച്ച IDE';

  @override
  String get aboutIdeUsedValue => 'വിഎസ് കോഡ് / ആന്റിഗ്രാവിറ്റി ഐഡിഇ';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get practiceEyebrow => 'അഭ്യാസം';

  @override
  String get sectionLanguage => 'ഭാഷ';

  @override
  String get sectionLanguageSub => 'ആപ്പിന്റെ പ്രദർശന ഭാഷ';

  @override
  String get appLanguage => 'ആപ്പ് ഭാഷ';

  @override
  String get systemDefault => 'സിസ്റ്റം സ്ഥിരസ്ഥിതി';

  @override
  String get englishLanguage => 'English';

  @override
  String get malayalamLanguage => 'മലയാളം';

  @override
  String get sanskritLanguage => 'संस्कृतम्';

  @override
  String get selectLanguageTitle => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get sectionDailyGoal => 'ദൈനംദിന ലക്ഷ്യം';

  @override
  String get sectionDailyGoalSub => 'സമർപ്പണം പൂർത്തിയാകുമ്പോൾ';

  @override
  String get enableNotification => 'അറിയിപ്പ് പ്രവർത്തനക്ഷമമാക്കുക';

  @override
  String get enableNotificationSub => 'പൂർത്തിയാകുമ്പോൾ വൈബ്രേഷനും ശബ്ദവും';

  @override
  String get vibration => 'വൈബ്രേഷൻ';

  @override
  String get vibrationSub => 'പൂർത്തിയാകുമ്പോൾ ഒരു മൃദുവായ മൂളൽ';

  @override
  String get notificationSound => 'അറിയിപ്പ് ശബ്ദം';

  @override
  String get previewTone => 'ടോൺ പ്രിവ്യൂ';

  @override
  String get previewToneSub => 'പൂർത്തിയാകുമ്പോൾ പ്ലേ ചെയ്യുന്നത് കേൾക്കുക';

  @override
  String get sectionMala => 'മാല പൂർത്തീകരണം';

  @override
  String get sectionMalaSub => 'ഓരോ 108 മണികളുടെയും സമാപനം';

  @override
  String get enableMalaSound => 'മാല ശബ്ദം പ്രവർത്തനക്ഷമമാക്കുക';

  @override
  String get enableMalaSoundSub => 'ഓരോ പൂർണ്ണ മാലയിലും ഒരു മൃദു ടിക്ക്';

  @override
  String get malaSoundTitle => 'മാല നാദം';

  @override
  String get malaSoundSub =>
      '108 മണികൾ പൂർത്തിയാകുമ്പോൾ കേൾക്കേണ്ട പവിത്ര നാദം';

  @override
  String get soundTempleBell => 'ക്ഷേത്ര വെങ്കല മണി';

  @override
  String get soundTempleBellSub => 'ആഴമേറിയ ശാന്ത വെങ്കല നാദം (ഘണ്ട)';

  @override
  String get soundSingingBowl => 'തിബറ്റൻ സിംഗിംഗ് ബൗൾ';

  @override
  String get soundSingingBowlSub => 'ധ്യാനപൂർണ്ണമായ ശാന്ത ഹാർമോണിക് സ്വരം';

  @override
  String get soundSynthesizedTone => 'സിന്തറ്റിക് ടോൺ';

  @override
  String get soundSynthesizedToneSub =>
      'പരമ്പരാഗത 100ms ഇലക്ട്രോണിക് ബീപ്പ് (DTMF)';

  @override
  String get sectionStillness => 'നിശ്ചലത';

  @override
  String get sectionStillnessSub => 'ദൈർഘ്യമേറിയ സെഷനുകൾക്ക്';

  @override
  String get dndTitle => 'അറിയിപ്പുകൾ നിശബ്ദമാക്കുക (DND)';

  @override
  String get dndSub =>
      'ജപിക്കുമ്പോൾ വരുന്ന സന്ദേശങ്ങളും കോളുകളും നിശബ്ദമാക്കുന്നു';

  @override
  String get dndPermissionTitle => 'ഡു നോട്ട് ഡിസ്റ്റർബ് അനുമതി';

  @override
  String get dndPermissionMessage =>
      'ജപിക്കുമ്പോൾ കോളുകളും അറിയിപ്പുകളും സ്വയം നിശബ്ദമാക്കാൻ, ആൻഡ്രോയിഡ് ക്രമീകരണങ്ങളിൽ Do Not Disturb അനുമതി നൽകുക.';

  @override
  String get dndOpenSettings => 'ക്രമീകരണങ്ങൾ തുറക്കുക';

  @override
  String get dimmedModeTitle => 'മങ്ങിയ ജപ രീതി';

  @override
  String get dimmedModeSub =>
      'ബാറ്ററി ലാഭിക്കാൻ മാല വൃത്തം മാത്രം കാണിച്ച് പശ്ചാത്തലം ഇരുണ്ടതാക്കുന്നു';

  @override
  String get brightnessLevel => 'തെളിച്ച നില';

  @override
  String get followingSystem => 'സിസ്റ്റം പിന്തുടരുന്നു';

  @override
  String get overrideActive => 'ഓവർറൈഡ് സജീവം';

  @override
  String get brightnessStill => 'നിശ്ചലം';

  @override
  String get brightnessUseSystem => 'സിസ്റ്റം ഉപയോഗിക്കുക';

  @override
  String get brightnessFull => 'പൂർണ്ണം';

  @override
  String get sectionPracticeGuide => 'അഭ്യാസ ഗൈഡ്';

  @override
  String get sectionPracticeGuideSub => 'ഉപയോഗത്തിന്റെ ആംഗ്യങ്ങളും താളങ്ങളും';

  @override
  String get howItWorks => 'ഇത് എങ്ങനെ പ്രവർത്തിക്കുന്നു';

  @override
  String get howItWorksSub => 'എണ്ണൽ, പഴയപടിയാക്കൽ, മെനു — വിശദീകരിച്ചു';

  @override
  String get settingsGuidanceBody =>
      'നിങ്ങളുടെ ലക്ഷ്യം എത്തുമ്പോൾ ദൈനംദിന-ലക്ഷ്യ ശബ്ദം പ്ലേ ചെയ്യുന്നു. ഓരോ 108 ജപങ്ങൾക്കും ശേഷം മാല ശബ്ദം മൃദുവായി മുഴങ്ങുന്നു — ആ എണ്ണം ദൈനംദിന സമർപ്പണവും പൂർത്തിയാക്കുമ്പോൾ ഒഴികെ.';

  @override
  String get clearAllData => 'എല്ലാ ഡാറ്റയും മായ്ക്കുക';

  @override
  String get clearAllDataSub =>
      'എല്ലാ കൗണ്ടറുകളും സെഷൻ ചരിത്രവും ശാശ്വതമായി ഇല്ലാതാക്കുക';

  @override
  String get soundSystemDefaultTapToChange =>
      'സിസ്റ്റം സ്ഥിരസ്ഥിതി — മാറ്റാൻ അമർത്തുക';

  @override
  String soundNamedTapToChange(String name) {
    return '$name — മാറ്റാൻ അമർത്തുക';
  }

  @override
  String get soundCustomTapToChange => 'ഇഷ്ടാനുസൃത ഓഡിയോ — മാറ്റാൻ അമർത്തുക';

  @override
  String get soundSystemDefault => 'സിസ്റ്റം സ്ഥിരസ്ഥിതി';

  @override
  String get browseAudioFile => 'ഓഡിയോ ഫയൽ ബ്രൗസ് ചെയ്യുക…';

  @override
  String get clearAllDataTitle => 'എല്ലാ ഡാറ്റയും മായ്ക്കണോ?';

  @override
  String get clearAllDataMessage =>
      'ഇത് എല്ലാ കൗണ്ടറുകളും എല്ലാ സെഷൻ ചരിത്രവും ശാശ്വതമായി ഇല്ലാതാക്കും. ഇത് പഴയപടിയാക്കാനാവില്ല.';

  @override
  String get clearAllButton => 'എല്ലാം മായ്ക്കുക';

  @override
  String get allDataCleared => 'എല്ലാ ഡാറ്റയും മായ്ച്ചു';

  @override
  String get helpTitle => 'സഹായം';

  @override
  String get helpCountingTitle => 'എണ്ണൽ';

  @override
  String get helpCountingBody =>
      'ഒരു ജപം എണ്ണാൻ മണി വൃത്തത്തിൽ എവിടെയും അമർത്തുക. ഓരോ 108 ജപങ്ങളും ഒരു മാല പൂർത്തിയാക്കുന്നു — മണികൾ കടന്നുപോകുമ്പോൾ വളയം നിറയുന്നു.';

  @override
  String get helpUndoTitle => 'ഒരു ടാപ്പ് പഴയപടിയാക്കൽ';

  @override
  String get helpUndoBody =>
      'നിങ്ങളുടെ അവസാന ജപം പഴയപടിയാക്കാൻ മണി വൃത്തത്തിൽ രണ്ട് വിരലുകൾ വെച്ച് — ഇടത്തോട്ടോ വലത്തോട്ടോ — സ്വൈപ്പ് ചെയ്യുക. എണ്ണം പൂജ്യത്തിലേക്ക് മടങ്ങിയാൽ സെഷൻ ഭംഗിയായി അവസാനിക്കുന്നു.';

  @override
  String get helpTimerTitle => 'ടൈമറും നിലയും';

  @override
  String get helpTimerBody =>
      'മുകളിലെ പിൽ ഈ സെഷനിൽ ചെലവഴിച്ച സമയം കാണിക്കുന്നു. എണ്ണത്തിന് താഴെയുള്ള പച്ച അടയാളം നിലവിലെ മാലയിൽ എത്ര മണികൾ ബാക്കിയുണ്ടെന്നോ ദൈനംദിന സമർപ്പണം പൂർത്തിയായെന്നോ പറയുന്നു.';

  @override
  String get helpResetTitle => 'പുനഃസജ്ജമാക്കൽ';

  @override
  String get helpResetBody =>
      'സെഷൻ പുനഃസജ്ജമാക്കാനും കൗണ്ടർ പുനഃസജ്ജമാക്കാനും മെനു (എണ്ണൽ സ്ക്രീനിന്റെ മുകളിൽ വലത്തുള്ള മൂന്ന് കുത്തുകൾ) തുറക്കുക. സെഷൻ പുനഃസജ്ജമാക്കൽ നിലവിലെ ഇരിപ്പ് ഉപേക്ഷിക്കുന്നു; കൗണ്ടർ പുനഃസജ്ജമാക്കൽ ആ മന്ത്രത്തിന്റെ എല്ലാ ചരിത്രവും മായ്ക്കുന്നു.';

  @override
  String cardChantsMala(int malas) {
    return 'ജപങ്ങൾ · $malas മാല';
  }

  @override
  String get cardComplete => '✓ പൂർത്തിയായി';

  @override
  String cardPercentDaily(int percent) {
    return '$percent% ദൈനംദിനം';
  }

  @override
  String get cardNoDaily => '—';

  @override
  String get cardTodayPrefix => 'ഇന്ന് · ';

  @override
  String cardChants(String count) {
    return '$count ജപങ്ങൾ';
  }

  @override
  String cardMala(int count) {
    return '$count മാല';
  }

  @override
  String cardMalaProgress(int current, int target) {
    return '$current / $target മാല';
  }

  @override
  String cardLifetimePercent(String percent) {
    return 'ആജീവനാന്തം · $percent%';
  }

  @override
  String cardLifetimePercentComplete(String percent) {
    return 'ആജീവനാന്തം · $percent% ✓';
  }

  @override
  String get notifDailyGoalTitle => 'ദൈനംദിന ലക്ഷ്യം നേടി';

  @override
  String get notifDailyGoalBody =>
      'നിങ്ങൾ നിങ്ങളുടെ ദൈനംദിന മന്ത്ര എണ്ണ ലക്ഷ്യത്തിലെത്തി!';

  @override
  String get backupShareSubject => 'മന്ത്ര ജപ കൗണ്ടർ ബാക്കപ്പ്';

  @override
  String get settingsAppearanceTitle => 'രൂപഭാവം';

  @override
  String get settingsAppearanceSub =>
      'സ്ക്രീൻ തെളിച്ചം, നിശ്ചല മോഡ് & ക്ഷേത്ര തീം';

  @override
  String get settingsFeaturesTitle => 'സവിശേഷതകൾ';

  @override
  String get settingsFeaturesSub =>
      'ആപ്പിന്റെ എല്ലാ സവിശേഷതകളും പര്യവേക്ഷണം ചെയ്യുക';

  @override
  String get settingsHelpTitle => 'സഹായവും ഉപയോക്തൃ ഗൈഡുകളും';

  @override
  String get settingsHelpSub =>
      'ഒപ്റ്റിക്കൽ സിങ്ക്, മാല എണ്ണൽ, ബാക്കപ്പ് എന്നിവ എങ്ങനെ പ്രവർത്തിക്കുന്നു';

  @override
  String get settingsAboutSub => 'പതിപ്പ്, ഡെവലപ്പർ വിവരങ്ങൾ & ആത്മീയ ലക്ഷ്യം';

  @override
  String get appearanceTitle => 'രൂപഭാവം';

  @override
  String get appearanceHeaderTitle => 'ക്ഷേത്ര ഭക്തി തീം';

  @override
  String get appearanceHeaderSub =>
      'ഇഷ്ടാനുസൃത നിശ്ചല തെളിച്ചം, പവിത്രമായ ദക്ഷിണേന്ത്യൻ ക്ഷേത്ര വർണ്ണങ്ങൾ, ക്ലാസിക്കൽ ടൈപ്പോഗ്രാഫി.';

  @override
  String get appearanceBrightnessSection => 'സ്ക്രീൻ തെളിച്ചവും നിശ്ചലതയും';

  @override
  String get appearancePaletteSection => 'പവിത്ര ക്ഷേത്ര വർണ്ണങ്ങൾ';

  @override
  String get appearanceTypographySection => 'ടൈപ്പോഗ്രാഫിയും ലിപികളും';

  @override
  String get paletteVermillionName => 'സിന്ദൂരം (Vermillion)';

  @override
  String get paletteVermillionRole =>
      'പ്രധാന ആത്മീയ വർണ്ണം, താമര അടയാളങ്ങൾ, പുരോഗതി';

  @override
  String get paletteTulsiName => 'തുളസി പച്ച';

  @override
  String get paletteTulsiRole => 'ദൈനംദിന ലക്ഷ്യം പൂർത്തിയായി, ശുഭ സൂചകം';

  @override
  String get paletteSandalName => 'ചന്ദനം (Sandalwood)';

  @override
  String get paletteSandalRole => 'ശാന്തമായ അടയാളങ്ങൾ, മണി സൂചകങ്ങൾ';

  @override
  String get paletteRoseName => 'റോസ് ഭക്തി';

  @override
  String get paletteRoseRole => 'സൗമ്യമായ ഭക്തി വർണ്ണം';

  @override
  String get paletteCreamName => 'ക്ഷേത്ര ശ്രീകോവിൽ ക്രീം';

  @override
  String get paletteCreamRole => 'കണ്ണുകൾക്ക് ആശ്വാസം നൽകുന്ന പശ്ചാത്തലം';

  @override
  String get typographySerifTitle => 'EB Garamond (ഭക്തി സെരിഫ്)';

  @override
  String get typographySerifSub =>
      'ക്ലാസിക്കൽ ഇറ്റാലിക് അക്കങ്ങൾ, മാല ആകെത്തുക, ശീർഷകങ്ങൾ';

  @override
  String get typographySansTitle => 'Inter (വ്യക്തമായ UI സാൻസ്)';

  @override
  String get typographySansSub => 'വ്യക്തമായ ലേബലുകൾ, ചരിത്രം, ക്രമീകരണങ്ങൾ';

  @override
  String get typographyMalTitle => 'Noto Sans Malayalam (മലയാള ലിപി)';

  @override
  String get typographyMalSub =>
      'യഥാർത്ഥ മലയാളം മന്ത്ര ശീർഷകങ്ങളും സ്തോത്രങ്ങളും';

  @override
  String get featuresTitle => 'സവിശേഷതകൾ';

  @override
  String get featuresHeaderTitle => 'മന്ത്രജപ കൗണ്ടർ സവിശേഷതകൾ';

  @override
  String get featuresHeaderSub =>
      'നിങ്ങളുടെ ദൈനംദിന സാധനയ്ക്കായി രൂപകൽപ്പന ചെയ്ത എല്ലാ സവിശേഷതകളും അറിയുക.';

  @override
  String get helpHeaderTitle => 'സഹായവും ഉപയോക്തൃ ഗൈഡുകളും';

  @override
  String get helpHeaderSub =>
      'ആപ്പിന്റെ എല്ലാ ഭാഗങ്ങൾക്കുമുള്ള ഗൈഡുകൾ: കൗണ്ടറുകൾ, എണ്ണൽ, മാലയും ലക്ഷ്യങ്ങളും, ചരിത്രം, ശബ്ദം, പ്രദർശനം, ബാക്കപ്പ്, ഒപ്റ്റിക്കൽ സിങ്ക്, സ്വകാര്യത.';

  @override
  String get helpCategoryCounting => 'എണ്ണലും ധ്യാന സാധനയും';

  @override
  String get helpCategorySync => 'ഡാറ്റ സിങ്കും ബാക്കപ്പും';

  @override
  String get helpCategoryAudio => 'ശബ്ദം, പ്രദർശനം, നിശ്ശബ്ദത';

  @override
  String get helpCategoryPrivacy => 'സ്വകാര്യതയും പിന്തുണയും';

  @override
  String get helpTopicCountingTitle => 'എണ്ണലും ആംഗ്യങ്ങളും ഗൈഡ്';

  @override
  String get helpTopicCountingSub =>
      'വൃത്തത്തിനുള്ളിൽ തൊടൽ, രണ്ട് വിരൽ തിരുത്തൽ, എണ്ണൽ മെനു, സ്വയം സേവ്';

  @override
  String get helpTopicMalaTitle => '108 മാല കണക്കുകൂട്ടലും ലക്ഷ്യങ്ങളും';

  @override
  String get helpTopicMalaSub =>
      '108 മണി ചുറ്റുകൾ, അധിക എണ്ണം, ദിവസ ലക്ഷ്യവും ആജീവനാന്ത ലക്ഷ്യവും';

  @override
  String get helpTopicOpticalSyncTitle => 'ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ്പ് സിങ്ക്';

  @override
  String get helpTopicOpticalSyncSub =>
      'ഇന്റർനെറ്റ് ഇല്ലാതെ, ചലിക്കുന്ന QR കോഡ് വഴി ഫോണിൽ നിന്ന് ഫോണിലേക്ക്';

  @override
  String get helpTopicBackupTitle => 'ബാക്കപ്പും പുനഃസ്ഥാപനവും';

  @override
  String get helpTopicBackupSub =>
      'ഫയലിലേക്ക് എക്സ്പോർട്ട്, എൻക്രിപ്റ്റ് ചെയ്ത ബാക്കപ്പ്, ഇംപോർട്ട്, ഡാറ്റ മുഴുവൻ മായ്ക്കൽ';

  @override
  String get helpTopicAudioTitle => 'ശബ്ദവും വൈബ്രേഷനും ക്രമീകരണങ്ങൾ';

  @override
  String get helpTopicAudioSub =>
      'മാല ശബ്ദം, ലക്ഷ്യ ശബ്ദങ്ങൾ, അറിയിപ്പുകൾ, വൈബ്രേഷൻ';

  @override
  String get helpTopicPrivacyTitle => 'സ്വകാര്യതയും ഓഫ്‌ലൈൻ രൂപകൽപ്പനയും';

  @override
  String get helpTopicPrivacySub =>
      'ഇന്റർനെറ്റ് അനുമതിയില്ല, സ്വകാര്യ സംഭരണം, ഉപയോഗിക്കുന്ന അനുമതികൾ';

  @override
  String get helpTopicFaqTitle => 'പതിവുചോദ്യങ്ങളും പരിഹാരങ്ങളും';

  @override
  String get helpTopicFaqSub =>
      'സാധാരണ ചോദ്യങ്ങൾ, സംശയങ്ങൾ, സഹായകരമായ നുറുങ്ങുകൾ';

  @override
  String get helpCountingIntro =>
      'എണ്ണൽ സ്ക്രീൻ ശാന്തമായ ശ്രദ്ധയ്ക്കായി ഉണ്ടാക്കിയതാണ്. ജപിക്കുമ്പോൾ സ്ക്രീനിൽ നോക്കേണ്ടതില്ല.';

  @override
  String get helpCountingTapSection => 'എങ്ങനെ എണ്ണാം';

  @override
  String get helpCountingTapBold1 => 'വൃത്തത്തിനുള്ളിൽ തൊടുക:';

  @override
  String get helpCountingTapBullet1 =>
      'മാലാവൃത്തത്തിനുള്ളിലെ തൊടൽ മാത്രമേ എണ്ണൂ. പുറത്തെ തൊടൽ എണ്ണില്ല, അതിനാൽ അബദ്ധ തൊടൽ എണ്ണം കൂട്ടില്ല.';

  @override
  String get helpCountingTapBold2 => 'ഓരോ തൊടലിലെ എണ്ണം:';

  @override
  String get helpCountingTapBullet2 =>
      'ഓരോ തൊടലിലും കൗണ്ടറിന്റെ എണ്ണം (സാധാരണ 1) കൂടും. കൗണ്ടർ എഡിറ്റ് ചെയ്ത് മാറ്റാം.';

  @override
  String get helpCountingTapBold3 => 'ശാന്തമായ തൊടൽ:';

  @override
  String get helpCountingTapBullet3 =>
      'തൊടലിന് വൈബ്രേഷൻ ഇല്ല. വൈബ്രേഷൻ ഓൺ ആണെങ്കിൽ ഓരോ മാല തീരുമ്പോഴും ലക്ഷ്യത്തിലും തിരുത്തലിലും വൈബ്രേഷൻ ഉണ്ടാകും.';

  @override
  String get helpCountingUndoSection => 'എണ്ണം തിരുത്തൽ';

  @override
  String get helpCountingUndoBold1 => 'രണ്ട് വിരൽ സ്വൈപ്പ്:';

  @override
  String get helpCountingUndoBullet1 =>
      'രണ്ട് വിരലുകൾ വൃത്തത്തിൽ വച്ച് ഇടത്തോട്ടോ വലത്തോട്ടോ നീക്കുക. ഒരു സ്വൈപ്പിൽ ഒരു എണ്ണം കുറയും, ഫോൺ ഒരിക്കൽ വൈബ്രേറ്റ് ചെയ്യും.';

  @override
  String get helpCountingUndoBold2 => 'പൂജ്യത്തിലേക്ക്:';

  @override
  String get helpCountingUndoBullet2 =>
      'സെഷൻ എണ്ണം 0 ആയാൽ ആ ഇരിപ്പ് മായ്ക്കും, ചരിത്രത്തിൽ ഒന്നും ചേർക്കില്ല.';

  @override
  String get helpMalaIntro =>
      'പരമ്പരാഗത ജപമാലയിൽ 108 മണികളുണ്ട്. ആപ്പ് 108-ന്റെ ചുറ്റുകളായി എണ്ണുന്നു, ഓരോ കാർഡിലും ലക്ഷ്യങ്ങൾ കാണിക്കുന്നു.';

  @override
  String get helpMalaBeadsSection => '108 മണികൾ';

  @override
  String get helpMalaBeadsBold1 => '1 മാല = 108 എണ്ണം:';

  @override
  String get helpMalaBeadsBullet1 =>
      'ഓരോ 108 എണ്ണവും ഒരു മുഴുവൻ മാല. എണ്ണൽ സ്ക്രീനിലെ വൃത്തം മണി മണിയായി നിറയും, 108-ന് ശേഷം വീണ്ടും തുടങ്ങും.';

  @override
  String get helpMalaBeadsBold2 => 'അധിക എണ്ണം:';

  @override
  String get helpMalaBeadsBullet2 =>
      'മുഴുവൻ മാലയ്ക്ക് ശേഷമുള്ള എണ്ണം സൂക്ഷിച്ച് കാണിക്കും. ഉദാഹരണം: 115 എണ്ണം = 1 മാലയും 7 എണ്ണവും.';

  @override
  String get helpMalaBeadsBold3 => 'വലിയ എണ്ണം:';

  @override
  String get helpMalaBeadsBullet3 =>
      'ഓരോ തൊടലിലെ എണ്ണം 1-ൽ കൂടുതലാണെങ്കിൽ, ഒരു തൊടലിൽ പല മണികൾ നീങ്ങും. മാലകൾ ആകെ എണ്ണത്തിൽ നിന്ന് തന്നെ കണക്കാക്കും.';

  @override
  String get helpMalaGoalsSection => 'ദിവസ ലക്ഷ്യവും ആജീവനാന്ത ലക്ഷ്യവും';

  @override
  String get helpMalaGoalsBold1 => 'ദിവസ ലക്ഷ്യം:';

  @override
  String get helpMalaGoalsBullet1 =>
      'ഓരോ ദിവസവും ജപിക്കാൻ ആഗ്രഹിക്കുന്ന എണ്ണം (0 = ദിവസ ലക്ഷ്യമില്ല). ഫോണിലെ സമയം അനുസരിച്ച് അർദ്ധരാത്രിയിൽ 0-ൽ നിന്ന് വീണ്ടും തുടങ്ങും.';

  @override
  String get helpMalaGoalsBold2 => 'ആജീവനാന്ത ലക്ഷ്യം (സങ്കല്പം):';

  @override
  String get helpMalaGoalsBullet2 =>
      'ദീർഘകാല ലക്ഷ്യം, ഉദാഹരണം 1,00,000 ജപം (0 = ആജീവനാന്ത ലക്ഷ്യമില്ല). ദിവസ ലക്ഷ്യം ഇതിനേക്കാൾ കൂടരുത്.';

  @override
  String get helpOpticalIntro =>
      'ഒപ്റ്റിക്കൽ സിങ്ക് സ്ക്രീനും ക്യാമറയും മാത്രം ഉപയോഗിച്ച് കൗണ്ടറുകളും ചരിത്രവും ഒരു ഫോണിൽ നിന്ന് മറ്റൊന്നിലേക്ക് മാറ്റുന്നു. ഇന്റർനെറ്റ്, വൈ-ഫൈ, ബ്ലൂടൂത്ത്, കേബിൾ ഒന്നും വേണ്ട.';

  @override
  String get helpOpticalHowSection => 'എങ്ങനെ മാറ്റാം';

  @override
  String get helpOpticalHowBold1 => 'അയയ്ക്കുന്ന ഫോൺ:';

  @override
  String get helpOpticalHowBullet1 =>
      'ക്രമീകരണങ്ങൾ → ഡാറ്റ ബാക്കപ്പും ഒപ്റ്റിക്കൽ സിങ്കും → ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ് സിങ്ക് (അയയ്ക്കുക). അയയ്ക്കേണ്ട കൗണ്ടറുകൾ തിരഞ്ഞെടുക്കുക. ചലിക്കുന്ന QR കോഡ് തുടങ്ങും.';

  @override
  String get helpOpticalHowBold2 => 'സ്വീകരിക്കുന്ന ഫോൺ:';

  @override
  String get helpOpticalHowBullet2 =>
      'ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ് സിങ്ക് (സ്വീകരിക്കുക) തുറന്ന് ക്യാമറ അനുവദിച്ച് അയയ്ക്കുന്ന ഫോണിന്റെ സ്ക്രീനിലേക്ക് പിടിക്കുക.';

  @override
  String get helpOpticalHowBold3 => 'പ്രിവ്യൂ:';

  @override
  String get helpOpticalHowBullet3 =>
      'എല്ലാ ഭാഗങ്ങളും എത്തുമ്പോൾ കൗണ്ടറുകളും സെഷനുകളും കാണിക്കുന്ന പ്രിവ്യൂ വരും. സൂക്ഷിക്കേണ്ട കൗണ്ടറുകൾ തിരഞ്ഞെടുത്ത് പുനഃസ്ഥാപിക്കൽ ബട്ടൺ തൊടുക.';

  @override
  String get helpOpticalTipsSection => 'വേഗത്തിൽ സ്കാൻ ചെയ്യാൻ';

  @override
  String get helpOpticalTipsBold1 => 'അകലം:';

  @override
  String get helpOpticalTipsBullet1 =>
      'സ്വീകരിക്കുന്ന ഫോൺ അയയ്ക്കുന്ന സ്ക്രീനിൽ നിന്ന് ഏകദേശം 15–25 സെ.മീ. അകലെ, കോഡ് ഗൈഡ് ബോക്സിനുള്ളിൽ വരുന്ന രീതിയിൽ ഇളകാതെ പിടിക്കുക.';

  @override
  String get helpOpticalTipsBold2 => 'പ്രതിഫലനം:';

  @override
  String get helpOpticalTipsBullet2 =>
      'അയയ്ക്കുന്ന സ്ക്രീനിൽ തിളക്കമുള്ള പ്രതിഫലനം ഒഴിവാക്കുക.';

  @override
  String get helpOpticalTipsBold3 => 'നഷ്ടപ്പെട്ട ഫ്രെയിമുകൾ:';

  @override
  String get helpOpticalTipsBullet3 =>
      'ചില ഫ്രെയിമുകൾ നഷ്ടപ്പെട്ടാലും കുഴപ്പമില്ല. അധിക മിശ്ര ഫ്രെയിമുകളോടെ സ്ട്രീം ആവർത്തിക്കുന്നതിനാൽ നഷ്ടപ്പെട്ട ഭാഗങ്ങൾ വീണ്ടും ഉണ്ടാക്കും.';

  @override
  String get helpAudioIntro =>
      'ശബ്ദവും സ്പന്ദനവും പ്രധാന നിമിഷങ്ങൾ അറിയിക്കുന്നു: ഓരോ മാലയും ഓരോ ലക്ഷ്യവും. ക്രമീകരണങ്ങൾ → ശബ്ദവും സ്പന്ദനവും എന്നതിൽ ഇവ സജ്ജമാക്കാം.';

  @override
  String get helpAudioVibrationSection => 'വൈബ്രേഷൻ';

  @override
  String get helpAudioVibrationBold1 => 'എപ്പോൾ വൈബ്രേറ്റ് ചെയ്യും:';

  @override
  String get helpAudioVibrationBullet1 =>
      'ഓരോ മാലയിലും ഒരു സ്പന്ദനം, ലക്ഷ്യം എത്തുമ്പോൾ മൂന്ന് സ്പന്ദനം, തിരുത്തുമ്പോൾ ചെറിയ ഒന്ന്.';

  @override
  String get helpAudioVibrationBold2 => 'ഓഫ് ചെയ്യാൻ:';

  @override
  String get helpAudioVibrationBullet2 =>
      'പൂർണ്ണ നിശബ്ദ സാധനയ്ക്ക് ക്രമീകരണങ്ങൾ → ശബ്ദവും സ്പന്ദനവും എന്നതിൽ വൈബ്രേഷൻ ഓഫ് ചെയ്യുക.';

  @override
  String get helpBackupIntro =>
      'നിങ്ങളുടെ ഡാറ്റ നിങ്ങളുടേതാണ്. എപ്പോൾ വേണമെങ്കിലും ഫയലിലേക്ക് സേവ് ചെയ്ത് ഈ ഫോണിലോ പുതിയ ഫോണിലോ പുനഃസ്ഥാപിക്കാം.';

  @override
  String get helpBackupExportSection => 'ബാക്കപ്പ് എക്സ്പോർട്ട് ചെയ്യൽ';

  @override
  String get helpBackupExportBold1 => 'ഒരു ഫയൽ:';

  @override
  String get helpBackupExportBullet1 =>
      'എല്ലാ കൗണ്ടറുകളും ലക്ഷ്യങ്ങളും സെഷൻ ചരിത്രവും ഒരു ബാക്കപ്പ് ഫയലിൽ.';

  @override
  String get helpBackupExportBold2 => 'എൻക്രിപ്റ്റ് (ഐച്ഛികം):';

  @override
  String get helpBackupExportBullet2 =>
      'പാസ്ഫ്രേസ് ഉപയോഗിച്ച് ഫയൽ സംരക്ഷിക്കാം. ശക്തമായ AES-256-GCM എൻക്രിപ്ഷൻ കൊണ്ട് പൂട്ടും.';

  @override
  String get helpBackupExportBold3 => 'പാസ്ഫ്രേസ് സൂക്ഷിക്കുക:';

  @override
  String get helpBackupExportBullet3 =>
      'മറന്ന പാസ്ഫ്രേസ് തിരികെ കിട്ടില്ല, അതില്ലാതെ ഫയൽ തുറക്കാനാവില്ല.';

  @override
  String get helpBackupImportSection => 'ബാക്കപ്പ് പുനഃസ്ഥാപിക്കൽ';

  @override
  String get helpBackupImportBold1 => 'ഫയൽ തിരഞ്ഞെടുക്കുക:';

  @override
  String get helpBackupImportBullet1 =>
      'ഇംപോർട്ട് തിരഞ്ഞെടുത്ത് സിസ്റ്റം ഫയൽ പിക്കറിൽ ബാക്കപ്പ് ഫയൽ തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpBackupImportBold2 => 'എല്ലാ ഡാറ്റയും മാറ്റും:';

  @override
  String get helpBackupImportBullet2 =>
      'ഇംപോർട്ട് ഇപ്പോഴത്തെ എല്ലാ കൗണ്ടറുകളും ചരിത്രവും ഫയലിലെ ഡാറ്റ കൊണ്ട് മാറ്റും. ഫോണിലുള്ളത് സൂക്ഷിക്കണമെങ്കിൽ ആദ്യം എക്സ്പോർട്ട് ചെയ്യുക.';

  @override
  String get helpBackupImportBold3 => 'എൻക്രിപ്റ്റ് ചെയ്ത ഫയലുകൾ:';

  @override
  String get helpBackupImportBullet3 =>
      'ഫയൽ എൻക്രിപ്റ്റ് ചെയ്തതാണെങ്കിൽ പാസ്ഫ്രേസ് ചോദിക്കും.';

  @override
  String get helpPrivacyIntro =>
      'SreerajP MantraJapa Counter സ്വകാര്യതയ്ക്കായി രൂപകൽപ്പന ചെയ്തതാണ്. നിങ്ങളുടെ സാധന നിങ്ങളുടെ ഫോണിൽ തന്നെ.';

  @override
  String get helpPrivacyOfflineSection => 'പൂർണ്ണമായി ഓഫ്‌ലൈൻ';

  @override
  String get helpPrivacyOfflineBold1 => 'ഇന്റർനെറ്റ് അനുമതിയില്ല:';

  @override
  String get helpPrivacyOfflineBullet1 =>
      'ആപ്പിന് ആൻഡ്രോയിഡ് ഇന്റർനെറ്റ് അനുമതിയില്ല, അതിനാൽ ഒന്നും എവിടേക്കും അയയ്ക്കാനാവില്ല.';

  @override
  String get helpPrivacyOfflineBold2 => 'നിരീക്ഷണമില്ല:';

  @override
  String get helpPrivacyOfflineBullet2 =>
      'അനലിറ്റിക്സോ ക്രാഷ് റിപ്പോർട്ടറോ പരസ്യമോ ഇല്ല.';

  @override
  String get helpPrivacyOfflineBold3 => 'അക്കൗണ്ട് വേണ്ട:';

  @override
  String get helpPrivacyOfflineBullet3 =>
      'ഒരിക്കലും സൈൻ അപ്പ് ചെയ്യുകയോ ഇമെയിലോ ഫോൺ നമ്പറോ നൽകുകയോ വേണ്ട.';

  @override
  String get helpPrivacyStorageSection => 'ഡാറ്റ എവിടെ സൂക്ഷിക്കുന്നു';

  @override
  String get helpPrivacyStorageBold1 => 'നിങ്ങളുടെ ഫോണിൽ മാത്രം:';

  @override
  String get helpPrivacyStorageBullet1 =>
      'കൗണ്ടറുകളും ചരിത്രവും ഫോണിലെ ആപ്പിന്റെ സ്വകാര്യ സംഭരണിയിൽ സൂക്ഷിക്കുന്നു. മറ്റ് ആപ്പുകൾക്ക് അത് വായിക്കാനാവില്ല.';

  @override
  String get helpPrivacyStorageBold2 => 'ക്ലൗഡ് ബാക്കപ്പ് ഇല്ല:';

  @override
  String get helpPrivacyStorageBullet2 =>
      'ഈ ആപ്പിന് ആൻഡ്രോയിഡിന്റെ സ്വയം ക്ലൗഡ് ബാക്കപ്പ് ഓഫ് ആണ്. പകർപ്പ് സൂക്ഷിക്കാൻ എക്സ്പോർട്ട് അല്ലെങ്കിൽ ഒപ്റ്റിക്കൽ സിങ്ക് ഉപയോഗിക്കുക.';

  @override
  String get helpFaqIntro => 'സാധാരണ ചോദ്യങ്ങൾക്ക് ചുരുങ്ങിയ ഉത്തരങ്ങൾ.';

  @override
  String get helpFaqQ1Title => 'എന്റെ തൊടൽ എന്തുകൊണ്ട് എണ്ണിയില്ല?';

  @override
  String get helpFaqQ1Answer =>
      'മാലാവൃത്തത്തിനുള്ളിലെ തൊടൽ മാത്രമേ എണ്ണൂ. മേരു വിരാമം ഓൺ ആണെങ്കിൽ, ഓരോ മാലയ്ക്കും ശേഷമുള്ള ചെറിയ വിരാമ സമയത്തെ തൊടലും എണ്ണില്ല.';

  @override
  String get helpFaqQ2Title => 'തെറ്റായ എണ്ണം എങ്ങനെ തിരുത്താം?';

  @override
  String get helpFaqQ2Answer =>
      'രണ്ട് വിരലുകൾ മാലാവൃത്തത്തിൽ വച്ച് ഇടത്തോട്ടോ വലത്തോട്ടോ നീക്കുക. ഓരോ സ്വൈപ്പിലും ഒരു എണ്ണം കുറയും.';

  @override
  String get helpFaqQ3Title => 'എന്റെ കൗണ്ടർ എന്തുകൊണ്ട് തുറക്കുന്നില്ല?';

  @override
  String get helpFaqQ3Answer =>
      'അത് ലോക്ക് ചെയ്തതോ നിർത്തിയതോ ആകാം. അൺലോക്ക് ചെയ്യാൻ കാർഡിലെ പൂട്ട് ഐക്കൺ തൊടുക. നിർത്തിയ കൗണ്ടറുകൾ എണ്ണാനായി തുറക്കില്ല.';

  @override
  String get helpFaqQ4Title => 'മാലയുടെ നടുവിൽ നിർത്തിയാൽ എന്ത് സംഭവിക്കും?';

  @override
  String get helpFaqQ4Answer =>
      'ഒന്നും നഷ്ടപ്പെടില്ല. എണ്ണം സേവ് ആകും, മറ്റൊരു ദിവസമായാലും അടുത്ത തവണ ആ മാല കാത്തിരിക്കും. 0-ൽ നിന്ന് തുടങ്ങണമെങ്കിൽ \'പുതിയത് തുടങ്ങുക\' തൊടുക.';

  @override
  String get lockCounter => 'കൗണ്ടർ ലോക്ക് ചെയ്യുക';

  @override
  String get unlockCounter => 'കൗണ്ടർ അൺലോക്ക് ചെയ്യുക';

  @override
  String counterLockedNotice(String name) {
    return '\"$name\" ലോക്ക് ചെയ്‌തിരിക്കുന്നു. ജപിക്കാൻ അൺലോക്ക് ചെയ്യുക.';
  }

  @override
  String get counterLockedTooltip =>
      'ലോക്ക് ചെയ്‌തിരിക്കുന്നു — അൺലോക്ക് ചെയ്യാൻ അമർത്തുക';

  @override
  String get counterUnlockedTooltip =>
      'അൺലോക്ക് ചെയ്‌തിരിക്കുന്നു — ലോക്ക് ചെയ്യാൻ അമർത്തുക';

  @override
  String get statusLocked => 'ലോക്ക് ചെയ്‌തു';

  @override
  String get settingsBackupTitle => 'ഡാറ്റ ബാക്കപ്പും ഒപ്റ്റിക്കൽ സിങ്കും';

  @override
  String get settingsBackupSub =>
      '100% ഓഫ്‌ലൈൻ ഉപകരണങ്ങൾ തമ്മിലുള്ള സിങ്കും ബാക്കപ്പും';

  @override
  String get settingsOpticalSendTitle =>
      'ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ് സിങ്ക് (അയയ്ക്കുക)';

  @override
  String get settingsOpticalSendSub =>
      'ആനിമേറ്റഡ് QR സ്ട്രീം വഴി കൗണ്ടറുകളും ചരിത്രവും കൈമാറുക';

  @override
  String get settingsOpticalReceiveTitle =>
      'ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ് സിങ്ക് (സ്വീകരിക്കുക)';

  @override
  String get settingsOpticalReceiveSub =>
      'മറ്റൊരു ഫോണിന്റെ സ്ക്രീനിലെ ആനിമേറ്റഡ് QR സ്ട്രീം സ്കാൻ ചെയ്യുക';

  @override
  String get settingsExportTitle => 'ബാക്കപ്പ് ഫയൽ എക്സ്പോർട്ട് ചെയ്യുക (JSON)';

  @override
  String get settingsExportSub =>
      'എല്ലാ ഡാറ്റയും ഒരു ലോക്കൽ JSON ഫയലിലേക്ക് എക്സ്പോർട്ട് ചെയ്ത് പങ്കിടുക';

  @override
  String get settingsImportTitle => 'ബാക്കപ്പ് ഫയൽ ഇംപോർട്ട് ചെയ്യുക (JSON)';

  @override
  String get settingsImportSub =>
      'ബാക്കപ്പ് ഫയലിൽ നിന്ന് കൗണ്ടറുകളും ചരിത്രവും പുനഃസ്ഥാപിക്കുക';

  @override
  String get dataRestoredSuccess => 'ഡാറ്റ വിജയകരമായി പുനഃസ്ഥാപിച്ചു!';

  @override
  String get opticalSendTitle => 'ഒപ്റ്റിക്കൽ സിങ്ക് സ്ട്രീം (അയയ്ക്കുക)';

  @override
  String get opticalReceiveTitle => 'ഒപ്റ്റിക്കൽ സിങ്ക് റിസീവർ (സ്കാൻ)';

  @override
  String get opticalNoFrames => 'ഡാറ്റ ഫ്രെയിമുകളൊന്നും ഉണ്ടാക്കിയിട്ടില്ല.';

  @override
  String opticalSessionId(String id) {
    return 'സെഷൻ ഐഡി: $id';
  }

  @override
  String opticalFrameCounter(int current) {
    return 'ഫ്രെയിം $current';
  }

  @override
  String opticalFramesReceived(int count) {
    return 'ലഭിച്ച ഫ്രെയിമുകൾ: $count';
  }

  @override
  String opticalSystematicChunk(int index) {
    return 'സിസ്റ്റമാറ്റിക് ഡാറ്റ ചങ്ക് #$index';
  }

  @override
  String opticalParityFrame(int index) {
    return 'ഫൗണ്ടൻ പാരിറ്റി ഫ്രെയിം #$index';
  }

  @override
  String get opticalStreamRate => 'സ്ട്രീം വേഗത (FPS)';

  @override
  String get opticalSendHint =>
      'സ്വീകരിക്കുന്ന ഉപകരണത്തിന്റെ ക്യാമറ ഈ സ്ക്രീനിലേക്ക് ചൂണ്ടുക. ആനിമേറ്റഡ് QR സ്ട്രീം എല്ലാ കൗണ്ടറുകളും സെഷൻ ചരിത്രവും 100% ഓഫ്‌ലൈനായി കൈമാറും.';

  @override
  String opticalReconstructing(int done, int total) {
    return 'പുനർനിർമ്മിക്കുന്നു: $done / $total ചങ്കുകൾ';
  }

  @override
  String get opticalAlignCamera =>
      'ക്യാമറ ആനിമേറ്റഡ് QR സ്ട്രീമിലേക്ക് ചേർത്തുവയ്ക്കുക...';

  @override
  String get opticalStreamComplete => 'ഒപ്റ്റിക്കൽ സിങ്ക് സ്ട്രീം പൂർത്തിയായി';

  @override
  String get opticalStatCounters => 'കൗണ്ടറുകൾ';

  @override
  String get opticalStatSessionLogs => 'സെഷൻ രേഖകൾ';

  @override
  String get opticalImportRestore => 'ഡാറ്റ ഇംപോർട്ട് ചെയ്ത് പുനഃസ്ഥാപിക്കുക';

  @override
  String get opticalImportSuccess =>
      'ഒപ്റ്റിക്കൽ സിങ്ക് ഇംപോർട്ട് വിജയകരം! ഡാറ്റ പുനഃസ്ഥാപിച്ചു.';

  @override
  String get opticalImportFailed => 'ഡാറ്റ ഇംപോർട്ട് ചെയ്യാൻ കഴിഞ്ഞില്ല.';

  @override
  String get featCat1Name => 'പവിത്ര ജപവും മാല എണ്ണവും';

  @override
  String get featCat1Sub =>
      'ശ്രദ്ധ പതറാത്ത ജപം, 108 മാല ഗണിതം, സുഗമമായ ആംഗ്യങ്ങൾ';

  @override
  String get featCat2Name => 'ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ് സിങ്കും ഡാറ്റ സുരക്ഷയും';

  @override
  String get featCat2Sub =>
      'ക്യാമറയും QR സ്ട്രീമിംഗും വഴി 100% ഓഫ്‌ലൈൻ ഉപകരണ സിങ്ക്';

  @override
  String get featCat3Name => 'സാധന വിശകലനവും ചരിത്രവും';

  @override
  String get featCat3Sub =>
      'വിശദമായ ദൈനംദിന രേഖകൾ, തുടർച്ചാ കണക്ക്, കൗണ്ടർ തിരിച്ചുള്ള വിവരണം';

  @override
  String get featCat4Name => 'ക്ഷേത്ര ഭംഗി, ശബ്ദം, സ്പർശന പ്രതികരണം';

  @override
  String get featCat4Sub =>
      'ശാന്തമായ ഭക്തി വർണ്ണങ്ങൾ, മണിനാദങ്ങൾ, മലയാളം പിന്തുണ';

  @override
  String get featCat5Name => 'സ്വകാര്യതയും ഓഫ്‌ലൈൻ-ആദ്യ രൂപകൽപ്പനയും';

  @override
  String get featCat5Sub =>
      'ക്ലൗഡ് ട്രാക്കിംഗ് ഇല്ല, നെറ്റ്‌വർക്ക് അഭ്യർത്ഥനകൾ ഇല്ല, പൂർണ്ണ ഡാറ്റ സ്വകാര്യത';

  @override
  String get featMalaTitle => '108 മാല മണി കണക്ക്';

  @override
  String get featMalaDesc =>
      'പൂർത്തിയായ മാലകൾ (1 മാല = 108 ജപം) സ്വയമേവ കണക്കാക്കുകയും ബാക്കി എണ്ണവും പുരോഗതി വളയങ്ങളും രേഖപ്പെടുത്തുകയും ചെയ്യുന്നു.';

  @override
  String get featMalaH1 => '108 മണി സൂത്രം';

  @override
  String get featMalaH2 => 'ബാക്കി എണ്ണ കൗണ്ടർ';

  @override
  String get featMalaH3 => 'മാല പൂർത്തിയാകുമ്പോൾ മണിനാദം';

  @override
  String get featImmersionTitle => 'പൂർണ്ണ സ്ക്രീൻ ലയനവും ടാപ്പ് ഇടവും';

  @override
  String get featImmersionDesc =>
      'പ്രത്യേക ബട്ടണുകൾ നോക്കേണ്ട ആവശ്യമില്ലാതെ, വലിയ പവിത്ര വളയത്തിൽ എവിടെയും ടാപ്പ് ചെയ്ത് എണ്ണം എളുപ്പത്തിൽ കൂട്ടാം.';

  @override
  String get featImmersionH1 => 'വിശാലമായ സ്പർശന ഇടം';

  @override
  String get featImmersionH2 => 'മൃദുവായ സ്പർശന പ്രതികരണം';

  @override
  String get featImmersionH3 => 'ശ്രദ്ധ പതറാത്ത ഏകാഗ്രത';

  @override
  String get featUndoTitle => 'രണ്ട് വിരൽ സ്വൈപ്പ് പിൻവലിക്കൽ';

  @override
  String get featUndoDesc =>
      'അബദ്ധത്തിൽ എണ്ണിയോ? വളയത്തിൽ രണ്ട് വിരലുകൊണ്ട് ഇടത്തോട്ടോ വലത്തോട്ടോ സ്വൈപ്പ് ചെയ്ത് എണ്ണം കുറയ്ക്കാം.';

  @override
  String get featUndoH1 => 'തിരശ്ചീന സ്വൈപ്പ് ആംഗ്യം';

  @override
  String get featUndoH2 => 'ഉടനടി എണ്ണം പിൻവലിക്കൽ';

  @override
  String get featUndoH3 => 'അധികം എണ്ണുന്നത് തടയുന്നു';

  @override
  String get featTimerTitle => 'സ്ഥിരമായ സെഷൻ ടൈമറും ലക്ഷ്യങ്ങളും';

  @override
  String get featTimerDesc =>
      'സ്വയമേവ താൽക്കാലികമായി നിർത്തുന്ന സൗകര്യത്തോടെ ഇരിപ്പിന്റെ സമയം രേഖപ്പെടുത്തുന്നു. ഓരോ മന്ത്രത്തിനും ദൈനംദിന ലക്ഷ്യങ്ങളും ജീവിതകാല സമർപ്പണ ലക്ഷ്യങ്ങളും ക്രമീകരിക്കാം.';

  @override
  String get featTimerH1 => 'സജീവ സമയ ടൈമർ';

  @override
  String get featTimerH2 => 'മന്ത്രം തിരിച്ചുള്ള ദൈനംദിന ലക്ഷ്യം';

  @override
  String get featTimerH3 => 'ജീവിതകാല സമർപ്പണ ലക്ഷ്യം';

  @override
  String get featQrStreamTitle => 'ഉയർന്ന സാന്ദ്രതയുള്ള ആനിമേറ്റഡ് QR സ്ട്രീം';

  @override
  String get featQrStreamDesc =>
      'അതിവേഗ ഒപ്റ്റിക്കൽ QR കോഡ് സ്ട്രീം ഉപയോഗിച്ച് സാധന രേഖകളും കൗണ്ടറുകളും ചരിത്രവും സെക്കൻഡുകൾക്കുള്ളിൽ ഫോണുകൾക്കിടയിൽ കൈമാറാം.';

  @override
  String get featQrStreamH1 => 'Wi-Fi / ബ്ലൂടൂത്ത് ആവശ്യമില്ല';

  @override
  String get featQrStreamH2 => '10-15 FPS ആനിമേറ്റഡ് സ്ട്രീം';

  @override
  String get featQrStreamH3 => 'തൽക്ഷണ ഫോൺ കൈമാറ്റം';

  @override
  String get featFountainTitle => 'ലൂബി ട്രാൻസ്ഫോം ഫൗണ്ടൻ കോഡ് വീണ്ടെടുക്കൽ';

  @override
  String get featFountainDesc =>
      'ഗണിതശാസ്ത്ര ഫൗണ്ടൻ കോഡുകളും CRC32 പരിശോധനയും ഉപയോഗിക്കുന്നതിനാൽ നഷ്ടപ്പെട്ട ക്യാമറ ഫ്രെയിമുകൾ സ്വയമേവ വീണ്ടെടുക്കുന്നു.';

  @override
  String get featFountainH1 => 'നഷ്ടം സഹിക്കുന്ന വീണ്ടെടുക്കൽ';

  @override
  String get featFountainH2 => 'CRC32 പരിശോധനാ സംഖ്യകൾ';

  @override
  String get featFountainH3 => 'ക്രമം തെറ്റിയ ഫ്രെയിം കൂട്ടിച്ചേർക്കൽ';

  @override
  String get featJsonExportTitle => 'ഓഫ്‌ലൈൻ JSON എക്സ്പോർട്ടും പുനഃസ്ഥാപനവും';

  @override
  String get featJsonExportDesc =>
      'പൂർണ്ണ ഡാറ്റാബേസ് ബാക്കപ്പ് ഒരു സാധാരണ JSON ഫയലിലേക്ക് എക്സ്പോർട്ട് ചെയ്ത് ഉപകരണത്തിൽ സൂക്ഷിക്കാം, പങ്കിടാം, എപ്പോൾ വേണമെങ്കിലും പുനഃസ്ഥാപിക്കാം.';

  @override
  String get featJsonExportH1 => 'സാധാരണ JSON ഘടന';

  @override
  String get featJsonExportH2 => 'ഒറ്റ ടാപ്പ് എക്സ്പോർട്ട്/ഇംപോർട്ട്';

  @override
  String get featJsonExportH3 => 'Room/Gson അനുയോജ്യത';

  @override
  String get featDailyLogTitle => 'ദൈനംദിന സാധന രേഖയും വിവരണവും';

  @override
  String get featDailyLogDesc =>
      'തീയതി അനുസരിച്ച് ക്രമീകരിച്ച പഴയ ഇരിപ്പുകൾ, ആരംഭ സമയം, ഇരിപ്പിന്റെ ദൈർഘ്യം, ജപിച്ച എണ്ണം, പൂർത്തിയായ മാലകൾ എന്നിവ സഹിതം കാണാം.';

  @override
  String get featDailyLogH1 => 'തീയതി തിരിച്ചുള്ള ക്രമീകരണം';

  @override
  String get featDailyLogH2 => 'ഇരിപ്പ് സമയ വിവരണം';

  @override
  String get featDailyLogH3 => 'ദൈനംദിന മാല കണക്ക്';

  @override
  String get featFilterTitle => 'കൗണ്ടർ തിരിച്ചുള്ള അരിച്ചെടുക്കൽ';

  @override
  String get featFilterDesc =>
      'ഓരോ മന്ത്രത്തിന്റെയും ചരിത്രം പ്രത്യേകം കാണാം, അല്ലെങ്കിൽ എല്ലാ സജീവ കൗണ്ടറുകളുടെയും സംയുക്ത സാധന കാണാം.';

  @override
  String get featFilterH1 => 'പ്രത്യേക മന്ത്ര കാഴ്ച';

  @override
  String get featFilterH2 => 'സംയുക്ത ദൈനംദിന കാഴ്ച';

  @override
  String get featFilterH3 => 'ജീവിതകാല ആകെത്തുക';

  @override
  String get featPaletteTitle => 'ക്ഷേത്ര ഭക്തി വർണ്ണനിര';

  @override
  String get featPaletteDesc =>
      'പവിത്രമായ ക്രീം പശ്ചാത്തലവും സിന്ദൂരം, ചന്ദന മഞ്ഞ, തുളസി പച്ച, റോസ് നിറങ്ങളും ചേർന്ന ആധികാരിക ക്ഷേത്ര വർണ്ണനിര.';

  @override
  String get featPaletteH1 => 'ക്രീം, സ്വർണ്ണ പശ്ചാത്തലം';

  @override
  String get featPaletteH2 => 'സിന്ദൂര, തുളസി നിറങ്ങൾ';

  @override
  String get featPaletteH3 => 'സെരിഫ് അക്ക അക്ഷരവിന്യാസം';

  @override
  String get featBellTitle => 'ശാന്തമായ മണിനാദങ്ങളും ശബ്ദ തിരഞ്ഞെടുപ്പും';

  @override
  String get featBellDesc =>
      'മാല പൂർത്തിയാകുമ്പോഴോ ദൈനംദിന ലക്ഷ്യത്തിലെത്തുമ്പോഴോ മൃദുവായ ധ്യാന നാദം. സിസ്റ്റം റിംഗ്ടോണുകൾ തിരഞ്ഞെടുക്കാം അല്ലെങ്കിൽ സ്വന്തം ശബ്ദ ഫയലുകൾ ഉപയോഗിക്കാം.';

  @override
  String get featBellH1 => 'മാല, ലക്ഷ്യ മണിനാദങ്ങൾ';

  @override
  String get featBellH2 => 'സ്വന്തം ശബ്ദ തിരഞ്ഞെടുപ്പ്';

  @override
  String get featBellH3 => 'ക്രമീകരണങ്ങളിൽ നാദ പരിശോധന';

  @override
  String get featBrightnessTitle => 'നിശ്ചലതാ പ്രകാശ രീതി';

  @override
  String get featBrightnessDesc =>
      'അതിരാവിലെ, ക്ഷേത്രത്തിൽ, അല്ലെങ്കിൽ രാത്രി വൈകിയുള്ള ധ്യാനത്തിന് ശ്രദ്ധ പതറാതിരിക്കാൻ സ്ക്രീൻ പ്രകാശം കുറയ്ക്കുന്നു.';

  @override
  String get featBrightnessH1 => 'സ്വന്തം പ്രകാശ സ്ലൈഡർ';

  @override
  String get featBrightnessH2 => 'ഒറ്റ ടാപ്പിൽ പഴയപടിയാക്കൽ';

  @override
  String get featBrightnessH3 => 'OLED ബാറ്ററി ലാഭം';

  @override
  String get featBilingualTitle => 'മലയാളം, ഇംഗ്ലീഷ് ദ്വിഭാഷാ ഇന്റർഫേസ്';

  @override
  String get featBilingualDesc =>
      'Noto Sans Malayalam ഫോണ്ടുകൾ ഉൾപ്പെടുത്തി ഇംഗ്ലീഷിനൊപ്പം പൂർണ്ണ മലയാളം ലിപിയും ഇന്റർഫേസ് പിന്തുണയും.';

  @override
  String get featBilingualH1 => 'പൂർണ്ണ മലയാളം പരിഭാഷ';

  @override
  String get featBilingualH2 => 'ആധികാരിക ഇന്ത്യൻ ലിപി അക്ഷരങ്ങൾ';

  @override
  String get featBilingualH3 => 'ഒറ്റ ടാപ്പിൽ ഭാഷ മാറ്റം';

  @override
  String get featOfflineTitle => 'INTERNET അനുമതിയില്ലാതെ 100% ഓഫ്‌ലൈൻ';

  @override
  String get featOfflineDesc =>
      'ആപ്പിന്റെ മാനിഫെസ്റ്റിൽ ഇന്റർനെറ്റ് അനുമതി ഒട്ടുമില്ല. ടെലിമെട്രിയോ പരസ്യങ്ങളോ അനലിറ്റിക്സോ ഒരിക്കലും പ്രവർത്തിക്കില്ല.';

  @override
  String get featOfflineH1 => 'INTERNET അനുമതിയില്ല';

  @override
  String get featOfflineH2 => 'ക്ലൗഡ് ടെലിമെട്രി ഇല്ല';

  @override
  String get featOfflineH3 => 'ട്രാക്കിംഗോ പരസ്യങ്ങളോ ഇല്ല';

  @override
  String get featSqliteTitle =>
      'ലോക്കൽ SQLite ഡാറ്റാബേസും തകരാർ വീണ്ടെടുക്കലും';

  @override
  String get featSqliteDesc =>
      'ഫോൺ പുനരാരംഭിക്കുമ്പോൾ ഡാറ്റ നഷ്ടപ്പെടാതിരിക്കാൻ ഇരട്ട പാളി സംഭരണം ഓരോ 5 ടാപ്പിലും 5 സെക്കൻഡിലും എണ്ണം സൂക്ഷിക്കുന്നു.';

  @override
  String get featSqliteH1 => 'ACID അനുസരിക്കുന്ന SQLite v3';

  @override
  String get featSqliteH2 => '5 ടാപ്പ് തകരാർ വീണ്ടെടുക്കൽ';

  @override
  String get featSqliteH3 => 'സുരക്ഷിത ഡാറ്റ മൈഗ്രേഷൻ';

  @override
  String get opticalStreamCompleteSub =>
      'ക്യാമറ സ്കാനർ വഴി 100% ഓഫ്‌ലൈനായി ഡാറ്റ പുനർനിർമ്മിച്ചു.';

  @override
  String get selectCountersTitle => 'കൗണ്ടറുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get selectCountersSub => 'ഉൾപ്പെടുത്താനുള്ള കൗണ്ടറുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get selectAll => 'എല്ലാം തിരഞ്ഞെടുക്കുക';

  @override
  String get deselectAll => 'എല്ലാം ഒഴിവാക്കുക';

  @override
  String selectedCountersCount(int count) {
    return '$count തിരഞ്ഞെടുത്തു';
  }

  @override
  String get continueAction => 'തുടരുക';

  @override
  String get noCountersSelected => 'ദയവായി ഒരു കൗണ്ടറെങ്കിലും തിരഞ്ഞെടുക്കുക';

  @override
  String get encryptBackup => 'ബാക്കപ്പ് എൻക്രിപ്റ്റ് ചെയ്യുക';

  @override
  String get encryptBackupSub =>
      'പാസ്‌ഫ്രെയ്‌സ് ഉപയോഗിച്ച് സംരക്ഷിക്കുക (AES-256-GCM)';

  @override
  String get enterPassphrase => 'പാസ്‌ഫ്രെയ്‌സ് നൽകുക';

  @override
  String get confirmPassphrase => 'പാസ്‌ഫ്രെയ്‌സ് സ്ഥിരീകരിക്കുക';

  @override
  String get passphraseMismatch => 'പാസ്‌ഫ്രെയ്‌സുകൾ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get passphraseTooShort =>
      'പാസ്‌ഫ്രെയ്‌സ് കുറഞ്ഞത് 6 അക്ഷരങ്ങളെങ്കിലും ആയിരിക്കണം';

  @override
  String get decryptBackup => 'ഡീക്രിപ്റ്റ് ചെയ്ത് ഇമ്പോർട്ട് ചെയ്യുക';

  @override
  String get decryptPassphrasePrompt =>
      'ഈ ബാക്കപ്പ് എൻക്രിപ്റ്റ് ചെയ്തതാണ്. ഡീക്രിപ്റ്റ് ചെയ്യാൻ പാസ്‌ഫ്രെയ്‌സ് നൽകുക.';

  @override
  String get decryptFailed =>
      'ഡീക്രിപ്ഷൻ പരാജയപ്പെട്ടു. തെറ്റായ പാസ്‌ഫ്രെയ്‌സ് അല്ലെങ്കിൽ കേടായ ഫയൽ.';

  @override
  String get skipEncryption => 'ഒഴിവാക്കുക (എൻക്രിപ്റ്റ് ചെയ്യാതെ)';

  @override
  String get opticalSelectCountersHint =>
      'ഓപ്റ്റിക്കൽ സിങ്ക് വഴി അയയ്ക്കാൻ കൗണ്ടറുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get opticalImportSelectHint =>
      'ലഭിച്ച ഡാറ്റയിൽ നിന്ന് ഇമ്പോർട്ട് ചെയ്യാൻ കൗണ്ടറുകൾ തിരഞ്ഞെടുക്കുക';

  @override
  String get notifLifetimeGoalTitle => 'ജീവിതകാല ലക്ഷ്യം നേടി!';

  @override
  String get notifLifetimeGoalBody =>
      'പുണ്യമായ ലക്ഷ്യം പൂർത്തിയായി. അങ്ങയുടെ സാധന ശാന്തിയും മോക്ഷവും നൽകട്ടെ.';

  @override
  String get lifetimeSoundTitle => 'ജീവിതകാല ലക്ഷ്യ ധ്വനി';

  @override
  String get lifetimeSoundSub =>
      'ജീവിതകാല ലക്ഷ്യം നേടുമ്പോൾ കേൾപ്പിക്കുന്ന വിശുദ്ധ ശബ്ദം';

  @override
  String get enableLifetimeNotification => 'ജീവിതകാല ലക്ഷ്യ അറിയിപ്പ്';

  @override
  String get enableLifetimeNotificationSub =>
      'ജീവിതകാല ലക്ഷ്യം നേടുമ്പോൾ വിജ്ഞാപനം നൽകുക';

  @override
  String get soundSacredShankha => 'വിശുദ്ധ ശംഖനാദം';

  @override
  String get soundSacredShankhaSub => 'വിജയവും പുണ്യവും പകരുന്ന ദിവ്യ ശംഖധ്വനി';

  @override
  String get settingsSoundTitle => 'ശബ്ദവും സ്പന്ദനവും';

  @override
  String get settingsSoundSub =>
      'മാല മണിനാദങ്ങൾ, ലക്ഷ്യ പൂർത്തീകരണ ധ്വനികൾ, വൈബ്രേഷൻ';

  @override
  String get settingsDisplayTitle => 'പ്രദർശനവും നിശ്ശബ്ദതയും';

  @override
  String get settingsDisplaySub => 'സ്ക്രീൻ പ്രകാശവും ധ്യാന നിശ്ശബ്ദതാ രീതിയും';

  @override
  String get settingsLanguageTitle => 'ഭാഷ';

  @override
  String get settingsLanguageSub => 'ആപ്ലിക്കേഷൻ ഭാഷയും ലിപിയും സംഖ്യാരീതിയും';

  @override
  String get settingsPermissionsTitle => 'അനുമതികൾ';

  @override
  String get settingsPermissionsSub =>
      'ആപ്പ് ഉപകരണത്തിൽ ഉപയോഗിക്കുന്ന അനുമതികളും അവയുടെ ആവശ്യകതയും';

  @override
  String get settingsClearDataTitle => 'ഡാറ്റ മുഴുവൻ മായ്ക്കുക';

  @override
  String get settingsClearDataSub =>
      'എല്ലാ കൗണ്ടറുകളും ജപ ചരിത്രവും പൂർണ്ണമായി ഒഴിവാക്കുക';

  @override
  String get permissionsExplicitHeader => 'നേരിട്ടുള്ള അനുമതികൾ (Explicit)';

  @override
  String get permissionsExplicitSub =>
      'നിങ്ങൾ നിർദ്ദിഷ്ട ഫീച്ചർ ഉപയോഗിക്കുമ്പോൾ മാത്രം ഉപയോക്താവിനോട് ചോദിക്കുന്നവ';

  @override
  String get permissionsImplicitHeader => 'ആന്തരിക അനുമതികൾ (Implicit)';

  @override
  String get permissionsImplicitSub =>
      'ഇന്റർനെറ്റില്ലാതെ ഓഫ്ലൈൻ പ്രവർത്തനം നൽകാൻ ആൻഡ്രോയിഡ് സ്വയം അനുവദിക്കുന്നവ';

  @override
  String get permissionsPrivacyHeader => 'പൂർണ്ണ സ്വകാര്യതാ ഉറപ്പ്';

  @override
  String get permissionsPrivacySub =>
      'അങ്ങയുടെ സാധനാ സ്വകാര്യതയ്ക്കായി ഒഴിവാക്കപ്പെട്ട അനുമതികൾ';

  @override
  String get permCameraTitle => 'ക്യാമറ';

  @override
  String get permCameraDesc =>
      'ഓപ്റ്റിക്കൽ എയർ-ഗ്യാപ് വഴി വിവരങ്ങൾ സ്വീകരിക്കുമ്പോൾ ആനിമേറ്റഡ് ക്യുആർ കോഡ് സ്കാൻ ചെയ്യാൻ മാത്രം ഉപയോഗിക്കുന്നു. ഫോട്ടോകളോ വീഡിയോകളോ എടുക്കുന്നില്ല.';

  @override
  String get permNotificationTitle => 'അറിയിപ്പുകൾ (Notifications)';

  @override
  String get permNotificationDesc =>
      'ആൻഡ്രോയിഡ് 13+ ഉപകരണങ്ങളിൽ പ്രതിദിന അല്ലെങ്കിൽ ജീവിതകാല ലക്ഷ്യം പൂർത്തിയാകുമ്പോൾ സ്റ്റാറ്റസ് ബാറിൽ അറിയിപ്പ് നൽകാൻ.';

  @override
  String get permVibrationTitle => 'സ്പന്ദനം (Vibration)';

  @override
  String get permVibrationDesc =>
      'ഓരോ ജപത്തിലും മാല പൂർത്തിയാകുമ്പോഴും നിശ്ശബ്ദ മോഡിലും അറിയാൻ മൃദുവായ സ്പന്ദനം നൽകുന്നു.';

  @override
  String get permAudioTitle => 'ശബ്ദ ക്രമീകരണം';

  @override
  String get permAudioDesc =>
      'ധ്യാനത്തിലിരിക്കുമ്പോഴും മണിനാദങ്ങൾ വ്യക്തമായി കേൾക്കാൻ അലാറം സ്ട്രീമിലൂടെ താൽക്കാലികമായി ശബ്ദം ലഭ്യമാക്കുന്നു.';

  @override
  String get permNoInternetTitle => 'ഇന്റർനെറ്റ് പൂർണ്ണമായി ഇല്ല';

  @override
  String get permNoInternetDesc =>
      'ആപ്പിന് ഇന്റർനെറ്റ് അനുമതിയില്ല. വിവരങ്ങൾ പുറത്തുവിടുകയോ ക്ലൗഡിലേക്ക് അയക്കുകയോ ട്രാക്ക് ചെയ്യുകയോ ചെയ്യുന്നില്ല.';

  @override
  String get permNoStorageTitle => 'സ്റ്റോറേജ് അനുമതി ആവശ്യമില്ല';

  @override
  String get permNoStorageDesc =>
      'ഫയലുകൾ സുരക്ഷിതമായി എക്സ്പോർട്ട് ചെയ്യാനും ഇംപോർട്ട് ചെയ്യാനും സിസ്റ്റത്തിന്റെ സുരക്ഷിത പിക്കർ ഉപയോഗിക്കുന്നു.';

  @override
  String get tutorialTitle => 'ആപ്പ് ട്യൂട്ടോറിയൽ';

  @override
  String get tutorialSub =>
      'ആദ്യ കൗണ്ടർ മുതൽ ബാക്കപ്പും സ്വകാര്യതയും വരെ, എല്ലാ സവിശേഷതകളിലൂടെയും ഘട്ടം ഘട്ടമായുള്ള യാത്ര.';

  @override
  String get tutorialStep1Title => 'സ്വാഗതം';

  @override
  String get tutorialStep1Desc =>
      'നിങ്ങളുടെ മന്ത്രജപം എണ്ണാൻ ഈ ആപ്പ് സഹായിക്കുന്നു. 108-ന്റെ മാലകൾ എണ്ണുന്നു, ദിവസ ലക്ഷ്യവും ആജീവനാന്ത ലക്ഷ്യവും സൂക്ഷിക്കുന്നു, മുഴുവൻ ചരിത്രവും സേവ് ചെയ്യുന്നു. ഇന്റർനെറ്റ് ഇല്ലാതെ പൂർണ്ണമായി പ്രവർത്തിക്കുന്നു.';

  @override
  String get tutorialStep2Title => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get tutorialStep2Desc =>
      'ക്രമീകരണങ്ങൾ → ഭാഷ തുറക്കുക. ഇംഗ്ലീഷ്, മലയാളം, സംസ്കൃതം, അല്ലെങ്കിൽ സിസ്റ്റം ഡിഫോൾട്ട് തിരഞ്ഞെടുക്കുക.';

  @override
  String get tutorialStep3Title => 'കൗണ്ടർ ഉണ്ടാക്കുക';

  @override
  String get tutorialStep3Desc =>
      'ഹോം സ്ക്രീനിന്റെ മുകളിലുള്ള + ബട്ടൺ തൊടുക. മന്ത്രത്തിന്റെ പേര് നൽകുക. പിന്നെ തുടക്ക എണ്ണം, ഓരോ തൊടലിലും കൂടുന്ന എണ്ണം, ആജീവനാന്ത ലക്ഷ്യം, ദിവസ ലക്ഷ്യം, തുടങ്ങിയ തീയതി എന്നിവ നൽകുക.';

  @override
  String get tutorialStep4Title => 'കൗണ്ടർ കാർഡ് മനസ്സിലാക്കുക';

  @override
  String get tutorialStep4Desc =>
      'ഓരോ കാർഡിലും ആകെ ജപം, ആകെ മാല, ഇന്നത്തെ ജപം, ഇന്നത്തെ പുരോഗതി കാണിക്കുന്ന 27 മണികളുടെ നിര, ആജീവനാന്ത ലക്ഷ്യത്തിന്റെ ബാർ എന്നിവ കാണാം.';

  @override
  String get tutorialStep5Title => 'ഇന്നത്തെ സംഗ്രഹം';

  @override
  String get tutorialStep5Desc =>
      'ഹോം സ്ക്രീനിന്റെ മുകളിലുള്ള ചെറിയ പെട്ടി ഇന്നത്തെ ആകെ ജപം, മാല, ഇന്ന് ഉപയോഗിച്ച കൗണ്ടറുകൾ എന്നിവ കാണിക്കുന്നു.';

  @override
  String get tutorialStep6Title => 'കൗണ്ടർ ഓപ്ഷനുകൾ';

  @override
  String get tutorialStep6Desc =>
      'കാർഡിൽ അമർത്തിപ്പിടിച്ചാൽ കൗണ്ടറിനെക്കുറിച്ച്, ചരിത്രം, തിരുത്തുക, ലോക്ക്, നിർത്തുക (പൂർത്തിയായി), നിർത്തുക (പൂർത്തിയായില്ല), ഡിലീറ്റ് എന്നിവ കാണാം.';

  @override
  String get tutorialStep7Title => 'കൗണ്ടർ ലോക്ക് ചെയ്യുക';

  @override
  String get tutorialStep7Desc =>
      'കാർഡിലെ പൂട്ട് ഐക്കൺ തൊട്ട് ലോക്ക് ചെയ്യാം. ലോക്ക് ചെയ്ത കൗണ്ടർ എണ്ണാനായി തുറക്കില്ല. വീണ്ടും തൊട്ടാൽ അൺലോക്ക് ആകും.';

  @override
  String get opticalCameraDenied =>
      'ക്യാമറ ഉപയോഗിക്കാനുള്ള അനുമതി നിഷേധിച്ചു. ഡാറ്റ സ്വീകരിക്കാൻ Android ക്രമീകരണങ്ങളിൽ ഈ ആപ്പിന് ക്യാമറ അനുമതി നൽകുക.';

  @override
  String get opticalCameraError =>
      'ക്യാമറ ആരംഭിക്കാനായില്ല. ക്യാമറ ഉപയോഗിക്കുന്ന മറ്റ് ആപ്പുകൾ അടച്ച് വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get opticalCameraUnavailable => 'ഈ ഉപകരണത്തിൽ QR സ്കാനർ ലഭ്യമല്ല.';

  @override
  String get opticalTorchOn => 'ലൈറ്റ് ഓണാക്കുക';

  @override
  String get opticalTorchOff => 'ലൈറ്റ് ഓഫാക്കുക';

  @override
  String get opticalZoom => 'സൂം';

  @override
  String get opticalScanTip =>
      'ഫോക്കസ് ചെയ്യാൻ കോഡിൽ തൊടുക. മങ്ങിയതായി തോന്നിയാൽ സൂം ഉപയോഗിക്കുക.';

  @override
  String get meruPauseTitle => 'നിർത്തുക · ശ്വസിക്കുക';

  @override
  String get meruPauseMessage =>
      'നിങ്ങൾ മേരു മണിയിൽ എത്തി. നിശ്ചലതയിൽ വിശ്രമിക്കുക.';

  @override
  String get pacingHintMessage => 'പതുക്കെ, ശ്വസിക്കുക, മന്ത്രം അനുഭവിക്കുക.';

  @override
  String get sectionMindfulCounting => 'ശ്രദ്ധയോടെ എണ്ണൽ';

  @override
  String get sectionMindfulCountingSub =>
      'തിരക്കില്ലാത്ത ജപത്തിന് സൗമ്യമായ സഹായം';

  @override
  String get meruPauseSettingTitle => 'ഓരോ മാലയ്ക്കും ശേഷം മേരു വിരാമം';

  @override
  String get meruPauseSettingSub =>
      '108-ന് ശേഷം ചെറിയ ശാന്തമായ വിരാമം. വിരാമ സമയത്തെ സ്പർശനങ്ങൾ എണ്ണില്ല.';

  @override
  String secondsShort(int seconds) {
    return '$seconds സെ';
  }

  @override
  String get pacingHintSettingTitle => 'സൗമ്യമായ വേഗ സൂചന';

  @override
  String get pacingHintSettingSub =>
      'വളരെ വേഗത്തിൽ സ്പർശിക്കുമ്പോൾ മൃദുവായ തിളക്കം. എല്ലാ സ്പർശനവും എണ്ണും.';

  @override
  String get helpCountingMindfulSection => 'ശ്രദ്ധാപൂർവ്വമായ എണ്ണൽ';

  @override
  String get sadhanaFlowTitle => 'സാധനാ പ്രവാഹം';

  @override
  String sadhanaFlowA11y(int weeks) {
    return 'കഴിഞ്ഞ $weeks ആഴ്ചകളിലെ സാധനാ ദിനങ്ങളുടെ കലണ്ടർ';
  }

  @override
  String sadhanaFlowYearDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ഈ വർഷം പവിത്ര സ്മരണയുടെ $count ദിവസങ്ങൾ.',
      one: 'ഈ വർഷം പവിത്ര സ്മരണയുടെ 1 ദിവസം.',
      zero: 'ഈ വർഷം നിങ്ങൾ അർപ്പിക്കുന്ന ഓരോ മന്ത്രവും ഇവിടെ തിളങ്ങും.',
    );
    return '$_temp0';
  }

  @override
  String get sadhanaFlowWelcomeBack =>
      'നിങ്ങളുടെ പവിത്ര ഇടത്തിലേക്ക് സ്വാഗതം. അർപ്പിച്ച ഓരോ മന്ത്രവും ശാശ്വതമാണ്.';

  @override
  String get sadhanaFlowLess => 'കുറവ്';

  @override
  String get sadhanaFlowMore => 'കൂടുതൽ';

  @override
  String get opticalBrightness => 'പ്രകാശം';

  @override
  String get opticalBrightnessNormal => 'സാധാരണ';

  @override
  String opticalBrightnessBoost(int percent) {
    return '+$percent%';
  }

  @override
  String get helpCategoryCounters => 'നിങ്ങളുടെ കൗണ്ടറുകളും ചരിത്രവും';

  @override
  String get helpTopicCountersTitle => 'കൗണ്ടറുകളും ഹോം സ്ക്രീനും';

  @override
  String get helpTopicCountersSub =>
      'കൗണ്ടർ ഉണ്ടാക്കൽ, എഡിറ്റ്, ലോക്ക്, നിർത്തൽ, ഡിലീറ്റ്, കാർഡ് മനസ്സിലാക്കൽ';

  @override
  String get helpTopicHistoryTitle => 'ചരിത്രവും സ്ഥിതിവിവരവും';

  @override
  String get helpTopicHistorySub =>
      'ദിവസം തിരിച്ചുള്ള ചരിത്രം, സാധനാ പ്രവാഹ കലണ്ടർ, കൗണ്ടർ വിവരങ്ങൾ';

  @override
  String get helpTopicDisplayTitle => 'പ്രദർശനം, നിശ്ശബ്ദത, ഭാഷ';

  @override
  String get helpTopicDisplaySub =>
      'പ്രകാശം, മങ്ങിയ രീതി, DND, മേരു വിരാമം, ഭാഷ, രൂപഭാവം';

  @override
  String get tutorialChapter1 => 'തുടക്കം';

  @override
  String get tutorialChapter2 => 'നിങ്ങളുടെ കൗണ്ടറുകൾ';

  @override
  String get tutorialChapter3 => 'എണ്ണൽ';

  @override
  String get tutorialChapter4 => 'മാലകളും ലക്ഷ്യങ്ങളും';

  @override
  String get tutorialChapter5 => 'ചരിത്രവും സ്ഥിതിവിവരവും';

  @override
  String get tutorialChapter6 => 'ശബ്ദം, വൈബ്രേഷൻ, ഡിസ്‌പ്ലേ';

  @override
  String get tutorialChapter7 => 'നിങ്ങളുടെ ഡാറ്റ';

  @override
  String get tutorialChapter8 => 'സ്വകാര്യത';

  @override
  String get tutorialStep1Tip =>
      'ഈ ഗൈഡ് എപ്പോൾ വേണമെങ്കിലും ക്രമീകരണങ്ങൾ → സഹായവും ഉപയോക്തൃ ഗൈഡുകളും എന്നതിൽ നിന്ന് തുറക്കാം.';

  @override
  String get tutorialStep2Tip =>
      'ആപ്പിന്റെ ഭാഷ ഏതായാലും, മന്ത്രത്തിന്റെ പേര് ഏത് ലിപിയിലും എഴുതാം.';

  @override
  String get tutorialStep3Tip =>
      'ലക്ഷ്യം വേണ്ടെങ്കിൽ 0 നൽകുക. ദിവസ ലക്ഷ്യം ആജീവനാന്ത ലക്ഷ്യത്തേക്കാൾ കൂടരുത്. ഓരോ തൊടലിലെ എണ്ണം ദിവസ ലക്ഷ്യത്തേക്കാൾ കുറവായിരിക്കണം.';

  @override
  String get tutorialStep4Tip =>
      'പച്ച ടിക്ക് എന്നാൽ ഇന്നത്തെ ലക്ഷ്യം പൂർത്തിയായി. സ്വർണ്ണ ട്രോഫി എന്നാൽ ആജീവനാന്ത ലക്ഷ്യം എത്തി.';

  @override
  String get tutorialStep5Tip =>
      'ഫോണിലെ സമയം അനുസരിച്ച് ഓരോ ദിവസവും അർദ്ധരാത്രിയിൽ ഇവ 0-ൽ നിന്ന് വീണ്ടും തുടങ്ങും.';

  @override
  String get tutorialStep6Tip =>
      'ഡിലീറ്റ് ചെയ്താൽ കൗണ്ടറും അതിന്റെ മുഴുവൻ ചരിത്രവും പോകും. തിരികെ കിട്ടില്ല.';

  @override
  String get tutorialStep7Tip =>
      'പൂർത്തിയായതോ അപൂർവ്വമായി ഉപയോഗിക്കുന്നതോ ആയ കൗണ്ടർ ലോക്ക് ചെയ്യുക. അപ്പോൾ അബദ്ധത്തിൽ എണ്ണം മാറില്ല.';

  @override
  String get tutorialStep8Title => 'എണ്ണൽ സ്ക്രീൻ തുറക്കുക';

  @override
  String get tutorialStep8Desc =>
      'ഒരു കൗണ്ടർ കാർഡ് തൊടുക. വലിയ മാലാവൃത്തമുള്ള എണ്ണൽ സ്ക്രീൻ തുറക്കും.';

  @override
  String get tutorialStep8Tip =>
      'ക്രമീകരണങ്ങളിൽ \'ശല്യപ്പെടുത്തരുത്\' ഓൺ ആണെങ്കിൽ, ഈ സ്ക്രീൻ തുറന്നിരിക്കുമ്പോൾ ഫോൺ നിശബ്ദമായിരിക്കും.';

  @override
  String get tutorialStep9Title => 'എണ്ണാൻ തൊടുക';

  @override
  String get tutorialStep9Desc =>
      'മാലാവൃത്തത്തിനുള്ളിൽ തൊടുക. ഓരോ തൊടലിലും നിശ്ചയിച്ച എണ്ണം (സാധാരണ 1) കൂടും. വൃത്തത്തിന് പുറത്തുള്ള തൊടൽ എണ്ണില്ല.';

  @override
  String get tutorialStep9Tip =>
      'കണ്ണടച്ചും ജപിക്കാം. വൃത്തം വലുതാണ്. ഓരോ മാല തീരുമ്പോഴും ശബ്ദവും സ്പന്ദനവും ഉണ്ടാകും.';

  @override
  String get tutorialStep10Title => 'എണ്ണം തിരുത്തുക';

  @override
  String get tutorialStep10Desc =>
      'രണ്ട് വിരലുകൾ വൃത്തത്തിൽ വച്ച് ഇടത്തോട്ടോ വലത്തോട്ടോ നീക്കുക. ഒരു സ്വൈപ്പിൽ ഒരു എണ്ണം കുറയും.';

  @override
  String get tutorialStep10Tip =>
      'തിരുത്തിയെന്ന് ഉറപ്പാക്കാൻ ഫോൺ ഒരിക്കൽ വൈബ്രേറ്റ് ചെയ്യും.';

  @override
  String get tutorialStep11Title => 'സ്ക്രീൻ മനസ്സിലാക്കുക';

  @override
  String get tutorialStep11Desc =>
      'മുകളിലെ പെട്ടി ഈ ഇരിപ്പിന്റെ സമയം കാണിക്കുന്നു. നടുവിൽ ഇപ്പോഴത്തെ മാലയിലെ മണി, ബാക്കിയുള്ള മണികൾ, തീർന്ന മാലകൾ എന്നിവ കാണാം. താഴത്തെ നിരയിൽ സെഷൻ, ദിവസം, ആജീവനാന്തം എന്നീ എണ്ണങ്ങൾ കാണാം.';

  @override
  String get tutorialStep11Tip =>
      'ലക്ഷ്യം എത്തുമ്പോൾ മുകളിലെ വിളക്ക് ഐക്കണിന്റെ നിറം മാറും.';

  @override
  String get tutorialStep12Title => 'പുറത്തുപോയി തിരികെ വരിക';

  @override
  String get tutorialStep12Desc =>
      'എപ്പോൾ വേണമെങ്കിലും ബാക്ക് അമർത്താം. എണ്ണം നിശബ്ദമായി സേവ് ആകും. ആപ്പ് പിന്നിലായിരിക്കുമ്പോൾ ടൈമർ നിൽക്കും. പൂർത്തിയാകാത്ത മാല മറ്റൊരു ദിവസമായാലും നിങ്ങളെ കാത്തിരിക്കും.';

  @override
  String get tutorialStep12Tip =>
      'പഴയ എണ്ണം സൂക്ഷിച്ച് 0-ൽ നിന്ന് പുതിയ മാല തുടങ്ങാൻ ബാനറിലെ \'പുതിയത് തുടങ്ങുക\' തൊടുക.';

  @override
  String get tutorialStep13Title => 'എണ്ണൽ മെനു';

  @override
  String get tutorialStep13Desc =>
      '⋮ മെനുവിൽ ചരിത്രം, വിവരം, ക്രമീകരണങ്ങൾ, പൂർത്തിയാക്കി പുതിയത് തുടങ്ങുക, സെഷൻ പുനഃസജ്ജമാക്കൽ, കൗണ്ടർ പുനഃസജ്ജമാക്കൽ എന്നിവയുണ്ട്.';

  @override
  String get tutorialStep13Tip =>
      'സെഷൻ പുനഃസജ്ജമാക്കൽ ഈ ഇരിപ്പ് മാത്രം മായ്ക്കും. കൗണ്ടർ പുനഃസജ്ജമാക്കൽ ആ കൗണ്ടറിന്റെ മുഴുവൻ ചരിത്രവും ഡിലീറ്റ് ചെയ്യും.';

  @override
  String get tutorialStep14Title => '108 മണി = 1 മാല';

  @override
  String get tutorialStep14Desc =>
      'ഓരോ 108 എണ്ണവും ഒരു മാലയാണ്. വൃത്തം മണി മണിയായി നിറയും, 108-ന് ശേഷം വീണ്ടും തുടങ്ങും.';

  @override
  String get tutorialStep14Tip =>
      '115 എണ്ണം = 1 മാലയും 7 എണ്ണവും. അധിക എണ്ണം ഒരിക്കലും നഷ്ടപ്പെടില്ല.';

  @override
  String get tutorialStep15Title => 'ലക്ഷ്യങ്ങളിൽ എത്തുക';

  @override
  String get tutorialStep15Desc =>
      'ദിവസ ലക്ഷ്യം എത്തുമ്പോൾ ശബ്ദം കേൾക്കും, ഫോൺ വൈബ്രേറ്റ് ചെയ്യും, അറിയിപ്പ് വരും. ആജീവനാന്ത ലക്ഷ്യത്തിന് സ്വന്തം ശബ്ദവും അറിയിപ്പും സ്വർണ്ണ ട്രോഫിയും ഉണ്ട്.';

  @override
  String get tutorialStep15Tip =>
      'ഇവ ക്രമീകരണങ്ങൾ → ശബ്ദവും സ്പന്ദനവും എന്നതിൽ ഓൺ/ഓഫ് ചെയ്യാം.';

  @override
  String get tutorialStep16Title => 'മേരു വിരാമം';

  @override
  String get tutorialStep16Desc =>
      'ക്രമീകരണങ്ങൾ → പ്രദർശനവും നിശ്ശബ്ദതയും എന്നതിൽ ഓൺ ചെയ്യുക. ഓരോ മാലയ്ക്കും ശേഷം 3, 5 അല്ലെങ്കിൽ 10 സെക്കൻഡ് ആപ്പ് നിൽക്കും, വിശ്രമിക്കാനും ശ്വസിക്കാനും.';

  @override
  String get tutorialStep16Tip =>
      'മേരു മണി ഒരിക്കലും കടക്കാത്തതുപോലെ, വിരാമ സമയത്തെ തൊടൽ എണ്ണില്ല.';

  @override
  String get tutorialStep17Title => 'മൃദുവായ വേഗ സൂചന';

  @override
  String get tutorialStep17Desc =>
      'സെക്കൻഡിൽ ഏകദേശം 3-ൽ കൂടുതൽ വേഗത്തിൽ തൊട്ടാൽ, വൃത്തം മഞ്ഞ നിറത്തിൽ തിളങ്ങും, ഒരു ചെറിയ ഓർമ്മപ്പെടുത്തൽ വരും.';

  @override
  String get tutorialStep17Tip =>
      'എല്ലാ തൊടലും എണ്ണും. ഈ സൂചന ക്രമീകരണങ്ങൾ → പ്രദർശനവും നിശ്ശബ്ദതയും എന്നതിൽ ഓഫ് ചെയ്യാം.';

  @override
  String get tutorialStep18Title => 'ചരിത്രം';

  @override
  String get tutorialStep18Desc =>
      'എണ്ണൽ മെനുവിൽ നിന്നോ അമർത്തിപ്പിടിക്കുന്ന മെനുവിൽ നിന്നോ ചരിത്രം തുറക്കാം. ഇരിപ്പുകൾ ദിവസം തിരിച്ച്, സമയം, ദൈർഘ്യം, എണ്ണം, മാല എന്നിവയോടെ കാണാം.';

  @override
  String get tutorialStep18Tip =>
      'ഒരു ഇരിപ്പ് നീക്കാൻ അതിലെ ഡിലീറ്റ് ഐക്കൺ തൊടുക. ആകെ എണ്ണം ഉടൻ പുതുക്കും.';

  @override
  String get tutorialStep19Title => 'സാധനാ പ്രവാഹം';

  @override
  String get tutorialStep19Desc =>
      'ചരിത്രത്തിലെ കലണ്ടർ കഴിഞ്ഞ 16 ആഴ്ച കാണിക്കുന്നു. ജപിച്ച ദിവസങ്ങൾ വിളക്കുപോലെ തിളങ്ങും. കൂടുതൽ തിളക്കം എന്നാൽ കൂടുതൽ ജപം.';

  @override
  String get tutorialStep19Tip =>
      'തുടർച്ച എണ്ണലോ നഷ്ടപ്പെട്ട ദിവസത്തിന്റെ അടയാളമോ ഇല്ല. തിരികെ വരുന്ന ഓരോ ദിവസവും സ്വാഗതം.';

  @override
  String get tutorialStep20Title => 'കൗണ്ടർ സ്ഥിതിവിവരം';

  @override
  String get tutorialStep20Desc =>
      'പുരോഗതി വൃത്തങ്ങളും കൗണ്ടറിന്റെ എല്ലാ വിവരങ്ങളും കാണാൻ \'കൗണ്ടറിനെക്കുറിച്ച്\' (അമർത്തിപ്പിടിക്കുന്ന മെനു) അല്ലെങ്കിൽ വിവരം (എണ്ണൽ മെനു) തിരഞ്ഞെടുക്കുക.';

  @override
  String get tutorialStep20Tip =>
      'ദിവസ ശരാശരി ജപം നിങ്ങൾ നൽകിയ തുടങ്ങിയ തീയതി മുതൽ കണക്കാക്കുന്നു.';

  @override
  String get tutorialStep21Title => 'ശബ്ദങ്ങൾ';

  @override
  String get tutorialStep21Desc =>
      'ക്രമീകരണങ്ങൾ → ശബ്ദവും സ്പന്ദനവും എന്നതിൽ മാല ശബ്ദം, ദിവസ ലക്ഷ്യ ശബ്ദം, ആജീവനാന്ത ലക്ഷ്യ ശബ്ദം എന്നിവ തിരഞ്ഞെടുക്കുക. ആപ്പിലെ ശബ്ദം, ഫോണിലെ റിംഗ്‌ടോൺ, അല്ലെങ്കിൽ സ്വന്തം ഓഡിയോ ഫയൽ ഉപയോഗിക്കാം.';

  @override
  String get tutorialStep21Tip =>
      'ജപിക്കുന്നതിന് മുമ്പ് ശബ്ദം കേൾക്കാൻ \'ടോൺ പ്രിവ്യൂ\' തൊടുക.';

  @override
  String get tutorialStep22Title => 'വൈബ്രേഷനും അറിയിപ്പുകളും';

  @override
  String get tutorialStep22Desc =>
      'ഓരോ മാലയ്ക്കും ലക്ഷ്യത്തിനും തിരുത്തലിനും വൈബ്രേഷൻ ഉണ്ട്. ലക്ഷ്യ അറിയിപ്പുകൾ സ്റ്റാറ്റസ് ബാറിൽ വരും.';

  @override
  String get tutorialStep22Tip =>
      'ശബ്ദങ്ങൾ അലാറം ചാനലിലൂടെ വരുന്നതിനാൽ ഫോൺ സൈലന്റിൽ ആണെങ്കിലും കേൾക്കാം.';

  @override
  String get tutorialStep23Title => 'പ്രദർശനവും നിശ്ശബ്ദതയും';

  @override
  String get tutorialStep23Desc =>
      'ക്രമീകരണങ്ങൾ → പ്രദർശനവും നിശ്ശബ്ദതയും എന്നതിൽ പ്രകാശം ക്രമീകരിക്കാം, മങ്ങിയ ജപ മോഡ് ഓൺ ചെയ്യാം, \'ശല്യപ്പെടുത്തരുത്\' വഴി കോളുകളും അറിയിപ്പുകളും നിശബ്ദമാക്കാം.';

  @override
  String get tutorialStep23Tip =>
      '\'ശല്യപ്പെടുത്തരുത്\' ഒരിക്കൽ അനുമതി നൽകണം. എണ്ണൽ സ്ക്രീനിൽ നിന്ന് പുറത്തുപോകുമ്പോൾ അത് വീണ്ടും ഓഫ് ആകും.';

  @override
  String get tutorialStep24Title => 'രൂപഭാവം';

  @override
  String get tutorialStep24Desc =>
      'ക്രമീകരണങ്ങൾ → രൂപഭാവം എന്നതിൽ ആപ്പിലെ ക്ഷേത്ര നിറങ്ങളും അക്ഷരരൂപങ്ങളും കാണാം.';

  @override
  String get tutorialStep24Tip =>
      'ഒറ്റക്കൈ കൊണ്ട് എണ്ണാൻ ആപ്പ് എപ്പോഴും നിവർന്ന (പോർട്രെയ്റ്റ്) നിലയിൽ ആയിരിക്കും.';

  @override
  String get tutorialStep25Title => 'ഫയലിലേക്ക് ബാക്കപ്പ്';

  @override
  String get tutorialStep25Desc =>
      'ക്രമീകരണങ്ങൾ → ഡാറ്റ ബാക്കപ്പും ഒപ്റ്റിക്കൽ സിങ്കും → എക്സ്പോർട്ട്, അല്ലെങ്കിൽ ഹോം മെനുവിലെ ഇംപോർട്ട് / എക്സ്പോർട്ട് ഉപയോഗിക്കുക. എല്ലാ കൗണ്ടറുകളും ചരിത്രവും ഒരു ഫയലിൽ സേവ് ആകും, ഷെയർ ഷീറ്റ് തുറക്കും.';

  @override
  String get tutorialStep25Tip =>
      'പാസ്ഫ്രേസ് ഉപയോഗിച്ച് ഫയൽ പൂട്ടാം (AES-256-GCM). മറന്ന പാസ്ഫ്രേസ് തിരികെ കിട്ടില്ല.';

  @override
  String get tutorialStep26Title => 'ഫയലിൽ നിന്ന് പുനഃസ്ഥാപിക്കുക';

  @override
  String get tutorialStep26Desc =>
      'ഇംപോർട്ട് തിരഞ്ഞെടുത്ത് ബാക്കപ്പ് ഫയൽ തിരഞ്ഞെടുക്കുക. ഫയൽ പൂട്ടിയതാണെങ്കിൽ പാസ്ഫ്രേസ് നൽകുക.';

  @override
  String get tutorialStep26Tip =>
      'ഇംപോർട്ട് ഈ ഫോണിലെ എല്ലാ ഡാറ്റയും മാറ്റിസ്ഥാപിക്കും. അത് സൂക്ഷിക്കണമെങ്കിൽ ആദ്യം എക്സ്പോർട്ട് ചെയ്യുക.';

  @override
  String get tutorialStep27Title => 'ഫോണിൽ നിന്ന് ഫോണിലേക്ക്';

  @override
  String get tutorialStep27Desc =>
      'പഴയ ഫോണിൽ ഒപ്റ്റിക്കൽ സിങ്ക് (അയയ്ക്കുക) തിരഞ്ഞെടുത്ത് കൗണ്ടറുകൾ തിരഞ്ഞെടുക്കുക. പുതിയ ഫോണിൽ ഒപ്റ്റിക്കൽ സിങ്ക് (സ്വീകരിക്കുക) തിരഞ്ഞെടുത്ത് ചലിക്കുന്ന QR കോഡിലേക്ക് ക്യാമറ പിടിക്കുക.';

  @override
  String get tutorialStep27Tip =>
      'ഇന്റർനെറ്റോ ബ്ലൂടൂത്തോ കേബിളോ വേണ്ട. തിരഞ്ഞെടുത്ത കൗണ്ടറുകൾ ചേർക്കും; സ്വീകരിക്കുന്ന ഫോണിലെ മറ്റ് കൗണ്ടറുകൾ നിലനിൽക്കും.';

  @override
  String get tutorialStep28Title => 'എല്ലാ ഡാറ്റയും മായ്ക്കുക';

  @override
  String get tutorialStep28Desc =>
      'ക്രമീകരണങ്ങൾ → ഡാറ്റ ബാക്കപ്പും ഒപ്റ്റിക്കൽ സിങ്കും → ഡാറ്റ മുഴുവൻ മായ്ക്കുക എന്നത് എല്ലാ കൗണ്ടറുകളും മുഴുവൻ ചരിത്രവും ഡിലീറ്റ് ചെയ്യും.';

  @override
  String get tutorialStep28Tip =>
      'ആദ്യം ബാക്കപ്പ് എടുക്കുക. ഇത് തിരികെ എടുക്കാനാവില്ല.';

  @override
  String get tutorialStep29Title => 'പൂർണ്ണമായി ഓഫ്‌ലൈൻ, സ്വകാര്യം';

  @override
  String get tutorialStep29Desc =>
      'ആപ്പിന് ഇന്റർനെറ്റ് അനുമതിയില്ല, പരസ്യമില്ല, നിരീക്ഷണമില്ല, അക്കൗണ്ടുമില്ല. നിങ്ങളുടെ സാധന നിങ്ങളുടെ ഫോണിൽ തന്നെ.';

  @override
  String get tutorialStep29Tip =>
      'ഈ ആപ്പിന് ആൻഡ്രോയിഡ് ക്ലൗഡ് ബാക്കപ്പ് ഓഫ് ആണ്. പകർപ്പ് സൂക്ഷിക്കാൻ എക്സ്പോർട്ട് അല്ലെങ്കിൽ ഒപ്റ്റിക്കൽ സിങ്ക് ഉപയോഗിക്കുക.';

  @override
  String get tutorialStep30Title => 'അനുമതികൾ';

  @override
  String get tutorialStep30Desc =>
      'ക്യാമറ സിങ്ക് കോഡ് സ്കാൻ ചെയ്യാൻ മാത്രം. അറിയിപ്പുകൾ ലക്ഷ്യ സന്ദേശങ്ങൾക്ക്. വൈബ്രേഷനും ഓഡിയോയും പ്രതികരണത്തിന്. \'ശല്യപ്പെടുത്തരുത്\' അനുമതി നിങ്ങൾ ഓൺ ചെയ്താൽ മാത്രം ചോദിക്കും.';

  @override
  String get tutorialStep30Tip =>
      'ഓരോ അനുമതിയും എന്തിനെന്ന് ക്രമീകരണങ്ങൾ → അനുമതികൾ എന്നതിൽ കാണാം.';

  @override
  String get helpCountersIntro =>
      'ഹോം സ്ക്രീനിൽ നിങ്ങളുടെ എല്ലാ കൗണ്ടറുകളും കാണാം. ഓരോ കൗണ്ടറും ഒരു മന്ത്രമോ സാധനയോ ആണ്, അതിന് സ്വന്തം ലക്ഷ്യങ്ങളും ചരിത്രവും ഉണ്ട്.';

  @override
  String get helpCountersCreateSection => 'കൗണ്ടർ ഉണ്ടാക്കൽ';

  @override
  String get helpCountersCreateBold1 => 'ചേർക്കൽ ബട്ടൺ:';

  @override
  String get helpCountersCreateBullet1 =>
      'പുതിയ കൗണ്ടർ ഉണ്ടാക്കാൻ ഹോം സ്ക്രീനിന്റെ മുകളിലുള്ള + ബട്ടൺ തൊടുക.';

  @override
  String get helpCountersCreateBold2 => 'പേര്:';

  @override
  String get helpCountersCreateBullet2 =>
      'മന്ത്രത്തിന്റെ പേര് ഏത് ഭാഷയിലും ലിപിയിലും എഴുതാം.';

  @override
  String get helpCountersCreateBold3 => 'തുടക്ക എണ്ണം:';

  @override
  String get helpCountersCreateBullet3 =>
      'മുമ്പ് ചെയ്ത ജപം ചേർക്കാൻ, ഉദാഹരണത്തിന് കടലാസിൽ എഴുതിയത്. സാധാരണ 0.';

  @override
  String get helpCountersCreateBold4 => 'ഓരോ തൊടലിലെ എണ്ണം:';

  @override
  String get helpCountersCreateBullet4 =>
      'ഒരു തൊടലിൽ എത്ര കൂടണം. സാധാരണ 1. ഇത് ദിവസ ലക്ഷ്യത്തേക്കാൾ കുറവായിരിക്കണം.';

  @override
  String get helpCountersCreateBold5 => 'ലക്ഷ്യങ്ങൾ:';

  @override
  String get helpCountersCreateBullet5 =>
      'ദിവസ ലക്ഷ്യവും ആജീവനാന്ത ലക്ഷ്യവും നൽകുക. ലക്ഷ്യം വേണ്ടെങ്കിൽ 0. ദിവസ ലക്ഷ്യം ആജീവനാന്ത ലക്ഷ്യത്തേക്കാൾ കൂടരുത്.';

  @override
  String get helpCountersCreateBold6 => 'തുടങ്ങിയ തീയതി:';

  @override
  String get helpCountersCreateBullet6 =>
      'ഈ സാധന തുടങ്ങിയ ദിവസം. ദിവസ ശരാശരി ജപം കണക്കാക്കാൻ ഇത് ഉപയോഗിക്കുന്നു.';

  @override
  String get helpCountersHomeSection => 'ഹോം സ്ക്രീൻ';

  @override
  String get helpCountersHomeBold1 => 'ഇന്നത്തെ സംഗ്രഹം:';

  @override
  String get helpCountersHomeBullet1 =>
      'മുകളിലെ ചെറിയ പെട്ടി ഇന്നത്തെ ആകെ ജപം, ആകെ മാല, ഇന്ന് ഉപയോഗിച്ച കൗണ്ടറുകളുടെ എണ്ണം എന്നിവ കാണിക്കുന്നു.';

  @override
  String get helpCountersHomeBold2 => 'കാർഡിലെ പുരോഗതി:';

  @override
  String get helpCountersHomeBullet2 =>
      'ഓരോ കാർഡിലും ആകെ ജപം, മാല, ഇന്നത്തെ ജപം, ഇന്നത്തെ ലക്ഷ്യത്തിന് 27 മണികളുടെ നിര, ആജീവനാന്ത ലക്ഷ്യത്തിന്റെ ബാർ എന്നിവയുണ്ട്.';

  @override
  String get helpCountersHomeBold3 => 'അടയാളങ്ങൾ:';

  @override
  String get helpCountersHomeBullet3 =>
      'ഇന്നത്തെ ലക്ഷ്യം തീരുമ്പോൾ പച്ച ടിക്ക് വരും. ആജീവനാന്ത ലക്ഷ്യം എത്തുമ്പോൾ സ്വർണ്ണ ട്രോഫി വരും.';

  @override
  String get helpCountersHomeBold4 => 'ക്രമം:';

  @override
  String get helpCountersHomeBullet4 =>
      'സജീവ കൗണ്ടറുകൾ ആദ്യം, പിന്നെ നിർത്തിയവ. പുതിയവ ആദ്യം കാണിക്കും.';

  @override
  String get helpCountersHomeBold5 => 'നിറങ്ങൾ:';

  @override
  String get helpCountersHomeBullet5 =>
      'ഓരോ കൗണ്ടറിനും സ്വന്തം നിറം ലഭിക്കും, അത് എപ്പോഴും ഒന്നുതന്നെ.';

  @override
  String get helpCountersHomeBold6 => 'മുകളിലെ മെനു:';

  @override
  String get helpCountersHomeBullet6 =>
      'മുകളിലെ മെനുവിൽ ഇംപോർട്ട് / എക്സ്പോർട്ട്, ക്രമീകരണങ്ങൾ, ആപ്പിനെക്കുറിച്ച് എന്നിവയുണ്ട്.';

  @override
  String get helpCountersOptionsSection =>
      'കൗണ്ടർ ഓപ്ഷനുകൾ (കാർഡിൽ അമർത്തിപ്പിടിക്കുക)';

  @override
  String get helpCountersOptionsBold1 => 'കൗണ്ടറിനെക്കുറിച്ച്:';

  @override
  String get helpCountersOptionsBullet1 =>
      'കൗണ്ടറിന്റെ സ്ഥിതിവിവരവും വിശദാംശങ്ങളും.';

  @override
  String get helpCountersOptionsBold2 => 'ചരിത്രം:';

  @override
  String get helpCountersOptionsBullet2 => 'ഈ കൗണ്ടറിന്റെ എല്ലാ ഇരിപ്പുകളും.';

  @override
  String get helpCountersOptionsBold3 => 'എഡിറ്റ്:';

  @override
  String get helpCountersOptionsBullet3 =>
      'പേര്, എണ്ണം, ലക്ഷ്യങ്ങൾ, തുടങ്ങിയ തീയതി എന്നിവ മാറ്റാം.';

  @override
  String get helpCountersOptionsBold4 => 'ലോക്ക് / അൺലോക്ക്:';

  @override
  String get helpCountersOptionsBullet4 => 'കാർഡിലെ പൂട്ട് ഐക്കൺ പോലെ തന്നെ.';

  @override
  String get helpCountersOptionsBold5 => 'പ്രവർത്തനരഹിതമാക്കുക (വിജയം):';

  @override
  String get helpCountersOptionsBullet5 =>
      'കൗണ്ടർ പൂർത്തിയായി എന്ന് അടയാളപ്പെടുത്തുക, ഉദാഹരണത്തിന് സങ്കല്പം തീരുമ്പോൾ. കാരണം ചേർക്കാം.';

  @override
  String get helpCountersOptionsBold6 =>
      'പ്രവർത്തനരഹിതമാക്കുക (പൂർത്തിയായില്ല):';

  @override
  String get helpCountersOptionsBullet6 =>
      'പൂർത്തിയാകാത്ത കൗണ്ടർ നിർത്തുക. കാരണം ചേർക്കാം.';

  @override
  String get helpCountersOptionsBold7 => 'ഇല്ലാതാക്കുക:';

  @override
  String get helpCountersOptionsBullet7 =>
      'ഉറപ്പാക്കിയ ശേഷം കൗണ്ടറും അതിന്റെ മുഴുവൻ ചരിത്രവും നീക്കും. തിരികെ കിട്ടില്ല.';

  @override
  String get helpCountersLockSection =>
      'ലോക്ക് ചെയ്തതും നിർത്തിയതുമായ കൗണ്ടറുകൾ';

  @override
  String get helpCountersLockBold1 => 'പൂട്ട് ഐക്കൺ:';

  @override
  String get helpCountersLockBullet1 =>
      'ലോക്ക് ചെയ്യാനോ അൺലോക്ക് ചെയ്യാനോ കാർഡിലെ പൂട്ട് ഐക്കൺ തൊടുക.';

  @override
  String get helpCountersLockBold2 => 'ലോക്ക് ചെയ്തത്:';

  @override
  String get helpCountersLockBullet2 =>
      'ലോക്ക് ചെയ്ത കൗണ്ടർ എണ്ണാനായി തുറക്കില്ല, അതിനാൽ അബദ്ധത്തിൽ എണ്ണം മാറില്ല. തൊട്ടാൽ ഒരു ചെറിയ സന്ദേശം കാണിക്കും.';

  @override
  String get helpCountersLockBold3 => 'നിർത്തിയത്:';

  @override
  String get helpCountersLockBullet3 =>
      'നിർത്തിയ കൗണ്ടറുകൾ ടിക്ക് അല്ലെങ്കിൽ ക്രോസ് അടയാളത്തോടെ പട്ടികയിൽ ഉണ്ടാകും, പക്ഷേ എണ്ണാനായി തുറക്കില്ല.';

  @override
  String get helpCountingScreenSection => 'സ്ക്രീൻ മനസ്സിലാക്കൽ';

  @override
  String get helpCountingScreenBold1 => 'ടൈമർ:';

  @override
  String get helpCountingScreenBullet1 =>
      'മുകളിലെ പെട്ടി ഈ ഇരിപ്പ് എത്ര സമയമായി എന്ന് കാണിക്കുന്നു. ആപ്പ് പിന്നിലായിരിക്കുമ്പോൾ \'നിർത്തി\' എന്ന് കാണിക്കും.';

  @override
  String get helpCountingScreenBold2 => 'നടുവിൽ:';

  @override
  String get helpCountingScreenBullet2 =>
      'വലിയ സംഖ്യ ഇപ്പോഴത്തെ മാലയിലെ സ്ഥാനമാണ് (0–107). അതിന് താഴെ ബാക്കിയുള്ള മണികളും ഈ ഇരിപ്പിൽ തീർന്ന മാലകളും.';

  @override
  String get helpCountingScreenBold3 => 'താഴത്തെ നിര:';

  @override
  String get helpCountingScreenBullet3 =>
      'സെഷൻ, ദിവസം, ആജീവനാന്തം എന്നീ എണ്ണങ്ങളും ലക്ഷ്യത്തിലേക്കുള്ള പുരോഗതിയും കാണിക്കുന്നു.';

  @override
  String get helpCountingScreenBold4 => 'വിളക്ക്:';

  @override
  String get helpCountingScreenBullet4 =>
      'ദിവസ ലക്ഷ്യമോ ആജീവനാന്ത ലക്ഷ്യമോ എത്തുമ്പോൾ മുകളിലെ വിളക്ക് ഐക്കണിന്റെ നിറം മാറും.';

  @override
  String get helpCountingSaveSection => 'പുറത്തുപോകലും സേവ് ചെയ്യലും';

  @override
  String get helpCountingSaveBold1 => 'സ്വയം സേവ്:';

  @override
  String get helpCountingSaveBullet1 =>
      'എപ്പോൾ വേണമെങ്കിലും ബാക്ക് അമർത്താം. എണ്ണം നിശബ്ദമായി സേവ് ആകും; ആപ്പ് ചോദിക്കില്ല.';

  @override
  String get helpCountingSaveBold2 => 'തകരാറിലും സുരക്ഷിതം:';

  @override
  String get helpCountingSaveBullet2 =>
      'ഓരോ 5 തൊടലിലും അല്ലെങ്കിൽ 5 സെക്കൻഡിലും എണ്ണം സേവ് ആകും, ഓരോ 20 തൊടലിലും അല്ലെങ്കിൽ 30 സെക്കൻഡിലും പൂർണ്ണമായി സൂക്ഷിക്കും. ഫോൺ ഓഫായാലും ആപ്പ് തുറക്കുമ്പോൾ എണ്ണം തിരികെ വരും.';

  @override
  String get helpCountingSaveBold3 => 'ടൈമർ നിർത്തൽ:';

  @override
  String get helpCountingSaveBullet3 =>
      'ആപ്പ് പിന്നിലായിരിക്കുമ്പോൾ ടൈമർ നിൽക്കും, അതിനാൽ വെറുതെയുള്ള സമയം ഇരിപ്പിൽ ചേർക്കില്ല.';

  @override
  String get helpCountingSaveBold4 => 'പൂർത്തിയാകാത്ത മാല:';

  @override
  String get helpCountingSaveBullet4 =>
      '108-ന് മുമ്പ് നിർത്തിയാൽ, മറ്റൊരു ദിവസമായാലും അടുത്ത തവണ ആ മാല കാത്തിരിക്കും, ഒരു ബാനർ അത് കാണിക്കും. തൊടൽ എപ്പോഴും തൊട്ട ദിവസത്തിൽ തന്നെ എണ്ണും. ആ എണ്ണം സൂക്ഷിച്ച് 0-ൽ നിന്ന് പുതിയ മാല തുടങ്ങാൻ \'പുതിയത് തുടങ്ങുക\' തൊടുക.';

  @override
  String get helpCountingMenuSection => 'എണ്ണൽ മെനു (⋮)';

  @override
  String get helpCountingMenuBold1 => 'ചരിത്രം:';

  @override
  String get helpCountingMenuBullet1 => 'ഈ കൗണ്ടറിന്റെ ചരിത്രം തുറക്കും.';

  @override
  String get helpCountingMenuBold2 => 'വിവരം:';

  @override
  String get helpCountingMenuBullet2 =>
      'ഈ കൗണ്ടറിന്റെ സ്ഥിതിവിവരവും വിശദാംശങ്ങളും കാണിക്കും.';

  @override
  String get helpCountingMenuBold3 => 'ക്രമീകരണങ്ങൾ:';

  @override
  String get helpCountingMenuBullet3 => 'ആപ്പിന്റെ ക്രമീകരണങ്ങൾ തുറക്കും.';

  @override
  String get helpCountingMenuBold4 => 'പൂർത്തിയാക്കി പുതിയത് തുടങ്ങുക:';

  @override
  String get helpCountingMenuBullet4 =>
      'ഇപ്പോഴത്തെ പൂർത്തിയാകാത്ത മാല അവസാനിപ്പിക്കും. അതിന്റെ എണ്ണം ചരിത്രത്തിൽ സൂക്ഷിക്കും, അടുത്ത തൊടൽ 0-ൽ നിന്ന് പുതിയ മാല തുടങ്ങും.';

  @override
  String get helpCountingMenuBold5 => 'സെഷൻ പുനഃസജ്ജമാക്കുക:';

  @override
  String get helpCountingMenuBullet5 =>
      'ഇപ്പോഴത്തെ ഇരിപ്പ് ഉപേക്ഷിച്ച് 0 ആക്കും. പഴയ ചരിത്രം നിലനിൽക്കും.';

  @override
  String get helpCountingMenuBold6 => 'കൗണ്ടർ പുനഃസജ്ജമാക്കുക:';

  @override
  String get helpCountingMenuBullet6 =>
      'ഈ കൗണ്ടറിന്റെ മുഴുവൻ ചരിത്രവും ഡിലീറ്റ് ചെയ്യും. തിരികെ കിട്ടില്ല.';

  @override
  String get helpCountingMindfulBold1 => 'മേരു വിരാമം:';

  @override
  String get helpCountingMindfulBullet1 =>
      'ക്രമീകരണങ്ങൾ → പ്രദർശനവും നിശ്ശബ്ദതയും എന്നതിൽ ഓൺ ചെയ്താൽ, ഓരോ മാലയ്ക്കും ശേഷം ആപ്പ് 3, 5 അല്ലെങ്കിൽ 10 സെക്കൻഡ് നിൽക്കും. ആ സമയത്തെ തൊടൽ എണ്ണില്ല. വിരാമം സ്വയം തീരും, അല്ലെങ്കിൽ തിരുത്തൽ സ്വൈപ്പ് കൊണ്ട് തീർക്കാം.';

  @override
  String get helpCountingMindfulBold2 => 'വേഗ സൂചന:';

  @override
  String get helpCountingMindfulBullet2 =>
      'സെക്കൻഡിൽ ഏകദേശം 3-ൽ കൂടുതൽ വേഗത്തിൽ തൊട്ടാൽ, വൃത്തം മൃദുവായി തിളങ്ങും, ചെറിയ ഓർമ്മപ്പെടുത്തൽ വരും. ഇത് ഒരിക്കലും എണ്ണം തടയില്ല.';

  @override
  String get helpMalaBeadsBold4 => 'മാല ശബ്ദം:';

  @override
  String get helpMalaBeadsBullet4 =>
      'ഓൺ ആണെങ്കിൽ ഓരോ 108-ാം എണ്ണത്തിലും മൃദുവായ ശബ്ദം കേൾക്കും. അതേ തൊടലിൽ ലക്ഷ്യം എത്തിയാൽ ഇത് ഒഴിവാക്കും, ശബ്ദങ്ങൾ കൂടിക്കലരാതിരിക്കാൻ.';

  @override
  String get helpMalaGoalsBold3 => 'ദിവസ ലക്ഷ്യം എത്തുമ്പോൾ:';

  @override
  String get helpMalaGoalsBullet3 =>
      'ദിവസ അറിയിപ്പ് ഓൺ ആണെങ്കിൽ ലക്ഷ്യ ശബ്ദം കേൾക്കും, ഫോൺ വൈബ്രേറ്റ് ചെയ്യും, അറിയിപ്പ് വരും. കാർഡിൽ പച്ച ടിക്ക് വരും.';

  @override
  String get helpMalaGoalsBold4 => 'ആജീവനാന്ത ലക്ഷ്യം എത്തുമ്പോൾ:';

  @override
  String get helpMalaGoalsBullet4 =>
      'ആജീവനാന്ത അറിയിപ്പ് ഓൺ ആണെങ്കിൽ അതിന്റെ ശബ്ദവും അറിയിപ്പും വരും. സ്വർണ്ണ ട്രോഫി വരും, കാർഡ് ഇളം ചന്ദന നിറമാകും.';

  @override
  String get helpMalaCardSection => 'കാർഡിലെ പുരോഗതി';

  @override
  String get helpMalaCardBold1 => 'മണി നിര:';

  @override
  String get helpMalaCardBullet1 =>
      '27 ചെറിയ മണികളുടെ നിര ഇന്നത്തെ ലക്ഷ്യത്തിലേക്കുള്ള പുരോഗതി കാണിക്കുന്നു. ഓരോ മണിയും ലക്ഷ്യത്തിന്റെ 1/27, മാലയിലെ 4 മണി പോലെ.';

  @override
  String get helpMalaCardBold2 => 'ആജീവനാന്ത ബാർ:';

  @override
  String get helpMalaCardBullet2 =>
      'നീണ്ട ബാർ ആജീവനാന്ത ലക്ഷ്യത്തിന്റെ എത്ര ഭാഗം തീർന്നു എന്ന് കാണിക്കുന്നു.';

  @override
  String get helpMalaCardBold3 => 'സംഖ്യകൾ:';

  @override
  String get helpMalaCardBullet3 =>
      'കാർഡിൽ ആകെ ജപം, ആകെ മാല, ഇന്നത്തെ ജപം, മാല എന്നിവ കാണാം.';

  @override
  String get helpHistoryIntro =>
      'ചരിത്രം ഓരോ ഇരിപ്പിന്റെയും രേഖ സൂക്ഷിക്കുന്നു. എണ്ണൽ മെനുവിൽ നിന്നോ, കൗണ്ടറിൽ അമർത്തിപ്പിടിക്കുന്ന മെനുവിൽ നിന്നോ, കൗണ്ടർ വിവര പേജിൽ നിന്നോ തുറക്കാം.';

  @override
  String get helpHistoryLogSection => 'ചരിത്ര പട്ടിക';

  @override
  String get helpHistoryLogBold1 => 'സംഗ്രഹം:';

  @override
  String get helpHistoryLogBullet1 =>
      'മുകളിലെ കാർഡ് ആകെ ജപം, സാധന ചെയ്ത ദിവസങ്ങൾ, സങ്കല്പത്തിന്റെ എത്ര ഭാഗം തീർന്നു എന്നിവ കാണിക്കുന്നു.';

  @override
  String get helpHistoryLogBold2 => 'ദിവസം തിരിച്ച്:';

  @override
  String get helpHistoryLogBullet2 =>
      'ഇരിപ്പുകൾ തീയതി തിരിച്ച്, പുതിയത് ആദ്യം. ഓരോ ദിവസവും അന്നത്തെ ആകെയും ആ ദിവസം വരെയുള്ള ആകെയും കാണിക്കും.';

  @override
  String get helpHistoryLogBold3 => 'ഇരിപ്പ് വരികൾ:';

  @override
  String get helpHistoryLogBullet3 =>
      'ഓരോ ഇരിപ്പും തുടങ്ങിയ സമയം, ദൈർഘ്യം, എണ്ണം, മാല എന്നിവ കാണിക്കും.';

  @override
  String get helpHistoryDeleteSection => 'ചരിത്രം ഡിലീറ്റ് ചെയ്യൽ';

  @override
  String get helpHistoryDeleteBold1 => 'ഒരു ഇരിപ്പ്:';

  @override
  String get helpHistoryDeleteBullet1 =>
      'ഇരിപ്പിലെ ഡിലീറ്റ് ഐക്കൺ തൊട്ട് ഉറപ്പാക്കുക. ആകെ എണ്ണം ഉടൻ വീണ്ടും കണക്കാക്കും.';

  @override
  String get helpHistoryDeleteBold2 => 'ചരിത്രം മായ്ക്കുക:';

  @override
  String get helpHistoryDeleteBullet2 =>
      'മുകളിലെ മായ്ക്കൽ ബട്ടൺ ഉറപ്പാക്കിയ ശേഷം ഈ കൗണ്ടറിന്റെ എല്ലാ ഇരിപ്പുകളും ഡിലീറ്റ് ചെയ്യും. തിരികെ കിട്ടില്ല.';

  @override
  String get helpHistoryFlowSection => 'സാധനാ പ്രവാഹ കലണ്ടർ';

  @override
  String get helpHistoryFlowBold1 => '16 ആഴ്ച:';

  @override
  String get helpHistoryFlowBullet1 =>
      'കഴിഞ്ഞ 16 ആഴ്ചയുടെ കലണ്ടർ, തിങ്കൾ മുകളിൽ. ജപിച്ച ദിവസങ്ങൾ ഇളം ചന്ദനം മുതൽ കടും കാവി വരെ വിളക്കുപോലെ തിളങ്ങും.';

  @override
  String get helpHistoryFlowBold2 => 'തിളക്കം:';

  @override
  String get helpHistoryFlowBullet2 =>
      'ദിവസ ലക്ഷ്യമുള്ള കൗണ്ടറിന് തിളക്കം ആ ലക്ഷ്യത്തിലേക്കുള്ള പുരോഗതി കാണിക്കും. അല്ലെങ്കിൽ കാണിച്ചിട്ടുള്ള ഏറ്റവും കൂടുതൽ ജപിച്ച ദിവസവുമായി താരതമ്യം ചെയ്യും.';

  @override
  String get helpHistoryFlowBold3 => 'സമ്മർദ്ദമില്ല:';

  @override
  String get helpHistoryFlowBullet3 =>
      'തുടർച്ച എണ്ണലോ നഷ്ടപ്പെട്ട ദിവസത്തിന്റെ അടയാളമോ ഇല്ല. 3-ഓ അതിൽ കൂടുതലോ ദിവസത്തിന് ശേഷം തിരികെ വന്നാൽ സ്നേഹത്തോടെ ഒരു സ്വാഗത വരി കാണിക്കും.';

  @override
  String get helpHistoryStatsSection => 'കൗണ്ടർ സ്ഥിതിവിവരം';

  @override
  String get helpHistoryStatsBold1 => 'തുറക്കാൻ:';

  @override
  String get helpHistoryStatsBullet1 =>
      'കൗണ്ടറിൽ അമർത്തിപ്പിടിച്ച് \'കൗണ്ടറിനെക്കുറിച്ച്\' തിരഞ്ഞെടുക്കുക, അല്ലെങ്കിൽ എണ്ണൽ മെനുവിലെ \'വിവരം\' ഉപയോഗിക്കുക.';

  @override
  String get helpHistoryStatsBold2 => 'വൃത്തങ്ങൾ:';

  @override
  String get helpHistoryStatsBullet2 =>
      'മൂന്ന് വൃത്തങ്ങൾ ആജീവനാന്ത പുരോഗതി, ഇന്നത്തെ പുരോഗതി, ആകെ മാല എന്നിവ കാണിക്കുന്നു.';

  @override
  String get helpHistoryStatsBold3 => 'വിശദാംശങ്ങൾ:';

  @override
  String get helpHistoryStatsBullet3 =>
      'പേര്, നില, എണ്ണം, തുടക്ക എണ്ണം, ലക്ഷ്യങ്ങൾ, തുടങ്ങിയ തീയതി, ഉണ്ടാക്കിയ തീയതി, ദിവസ ശരാശരി ജപം, നിർത്തിയെങ്കിൽ ആ തീയതിയും കാരണവും.';

  @override
  String get helpAudioMalaSection => 'മാല ശബ്ദം';

  @override
  String get helpAudioMalaBold1 => 'മാല ശബ്ദം:';

  @override
  String get helpAudioMalaBullet1 =>
      'ഓരോ 108-ാം എണ്ണത്തിലും മൃദുവായ ശബ്ദവും വൈബ്രേഷനും.';

  @override
  String get helpAudioMalaBold2 => 'തിരഞ്ഞെടുപ്പുകൾ:';

  @override
  String get helpAudioMalaBullet2 =>
      'ക്ഷേത്ര വെങ്കല മണി, ടിബറ്റൻ സിംഗിംഗ് ബൗൾ, അല്ലെങ്കിൽ ഇലക്ട്രോണിക് ടോൺ (ചെറിയ ബീപ്).';

  @override
  String get helpAudioMalaBold3 => 'കൂടിക്കലരില്ല:';

  @override
  String get helpAudioMalaBullet3 =>
      '108-ാം എണ്ണം ലക്ഷ്യവും എത്തിച്ചാൽ ലക്ഷ്യ ശബ്ദം മാത്രം കേൾക്കും.';

  @override
  String get helpAudioGoalSection => 'ദിവസ ലക്ഷ്യം';

  @override
  String get helpAudioGoalBold1 => 'അറിയിപ്പ്:';

  @override
  String get helpAudioGoalBullet1 =>
      'ദിവസ ലക്ഷ്യം എത്തുമ്പോൾ ശബ്ദം കേൾക്കും, ഫോൺ വൈബ്രേറ്റ് ചെയ്യും, സ്റ്റാറ്റസ് ബാറിൽ അറിയിപ്പ് വരും.';

  @override
  String get helpAudioGoalBold2 => 'ലക്ഷ്യ ശബ്ദം:';

  @override
  String get helpAudioGoalBullet2 =>
      'സിസ്റ്റം സ്ഥിരസ്ഥിതി, ഫോണിലെ റിംഗ്‌ടോൺ, ആപ്പിലെ ശബ്ദം (ക്ഷേത്ര മണി, സിംഗിംഗ് ബൗൾ, ഇലക്ട്രോണിക് ടോൺ, ശംഖ്), അല്ലെങ്കിൽ സ്വന്തം ഓഡിയോ ഫയൽ (MP3, WAV, AAC) തിരഞ്ഞെടുക്കാം.';

  @override
  String get helpAudioGoalBold3 => 'കേട്ടുനോക്കുക:';

  @override
  String get helpAudioGoalBullet3 =>
      'തിരഞ്ഞെടുത്ത ശബ്ദം കേൾക്കാൻ \'ടോൺ പ്രിവ്യൂ\' തൊടുക.';

  @override
  String get helpAudioLifetimeSection => 'ആജീവനാന്ത ലക്ഷ്യം';

  @override
  String get helpAudioLifetimeBold1 => 'ആജീവനാന്ത ലക്ഷ്യ ശബ്ദം:';

  @override
  String get helpAudioLifetimeBullet1 =>
      'ആജീവനാന്ത ലക്ഷ്യം എത്തുന്ന നിമിഷത്തിന് പ്രത്യേക ശബ്ദം.';

  @override
  String get helpAudioLifetimeBold2 => 'ആജീവനാന്ത ലക്ഷ്യ അറിയിപ്പ്:';

  @override
  String get helpAudioLifetimeBullet2 =>
      'ആജീവനാന്ത ലക്ഷ്യം എത്തുമ്പോൾ ശബ്ദവും വൈബ്രേഷനും അറിയിപ്പും ലഭിക്കാൻ ഇത് ഓൺ ചെയ്യുക.';

  @override
  String get helpAudioVolumeSection => 'കേൾക്കാൻ മതിയായ ശബ്ദം';

  @override
  String get helpAudioVolumeBold1 => 'അലാറം ചാനൽ:';

  @override
  String get helpAudioVolumeBullet1 =>
      'പൂർത്തീകരണ ശബ്ദങ്ങൾ അലാറം ചാനലിലൂടെ വരുന്നതിനാൽ ഫോൺ സൈലന്റിൽ ആണെങ്കിലും കേൾക്കാം. കുറച്ച് സെക്കൻഡിന് ശേഷം ശബ്ദനില സാധാരണ നിലയിലാകും.';

  @override
  String get helpDisplayIntro =>
      'ശാന്തമായി ജപിക്കാൻ ഈ ക്രമീകരണങ്ങൾ സഹായിക്കുന്നു, ആപ്പിന്റെ രൂപവും ഭാഷയും തിരഞ്ഞെടുക്കാനും.';

  @override
  String get helpDisplayBrightSection => 'പ്രകാശവും മങ്ങലും';

  @override
  String get helpDisplayBrightBold1 => 'പ്രകാശ നില:';

  @override
  String get helpDisplayBrightBullet1 =>
      'ക്രമീകരണങ്ങൾ → പ്രദർശനവും നിശ്ശബ്ദതയും എന്നതിൽ \'still\' (മങ്ങിയ) മുതൽ \'full\' വരെ ഒരു നില തിരഞ്ഞെടുക്കുക. ഇത് ആപ്പിന്റെ സ്ക്രീൻ മാത്രം മാറ്റും, ഫോണിന്റെ പ്രകാശം മാറില്ല.';

  @override
  String get helpDisplayBrightBold2 => 'സിസ്റ്റം ഉപയോഗിക്കുക:';

  @override
  String get helpDisplayBrightBullet2 =>
      'ഫോണിന്റെ സാധാരണ പ്രകാശത്തിലേക്ക് മടങ്ങാൻ \'use system\' തൊടുക.';

  @override
  String get helpDisplayBrightBold3 => 'മങ്ങിയ ജപ രീതി:';

  @override
  String get helpDisplayBrightBullet3 =>
      'മാലാവൃത്തം വ്യക്തമായി നിലനിർത്തി എണ്ണൽ സ്ക്രീനിന്റെ പശ്ചാത്തലം ഇരുണ്ടതാക്കും. ഇരുണ്ട മുറികൾക്ക് നല്ലത്, ബാറ്ററിയും ലാഭിക്കും.';

  @override
  String get helpDisplayDndSection => 'ശല്യപ്പെടുത്തരുത് (DND)';

  @override
  String get helpDisplayDndBold1 => 'അറിയിപ്പുകൾ നിശബ്ദമാക്കുക:';

  @override
  String get helpDisplayDndBullet1 =>
      'ഓൺ ആണെങ്കിൽ, എണ്ണൽ സ്ക്രീൻ തുറന്നിരിക്കുമ്പോൾ ഫോൺ DND-യിലാകും, പുറത്തുപോകുമ്പോൾ സാധാരണ നിലയിലാകും.';

  @override
  String get helpDisplayDndBold2 => 'അനുമതി:';

  @override
  String get helpDisplayDndBullet2 =>
      'ആദ്യ തവണ DND അനുമതി നൽകാൻ ആപ്പ് ആവശ്യപ്പെടും. \'ക്രമീകരണങ്ങൾ തുറക്കുക\' തൊട്ട് ഈ ആപ്പിന് അനുമതി നൽകുക.';

  @override
  String get helpDisplayMindfulSection => 'ശ്രദ്ധാപൂർവ്വമായ എണ്ണൽ';

  @override
  String get helpDisplayMindfulBold1 => 'മേരു വിരാമം:';

  @override
  String get helpDisplayMindfulBullet1 =>
      'ഓരോ മാലയ്ക്കും ശേഷം 3, 5 അല്ലെങ്കിൽ 10 സെക്കൻഡ് ചെറിയ വിരാമം. ആ സമയത്തെ തൊടൽ എണ്ണില്ല. സാധാരണ ഓഫ്.';

  @override
  String get helpDisplayMindfulBold2 => 'സൗമ്യമായ വേഗ സൂചന:';

  @override
  String get helpDisplayMindfulBullet2 =>
      'വളരെ വേഗത്തിൽ തൊടുമ്പോൾ മൃദുവായ തിളക്കം. എല്ലാ തൊടലും എണ്ണും. സാധാരണ ഓൺ.';

  @override
  String get helpDisplayLangSection => 'ഭാഷ';

  @override
  String get helpDisplayLangBold1 => 'ഭാഷ തിരഞ്ഞെടുക്കുക:';

  @override
  String get helpDisplayLangBullet1 =>
      'ക്രമീകരണങ്ങൾ → ഭാഷ എന്നതിൽ ഇംഗ്ലീഷ്, മലയാളം, സംസ്കൃതം, അല്ലെങ്കിൽ സിസ്റ്റം സ്ഥിരസ്ഥിതി തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpDisplayLangBold2 => 'ഏത് ലിപിയും:';

  @override
  String get helpDisplayLangBullet2 =>
      'ആപ്പിന്റെ ഭാഷ ഏതായാലും കൗണ്ടറിന്റെ പേര് ഏത് ലിപിയിലും എഴുതാം.';

  @override
  String get helpDisplayLookSection => 'രൂപഭാവം';

  @override
  String get helpDisplayLookBold1 => 'ക്ഷേത്ര ശൈലി:';

  @override
  String get helpDisplayLookBullet1 =>
      'ക്രമീകരണങ്ങൾ → രൂപഭാവം എന്നതിൽ ആപ്പിലെ നിറങ്ങളും (ക്രീം, സിന്ദൂരം, ചന്ദനം, തുളസി, റോസ്) അക്ഷരരൂപങ്ങളും കാണാം.';

  @override
  String get helpDisplayLookBold2 => 'നിവർന്ന നില മാത്രം:';

  @override
  String get helpDisplayLookBullet2 =>
      'ഒറ്റക്കൈ കൊണ്ട് എണ്ണാൻ ആപ്പ് എപ്പോഴും നിവർന്ന നിലയിൽ ആയിരിക്കും.';

  @override
  String get helpOpticalHowBold4 => 'ലയനം:';

  @override
  String get helpOpticalHowBullet4 =>
      'തിരഞ്ഞെടുത്ത കൗണ്ടറുകൾ സ്വീകരിക്കുന്ന ഫോണിൽ ചേർക്കും. അവിടെ നേരത്തേ ഉള്ള അതേ കൗണ്ടർ ലഭിച്ച പകർപ്പ് കൊണ്ട് മാറ്റും. ആ ഫോണിലെ മറ്റ് കൗണ്ടറുകൾ മാറില്ല.';

  @override
  String get helpOpticalSendSection => 'അയയ്ക്കുന്ന ഫോണിലെ നിയന്ത്രണങ്ങൾ';

  @override
  String get helpOpticalSendBold1 => 'വേഗം:';

  @override
  String get helpOpticalSendBullet1 =>
      'സെക്കൻഡിൽ 8, 12 അല്ലെങ്കിൽ 15 ഫ്രെയിം തിരഞ്ഞെടുക്കാം. 8 ആണ് സാധാരണ, മിക്ക ഫോണുകളിലും ഏറ്റവും നല്ലത്.';

  @override
  String get helpOpticalSendBold2 => 'നിർത്തലും തുടരലും:';

  @override
  String get helpOpticalSendBullet2 =>
      'എപ്പോൾ വേണമെങ്കിലും നിർത്തി വീണ്ടും തുടരാം.';

  @override
  String get helpOpticalSendBold3 => 'പ്രകാശം:';

  @override
  String get helpOpticalSendBullet3 =>
      'മറ്റേ ക്യാമറയ്ക്ക് ബുദ്ധിമുട്ടുണ്ടെങ്കിൽ സ്ലൈഡർ ഉപയോഗിച്ച് സ്ക്രീൻ കൂടുതൽ പ്രകാശമുള്ളതാക്കാം. അയയ്ക്കൽ നിർത്തുമ്പോൾ സാധാരണ നിലയിലാകും. അയയ്ക്കുമ്പോൾ സ്ക്രീൻ ഓഫാകില്ല.';

  @override
  String get helpOpticalReceiveSection => 'സ്വീകരിക്കുന്ന ഫോണിലെ നിയന്ത്രണങ്ങൾ';

  @override
  String get helpOpticalReceiveBold1 => 'ഫോക്കസ് ചെയ്യാൻ തൊടുക:';

  @override
  String get helpOpticalReceiveBullet1 =>
      'കോഡിൽ ഫോക്കസ് ചെയ്യാൻ ക്യാമറ ദൃശ്യത്തിൽ തൊടുക.';

  @override
  String get helpOpticalReceiveBold2 => 'സൂം:';

  @override
  String get helpOpticalReceiveBullet2 =>
      'കോഡ് ചെറുതായി തോന്നിയാൽ സൂം സ്ലൈഡർ (4× വരെ) ഉപയോഗിക്കുക.';

  @override
  String get helpOpticalReceiveBold3 => 'വെളിച്ചം:';

  @override
  String get helpOpticalReceiveBullet3 => 'ഇരുണ്ട മുറിയിൽ ടോർച്ച് ഓൺ ചെയ്യുക.';

  @override
  String get helpOpticalReceiveBold4 => 'ലഭിച്ച ഫ്രെയിമുകൾ:';

  @override
  String get helpOpticalReceiveBullet4 =>
      'എല്ലാ ഭാഗങ്ങളും പൂർത്തിയാകുന്നതിന് മുമ്പുതന്നെ സ്കാനിംഗ് നടക്കുന്നുണ്ടെന്ന് ഈ വരി കാണിക്കും.';

  @override
  String get helpBackupWhereSection => 'എവിടെ കാണാം';

  @override
  String get helpBackupWhereBold1 => 'ക്രമീകരണങ്ങൾ:';

  @override
  String get helpBackupWhereBullet1 =>
      'ക്രമീകരണങ്ങൾ → ഡാറ്റ ബാക്കപ്പും ഒപ്റ്റിക്കൽ സിങ്കും എന്നതിൽ എക്സ്പോർട്ട്, ഇംപോർട്ട്, ഒപ്റ്റിക്കൽ സിങ്ക്, ഡാറ്റ മുഴുവൻ മായ്ക്കുക എന്നിവയുണ്ട്.';

  @override
  String get helpBackupWhereBold2 => 'ഹോം മെനു:';

  @override
  String get helpBackupWhereBullet2 =>
      'ഹോം സ്ക്രീനിലെ മെനുവിലും ഇംപോർട്ട് / എക്സ്പോർട്ട് ഉണ്ട്.';

  @override
  String get helpBackupExportBold4 => 'ഷെയർ ഷീറ്റ്:';

  @override
  String get helpBackupExportBullet4 =>
      'എക്സ്പോർട്ടിന് ശേഷം ആൻഡ്രോയിഡ് ഷെയർ ഷീറ്റ് തുറക്കും. ഫയൽ ഫോണിലോ മെമ്മറി കാർഡിലോ സേവ് ചെയ്യുക, അല്ലെങ്കിൽ വിശ്വസിക്കുന്ന ആപ്പ് വഴി അയയ്ക്കുക.';

  @override
  String get helpBackupImportBold4 => 'സുരക്ഷിത പുനഃസ്ഥാപനം:';

  @override
  String get helpBackupImportBullet4 =>
      'ഫയൽ ആദ്യം പരിശോധിക്കും. കേടായതാണെങ്കിലോ പാസ്ഫ്രേസ് തെറ്റാണെങ്കിലോ ഒന്നും മാറില്ല, പിശക് കാണിക്കും.';

  @override
  String get helpBackupImportBold5 => 'പഴയ ബാക്കപ്പുകൾ:';

  @override
  String get helpBackupImportBullet5 =>
      'ഈ ആപ്പിന്റെ പഴയ ആൻഡ്രോയിഡ് പതിപ്പിലെ ബാക്കപ്പ് ഫയലുകളും ഇംപോർട്ട് ചെയ്യാം.';

  @override
  String get helpBackupClearSection => 'ഡാറ്റ മുഴുവൻ മായ്ക്കുക';

  @override
  String get helpBackupClearBold1 => 'എല്ലാം മായ്ക്കുക:';

  @override
  String get helpBackupClearBullet1 =>
      'ഉറപ്പാക്കിയ ശേഷം എല്ലാ കൗണ്ടറുകളും മുഴുവൻ ചരിത്രവും ഡിലീറ്റ് ചെയ്യും. തിരികെ കിട്ടില്ല, അതിനാൽ ആദ്യം ബാക്കപ്പ് എടുക്കുക.';

  @override
  String get helpPrivacyStorageBold3 => 'സുരക്ഷിത സേവ്:';

  @override
  String get helpPrivacyStorageBullet3 =>
      'ആപ്പ് പെട്ടെന്ന് അടഞ്ഞാലും ഇടയ്ക്കിടെയുള്ള സേവ് എണ്ണം സുരക്ഷിതമാക്കും.';

  @override
  String get helpPrivacyPermsSection => 'ആപ്പ് ഉപയോഗിക്കുന്ന അനുമതികൾ';

  @override
  String get helpPrivacyPermsBold1 => 'ക്യാമറ:';

  @override
  String get helpPrivacyPermsBullet1 =>
      'ഒപ്റ്റിക്കൽ സിങ്ക് സ്വീകരിക്കുമ്പോൾ QR കോഡ് സ്കാൻ ചെയ്യാൻ മാത്രം. ഫോട്ടോയോ വീഡിയോയോ എടുക്കില്ല.';

  @override
  String get helpPrivacyPermsBold2 => 'അറിയിപ്പുകൾ:';

  @override
  String get helpPrivacyPermsBullet2 =>
      'സ്റ്റാറ്റസ് ബാറിൽ ലക്ഷ്യ സന്ദേശങ്ങൾ കാണിക്കാൻ. ആൻഡ്രോയിഡ് 13-ലും പിന്നീടും ചോദിക്കും.';

  @override
  String get helpPrivacyPermsBold3 => 'വൈബ്രേഷനും ഓഡിയോയും:';

  @override
  String get helpPrivacyPermsBullet3 =>
      'മാല, ലക്ഷ്യം, തിരുത്തൽ എന്നിവയുടെ പ്രതികരണത്തിനും പൂർത്തീകരണ ശബ്ദം വ്യക്തമായി കേൾപ്പിക്കാനും.';

  @override
  String get helpPrivacyPermsBold4 => 'DND അനുമതി:';

  @override
  String get helpPrivacyPermsBullet4 =>
      'പ്രദർശനവും നിശ്ശബ്ദതയും എന്നതിൽ DND ഓൺ ചെയ്താൽ മാത്രം ചോദിക്കും.';

  @override
  String get helpPrivacyPermsBold5 => 'നിങ്ങളുടെ ഫയലുകൾ:';

  @override
  String get helpPrivacyPermsBullet5 =>
      'ആപ്പ് നിങ്ങളുടെ ഫയലുകൾ വായിക്കില്ല. ഇംപോർട്ടും എക്സ്പോർട്ടും ആൻഡ്രോയിഡ് ഫയൽ പിക്കർ ഉപയോഗിക്കുന്നു, അവിടെ നിങ്ങൾ ഫയൽ തിരഞ്ഞെടുക്കുന്നു.';

  @override
  String get helpPrivacyPermsBold6 => 'മുഴുവൻ പട്ടിക:';

  @override
  String get helpPrivacyPermsBullet6 =>
      'ക്രമീകരണങ്ങൾ → അനുമതികൾ എന്നതിൽ ഓരോ അനുമതിയും എന്തിനെന്ന് കാണാം.';

  @override
  String get helpFaqQ5Title => 'എന്റെ എണ്ണം ഏത് ദിവസത്തിൽ ചേരും?';

  @override
  String get helpFaqQ5Answer =>
      'ഫോണിലെ സമയം അനുസരിച്ച് ഓരോ തൊടലും തൊട്ട ദിവസത്തിൽ തന്നെ എണ്ണും. ദിവസ ലക്ഷ്യം അർദ്ധരാത്രിയിൽ വീണ്ടും തുടങ്ങും.';

  @override
  String get helpFaqQ6Title =>
      'സെഷൻ പുനഃസജ്ജമാക്കലും കൗണ്ടർ പുനഃസജ്ജമാക്കലും തമ്മിലുള്ള വ്യത്യാസം എന്ത്?';

  @override
  String get helpFaqQ6Answer =>
      'സെഷൻ പുനഃസജ്ജമാക്കൽ ഇപ്പോഴത്തെ ഇരിപ്പ് മാത്രം ഉപേക്ഷിക്കും. കൗണ്ടർ പുനഃസജ്ജമാക്കൽ ആ കൗണ്ടറിന്റെ മുഴുവൻ ചരിത്രവും ഡിലീറ്റ് ചെയ്യും, തിരികെ കിട്ടില്ല.';

  @override
  String get helpFaqQ7Title => 'മാല ശബ്ദം എന്തുകൊണ്ട് കേട്ടില്ല?';

  @override
  String get helpFaqQ7Answer =>
      'മാല ശബ്ദം ഓൺ ആണോ എന്ന് നോക്കുക. അതേ തൊടലിൽ ലക്ഷ്യവും എത്തിയാൽ ലക്ഷ്യ ശബ്ദം മാത്രം കേൾക്കും.';

  @override
  String get helpFaqQ8Title =>
      'ഫോൺ സൈലന്റിൽ ആയിട്ടും ശബ്ദം എന്തുകൊണ്ട് കേൾക്കുന്നു?';

  @override
  String get helpFaqQ8Answer =>
      'നഷ്ടപ്പെടാതിരിക്കാൻ പൂർത്തീകരണ ശബ്ദങ്ങൾ അലാറം ചാനൽ ഉപയോഗിക്കുന്നു. നിശബ്ദത വേണമെങ്കിൽ ക്രമീകരണങ്ങൾ → ശബ്ദവും സ്പന്ദനവും എന്നതിൽ ശബ്ദങ്ങൾ ഓഫ് ചെയ്യുക.';

  @override
  String get helpFaqQ9Title => 'ബാക്കപ്പ് പാസ്ഫ്രേസ് മറന്നു. എന്ത് ചെയ്യാം?';

  @override
  String get helpFaqQ9Answer =>
      'പാസ്ഫ്രേസ് തിരികെ കിട്ടില്ല, ആ ഫയൽ തുറക്കാനുമാവില്ല. ഡാറ്റ ഇപ്പോഴുമുള്ള ഫോണിൽ നിന്ന് പുതിയ ബാക്കപ്പ് എടുക്കുക.';

  @override
  String get helpFaqQ10Title => 'ഇംപോർട്ട് ഇപ്പോഴത്തെ കൗണ്ടറുകൾ നീക്കുമോ?';

  @override
  String get helpFaqQ10Answer =>
      'ബാക്കപ്പ് ഫയൽ ഇംപോർട്ട് ചെയ്താൽ ഇപ്പോഴത്തെ എല്ലാ ഡാറ്റയും മാറും. ഒപ്റ്റിക്കൽ സിങ്ക് വ്യത്യസ്തമാണ്: നിങ്ങൾ തിരഞ്ഞെടുക്കുന്ന കൗണ്ടറുകൾ മാത്രം ചേർക്കുകയോ പുതുക്കുകയോ ചെയ്യും.';

  @override
  String get helpFaqQ11Title =>
      'ഒപ്റ്റിക്കൽ സിങ്ക് സ്കാനിംഗ് മന്ദഗതിയിലാണ്. എന്ത് ചെയ്യാം?';

  @override
  String get helpFaqQ11Answer =>
      'ഫോൺ 15–25 സെ.മീ. അകലെ ഇളകാതെ പിടിക്കുക, ഫോക്കസിനായി തൊടുക, പ്രതിഫലനം ഒഴിവാക്കുക, അയയ്ക്കുന്ന ഫോണിന്റെ പ്രകാശം കൂട്ടുക. സെക്കൻഡിൽ 8 ഫ്രെയിം പോലുള്ള കുറഞ്ഞ വേഗം പരീക്ഷിക്കുക.';

  @override
  String get helpFaqQ12Title => 'ഡാറ്റ പുതിയ ഫോണിലേക്ക് മാറ്റാമോ?';

  @override
  String get helpFaqQ12Answer =>
      'അതെ. രണ്ട് ഫോണുകളും അടുത്തടുത്ത് വച്ച് ഒപ്റ്റിക്കൽ സിങ്ക് ഉപയോഗിക്കുക, അല്ലെങ്കിൽ ബാക്കപ്പ് ഫയൽ എക്സ്പോർട്ട് ചെയ്ത് പുതിയ ഫോണിൽ ഇംപോർട്ട് ചെയ്യുക.';

  @override
  String get helpFaqQ13Title => 'ആപ്പ് എന്തുകൊണ്ട് പൂർണ്ണമായി ഓഫ്‌ലൈൻ ആണ്?';

  @override
  String get helpFaqQ13Answer =>
      'ജപം വ്യക്തിപരവും പവിത്രവുമാണ്. ഓഫ്‌ലൈൻ ആയിരിക്കുന്നത് സാധന സ്വകാര്യമാക്കുന്നു, ബാറ്ററി ലാഭിക്കുന്നു, ശ്രദ്ധ തിരിയൽ ഒഴിവാക്കുന്നു.';

  @override
  String get helpFaqQ14Title => 'എന്റെ ഡാറ്റ ആരുമായെങ്കിലും പങ്കിടുന്നുണ്ടോ?';

  @override
  String get helpFaqQ14Answer =>
      'ഇല്ല. നിങ്ങൾ തന്നെ എക്സ്പോർട്ട് ചെയ്യുകയോ ഒപ്റ്റിക്കൽ സിങ്ക് വഴി അയയ്ക്കുകയോ ചെയ്യാതെ ഡാറ്റ ഫോണിൽ നിന്ന് പുറത്തുപോകില്ല.';
}
