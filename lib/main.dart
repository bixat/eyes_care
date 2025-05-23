import 'package:eyes_care/countdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(const CareYourEyes());
}

final themeNotifier = ValueNotifier(ThemeMode.light);

class CareYourEyes extends StatelessWidget {
  const CareYourEyes({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: themeNotifier,
        builder: (context, _, __) {
          const primaryColor = Color(0xFF6C63FF);
          const secondaryColor = Color(0xFF32CD32);

          return MaterialApp(
            title: 'Eyes Care',
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.value,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                secondary: secondaryColor,
              ),
              textTheme: GoogleFonts.poppinsTextTheme(),
              cardTheme: CardTheme(
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
              textTheme:
                  GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
              cardTheme: CardTheme(
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
        });
  }
}
