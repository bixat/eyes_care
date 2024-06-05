import 'package:flutter/material.dart';

class RuleText extends StatelessWidget {
  const RuleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "Give your eyes a rest by following the 20-20-20 rule. Every 20 minutes, look away from your screen and focus on something 20 feet away for 20 seconds. This helps reduce eye strain caused by prolonged screen use.",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}
