import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/duration_picker_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditRuleButton extends StatefulWidget {
  const EditRuleButton({
    super.key,
    required this.onConfirm,
    required this.reminder,
    required this.breakTime,
  });
  final dynamic Function(int, int) onConfirm;
  final int reminder, breakTime;

  @override
  State<EditRuleButton> createState() => _EditRuleButtonState();
}

class _EditRuleButtonState extends State<EditRuleButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(Colors.blue.withOpacity(0.2)),
          ),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return DurationPickerDialog(
                  onConfirm: (int min, int sec) {
                    PreferenceService.setDuration(min, sec);
                    widget.onConfirm(min, sec);
                  },
                );
              },
            );
          },
          child: const Text("Edit Rule"),
        ),
        Text("${widget.reminder}m - ${widget.breakTime}s")
      ],
    );
  }
}
