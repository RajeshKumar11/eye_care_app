import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import '../utils/constants.dart';
import '../utils/app_logger.dart';

/// Provider for managing app settings state.
///
/// Handles loading, saving, and validating user settings.
/// All settings changes are validated against min/max bounds
/// before being applied and persisted.
///
/// Example:
/// ```dart
/// final provider = context.read<SettingsProvider>();
/// await provider.setBlinkInterval(20);
/// print(provider.settings.blinkIntervalSeconds); // 20
/// ```
class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final TtsService _ttsService = TtsService();

  EyeCareSettings _settings = const EyeCareSettings();
  bool _isLoading = true;
  String? _lastError;

  /// Current settings configuration.
  EyeCareSettings get settings => _settings;

  /// Whether settings are currently being loaded.
  bool get isLoading => _isLoading;

  /// Last error message, if any.
  String? get lastError => _lastError;

  /// Creates a new settings provider and loads saved settings.
  SettingsProvider() {
    _loadSettings();
  }

  /// Load settings from persistent storage.
  Future<void> _loadSettings() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      _settings = await _storageService.loadSettings();
      _ttsService.setEnabled(_settings.ttsEnabled);
      AppLogger.info('Settings loaded: preset=${_settings.activePreset.name}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load settings', error: e, stackTrace: stackTrace);
      _lastError = 'Failed to load settings';
      _settings = const EyeCareSettings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reload settings from storage.
  ///
  /// Useful after external changes or to retry after an error.
  Future<void> reload() async {
    await _loadSettings();
  }

  /// Update settings with new values.
  ///
  /// Saves to persistent storage and notifies listeners.
  /// Returns `true` if save was successful.
  Future<bool> updateSettings(EyeCareSettings newSettings) async {
    final previousSettings = _settings;
    _settings = newSettings;
    _lastError = null;

    try {
      _ttsService.setEnabled(newSettings.ttsEnabled);
      final success = await _storageService.saveSettings(newSettings);

      if (!success) {
        AppLogger.warning('Settings save returned false, reverting');
        _settings = previousSettings;
        _lastError = 'Failed to save settings';
        notifyListeners();
        return false;
      }

      AppLogger.stateChange('SettingsProvider', 'Settings updated');
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save settings', error: e, stackTrace: stackTrace);
      _settings = previousSettings;
      _lastError = 'Failed to save settings';
      notifyListeners();
      return false;
    }
  }

  /// Apply a preset configuration.
  ///
  /// Replaces current settings with the preset values.
  Future<bool> applyPreset(EyeCarePreset preset) async {
    AppLogger.userAction('Apply preset: ${preset.name}');
    final newSettings = EyeCareSettings.fromPreset(preset);
    return updateSettings(newSettings);
  }

  /// Enable or disable background mode.
  Future<bool> setBackgroundMode(bool enabled) async {
    AppLogger.userAction('Set background mode: $enabled');
    return updateSettings(_settings.copyWith(backgroundModeEnabled: enabled));
  }

  /// Set the blink reminder interval.
  ///
  /// Value is clamped to valid range [minBlinkInterval, maxBlinkInterval].
  /// Setting this also changes the preset to "custom".
  Future<bool> setBlinkInterval(int seconds) async {
    final validSeconds = _validateBlinkInterval(seconds);
    AppLogger.userAction('Set blink interval: $validSeconds seconds');
    return updateSettings(_settings.copyWith(
      blinkIntervalSeconds: validSeconds,
      activePreset: EyeCarePreset.custom,
    ));
  }

  /// Validate and clamp blink interval to valid range.
  int _validateBlinkInterval(int seconds) {
    if (seconds < AppConstants.minBlinkInterval) {
      AppLogger.warning(
        'Blink interval $seconds below min (${AppConstants.minBlinkInterval}), clamping',
      );
      return AppConstants.minBlinkInterval;
    }
    if (seconds > AppConstants.maxBlinkInterval) {
      AppLogger.warning(
        'Blink interval $seconds above max (${AppConstants.maxBlinkInterval}), clamping',
      );
      return AppConstants.maxBlinkInterval;
    }
    return seconds;
  }

  /// Set the blank screen duration.
  ///
  /// Value is clamped to valid range [minBlankDuration, maxBlankDuration].
  /// Setting this also changes the preset to "custom".
  Future<bool> setBlankScreenDuration(int seconds) async {
    final validSeconds = _validateBlankDuration(seconds);
    AppLogger.userAction('Set blank screen duration: $validSeconds seconds');
    return updateSettings(_settings.copyWith(
      blankScreenDurationSeconds: validSeconds,
      activePreset: EyeCarePreset.custom,
    ));
  }

  /// Validate and clamp blank screen duration to valid range.
  int _validateBlankDuration(int seconds) {
    if (seconds < AppConstants.minBlankDuration) {
      AppLogger.warning(
        'Blank duration $seconds below min (${AppConstants.minBlankDuration}), clamping',
      );
      return AppConstants.minBlankDuration;
    }
    if (seconds > AppConstants.maxBlankDuration) {
      AppLogger.warning(
        'Blank duration $seconds above max (${AppConstants.maxBlankDuration}), clamping',
      );
      return AppConstants.maxBlankDuration;
    }
    return seconds;
  }

  /// Set the blank screen interval.
  ///
  /// Value is clamped to valid range [minBlankInterval, maxBlankInterval].
  /// Setting this also changes the preset to "custom".
  Future<bool> setBlankScreenInterval(int minutes) async {
    final validMinutes = _validateBlankInterval(minutes);
    AppLogger.userAction('Set blank screen interval: $validMinutes minutes');
    return updateSettings(_settings.copyWith(
      blankScreenIntervalMinutes: validMinutes,
      activePreset: EyeCarePreset.custom,
    ));
  }

  /// Validate and clamp blank screen interval to valid range.
  int _validateBlankInterval(int minutes) {
    if (minutes < AppConstants.minBlankInterval) {
      AppLogger.warning(
        'Blank interval $minutes below min (${AppConstants.minBlankInterval}), clamping',
      );
      return AppConstants.minBlankInterval;
    }
    if (minutes > AppConstants.maxBlankInterval) {
      AppLogger.warning(
        'Blank interval $minutes above max (${AppConstants.maxBlankInterval}), clamping',
      );
      return AppConstants.maxBlankInterval;
    }
    return minutes;
  }

  /// Enable or disable text-to-speech.
  Future<bool> setTtsEnabled(bool enabled) async {
    AppLogger.userAction('Set TTS enabled: $enabled');
    return updateSettings(_settings.copyWith(ttsEnabled: enabled));
  }

  /// Enable or disable blink reminders.
  ///
  /// Setting this also changes the preset to "custom".
  Future<bool> setBlinkReminderEnabled(bool enabled) async {
    AppLogger.userAction('Set blink reminder enabled: $enabled');
    return updateSettings(_settings.copyWith(
      blinkReminderEnabled: enabled,
      activePreset: EyeCarePreset.custom,
    ));
  }

  /// Enable or disable blank screen mode.
  ///
  /// Setting this also changes the preset to "custom".
  Future<bool> setBlankScreenEnabled(bool enabled) async {
    AppLogger.userAction('Set blank screen enabled: $enabled');
    return updateSettings(_settings.copyWith(
      blankScreenEnabled: enabled,
      activePreset: EyeCarePreset.custom,
    ));
  }

  /// Reset all settings to defaults.
  Future<bool> resetToDefaults() async {
    AppLogger.userAction('Reset settings to defaults');
    return updateSettings(const EyeCareSettings());
  }

  /// Clear any error state.
  void clearError() {
    _lastError = null;
    notifyListeners();
  }
}
