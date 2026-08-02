import 'package:eyes_care/l10n/app_localizations.dart';
import 'package:eyes_care/main.dart';
import 'package:eyes_care/widgets/settings.dart';
import 'package:eyes_care/widgets/work_break_info.dart';
import 'package:eyes_care/services/prayer_service.dart';
import 'package:eyes_care/widgets/prayer_table.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rocket_timer/rocket_timer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/rule_text.dart';
import 'package:eyes_care/widgets/rule_timer.dart';
import 'package:local_notifier/local_notifier.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  CountdownScreenState createState() => CountdownScreenState();
}

const size = Size(500, 750);

class CountdownScreenState extends State<CountdownScreen> with WindowListener {
  RocketTimer? _timer;
  bool inBreak = false;
  bool isPaused = false;
  late ValueNotifier<bool> forceModeEnabled = ValueNotifier(false);
  late ValueNotifier<bool> startUpModeEnabled = ValueNotifier(false);
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
  Duration get workDuration => Duration(minutes: reminder);
  Duration get breakDuration => Duration(seconds: breakTime);

  final appVersion = ValueNotifier<String?>(null);

  @override
  void initState() {
    setUpSettings();
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
    
    PrayerService().onAdhanStateChanged = (isPlaying) async {
      if (forceModeEnabled.value) {
        await handleWindowState();
      }
    };
    
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
    _timer = RocketTimer(type: TimerType.countdown, duration: workDuration);
    _timer!.addListener(() {
      if (_timer!.kDuration == 0) {
        showNotification();
        _timer!.kDuration =
            inBreak ? workDuration.inSeconds : breakDuration.inSeconds;
        inBreak = !inBreak;
        setState(() {});
      }
    });
    _timer!.start();
  }

  setUpSettings() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    PreferenceService.getBool(PreferenceService.forceModeKey).then((value) {
      forceModeEnabled.value = value ?? false;
    });
    PreferenceService.getBool(PreferenceService.startupModeKey).then((value) {
      startUpModeEnabled.value = value ?? false;
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
    if (inBreak || PrayerService().isAdhanPlaying) {
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
    final loc = AppLocalizations.of(context);
    LocalNotification notification = LocalNotification(
      title: inBreak ? loc.stayFocused : loc.takeAMoment,
      body:
          inBreak ? loc.breakNotification : loc.workNotification,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

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
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Bar
                Row(
                  children: [
                    Text(
                      loc.appTitle,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _showSettings(context);
                      },
                      icon: const Icon(Icons.settings),
                    ),
                    IconButton(
                      icon: Icon(
                        themeNotifier.value == ThemeMode.light
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                      onPressed: () async {
                        if (themeNotifier.value == ThemeMode.light) {
                          themeNotifier.value = ThemeMode.dark;
                          await PreferenceService.setThemeMode('dark');
                        } else {
                          themeNotifier.value = ThemeMode.light;
                          await PreferenceService.setThemeMode('light');
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tabs
                ListenableBuilder(
                  listenable: PrayerService(),
                  builder: (context, _) {
                    final prayerService = PrayerService();
                    final isMuslimMode = prayerService.isMuslimModeEnabled;
                    
                    return Expanded(
                      child: Column(
                        children: [
                          if (prayerService.isAdhanPlaying)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.volume_up, color: theme.colorScheme.onPrimaryContainer),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      loc.adhanIsPlaying, 
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => prayerService.stopAdhan(),
                                    style: TextButton.styleFrom(
                                      foregroundColor: theme.colorScheme.onErrorContainer,
                                      backgroundColor: theme.colorScheme.errorContainer,
                                    ),
                                    child: Text(loc.stopAdhan),
                                  ),
                                ],
                              ),
                            ),
                          if (!isMuslimMode)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 24),
                                    if (_timer != null)
                                      Column(
                                        children: [
                                          RuleTimer(timer: _timer!, inBreak: inBreak),
                                          WorkBreakInfo(reminder: reminder, breakTime: breakTime),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              AnimatedBuilder(
                                                animation: _timer!,
                                                builder: (context, _) {
                                                  return IconButton(
                                                    icon: Icon(
                                                      _timer!.status == TimerStatus.pause
                                                          ? Icons.play_arrow
                                                          : Icons.pause,
                                                    ),
                                                    onPressed: () {
                                                      if (_timer!.status == TimerStatus.pause) {
                                                        _timer!.start();
                                                      } else {
                                                        _timer!.pause();
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                onPressed: _restartTimer,
                                                icon: const Icon(Icons.restart_alt),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 32),
                                    const RuleText(),
                                  ],
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    TabBar(
                                      tabs: [
                                        Tab(icon: const Icon(Icons.timer), text: loc.eyeCare),
                                        Tab(icon: const Icon(Icons.mosque), text: loc.muslimMode),
                                      ],
                                      labelColor: theme.colorScheme.primary,
                                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          // Tab 1: Eye Care
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 16),
                                                if (_timer != null)
                                                  Column(
                                                    children: [
                                                      RuleTimer(timer: _timer!, inBreak: inBreak),
                                                      WorkBreakInfo(reminder: reminder, breakTime: breakTime),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          AnimatedBuilder(
                                                            animation: _timer!,
                                                            builder: (context, _) {
                                                              return IconButton(
                                                                icon: Icon(
                                                                  _timer!.status == TimerStatus.pause
                                                                      ? Icons.play_arrow
                                                                      : Icons.pause,
                                                                ),
                                                                onPressed: () {
                                                                  if (_timer!.status == TimerStatus.pause) {
                                                                    _timer!.start();
                                                                  } else {
                                                                    _timer!.pause();
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          IconButton(
                                                            onPressed: _restartTimer,
                                                            icon: const Icon(Icons.restart_alt),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                const SizedBox(height: 16),
                                                const RuleText(),
                                                const SizedBox(height: 16),
                                              ],
                                            ),
                                          ),
                                          // Tab 2: Prayer Table
                                          const PrayerTable(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                ),

                // Version Info
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: appVersion,
                      builder: (context, value, _) {
                        return Text(
                          'v$value',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse('https://bixat.dev'));
                        },
                        child: Text(
                          loc.poweredBy,
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

  Future<dynamic> _showSettings(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Settings(
          reminder: reminder,
          breakTime: breakTime,
          forceModeEnabled: forceModeEnabled,
          startUpModeEnabled: startUpModeEnabled,
          onConfirm: (min, sec) {
            setState(() {
              reminder = min;
              breakTime = sec;
              _restartTimer();
            });
            PreferenceService.setDuration(min, sec);
            PreferenceService.setBool(
              PreferenceService.forceModeKey,
              forceModeEnabled.value,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _restartTimer() {
    _timer!.restart();
    inBreak = false;
    _timer!.kDuration = workDuration.inSeconds;
    setState(() {});
  }
}
