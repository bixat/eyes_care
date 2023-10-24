import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';
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
  CountdownScreenState createState() => CountdownScreenState();
}

class CountdownScreenState extends State<CountdownScreen> {
  late RocketTimer _timer;
  bool inProgress = false;
  @override
  void initState() {
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
      }
    });
    _timer.start();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  Future<void> showNotification() async {
    // Add in main method.
    await localNotifier.setup(
      appName: 'CareYourEyes',
      // The parameter shortcutPolicy only works on Windows
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );

    LocalNotification notification = LocalNotification(
      title: "Care your eyes",
      body: "rules 20 for care your eyes",
    );
    notification.onShow = () {
      print('onShow ${notification.identifier}');
    };
    notification.onClose = (closeReason) {
      // Only supported on windows, other platforms closeReason is always unknown.
      switch (closeReason) {
        case LocalNotificationCloseReason.userCanceled:
          // do something
          break;
        case LocalNotificationCloseReason.timedOut:
          // do something
          break;
        default:
      }
      print('onClose ${notification.identifier} - $closeReason');
    };
    notification.onClick = () {
      print('onClick ${notification.identifier}');
    };
    notification.onClickAction = (actionIndex) {
      print('onClickAction ${notification.identifier} - $actionIndex');
    };

    notification.show();
  }

  @override
  Widget build(BuildContext context) {
    showNotification();
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
