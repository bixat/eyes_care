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

  final circleSize = 200.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stroke = inProgress ? 25.0 : 15.0;

    return SizedBox(
      height: circleSize + 40,
      child: RocketTimerBuilder(
        timer: _timer,
        builder: (BuildContext context) {
          List splited = _timer.formattedDuration.split(":");
          splited.removeAt(0);
          final timeString = splited.join(':');

          return Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: circleSize + 20,
                width: circleSize + 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (inProgress
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primary)
                          .withAlpha((0.2 * 255).round()),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
              // Timer text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeString,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: inProgress
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.primary,
                    ),
                  ),
                  if (inProgress)
                    Text(
                      'Break Time',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                ],
              ),
              // Progress indicator
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: _timer.kDuration / _timer.duration.inSeconds,
                ),
                builder: (context, value, _) => SizedBox(
                  height: circleSize,
                  width: circleSize,
                  child: CircularProgressIndicator(
                    color: inProgress
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    strokeWidth: stroke,
                    value: value,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
