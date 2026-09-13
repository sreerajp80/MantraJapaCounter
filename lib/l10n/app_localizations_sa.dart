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
  String get menuAbout => 'विषये';

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
  String get aboutTitle => 'विषये';

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
  String get sectionStillness => 'प्रशान्तिः';

  @override
  String get sectionStillnessSub => 'रात्रौ नेत्रसौख्याय मन्दप्रकाशः';

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
  String get helpHeaderSub => 'जपगणकस्य उपयोगविषये मार्गदर्शिका';

  @override
  String get helpCategoryCounting => 'जपसाधना';

  @override
  String get helpCategorySync => 'दत्तांशसञ्चारः';

  @override
  String get helpCategoryAudio => 'ध्वनिः कम्पनञ्च';

  @override
  String get helpCategoryPrivacy => 'गोपनीयता';

  @override
  String get helpTopicCountingTitle => 'जपगणना कथं करणीया';

  @override
  String get helpTopicCountingSub => 'स्पर्शः, मालाः, ध्यानावस्था च';

  @override
  String get helpTopicMalaTitle => '१०८ मणयः एका माला';

  @override
  String get helpTopicMalaSub => 'मालापूर्तिः तस्याः महत्त्वञ्च';

  @override
  String get helpTopicOpticalSyncTitle => 'प्रकाशसञ्चारः (QR)';

  @override
  String get helpTopicOpticalSyncSub =>
      'अन्तर्जालं विना यन्त्रयोर्मध्ये दत्तांशसञ्चारः';

  @override
  String get helpTopicBackupTitle => 'दत्तांशसंरक्षणम्';

  @override
  String get helpTopicBackupSub => 'JSON-सञ्चिकायाः आयात-निर्यात-प्रक्रिया';

  @override
  String get helpTopicAudioTitle => 'ध्वनिः कम्पनञ्च';

  @override
  String get helpTopicAudioSub => 'घण्टानादः, कम्पनम्, मूकसाधना च';

  @override
  String get helpTopicPrivacyTitle => 'गोपनीयता दर्शनञ्च';

  @override
  String get helpTopicPrivacySub => 'शून्यनिरीक्षणम्, अन्तर्जालरहितम्';

  @override
  String get helpTopicFaqTitle => 'प्रायिकप्रश्नाः';

  @override
  String get helpTopicFaqSub => 'सामान्यप्रश्नानाम् उत्तराणि';

  @override
  String get helpCountingIntro =>
      'अयं जपगणकः भवतः एकाग्रसाधनायै सौकर्याय च रचितः अस्ति।';

  @override
  String get helpCountingTapSection => 'स्पर्शेन गणना';

  @override
  String get helpCountingTapBold1 => 'यत्र कुत्रापि स्पृशन्तु';

  @override
  String get helpCountingTapBullet1 =>
      'फलकस्य यत्र कुत्रापि स्पृष्ट्वा जपगणनां वर्धयितुं शक्नुवन्ति।';

  @override
  String get helpCountingTapBold2 => 'वर्धमानपदम्';

  @override
  String get helpCountingTapBullet2 =>
      'इच्छानुसारेण १ वा अन्यसङ्ख्यायाः वृद्धिक्रमः संयोज्यते।';

  @override
  String get helpCountingTapBold3 => 'प्रशान्तिः (Stillness)';

  @override
  String get helpCountingTapBullet3 =>
      'मन्दप्रकाशेन विक्षेपं विना रात्रौ जपः क्रियताम्।';

  @override
  String get helpCountingUndoSection => 'पूर्ववत्करणम्';

  @override
  String get helpCountingUndoBold1 => 'प्रमादस्पर्शस्य निराकरणम्';

  @override
  String get helpCountingUndoBullet1 =>
      'पूर्ववत्-चिह्नं स्पृष्ट्वा अन्तिमं जपस्पर्शं निराकुर्वन्तु।';

  @override
  String get helpCountingUndoBold2 => 'सत्रसुरक्षा';

  @override
  String get helpCountingUndoBullet2 =>
      'वर्तमानसत्रस्यैव स्पर्शः निराक्रियते, समग्रदत्तांशो न नश्यति।';

  @override
  String get helpCountingTimerSection => 'समयमापनम्';

  @override
  String get helpCountingTimerBold1 => 'स्वचालितसमयः';

  @override
  String get helpCountingTimerBullet1 => 'जपसत्रस्य कालावधिः स्वयमेव सञ्चीयते।';

  @override
  String get helpCountingTimerBold2 => 'विश्रामः (Pause)';

  @override
  String get helpCountingTimerBullet2 => 'जपविरामे सति समयमापनमपि विरमति।';

  @override
  String get helpMalaIntro =>
      '१०८ जपमणयः पारम्परिकसनातनसाधनायाः एकां पूर्णां मालां सूचयन्ति।';

  @override
  String get helpMalaBeadsSection => 'मणियोजनम्';

  @override
  String get helpMalaBeadsBold1 => '१०८ मणयः';

  @override
  String get helpMalaBeadsBullet1 =>
      'प्रत्येकं १०८ जपानां समाप्तौ एका माला स्वयमेव योज्यते।';

  @override
  String get helpMalaBeadsBold2 => 'अवशिष्टाः मणयः';

  @override
  String get helpMalaBeadsBullet2 =>
      'वर्तमानमालायाः कति मणयः अवशिष्टाः इति स्पष्टं ज्ञायते।';

  @override
  String get helpMalaBeadsBold3 => 'मालासमाप्तिध्वनिः';

  @override
  String get helpMalaBeadsBullet3 =>
      'मालापूर्तौ सौम्यः घण्टानादः श्रूयते, मृदुकम्पनं चानुभूयते।';

  @override
  String get helpMalaGoalsSection => 'लक्ष्यव्यवस्था';

  @override
  String get helpMalaGoalsBold1 => 'दैनिकलक्ष्यम्';

  @override
  String get helpMalaGoalsBullet1 =>
      'नित्यं कति जपाः करणीयाः इति निर्धारयन्तु।';

  @override
  String get helpMalaGoalsBold2 => 'आजीवनलक्ष्यम्';

  @override
  String get helpMalaGoalsBullet2 =>
      'दीर्घकालीनसङ्कल्पस्य (यथा लक्षजपस्य) प्रगतिं पश्यन्तु।';

  @override
  String get helpOpticalIntro =>
      'अन्तर्जालं विना यन्त्रयोर्मध्ये प्रकाशतरङ्गरूपेण (QR) दत्तांशसञ्चारः क्रियते।';

  @override
  String get helpOpticalHowSection => 'कथं कार्यं करोति';

  @override
  String get helpOpticalHowBold1 => 'प्रेषकयन्त्रम्';

  @override
  String get helpOpticalHowBullet1 =>
      'प्रेषकयन्त्रं QR-सङ्केतानां प्रवाहं प्रदर्शयति।';

  @override
  String get helpOpticalHowBold2 => 'ग्राहकयन्त्रम्';

  @override
  String get helpOpticalHowBullet2 =>
      'ग्राहकयन्त्रस्य चित्रग्राहकेण (Camera) तान् सङ्केतान् पठन्तु।';

  @override
  String get helpOpticalHowBold3 => 'सम्पूर्णा सुरक्षा';

  @override
  String get helpOpticalHowBullet3 =>
      'नास्त्यन्तर्जालस्य, ब्लूटूत्-माध्यमस्य वा कोऽपि सम्बन्धः।';

  @override
  String get helpOpticalTipsSection => 'उपयुक्तपरामर्शाः';

  @override
  String get helpOpticalTipsBold1 => 'प्रकाशस्तरः';

  @override
  String get helpOpticalTipsBullet1 =>
      'प्रेषकफलकस्य प्रकाशं किञ्चिद् वर्धयन्तु।';

  @override
  String get helpOpticalTipsBold2 => 'दूरत्वम्';

  @override
  String get helpOpticalTipsBullet2 =>
      'यन्त्रद्वयं १५-२० से.मी. दूरे स्थापयन्तु।';

  @override
  String get helpOpticalTipsBold3 => 'स्थिरता';

  @override
  String get helpOpticalTipsBullet3 => 'पठनसमये यन्त्रं स्थिरं धारयन्तु।';

  @override
  String get helpAudioIntro => 'जपसमये ध्वनिः कम्पनञ्च भवत एकाग्रतां पोषयतः।';

  @override
  String get helpAudioTonesSection => 'सूचनाध्वनयः';

  @override
  String get helpAudioTonesBold1 => 'प्रणालीध्वनिः';

  @override
  String get helpAudioTonesBullet1 =>
      'यन्त्रस्य पूर्वनिर्धारितध्वनेरुपयोगं कुर्वन्तु।';

  @override
  String get helpAudioTonesBold2 => 'व्यक्तिगतध्वनिः';

  @override
  String get helpAudioTonesBullet2 =>
      'स्वस्य प्रियाम् ओङ्कारनादादिसञ्चिकां योजयन्तु।';

  @override
  String get helpAudioTonesBold3 => 'मूकसाधना';

  @override
  String get helpAudioTonesBullet3 =>
      'इच्छानुसारं ध्वनिं सर्वथा पिधातुं शक्नुवन्ति।';

  @override
  String get helpAudioVibrationSection => 'कम्पनम्';

  @override
  String get helpAudioVibrationBold1 => 'स्पर्शकम्पनम्';

  @override
  String get helpAudioVibrationBullet1 =>
      'प्रत्येकं जपस्पर्शसमये मृदुकम्पनं भवति।';

  @override
  String get helpAudioVibrationBold2 => 'लक्ष्यकम्पनम्';

  @override
  String get helpAudioVibrationBullet2 =>
      'दैनिकलक्ष्यपूर्तौ विशेषकम्पनमनुभूयते।';

  @override
  String get helpBackupIntro =>
      'भवतः साधनादत्तांशोऽत्यन्तमूल्यवान्। सञ्चिकामाध्यमेन तं संरक्षन्तु।';

  @override
  String get helpBackupExportSection => 'निर्यातप्रक्रिया';

  @override
  String get helpBackupExportBold1 => 'JSON-सञ्चिकानिर्हारः';

  @override
  String get helpBackupExportBullet1 =>
      'सर्वे गणकाः सत्राणि चैकस्यां सञ्चिकायां संरक्ष्यन्ते।';

  @override
  String get helpBackupExportBold2 => 'सुरक्षितसञ्चयः';

  @override
  String get helpBackupExportBullet2 =>
      'निर्याता सञ्चिकान्यत्र यन्त्रे सञ्चिकारूपेण प्रेषयितुं शक्यते।';

  @override
  String get helpBackupExportBold3 => 'नियमितसंरक्षणम्';

  @override
  String get helpBackupExportBullet3 =>
      'सप्ताहे सकृद् वा मासे सकृद् दत्तांशं निर्हरन्तु।';

  @override
  String get helpBackupImportSection => 'आयातप्रक्रिया';

  @override
  String get helpBackupImportBold1 => 'JSON-सञ्चिकायाश्चयनम्';

  @override
  String get helpBackupImportBullet1 =>
      'पूर्वं संरक्षितां JSON-सञ्चिकां चिनोतु।';

  @override
  String get helpBackupImportBold2 => 'दत्तांशपुनःस्थापनम्';

  @override
  String get helpBackupImportBullet2 =>
      'आयातप्रक्रियया सर्वे गणकाः सत्राणि च पुनःस्थाप्यन्ते।';

  @override
  String get helpBackupImportBold3 => 'दत्तांशसङ्गतिः';

  @override
  String get helpBackupImportBullet3 =>
      'आयातात् पूर्वं वर्तमानदत्तांशस्य परीक्षणं क्रियते।';

  @override
  String get helpPrivacyIntro =>
      'गोपनीयतास्माकं प्रधानसङ्कल्पः। भवतः दत्तांशः केवलं भवत एव।';

  @override
  String get helpPrivacyOfflineSection => 'सर्वथा अन्तर्जालरहितम्';

  @override
  String get helpPrivacyOfflineBold1 => 'शून्यसंयोगः (No Internet)';

  @override
  String get helpPrivacyOfflineBullet1 =>
      'अस्मिन् अनुप्रयोगे अन्तर्जालसम्पर्कस्यानुज्ञा नास्ति।';

  @override
  String get helpPrivacyOfflineBold2 => 'शून्यनिरीक्षणम् (Zero Telemetry)';

  @override
  String get helpPrivacyOfflineBullet2 =>
      'कोऽपि विश्लेषणांशो (Analytics) नास्ति, न किमपि बाह्यं प्रेष्यते।';

  @override
  String get helpPrivacyOfflineBold3 => 'विज्ञापनरहितम्';

  @override
  String get helpPrivacyOfflineBullet3 => 'नास्ति विज्ञापनम्, नास्ति व्यामोहः।';

  @override
  String get helpPrivacyStorageSection => 'स्थानिकदत्तांशः';

  @override
  String get helpPrivacyStorageBold1 => 'यन्त्रे एव सञ्चयः';

  @override
  String get helpPrivacyStorageBullet1 =>
      'सर्वे गणकाः सत्राणि च भवतः दूरवाण्यामेव तिष्ठन्ति।';

  @override
  String get helpPrivacyStorageBold2 => 'क्लाउड-रहितम्';

  @override
  String get helpPrivacyStorageBullet2 => 'मेघे (Cloud) किमपि न सञ्चीयते।';

  @override
  String get helpFaqIntro => 'जपगणकविषये सामान्या जिज्ञासाः।';

  @override
  String get helpFaqQ1Title => 'किम् अन्तर्जालसम्पर्क आवश्यकः?';

  @override
  String get helpFaqQ1Answer => 'नहि, अयं गणकः सर्वथा अन्तर्जालरहितोऽस्ति।';

  @override
  String get helpFaqQ2Title => '१०८ जपानां समाप्तौ किं भवति?';

  @override
  String get helpFaqQ2Answer =>
      '१०८ जपानन्तरमेका माला स्वयमेव योज्यते, सौम्यघण्टानादश्च भवति।';

  @override
  String get helpFaqQ3Title => 'मम दत्तांशः कथं सुरक्षितः?';

  @override
  String get helpFaqQ3Answer =>
      'सर्वो दत्तांशः केवलं भवतः यन्त्र एव तिष्ठति। JSON-सञ्चिकाद्वारा तं संरक्षन्तु।';

  @override
  String get helpFaqQ4Title => 'प्रमादेन गणना वर्धिता चेत् किं करणीयम्?';

  @override
  String get helpFaqQ4Answer =>
      'उपरि दृश्यमानं पूर्ववत्-चिह्नं स्पृष्ट्वा अन्तिमं जपस्पर्शं निराकुर्वन्तु।';

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
  String opticalFrameProgress(int current, int total) {
    return 'सङ्केतः $current / $total';
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
}
