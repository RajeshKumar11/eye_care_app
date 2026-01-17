import 'package:flutter_test/flutter_test.dart';
import 'package:eye_care_app/models/settings_model.dart';
import 'package:eye_care_app/utils/constants.dart';

void main() {
  // Initialize Flutter binding for tests that need platform services
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  // Note: SettingsProvider tests are limited because they rely on
  // SharedPreferences which requires mocking. These tests verify
  // the validation constants and settings logic.

  group('AppConstants validation ranges', () {
    test('blink interval range is valid', () {
      expect(AppConstants.minBlinkInterval, lessThan(AppConstants.maxBlinkInterval));
      expect(AppConstants.minBlinkInterval, greaterThanOrEqualTo(1));
    });

    test('blank duration range is valid', () {
      expect(AppConstants.minBlankDuration, lessThan(AppConstants.maxBlankDuration));
      expect(AppConstants.minBlankDuration, greaterThanOrEqualTo(1));
    });

    test('blank interval range is valid', () {
      expect(AppConstants.minBlankInterval, lessThan(AppConstants.maxBlankInterval));
      expect(AppConstants.minBlankInterval, greaterThanOrEqualTo(1));
    });

    test('min blink interval is positive', () {
      expect(AppConstants.minBlinkInterval, greaterThan(0));
    });

    test('max blink interval is greater than min', () {
      expect(AppConstants.maxBlinkInterval, greaterThan(AppConstants.minBlinkInterval));
    });

    test('min blank duration is positive', () {
      expect(AppConstants.minBlankDuration, greaterThan(0));
    });

    test('max blank duration is greater than min', () {
      expect(AppConstants.maxBlankDuration, greaterThan(AppConstants.minBlankDuration));
    });

    test('min blank interval is positive', () {
      expect(AppConstants.minBlankInterval, greaterThan(0));
    });

    test('max blank interval is greater than min', () {
      expect(AppConstants.maxBlankInterval, greaterThan(AppConstants.minBlankInterval));
    });
  });

  group('EyeCareSettings defaults within ranges', () {
    test('default blink interval is within range', () {
      expect(
        EyeCareSettings.defaultBlinkInterval,
        inInclusiveRange(AppConstants.minBlinkInterval, AppConstants.maxBlinkInterval),
      );
    });

    test('default blank duration is within range', () {
      expect(
        EyeCareSettings.defaultBlankDuration,
        inInclusiveRange(AppConstants.minBlankDuration, AppConstants.maxBlankDuration),
      );
    });

    test('default blank interval is within range', () {
      expect(
        EyeCareSettings.defaultBlankInterval,
        inInclusiveRange(AppConstants.minBlankInterval, AppConstants.maxBlankInterval),
      );
    });
  });

  group('EyeCarePreset values within ranges', () {
    test('all presets have valid blink intervals', () {
      for (final preset in EyeCarePreset.values) {
        final settings = EyeCareSettings.fromPreset(preset);
        expect(
          settings.blinkIntervalSeconds,
          inInclusiveRange(AppConstants.minBlinkInterval, AppConstants.maxBlinkInterval),
          reason: 'Preset ${preset.name} has invalid blink interval',
        );
      }
    });

    test('all presets have valid blank durations', () {
      for (final preset in EyeCarePreset.values) {
        final settings = EyeCareSettings.fromPreset(preset);
        expect(
          settings.blankScreenDurationSeconds,
          inInclusiveRange(AppConstants.minBlankDuration, AppConstants.maxBlankDuration),
          reason: 'Preset ${preset.name} has invalid blank duration',
        );
      }
    });

    test('all presets have valid blank intervals', () {
      for (final preset in EyeCarePreset.values) {
        final settings = EyeCareSettings.fromPreset(preset);
        expect(
          settings.blankScreenIntervalMinutes,
          inInclusiveRange(AppConstants.minBlankInterval, AppConstants.maxBlankInterval),
          reason: 'Preset ${preset.name} has invalid blank interval',
        );
      }
    });

    test('intenseFocus preset values are within ranges', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.intenseFocus);
      expect(settings.blinkIntervalSeconds, 10);
      expect(settings.blankScreenDurationSeconds, 2);
      expect(settings.blankScreenIntervalMinutes, 15);
    });

    test('normal preset values are within ranges', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.normal);
      expect(settings.blinkIntervalSeconds, 20);
      expect(settings.blankScreenDurationSeconds, 3);
      expect(settings.blankScreenIntervalMinutes, 30);
    });

    test('relaxed preset values are within ranges', () {
      final settings = EyeCareSettings.fromPreset(EyeCarePreset.relaxed);
      expect(settings.blinkIntervalSeconds, 60);
      expect(settings.blankScreenDurationSeconds, 5);
      expect(settings.blankScreenIntervalMinutes, 60);
    });
  });
}
