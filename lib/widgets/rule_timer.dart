import 'package:flutter/material.dart';
import 'package:rocket_timer/rocket_timer.dart';

class RuleTimer extends StatelessWidget {
  const RuleTimer({
    super.key,
    required RocketTimer timer,
    required this.inProgress,
  }) : _timer = timer;

  final RocketTimer _timer;
  final bool inProgress;

  final circleSize = 100.0;
  @override
  Widget build(BuildContext context) {
    final stroke = inProgress ? 20.0 : 10.0;
    return Expanded(
      child: RocketTimerBuilder(
        timer: _timer,
        builder: (BuildContext context) {
          List splited = _timer.formattedDuration.split(":");
          splited.removeAt(0);
          return Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  splited.join(':'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Center(
                child: SizedBox(
                  height: circleSize,
                  width: circleSize,
                  child: CircularProgressIndicator(
                    color: inProgress ? Colors.orange : Colors.blue,
                    backgroundColor: Colors.grey[300],
                    strokeWidth: stroke,
                    value: _timer.kDuration / _timer.duration.inSeconds,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
