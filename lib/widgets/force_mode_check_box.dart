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
          return CheckboxListTile(
            title: const Text("Force Mode"),
            value: forceModeEnabled.value,
            onChanged: (value) {
              PreferenceService.setBool(
                  PreferenceService.forceModeKey, value!);
              forceModeEnabled.value = value;
            },
          );
        });
  }
}
