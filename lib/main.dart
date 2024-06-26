import 'package:eyes_care/countdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

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
          return MaterialApp(
            title: 'Eyes Care',
            debugShowCheckedModeBanner: false,
            themeMode: themeNotifier.value,
            theme: ThemeData.light().copyWith(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
            darkTheme: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue, brightness: Brightness.dark)),
            home: const CountdownScreen(),
          );
        });
  }
}
