import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getStrData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> storeStrData(String key, String? value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value!);
}

Future<int?> getIntData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key) ?? 0;
}

Future<void> storeIntData(String key, int? value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value!);
}
