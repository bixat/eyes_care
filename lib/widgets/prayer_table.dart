import 'package:flutter/material.dart';
import 'package:eyes_care/services/prayer_service.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import 'package:eyes_care/l10n/app_localizations.dart';

class PrayerTable extends StatelessWidget {
  const PrayerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PrayerService(),
      builder: (context, _) {
        final prayerService = PrayerService();
        final prayerTimes = prayerService.prayerTimes;
        final nextPrayer = prayerService.nextPrayer;
        final theme = Theme.of(context);

        final loc = AppLocalizations.of(context);
        if (prayerTimes == null) {
          return Center(
            child: Text(
              loc.tapToDetect,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        final localeCode = Localizations.localeOf(context).languageCode;
        final formatter = DateFormat.jm(localeCode);
        
        final displayNextPrayer = nextPrayer == Prayer.none ? Prayer.fajr : nextPrayer;
        
        final prayers = [
          {'name': loc.fajr, 'time': prayerTimes.fajr, 'enum': Prayer.fajr},
          {'name': loc.sunrise, 'time': prayerTimes.sunrise, 'enum': Prayer.sunrise},
          {'name': loc.dhuhr, 'time': prayerTimes.dhuhr, 'enum': Prayer.dhuhr},
          {'name': loc.asr, 'time': prayerTimes.asr, 'enum': Prayer.asr},
          {'name': loc.maghrib, 'time': prayerTimes.maghrib, 'enum': Prayer.maghrib},
          {'name': loc.isha, 'time': prayerTimes.isha, 'enum': Prayer.isha},
        ];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                loc.prayerTimes,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (prayerService.city != null)
              Text(
                '${prayerService.city}, ${prayerService.country}',
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  final prayer = prayers[index];
                  final isNext = prayer['enum'] == displayNextPrayer;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isNext
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isNext
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        prayer['name'] as String,
                        style: TextStyle(
                          fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          color: isNext
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: isNext 
                          ? NextPrayerCountdown(
                              nextPrayerTime: prayerService.nextPrayerTime ?? (prayer['time'] as DateTime),
                              nextPrayerText: loc.nextPrayer,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              )) 
                          : null,
                      trailing: Text(
                        _toEnglishDigits(formatter.format(prayer['time'] as DateTime)),
                        style: TextStyle(
                          fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                          color: isNext
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      leading: Icon(
                        isNext ? Icons.access_time_filled : Icons.access_time,
                        color: isNext
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _toEnglishDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
  }
}

class NextPrayerCountdown extends StatefulWidget {
  final DateTime nextPrayerTime;
  final String nextPrayerText;
  final TextStyle style;

  const NextPrayerCountdown({
    super.key,
    required this.nextPrayerTime,
    required this.nextPrayerText,
    required this.style,
  });

  @override
  State<NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<NextPrayerCountdown> {
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  String _formatDuration(Duration duration) {
    final isNegative = duration.isNegative;
    final absDuration = duration.abs();
    
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(absDuration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(absDuration.inSeconds.remainder(60));
    String formattedTime = "${twoDigits(absDuration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    
    // Remaining time gets a minus sign (counting down), passed time gets a plus sign (counting up).
    return isNegative ? "+$formattedTime" : "-$formattedTime";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (context, snapshot) {
        final remaining = widget.nextPrayerTime.difference(DateTime.now());
        final formatted = _formatDuration(remaining);
        return Text(
          '${widget.nextPrayerText} $formatted',
          style: widget.style,
        );
      },
    );
  }
}
