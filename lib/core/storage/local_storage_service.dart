import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('LocalStorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  // Biometric
  static bool get isBiometricEnabled => prefs.getBool(AppConstants.keyBiometricEnabled) ?? false;
  static Future<bool> setBiometricEnabled(bool value) => prefs.setBool(AppConstants.keyBiometricEnabled, value);

  // Theme
  static String get themeMode => prefs.getString(AppConstants.keyThemeMode) ?? 'dark';
  static Future<bool> setThemeMode(String mode) => prefs.setString(AppConstants.keyThemeMode, mode);

  // Generic JSON caching
  static Future<bool> saveJson(String key, dynamic data) async {
    return prefs.setString(key, jsonEncode(data));
  }

  static dynamic getJson(String key) {
    final str = prefs.getString(key);
    if (str == null) return null;
    try {
      return jsonDecode(str);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> remove(String key) => prefs.remove(key);
  static Future<bool> clear() => prefs.clear();
}
