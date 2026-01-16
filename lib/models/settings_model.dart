/// Eye Care App Settings Model.
///
/// Immutable configuration for eye care reminders and features.
/// Use [copyWith] to create modified copies.
/// Use [fromJson] to deserialize from storage (with safe defaults).
/// Use [fromPreset] to apply predefined configurations.
class EyeCareSettings {
  /// Whether the app should continue running in the background.
  final bool backgroundModeEnabled;

  /// Interval between blink reminders in seconds.
  final int blinkIntervalSeconds;

  /// Duration of blank screen in seconds.
  final int blankScreenDurationSeconds;

  /// Whether text-to-speech is enabled for reminders.
  final bool ttsEnabled;

  /// Whether blink reminders are enabled.
  final bool blinkReminderEnabled;

  /// Whether blank screen feature is enabled.
  final bool blankScreenEnabled;

  /// Interval between blank screen reminders in minutes.
  final int blankScreenIntervalMinutes;

  /// Currently active preset configuration.
  final EyeCarePreset activePreset;

  /// Default values for settings.
  static const int defaultBlinkInterval = 15;
  static const int defaultBlankDuration = 3;
  static const int defaultBlankInterval = 30;

  const EyeCareSettings({
    this.backgroundModeEnabled = true,
    this.blinkIntervalSeconds = defaultBlinkInterval,
    this.blankScreenDurationSeconds = defaultBlankDuration,
    this.ttsEnabled = true,
    this.blinkReminderEnabled = true,
    this.blankScreenEnabled = true,
    this.blankScreenIntervalMinutes = defaultBlankInterval,
    this.activePreset = EyeCarePreset.normal,
  });

  EyeCareSettings copyWith({
    bool? backgroundModeEnabled,
    int? blinkIntervalSeconds,
    int? blankScreenDurationSeconds,
    bool? ttsEnabled,
    bool? blinkReminderEnabled,
    bool? blankScreenEnabled,
    int? blankScreenIntervalMinutes,
    EyeCarePreset? activePreset,
  }) {
    return EyeCareSettings(
      backgroundModeEnabled: backgroundModeEnabled ?? this.backgroundModeEnabled,
      blinkIntervalSeconds: blinkIntervalSeconds ?? this.blinkIntervalSeconds,
      blankScreenDurationSeconds: blankScreenDurationSeconds ?? this.blankScreenDurationSeconds,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      blinkReminderEnabled: blinkReminderEnabled ?? this.blinkReminderEnabled,
      blankScreenEnabled: blankScreenEnabled ?? this.blankScreenEnabled,
      blankScreenIntervalMinutes: blankScreenIntervalMinutes ?? this.blankScreenIntervalMinutes,
      activePreset: activePreset ?? this.activePreset,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundModeEnabled': backgroundModeEnabled,
      'blinkIntervalSeconds': blinkIntervalSeconds,
      'blankScreenDurationSeconds': blankScreenDurationSeconds,
      'ttsEnabled': ttsEnabled,
      'blinkReminderEnabled': blinkReminderEnabled,
      'blankScreenEnabled': blankScreenEnabled,
      'blankScreenIntervalMinutes': blankScreenIntervalMinutes,
      'activePreset': activePreset.index,
    };
  }

  /// Creates settings from JSON with safe type checking.
  ///
  /// All fields use defaults if missing or invalid type.
  /// Invalid preset indices default to [EyeCarePreset.normal].
  factory EyeCareSettings.fromJson(Map<String, dynamic> json) {
    return EyeCareSettings(
      backgroundModeEnabled: _safeBool(json['backgroundModeEnabled'], true),
      blinkIntervalSeconds: _safeInt(json['blinkIntervalSeconds'], defaultBlinkInterval),
      blankScreenDurationSeconds: _safeInt(json['blankScreenDurationSeconds'], defaultBlankDuration),
      ttsEnabled: _safeBool(json['ttsEnabled'], true),
      blinkReminderEnabled: _safeBool(json['blinkReminderEnabled'], true),
      blankScreenEnabled: _safeBool(json['blankScreenEnabled'], true),
      blankScreenIntervalMinutes: _safeInt(json['blankScreenIntervalMinutes'], defaultBlankInterval),
      activePreset: _safePreset(json['activePreset']),
    );
  }

  /// Safely parse bool from JSON with fallback.
  static bool _safeBool(dynamic value, bool defaultValue) {
    if (value is bool) return value;
    return defaultValue;
  }

  /// Safely parse int from JSON with fallback.
  static int _safeInt(dynamic value, int defaultValue) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  /// Safely parse preset from JSON with bounds checking.
  static EyeCarePreset _safePreset(dynamic value) {
    if (value is int && value >= 0 && value < EyeCarePreset.values.length) {
      return EyeCarePreset.values[value];
    }
    return EyeCarePreset.normal; // Default preset
  }

  /// Apply preset settings
  static EyeCareSettings fromPreset(EyeCarePreset preset) {
    switch (preset) {
      case EyeCarePreset.intenseFocus:
        return const EyeCareSettings(
          blinkIntervalSeconds: 10,
          blankScreenDurationSeconds: 2,
          blankScreenIntervalMinutes: 15,
          activePreset: EyeCarePreset.intenseFocus,
        );
      case EyeCarePreset.normal:
        return const EyeCareSettings(
          blinkIntervalSeconds: 20,
          blankScreenDurationSeconds: 3,
          blankScreenIntervalMinutes: 30,
          activePreset: EyeCarePreset.normal,
        );
      case EyeCarePreset.relaxed:
        return const EyeCareSettings(
          blinkIntervalSeconds: 60,
          blankScreenDurationSeconds: 5,
          blankScreenIntervalMinutes: 60,
          blinkReminderEnabled: false,
          activePreset: EyeCarePreset.relaxed,
        );
      case EyeCarePreset.custom:
        return const EyeCareSettings(activePreset: EyeCarePreset.custom);
    }
  }
}

enum EyeCarePreset {
  intenseFocus,
  normal,
  relaxed,
  custom,
}

extension EyeCarePresetExtension on EyeCarePreset {
  String get displayName {
    switch (this) {
      case EyeCarePreset.intenseFocus:
        return 'Intense Focus';
      case EyeCarePreset.normal:
        return 'Normal Use';
      case EyeCarePreset.relaxed:
        return 'Relaxed';
      case EyeCarePreset.custom:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case EyeCarePreset.intenseFocus:
        return 'Blink: 10s • Blank: 15min (2s) • Training: 1hr';
      case EyeCarePreset.normal:
        return 'Blink: 20s • Blank: 30min (3s) • Training: 2hr';
      case EyeCarePreset.relaxed:
        return 'Blink: Off • Blank: 60min (5s) • Training: Daily';
      case EyeCarePreset.custom:
        return 'Your custom settings';
    }
  }
}
