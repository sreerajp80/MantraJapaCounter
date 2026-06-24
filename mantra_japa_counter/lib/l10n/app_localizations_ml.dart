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
}
