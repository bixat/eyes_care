import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/custom_slider.dart';
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
  void initState() {
    setDuration();
    super.initState();
  }

  Future<void> setDuration() async {
    var (min, sec) = await PreferenceService.getDuration();
    _minutes = min ?? 20;
    _seconds = sec ?? 20;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary
                        .withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Set Break Duration',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomSlider(
              title: "Work Duration",
              value: _minutes,
              onChanged: (double value) {
                setState(() {
                  _minutes = value.round();
                  _seconds = value.round();
                });
              },
            ),
            const SizedBox(height: 16),
            CustomSlider(
              title: "Break Duration",
              value: _seconds,
              onChanged: (double value) {
                setState(() {
                  _seconds = value.round();
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    widget.onConfirm(_minutes, _seconds);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
