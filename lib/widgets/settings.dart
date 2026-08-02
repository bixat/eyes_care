import 'package:eyes_care/l10n/app_localizations.dart';
import 'package:eyes_care/main.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/widgets/edit_rule_button.dart';
import 'package:eyes_care/widgets/force_mode_check_box.dart';
import 'package:eyes_care/services/prayer_service.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  final int reminder;
  final int breakTime;
  final ValueNotifier<bool> forceModeEnabled;
  final ValueNotifier<bool> startUpModeEnabled;
  final Function(int, int) onConfirm;

  const Settings({
    super.key,
    required this.reminder,
    required this.breakTime,
    required this.forceModeEnabled,
    required this.onConfirm,
    required this.startUpModeEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
      {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
      {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
      {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            // Language Selector
            _buildLanguageCard(context, loc, theme, languages),
            EditRuleButton(
              reminder: reminder,
              breakTime: breakTime,
              onConfirm: onConfirm,
            ),
            SwitcherSetting(
              enabled: forceModeEnabled,
              icon: Icons.lock_rounded,
              title: loc.forceMode,
              subtitle: loc.forceModeSubtitle,
              onChanged: _onUpdateForceMode,
            ),
            SwitcherSetting(
              enabled: startUpModeEnabled,
              icon: Icons.start,
              title: loc.startupAtLogin,
              subtitle: loc.startupAtLoginSubtitle,
              onChanged: _onUpdateStartupMode,
            ),
            ListenableBuilder(
              listenable: PrayerService(),
              builder: (context, _) {
                final prayerService = PrayerService();
                return Column(
                  spacing: 16.0,
                  children: [
                    SwitcherSetting(
                      enabled: ValueNotifier(prayerService.isMuslimModeEnabled),
                      icon: Icons.mosque,
                      title: loc.muslimMode,
                      subtitle: loc.muslimModeSubtitle,
                      onChanged: (val) {
                        if (val != null) prayerService.toggleMuslimMode(val);
                      },
                    ),
                    if (prayerService.isMuslimModeEnabled)
                      _buildLocationCard(context, theme, prayerService),
                  ],
                );
              },
            ),
            _buildDiscoverIslamCard(context, theme),
        ],
        ),
      ),
    );
  }

  Widget _buildDiscoverIslamCard(BuildContext context, ThemeData theme) {
    final loc = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: InkWell(
        onTap: () async {
          final supportedLanguages = {'en', 'es', 'fr', 'de', 'zh', 'ja', 'ru', 'pt', 'hi', 'tr'};
          final currentLang = localeNotifier.value.languageCode;
          final lang = supportedLanguages.contains(currentLang) ? currentLang : 'en';
          
          final url = Uri.parse('https://guidetoislam.com/$lang');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.tertiaryContainer,
                      theme.colorScheme.tertiaryContainer.withAlpha(180),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: theme.colorScheme.tertiary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.discoverIslam,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.discoverIslamSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.open_in_new_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    BuildContext context,
    ThemeData theme,
    PrayerService prayerService,
  ) {
    final loc = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: InkWell(
        onTap: () => prayerService.detectLocation(context: context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondaryContainer,
                      theme.colorScheme.secondaryContainer.withAlpha(180),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: theme.colorScheme.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.location,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prayerService.city != null
                          ? '${prayerService.city}, ${prayerService.country}'
                          : loc.tapToDetect,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  loc.detect,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    AppLocalizations loc,
    ThemeData theme,
    List<Map<String, String>> languages,
  ) {
    final currentLang = languages.firstWhere(
      (lang) => lang['code'] == localeNotifier.value.languageCode,
      orElse: () => languages.first,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: InkWell(
        onTap: () => _showLanguageDialog(context, theme, languages),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.primaryContainer.withAlpha(180),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.language,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          currentLang['flag']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentLang['name']!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    ThemeData theme,
    List<Map<String, String>> languages,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  AppLocalizations.of(context).language,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4,
                  ),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected =
                        lang['code'] == localeNotifier.value.languageCode;

                    return _buildLanguageItem(context, theme, lang, isSelected);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    ThemeData theme,
    Map<String, String> lang,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        localeNotifier.value = Locale(lang['code']!);
        PreferenceService.setLanguage(lang['code']!);
        Navigator.pop(context);
      },

      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                lang['name']!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 18,
              ),
            ],
          ],
        ),
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
      launchAtStartup.enable();
    } else {
      launchAtStartup.disable();
    }
  }
}
