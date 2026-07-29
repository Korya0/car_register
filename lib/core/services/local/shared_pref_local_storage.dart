import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  factory SharedPref() {
    return preferences;
  }

  SharedPref._internal();
  static final SharedPref preferences = SharedPref._internal();

  static late SharedPreferences sharedPreferences;

  Future<dynamic> instantiatePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  Future<dynamic> setString(String key, String stringValue) async {
    await sharedPreferences.setString(key, stringValue);
  }
}
