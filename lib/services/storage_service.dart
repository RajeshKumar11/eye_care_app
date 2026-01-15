import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';
import '../utils/constants.dart';

/// Local storage service for persisting settings
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<EyeCareSettings> loadSettings() async {
    if (_prefs == null) {
      await initialize();
    }

    final jsonString = _prefs?.getString(AppConstants.settingsKey);
    if (jsonString == null) {
      return const EyeCareSettings();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return EyeCareSettings.fromJson(json);
    } catch (e) {
      return const EyeCareSettings();
    }
  }

  Future<void> saveSettings(EyeCareSettings settings) async {
    if (_prefs == null) {
      await initialize();
    }

    final jsonString = jsonEncode(settings.toJson());
    await _prefs?.setString(AppConstants.settingsKey, jsonString);
  }

  Future<void> clearSettings() async {
    if (_prefs == null) {
      await initialize();
    }
    await _prefs?.remove(AppConstants.settingsKey);
  }
}
