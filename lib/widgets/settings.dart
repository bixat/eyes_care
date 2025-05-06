import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/edit_rule_button.dart';
import 'package:eyes_care/widgets/force_mode_check_box.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:window_manager/window_manager.dart';

class Settings extends StatelessWidget {
  final int reminder;
  final int breakTime;
  final ValueNotifier<bool> forceModeEnabled;
  final ValueNotifier<bool> startUpModeEnabled;
  final Function(int, int) onConfirm;

  const Settings({
    Key? key,
    required this.reminder,
    required this.breakTime,
    required this.forceModeEnabled,
    required this.onConfirm,
    required this.startUpModeEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          EditRuleButton(
            reminder: reminder,
            breakTime: breakTime,
            onConfirm: onConfirm,
          ),
          SwitcherSetting(
            enabled: forceModeEnabled,
            icon: Icons.lock_rounded,
            title: "Force Mode",
            subtitle: "Prevent window minimization during breaks",
            onChanged: _onUpdateForceMode,
          ),
          SwitcherSetting(
            enabled: startUpModeEnabled,
            icon: Icons.start,
            title: "Startup at Login",
            subtitle: "Launch application automatically at system startup",
            onChanged: _onUpdateStartupMode,
          ),
        ],
      ),
    );
  }

  void _onUpdateForceMode(bool? value) {
    if (value == null) return;
    PreferenceService.setBool(PreferenceService.forceModeKey, value);
    forceModeEnabled.value = value;
    windowManager.setFullScreen(false);
  }

  void _onUpdateStartupMode(bool? value) {
    if (value == null) return;
    startUpModeEnabled.value = value;
    PreferenceService.setBool(PreferenceService.startupModeKey, value);
    if (value) {
      launchAtStartup.disable();
    } else {
      launchAtStartup.disable();
    }
  }
}
