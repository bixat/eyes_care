import 'package:flutter/material.dart';

class SwitcherSetting extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const SwitcherSetting({
    super.key,
    required this.enabled,
    required this.title,
    required this.subtitle,
    required this.onChanged,
    required this.icon,
  });

  final ValueNotifier<bool> enabled;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
        valueListenable: enabled,
        builder: (context, _, __) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: enabled.value
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
            ),
            child: ListTile(
              onTap: () => onChanged(!enabled.value),
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
                    icon,
                    color: enabled.value
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              title: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: enabled.value
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: enabled.value
                      ? theme.colorScheme.onPrimaryContainer
                          .withAlpha((0.8 * 255).round())
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Switch(
                value: enabled.value,
                onChanged: onChanged,
              ),
            ),
          );
        });
  }
}
