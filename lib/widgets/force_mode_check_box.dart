import 'package:eyes_care/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ForceModeCheckBox extends StatelessWidget {
  const ForceModeCheckBox({
    super.key,
    required this.forceModeEnabled,
  });

  final ValueNotifier<bool> forceModeEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
        valueListenable: forceModeEnabled,
        builder: (context, _, __) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: forceModeEnabled.value
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
            ),
            child: ListTile(
              onTap: () => onChanged(!forceModeEnabled.value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.surface,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.lock_rounded,
                    color: forceModeEnabled.value
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              title: Text(
                "Force Mode",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: forceModeEnabled.value
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Prevent window minimization during breaks",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: forceModeEnabled.value
                      ? theme.colorScheme.onPrimaryContainer.withAlpha((0.8 * 255).round())
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Switch(
                value: forceModeEnabled.value,
                onChanged: onChanged,
              ),
            ),
          );
        });
  }

  void onChanged(bool? value) {
    if (value == null) return;
    PreferenceService.setBool(PreferenceService.forceModeKey, value);
    forceModeEnabled.value = value;
    windowManager.setFullScreen(false);
  }
}
