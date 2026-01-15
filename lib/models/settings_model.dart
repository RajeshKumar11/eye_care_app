/// Eye Care App Settings Model
class EyeCareSettings {
  final bool backgroundModeEnabled;
  final int blinkIntervalSeconds;
  final int blankScreenDurationSeconds;
  final bool ttsEnabled;
  final bool blinkReminderEnabled;
  final bool blankScreenEnabled;
  final int blankScreenIntervalMinutes;
  final EyeCarePreset activePreset;

  const EyeCareSettings({
    this.backgroundModeEnabled = true,
    this.blinkIntervalSeconds = 15,
    this.blankScreenDurationSeconds = 3,
    this.ttsEnabled = true,
    this.blinkReminderEnabled = true,
    this.blankScreenEnabled = true,
    this.blankScreenIntervalMinutes = 30,
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

  factory EyeCareSettings.fromJson(Map<String, dynamic> json) {
    return EyeCareSettings(
      backgroundModeEnabled: json['backgroundModeEnabled'] ?? true,
      blinkIntervalSeconds: json['blinkIntervalSeconds'] ?? 15,
      blankScreenDurationSeconds: json['blankScreenDurationSeconds'] ?? 3,
      ttsEnabled: json['ttsEnabled'] ?? true,
      blinkReminderEnabled: json['blinkReminderEnabled'] ?? true,
      blankScreenEnabled: json['blankScreenEnabled'] ?? true,
      blankScreenIntervalMinutes: json['blankScreenIntervalMinutes'] ?? 30,
      activePreset: EyeCarePreset.values[json['activePreset'] ?? 1],
    );
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
