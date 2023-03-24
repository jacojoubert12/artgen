import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<String?> getStrData(String key) async {
  if (kIsWeb) {
    final Storage _localStorage = window.localStorage;
    String? value = _localStorage[key];
    return value;
  } else {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

Future<void> storeStrData(String key, String? value) async {
  if (kIsWeb) {
    final Storage _localStorage = window.localStorage;
    _localStorage[key] = value!;
  } else {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value!);
  }
}

Future<int?> getIntData(String key) async {
  if (kIsWeb) {
    print("Nulll yet?");
    final Storage _localStorage = window.localStorage;
    String? strValue = _localStorage[key];
    if (strValue == null) {
      return 0;
    }
    int? value;
    try {
      value = int.tryParse(strValue);
    } catch (_) {
      value = 0;
    }
    print("getIntData");
    print(value);
    return value;
  } else {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }
}

Future<void> storeIntData(String key, int? value) async {
  if (kIsWeb) {
    print("storeIntData");
    print(value);
    final Storage _localStorage = window.localStorage;
    _localStorage[key] = value.toString();
  } else {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value!);
  }
}
