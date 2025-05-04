import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/duration_picker_dialog.dart';
import 'package:eyes_care/widgets/work_break_info.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color:
          theme.colorScheme.secondaryContainer.withAlpha((0.3 * 255).round()),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              WorkBreakInfo(
                reminder: widget.reminder,
                breakTime: widget.breakTime,
              ),
              const Spacer(),
              Icon(
                Icons.edit_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
