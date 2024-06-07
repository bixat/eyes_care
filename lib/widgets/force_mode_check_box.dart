import 'package:eyes_care/shared_pref.dart';
import 'package:flutter/material.dart';

class ForceModeCheckBox extends StatelessWidget {
  const ForceModeCheckBox({
    super.key,
    required this.forceModeEnabled,
  });

  final ValueNotifier<bool> forceModeEnabled;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: forceModeEnabled,
        builder: (context, _, __) {
          return ListTile(
            onTap: () {
              onChanged(!forceModeEnabled.value);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            title: Row(
              children: [
                Checkbox(
                  value: forceModeEnabled.value,
                  onChanged: onChanged,
                  fillColor: const MaterialStatePropertyAll(Colors.blue),
                ),
                const Text("Force Mode"),
              ],
            ),
          );
        });
  }

  void onChanged(value) {
    PreferenceService.setBool(PreferenceService.forceModeKey, value!);
    forceModeEnabled.value = value;
  }
}
