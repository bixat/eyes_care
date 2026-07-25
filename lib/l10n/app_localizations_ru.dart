// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Забота о Глазах';

  @override
  String get forceMode => 'Принудительный Режим';

  @override
  String get forceModeSubtitle =>
      'Предотвратить сворачивание окна во время перерывов';

  @override
  String get startupAtLogin => 'Запуск при Входе';

  @override
  String get startupAtLoginSubtitle =>
      'Автоматически запускать приложение при запуске системы';

  @override
  String get work => 'работа';

  @override
  String get breakPeriod => 'перерыв';

  @override
  String get breakTime => 'Время Перерыва';

  @override
  String get ruleTitle => 'Правило 20-20-20';

  @override
  String get ruleSubtitle => 'Дайте отдых глазам, следуя правилу 20-20-20';

  @override
  String get ruleEvery20Minutes => 'Каждые 20 минут,';

  @override
  String get ruleLookAway =>
      'отводите взгляд от экрана и фокусируйтесь на чем-то';

  @override
  String get rule20FeetAway => 'в 20 футах';

  @override
  String get ruleFor => 'на';

  @override
  String get rule20Seconds => '20 секунд.';

  @override
  String get ruleExplanation =>
      'Это помогает уменьшить зрительное напряжение, вызванное длительным использованием экрана.';

  @override
  String get settings => 'Настройки';

  @override
  String get editRule => 'Редактировать Правило';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get minutes => 'Минуты';

  @override
  String get seconds => 'Секунды';

  @override
  String get stayFocused => 'Оставайтесь Сосредоточенными 💪';

  @override
  String get takeAMoment => 'Сделайте Паузу 🌟';

  @override
  String get breakNotification =>
      'Держите взгляд на экране. Помните, каждые 20 минут делайте 20-секундный перерыв, глядя на что-то в 20 футах.';

  @override
  String get workNotification =>
      'Отойдите от экрана и сфокусируйтесь на чем-то в 20 футах на 20 секунд. Ваши глаза скажут вам спасибо!';

  @override
  String get poweredBy => 'Разработано командой bixat.dev';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get system => 'Системная';

  @override
  String get muslimMode => 'Мусульманский режим';

  @override
  String get muslimModeSubtitle => 'Показывать время молитв и азан';

  @override
  String get location => 'Локация';

  @override
  String get tapToDetect => 'Нажмите, чтобы определить';

  @override
  String get detect => 'Определить';

  @override
  String get eyeCare => 'Забота о глазах';

  @override
  String get prayerTimes => 'Время молитв';

  @override
  String get fajr => 'Фаджр';

  @override
  String get sunrise => 'Восход';

  @override
  String get dhuhr => 'Зухр';

  @override
  String get asr => 'Аср';

  @override
  String get maghrib => 'Магриб';

  @override
  String get isha => 'Иша';

  @override
  String get nextPrayer => 'Следующая';

  @override
  String get locationDisabled => 'Локация отключена';

  @override
  String get enableLocationPrompt =>
      'Пожалуйста, включите службы геолокации в настройках системы, чтобы определить ваш город.';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get timeForPrayer => 'Время молитвы';

  @override
  String get stopAdhan => 'Остановить Азан';

  @override
  String get adhanIsPlaying => 'Азан звучит';
}
