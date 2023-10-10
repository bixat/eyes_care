import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rocket_timer/rocket_timer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const Size size = Size(300, 300);
  DesktopWindow.setMinWindowSize(size);
  DesktopWindow.setWindowSize(size);
  DesktopWindow.setMaxWindowSize(size);
  runApp(const CareYourEyes());
}

class CareYourEyes extends StatelessWidget {
  const CareYourEyes({super.key});
  // TODO : name from 20 min 20 sec 20 m
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareYourEyes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CountdownScreen(),
    );
  }
}

const int rule = 20;
const duration = Duration(minutes: rule);

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late RocketTimer _timer;
  bool inProgress = false;
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    initTimer();
  }

  void initTimer() {
    _timer = RocketTimer(type: TimerType.countdown, duration: duration);
    _timer.addListener(() {
      if (_timer.kDuration == 0) {
        showNotification('Yaay Care your eyes');
        _timer.kDuration = inProgress ? duration.inSeconds : rule;
        inProgress = !inProgress;
      }
    });
    _timer.start();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
        macOS: initializationSettingsIOS,
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'care_your_eyes',
      'Keep your eyes',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        macOS: iOSPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Keep your eyes',
      body,
      platformChannelSpecifics,
      payload: 'care_your_eyes',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareYourEyes'),
        leading: AnimatedBuilder(
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
      ),
      body: Center(
          child: RocketTimerBuilder(
        timer: _timer,
        builder: (BuildContext context) {
          List splited = _timer.formattedDuration.split(":");
          splited.removeAt(0);
          return Stack(
            children: [
              Center(
                child: Text(
                  splited.join(':'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    color: inProgress ? Colors.orange : Colors.blue,
                    backgroundColor: Colors.grey[300],
                    strokeWidth: 10,
                    value: _timer.kDuration / _timer.duration.inSeconds,
                  ),
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
