import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const forceModeKey = "force_mode";
  static const minutes = "minutes";
  static const seconds = "seconds";

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
