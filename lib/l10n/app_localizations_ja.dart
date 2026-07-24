// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'アイケア';

  @override
  String get forceMode => 'フォースモード';

  @override
  String get forceModeSubtitle => '休憩中にウィンドウを最小化できないようにする';

  @override
  String get startupAtLogin => 'ログイン時に起動';

  @override
  String get startupAtLoginSubtitle => 'システム起動時にアプリを自動的に起動';

  @override
  String get work => '作業';

  @override
  String get breakPeriod => '休憩';

  @override
  String get breakTime => '休憩時間';

  @override
  String get ruleTitle => '20-20-20 ルール';

  @override
  String get ruleSubtitle => '20-20-20 ルールに従って目を休めましょう';

  @override
  String get ruleEvery20Minutes => '20 分ごとに、';

  @override
  String get ruleLookAway => '画面から目を離して、何かに焦点を当ててください';

  @override
  String get rule20FeetAway => '20 フィート先';

  @override
  String get ruleFor => '間';

  @override
  String get rule20Seconds => '20 秒間。';

  @override
  String get ruleExplanation => 'これは、長時間の画面使用による眼精疲労を軽減するのに役立ちます。';

  @override
  String get settings => '設定';

  @override
  String get editRule => 'ルールを編集';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get minutes => '分';

  @override
  String get seconds => '秒';

  @override
  String get stayFocused => '集中し続けて 💪';

  @override
  String get takeAMoment => '少し休憩 🌟';

  @override
  String get breakNotification =>
      '画面に視線を向け続けましょう。覚えておいてください、20 分ごとに、20 フィート先を 20 秒間見て休憩しましょう。';

  @override
  String get workNotification => '画面から離れて、20 フィート先を 20 秒間見つめましょう。目が感謝します！';

  @override
  String get poweredBy => 'bixat.dev チームによって提供';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get system => 'システム';

  @override
  String get muslimMode => 'Muslim Mode';

  @override
  String get muslimModeSubtitle => 'Show prayer times and Adhan';

  @override
  String get location => 'Location';

  @override
  String get tapToDetect => 'Tap to detect';

  @override
  String get detect => 'Detect';

  @override
  String get eyeCare => 'Eye Care';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get fajr => 'Fajr';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get asr => 'Asr';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get isha => 'Isha';

  @override
  String get nextPrayer => 'Next';

  @override
  String get locationDisabled => 'Location Disabled';

  @override
  String get enableLocationPrompt =>
      'Please enable location services in your system settings to detect your exact city.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get timeForPrayer => 'Time for prayer';

  @override
  String get stopAdhan => 'Stop Adhan';

  @override
  String get adhanIsPlaying => 'Adhan is playing';
}
