// shared_pref.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  // Singleton instance
  static final SharedPref _instance = SharedPref._internal();
  factory SharedPref() => _instance;
  SharedPref._internal();

  static late SharedPreferences _prefs;

  // Initialize method
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save methods
  static Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
  static Future<bool> setBool(String key, bool value) =>
      _prefs.setBool(key, value);
  static Future<bool> setInt(String key, int value) =>
      _prefs.setInt(key, value);
  static Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  // Get methods
  static String? getString(String key) => _prefs.getString(key);
  static bool? getBool(String key) => _prefs.getBool(key);
  static int? getInt(String key) => _prefs.getInt(key);
  static double? getDouble(String key) => _prefs.getDouble(key);

  // Utility methods
  static Future<bool> remove(String key) => _prefs.remove(key);
  static Future<bool> clear() => _prefs.clear();
  static bool contains(String key) => _prefs.containsKey(key);
}
