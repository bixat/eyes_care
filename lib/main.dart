import 'dart:io';
import 'package:local_notifier/local_notifier.dart';
import 'package:eyes_care/services/prayer_service.dart';

import 'package:eyes_care/countdown_screen.dart';
import 'package:eyes_care/l10n/app_localizations.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> initLaunchStartup() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
    packageName: packageInfo.packageName,
  );
}

Future<void> loadThemeMode() async {
  final mode = await PreferenceService.getThemeMode();
  if (mode == 'dark') {
    themeNotifier.value = ThemeMode.dark;
  } else if (mode == 'light') {
    themeNotifier.value = ThemeMode.light;
  } else if (mode == 'system') {
    themeNotifier.value = ThemeMode.system;
  }
}

Future<void> loadLanguage() async {
  final lang = await PreferenceService.getLanguage();
  if (lang != null) {
    localeNotifier.value = Locale(lang);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await localNotifier.setup(appName: 'Taline');
  await loadThemeMode();
  await loadLanguage();
  await initLaunchStartup();
  await PrayerService().init();
  runApp(const CareYourEyes());
}

final themeNotifier = ValueNotifier(ThemeMode.light);
final localeNotifier = ValueNotifier(const Locale('en'));

class CareYourEyes extends StatelessWidget {
  const CareYourEyes({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, themeValue, _) {
        return ValueListenableBuilder(
          valueListenable: localeNotifier,
          builder: (context, localeValue, _) {
            const primaryColor = Color(0xFF5BE0E5);
            const secondaryColor = Color(0xFF32CD32);

            return MaterialApp(
              title: 'Taline',
              debugShowCheckedModeBanner: false,
              locale: localeValue,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
                Locale('es'),
                Locale('fr'),
                Locale('de'),
                Locale('zh'),
                Locale('ja'),
                Locale('ru'),
                Locale('pt'),
                Locale('hi'),
                Locale('tr'),
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              themeMode: themeValue,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  secondary: secondaryColor,
                ),
                textTheme: _getTextTheme(localeValue),
                cardTheme: CardThemeData(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  secondary: secondaryColor,
                  brightness: Brightness.dark,
                ),
                textTheme: _getTextTheme(localeValue, isDark: true),
                cardTheme: CardThemeData(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                ),
              ),
              home: const CountdownScreen(),
            );
          },
        );
      },
    );
  }

  TextTheme _getTextTheme(Locale locale, {bool isDark = false}) {
    // Use Tajawal font for Arabic, Poppins for other languages
    if (locale.languageCode == 'ar') {
      return GoogleFonts.tajawalTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      );
    }
    return GoogleFonts.poppinsTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );
  }
}
