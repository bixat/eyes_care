import 'dart:async';
import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:eyes_care/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:eyes_care/main.dart';

class PrayerService extends ChangeNotifier {
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  PrayerTimes? prayerTimes;
  Prayer? nextPrayer;
  DateTime? nextPrayerTime;
  
  bool isMuslimModeEnabled = false;
  String? city;
  String? country;
  double? latitude;
  double? longitude;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  // Callback to trigger UI actions like blocking the screen
  Function(bool isPlaying)? onAdhanStateChanged;

  Future<void> init() async {
    isMuslimModeEnabled = await PreferenceService.getBool(PreferenceService.muslimModeEnabledKey) ?? false;
    city = await PreferenceService.getString(PreferenceService.cityKey);
    country = await PreferenceService.getString(PreferenceService.countryKey);
    latitude = await PreferenceService.getDouble(PreferenceService.latitudeKey);
    longitude = await PreferenceService.getDouble(PreferenceService.longitudeKey);

    if (isMuslimModeEnabled && latitude != null && longitude != null) {
      _calculatePrayerTimes();
    }
  }

  Future<void> toggleMuslimMode(bool value) async {
    isMuslimModeEnabled = value;
    await PreferenceService.setBool(PreferenceService.muslimModeEnabledKey, value);
    if (value && latitude != null && longitude != null) {
      _calculatePrayerTimes();
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  Future<bool> detectLocation({BuildContext? context}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        if (context != null) {
          final loc = AppLocalizations.of(context)!;
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(loc.locationDisabled),
              content: Text(loc.enableLocationPrompt),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(loc.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Geolocator.openLocationSettings();
                  },
                  child: Text(loc.openSettings),
                ),
              ],
            ),
          );
        }
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return false;
      }

      Position position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;

      // Reverse geocode using Nominatim API to get readable city/country.
      final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=10&addressdetails=1';
      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'Taline-App/1.0'}
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'];
        if (address != null) {
          city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? 'Unknown';
          country = address['country'] ?? 'Unknown';
        }
      } else {
        city = "Unknown";
        country = "Unknown";
      }

      if (city != null) {
        await PreferenceService.setString(PreferenceService.cityKey, city!);
      }
      if (country != null) {
        await PreferenceService.setString(PreferenceService.countryKey, country!);
      }
      await PreferenceService.setDouble(PreferenceService.latitudeKey, latitude!);
      await PreferenceService.setDouble(PreferenceService.longitudeKey, longitude!);
      
      if (isMuslimModeEnabled) {
        _calculatePrayerTimes();
      }
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error fetching location: $e");
      return false;
    }
  }

  void _calculatePrayerTimes() {
    if (latitude == null || longitude == null) return;
    
    final coordinates = Coordinates(latitude!, longitude!);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final date = DateComponents.from(DateTime.now());
    
    prayerTimes = PrayerTimes(coordinates, date, params);
    _scheduleNextPrayer();
    notifyListeners();
  }

  void _scheduleNextPrayer() {
    _timer?.cancel();
    if (prayerTimes == null) return;
    
    final now = DateTime.now();
    nextPrayer = prayerTimes!.nextPrayer();
    
    if (nextPrayer == Prayer.none) {
      // All prayers for today are done, schedule for tomorrow's Fajr by recalculating at midnight
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final diff = tomorrow.difference(now);
      _timer = Timer(diff, _calculatePrayerTimes);
      nextPrayerTime = null;
      return;
    }
    
    nextPrayerTime = prayerTimes!.timeForPrayer(nextPrayer!);
    if (nextPrayerTime != null) {
      final durationUntilNext = nextPrayerTime!.difference(now);
      if (durationUntilNext.isNegative) {
         _calculatePrayerTimes();
         return;
      }
      _timer = Timer(durationUntilNext, _onPrayerTime);
    }
    notifyListeners();
  }

  bool isAdhanPlaying = false;
  LocalNotification? _adhanNotification;

  void _onPrayerTime() async {
    isAdhanPlaying = true;
    notifyListeners();

    // Play Adhan
    await _audioPlayer.play(AssetSource('audio/adhan.mp3'));
    
    // Listen for audio completion to reset state
    _audioPlayer.onPlayerComplete.listen((_) {
      stopAdhan();
    });
    
    // Show native notification
    final loc = lookupAppLocalizations(localeNotifier.value);
    _adhanNotification = LocalNotification(
      title: 'Taline',
      body: loc.timeForPrayer,
      actions: [
        LocalNotificationAction(
          text: loc.stopAdhan,
        ),
      ],
    );
    
    _adhanNotification?.onClickAction = (actionIndex) {
      if (actionIndex == 0) {
        stopAdhan();
      }
    };
    
    _adhanNotification?.onShow = () {
      if (onAdhanStateChanged != null) {
        onAdhanStateChanged!(true);
      }
    };
    
    _adhanNotification?.show();
    
    // Schedule the next prayer
    _scheduleNextPrayer();
  }
  
  void stopAdhan() {
    _audioPlayer.stop();
    isAdhanPlaying = false;
    _adhanNotification?.close();
    _adhanNotification = null;
    if (onAdhanStateChanged != null) {
      onAdhanStateChanged!(false);
    }
    notifyListeners();
  }
}
