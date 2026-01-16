import 'dart:convert';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';
import '../utils/constants.dart';
import '../utils/app_logger.dart';

/// Local storage service for persisting settings.
///
/// Provides methods to save, load, and clear [EyeCareSettings]
/// using SharedPreferences for persistent local storage.
///
/// This service uses the singleton pattern to ensure consistent
/// access to storage throughout the app.
///
/// Example:
/// ```dart
/// final storage = StorageService();
/// await storage.initialize();
/// final settings = await storage.loadSettings();
/// ```
class StorageService {
  static final StorageService _instance = StorageService._internal();

  /// Factory constructor returns the singleton instance.
  factory StorageService() => _instance;

  StorageService._internal();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  /// Whether the storage service has been initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize the storage service.
  ///
  /// Must be called before using [loadSettings] or [saveSettings].
  /// Safe to call multiple times - subsequent calls are no-ops.
  ///
  /// Throws [StorageException] if SharedPreferences cannot be initialized.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      AppLogger.serviceInit('StorageService');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize SharedPreferences',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Ensure the service is initialized before use.
  Future<void> _ensureInitialized() async {
    if (!_isInitialized || _prefs == null) {
      await initialize();
    }
  }

  /// Load settings from persistent storage.
  ///
  /// Returns saved [EyeCareSettings] if available, or default settings
  /// if no settings have been saved or if loading fails.
  ///
  /// This method handles corrupted data gracefully by returning
  /// default settings and logging the error.
  ///
  /// Example:
  /// ```dart
  /// final settings = await storageService.loadSettings();
  /// print('Blink interval: ${settings.blinkIntervalSeconds}');
  /// ```
  Future<EyeCareSettings> loadSettings() async {
    try {
      await _ensureInitialized();

      final jsonString = _prefs?.getString(AppConstants.settingsKey);
      if (jsonString == null || jsonString.isEmpty) {
        AppLogger.debug('No saved settings found, using defaults');
        return const EyeCareSettings();
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final settings = EyeCareSettings.fromJson(json);
      AppLogger.debug('Settings loaded successfully');
      return settings;
    } on FormatException catch (e, stackTrace) {
      AppLogger.error(
        'Invalid JSON format in saved settings, using defaults',
        error: e,
        stackTrace: stackTrace,
      );
      // Clear corrupted data
      await _clearCorruptedSettings();
      return const EyeCareSettings();
    } on TypeError catch (e, stackTrace) {
      AppLogger.error(
        'Type error while parsing settings, using defaults',
        error: e,
        stackTrace: stackTrace,
      );
      await _clearCorruptedSettings();
      return const EyeCareSettings();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error loading settings, using defaults',
        error: e,
        stackTrace: stackTrace,
      );
      return const EyeCareSettings();
    }
  }

  /// Save settings to persistent storage.
  ///
  /// Serializes the provided [settings] to JSON and stores it
  /// in SharedPreferences.
  ///
  /// Returns `true` if save was successful, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final success = await storageService.saveSettings(newSettings);
  /// if (!success) {
  ///   showError('Failed to save settings');
  /// }
  /// ```
  Future<bool> saveSettings(EyeCareSettings settings) async {
    try {
      await _ensureInitialized();

      final jsonString = jsonEncode(settings.toJson());
      final success =
          await _prefs?.setString(AppConstants.settingsKey, jsonString) ??
              false;

      if (success) {
        AppLogger.debug('Settings saved successfully');
      } else {
        AppLogger.warning('SharedPreferences.setString returned false');
      }

      return success;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save settings',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear all saved settings.
  ///
  /// Removes the settings from storage. After calling this,
  /// [loadSettings] will return default settings.
  ///
  /// Returns `true` if clear was successful, `false` otherwise.
  Future<bool> clearSettings() async {
    try {
      await _ensureInitialized();

      final success =
          await _prefs?.remove(AppConstants.settingsKey) ?? false;

      if (success) {
        AppLogger.info('Settings cleared');
      }

      return success;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear settings',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear corrupted settings data.
  ///
  /// Called internally when settings data cannot be parsed.
  Future<void> _clearCorruptedSettings() async {
    try {
      await _prefs?.remove(AppConstants.settingsKey);
      AppLogger.warning('Cleared corrupted settings data');
    } catch (e) {
      AppLogger.error('Failed to clear corrupted settings', error: e);
    }
  }

  /// Reset storage service state (for testing).
  ///
  /// This method is intended for use in tests only.
  @visibleForTesting
  void reset() {
    _prefs = null;
    _isInitialized = false;
  }
}
