import 'package:eyes_care/main.dart';
import 'package:eyes_care/widgets/edit_rule_button.dart';
import 'package:flutter/material.dart';
import 'package:rocket_timer/rocket_timer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_launcher/url_launcher.dart';
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

const size = Size(500, 900);

class CountdownScreenState extends State<CountdownScreen> with WindowListener {
  RocketTimer? _timer;
  bool inProgress = false;
  bool isPaused = false;
  late ValueNotifier<bool> forceModeEnabled = ValueNotifier(false);
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

  late int reminder;
  late int breakTime;

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

    setupTimer();
    super.initState();
  }

  Future<void> setupTimer() async {
    var (min, sec) = await PreferenceService.getDuration();
    reminder = min ?? 20;
    breakTime = sec ?? 20;
    initTimer();
    setState(() {});
  }

  void initTimer() {
    final duration = Duration(minutes: reminder);
    _timer = RocketTimer(type: TimerType.countdown, duration: duration);
    _timer!.addListener(() {
      if (_timer!.kDuration == 0) {
        showNotification();
        _timer!.kDuration = inProgress ? duration.inSeconds : reminder;
        inProgress = !inProgress;
        setState(() {});
      }
    });
    _timer!.start();
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
    _timer!.dispose();
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

  void toggleTimer() {
    if (isPaused) {
      _timer?.start();
    } else {
      _timer?.stop();
    }
    setState(() {
      isPaused = !isPaused;
    });
  }

  void resetTimer() {
    final duration = Duration(minutes: reminder);
    _timer?.stop();
    _timer?.kDuration = duration.inSeconds;
    if (isPaused) {
      setState(() {
        isPaused = false;
        inProgress = false;
      });
    }
    _timer?.start();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withAlpha((0.3 * 255).round()),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Eyes Care',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        themeNotifier.value == ThemeMode.light
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                      onPressed: () {
                        themeNotifier.value =
                            themeNotifier.value == ThemeMode.light
                                ? ThemeMode.dark
                                : ThemeMode.light;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Timer Section
                if (_timer != null)
                  Column(
                    children: [
                      RuleTimer(timer: _timer!, inProgress: inProgress),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                              animation: _timer!,
                              builder: (context, _) {
                                return IconButton(
                                  icon: Icon(_timer!.status == TimerStatus.pause
                                      ? Icons.play_arrow
                                      : Icons.pause),
                                  onPressed: () {
                                    if (_timer!.status == TimerStatus.pause) {
                                      _timer!.start();
                                    } else {
                                      _timer!.pause();
                                    }
                                  },
                                );
                              }),
                          IconButton(
                              onPressed: _timer!.restart,
                              icon: const Icon(Icons.restart_alt)),
                        ],
                      )
                    ],
                  ),
                const SizedBox(height: 32),

                // Rule Text Card
                const RuleText(),
                const SizedBox(height: 24),

                // Edit Rule Button
                EditRuleButton(
                  reminder: reminder,
                  breakTime: breakTime,
                  onConfirm: (min, sec) {
                    reminder = min;
                    breakTime = sec;
                    initTimer();
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Force Mode Toggle
                ForceModeCheckBox(forceModeEnabled: forceModeEnabled),

                const Spacer(),

                // Version Info
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      // TODO: get from pubspect dynamiclly
                      'v2.0.0',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse('https://bixat.dev'));
                        },
                        child: Text(
                          'Powered by bixat.dev team',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
