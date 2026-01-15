import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';
import '../services/notification_service.dart';
import '../services/tts_service.dart';
import '../services/background_service.dart';
import '../utils/platform_utils.dart';

/// Main provider for eye care functionality
class EyeCareProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final TtsService _ttsService = TtsService();
  final BackgroundService _backgroundService = BackgroundService();

  Timer? _blinkTimer;
  Timer? _blankScreenTimer;

  bool _isServiceRunning = false;
  bool _showBlinkOverlay = false;
  bool _showBlankScreen = false;
  int _blinkCountdown = 0;
  int _blankScreenCountdown = 0;

  bool get isServiceRunning => _isServiceRunning;
  bool get showBlinkOverlay => _showBlinkOverlay;
  bool get showBlankScreen => _showBlankScreen;
  int get blinkCountdown => _blinkCountdown;
  int get blankScreenCountdown => _blankScreenCountdown;

  EyeCareSettings? _currentSettings;
  EyeCareSettings? get currentSettings => _currentSettings;

  VoidCallback? onBlinkReminder;
  VoidCallback? onBlankScreenStart;
  VoidCallback? onBlankScreenEnd;

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _ttsService.initialize();
    await _backgroundService.initialize();

    // Register notification tap callbacks to show overlay when user taps notification
    _notificationService.onBlinkReminderTapped = () {
      if (_currentSettings != null) {
        triggerBlinkReminder(_currentSettings!.blankScreenDurationSeconds);
      }
    };

    _notificationService.onBlankScreenTapped = () {
      if (_currentSettings != null) {
        triggerBlankScreen(_currentSettings!.blankScreenDurationSeconds);
      }
    };
  }

  Future<void> startService(EyeCareSettings settings) async {
    _currentSettings = settings;

    // Start foreground timers (for when app is open - shows full screen overlay)
    _startForegroundTimers(settings);

    // Start background scheduled notifications (for when app is in background)
    if (PlatformUtils.isAndroid) {
      await _backgroundService.start(
        blinkIntervalSeconds: settings.blinkIntervalSeconds,
        blankScreenIntervalMinutes: settings.blankScreenIntervalMinutes,
        blinkEnabled: settings.blinkReminderEnabled,
        blankScreenEnabled: settings.blankScreenEnabled,
      );
    }

    _isServiceRunning = true;
    notifyListeners();
  }

  Future<void> stopService() async {
    _stopForegroundTimers();

    // Stop background notifications
    if (PlatformUtils.isAndroid) {
      await _backgroundService.stop();
    }

    // Cancel any ongoing notifications
    await _notificationService.cancelAllNotifications();

    _isServiceRunning = false;
    notifyListeners();
  }

  Future<void> updateSettings(EyeCareSettings settings) async {
    _currentSettings = settings;

    if (_isServiceRunning) {
      _stopForegroundTimers();
      _startForegroundTimers(settings);

      // Update background notifications
      if (PlatformUtils.isAndroid) {
        await _backgroundService.updateSettings(
          blinkIntervalSeconds: settings.blinkIntervalSeconds,
          blankScreenIntervalMinutes: settings.blankScreenIntervalMinutes,
          blinkEnabled: settings.blinkReminderEnabled,
          blankScreenEnabled: settings.blankScreenEnabled,
        );
      }
    }
  }

  void _startForegroundTimers(EyeCareSettings settings) {
    // Start blink timer - triggers full screen blink reminder when app is in foreground
    if (settings.blinkReminderEnabled) {
      _blinkTimer = Timer.periodic(
        Duration(seconds: settings.blinkIntervalSeconds),
        (_) => triggerBlinkReminder(settings.blankScreenDurationSeconds),
      );
    }

    // Start blank screen timer (separate longer rest periods)
    if (settings.blankScreenEnabled) {
      _blankScreenTimer = Timer.periodic(
        Duration(minutes: settings.blankScreenIntervalMinutes),
        (_) => triggerBlankScreen(settings.blankScreenDurationSeconds),
      );
    }
  }

  void _stopForegroundTimers() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _blankScreenTimer?.cancel();
    _blankScreenTimer = null;
  }

  /// Trigger blink reminder with full black screen and countdown
  void triggerBlinkReminder(int durationSeconds) {
    if (_showBlinkOverlay || _showBlankScreen) return; // Prevent overlap

    _showBlinkOverlay = true;
    _blinkCountdown = durationSeconds;
    notifyListeners();
    onBlinkReminder?.call();

    // Cancel notification since we're showing the overlay
    _notificationService.cancelNotification(BackgroundService.blinkNotificationId);
  }

  /// Dismiss blink overlay
  void dismissBlinkOverlay() {
    _showBlinkOverlay = false;
    _blinkCountdown = 0;
    notifyListeners();
  }

  /// Trigger longer blank screen rest
  void triggerBlankScreen(int durationSeconds) {
    if (_showBlinkOverlay || _showBlankScreen) return; // Prevent overlap

    _showBlankScreen = true;
    _blankScreenCountdown = durationSeconds;
    notifyListeners();
    onBlankScreenStart?.call();

    // Cancel notification since we're showing the overlay
    _notificationService.cancelNotification(BackgroundService.blankNotificationId);

    // Countdown timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _blankScreenCountdown--;
      notifyListeners();

      if (_blankScreenCountdown <= 0) {
        timer.cancel();
        _showBlankScreen = false;
        notifyListeners();
        onBlankScreenEnd?.call();
      }
    });
  }

  void dismissBlankScreen() {
    _showBlankScreen = false;
    _blankScreenCountdown = 0;
    notifyListeners();
    onBlankScreenEnd?.call();
  }

  Future<void> requestNotificationPermission() async {
    await _notificationService.requestPermissions();
  }

  @override
  void dispose() {
    _stopForegroundTimers();
    _backgroundService.dispose();
    super.dispose();
  }
}
