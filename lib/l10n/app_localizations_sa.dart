// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sanskrit (`sa`).
class AppLocalizationsSa extends AppLocalizations {
  AppLocalizationsSa([String locale = 'sa']) : super(locale);

  @override
  String get appTitle => 'मन्त्रजपगणकः';

  @override
  String get cancel => 'निरस्यताम्';

  @override
  String get delete => 'विलोप्यताम्';

  @override
  String get save => 'संरक्ष्यताम्';

  @override
  String get create => 'सृज्यताम्';

  @override
  String get confirm => 'दृढीक्रियताम्';

  @override
  String get clear => 'मार्ज्यताम्';

  @override
  String get reset => 'पुनःस्थाप्यताम्';

  @override
  String get resetAll => 'सर्वं पुनःस्थाप्यताम्';

  @override
  String get export => 'निर्यातः';

  @override
  String get import => 'आयातः';

  @override
  String get play => 'वाद्यताम्';

  @override
  String get more => 'अधिकम्';

  @override
  String get notSet => 'न निर्धारितम्';

  @override
  String errorWithMessage(String message) {
    return 'दोषः: $message';
  }

  @override
  String get mantraCounters => 'मन्त्रगणकाः';

  @override
  String get menuImportExport => 'आयात-निर्यातः';

  @override
  String get menuSettings => 'संयोजनानि';

  @override
  String get menuAbout => 'विषयपरिचयः';

  @override
  String get todayChants => 'जपाः';

  @override
  String get todayMalas => 'मालाः';

  @override
  String get todayActive => 'सक्रियाः';

  @override
  String get noCountersYet => 'अद्यापि गणकाः न सन्ति';

  @override
  String get noCountersSubtitle =>
      'प्रथमां साधनाम् आरब्धुम् उपरि + चिह्नं स्पृशन्तु';

  @override
  String get aboutCounter => 'गणकस्य विषये';

  @override
  String get history => 'इतिहासः';

  @override
  String get edit => 'सम्पाद्यताम्';

  @override
  String get disableSuccess => 'निष्क्रियीकृतः (सिद्धः)';

  @override
  String get disableFailure => 'निष्क्रियीकृतः (अपूर्णः)';

  @override
  String get deleteCounterTitle => 'गणकं विलोपयितुम् इच्छन्ति किम्?';

  @override
  String deleteCounterMessage(String name) {
    return '\"$name\" इति गणकं तस्य सर्वमितिहासञ्च विलोपयितुम् इच्छन्ति किम्? एतत् पूर्ववत् कर्तुं न शक्यते।';
  }

  @override
  String get disableAsCompletedTitle =>
      'पूर्णमिति मत्वा निष्क्रियीक्रियताम् किम्?';

  @override
  String get disableCounterTitle => 'गणकं निष्क्रियीकर्तुम् इच्छन्ति किम्?';

  @override
  String get reasonOptional => 'कारणम् (ऐच्छिकम्)';

  @override
  String get reasonHint => 'यथा लक्षजपसङ्कल्पः सम्पन्नः';

  @override
  String get editCounterTitle => 'गणकः सम्पाद्यताम्';

  @override
  String get newCounterTitle => 'नवीनगणकः';

  @override
  String get counterNameLabel => 'गणकस्य नाम *';

  @override
  String get initialCountLabel => 'प्रारम्भिकगणना (पूर्वनिर्धारितम् ०)';

  @override
  String get incrementStepLabel => 'वृद्धिपदम् (पूर्वनिर्धारितम् १)';

  @override
  String get lifetimeGoalFieldLabel => 'आजीवनलक्ष्यम् (० = नास्ति)';

  @override
  String get dailyGoalFieldLabel => 'दैनिकलक्ष्यम् (० = नास्ति)';

  @override
  String get startDateLabel => 'आरम्भदिनाङ्कः: ';

  @override
  String get dailyExceedsLifetime =>
      'दैनिकलक्ष्यम् आजीवनलक्ष्यात् अधिकं भवितुं नार्हति';

  @override
  String get stepExceedsDaily => 'वृद्धिपदं दैनिकलक्ष्यात् न्यूनं भवेत्';

  @override
  String get importExportBody =>
      'निर्यातेन सर्वे गणकाः सत्राणि च JSON-सञ्चिकायां संरक्ष्यन्ते।\n\nआयातेन च वर्तमानः सर्वदत्तांशः चितसञ्चिकया प्रतिस्थाप्यते।';

  @override
  String exportFailed(String message) {
    return 'निर्यातः विफलः: $message';
  }

  @override
  String importFailed(String message) {
    return 'आयातः विफलः: $message';
  }

  @override
  String get importSuccessful => 'आयातः साफल्येन सम्पन्नः';

  @override
  String pausedWithTime(String time) {
    return 'विरामः · $time';
  }

  @override
  String get resetSession => 'सत्रं पुनःस्थाप्यताम्';

  @override
  String unfinishedMalaBanner(int chants) {
    return 'पूर्वदिनस्य अपूर्णा माला: $chants/१०८';
  }

  @override
  String get startNewSession => 'नूतनम् आरभ्यताम्';

  @override
  String get finishAndStartNew => 'समाप्य नूतनम् आरभ्यताम्';

  @override
  String get resetCounter => 'गणकः पुनःस्थाप्यताम्';

  @override
  String get ofOneHundredEight => '१०८ मध्ये';

  @override
  String get lifetimeGoalCaps => 'आजीवनलक्ष्यम्';

  @override
  String get dailyGoalCaps => 'दैनिकलक्ष्यम्';

  @override
  String beadsRemainCaps(int count) {
    return '$count मणयः अवशिष्टाः';
  }

  @override
  String malaThisSession(int count) {
    return '+$count माला अस्मिन् सत्रे';
  }

  @override
  String get footerLifetime => 'आजीवनम्';

  @override
  String get footerDaily => 'दैनिकम्';

  @override
  String get footerSession => 'सत्रम्';

  @override
  String get resetSessionTitle => 'सत्रं पुनःस्थाप्यताम् किम्?';

  @override
  String get resetSessionMessage =>
      'वर्तमानसत्रस्य गणना शून्ये पुनःस्थापिता भविष्यति।';

  @override
  String get resetCounterTitle => 'गणकः पुनःस्थाप्यताम् किम्?';

  @override
  String get resetCounterMessage =>
      'एतेन गणकस्य समग्रगणना शून्ये पुनःस्थापिता भविष्यति।';

  @override
  String get noSessionsRecorded => 'अद्यापि सत्राणि न सञ्चितानि';

  @override
  String get recentOfferings => 'सद्यः समर्पितानि';

  @override
  String get today => 'अद्य';

  @override
  String sessionCount(int count) {
    return '$count जपाः';
  }

  @override
  String get labelChants => 'जपाः';

  @override
  String get labelMala => 'माला';

  @override
  String get clearAllHistoryTitle => 'सर्वः सञ्चितः इतिहासः विलोप्यताम् किम्?';

  @override
  String get clearCounterHistoryTitle =>
      'अस्य गणकस्य इतिहासः विलोप्यताम् किम्?';

  @override
  String get clearHistoryMessage =>
      'एतेन सर्वाणि पूर्वसत्राणि विलोपितानि भविष्यन्ति। समग्रगणना न परिवर्तते।';

  @override
  String get recordOfDevotion => 'साधनायाः अभिलेखः';

  @override
  String get allCounters => 'सर्वे गणकाः';

  @override
  String chantsOfferedDays(int count) {
    return '$count दिनेषु जपाः समर्पिताः';
  }

  @override
  String chantsOfferedPercent(String percent) {
    return 'लक्ष्यस्य $percent%';
  }

  @override
  String get deleteSessionTitle => 'सत्रं विलोपयितुम् इच्छन्ति किम्?';

  @override
  String deleteSessionMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count जपानाम् इदं सत्रं सर्वथा विलोपयिष्यते।',
      one: '१ जपस्य इदं सत्रं सर्वथा विलोपयिष्यते।',
    );
    return '$_temp0';
  }

  @override
  String get deleteSessionTooltip => 'सत्रं विलोप्यताम्';

  @override
  String chantsCount(String count) {
    return '$count जपाः';
  }

  @override
  String malaCount(int count) {
    return '$count मालाः';
  }

  @override
  String get counterDetailsTitle => 'गणकस्य विवरणम्';

  @override
  String get counterNotFound => 'गणकः न प्राप्तः';

  @override
  String get completedSuccessfully => 'सफलतापूर्वकं सम्पन्नम्';

  @override
  String get statusDisabled => 'निष्क्रियम्';

  @override
  String get labelTotal => 'समग्रम्';

  @override
  String get labelTodayCap => 'अद्य';

  @override
  String get labelMalas => 'मालाः';

  @override
  String get infoName => 'नाम';

  @override
  String get infoStatus => 'स्थितिः';

  @override
  String get infoIncrementStep => 'वृद्धिपदम्';

  @override
  String get infoInitialCount => 'प्रारम्भिकगणना';

  @override
  String get infoLifetimeGoal => 'आजीवनलक्ष्यम्';

  @override
  String get infoDailyGoal => 'दैनिकलक्ष्यम्';

  @override
  String get infoStarted => 'आरब्धम्';

  @override
  String get infoCreated => 'सृष्टम्';

  @override
  String get infoAvgDaily => 'दैनिकमाध्यम्';

  @override
  String get infoDisabled => 'निष्क्रियीकृतम्';

  @override
  String get statusActive => 'सक्रियम्';

  @override
  String get statusCompleted => 'सिद्धम्';

  @override
  String get aboutTitle => 'विषयपरिचयः';

  @override
  String versionLabel(String version) {
    return 'संस्करणम् $version';
  }

  @override
  String aboutBuildDate(String date) {
    return 'निर्माणदिनाङ्कः: $date';
  }

  @override
  String get aboutPurposeTitle => 'उद्देश्यम्';

  @override
  String get aboutPurposeBody =>
      'मन्त्रजपाय, ध्यानाय, दैनिकसाधनायै च विनिर्मितः एकाग्रः पवित्रश्च गणकः।';

  @override
  String get aboutOfflineTitle => 'सर्वथा अन्तर्जालरहितम्';

  @override
  String get aboutOfflineBody =>
      'अन्तर्जालस्य लेशोऽपि नापेक्ष्यते। कोऽपि दत्तांशः बाह्यतः न प्रेष्यते।';

  @override
  String get aboutPrivacyTitle => 'गोपनीयता';

  @override
  String get aboutPrivacyBody =>
      'भवतः सर्वं जपविवरणं केवलं भवतः यन्त्रे एव सुरक्षितं तिष्ठति।';

  @override
  String get aboutBackupTitle => 'दत्तांशसंरक्षणम्';

  @override
  String get aboutBackupBody =>
      'JSON-सञ्चिकाद्वारा वा प्रकाशमाध्यमेन (QR) दत्तांशं संरक्षन्तु अन्यत्र च नयन्तु।';

  @override
  String get aboutMantraQuote => 'गणेशाय नमः · हरे कृष्ण · दुर्गायै नमः';

  @override
  String get aboutMadeWithPrefix => 'सस्नेहं निर्मितम्';

  @override
  String get aboutMadeWithSuffix => ' भारततः';

  @override
  String madeWithLove(String heart) {
    return 'सस्नेहं निर्मितम् $heart भारततः';
  }

  @override
  String get madeWithLoveA11y => 'सस्नेहं निर्मितम् भारततः';

  @override
  String get aboutDetailAuthor => 'लेखकः';

  @override
  String get aboutDetailEmail => 'विद्युत्पत्रम्';

  @override
  String get aboutDetailLicense => 'अनुज्ञापत्रम्';

  @override
  String get aboutDetailAiUsed => 'प्रयुक्ता कृत्रिमबुद्धिः';

  @override
  String get aboutDetailIdeUsed => 'प्रयुक्तं विकाससाधनम्';

  @override
  String get aboutDescription =>
      'अनुकूलनीयगणकैः सत्रेतिहासैश्च सह मन्त्रजपसाधनायाः अनुसरणे अन्तर्जालरहितः अनुप्रयोगः।';

  @override
  String get aboutAuthor => 'रचयिता';

  @override
  String get aboutAuthorValue => 'श्रीराज् पि';

  @override
  String get aboutEmail => 'विद्युत्पत्रम्';

  @override
  String get aboutLicense => 'अनुज्ञापत्रम्';

  @override
  String get aboutLicenseValue =>
      'सर्वे प्रयुक्ताः तन्त्रांशग्रन्थालयाः विवृतस्रोतांसि (open-source) सन्ति।';

  @override
  String get aboutAiUsed => 'प्रयुक्त-कृत्रिमबुद्धिः (AI)';

  @override
  String get aboutAiUsedValue => 'गूगल जेमिनी / एन्थ्रोपिक क्लाउड';

  @override
  String get aboutIdeUsed => 'प्रयुक्त-विकासपरिवेशः (IDE)';

  @override
  String get aboutIdeUsedValue => 'वीएस कोड / एन्टीग्रैविटी आईडीई';

  @override
  String get settingsTitle => 'संयोजनानि';

  @override
  String get practiceEyebrow => 'साधना';

  @override
  String get sectionLanguage => 'भाषा';

  @override
  String get sectionLanguageSub => 'अनुप्रयोगस्य प्रदर्शभाषा';

  @override
  String get appLanguage => 'अनुप्रयोगभाषा';

  @override
  String get systemDefault => 'प्रणाली-पूर्वनिर्धारितम्';

  @override
  String get englishLanguage => 'English';

  @override
  String get malayalamLanguage => 'മലയാളം';

  @override
  String get sanskritLanguage => 'संस्कृतम्';

  @override
  String get selectLanguageTitle => 'भाषां चिनोतु';

  @override
  String get sectionDailyGoal => 'दैनिकलक्ष्यम्';

  @override
  String get sectionDailyGoalSub => 'यदा दैनिकलक्ष्यं सम्पन्नं भवति';

  @override
  String get enableNotification => 'सूचनां सक्षमीकरोतु';

  @override
  String get enableNotificationSub => 'लक्ष्यपूर्तौ कम्पनं ध्वनिञ्च जनयतु';

  @override
  String get vibration => 'कम्पनम्';

  @override
  String get vibrationSub => 'लक्ष्यपूर्तौ मृदुकम्पनम्';

  @override
  String get notificationSound => 'सूचनाध्वनिः';

  @override
  String get previewTone => 'ध्वनिं शृणोतु';

  @override
  String get previewToneSub => 'पूर्तौ भवं ध्वनिं शृणोतु';

  @override
  String get sectionMala => 'मालापूर्तिः';

  @override
  String get sectionMalaSub => 'प्रत्येकं १०८ जपानन्तरम्';

  @override
  String get enableMalaSound => 'मालाध्वनिः';

  @override
  String get enableMalaSoundSub => 'प्रत्येकमालापूर्तौ सौम्यध्वनिं जनयतु';

  @override
  String get malaSoundTitle => 'मालाध्वनिप्रकारः';

  @override
  String get malaSoundSub => '१०८ जपानन्तरं पवित्रध्वनिवरणम्';

  @override
  String get soundTempleBell => 'कांस्यमन्दिरघण्टा';

  @override
  String get soundTempleBellSub => 'गम्भीरशान्तकांस्यनादः (घण्टा)';

  @override
  String get soundSingingBowl => 'तिब्बतीनादपात्रम्';

  @override
  String get soundSingingBowlSub => 'शान्तध्यानाय सुखदसंवादीनादः';

  @override
  String get soundSynthesizedTone => 'कृत्रिमध्वनिः';

  @override
  String get soundSynthesizedToneSub =>
      'पारम्परिकः १००मि.से. विद्युत्-ध्वनिः (DTMF)';

  @override
  String get sectionStillness => 'प्रशान्तिः';

  @override
  String get sectionStillnessSub => 'रात्रौ नेत्रसौख्याय मन्दप्रकाशः';

  @override
  String get dndTitle => 'शान्तिप्रणाली (Do Not Disturb)';

  @override
  String get dndSub => 'जपकाले सूचनाः ध्वनींश्च विरमयति';

  @override
  String get dndPermissionTitle => 'शान्तिप्रणाल्यै अनुमतिः';

  @override
  String get dndPermissionMessage =>
      'जपकाले विघ्ननिवारणाय यन्त्रस्य शान्तिप्रणाल्यै (DND) अनुमतिं ददातु।';

  @override
  String get dndOpenSettings => 'संयोजनानि उद्घाटयतु';

  @override
  String get dimmedModeTitle => 'मन्दप्रकाशजपविधिः';

  @override
  String get dimmedModeSub =>
      'ऊर्जासंरक्षणाय पृष्ठभूमिं तिमिरीकृत्य जपमालां प्रकाशयति';

  @override
  String get brightnessLevel => 'प्रकाशस्तरः';

  @override
  String get followingSystem => 'प्रणालीप्रकाशाधीनम्';

  @override
  String get overrideActive => 'व्यक्तिगतप्रकाशः सक्रियः';

  @override
  String get brightnessStill => 'मन्दम्';

  @override
  String get brightnessUseSystem => 'प्रणालीवत्';

  @override
  String get brightnessFull => 'पूर्णम्';

  @override
  String get sectionPracticeGuide => 'साधनादर्शनम्';

  @override
  String get sectionPracticeGuideSub => 'जपसाधनायाः रहस्यम्';

  @override
  String get howItWorks => 'साधनापद्धतिः';

  @override
  String get howItWorksSub => 'गणकस्य सौम्योपयोगः';

  @override
  String get settingsGuidanceBody =>
      'जपसाधना शान्तमनसा नित्यं करणीया। १०८ मणयः एकां सम्पूर्णां मालां सूचयन्ति।';

  @override
  String get clearAllData => 'सर्वदत्तांशमपमार्जयतु';

  @override
  String get clearAllDataSub => 'सर्वान् गणकान् इतिहासञ्च विलोपयतु';

  @override
  String get soundSystemDefaultTapToChange =>
      'प्रणाली-पूर्वनिर्धारितम् (परिवर्तनाय स्पृशतु)';

  @override
  String soundNamedTapToChange(String name) {
    return '$name (परिवर्तनाय स्पृशतु)';
  }

  @override
  String get soundCustomTapToChange => 'व्यक्तिगतध्वनिः (परिवर्तनाय स्पृशतु)';

  @override
  String get soundSystemDefault => 'प्रणाली-पूर्वनिर्धारितम्';

  @override
  String get browseAudioFile => 'ध्वनिसञ्चिकामन्विष्यताम्...';

  @override
  String get clearAllDataTitle => 'सर्वदत्तांशं विलोपयितुम् इच्छन्ति किम्?';

  @override
  String get clearAllDataMessage =>
      'एतेन सर्वे गणकाः, इतिहासः, संयोजनानि च सर्वथा विलोपितानि भविष्यन्ति। एतत् पूर्ववत् कर्तुं न शक्यते।';

  @override
  String get clearAllButton => 'सर्वं विलोप्यताम्';

  @override
  String get allDataCleared => 'सर्वो दत्तांशः विलोपितः';

  @override
  String get helpTitle => 'साहाय्यम्';

  @override
  String get helpCountingTitle => 'जपगणना';

  @override
  String get helpCountingBody =>
      'फलकस्य यत्र कुत्रापि स्पृष्ट्वा गणनां कर्तुं शक्नुवन्ति।';

  @override
  String get helpUndoTitle => 'पूर्ववत्करणम्';

  @override
  String get helpUndoBody =>
      'प्रमादस्पर्शस्य निराकरणाय पूर्ववत्-चिह्नं स्पृशन्तु।';

  @override
  String get helpTimerTitle => 'समयमापकम्';

  @override
  String get helpTimerBody => 'जपसत्रस्य कालावधिः स्वयमेव गण्यते।';

  @override
  String get helpResetTitle => 'पुनःस्थापनम्';

  @override
  String get helpResetBody =>
      'सत्रं समग्रगणकं वा पुनःस्थापयितुं पुनःस्थापनविकल्पं चिनोतु।';

  @override
  String cardChantsMala(int malas) {
    return 'जपाः · $malas मालाः';
  }

  @override
  String get cardComplete => 'सम्पूर्णम्';

  @override
  String cardPercentDaily(int percent) {
    return 'दैनिकस्य $percent%';
  }

  @override
  String get cardNoDaily => 'दैनिकलक्ष्यं नास्ति';

  @override
  String get cardTodayPrefix => 'अद्य: ';

  @override
  String cardChants(String count) {
    return '$count जपाः';
  }

  @override
  String cardMala(int count) {
    return '$count मालाः';
  }

  @override
  String cardMalaProgress(int current, int target) {
    return '$current / $target मालाः';
  }

  @override
  String cardLifetimePercent(String percent) {
    return 'आजीवनस्य $percent%';
  }

  @override
  String cardLifetimePercentComplete(String percent) {
    return 'आजीवनस्य $percent% सम्पूर्णम्';
  }

  @override
  String get notifDailyGoalTitle => 'दैनिकलक्ष्यं सम्पन्नम्!';

  @override
  String get notifDailyGoalBody => 'अद्यतनसाधना संसिद्धा। शान्तिः भवतु।';

  @override
  String get backupShareSubject => 'मन्त्रजपगणकदत्तांशः';

  @override
  String get settingsAppearanceTitle => 'स्वरूपम्';

  @override
  String get settingsAppearanceSub => 'प्रकाशः, मन्दप्रकाशः, मन्दिरवर्णाः';

  @override
  String get settingsFeaturesTitle => 'वैशिष्ट्यानि';

  @override
  String get settingsFeaturesSub => 'जपसाधनायाः सर्वाणि साधनानि';

  @override
  String get settingsHelpTitle => 'साहाय्यम्';

  @override
  String get settingsHelpSub => 'मार्गदर्शिका, प्रश्नाः, साधनापद्धतिः';

  @override
  String get settingsAboutSub => 'संस्करणम्, परम्परा, परिचयः';

  @override
  String get appearanceTitle => 'स्वरूपम्';

  @override
  String get appearanceHeaderTitle => 'मन्दिरस्वरूपम्';

  @override
  String get appearanceHeaderSub =>
      'परम्परया मन्दिरसौन्दर्येण च प्रेरितं सौम्यं वातावरणम्';

  @override
  String get appearanceBrightnessSection => 'प्रकाशसंयोजनम्';

  @override
  String get appearancePaletteSection => 'मन्दिरवर्णपरम्परा';

  @override
  String get appearanceTypographySection => 'अक्षरविन्यासः';

  @override
  String get paletteVermillionName => 'सिन्दूरम्';

  @override
  String get paletteVermillionRole => 'प्रधानवर्णः, तेजः समर्पणञ्च';

  @override
  String get paletteTulsiName => 'तुलसी';

  @override
  String get paletteTulsiRole => 'मालापूर्तिः, शान्तिः सात्त्विकता च';

  @override
  String get paletteSandalName => 'चन्दनम्';

  @override
  String get paletteSandalRole => 'दीपप्रकाशः, मङ्गलम्';

  @override
  String get paletteRoseName => 'पाटलम्';

  @override
  String get paletteRoseRole => 'पुष्पार्चनम्, भक्तिभावः';

  @override
  String get paletteCreamName => 'गोरोचनम्';

  @override
  String get paletteCreamRole => 'पृष्ठभूमिः, नेत्रसौख्यम्';

  @override
  String get typographySerifTitle => 'गणनमाला (गरामण्ड्)';

  @override
  String get typographySerifSub => 'मन्त्रसंख्यायै परम्परागतम्';

  @override
  String get typographySansTitle => 'विवरणम् (इन्टर्)';

  @override
  String get typographySansSub => 'सुस्पष्टवाचनाय';

  @override
  String get typographyMalTitle => 'भारतीयलिपयः';

  @override
  String get typographyMalSub => 'मूलमन्त्रलेखनाय';

  @override
  String get featuresTitle => 'वैशिष्ट्यानि';

  @override
  String get featuresHeaderTitle => 'साधनावैशिष्ट्यानि';

  @override
  String get featuresHeaderSub => 'भवतः नित्यजपाय रचितानि सर्वाणि साधनानि';

  @override
  String get helpHeaderTitle => 'साधनासाहाय्यम्';

  @override
  String get helpHeaderSub =>
      'उपकरणस्य सर्वभागानां मार्गदर्शिकाः: गणकाः, गणनं, मालाः लक्ष्याणि च, इतिहासः, ध्वनिः, प्रदर्शनं, प्रतिलिपिः, प्रकाशसञ्चारः, गोपनीयता च।';

  @override
  String get helpCategoryCounting => 'जपसाधना';

  @override
  String get helpCategorySync => 'दत्तांशसञ्चारः';

  @override
  String get helpCategoryAudio => 'ध्वनिः, प्रदर्शनं, स्थिरता च';

  @override
  String get helpCategoryPrivacy => 'गोपनीयता';

  @override
  String get helpTopicCountingTitle => 'जपगणना कथं करणीया';

  @override
  String get helpTopicCountingSub =>
      'वृत्तान्तः स्पर्शः, अङ्गुलिद्वयनिवर्तनं, गणनसूची, स्वयंरक्षणं च';

  @override
  String get helpTopicMalaTitle => '१०८ मणयः एका माला';

  @override
  String get helpTopicMalaSub =>
      '108 मण्यावर्तनानि, अधिकगणनाः, दैनिकजीवनलक्ष्याणि च';

  @override
  String get helpTopicOpticalSyncTitle => 'प्रकाशसञ्चारः (QR)';

  @override
  String get helpTopicOpticalSyncSub =>
      'अन्तर्जालं विना चलेन QR सङ्केतेन दूरवाणीतः दूरवाणीं प्रति स्थानान्तरणम्';

  @override
  String get helpTopicBackupTitle => 'प्रतिलिपिः पुनःस्थापनं च';

  @override
  String get helpTopicBackupSub =>
      'सञ्चिकायां निर्यातः, गूढप्रतिलिपिः, आयातः, सर्वदत्तांशमार्जनं च';

  @override
  String get helpTopicAudioTitle => 'ध्वनिः कम्पनञ्च';

  @override
  String get helpTopicAudioSub => 'मालाध्वनिः, लक्ष्यध्वनयः, सूचनाः, कम्पनं च';

  @override
  String get helpTopicPrivacyTitle => 'गोपनीयता दर्शनञ्च';

  @override
  String get helpTopicPrivacySub =>
      'अन्तर्जालानुमतिः नास्ति, निजसञ्चयः, उपयुक्ताः अनुमतयः च';

  @override
  String get helpTopicFaqTitle => 'प्रायिकप्रश्नाः';

  @override
  String get helpTopicFaqSub => 'सामान्यप्रश्नानाम् उत्तराणि';

  @override
  String get helpCountingIntro =>
      'गणनपटं शान्तध्यानाय निर्मितम्। जपकाले पटं द्रष्टुं न आवश्यकम्।';

  @override
  String get helpCountingTapSection => 'कथं गणनीयम्';

  @override
  String get helpCountingTapBold1 => 'वृत्तस्य अन्तः स्पृशतु:';

  @override
  String get helpCountingTapBullet1 =>
      'मालावृत्तस्य अन्तः स्पर्शाः एव गण्यन्ते। बहिः स्पर्शाः न गण्यन्ते, अतः आकस्मिकस्पर्शः सङ्ख्यां न वर्धयति।';

  @override
  String get helpCountingTapBold2 => 'वृद्धिपदम्:';

  @override
  String get helpCountingTapBullet2 =>
      'प्रतिस्पर्शं गणकस्य पदं (सामान्यतः 1) योज्यते। गणकसम्पादनेन परिवर्तयतु।';

  @override
  String get helpCountingTapBold3 => 'शान्ताः स्पर्शाः:';

  @override
  String get helpCountingTapBullet3 =>
      'स्पर्शेषु कम्पनं नास्ति। कम्पने सक्रिये प्रत्येकमालासमाप्तौ, लक्ष्ये, निवर्तने च कम्पनं भवति।';

  @override
  String get helpCountingUndoSection => 'गणनानिवर्तनम्';

  @override
  String get helpCountingUndoBold1 => 'अङ्गुलिद्वयचालनम्:';

  @override
  String get helpCountingUndoBullet1 =>
      'वृत्ते अङ्गुलिद्वयं निधाय वामतः दक्षिणतः वा चालयतु। एकेन चालनेन एकं पदं न्यूनीभवति, दूरवाणी एकवारं कम्पते च।';

  @override
  String get helpCountingUndoBold2 => 'शून्यं प्रति:';

  @override
  String get helpCountingUndoBullet2 =>
      'सत्रसङ्ख्या 0 भवति चेत् उपवेशनं मार्ज्यते, इतिहासे किमपि न योज्यते।';

  @override
  String get helpMalaIntro =>
      'पारम्परिकजपमालायाम् अष्टोत्तरशतं मणयः सन्ति। उपकरणं 108 आवर्तनैः गणयति, प्रत्येकपत्रे लक्ष्याणि च दर्शयति।';

  @override
  String get helpMalaBeadsSection => '108 मणयः';

  @override
  String get helpMalaBeadsBold1 => '1 माला = 108 गणनाः:';

  @override
  String get helpMalaBeadsBullet1 =>
      'प्रत्येकं 108 गणनाः एका पूर्णमाला। गणनपटस्य वृत्तं मणिशः पूर्यते, 108 अनन्तरं पुनः आरभते।';

  @override
  String get helpMalaBeadsBold2 => 'अधिकगणनाः:';

  @override
  String get helpMalaBeadsBullet2 =>
      'पूर्णमालायाः परं गणनाः रक्ष्यन्ते दर्श्यन्ते च। यथा, 115 गणनाः = 1 माला 7 गणनाः च।';

  @override
  String get helpMalaBeadsBold3 => 'बृहत्पदानि:';

  @override
  String get helpMalaBeadsBullet3 =>
      'पदं 1 तः अधिकं चेत्, एकेन स्पर्शेन अनेके मणयः चलन्ति। मालाः आहत्यगणनातः एव गण्यन्ते।';

  @override
  String get helpMalaGoalsSection => 'दैनिकलक्ष्यं जीवनलक्ष्यं च';

  @override
  String get helpMalaGoalsBold1 => 'दैनिकलक्ष्यम्:';

  @override
  String get helpMalaGoalsBullet1 =>
      'प्रतिदिनं समर्पयितुम् इष्टा जपसङ्ख्या (0 = दैनिकलक्ष्यं नास्ति)। दूरवाण्याः घटिकानुसारम् अर्धरात्रे 0 तः पुनः आरभते।';

  @override
  String get helpMalaGoalsBold2 => 'जीवनलक्ष्यम् (सङ्कल्पः):';

  @override
  String get helpMalaGoalsBullet2 =>
      'दीर्घकालिकं लक्ष्यं, यथा 1,00,000 जपाः (0 = जीवनलक्ष्यं नास्ति)। दैनिकलक्ष्यं ततः अधिकं न भवेत्।';

  @override
  String get helpOpticalIntro =>
      'प्रकाशसञ्चारः पटं छायाग्राहकं च एव उपयुज्य गणकान् इतिहासं च एकस्याः दूरवाण्याः अन्यां प्रति नयति। अन्तर्जालं, वाइ-फाइ, ब्लूटूथ्, तन्त्री वा न आवश्यकम्।';

  @override
  String get helpOpticalHowSection => 'कथं स्थानान्तरणम्';

  @override
  String get helpOpticalHowBold1 => 'प्रेषकदूरवाणी:';

  @override
  String get helpOpticalHowBullet1 =>
      'संयोजनानि → दत्तांशसंरक्षणम् → प्रकाशसञ्चारः (प्रेषणम्)। प्रेषणीयान् गणकान् चिनोतु। चलः QR सङ्केतः आरभते।';

  @override
  String get helpOpticalHowBold2 => 'ग्राहकदूरवाणी:';

  @override
  String get helpOpticalHowBullet2 =>
      'प्रकाशसञ्चारः (स्वीकरणम्) उद्घाट्य छायाग्राहकम् अनुमन्य प्रेषकपटं प्रति धारयतु।';

  @override
  String get helpOpticalHowBold3 => 'पूर्वदर्शनम्:';

  @override
  String get helpOpticalHowBullet3 =>
      'सर्वेषु भागेषु प्राप्तेषु गणकान् सत्राणि च दर्शयत् पूर्वदर्शनं दृश्यते। रक्षणीयान् गणकान् चित्वा पुनःस्थापनगण्डं स्पृशतु।';

  @override
  String get helpOpticalTipsSection => 'शीघ्रपरीक्षणाय सूचनाः';

  @override
  String get helpOpticalTipsBold1 => 'दूरता:';

  @override
  String get helpOpticalTipsBullet1 =>
      'ग्राहकदूरवाणीं प्रेषकपटात् प्रायः 15–25 से.मी. दूरे, सङ्केतं मार्गदर्शकपेटिकायाम् अन्तः कृत्वा, स्थिरं धारयतु।';

  @override
  String get helpOpticalTipsBold2 => 'प्रतिबिम्बः:';

  @override
  String get helpOpticalTipsBullet2 => 'प्रेषकपटे तीव्रप्रतिबिम्बं परिहरतु।';

  @override
  String get helpOpticalTipsBold3 => 'त्यक्तचित्राणि:';

  @override
  String get helpOpticalTipsBullet3 =>
      'केचन चित्राणि त्यक्तानि चेदपि न दोषः। अधिकमिश्रचित्रैः सह प्रवाहः पुनः पुनः भवति, अतः लुप्तभागाः पुनर्निर्मीयन्ते।';

  @override
  String get helpAudioIntro =>
      'ध्वनिः स्पन्दनं च मुख्यक्षणान् सूचयतः: प्रत्येकमालां प्रत्येकलक्ष्यं च। संयोजनानि → ध्वनिः स्पन्दनं च इत्यत्र तानि निर्धारयतु।';

  @override
  String get helpAudioVibrationSection => 'कम्पनम्';

  @override
  String get helpAudioVibrationBold1 => 'कदा कम्पते:';

  @override
  String get helpAudioVibrationBullet1 =>
      'प्रत्येकमालायाम् एकं स्पन्दनं, लक्ष्यसिद्धौ त्रीणि, निवर्तने लघु एकम्।';

  @override
  String get helpAudioVibrationBold2 => 'निष्क्रियीकरणम्:';

  @override
  String get helpAudioVibrationBullet2 =>
      'पूर्णमौनसाधनायै संयोजनानि → ध्वनिः स्पन्दनं च इत्यत्र कम्पनं निष्क्रियं करोतु।';

  @override
  String get helpBackupIntro =>
      'भवतां दत्तांशः भवताम् एव। कदापि सञ्चिकायां रक्षित्वा अस्यां नूतनायां वा दूरवाण्यां पुनःस्थापयतु।';

  @override
  String get helpBackupExportSection => 'प्रतिलिपिनिर्यातः';

  @override
  String get helpBackupExportBold1 => 'एका सञ्चिका:';

  @override
  String get helpBackupExportBullet1 =>
      'सर्वे गणकाः, लक्ष्याणि, सत्रेतिहासः च एकस्यां प्रतिलिपिसञ्चिकायाम्।';

  @override
  String get helpBackupExportBold2 => 'गूढीकरणम् (ऐच्छिकम्):';

  @override
  String get helpBackupExportBullet2 =>
      'गुप्तवाक्येन सञ्चिकां रक्षितुं शक्यते। दृढेन AES-256-GCM गूढीकरणेन कील्यते।';

  @override
  String get helpBackupExportBold3 => 'गुप्तवाक्यं रक्षतु:';

  @override
  String get helpBackupExportBullet3 =>
      'विस्मृतं गुप्तवाक्यं पुनः न लभ्यते, तद्विना सञ्चिका न उद्घाट्यते।';

  @override
  String get helpBackupImportSection => 'प्रतिलिपिपुनःस्थापनम्';

  @override
  String get helpBackupImportBold1 => 'सञ्चिकां चिनोतु:';

  @override
  String get helpBackupImportBullet1 =>
      'आयातं चित्वा प्रणालीसञ्चिकाचयनके प्रतिलिपिसञ्चिकां चिनोतु।';

  @override
  String get helpBackupImportBold2 => 'सर्वदत्तांशप्रतिस्थापनम्:';

  @override
  String get helpBackupImportBullet2 =>
      'आयातः वर्तमानान् सर्वान् गणकान् इतिहासं च सञ्चिकादत्तांशेन प्रतिस्थापयति। दूरवाण्यां स्थितं रक्षितुम् इच्छति चेत् प्रथमं निर्यातं करोतु।';

  @override
  String get helpBackupImportBold3 => 'गूढसञ्चिकाः:';

  @override
  String get helpBackupImportBullet3 =>
      'सञ्चिका गूढा चेत् गुप्तवाक्यं पृच्छ्यते।';

  @override
  String get helpPrivacyIntro =>
      'SreerajP MantraJapa Counter गोपनीयतायै एव निर्मितम्। भवतां साधना भवतां दूरवाण्याम् एव तिष्ठति।';

  @override
  String get helpPrivacyOfflineSection => 'पूर्णतया अन्तर्जालरहितम्';

  @override
  String get helpPrivacyOfflineBold1 => 'अन्तर्जालानुमतिः नास्ति:';

  @override
  String get helpPrivacyOfflineBullet1 =>
      'उपकरणस्य एण्ड्रॉयड्-अन्तर्जालानुमतिः नास्ति, अतः किमपि कुत्रापि प्रेषयितुं न शक्नोति।';

  @override
  String get helpPrivacyOfflineBold2 => 'अनुवर्तनं नास्ति:';

  @override
  String get helpPrivacyOfflineBullet2 =>
      'विश्लेषणं, दोषप्रतिवेदनं, विज्ञापनं वा नास्ति।';

  @override
  String get helpPrivacyOfflineBold3 => 'खाता नावश्यकी:';

  @override
  String get helpPrivacyOfflineBullet3 =>
      'पञ्जीकरणं, ईमेल्, दूरवाणीसङ्ख्या वा कदापि न आवश्यकम्।';

  @override
  String get helpPrivacyStorageSection => 'दत्तांशः कुत्र रक्ष्यते';

  @override
  String get helpPrivacyStorageBold1 => 'भवतां दूरवाण्याम् एव:';

  @override
  String get helpPrivacyStorageBullet1 =>
      'गणकाः इतिहासः च दूरवाण्याम् उपकरणस्य निजसञ्चये रक्ष्यन्ते। अन्यानि उपकरणानि तं पठितुं न शक्नुवन्ति।';

  @override
  String get helpPrivacyStorageBold2 => 'मेघप्रतिलिपिः नास्ति:';

  @override
  String get helpPrivacyStorageBullet2 =>
      'अस्य उपकरणस्य कृते एण्ड्रॉयड्-स्वयंमेघप्रतिलिपिः निष्क्रिया। प्रतिलिपिरक्षणाय निर्यातं प्रकाशसञ्चारं वा उपयुज्यताम्।';

  @override
  String get helpFaqIntro => 'सामान्यप्रश्नानां संक्षिप्तोत्तराणि।';

  @override
  String get helpFaqQ1Title => 'मम स्पर्शः किमर्थं न गणितः?';

  @override
  String get helpFaqQ1Answer =>
      'मालावृत्तस्य अन्तः स्पर्शाः एव गण्यन्ते। मेरुविरामे सक्रिये प्रत्येकमालानन्तरं लघुविरामे स्पर्शाः अपि न गण्यन्ते।';

  @override
  String get helpFaqQ2Title => 'अशुद्धगणनां कथं निवर्तयेयम्?';

  @override
  String get helpFaqQ2Answer =>
      'मालावृत्ते अङ्गुलिद्वयं निधाय वामतः दक्षिणतः वा चालयतु। प्रत्येकचालनेन एकं पदं न्यूनीभवति।';

  @override
  String get helpFaqQ3Title => 'मम गणकः किमर्थं न उद्घाट्यते?';

  @override
  String get helpFaqQ3Answer =>
      'सः कीलितः निष्क्रियः वा। उद्घाटनाय पत्रस्य कीलचिह्नं स्पृशतु। निष्क्रियाः गणकाः गणनार्थं न उद्घाट्यन्ते।';

  @override
  String get helpFaqQ4Title => 'मालामध्ये विरमामि चेत् किं भवति?';

  @override
  String get helpFaqQ4Answer =>
      'किमपि न नश्यति। गणनाः रक्ष्यन्ते, अन्यस्मिन् दिने अपि अग्रिमवारं माला प्रतीक्षते। 0 तः आरब्धुम् इच्छति चेत् \'नूतनम् आरभ्यताम्\' स्पृशतु।';

  @override
  String get lockCounter => 'गणकं कीलयतु';

  @override
  String get unlockCounter => 'गणकमुद्घाटयतु';

  @override
  String counterLockedNotice(String name) {
    return '\"$name\" कीलितोऽस्ति। जपार्थमुद्घाटयन्तु।';
  }

  @override
  String get counterLockedTooltip => 'गणकः कीलितः (उद्घाटनाय स्पृशतु)';

  @override
  String get counterUnlockedTooltip => 'गणक उद्घाटितः (कीलनाय स्पृशतु)';

  @override
  String get statusLocked => 'कीलितम्';

  @override
  String get settingsBackupTitle => 'दत्तांशसंरक्षणम्';

  @override
  String get settingsBackupSub => 'सञ्चिका वा प्रकाशमाध्यमेन संरक्षणम्';

  @override
  String get settingsOpticalSendTitle => 'प्रकाशसञ्चारः (प्रेषणम्)';

  @override
  String get settingsOpticalSendSub =>
      'QR-सङ्केतद्वारा अन्ययन्त्रे प्रेष्यताम्';

  @override
  String get settingsOpticalReceiveTitle => 'प्रकाशसञ्चारः (स्वीकरणम्)';

  @override
  String get settingsOpticalReceiveSub =>
      'अन्ययन्त्रतः QR-सङ्केतं पठित्वा स्वीक्रियताम्';

  @override
  String get settingsExportTitle => 'दत्तांशं निर्हरतु (JSON)';

  @override
  String get settingsExportSub => 'सञ्चिकां संरक्षतु वा अन्यत्र प्रेषयतु';

  @override
  String get settingsImportTitle => 'दत्तांशम् आहरतु (JSON)';

  @override
  String get settingsImportSub => 'JSON-सञ्चिकातो दत्तांशं पुनःस्थापयतु';

  @override
  String get dataRestoredSuccess => 'दत्तांशः साफल्येन पुनःस्थापितः';

  @override
  String get opticalSendTitle => 'प्रकाशप्रेषणम्';

  @override
  String get opticalReceiveTitle => 'प्रकाशस्वीकरणम्';

  @override
  String get opticalNoFrames => 'सङ्केता न सज्जाः';

  @override
  String opticalSessionId(String id) {
    return 'सत्रक्रमाङ्कः: $id';
  }

  @override
  String opticalFrameCounter(int current) {
    return 'सङ्केतः $current';
  }

  @override
  String opticalFramesReceived(int count) {
    return 'प्राप्ताः सङ्केताः: $count';
  }

  @override
  String opticalSystematicChunk(int index) {
    return 'क्रमबद्धदत्तांशखण्डः #$index';
  }

  @override
  String opticalParityFrame(int index) {
    return 'समतासङ्केतः $index';
  }

  @override
  String get opticalStreamRate => 'प्रवाहवेगः (FPS)';

  @override
  String get opticalSendHint =>
      'अन्ययन्त्रस्य चित्रग्राहकेण (Camera) अयं QR-सङ्केतः पठ्यताम्।';

  @override
  String opticalReconstructing(int done, int total) {
    return 'पुनर्निर्माणं क्रियते: $done / $total खण्डाः';
  }

  @override
  String get opticalAlignCamera => 'QR-सङ्केतं मञ्जूषायामानयन्तु';

  @override
  String get opticalStreamComplete => 'प्रकाशप्रवाहः सम्पन्नः';

  @override
  String get opticalStatCounters => 'गणकाः';

  @override
  String get opticalStatSessionLogs => 'सत्राणि';

  @override
  String get opticalImportRestore => 'दत्तांशं पुनःस्थापयतु';

  @override
  String get opticalImportSuccess => 'दत्तांशः साफल्येनानीतः!';

  @override
  String get opticalImportFailed => 'दत्तांशायातो विफलः संवृत्तः।';

  @override
  String get featCat1Name => 'जपसाधना';

  @override
  String get featCat1Sub => 'स्पर्शः, मालाः, ध्यानावस्था च';

  @override
  String get featCat2Name => 'दत्तांशसञ्चारः';

  @override
  String get featCat2Sub => 'प्रकाशप्रवाहः, सञ्चिकासंरक्षणञ्च';

  @override
  String get featCat3Name => 'साधनेतिहासः सङ्ख्याविवरणञ्च';

  @override
  String get featCat3Sub => 'दैनिकसत्राणि, परम्परा, लक्ष्यञ्च';

  @override
  String get featCat4Name => 'गोपनीयता सुरक्षा च';

  @override
  String get featCat4Sub => 'अन्तर्जालरहितम्, स्थानिकसञ्चयः';

  @override
  String get featCat5Name => 'स्वरूपं ध्वनयश्च';

  @override
  String get featCat5Sub => 'मन्दिरवर्णाः, घण्टानादः, कम्पनञ्च';

  @override
  String get featMalaTitle => '१०८ मणियोजनम्';

  @override
  String get featMalaDesc =>
      'पारम्परिकसनातनसाधनायाः पूर्णमाला स्वयमेव योज्यते।';

  @override
  String get featMalaH1 => 'स्वचालितमाला';

  @override
  String get featMalaH2 => 'अवशिष्टाः मणयः';

  @override
  String get featMalaH3 => 'घण्टानादः';

  @override
  String get featImmersionTitle => 'प्रशान्तिसाधना (Stillness)';

  @override
  String get featImmersionDesc => 'रात्रौ नेत्रसंरक्षणाय मन्दप्रकाशे जपसाधना।';

  @override
  String get featImmersionH1 => 'मन्दप्रकाशः';

  @override
  String get featImmersionH2 => 'शान्तवातावरणम्';

  @override
  String get featImmersionH3 => 'नेत्रसौख्यम्';

  @override
  String get featUndoTitle => 'पूर्ववत्करणम् (Undo)';

  @override
  String get featUndoDesc => 'प्रमादस्पर्शस्य निराकरणाय सुगमं साधनम्।';

  @override
  String get featUndoH1 => 'एकस्पर्शेन पूर्ववत्';

  @override
  String get featUndoH2 => 'सत्ररक्षणम्';

  @override
  String get featUndoH3 => 'सुस्पष्टगणना';

  @override
  String get featTimerTitle => 'जपसमयमापकम्';

  @override
  String get featTimerDesc => 'प्रत्येकस्य जपसत्रस्य कालावधिः स्वयमेव ज्ञायते।';

  @override
  String get featTimerH1 => 'स्वचालितमापनम्';

  @override
  String get featTimerH2 => 'विश्रामे विरामः';

  @override
  String get featTimerH3 => 'इतिहाससञ्चयः';

  @override
  String get featQrStreamTitle => 'प्रकाशसञ्चारः (QR)';

  @override
  String get featQrStreamDesc =>
      'अन्तर्जालं विना यन्त्रयोर्मध्ये द्रुतदत्तांशसञ्चारः।';

  @override
  String get featQrStreamH1 => 'शून्यसंयोगः';

  @override
  String get featQrStreamH2 => 'द्रुतसञ्चारः';

  @override
  String get featQrStreamH3 => 'नेत्रग्राह्यम्';

  @override
  String get featFountainTitle => 'समतासङ्केतः (Fountain Codes)';

  @override
  String get featFountainDesc =>
      'प्रकाशसञ्चारे केचन सङ्केताः लुप्ताश्चेदपि दत्तांशहानिर्न भवति।';

  @override
  String get featFountainH1 => 'दोषसहिष्णुता';

  @override
  String get featFountainH2 => 'स्वयंशोधनम्';

  @override
  String get featFountainH3 => 'पूर्णसुरक्षा';

  @override
  String get featJsonExportTitle => 'JSON-सञ्चिकासंरक्षणम्';

  @override
  String get featJsonExportDesc =>
      'भवतः सम्पूर्णो दत्तांशः प्रमाणभूत-JSON-सञ्चिकारूपेण निर्ह्रियते।';

  @override
  String get featJsonExportH1 => 'मानकप्रारूपम्';

  @override
  String get featJsonExportH2 => 'सुरक्षितसञ्चिका';

  @override
  String get featJsonExportH3 => 'सुगमपुनःस्थापनम्';

  @override
  String get featDailyLogTitle => 'दैनिकसाधनालेखः';

  @override
  String get featDailyLogDesc => 'प्रतिदिनं कृतानां जपानां सविस्तर इतिहासः।';

  @override
  String get featDailyLogH1 => 'दैनिकसत्राणि';

  @override
  String get featDailyLogH2 => 'सत्रकालावधिः';

  @override
  String get featDailyLogH3 => 'अखण्डपरम्परा';

  @override
  String get featFilterTitle => 'गणकशोधनम्';

  @override
  String get featFilterDesc =>
      'विशिष्टगणकानामितिहासः पृथक्तया द्रष्टुं शक्यते।';

  @override
  String get featFilterH1 => 'प्रत्येकगणकः';

  @override
  String get featFilterH2 => 'समग्रदर्शनम्';

  @override
  String get featFilterH3 => 'सुगमशोधनम्';

  @override
  String get featPaletteTitle => 'मन्दिरवर्णाः';

  @override
  String get featPaletteDesc =>
      'सिन्दूरं, तुलसी, चन्दनमित्यादयः पारम्परिकाः सात्त्विकवर्णाः।';

  @override
  String get featPaletteH1 => 'सात्त्विकवर्णाः';

  @override
  String get featPaletteH2 => 'नेत्रसौख्यम्';

  @override
  String get featPaletteH3 => 'समर्पणभावः';

  @override
  String get featBellTitle => 'घण्टानादः कम्पनञ्च';

  @override
  String get featBellDesc =>
      'मालापूर्तौ सौम्यघण्टानादः, प्रत्येकस्पर्शसमये च मृदुकम्पनम्।';

  @override
  String get featBellH1 => 'घण्टानादः';

  @override
  String get featBellH2 => 'मृदुकम्पनम्';

  @override
  String get featBellH3 => 'मूकसाधना';

  @override
  String get featBrightnessTitle => 'प्रकाशसंयोजनम्';

  @override
  String get featBrightnessDesc => 'फलकप्रकाशस्य सुलभं संयोजनम्।';

  @override
  String get featBrightnessH1 => 'सुसमायोजनम्';

  @override
  String get featBrightnessH2 => 'प्रणालीवत्';

  @override
  String get featBrightnessH3 => 'मन्दप्रकाशः';

  @override
  String get featBilingualTitle => 'त्रिभाषासमर्थनम्';

  @override
  String get featBilingualDesc =>
      'संस्कृतम्, आङ्ग्लभाषा, मलयाळम् इति भाषात्रयस्य सम्पूर्णं समर्थनम्।';

  @override
  String get featBilingualH1 => 'संस्कृतम्';

  @override
  String get featBilingualH2 => 'मलयाळम्';

  @override
  String get featBilingualH3 => 'आङ्ग्लभाषा';

  @override
  String get featOfflineTitle => 'सर्वथा अन्तर्जालरहितम्';

  @override
  String get featOfflineDesc => 'अन्तर्जालस्यानुज्ञां विना कार्यं करोति।';

  @override
  String get featOfflineH1 => 'शून्यसंयोगः';

  @override
  String get featOfflineH2 => 'गोपनीयम्';

  @override
  String get featOfflineH3 => 'विश्वसनीयम्';

  @override
  String get featSqliteTitle => 'स्थानिक-SQLite-दत्तांशकोशः';

  @override
  String get featSqliteDesc =>
      'भवतो यन्त्रे सुरक्षितरूपेण SQLite-दत्तांशकोशे सञ्चयः।';

  @override
  String get featSqliteH1 => 'स्थानिकसञ्चयः';

  @override
  String get featSqliteH2 => 'दत्तांशसुरक्षा';

  @override
  String get featSqliteH3 => 'अखण्डता';

  @override
  String get opticalStreamCompleteSub => 'सर्वे खण्डाः साफल्येन प्राप्ताः।';

  @override
  String get selectCountersTitle => 'गणकान् चिनुत';

  @override
  String get selectCountersSub => 'समाविष्टव्यान् गणकान् चिनुत';

  @override
  String get selectAll => 'सर्वान् चिनुत';

  @override
  String get deselectAll => 'सर्वान् अपनयत';

  @override
  String selectedCountersCount(int count) {
    return '$count चितम्';
  }

  @override
  String get continueAction => 'अग्रे गच्छतु';

  @override
  String get noCountersSelected => 'कृपया एकं गणकमपि चिनुत';

  @override
  String get encryptBackup => 'सञ्चिकां कूटीकुरुत';

  @override
  String get encryptBackupSub => 'गुप्तवाक्येन सुरक्षा (AES-256-GCM)';

  @override
  String get enterPassphrase => 'गुप्तवाक्यं लिखतु';

  @override
  String get confirmPassphrase => 'गुप्तवाक्यं पुष्टीकुरुत';

  @override
  String get passphraseMismatch => 'गुप्तवाक्ये न सम्मतौ';

  @override
  String get passphraseTooShort =>
      'गुप्तवाक्यं न्यूनातिन्यूनं ६ अक्षराणि भवेत्';

  @override
  String get decryptBackup => 'विकूटीकृत्य आनयतु';

  @override
  String get decryptPassphrasePrompt =>
      'इयं सञ्चिका कूटिता अस्ति। विकूटीकरणाय गुप्तवाक्यं लिखतु।';

  @override
  String get decryptFailed =>
      'विकूटीकरणं विफलम्। अशुद्धं गुप्तवाक्यं वा भ्रष्टा सञ्चिका।';

  @override
  String get skipEncryption => 'अतिक्रम्य (अकूटितम्)';

  @override
  String get opticalSelectCountersHint => 'प्रकाशसञ्चाराय गणकान् चिनुत';

  @override
  String get opticalImportSelectHint =>
      'प्राप्तदत्तांशात् आनेतव्यान् गणकान् चिनुत';

  @override
  String get notifLifetimeGoalTitle => 'जीवनलक्ष्यं सम्पन्नम्!';

  @override
  String get notifLifetimeGoalBody =>
      'शुभं लक्ष्यं सम्पन्नम्। भवदीयसाधना शान्तिं मुक्तिं च यच्छतु।';

  @override
  String get lifetimeSoundTitle => 'जीवनलक्ष्यध्वनिः';

  @override
  String get lifetimeSoundSub => 'जीवनलक्ष्यप्राप्तौ वाद्यमाना पवित्रा ध्वनिः';

  @override
  String get enableLifetimeNotification => 'जीवनलक्ष्यसूचना';

  @override
  String get enableLifetimeNotificationSub =>
      'जीवनलक्ष्ये प्राप्ते सूचनां प्रदर्शयतु';

  @override
  String get soundSacredShankha => 'पवित्रशङ्खध्वनिः';

  @override
  String get soundSacredShankhaSub => 'साधनाविजयसूचकः दिव्यः शङ्खनादः';

  @override
  String get settingsSoundTitle => 'ध्वनिः स्पन्दनं च';

  @override
  String get settingsSoundSub => 'मालाघण्टा, लक्ष्यपूर्तेः ध्वनिः, स्पन्दनं च';

  @override
  String get settingsDisplayTitle => 'प्रदर्शनं स्थिरता च';

  @override
  String get settingsDisplaySub => 'पटप्रकाशः ध्यानस्थिरता च';

  @override
  String get settingsLanguageTitle => 'भाषा';

  @override
  String get settingsLanguageSub => 'अनुप्रयोगस्य भाषा लिपिः सङ्ख्यापद्धतिः च';

  @override
  String get settingsPermissionsTitle => 'अनुमतयः';

  @override
  String get settingsPermissionsSub =>
      'अनुप्रयोगे उपयुक्ताः अनुमतयः तन्निमित्तानि च';

  @override
  String get settingsClearDataTitle => 'सर्वदत्तांशमलोकनम्';

  @override
  String get settingsClearDataSub => 'सर्वान् गणकान् जपविवरणं च सर्वथा अपनयतु';

  @override
  String get permissionsExplicitHeader => 'प्रत्यक्षानुमतयः (Explicit)';

  @override
  String get permissionsExplicitSub =>
      'विशिष्टसुविधासमये एव उपयोक्त्रनुमतिः याच्यते';

  @override
  String get permissionsImplicitHeader => 'अप्रत्यक्षानुमतयः (Implicit)';

  @override
  String get permissionsImplicitSub =>
      'जालसम्पर्कं विना कार्याय तन्त्रज्ञानेन स्वयमेव दीयते';

  @override
  String get permissionsPrivacyHeader => 'पूर्णगोपनीयताप्रतिज्ञा';

  @override
  String get permissionsPrivacySub => 'साधनागोपनीयतायै काश्चिदनुमतयः त्यक्ताः';

  @override
  String get permCameraTitle => 'दृश्यकम् (Camera)';

  @override
  String get permCameraDesc =>
      'प्रकाशीयसङ्क्रमणे चलचित्रित-QR-सङ्केतपठनाय एव उपयुज्यते। चित्राणि न सङ्गृह्यन्ते।';

  @override
  String get permNotificationTitle => 'सूचनाः (Notifications)';

  @override
  String get permNotificationDesc =>
      'दैनिके जीवनलक्ष्ये वा प्राप्ते सूचनापट्टे विजयवार्ताप्रदर्शनाय।';

  @override
  String get permVibrationTitle => 'स्पन्दनम् (Vibration)';

  @override
  String get permVibrationDesc =>
      'प्रत्येकजपे मालापूर्तौ मौनावस्थायामपि ज्ञानार्थं मृदुस्पन्दनम्।';

  @override
  String get permAudioTitle => 'ध्वनिनियमनम्';

  @override
  String get permAudioDesc =>
      'ध्यानावस्थायां घण्टानादस्य श्रवणाय विशेषध्वनिसम्पर्कः।';

  @override
  String get permNoInternetTitle => 'अन्तर्जालरहितम्';

  @override
  String get permNoInternetDesc =>
      'अत्र अन्तर्जालानुमतिः नास्ति। कोऽपि दत्तांशः बहिः न प्रेष्यते।';

  @override
  String get permNoStorageTitle => 'कोशप्रवेशरहितम्';

  @override
  String get permNoStorageDesc =>
      'व्यक्तिगतसञ्चिकानां रक्षणाय तन्त्रस्य सुरक्षितान्वेषकः उपयुज्यते।';

  @override
  String get tutorialTitle => 'अनुप्रयोगप्रशिक्षणम्';

  @override
  String get tutorialSub =>
      'प्रथमगणकात् प्रतिलिपिगोपनीयतापर्यन्तं सर्वासां विशेषतानां क्रमशः परिचयः।';

  @override
  String get tutorialStep1Title => 'स्वागतम्';

  @override
  String get tutorialStep1Desc =>
      'इदम् उपकरणं भवतां मन्त्रजपस्य गणनायां साहाय्यं करोति। अष्टोत्तरशतस्य मालाः गणयति, दैनिकं जीवनलक्ष्यं च रक्षति, सम्पूर्णम् इतिहासं च रक्षति। अन्तर्जालं विना पूर्णतया कार्यं करोति।';

  @override
  String get tutorialStep2Title => 'भाषां चिनोतु';

  @override
  String get tutorialStep2Desc =>
      'संयोजनानि → भाषा इत्यत्र गच्छतु। आङ्ग्लं, मलयाळं, संस्कृतं, प्रणाली-पूर्वनिर्धारितं वा चिनोतु।';

  @override
  String get tutorialStep3Title => 'गणकं रचयतु';

  @override
  String get tutorialStep3Desc =>
      'मुख्यपटस्य उपरि स्थितं + गण्डं स्पृशतु। मन्त्रनाम लिखतु। ततः आरम्भसङ्ख्यां, वृद्धिपदं, जीवनलक्ष्यं, दैनिकलक्ष्यम्, आरम्भदिनाङ्कं च निर्धारयतु।';

  @override
  String get tutorialStep4Title => 'गणकपत्रं पठतु';

  @override
  String get tutorialStep4Desc =>
      'प्रत्येकस्मिन् पत्रे आहत्य जपाः मालाः च, अद्यतनजपाः, अद्यतनप्रगतेः 27 मणीनां पङ्क्तिः, जीवनलक्ष्यस्य पट्टिका च दृश्यन्ते।';

  @override
  String get tutorialStep5Title => 'अद्यतनसारांशः';

  @override
  String get tutorialStep5Desc =>
      'मुख्यपटस्य उपरि स्थिता गुलिका अद्यतनजपान्, मालाः, अद्य उपयुक्तान् गणकान् च योजयित्वा दर्शयति।';

  @override
  String get tutorialStep6Title => 'गणकविकल्पाः';

  @override
  String get tutorialStep6Desc =>
      'पत्रं दीर्घं स्पृशतु — \'गणकस्य विषये\', इतिहासः, सम्पादनं, कीलनं, निष्क्रियं (सफलम्), निष्क्रियं (असम्पूर्णम्), अपाकरणं च दृश्यन्ते।';

  @override
  String get tutorialStep7Title => 'गणकं कीलयतु';

  @override
  String get tutorialStep7Desc =>
      'पत्रस्य कीलचिह्नं स्पृष्ट्वा कीलयतु। कीलितः गणकः गणनार्थं न उद्घाट्यते। पुनः स्पृष्ट्वा उद्घाटयतु।';

  @override
  String get opticalCameraDenied =>
      'दृश्यकस्य (Camera) अनुमतिः निराकृता। दत्तांशं प्राप्तुं Android-संयोजनेषु अस्मै अनुप्रयोगाय दृश्यक-अनुमतिं ददातु।';

  @override
  String get opticalCameraError =>
      'दृश्यकम् (Camera) आरब्धुं न शक्यते। दृश्यकम् उपयुञ्जानान् अन्यान् अनुप्रयोगान् पिधाय पुनः प्रयतताम्।';

  @override
  String get opticalCameraUnavailable => 'अस्मिन् यन्त्रे QR-पाठकं न उपलभ्यते।';

  @override
  String get opticalTorchOn => 'दीपं प्रज्वालयतु';

  @override
  String get opticalTorchOff => 'दीपं शमयतु';

  @override
  String get opticalZoom => 'विस्तारः';

  @override
  String get opticalScanTip =>
      'केन्द्रीकरणाय सङ्केतं स्पृशतु। अस्पष्टं दृश्यते चेत् विस्तारं प्रयुङ्क्ताम्।';

  @override
  String get meruPauseTitle => 'विरमतु · श्वसितु';

  @override
  String get meruPauseMessage => 'मेरुमणिः प्राप्तः। प्रशान्त्यां विश्राम्यतु।';

  @override
  String get pacingHintMessage => 'शनैः शनैः, श्वसितु, मन्त्रम् अनुभवतु।';

  @override
  String get sectionMindfulCounting => 'सावधानगणनम्';

  @override
  String get sectionMindfulCountingSub => 'अत्वरितजपाय मृदुसाहाय्यम्';

  @override
  String get meruPauseSettingTitle => 'प्रतिमालान्ते मेरुविरामः';

  @override
  String get meruPauseSettingSub =>
      'अष्टोत्तरशतान्ते लघुः शान्तः विरामः। विरामकाले स्पर्शाः न गण्यन्ते।';

  @override
  String secondsShort(int seconds) {
    return '$seconds क्ष';
  }

  @override
  String get pacingHintSettingTitle => 'मृदुगतिसूचना';

  @override
  String get pacingHintSettingSub =>
      'अतिशीघ्रस्पर्शे मृदुप्रकाशः। सर्वे स्पर्शाः गण्यन्ते एव।';

  @override
  String get helpCountingMindfulSection => 'सावधानगणनम्';

  @override
  String get sadhanaFlowTitle => 'साधनाप्रवाहः';

  @override
  String sadhanaFlowA11y(int weeks) {
    return 'गतेषु $weeks सप्ताहेषु साधनादिनानां पञ्चाङ्गम्';
  }

  @override
  String sadhanaFlowYearDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'अस्मिन् वर्षे पवित्रस्मरणस्य $count दिनानि।',
      one: 'अस्मिन् वर्षे पवित्रस्मरणस्य 1 दिनम्।',
      zero: 'अस्मिन् वर्षे अर्पितः प्रत्येकः मन्त्रः अत्र प्रकाशिष्यते।',
    );
    return '$_temp0';
  }

  @override
  String get sadhanaFlowWelcomeBack =>
      'भवतः पवित्रस्थानं प्रति पुनः स्वागतम्। अर्पितः प्रत्येकः मन्त्रः शाश्वतः।';

  @override
  String get sadhanaFlowLess => 'अल्पम्';

  @override
  String get sadhanaFlowMore => 'अधिकम्';

  @override
  String get opticalBrightness => 'प्रकाशः';

  @override
  String get opticalBrightnessNormal => 'सामान्यम्';

  @override
  String opticalBrightnessBoost(int percent) {
    return '+$percent%';
  }

  @override
  String get helpCategoryCounters => 'भवतां गणकाः इतिहासश्च';

  @override
  String get helpTopicCountersTitle => 'गणकाः मुख्यपटं च';

  @override
  String get helpTopicCountersSub =>
      'गणकरचना, सम्पादनं, कीलनं, निष्क्रियीकरणं, विलोपनं, पत्रपठनं च';

  @override
  String get helpTopicHistoryTitle => 'इतिहासः साङ्ख्यिकी च';

  @override
  String get helpTopicHistorySub =>
      'दिनशः इतिहासः, साधनाप्रवाहदिनदर्शिका, गणकविवरणानि च';

  @override
  String get helpTopicDisplayTitle => 'प्रदर्शनं, स्थिरता, भाषा च';

  @override
  String get helpTopicDisplaySub =>
      'प्रकाशः, मन्दविधिः, शान्तिप्रणाली, मेरुविरामः, भाषा, स्वरूपं च';

  @override
  String get tutorialChapter1 => 'आरम्भः';

  @override
  String get tutorialChapter2 => 'भवतां गणकाः';

  @override
  String get tutorialChapter3 => 'गणनम्';

  @override
  String get tutorialChapter4 => 'मालाः लक्ष्याणि च';

  @override
  String get tutorialChapter5 => 'इतिहासः साङ्ख्यिकी च';

  @override
  String get tutorialChapter6 => 'ध्वनिः, कम्पनं, प्रदर्शनं च';

  @override
  String get tutorialChapter7 => 'भवतां दत्तांशः';

  @override
  String get tutorialChapter8 => 'गोपनीयता';

  @override
  String get tutorialStep1Tip =>
      'इमं मार्गदर्शिकां कदापि संयोजनानि → साहाय्यम् इत्यतः उद्घाटयितुं शक्यते।';

  @override
  String get tutorialStep2Tip =>
      'उपकरणस्य भाषा का अपि भवतु, मन्त्रनाम कस्यामपि लिप्यां लेखितुं शक्यते।';

  @override
  String get tutorialStep3Tip =>
      'लक्ष्यं नास्ति चेत् 0 लिखतु। दैनिकलक्ष्यं जीवनलक्ष्यात् अधिकं न भवेत्, वृद्धिपदं च दैनिकलक्ष्यात् न्यूनं भवेत्।';

  @override
  String get tutorialStep4Tip =>
      'हरितं चिह्नम् अद्यतनलक्ष्यस्य सिद्धिं सूचयति। सुवर्णपारितोषिकं जीवनलक्ष्यस्य सिद्धिं सूचयति।';

  @override
  String get tutorialStep5Tip =>
      'दूरवाण्याः घटिकानुसारं प्रतिदिनम् अर्धरात्रे एताः सङ्ख्याः 0 तः पुनः आरभन्ते।';

  @override
  String get tutorialStep6Tip =>
      'अपाकरणेन गणकः तस्य सर्वः इतिहासः च नश्यति। पुनः प्राप्तुं न शक्यते।';

  @override
  String get tutorialStep7Tip =>
      'समाप्तं विरलोपयुक्तं वा गणकं कीलयतु, येन प्रमादेन सङ्ख्या न परिवर्तते।';

  @override
  String get tutorialStep8Title => 'गणनपटम् उद्घाटयतु';

  @override
  String get tutorialStep8Desc =>
      'गणकपत्रं स्पृशतु। बृहत् मालावृत्तयुक्तं गणनपटम् उद्घाट्यते।';

  @override
  String get tutorialStep8Tip =>
      'संयोजनेषु शान्तिप्रणाली सक्रियं चेत्, अस्मिन् पटे उद्घाटिते दूरवाणी शान्ता तिष्ठति।';

  @override
  String get tutorialStep9Title => 'गणनाय स्पृशतु';

  @override
  String get tutorialStep9Desc =>
      'मालावृत्तस्य अन्तः स्पृशतु। प्रतिस्पर्शं वृद्धिपदं (सामान्यतः 1) योज्यते। वृत्तात् बहिः स्पर्शाः न गण्यन्ते।';

  @override
  String get tutorialStep9Tip =>
      'नेत्रे निमील्य अपि जपितुं शक्यते। वृत्तं बृहत् अस्ति, प्रत्येकमालासमाप्तौ ध्वनिः कम्पनं च भवति।';

  @override
  String get tutorialStep10Title => 'गणनां निवर्तयतु';

  @override
  String get tutorialStep10Desc =>
      'वृत्ते अङ्गुलिद्वयं निधाय वामतः दक्षिणतः वा चालयतु। एकेन चालनेन एकं पदं न्यूनीभवति।';

  @override
  String get tutorialStep10Tip =>
      'निवर्तनस्य पुष्ट्यर्थं दूरवाणी एकवारं कम्पते।';

  @override
  String get tutorialStep11Title => 'पटं पठतु';

  @override
  String get tutorialStep11Desc =>
      'उपरितनी गुलिका अस्य उपवेशनस्य कालं दर्शयति। मध्ये वर्तमानमालायां मणिः, अवशिष्टाः मणयः, समाप्ताः मालाः च दृश्यन्ते। अधस्तनपङ्क्तौ सत्रस्य, दिनस्य, जीवनस्य च सङ्ख्याः दृश्यन्ते।';

  @override
  String get tutorialStep11Tip =>
      'लक्ष्ये सिद्धे उपरि स्थितस्य दीपचिह्नस्य वर्णः परिवर्तते।';

  @override
  String get tutorialStep12Title => 'निर्गत्य पुनः आगच्छतु';

  @override
  String get tutorialStep12Desc =>
      'कदापि \'पृष्ठतः\' स्पृशतु। गणना शान्त्या रक्ष्यते। उपकरणे पृष्ठभूमौ सति कालमापकं स्थगितं भवति। असमाप्ता माला अन्यस्मिन् दिने अपि भवन्तं प्रतीक्षते।';

  @override
  String get tutorialStep12Tip =>
      'पुरातनसङ्ख्यां रक्षित्वा 0 तः नूतनमालाम् आरब्धुं सूचनापट्टे \'नूतनम् आरभ्यताम्\' स्पृशतु।';

  @override
  String get tutorialStep13Title => 'गणनसूची';

  @override
  String get tutorialStep13Desc =>
      '⋮ सूच्यां इतिहासः, विवरणं, संयोजनानि, समाप्य नूतनम् आरम्भः, सत्रपुनःस्थापनं, गणकपुनःस्थापनं च सन्ति।';

  @override
  String get tutorialStep13Tip =>
      'सत्रपुनःस्थापनम् इदम् उपवेशनमात्रं मार्जयति। गणकपुनःस्थापनं गणकस्य सर्वम् इतिहासम् अपाकरोति।';

  @override
  String get tutorialStep14Title => '108 मणयः = 1 माला';

  @override
  String get tutorialStep14Desc =>
      'प्रत्येकं 108 गणनाः एका माला। वृत्तं मणिशः पूर्यते, 108 अनन्तरं पुनः आरभते।';

  @override
  String get tutorialStep14Tip =>
      '115 गणनाः = 1 माला 7 गणनाः च। अधिकाः गणनाः कदापि न नश्यन्ति।';

  @override
  String get tutorialStep15Title => 'लक्ष्याणि प्राप्नोतु';

  @override
  String get tutorialStep15Desc =>
      'दैनिकलक्ष्ये सिद्धे ध्वनिः श्रूयते, दूरवाणी कम्पते, सूचना च दृश्यते। जीवनलक्ष्यस्य स्वकीयः ध्वनिः, सूचना, सुवर्णपारितोषिकं च सन्ति।';

  @override
  String get tutorialStep15Tip =>
      'एतानि संयोजनानि → ध्वनिः स्पन्दनं च इत्यत्र सक्रियाणि निष्क्रियाणि वा कुर्वन्तु।';

  @override
  String get tutorialStep16Title => 'मेरुविरामः';

  @override
  String get tutorialStep16Desc =>
      'संयोजनानि → प्रदर्शनं स्थिरता च इत्यत्र सक्रियं करोतु। प्रत्येकमालानन्तरं 3, 5, 10 वा निमेषान् उपकरणं विरमति, येन विश्रमितुं श्वसितुं च शक्यते।';

  @override
  String get tutorialStep16Tip =>
      'यथा मेरुमणिः कदापि न लङ्घ्यते, तथा विरामकाले स्पर्शाः न गण्यन्ते।';

  @override
  String get tutorialStep17Title => 'मृदुवेगसूचना';

  @override
  String get tutorialStep17Desc =>
      'निमेषे प्रायः त्रिभ्यः अधिकवारं स्पृशति चेत्, वृत्तं पीतवर्णेन दीप्यते, लघुस्मरणं च दृश्यते।';

  @override
  String get tutorialStep17Tip =>
      'सर्वे स्पर्शाः गण्यन्ते एव। संयोजनानि → प्रदर्शनं स्थिरता च इत्यत्र एषा सूचना निष्क्रिया कर्तुं शक्यते।';

  @override
  String get tutorialStep18Title => 'इतिहासः';

  @override
  String get tutorialStep18Desc =>
      'गणनसूच्याः दीर्घस्पर्शसूच्याः वा इतिहासम् उद्घाटयतु। उपवेशनानि दिनशः, समयेन, दीर्घतया, सङ्ख्यया, मालाभिः च सह दृश्यन्ते।';

  @override
  String get tutorialStep18Tip =>
      'उपवेशनम् अपाकर्तुं तस्य अपाकरणचिह्नं स्पृशतु। आहत्य सङ्ख्याः सद्यः नवीक्रियन्ते।';

  @override
  String get tutorialStep19Title => 'साधनाप्रवाहः';

  @override
  String get tutorialStep19Desc =>
      'इतिहासे स्थिता दिनदर्शिका गतान् 16 सप्ताहान् दर्शयति। साधनादिनानि दीपवत् दीप्यन्ते। अधिका दीप्तिः अधिकं जपं सूचयति।';

  @override
  String get tutorialStep19Tip =>
      'अविच्छिन्नदिनगणना वा त्यक्तदिनचिह्नं वा नास्ति। यस्मिन् दिने प्रत्यागच्छति तत् स्वागतम्।';

  @override
  String get tutorialStep20Title => 'गणकसाङ्ख्यिकी';

  @override
  String get tutorialStep20Desc =>
      'प्रगतिवृत्तानि गणकस्य सर्वविवरणानि च द्रष्टुं \'गणकस्य विषये\' (दीर्घस्पर्शसूची) विवरणं (गणनसूची) वा चिनोतु।';

  @override
  String get tutorialStep20Tip =>
      'प्रतिदिनं सरासरी जपसङ्ख्या भवता निर्धारितात् आरम्भदिनाङ्कात् गण्यते।';

  @override
  String get tutorialStep21Title => 'ध्वनयः';

  @override
  String get tutorialStep21Desc =>
      'संयोजनानि → ध्वनिः स्पन्दनं च इत्यत्र मालाध्वनिं, दैनिकलक्ष्यध्वनिं, जीवनलक्ष्यध्वनिं च चिनोतु। अन्तर्निहितध्वनिं, दूरवाण्याः घण्टिकाध्वनिं, स्वकीयां ध्वनिसञ्चिकां वा चिनोतु।';

  @override
  String get tutorialStep21Tip =>
      'जपात् पूर्वं ध्वनिं श्रोतुं \'ध्वनिं शृणोतु\' स्पृशतु।';

  @override
  String get tutorialStep22Title => 'कम्पनं सूचनाश्च';

  @override
  String get tutorialStep22Desc =>
      'प्रत्येकमालायां, लक्ष्ये, निवर्तने च कम्पनं भवति। लक्ष्यसूचनाः स्थितिपट्टिकायां दृश्यन्ते।';

  @override
  String get tutorialStep22Tip =>
      'ध्वनयः जागरणवाहिन्या वाद्यन्ते, अतः दूरवाण्यां मौनस्थितौ अपि श्रूयन्ते।';

  @override
  String get tutorialStep23Title => 'प्रदर्शनं स्थिरता च';

  @override
  String get tutorialStep23Desc =>
      'संयोजनानि → प्रदर्शनं स्थिरता च इत्यत्र प्रकाशं निर्धारयतु, मन्दजपविधिं सक्रियं करोतु, शान्तिप्रणाली इत्यनेन आह्वानानि सूचनाश्च शमयतु वा।';

  @override
  String get tutorialStep23Tip =>
      'शान्तिप्रणाली कृते एकवारम् अनुमतिः आवश्यकी। गणनपटात् निर्गमने तत् पुनः निष्क्रियं भवति।';

  @override
  String get tutorialStep24Title => 'रूपम्';

  @override
  String get tutorialStep24Desc =>
      'संयोजनानि → स्वरूपम् इत्यत्र उपकरणे उपयुक्ताः मन्दिरवर्णाः अक्षररूपाणि च दृश्यन्ते।';

  @override
  String get tutorialStep24Tip =>
      'एकेन हस्तेन गणनाय उपकरणं सर्वदा ऊर्ध्वस्थितौ (पोर्ट्रेट्) तिष्ठति।';

  @override
  String get tutorialStep25Title => 'सञ्चिकायां प्रतिलिपिः';

  @override
  String get tutorialStep25Desc =>
      'संयोजनानि → दत्तांशसंरक्षणम् → निर्यातः, मुख्यसूच्याम् आयात-निर्यातः वा उपयुज्यताम्। सर्वे गणकाः इतिहासः च एकस्यां सञ्चिकायां रक्ष्यन्ते, वितरणपत्रं च उद्घाट्यते।';

  @override
  String get tutorialStep25Tip =>
      'गुप्तवाक्येन सञ्चिकां कीलयितुं शक्यते (AES-256-GCM)। विस्मृतं गुप्तवाक्यं पुनः न लभ्यते।';

  @override
  String get tutorialStep26Title => 'सञ्चिकातः पुनःस्थापनम्';

  @override
  String get tutorialStep26Desc =>
      'आयातं चित्वा प्रतिलिपिसञ्चिकां चिनोतु। सञ्चिका कीलिता चेत् गुप्तवाक्यं लिखतु।';

  @override
  String get tutorialStep26Tip =>
      'आयातः अस्यां दूरवाण्यां स्थितं सर्वं दत्तांशं प्रतिस्थापयति। तं रक्षितुम् इच्छति चेत् प्रथमं निर्यातं करोतु।';

  @override
  String get tutorialStep27Title => 'दूरवाणीतः दूरवाणीं प्रति';

  @override
  String get tutorialStep27Desc =>
      'पुरातनदूरवाण्यां प्रकाशसञ्चारः (प्रेषणम्) चित्वा गणकान् चिनोतु। नूतनदूरवाण्यां प्रकाशसञ्चारः (स्वीकरणम्) चित्वा चलं QR सङ्केतं प्रति छायाग्राहकं धारयतु।';

  @override
  String get tutorialStep27Tip =>
      'अन्तर्जालं, ब्लूटूथ्, तन्त्री वा न उपयुज्यते। चिताः गणकाः योज्यन्ते; ग्राहकदूरवाण्याम् अन्ये गणकाः तिष्ठन्ति।';

  @override
  String get tutorialStep28Title => 'सर्वं दत्तांशं मार्जयतु';

  @override
  String get tutorialStep28Desc =>
      'संयोजनानि → दत्तांशसंरक्षणम् → सर्वदत्तांशमार्जनं सर्वान् गणकान् सर्वम् इतिहासं च अपाकरोति।';

  @override
  String get tutorialStep28Tip =>
      'प्रथमं प्रतिलिपिं करोतु। इदं निवर्तयितुं न शक्यते।';

  @override
  String get tutorialStep29Title => 'पूर्णतया अन्तर्जालरहितं गोपनीयं च';

  @override
  String get tutorialStep29Desc =>
      'उपकरणस्य अन्तर्जालानुमतिः नास्ति, विज्ञापनानि न, अनुवर्तनं न, खाता अपि न। भवतां साधना भवतां दूरवाण्याम् एव तिष्ठति।';

  @override
  String get tutorialStep29Tip =>
      'अस्य उपकरणस्य कृते एण्ड्रॉयड्-मेघप्रतिलिपिः निष्क्रिया, अतः प्रतिलिपिरक्षणाय निर्यातं प्रकाशसञ्चारं वा उपयुज्यताम्।';

  @override
  String get tutorialStep30Title => 'अनुमतयः';

  @override
  String get tutorialStep30Desc =>
      'छायाग्राहकः केवलं समन्वयसङ्केतानां परीक्षणाय। सूचनाः लक्ष्यसन्देशाय। कम्पनं ध्वनिश्च प्रतिक्रियायै। शान्तिप्रणाली अनुमतिः भवता सक्रियीकृते एव पृच्छ्यते।';

  @override
  String get tutorialStep30Tip =>
      'प्रत्येकम् अनुमतिः किमर्थम् इति संयोजनानि → अनुमतयः इत्यत्र पश्यतु।';

  @override
  String get helpCountersIntro =>
      'मुख्यपटे भवतां सर्वे गणकाः दृश्यन्ते। प्रत्येकः गणकः एकः मन्त्रः साधना वा, स्वकीयैः लक्ष्यैः इतिहासेन च सह।';

  @override
  String get helpCountersCreateSection => 'गणकरचना';

  @override
  String get helpCountersCreateBold1 => 'योजनगण्डः:';

  @override
  String get helpCountersCreateBullet1 =>
      'नूतनगणकाय मुख्यपटस्य उपरि स्थितं + गण्डं स्पृशतु।';

  @override
  String get helpCountersCreateBold2 => 'नाम:';

  @override
  String get helpCountersCreateBullet2 =>
      'मन्त्रनाम कस्यामपि भाषायां लिप्यां वा लिखतु।';

  @override
  String get helpCountersCreateBold3 => 'आरम्भसङ्ख्या:';

  @override
  String get helpCountersCreateBullet3 =>
      'पूर्वकृतान् जपान् योजयितुं, यथा पत्रे लिखितान्। सामान्यतः 0।';

  @override
  String get helpCountersCreateBold4 => 'वृद्धिपदम्:';

  @override
  String get helpCountersCreateBullet4 =>
      'एकेन स्पर्शेन कियत् योज्यते। सामान्यतः 1। दैनिकलक्ष्यात् न्यूनं भवेत्।';

  @override
  String get helpCountersCreateBold5 => 'लक्ष्याणि:';

  @override
  String get helpCountersCreateBullet5 =>
      'दैनिकलक्ष्यं जीवनलक्ष्यं च निर्धारयतु। लक्ष्यं नास्ति चेत् 0। दैनिकलक्ष्यं जीवनलक्ष्यात् अधिकं न भवेत्।';

  @override
  String get helpCountersCreateBold6 => 'आरम्भदिनाङ्कः:';

  @override
  String get helpCountersCreateBullet6 =>
      'अस्याः साधनायाः आरम्भदिनम्। प्रतिदिनं सरासरी जपगणनाय उपयुज्यते।';

  @override
  String get helpCountersHomeSection => 'मुख्यपटम्';

  @override
  String get helpCountersHomeBold1 => 'अद्यतनसारांशः:';

  @override
  String get helpCountersHomeBullet1 =>
      'उपरितनी गुलिका अद्यतनान् आहत्य जपान्, मालाः, अद्य उपयुक्तानां गणकानां सङ्ख्यां च दर्शयति।';

  @override
  String get helpCountersHomeBold2 => 'पत्रे प्रगतिः:';

  @override
  String get helpCountersHomeBullet2 =>
      'प्रत्येकस्मिन् पत्रे आहत्य जपाः मालाः च, अद्यतनजपाः, अद्यतनलक्ष्याय 27 मणीनां पङ्क्तिः, जीवनलक्ष्यस्य पट्टिका च सन्ति।';

  @override
  String get helpCountersHomeBold3 => 'चिह्नानि:';

  @override
  String get helpCountersHomeBullet3 =>
      'अद्यतनलक्ष्ये सिद्धे हरितचिह्नं दृश्यते। जीवनलक्ष्ये सिद्धे सुवर्णपारितोषिकं दृश्यते।';

  @override
  String get helpCountersHomeBold4 => 'क्रमः:';

  @override
  String get helpCountersHomeBullet4 =>
      'सक्रियाः गणकाः प्रथमं, ततः निष्क्रियाः। नूतनाः प्रथमं दृश्यन्ते।';

  @override
  String get helpCountersHomeBold5 => 'वर्णाः:';

  @override
  String get helpCountersHomeBullet5 =>
      'प्रत्येकः गणकः स्वकीयं वर्णं लभते, सः सर्वदा समानः तिष्ठति।';

  @override
  String get helpCountersHomeBold6 => 'उपरितनी सूची:';

  @override
  String get helpCountersHomeBullet6 =>
      'उपरितन्यां सूच्याम् आयात-निर्यातः, संयोजनानि, विषयपरिचयः च सन्ति।';

  @override
  String get helpCountersOptionsSection => 'गणकविकल्पाः (पत्रं दीर्घं स्पृशतु)';

  @override
  String get helpCountersOptionsBold1 => 'गणकस्य विषये:';

  @override
  String get helpCountersOptionsBullet1 => 'गणकस्य साङ्ख्यिकी विवरणानि च।';

  @override
  String get helpCountersOptionsBold2 => 'इतिहासः:';

  @override
  String get helpCountersOptionsBullet2 => 'अस्य गणकस्य सर्वाणि उपवेशनानि।';

  @override
  String get helpCountersOptionsBold3 => 'सम्पादनम्:';

  @override
  String get helpCountersOptionsBullet3 =>
      'नाम, पदं, लक्ष्याणि, आरम्भदिनाङ्कं वा परिवर्तयतु।';

  @override
  String get helpCountersOptionsBold4 => 'कीलनम् / उद्घाटनम्:';

  @override
  String get helpCountersOptionsBullet4 => 'पत्रस्य कीलचिह्नवत् एव।';

  @override
  String get helpCountersOptionsBold5 => 'निष्क्रियीकृतः (सिद्धः):';

  @override
  String get helpCountersOptionsBullet5 =>
      'गणकं समाप्तम् इति चिह्नयतु, यथा सङ्कल्पे पूर्णे। कारणं योजयितुं शक्यते।';

  @override
  String get helpCountersOptionsBold6 => 'निष्क्रियीकृतः (अपूर्णः):';

  @override
  String get helpCountersOptionsBullet6 =>
      'असमाप्तं गणकं स्थगयतु। कारणं योजयितुं शक्यते।';

  @override
  String get helpCountersOptionsBold7 => 'विलोपनम्:';

  @override
  String get helpCountersOptionsBullet7 =>
      'पुष्टेः अनन्तरं गणकं तस्य सर्वम् इतिहासं च अपाकरोति। निवर्तयितुं न शक्यते।';

  @override
  String get helpCountersLockSection => 'कीलिताः निष्क्रियाः च गणकाः';

  @override
  String get helpCountersLockBold1 => 'कीलचिह्नम्:';

  @override
  String get helpCountersLockBullet1 =>
      'कीलनाय उद्घाटनाय वा पत्रस्य कीलचिह्नं स्पृशतु।';

  @override
  String get helpCountersLockBold2 => 'कीलितः:';

  @override
  String get helpCountersLockBullet2 =>
      'कीलितः गणकः गणनार्थं न उद्घाट्यते, अतः प्रमादेन सङ्ख्या न परिवर्तते। स्पर्शे लघुसन्देशः दृश्यते।';

  @override
  String get helpCountersLockBold3 => 'निष्क्रियः:';

  @override
  String get helpCountersLockBullet3 =>
      'निष्क्रियाः गणकाः चिह्नेन सह सूच्यां तिष्ठन्ति, किन्तु गणनार्थं न उद्घाट्यन्ते।';

  @override
  String get helpCountingScreenSection => 'पटपठनम्';

  @override
  String get helpCountingScreenBold1 => 'कालमापकम्:';

  @override
  String get helpCountingScreenBullet1 =>
      'उपरितनी गुलिका अस्य उपवेशनस्य कालं दर्शयति। उपकरणे पृष्ठभूमौ सति \'स्थगितम्\' इति दर्शयति।';

  @override
  String get helpCountingScreenBold2 => 'मध्ये:';

  @override
  String get helpCountingScreenBullet2 =>
      'बृहत्सङ्ख्या वर्तमानमालायां स्थानम् (0–107)। तदधः अवशिष्टाः मणयः अस्मिन् उपवेशने समाप्ताः मालाः च।';

  @override
  String get helpCountingScreenBold3 => 'अधस्तनपङ्क्तिः:';

  @override
  String get helpCountingScreenBullet3 =>
      'सत्रस्य, दिनस्य, जीवनस्य च सङ्ख्याः लक्ष्यप्रगत्या सह दर्शयति।';

  @override
  String get helpCountingScreenBold4 => 'दीपः:';

  @override
  String get helpCountingScreenBullet4 =>
      'दैनिकलक्ष्ये जीवनलक्ष्ये वा सिद्धे उपरि स्थितस्य दीपचिह्नस्य वर्णः परिवर्तते।';

  @override
  String get helpCountingSaveSection => 'निर्गमनं रक्षणं च';

  @override
  String get helpCountingSaveBold1 => 'स्वयंरक्षणम्:';

  @override
  String get helpCountingSaveBullet1 =>
      'कदापि \'पृष्ठतः\' स्पृशतु। गणना शान्त्या रक्ष्यते; उपकरणं न पृच्छति।';

  @override
  String get helpCountingSaveBold2 => 'विघ्नेऽपि सुरक्षितम्:';

  @override
  String get helpCountingSaveBullet2 =>
      'प्रति 5 स्पर्शान् 5 निमेषान् वा गणना रक्ष्यते, प्रति 20 स्पर्शान् 30 निमेषान् वा पूर्णतया सञ्चीयते। दूरवाण्यां निष्क्रियायाम् अपि उपकरणोद्घाटने गणना प्रत्यागच्छति।';

  @override
  String get helpCountingSaveBold3 => 'कालमापकविरामः:';

  @override
  String get helpCountingSaveBullet3 =>
      'उपकरणे पृष्ठभूमौ सति कालमापकं स्थगितं भवति, अतः निष्क्रियकालः उपवेशने न योज्यते।';

  @override
  String get helpCountingSaveBold4 => 'असमाप्ता माला:';

  @override
  String get helpCountingSaveBullet4 =>
      '108 पूर्वं विरमति चेत्, अन्यस्मिन् दिने अपि अग्रिमवारं सा माला प्रतीक्षते, सूचनापट्टः तां दर्शयति। स्पर्शाः सर्वदा तस्मिन् एव दिने गण्यन्ते यस्मिन् कृताः। ताः गणनाः रक्षित्वा 0 तः नूतनमालाम् आरब्धुं \'नूतनम् आरभ्यताम्\' स्पृशतु।';

  @override
  String get helpCountingMenuSection => 'गणनसूची (⋮)';

  @override
  String get helpCountingMenuBold1 => 'इतिहासः:';

  @override
  String get helpCountingMenuBullet1 => 'अस्य गणकस्य इतिहासम् उद्घाटयति।';

  @override
  String get helpCountingMenuBold2 => 'विवरणम्:';

  @override
  String get helpCountingMenuBullet2 =>
      'अस्य गणकस्य साङ्ख्यिकीं विवरणानि च दर्शयति।';

  @override
  String get helpCountingMenuBold3 => 'संयोजनानि:';

  @override
  String get helpCountingMenuBullet3 => 'उपकरणस्य संयोजनानि उद्घाटयति।';

  @override
  String get helpCountingMenuBold4 => 'समाप्य नूतनम् आरभ्यताम्:';

  @override
  String get helpCountingMenuBullet4 =>
      'वर्तमानाम् असमाप्तमालां समापयति। तस्याः गणनाः इतिहासे रक्ष्यन्ते, अग्रिमः स्पर्शः 0 तः नूतनमालाम् आरभते।';

  @override
  String get helpCountingMenuBold5 => 'सत्रं पुनःस्थाप्यताम्:';

  @override
  String get helpCountingMenuBullet5 =>
      'वर्तमानम् उपवेशनं त्यक्त्वा 0 करोति। पूर्वेतिहासः तिष्ठति।';

  @override
  String get helpCountingMenuBold6 => 'गणकः पुनःस्थाप्यताम्:';

  @override
  String get helpCountingMenuBullet6 =>
      'अस्य गणकस्य सर्वम् इतिहासम् अपाकरोति। निवर्तयितुं न शक्यते।';

  @override
  String get helpCountingMindfulBold1 => 'मेरुविरामः:';

  @override
  String get helpCountingMindfulBullet1 =>
      'संयोजनानि → प्रदर्शनं स्थिरता च इत्यत्र सक्रियीकृते, प्रत्येकमालानन्तरम् उपकरणं 3, 5, 10 वा निमेषान् विरमति। विरामे स्पर्शाः न गण्यन्ते। विरामः स्वयं समाप्यते, निवर्तनचालनेन वा।';

  @override
  String get helpCountingMindfulBold2 => 'गतिसूचना:';

  @override
  String get helpCountingMindfulBullet2 =>
      'निमेषे प्रायः त्रिभ्यः अधिकवारं स्पृशति चेत्, वृत्तं मृदु दीप्यते, लघुस्मरणं च दृश्यते। एतत् कदापि गणनां न निरुणद्धि।';

  @override
  String get helpMalaBeadsBold4 => 'मालाध्वनिः:';

  @override
  String get helpMalaBeadsBullet4 =>
      'सक्रियं चेत् प्रत्येकम् अष्टोत्तरशततमगणनायां मृदुध्वनिः भवति। तेनैव स्पर्शेन लक्ष्ये सिद्धे सः त्यज्यते, येन ध्वनयः न मिश्रीभवन्ति।';

  @override
  String get helpMalaGoalsBold3 => 'दैनिकलक्ष्यसिद्धौ:';

  @override
  String get helpMalaGoalsBullet3 =>
      'दैनिकसूचना सक्रिया चेत् लक्ष्यध्वनिः भवति, दूरवाणी कम्पते, सूचना च दृश्यते। पत्रे हरितचिह्नं दृश्यते।';

  @override
  String get helpMalaGoalsBold4 => 'जीवनलक्ष्यसिद्धौ:';

  @override
  String get helpMalaGoalsBullet4 =>
      'जीवनसूचना सक्रिया चेत् तस्याः ध्वनिः सूचना च भवतः। सुवर्णपारितोषिकं दृश्यते, पत्रं मृदुचन्दनवर्णं भवति।';

  @override
  String get helpMalaCardSection => 'पत्रे प्रगतिः';

  @override
  String get helpMalaCardBold1 => 'मणिपङ्क्तिः:';

  @override
  String get helpMalaCardBullet1 =>
      '27 लघुमणीनां पङ्क्तिः अद्यतनलक्ष्यप्रगतिं दर्शयति। प्रत्येकः मणिः लक्ष्यस्य 1/27, मालायाः 4 मणिवत्।';

  @override
  String get helpMalaCardBold2 => 'जीवनपट्टिका:';

  @override
  String get helpMalaCardBullet2 =>
      'दीर्घपट्टिका जीवनलक्ष्यस्य कियान् भागः सिद्धः इति दर्शयति।';

  @override
  String get helpMalaCardBold3 => 'सङ्ख्याः:';

  @override
  String get helpMalaCardBullet3 =>
      'पत्रे आहत्य जपाः, आहत्य मालाः, अद्यतनजपाः मालाः च दृश्यन्ते।';

  @override
  String get helpHistoryIntro =>
      'इतिहासः प्रत्येकोपवेशनस्य अभिलेखं रक्षति। गणनसूच्याः, गणकस्य दीर्घस्पर्शसूच्याः, गणकविवरणपृष्ठात् वा उद्घाटयतु।';

  @override
  String get helpHistoryLogSection => 'इतिहाससूची';

  @override
  String get helpHistoryLogBold1 => 'सारांशः:';

  @override
  String get helpHistoryLogBullet1 =>
      'उपरितनं पत्रम् आहत्य जपान्, साधनादिनानि, सङ्कल्पस्य कियान् भागः सिद्धः इति च दर्शयति।';

  @override
  String get helpHistoryLogBold2 => 'दिनशः:';

  @override
  String get helpHistoryLogBullet2 =>
      'उपवेशनानि दिनाङ्कशः, नूतनानि प्रथमम्। प्रत्येकं दिनं स्वकीयम् आहत्यं तद्दिनान्तपर्यन्तम् आहत्यं च दर्शयति।';

  @override
  String get helpHistoryLogBold3 => 'उपवेशनपङ्क्तयः:';

  @override
  String get helpHistoryLogBullet3 =>
      'प्रत्येकम् उपवेशनम् आरम्भसमयं, दीर्घतां, सङ्ख्यां, मालाः च दर्शयति।';

  @override
  String get helpHistoryDeleteSection => 'इतिहासविलोपनम्';

  @override
  String get helpHistoryDeleteBold1 => 'एकम् उपवेशनम्:';

  @override
  String get helpHistoryDeleteBullet1 =>
      'उपवेशनस्य विलोपनचिह्नं स्पृष्ट्वा पुष्टिं करोतु। आहत्यसङ्ख्याः सद्यः पुनः गण्यन्ते।';

  @override
  String get helpHistoryDeleteBold2 => 'इतिहासमार्जनम्:';

  @override
  String get helpHistoryDeleteBullet2 =>
      'उपरितनः मार्जनगण्डः पुष्टेः अनन्तरम् अस्य गणकस्य सर्वाणि उपवेशनानि अपाकरोति। निवर्तयितुं न शक्यते।';

  @override
  String get helpHistoryFlowSection => 'साधनाप्रवाहदिनदर्शिका';

  @override
  String get helpHistoryFlowBold1 => '16 सप्ताहाः:';

  @override
  String get helpHistoryFlowBullet1 =>
      'गतानां 16 सप्ताहानां दिनदर्शिका, सोमवासरः उपरि। साधनादिनानि मृदुचन्दनात् गाढकाषायपर्यन्तं दीपवत् दीप्यन्ते।';

  @override
  String get helpHistoryFlowBold2 => 'दीप्तिः:';

  @override
  String get helpHistoryFlowBullet2 =>
      'दैनिकलक्ष्ययुक्तस्य गणकस्य दीप्तिः तल्लक्ष्यप्रगतिं दर्शयति। अन्यथा दर्शितेषु अधिकतमजपदिनेन सह तुल्यते।';

  @override
  String get helpHistoryFlowBold3 => 'दबावः नास्ति:';

  @override
  String get helpHistoryFlowBullet3 =>
      'अविच्छिन्नदिनगणना वा त्यक्तदिनचिह्नं वा नास्ति। त्रिभ्यः अधिकदिनेभ्यः अनन्तरं प्रत्यागमने स्नेहपूर्णा स्वागतपङ्क्तिः दृश्यते।';

  @override
  String get helpHistoryStatsSection => 'गणकसाङ्ख्यिकी';

  @override
  String get helpHistoryStatsBold1 => 'उद्घाटनम्:';

  @override
  String get helpHistoryStatsBullet1 =>
      'गणकं दीर्घं स्पृष्ट्वा \'गणकस्य विषये\' चिनोतु, गणनसूच्यां \'विवरणम्\' वा उपयुज्यताम्।';

  @override
  String get helpHistoryStatsBold2 => 'वृत्तानि:';

  @override
  String get helpHistoryStatsBullet2 =>
      'त्रीणि वृत्तानि जीवनप्रगतिम्, अद्यतनप्रगतिम्, आहत्य मालाः च दर्शयन्ति।';

  @override
  String get helpHistoryStatsBold3 => 'विवरणानि:';

  @override
  String get helpHistoryStatsBullet3 =>
      'नाम, स्थितिः, पदम्, आरम्भसङ्ख्या, लक्ष्याणि, आरम्भदिनाङ्कः, रचनादिनाङ्कः, प्रतिदिनं सरासरी जपाः, निष्क्रियत्वे तद्दिनाङ्कः कारणं च।';

  @override
  String get helpAudioMalaSection => 'मालाध्वनिः';

  @override
  String get helpAudioMalaBold1 => 'मालाध्वनिः:';

  @override
  String get helpAudioMalaBullet1 =>
      'प्रत्येकम् अष्टोत्तरशततमगणनायां मृदुध्वनिः कम्पनं च।';

  @override
  String get helpAudioMalaBold2 => 'विकल्पाः:';

  @override
  String get helpAudioMalaBullet2 =>
      'मन्दिरकांस्यघण्टा, तिब्बतीयगायनपात्रं, संश्लिष्टध्वनिः (लघुबीप्) वा।';

  @override
  String get helpAudioMalaBold3 => 'मिश्रणं नास्ति:';

  @override
  String get helpAudioMalaBullet3 =>
      'अष्टोत्तरशततमगणना लक्ष्यम् अपि साधयति चेत् लक्ष्यध्वनिः एव भवति।';

  @override
  String get helpAudioGoalSection => 'दैनिकलक्ष्यम्';

  @override
  String get helpAudioGoalBold1 => 'सूचना:';

  @override
  String get helpAudioGoalBullet1 =>
      'दैनिकलक्ष्ये सिद्धे ध्वनिः भवति, दूरवाणी कम्पते, स्थितिपट्टिकायां सूचना च दृश्यते।';

  @override
  String get helpAudioGoalBold2 => 'लक्ष्यध्वनिः:';

  @override
  String get helpAudioGoalBullet2 =>
      'प्रणाली-पूर्वनिर्धारितं, दूरवाण्याः घण्टिकाध्वनिं, अन्तर्निहितध्वनिं (मन्दिरघण्टा, गायनपात्रं, संश्लिष्टध्वनिः, पवित्रशङ्खः), स्वकीयां ध्वनिसञ्चिकां (MP3, WAV, AAC) वा चिनोतु।';

  @override
  String get helpAudioGoalBold3 => 'पूर्वश्रवणम्:';

  @override
  String get helpAudioGoalBullet3 =>
      'चितं ध्वनिं श्रोतुं \'ध्वनिं शृणोतु\' स्पृशतु।';

  @override
  String get helpAudioLifetimeSection => 'जीवनलक्ष्यम्';

  @override
  String get helpAudioLifetimeBold1 => 'जीवनलक्ष्यध्वनिः:';

  @override
  String get helpAudioLifetimeBullet1 => 'जीवनलक्ष्यसिद्धिक्षणाय पृथक् ध्वनिः।';

  @override
  String get helpAudioLifetimeBold2 => 'जीवनलक्ष्यसूचना:';

  @override
  String get helpAudioLifetimeBullet2 =>
      'जीवनलक्ष्यसिद्धौ ध्वनिं, कम्पनं, सूचनां च प्राप्तुम् एतत् सक्रियं करोतु।';

  @override
  String get helpAudioVolumeSection => 'श्रवणयोग्यः ध्वनिः';

  @override
  String get helpAudioVolumeBold1 => 'जागरणवाहिनी:';

  @override
  String get helpAudioVolumeBullet1 =>
      'समाप्तिध्वनयः जागरणवाहिन्या वाद्यन्ते, अतः मौनस्थितौ अपि श्रूयन्ते। कतिपयनिमेषानन्तरं ध्वनिमात्रा पूर्ववत् भवति।';

  @override
  String get helpDisplayIntro =>
      'एतानि संयोजनानि शान्तजपे साहाय्यं कुर्वन्ति, उपकरणस्य रूपं भाषां च चेतुम् अपि।';

  @override
  String get helpDisplayBrightSection => 'प्रकाशः मन्दता च';

  @override
  String get helpDisplayBrightBold1 => 'प्रकाशस्तरः:';

  @override
  String get helpDisplayBrightBullet1 =>
      'संयोजनानि → प्रदर्शनं स्थिरता च इत्यत्र मन्दात् पूर्णपर्यन्तं स्तरं चिनोतु। एतत् उपकरणपटम् एव परिवर्तयति, दूरवाण्याः प्रकाशं न।';

  @override
  String get helpDisplayBrightBold2 => 'प्रणालीप्रयोगः:';

  @override
  String get helpDisplayBrightBullet2 =>
      'दूरवाण्याः सामान्यप्रकाशं प्रति प्रत्यागन्तुं \'प्रणाली\' विकल्पं स्पृशतु।';

  @override
  String get helpDisplayBrightBold3 => 'मन्दप्रकाशजपविधिः:';

  @override
  String get helpDisplayBrightBullet3 =>
      'मालावृत्तं स्पष्टं रक्षित्वा गणनपटस्य पृष्ठभूमिं श्यामां करोति। अन्धकारकक्षेभ्यः उचितम्, विद्युत्कोशं च रक्षति।';

  @override
  String get helpDisplayDndSection => 'शान्तिप्रणाली';

  @override
  String get helpDisplayDndBold1 => 'सूचनाशमनम्:';

  @override
  String get helpDisplayDndBullet1 =>
      'सक्रिये सति गणनपटे उद्घाटिते दूरवाणी शान्तिप्रणाल्यां गच्छति, निर्गमने पूर्ववत् भवति।';

  @override
  String get helpDisplayDndBold2 => 'अनुमतिः:';

  @override
  String get helpDisplayDndBullet2 =>
      'प्रथमवारं शान्तिप्रणाल्याः अनुमतिं दातुम् उपकरणं पृच्छति। संयोजनानि उद्घाट्य अस्मै उपकरणाय अनुमतिं ददातु।';

  @override
  String get helpDisplayMindfulSection => 'सावधानगणनम्';

  @override
  String get helpDisplayMindfulBold1 => 'मेरुविरामः:';

  @override
  String get helpDisplayMindfulBullet1 =>
      'प्रत्येकमालानन्तरं 3, 5, 10 वा निमेषाणां लघुविरामः। विरामे स्पर्शाः न गण्यन्ते। सामान्यतः निष्क्रियः।';

  @override
  String get helpDisplayMindfulBold2 => 'मृदुगतिसूचना:';

  @override
  String get helpDisplayMindfulBullet2 =>
      'अतिवेगेन स्पर्शे मृदुदीप्तिः। सर्वे स्पर्शाः गण्यन्ते। सामान्यतः सक्रिया।';

  @override
  String get helpDisplayLangSection => 'भाषा';

  @override
  String get helpDisplayLangBold1 => 'भाषाचयनम्:';

  @override
  String get helpDisplayLangBullet1 =>
      'संयोजनानि → भाषा इत्यत्र आङ्ग्लं, मलयाळं, संस्कृतं, प्रणाली-पूर्वनिर्धारितं वा चिनोतु।';

  @override
  String get helpDisplayLangBold2 => 'का अपि लिपिः:';

  @override
  String get helpDisplayLangBullet2 =>
      'उपकरणभाषा का अपि भवतु, गणकनाम कस्यामपि लिप्यां लेखितुं शक्यते।';

  @override
  String get helpDisplayLookSection => 'स्वरूपम्';

  @override
  String get helpDisplayLookBold1 => 'मन्दिरशैली:';

  @override
  String get helpDisplayLookBullet1 =>
      'संयोजनानि → स्वरूपम् इत्यत्र उपकरणस्य वर्णाः (क्षीरवर्णः, सिन्दूरः, चन्दनं, तुलसी, पाटलः) अक्षररूपाणि च दृश्यन्ते।';

  @override
  String get helpDisplayLookBold2 => 'ऊर्ध्वस्थितिः एव:';

  @override
  String get helpDisplayLookBullet2 =>
      'एकेन हस्तेन गणनाय उपकरणं सर्वदा ऊर्ध्वं तिष्ठति।';

  @override
  String get helpOpticalHowBold4 => 'संयोजनम्:';

  @override
  String get helpOpticalHowBullet4 =>
      'चिताः गणकाः ग्राहकदूरवाण्यां योज्यन्ते। तत्र पूर्वमेव स्थितः समानः गणकः प्राप्तप्रतिलिप्या प्रतिस्थाप्यते। तस्यां दूरवाण्याम् अन्ये गणकाः न स्पृश्यन्ते।';

  @override
  String get helpOpticalSendSection => 'प्रेषकनियन्त्रणानि';

  @override
  String get helpOpticalSendBold1 => 'वेगः:';

  @override
  String get helpOpticalSendBullet1 =>
      'निमेषे 8, 12, 15 वा चित्राणि चिनोतु। 8 पूर्वनिर्धारितम्, बहुषु दूरवाणीषु उत्तमम्।';

  @override
  String get helpOpticalSendBold2 => 'विरामः प्रवर्तनं च:';

  @override
  String get helpOpticalSendBullet2 =>
      'कदापि प्रवाहं स्थगयित्वा पुनः प्रवर्तयतु।';

  @override
  String get helpOpticalSendBold3 => 'प्रकाशः:';

  @override
  String get helpOpticalSendBullet3 =>
      'अन्यछायाग्राहकस्य कष्टे सति सर्पकेण पटं प्रकाशमानतरं कर्तुं शक्यते। प्रेषणे स्थगिते पूर्ववत् भवति। प्रेषणकाले पटं सक्रियं तिष्ठति।';

  @override
  String get helpOpticalReceiveSection => 'ग्राहकनियन्त्रणानि';

  @override
  String get helpOpticalReceiveBold1 => 'केन्द्रीकरणाय स्पृशतु:';

  @override
  String get helpOpticalReceiveBullet1 =>
      'सङ्केते केन्द्रीकर्तुं छायाग्राहकदृश्यं स्पृशतु।';

  @override
  String get helpOpticalReceiveBold2 => 'विस्तारणम्:';

  @override
  String get helpOpticalReceiveBullet2 =>
      'सङ्केतः लघुः दृश्यते चेत् विस्तारणसर्पकं (4× पर्यन्तम्) उपयुज्यताम्।';

  @override
  String get helpOpticalReceiveBold3 => 'दीपः:';

  @override
  String get helpOpticalReceiveBullet3 => 'अन्धकारकक्षे दीपिकां प्रज्वालयतु।';

  @override
  String get helpOpticalReceiveBold4 => 'प्राप्तचित्राणि:';

  @override
  String get helpOpticalReceiveBullet4 =>
      'सर्वभागपूर्तेः पूर्वम् अपि परीक्षणं प्रचलति इति एषा पङ्क्तिः दर्शयति।';

  @override
  String get helpBackupWhereSection => 'कुत्र लभ्यते';

  @override
  String get helpBackupWhereBold1 => 'संयोजनानि:';

  @override
  String get helpBackupWhereBullet1 =>
      'संयोजनानि → दत्तांशसंरक्षणम् इत्यत्र निर्यातः, आयातः, प्रकाशसञ्चारः, सर्वदत्तांशमार्जनं च सन्ति।';

  @override
  String get helpBackupWhereBold2 => 'मुख्यसूची:';

  @override
  String get helpBackupWhereBullet2 =>
      'मुख्यपटस्य सूच्याम् अपि आयात-निर्यातः अस्ति।';

  @override
  String get helpBackupExportBold4 => 'वितरणपत्रम्:';

  @override
  String get helpBackupExportBullet4 =>
      'निर्यातानन्तरम् एण्ड्रॉयड्-वितरणपत्रम् उद्घाट्यते। सञ्चिकां स्वसञ्चिकासु स्मृतिपत्रे वा रक्षतु, विश्वस्तेन उपकरणेन प्रेषयतु वा।';

  @override
  String get helpBackupImportBold4 => 'सुरक्षितपुनःस्थापनम्:';

  @override
  String get helpBackupImportBullet4 =>
      'सञ्चिका प्रथमं परीक्ष्यते। सा दूषिता गुप्तवाक्यं वा अशुद्धं चेत् किमपि न परिवर्तते, दोषः च दर्श्यते।';

  @override
  String get helpBackupImportBold5 => 'पुरातनप्रतिलिपयः:';

  @override
  String get helpBackupImportBullet5 =>
      'अस्य उपकरणस्य पुरातन-एण्ड्रॉयड्-संस्करणस्य प्रतिलिपिसञ्चिकाः अपि आयातुं शक्यन्ते।';

  @override
  String get helpBackupClearSection => 'सर्वदत्तांशमार्जनम्';

  @override
  String get helpBackupClearBold1 => 'सर्वमार्जनम्:';

  @override
  String get helpBackupClearBullet1 =>
      'पुष्टेः अनन्तरं सर्वान् गणकान् सर्वम् इतिहासं च अपाकरोति। निवर्तयितुं न शक्यते, अतः प्रथमं प्रतिलिपिं करोतु।';

  @override
  String get helpPrivacyStorageBold3 => 'सुरक्षितरक्षणम्:';

  @override
  String get helpPrivacyStorageBullet3 =>
      'उपकरणे सहसा पिहिते अपि पुनः पुनः रक्षणेन गणना सुरक्षिता तिष्ठति।';

  @override
  String get helpPrivacyPermsSection => 'उपकरणेन उपयुक्ताः अनुमतयः';

  @override
  String get helpPrivacyPermsBold1 => 'छायाग्राहकः:';

  @override
  String get helpPrivacyPermsBullet1 =>
      'प्रकाशसञ्चारस्वीकरणे QR सङ्केतपरीक्षणाय एव। चित्राणि चलचित्राणि वा न गृह्यन्ते।';

  @override
  String get helpPrivacyPermsBold2 => 'सूचनाः:';

  @override
  String get helpPrivacyPermsBullet2 =>
      'स्थितिपट्टिकायां लक्ष्यसन्देशान् दर्शयितुम्। एण्ड्रॉयड् 13 तः परं पृच्छ्यते।';

  @override
  String get helpPrivacyPermsBold3 => 'कम्पनं ध्वनिश्च:';

  @override
  String get helpPrivacyPermsBullet3 =>
      'माला-लक्ष्य-निवर्तनप्रतिक्रियायै, समाप्तिध्वनीनां स्पष्टवादनाय च।';

  @override
  String get helpPrivacyPermsBold4 => 'शान्तिप्रणाल्यनुमतिः:';

  @override
  String get helpPrivacyPermsBullet4 =>
      'प्रदर्शनं स्थिरता च इत्यत्र शान्तिप्रणाल्यां सक्रियीकृतायाम् एव पृच्छ्यते।';

  @override
  String get helpPrivacyPermsBold5 => 'भवतां सञ्चिकाः:';

  @override
  String get helpPrivacyPermsBullet5 =>
      'उपकरणं भवतां सञ्चिकाः न पठति। आयात-निर्यातौ एण्ड्रॉयड्-सञ्चिकाचयनकम् उपयुञ्जाते, यत्र भवान् सञ्चिकां चिनोति।';

  @override
  String get helpPrivacyPermsBold6 => 'पूर्णसूची:';

  @override
  String get helpPrivacyPermsBullet6 =>
      'संयोजनानि → अनुमतयः इत्यत्र प्रत्येकानुमतिः किमर्थम् इति दृश्यते।';

  @override
  String get helpFaqQ5Title => 'मम गणनाः कस्मिन् दिने योज्यन्ते?';

  @override
  String get helpFaqQ5Answer =>
      'दूरवाण्याः घटिकानुसारं प्रत्येकः स्पर्शः तस्मिन् एव दिने गण्यते यस्मिन् कृतः। दैनिकलक्ष्यम् अर्धरात्रे पुनः आरभते।';

  @override
  String get helpFaqQ6Title => 'सत्रपुनःस्थापनस्य गणकपुनःस्थापनस्य च भेदः कः?';

  @override
  String get helpFaqQ6Answer =>
      'सत्रपुनःस्थापनं वर्तमानम् उपवेशनम् एव त्यजति। गणकपुनःस्थापनं तस्य गणकस्य सर्वम् इतिहासम् अपाकरोति, निवर्तयितुं न शक्यते।';

  @override
  String get helpFaqQ7Title => 'मालाध्वनिः किमर्थं न श्रुतः?';

  @override
  String get helpFaqQ7Answer =>
      'मालाध्वनिः सक्रियः वा इति पश्यतु। तेनैव स्पर्शेन लक्ष्ये सिद्धे लक्ष्यध्वनिः एव भवति।';

  @override
  String get helpFaqQ8Title => 'मौनस्थितौ अपि ध्वनयः किमर्थं श्रूयन्ते?';

  @override
  String get helpFaqQ8Answer =>
      'समाप्तिध्वनयः जागरणवाहिनीम् उपयुञ्जते येन ते न त्यज्यन्ते। मौनम् इच्छति चेत् संयोजनानि → ध्वनिः स्पन्दनं च इत्यत्र ध्वनीन् निष्क्रियान् करोतु।';

  @override
  String get helpFaqQ9Title => 'प्रतिलिपेः गुप्तवाक्यं विस्मृतम्। किं करवाणि?';

  @override
  String get helpFaqQ9Answer =>
      'गुप्तवाक्यं पुनः न लभ्यते, सा सञ्चिका न उद्घाट्यते। यस्यां दूरवाण्यां दत्तांशः अद्यापि अस्ति ततः नूतनप्रतिलिपिं करोतु।';

  @override
  String get helpFaqQ10Title => 'आयातः वर्तमानगणकान् अपाकरिष्यति वा?';

  @override
  String get helpFaqQ10Answer =>
      'प्रतिलिपिसञ्चिकायाः आयातः वर्तमानं सर्वं दत्तांशं प्रतिस्थापयति। प्रकाशसञ्चारः भिन्नः: भवता चितान् गणकान् एव योजयति नवीकरोति वा।';

  @override
  String get helpFaqQ11Title =>
      'प्रकाशसञ्चारपरीक्षणं मन्दम्। किं साहाय्यं करोति?';

  @override
  String get helpFaqQ11Answer =>
      'दूरवाणीं 15–25 से.मी. दूरे स्थिरं धारयतु, केन्द्रीकरणाय स्पृशतु, प्रतिबिम्बं परिहरतु, प्रेषकस्य प्रकाशं वर्धयतु। निमेषे 8 चित्राणि इति मन्दवेगं प्रयततु।';

  @override
  String get helpFaqQ12Title => 'दत्तांशं नूतनदूरवाणीं प्रति नेतुं शक्यते वा?';

  @override
  String get helpFaqQ12Answer =>
      'आम्। उभे दूरवाण्यौ पार्श्वे निधाय प्रकाशसञ्चारम् उपयुज्यताम्, प्रतिलिपिसञ्चिकां निर्यात्य नूतनदूरवाण्याम् आयातयतु वा।';

  @override
  String get helpFaqQ13Title => 'उपकरणं किमर्थं पूर्णतया अन्तर्जालरहितम्?';

  @override
  String get helpFaqQ13Answer =>
      'जपः वैयक्तिकः पवित्रः च। अन्तर्जालरहितत्वं साधनां गोपनीयां करोति, विद्युत्कोशं रक्षति, विक्षेपान् च निवारयति।';

  @override
  String get helpFaqQ14Title => 'मम दत्तांशः केनापि सह विभज्यते वा?';

  @override
  String get helpFaqQ14Answer =>
      'न। भवान् स्वयं निर्यातं प्रकाशसञ्चारेण प्रेषणं वा विना दत्तांशः दूरवाणीं कदापि न त्यजति।';
}
