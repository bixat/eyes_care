import 'package:eyes_care/widgets/custom_minutes_slider.dart';
import 'package:flutter/material.dart';

class DurationPickerDialog extends StatefulWidget {
  final Function(int minutes, int seconds) onConfirm;

  const DurationPickerDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  DurationPickerDialogState createState() => DurationPickerDialogState();
}

class DurationPickerDialogState extends State<DurationPickerDialog> {
  int _minutes = 20;
  int _seconds = 10;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Break Duration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSlider(
            title: "Reminder in Minutes",
            value: _minutes,
            onChanged: (double value) {
              setState(() {
                _minutes = value.round();
                _seconds = value.round();
              });
            },
          ),
          CustomSlider(
            title: "Break in Seconds",
            value: _seconds,
            onChanged: (double value) {
              setState(() {
                _seconds = value.round();
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            widget.onConfirm(
                _minutes, _seconds); // Call the callback with selected values
          },
        ),
      ],
    );
  }
}
