import 'package:eyes_care/main.dart';
import 'package:eyes_care/widgets/edit_rule_button.dart';
import 'package:flutter/material.dart';
import 'package:rocket_timer/rocket_timer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/force_mode_check_box.dart';
import 'package:eyes_care/widgets/rule_text.dart';
import 'package:eyes_care/widgets/rule_timer.dart';
import 'package:local_notifier/local_notifier.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  CountdownScreenState createState() => CountdownScreenState();
}

const int rule = 20;
const duration = Duration(minutes: rule);
const size = Size(400, 400);

class CountdownScreenState extends State<CountdownScreen> with WindowListener {
  late RocketTimer _timer;
  bool inProgress = false;
  late ValueNotifier<bool> forceModeEnabled = ValueNotifier(false);
  int followed = 0;
  WindowOptions windowOptions = const WindowOptions(
    windowButtonVisibility: false,
    size: size,
    minimumSize: size,
    maximumSize: size,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  @override
  void initState() {
    setUpForceMode();
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.addListener(this);
    localNotifier.setup(
      appName: 'CareYourEyes',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
    super.initState();
    initTimer();
  }

  void initTimer() {
    _timer = RocketTimer(type: TimerType.countdown, duration: duration);
    _timer.addListener(() {
      if (_timer.kDuration == 0) {
        showNotification();
        _timer.kDuration = inProgress ? duration.inSeconds : rule;
        inProgress = !inProgress;
        setState(() {});
      }
    });
    _timer.start();
  }

  setUpForceMode() {
    PreferenceService.getBool(PreferenceService.forceModeKey).then((value) {
      forceModeEnabled.value = value ?? false;
    });
  }

  @override
  Future<void> onWindowMinimize() async {
    if (forceModeEnabled.value) {
      await handleWindowState();
    }
    super.onWindowMinimize();
  }

  @override
  Future<void> onWindowBlur() async {
    if (forceModeEnabled.value) {
      await handleWindowState();
    }
    super.onWindowBlur();
  }

  Future<void> handleWindowState() async {
    if (inProgress) {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setFullScreen(true);
    } else {
      windowManager.minimize();
      await windowManager.setFullScreen(false);
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> showNotification() async {
    LocalNotification notification = LocalNotification(
      title: inProgress ? "Stay Focused 💪" : "Take a Moment 🌟",
      body: inProgress
          ? "Keep your gaze on the screen. Remember, every 20 minutes, take a 20-second break looking at something 20 feet away."
          : "Step back from the screen and focus on something 20 feet away for 20 seconds. Your eyes will thank you!",
    );
    notification.onShow = _onShowNotification;
    notification.show();
  }

  _onShowNotification() async {
    if (forceModeEnabled.value) {
      await handleWindowState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Eyes Care'),
          centerTitle: true,
          actions: [
            AnimatedBuilder(
                animation: _timer,
                builder: (context, _) {
                  return IconButton(
                    icon: Icon(_timer.status == TimerStatus.pause
                        ? Icons.play_arrow
                        : Icons.pause),
                    onPressed: () {
                      if (_timer.status == TimerStatus.pause) {
                        _timer.start();
                      } else {
                        _timer.pause();
                      }
                    },
                  );
                }),
            IconButton(
                onPressed: _timer.restart, icon: const Icon(Icons.restart_alt)),
            IconButton(
                onPressed: windowManager.minimize,
                icon: const Icon(Icons.minimize_rounded)),
          ],
          leading: ValueListenableBuilder(
              valueListenable: themeNotifier,
              builder: (context, _, __) {
                final isLight = themeNotifier.value.index == 1;
                return IconButton(
                    onPressed: () {
                      themeNotifier.value =
                          isLight ? ThemeMode.dark : ThemeMode.light;
                    },
                    icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode));
              })),
      body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            direction: inProgress ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (inProgress)
                      Text(
                          "look away from your screen and focus on something 20 feet away for 20 seconds.",
                          style: Theme.of(context).textTheme.headlineMedium)
                    else
                      const RuleText(),
                    ForceModeCheckBox(forceModeEnabled: forceModeEnabled)
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  RuleTimer(timer: _timer, inProgress: inProgress),
                  const EditRuleButton(),
                ],
              )),
            ],
          )),
    );
  }
}
