import 'package:flutter_test/flutter_test.dart';
import 'package:eye_care_app/models/settings_model.dart';

void main() {
  group('EyeCareSettings', () {
    test('creates default settings correctly', () {
      const settings = EyeCareSettings();

      expect(settings.backgroundModeEnabled, true);
      expect(settings.blinkIntervalSeconds, 15);
      expect(settings.blankScreenDurationSeconds, 3);
      expect(settings.ttsEnabled, true);
      expect(settings.blinkReminderEnabled, true);
      expect(settings.blankScreenEnabled, true);
      expect(settings.blankScreenIntervalMinutes, 30);
      expect(settings.activePreset, EyeCarePreset.normal);
    });

    test('copyWith creates new instance with updated values', () {
      const original = EyeCareSettings(blinkIntervalSeconds: 15);
      final updated = original.copyWith(blinkIntervalSeconds: 20);

      expect(updated.blinkIntervalSeconds, 20);
      expect(updated.backgroundModeEnabled, original.backgroundModeEnabled);
      expect(updated.ttsEnabled, original.ttsEnabled);
    });

    test('copyWith with null values preserves original', () {
      const original = EyeCareSettings(
        blinkIntervalSeconds: 15,
        backgroundModeEnabled: false,
      );
      final updated = original.copyWith();

      expect(updated.blinkIntervalSeconds, original.blinkIntervalSeconds);
      expect(updated.backgroundModeEnabled, original.backgroundModeEnabled);
    });

    test('toJson serializes correctly', () {
      const settings = EyeCareSettings(
        backgroundModeEnabled: false,
        blinkIntervalSeconds: 25,
        activePreset: EyeCarePreset.intenseFocus,
      );

      final json = settings.toJson();

      expect(json['backgroundModeEnabled'], false);
      expect(json['blinkIntervalSeconds'], 25);
      expect(json['activePreset'], EyeCarePreset.intenseFocus.index);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'backgroundModeEnabled': false,
        'blinkIntervalSeconds': 25,
        'blankScreenDurationSeconds': 4,
        'ttsEnabled': false,
        'blinkReminderEnabled': false,
        'blankScreenEnabled': false,
        'blankScreenIntervalMinutes': 45,
        'activePreset': 2, // relaxed
      };

      final settings = EyeCareSettings.fromJson(json);

      expect(settings.backgroundModeEnabled, false);
      expect(settings.blinkIntervalSeconds, 25);
      expect(settings.blankScreenDurationSeconds, 4);
      expect(settings.ttsEnabled, false);
      expect(settings.blinkReminderEnabled, false);
      expect(settings.blankScreenEnabled, false);
      expect(settings.blankScreenIntervalMinutes, 45);
      expect(settings.activePreset, EyeCarePreset.relaxed);
    });

    test('fromJson handles missing values with defaults', () {
      final json = <String, dynamic>{};
      final settings = EyeCareSettings.fromJson(json);

      expect(settings.backgroundModeEnabled, true);
      expect(settings.blinkIntervalSeconds, 15);
      expect(settings.activePreset, EyeCarePreset.normal);
    });

    test('fromJson and toJson are symmetric', () {
      const original = EyeCareSettings(
        backgroundModeEnabled: false,
        blinkIntervalSeconds: 30,
        activePreset: EyeCarePreset.custom,
      );

      final json = original.toJson();
      final restored = EyeCareSettings.fromJson(json);

      expect(restored.backgroundModeEnabled, original.backgroundModeEnabled);
      expect(restored.blinkIntervalSeconds, original.blinkIntervalSeconds);
      expect(restored.activePreset, original.activePreset);
    });
  });

  group('EyeCareSettings.fromPreset', () {
    test('intenseFocus preset has correct values', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.intenseFocus);

      expect(settings.blinkIntervalSeconds, 10);
      expect(settings.blankScreenDurationSeconds, 2);
      expect(settings.blankScreenIntervalMinutes, 15);
      expect(settings.activePreset, EyeCarePreset.intenseFocus);
      expect(settings.blinkReminderEnabled, true);
    });

    test('normal preset has correct values', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.normal);

      expect(settings.blinkIntervalSeconds, 20);
      expect(settings.blankScreenDurationSeconds, 3);
      expect(settings.blankScreenIntervalMinutes, 30);
      expect(settings.activePreset, EyeCarePreset.normal);
    });

    test('relaxed preset has correct values', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.relaxed);

      expect(settings.blinkIntervalSeconds, 60);
      expect(settings.blankScreenDurationSeconds, 5);
      expect(settings.blankScreenIntervalMinutes, 60);
      expect(settings.blinkReminderEnabled, false);
      expect(settings.activePreset, EyeCarePreset.relaxed);
    });

    test('custom preset has default values', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.custom);

      expect(settings.activePreset, EyeCarePreset.custom);
      expect(settings.backgroundModeEnabled, true);
      expect(settings.ttsEnabled, true);
    });
  });

  group('EyeCarePreset', () {
    test('has correct number of values', () {
      expect(EyeCarePreset.values.length, 4);
    });

    test('values are in correct order', () {
      expect(EyeCarePreset.values[0], EyeCarePreset.intenseFocus);
      expect(EyeCarePreset.values[1], EyeCarePreset.normal);
      expect(EyeCarePreset.values[2], EyeCarePreset.relaxed);
      expect(EyeCarePreset.values[3], EyeCarePreset.custom);
    });
  });

  group('EyeCarePresetExtension', () {
    test('displayName returns correct names', () {
      expect(EyeCarePreset.intenseFocus.displayName, 'Intense Focus');
      expect(EyeCarePreset.normal.displayName, 'Normal Use');
      expect(EyeCarePreset.relaxed.displayName, 'Relaxed');
      expect(EyeCarePreset.custom.displayName, 'Custom');
    });

    test('description returns non-empty strings', () {
      for (final preset in EyeCarePreset.values) {
        expect(preset.description.isNotEmpty, true);
      }
    });

    test('intenseFocus description contains key information', () {
      final description = EyeCarePreset.intenseFocus.description;
      expect(description.contains('10s'), true);
      expect(description.contains('15min'), true);
    });

    test('normal description contains key information', () {
      final description = EyeCarePreset.normal.description;
      expect(description.contains('20s'), true);
      expect(description.contains('30min'), true);
    });

    test('relaxed description contains key information', () {
      final description = EyeCarePreset.relaxed.description;
      expect(description.contains('60min'), true);
    });
  });
}
