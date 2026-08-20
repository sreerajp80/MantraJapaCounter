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
  String get menuAbout => 'കുറിച്ച്';

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
  String get aboutTitle => 'കുറിച്ച്';

  @override
  String versionLabel(String version) {
    return 'പതിപ്പ് $version';
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
  String get aboutMantraQuote => 'ഓം നമഃ ശിവായ';

  @override
  String get aboutMadeWithPrefix => 'സ്നേഹത്തോടെ ';

  @override
  String get aboutMadeWithSuffix => ' ഇന്ത്യയിൽ നിന്ന്';

  @override
  String get settingsTitle => 'ക്രമീകരണങ്ങൾ';

  @override
  String get practiceEyebrow => 'അഭ്യാസം';

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
  String get sectionStillness => 'നിശ്ചലത';

  @override
  String get sectionStillnessSub => 'ദൈർഘ്യമേറിയ സെഷനുകൾക്ക്';

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
      'എണ്ണൽ രീതികൾ, 108 മാല കണക്കുകൂട്ടൽ, ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ്പ് സിങ്ക്, സ്വകാര്യത എന്നിവയ്ക്കുള്ള ഗൈഡുകൾ.';

  @override
  String get helpCategoryCounting => 'എണ്ണലും ധ്യാന സാധനയും';

  @override
  String get helpCategorySync => 'ഡാറ്റ സിങ്കും ബാക്കപ്പും';

  @override
  String get helpCategoryAudio => 'ഓഡിയോയും ഫീഡ്‌ബാക്കും';

  @override
  String get helpCategoryPrivacy => 'സ്വകാര്യതയും പിന്തുണയും';

  @override
  String get helpTopicCountingTitle => 'എണ്ണലും ആംഗ്യങ്ങളും ഗൈഡ്';

  @override
  String get helpTopicCountingSub =>
      'വളയത്തിൽ എവിടെയും ടാപ്പ് ചെയ്യുക, രണ്ട് വിരൽ സ്വൈപ്പ് വഴി പഴയപടിയാക്കൽ';

  @override
  String get helpTopicMalaTitle => '108 മാല കണക്കുകൂട്ടലും ലക്ഷ്യങ്ങളും';

  @override
  String get helpTopicMalaSub =>
      '108 മണി ചക്രങ്ങൾ, അധിക എണ്ണങ്ങൾ, ദൈനംദിന ലക്ഷ്യങ്ങൾ';

  @override
  String get helpTopicOpticalSyncTitle => 'ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ്പ് സിങ്ക്';

  @override
  String get helpTopicOpticalSyncSub =>
      'ആനിമേഷൻ ചെയ്ത ക്യുആർ സ്ട്രീം വഴി ഫോണുകൾ തമ്മിൽ ഓഫ്‌ലൈൻ കൈമാറ്റം';

  @override
  String get helpTopicBackupTitle => 'JSON ബാക്കപ്പും പുനഃസ്ഥാപനവും';

  @override
  String get helpTopicBackupSub =>
      'ലോക്കൽ ബാക്കപ്പ് ഫയലുകൾ എക്സ്പോർട്ട് ചെയ്യലും സുരക്ഷിത പുനഃസ്ഥാപനവും';

  @override
  String get helpTopicAudioTitle => 'ശബ്ദവും വൈബ്രേഷനും ക്രമീകരണങ്ങൾ';

  @override
  String get helpTopicAudioSub =>
      'ക്ഷേത്ര മണി ശബ്ദങ്ങൾ, മാല നാദങ്ങൾ, വൈബ്രേഷൻ ഫീഡ്‌ബാക്ക്';

  @override
  String get helpTopicPrivacyTitle => 'സ്വകാര്യതയും ഓഫ്‌ലൈൻ രൂപകൽപ്പനയും';

  @override
  String get helpTopicPrivacySub =>
      'ഇന്റർനെറ്റ് അനുമതികളില്ല, ലോക്കൽ SQLite സ്റ്റോറേജ്, സീറോ ടെലിമെട്രി';

  @override
  String get helpTopicFaqTitle => 'പതിവുചോദ്യങ്ങളും പരിഹാരങ്ങളും';

  @override
  String get helpTopicFaqSub =>
      'സാധാരണ ചോദ്യങ്ങൾ, സംശയങ്ങൾ, സഹായകരമായ നുറുങ്ങുകൾ';

  @override
  String get helpCountingIntro =>
      'ധ്യാനത്തിൽ പൂർണ്ണമായി മുഴുകാൻ വേണ്ടിയാണ് എണ്ണൽ സ്ക്രീൻ രൂപകൽപ്പന ചെയ്തിരിക്കുന്നത്. ജപിക്കുമ്പോൾ സ്ക്രീനിലേക്ക് നോക്കേണ്ടതില്ല.';

  @override
  String get helpCountingTapSection => 'എങ്ങനെ എണ്ണാം';

  @override
  String get helpCountingTapBold1 => 'എവിടെയും ടാപ്പ് ചെയ്യുക:';

  @override
  String get helpCountingTapBullet1 =>
      '1 എണ്ണം കൂട്ടാൻ വലിയ വൃത്തത്തിനുള്ളിലോ സ്ക്രീനിലോ എവിടെയും ടാപ്പ് ചെയ്യുക.';

  @override
  String get helpCountingTapBold2 => 'ഹാപ്റ്റിക് പൾസ്:';

  @override
  String get helpCountingTapBullet2 =>
      'ഓരോ ജപത്തിനും മൃദുവായ വൈബ്രേഷൻ ലഭിക്കുന്നു, അതിനാൽ കണ്ണുകൾ അടച്ച് ജപിക്കാം.';

  @override
  String get helpCountingTapBold3 => 'ക്രാഷ് റിക്കവറി:';

  @override
  String get helpCountingTapBullet3 =>
      'ഓരോ 5 ടാപ്പുകളും സ്വയമേവ സേവ് ചെയ്യപ്പെടുന്നു.';

  @override
  String get helpCountingUndoSection => 'തെറ്റായ എണ്ണം തിരുത്തൽ';

  @override
  String get helpCountingUndoBold1 => 'രണ്ട് വിരൽ സ്വൈപ്പ്:';

  @override
  String get helpCountingUndoBullet1 =>
      'എണ്ണം 1 കുറയ്ക്കാൻ മാല വൃത്തത്തിൽ രണ്ട് വിരലുകൾ വെച്ച് ഇടത്തോട്ടോ വലത്തോട്ടോ സ്വൈപ്പ് ചെയ്യുക.';

  @override
  String get helpCountingUndoBold2 => 'പൂജ്യം എണ്ണം:';

  @override
  String get helpCountingUndoBullet2 =>
      'എണ്ണം പൂജ്യമായാൽ സെഷൻ മായ്ച്ചു കളയുന്നു.';

  @override
  String get helpCountingTimerSection => 'സെഷൻ സമയവും നിലയും';

  @override
  String get helpCountingTimerBold1 => 'ടൈമർ:';

  @override
  String get helpCountingTimerBullet1 =>
      'മുകളിലെ പിൽ ഈ സെഷനിൽ ചെലവഴിച്ച സമയം കാണിക്കുന്നു.';

  @override
  String get helpCountingTimerBold2 => 'പുരോഗതി ബാഡ്ജ്:';

  @override
  String get helpCountingTimerBullet2 =>
      'നിലവിലെ 108 ചക്രം പൂർത്തിയാക്കാൻ ബാക്കിയുള്ള മണികൾ കാണിക്കുന്നു.';

  @override
  String get helpMalaIntro =>
      'പരമ്പരാഗത സാധനയിൽ ഒരു ജപമാലയിൽ 108 മണികൾ അടങ്ങിയിരിക്കുന്നു.';

  @override
  String get helpMalaBeadsSection => '108 മണികളുടെ കണക്കുകൂട്ടൽ';

  @override
  String get helpMalaBeadsBold1 => '1 മാല = 108 ജപങ്ങൾ:';

  @override
  String get helpMalaBeadsBullet1 =>
      'ഓരോ 108 ജപങ്ങളും 1 പൂർണ്ണ മാലയായി മാറുന്നു.';

  @override
  String get helpMalaBeadsBold2 => 'അധിക എണ്ണങ്ങൾ:';

  @override
  String get helpMalaBeadsBullet2 =>
      'മാല കഴിഞ്ഞുള്ള അധിക ജപങ്ങൾ വ്യക്തമായി കാണിക്കുന്നു.';

  @override
  String get helpMalaBeadsBold3 => 'മാല മണിനാദം:';

  @override
  String get helpMalaBeadsBullet3 =>
      'ഓരോ 108-ാമത്തെ ജപത്തിലും മൃദുവായ മണി മുഴങ്ങുന്നു.';

  @override
  String get helpMalaGoalsSection => 'ലക്ഷ്യങ്ങൾ ക്രമീകരിക്കൽ';

  @override
  String get helpMalaGoalsBold1 => 'ദൈനംദിന ലക്ഷ്യം:';

  @override
  String get helpMalaGoalsBullet1 =>
      'ദിവസേന എത്ര മാല ജപിക്കണമെന്ന് ക്രമീകരിക്കാം.';

  @override
  String get helpMalaGoalsBold2 => 'ആജീവനാന്ത ലക്ഷ്യം:';

  @override
  String get helpMalaGoalsBullet2 => 'ദീർഘകാല സാധനാ ലക്ഷ്യങ്ങൾ നിശ്ചയിക്കാം.';

  @override
  String get helpOpticalIntro =>
      'ഇന്റർനെറ്റോ ബ്ലൂടൂത്തോ ഇല്ലാതെ രണ്ട് ഫോണുകൾ തമ്മിൽ ഡാറ്റ മാറ്റാൻ ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ്പ് സിങ്ക് സഹായിക്കുന്നു.';

  @override
  String get helpOpticalHowSection => 'എങ്ങനെ കൈമാറാം';

  @override
  String get helpOpticalHowBold1 => 'അയക്കുന്ന ഫോണിൽ:';

  @override
  String get helpOpticalHowBullet1 =>
      'Settings -> Optical Air-Gap Sync (Send) തുറക്കുക. ആനിമേറ്റഡ് ക്യുആർ കാണാം.';

  @override
  String get helpOpticalHowBold2 => 'സ്വീകരിക്കുന്ന ഫോണിൽ:';

  @override
  String get helpOpticalHowBullet2 =>
      'Settings -> Optical Air-Gap Sync (Receive) തുറന്ന് ക്യാമറ കാണിക്കുക.';

  @override
  String get helpOpticalHowBold3 => 'ഡാറ്റ പുനഃസൃഷ്ടി:';

  @override
  String get helpOpticalHowBullet3 =>
      'ഡാറ്റ നിമിഷങ്ങൾക്കകം പൂർണ്ണമായി ഫോണിൽ ലഭിക്കുന്നു.';

  @override
  String get helpOpticalTipsSection => 'വേഗത്തിൽ സ്കാൻ ചെയ്യാൻ';

  @override
  String get helpOpticalTipsBold1 => 'തെളിച്ചം:';

  @override
  String get helpOpticalTipsBullet1 =>
      'അയക്കുന്ന സ്ക്രീൻ തെളിച്ചമുള്ളതാണെന്ന് ഉറപ്പാക്കുക.';

  @override
  String get helpOpticalTipsBold2 => 'അകലം:';

  @override
  String get helpOpticalTipsBullet2 =>
      '15 മുതൽ 25 സെന്റിമീറ്റർ അകലെ ക്യാമറ പിടിക്കുക.';

  @override
  String get helpOpticalTipsBold3 => 'ഫൗണ്ടൻ കോഡുകൾ:';

  @override
  String get helpOpticalTipsBullet3 =>
      'ചില ഫ്രെയിമുകൾ നഷ്ടപ്പെട്ടാലും ഡാറ്റ കൃത്യമായി ലഭിക്കുന്നു.';

  @override
  String get helpAudioIntro =>
      'മണി ശബ്ദങ്ങളും വൈബ്രേഷനും ഉപയോഗിച്ച് നിങ്ങളുടെ ജപ സാധന ക്രമീകരിക്കുക.';

  @override
  String get helpAudioTonesSection => 'നാദങ്ങളും ശബ്ദങ്ങളും';

  @override
  String get helpAudioTonesBold1 => 'ദൈനംദിന ലക്ഷ്യ ശബ്ദം:';

  @override
  String get helpAudioTonesBullet1 =>
      'ലക്ഷ്യം പൂർത്തിയാകുമ്പോൾ ശാന്തമായ മണി മുഴങ്ങുന്നു.';

  @override
  String get helpAudioTonesBold2 => 'മാല നാദം:';

  @override
  String get helpAudioTonesBullet2 =>
      'ഓരോ 108 മണി പൂർത്തിയാകുമ്പോൾ നേർത്ത മണിനാദം കേൾക്കാം.';

  @override
  String get helpAudioTonesBold3 => 'ഇഷ്ടാനുസൃത ഓഡിയോ:';

  @override
  String get helpAudioTonesBullet3 =>
      'നിങ്ങളുടെ ഫോണിലെ ഏത് ഓഡിയോ ഫയലും തിരഞ്ഞെടുക്കാം.';

  @override
  String get helpAudioVibrationSection => 'വൈബ്രേഷൻ';

  @override
  String get helpAudioVibrationBold1 => 'എണ്ണൽ സ്പന്ദനം:';

  @override
  String get helpAudioVibrationBullet1 =>
      'സ്ക്രീനിൽ നോക്കാതെ എണ്ണാൻ സഹായിക്കുന്ന മൃദു സ്പന്ദനം.';

  @override
  String get helpAudioVibrationBold2 => 'ഓഫ് ചെയ്യാം:';

  @override
  String get helpAudioVibrationBullet2 =>
      'ക്രമീകരണങ്ങളിൽ നിന്ന് എപ്പോൾ വേണമെങ്കിലും വൈബ്രേഷൻ മാറ്റാം.';

  @override
  String get helpBackupIntro =>
      'നിങ്ങളുടെ ജപ ഡാറ്റ നിങ്ങളുടെ സ്വന്തമാണ്. എപ്പോൾ വേണമെങ്കിലും ബാക്കപ്പ് ഫയൽ എക്സ്പോർട്ട് ചെയ്യാം.';

  @override
  String get helpBackupExportSection => 'ഡാറ്റ എക്സ്പോർട്ട് ചെയ്യൽ';

  @override
  String get helpBackupExportBold1 => 'JSON ഫയൽ:';

  @override
  String get helpBackupExportBullet1 =>
      'എല്ലാ കൗണ്ടറുകളും ചരിത്രവും ഒറ്റ ഫയലിലേക്ക് എക്സ്പോർട്ട് ചെയ്യുന്നു.';

  @override
  String get helpBackupExportBold2 => 'ഷെയർ ഷീറ്റ്:';

  @override
  String get helpBackupExportBullet2 =>
      'ലോക്കൽ ഫയലുകളിലോ എസ്ഡി കാർഡിലോ സൂക്ഷിക്കാം.';

  @override
  String get helpBackupExportBold3 => 'പൂർണ്ണ അനുയോജ്യത:';

  @override
  String get helpBackupExportBullet3 =>
      'ഭാവിയിലെ എല്ലാ പതിപ്പുകളിലും പ്രവർത്തിക്കും.';

  @override
  String get helpBackupImportSection => 'ഡാറ്റ പുനഃസ്ഥാപിക്കൽ';

  @override
  String get helpBackupImportBold1 => 'ഫയൽ തിരഞ്ഞെടുക്കൽ:';

  @override
  String get helpBackupImportBullet1 =>
      '\'ബാക്കപ്പ് ഫയൽ ഇംപോർട്ട് ചെയ്യുക\' അമർത്തി ഫയൽ തിരഞ്ഞെടുക്കുക.';

  @override
  String get helpBackupImportBold2 => 'സുരക്ഷിത പരിശോധന:';

  @override
  String get helpBackupImportBullet2 =>
      'ഡാറ്റ തകരാറുകളില്ലെന്ന് പരിശോധിച്ച ശേഷം പുനഃസ്ഥാപിക്കുന്നു.';

  @override
  String get helpBackupImportBold3 => 'തൽക്ഷണ മാറ്റം:';

  @override
  String get helpBackupImportBullet3 =>
      'എല്ലാ കൗണ്ടറുകളും ഉടൻ തന്നെ അപ്‌ഡേറ്റ് ആകുന്നു.';

  @override
  String get helpPrivacyIntro =>
      'പൂർണ്ണ സ്വകാര്യതയോടെയും ഓഫ്‌ലൈനായും പ്രവർത്തിക്കുന്ന ആപ്പാണിത്.';

  @override
  String get helpPrivacyOfflineSection => '100% ഓഫ്‌ലൈൻ രൂപകൽപ്പന';

  @override
  String get helpPrivacyOfflineBold1 => 'ഇന്റർനെറ്റ് അനുമതിയില്ല:';

  @override
  String get helpPrivacyOfflineBullet1 =>
      'ആപ്പിൽ ഇന്റർനെറ്റ് അനുമതി പൂർണ്ണമായും ഒഴിവാക്കിയിരിക്കുന്നു.';

  @override
  String get helpPrivacyOfflineBold2 => 'സീറോ ട്രാക്കിംഗ്:';

  @override
  String get helpPrivacyOfflineBullet2 =>
      'പരസ്യങ്ങളോ ട്രാക്കിംഗ് സോഫ്റ്റ്‌വെയറോ ഇല്ല.';

  @override
  String get helpPrivacyOfflineBold3 => 'ലോഗിൻ ആവശ്യമില്ല:';

  @override
  String get helpPrivacyOfflineBullet3 => 'അക്കൗണ്ടോ ഇമെയിലോ ആവശ്യമില്ല.';

  @override
  String get helpPrivacyStorageSection => 'ഡാറ്റ സംരക്ഷണം';

  @override
  String get helpPrivacyStorageBold1 => 'SQLite ഡാറ്റാബേസ്:';

  @override
  String get helpPrivacyStorageBullet1 =>
      'എല്ലാ ഡാറ്റയും നിങ്ങളുടെ ഉപകരണത്തിൽ മാത്രം സുരക്ഷിതമായി സൂക്ഷിക്കുന്നു.';

  @override
  String get helpPrivacyStorageBold2 => 'ക്രാഷ് പ്രൂഫ്:';

  @override
  String get helpPrivacyStorageBullet2 =>
      'എണ്ണങ്ങൾ നഷ്ടപ്പെടാതിരിക്കാൻ കൃത്യമായ ഇടവേളകളിൽ സേവ് ചെയ്യുന്നു.';

  @override
  String get helpFaqIntro =>
      'മന്ത്രജപ കൗണ്ടറിനെക്കുറിച്ചുള്ള പ്രധാന ചോദ്യങ്ങൾക്ക് ഉത്തരങ്ങൾ.';

  @override
  String get helpFaqQ1Title =>
      'എന്തുകൊണ്ടാണ് ആപ്പ് പൂർണ്ണമായും ഓഫ്‌ലൈൻ ആയിരിക്കുന്നത്?';

  @override
  String get helpFaqQ1Answer =>
      'ജപ ധ്യാനം തികച്ചും വ്യക്തിപരമാണ്. യാതൊരു ശ്രദ്ധാശൈഥില്യങ്ങളും ഇല്ലാതെ പൂർണ്ണ സ്വകാര്യതയോടെ ജപിക്കാൻ വേണ്ടിയാണിത്.';

  @override
  String get helpFaqQ2Title =>
      'ഇന്റർനെറ്റ് ഇല്ലാതെ ഒപ്റ്റിക്കൽ സിങ്ക് എങ്ങനെ പ്രവർത്തിക്കുന്നു?';

  @override
  String get helpFaqQ2Answer =>
      'ആനിമേറ്റഡ് ക്യുആർ കോഡുകൾ സ്ക്രീനിൽ കാണിച്ച് ക്യാമറ വഴി ഡാറ്റ ഓഫ്‌ലൈനായി കൈമാറുന്നു.';

  @override
  String get helpFaqQ3Title => 'നിശ്ചല തെളിച്ചം മോഡ് എന്തിനാണ്?';

  @override
  String get helpFaqQ3Answer =>
      'ഇരുട്ടുള്ള മുറികളിലും ക്ഷേത്രങ്ങളിലും മറ്റുള്ളവർക്ക് ബുദ്ധിമുട്ടുണ്ടാക്കാതെ ജപിക്കാൻ സ്ക്രീൻ തെളിച്ചം കുറയ്ക്കുന്നു.';

  @override
  String get helpFaqQ4Title => 'പുതിയ ഫോണിലേക്ക് ഡാറ്റ മാറ്റാൻ കഴിയുമോ?';

  @override
  String get helpFaqQ4Answer =>
      'അതെ! ഒപ്റ്റിക്കൽ എയർ-ഗ്യാപ്പ് സിങ്ക് വഴിയോ JSON ബാക്കപ്പ് ഫയൽ വഴിയോ ഡാറ്റ മാറ്റാം.';
}
