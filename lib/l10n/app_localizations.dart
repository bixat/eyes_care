import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taline'**
  String get appTitle;

  /// No description provided for @forceMode.
  ///
  /// In en, this message translates to:
  /// **'Force Mode'**
  String get forceMode;

  /// No description provided for @forceModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prevent window minimization during breaks'**
  String get forceModeSubtitle;

  /// No description provided for @startupAtLogin.
  ///
  /// In en, this message translates to:
  /// **'Startup at Login'**
  String get startupAtLogin;

  /// No description provided for @startupAtLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Launch application automatically at system startup'**
  String get startupAtLoginSubtitle;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'work'**
  String get work;

  /// No description provided for @breakPeriod.
  ///
  /// In en, this message translates to:
  /// **'break'**
  String get breakPeriod;

  /// No description provided for @breakTime.
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// No description provided for @ruleTitle.
  ///
  /// In en, this message translates to:
  /// **'20-20-20 Rule'**
  String get ruleTitle;

  /// No description provided for @ruleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give your eyes a rest by following the 20-20-20 rule'**
  String get ruleSubtitle;

  /// No description provided for @ruleEvery20Minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 20 minutes,'**
  String get ruleEvery20Minutes;

  /// No description provided for @ruleLookAway.
  ///
  /// In en, this message translates to:
  /// **'look away from your screen and focus on something'**
  String get ruleLookAway;

  /// No description provided for @rule20FeetAway.
  ///
  /// In en, this message translates to:
  /// **'20 feet away'**
  String get rule20FeetAway;

  /// No description provided for @ruleFor.
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get ruleFor;

  /// No description provided for @rule20Seconds.
  ///
  /// In en, this message translates to:
  /// **'20 seconds.'**
  String get rule20Seconds;

  /// No description provided for @ruleExplanation.
  ///
  /// In en, this message translates to:
  /// **'This helps reduce eye strain caused by prolonged screen use.'**
  String get ruleExplanation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editRule.
  ///
  /// In en, this message translates to:
  /// **'Edit Rule'**
  String get editRule;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @stayFocused.
  ///
  /// In en, this message translates to:
  /// **'Stay Focused 💪'**
  String get stayFocused;

  /// No description provided for @takeAMoment.
  ///
  /// In en, this message translates to:
  /// **'Take a Moment 🌟'**
  String get takeAMoment;

  /// No description provided for @breakNotification.
  ///
  /// In en, this message translates to:
  /// **'Keep your gaze on the screen. Remember, every 20 minutes, take a 20-second break looking at something 20 feet away.'**
  String get breakNotification;

  /// No description provided for @workNotification.
  ///
  /// In en, this message translates to:
  /// **'Step back from the screen and focus on something 20 feet away for 20 seconds. Your eyes will thank you!'**
  String get workNotification;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by bixat.dev team'**
  String get poweredBy;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @muslimMode.
  ///
  /// In en, this message translates to:
  /// **'Muslim Mode'**
  String get muslimMode;

  /// No description provided for @muslimModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show prayer times and Adhan'**
  String get muslimModeSubtitle;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @tapToDetect.
  ///
  /// In en, this message translates to:
  /// **'Tap to detect'**
  String get tapToDetect;

  /// No description provided for @detect.
  ///
  /// In en, this message translates to:
  /// **'Detect'**
  String get detect;

  /// No description provided for @eyeCare.
  ///
  /// In en, this message translates to:
  /// **'Eye Care'**
  String get eyeCare;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPrayer;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Disabled'**
  String get locationDisabled;

  /// No description provided for @enableLocationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services in your system settings to detect your exact city.'**
  String get enableLocationPrompt;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @timeForPrayer.
  ///
  /// In en, this message translates to:
  /// **'Time for prayer'**
  String get timeForPrayer;

  /// No description provided for @stopAdhan.
  ///
  /// In en, this message translates to:
  /// **'Stop Adhan'**
  String get stopAdhan;

  /// No description provided for @adhanIsPlaying.
  ///
  /// In en, this message translates to:
  /// **'Adhan is playing'**
  String get adhanIsPlaying;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
