import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final int value;
  final String title;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Slider(
          value: value.toDouble(),
          min: 10,
          max: 60,
          divisions: 60,
          label: value.toString(),
          onChanged: (double value) {
            onChanged(value);
          },
        ),
      ],
    );
  }
}
