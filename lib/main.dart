import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rocket_timer/rocket_timer.dart';

void main() {
  runApp(const KeepYourEyes());
}

class KeepYourEyes extends StatelessWidget {
  const KeepYourEyes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CountdownScreen(),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late RocketTimer _timer;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    initTimer();
  }

  void initTimer() {
    _timer = RocketTimer(
        type: TimerType.countdown, duration: const Duration(seconds: 20));
    _timer.addListener(() {
      if (_timer.seconds == 0 && _timer.minutes == 0) {
        showNotification('countdown finisghed');
        _timer.restart();
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
      'countdown_app_channel',
      'Countdown App Channel',
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
      'Countdown Notification',
      body,
      platformChannelSpecifics,
      payload: 'countdown_app_notification',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown App'),
      ),
      body: Center(
          child: RocketTimerBuilder(
        timer: _timer,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Center(child: Text(_timer.formattedDuration)),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    strokeWidth: 10,
                    value: _timer.kDuration / 20,
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
