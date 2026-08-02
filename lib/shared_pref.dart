import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const forceModeKey = "force_mode";
  static const startupModeKey = "startup_mode";
  static const minutes = "minutes";
  static const seconds = "seconds";
  static const themeModeKey = "theme_mode";
  static const languageKey = "language";
  static const muslimModeEnabledKey = "muslim_mode_enabled";
  static const latitudeKey = "latitude";
  static const longitudeKey = "longitude";
  static const cityKey = "city";
  static const countryKey = "country";

  static Future<void> setThemeMode(String mode) async {
    final prefs = await instance;
    await prefs.setString(themeModeKey, mode);
  }

  static Future<String?> getThemeMode() async {
    final prefs = await instance;
    return prefs.getString(themeModeKey);
  }

  static Future<void> setLanguage(String lang) async {
    final prefs = await instance;
    await prefs.setString(languageKey, lang);
  }

  static Future<String?> getLanguage() async {
    final prefs = await instance;
    return prefs.getString(languageKey);
  }

  static Future<SharedPreferences> get instance async =>
      await SharedPreferences.getInstance();

  static Future<void> setBool(String key, bool value) async {
    final prefs = await instance;
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await instance;
    return prefs.getBool(key);
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await instance;
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await instance;
    return prefs.getString(key);
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await instance;
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await instance;
    return prefs.getDouble(key);
  }

  static Future<void> setDuration(int min, int sec) async {
    final prefs = await instance;
    await prefs.setInt(minutes, min);
    await prefs.setInt(seconds, sec);
  }

  static Future<(int?, int?)> getDuration() async {
    final prefs = await instance;
    final minutes = prefs.getInt('minutes');
    final seconds = prefs.getInt('seconds');
    return (minutes, seconds);
  }
}
