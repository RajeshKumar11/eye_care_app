import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';

/// Provider for managing app settings state
class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final TtsService _ttsService = TtsService();

  EyeCareSettings _settings = const EyeCareSettings();
  bool _isLoading = true;

  EyeCareSettings get settings => _settings;
  bool get isLoading => _isLoading;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _storageService.loadSettings();
    _ttsService.setEnabled(_settings.ttsEnabled);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings(EyeCareSettings newSettings) async {
    _settings = newSettings;
    _ttsService.setEnabled(newSettings.ttsEnabled);
    await _storageService.saveSettings(newSettings);
    notifyListeners();
  }

  Future<void> applyPreset(EyeCarePreset preset) async {
    final newSettings = EyeCareSettings.fromPreset(preset);
    await updateSettings(newSettings);
  }

  Future<void> setBackgroundMode(bool enabled) async {
    await updateSettings(_settings.copyWith(backgroundModeEnabled: enabled));
  }

  Future<void> setBlinkInterval(int seconds) async {
    await updateSettings(_settings.copyWith(
      blinkIntervalSeconds: seconds,
      activePreset: EyeCarePreset.custom,
    ));
  }

  Future<void> setBlankScreenDuration(int seconds) async {
    await updateSettings(_settings.copyWith(
      blankScreenDurationSeconds: seconds,
      activePreset: EyeCarePreset.custom,
    ));
  }

  Future<void> setBlankScreenInterval(int minutes) async {
    await updateSettings(_settings.copyWith(
      blankScreenIntervalMinutes: minutes,
      activePreset: EyeCarePreset.custom,
    ));
  }

  Future<void> setTtsEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(ttsEnabled: enabled));
  }

  Future<void> setBlinkReminderEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(
      blinkReminderEnabled: enabled,
      activePreset: EyeCarePreset.custom,
    ));
  }

  Future<void> setBlankScreenEnabled(bool enabled) async {
    await updateSettings(_settings.copyWith(
      blankScreenEnabled: enabled,
      activePreset: EyeCarePreset.custom,
    ));
  }

  Future<void> resetToDefaults() async {
    await updateSettings(const EyeCareSettings());
  }
}
