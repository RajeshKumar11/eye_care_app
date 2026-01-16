import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';
import '../services/notification_service.dart';
import '../services/tts_service.dart';
import '../services/background_service.dart';
import '../services/window_service.dart';
import '../utils/platform_utils.dart';
import '../utils/app_logger.dart';

/// Main provider for eye care functionality.
///
/// Manages blink reminders and blank screen rest periods.
/// Handles both foreground overlays and background notifications.
///
/// Example:
/// ```dart
/// final provider = context.read<EyeCareProvider>();
/// await provider.initialize();
/// await provider.startService(settings);
/// ```
class EyeCareProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final TtsService _ttsService = TtsService();
  final BackgroundService _backgroundService = BackgroundService();
  final WindowService _windowService = WindowService();

  Timer? _blinkTimer;
  Timer? _blankScreenTimer;
  Timer? _blankScreenCountdownTimer; // Track countdown timer to prevent leaks

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

  /// Initialize the eye care service.
  ///
  /// Must be called before [startService].
  Future<void> initialize() async {
    AppLogger.serviceInit('EyeCareProvider');
    try {
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
      AppLogger.info('EyeCareProvider initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize EyeCareProvider', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Start the eye care service with the given settings.
  Future<void> startService(EyeCareSettings settings) async {
    AppLogger.userAction('Start eye care service');
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
    AppLogger.stateChange('EyeCareProvider', 'Service started');
    notifyListeners();
  }

  /// Stop the eye care service.
  Future<void> stopService() async {
    AppLogger.userAction('Stop eye care service');
    _stopForegroundTimers();
    _blankScreenCountdownTimer?.cancel();
    _blankScreenCountdownTimer = null;

    // Stop background notifications
    if (PlatformUtils.isAndroid) {
      await _backgroundService.stop();
    }

    // Cancel any ongoing notifications
    await _notificationService.cancelAllNotifications();

    _isServiceRunning = false;
    _showBlinkOverlay = false;
    _showBlankScreen = false;
    AppLogger.stateChange('EyeCareProvider', 'Service stopped');
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
        (_) => _handleBlinkReminderTimer(settings.blankScreenDurationSeconds),
      );
    }

    // Start blank screen timer (separate longer rest periods)
    if (settings.blankScreenEnabled) {
      _blankScreenTimer = Timer.periodic(
        Duration(minutes: settings.blankScreenIntervalMinutes),
        (_) => _handleBlankScreenTimer(settings.blankScreenDurationSeconds),
      );
    }
  }

  /// Handle blink reminder timer - shows overlay only if app is visible,
  /// otherwise shows notification.
  Future<void> _handleBlinkReminderTimer(int durationSeconds) async {
    if (PlatformUtils.isDesktop) {
      final isVisible = await _windowService.isWindowVisibleAndFocused();
      if (!isVisible) {
        // App is hidden/minimized - show notification instead of overlay
        AppLogger.debug('App hidden - showing blink notification instead of overlay');
        await _notificationService.showBlinkReminder();
        return;
      }
    }
    triggerBlinkReminder(durationSeconds);
  }

  /// Handle blank screen timer - shows overlay only if app is visible,
  /// otherwise shows notification.
  Future<void> _handleBlankScreenTimer(int durationSeconds) async {
    if (PlatformUtils.isDesktop) {
      final isVisible = await _windowService.isWindowVisibleAndFocused();
      if (!isVisible) {
        // App is hidden/minimized - show notification instead of overlay
        AppLogger.debug('App hidden - showing blank screen notification instead of overlay');
        await _notificationService.showBlankScreenReminder();
        return;
      }
    }
    triggerBlankScreen(durationSeconds);
  }

  void _stopForegroundTimers() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _blankScreenTimer?.cancel();
    _blankScreenTimer = null;
  }

  /// Trigger blink reminder with full black screen and countdown.
  void triggerBlinkReminder(int durationSeconds) {
    if (_showBlinkOverlay || _showBlankScreen) {
      AppLogger.debug('Skipping blink reminder - overlay already showing');
      return;
    }

    AppLogger.info('Triggering blink reminder for $durationSeconds seconds');
    _showBlinkOverlay = true;
    _blinkCountdown = durationSeconds;
    notifyListeners();
    onBlinkReminder?.call();

    // Cancel notification since we're showing the overlay
    _notificationService.cancelNotification(BackgroundService.blinkNotificationId);
  }

  /// Dismiss blink overlay.
  void dismissBlinkOverlay() {
    AppLogger.userAction('Dismiss blink overlay');
    _showBlinkOverlay = false;
    _blinkCountdown = 0;
    notifyListeners();
  }

  /// Trigger longer blank screen rest.
  ///
  /// Shows a full-screen blank overlay for the specified duration.
  /// Automatically counts down and dismisses when complete.
  void triggerBlankScreen(int durationSeconds) {
    if (_showBlinkOverlay || _showBlankScreen) {
      AppLogger.debug('Skipping blank screen - overlay already showing');
      return;
    }

    AppLogger.info('Triggering blank screen for $durationSeconds seconds');

    // Cancel any existing countdown timer to prevent leaks
    _blankScreenCountdownTimer?.cancel();

    _showBlankScreen = true;
    _blankScreenCountdown = durationSeconds;
    notifyListeners();
    onBlankScreenStart?.call();

    // Cancel notification since we're showing the overlay
    _notificationService.cancelNotification(BackgroundService.blankNotificationId);

    // Countdown timer - tracked to allow proper cleanup
    _blankScreenCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _blankScreenCountdown--;
      notifyListeners();

      if (_blankScreenCountdown <= 0) {
        timer.cancel();
        _blankScreenCountdownTimer = null;
        _showBlankScreen = false;
        notifyListeners();
        onBlankScreenEnd?.call();
        AppLogger.debug('Blank screen completed');
      }
    });
  }

  /// Dismiss the blank screen early.
  void dismissBlankScreen() {
    AppLogger.userAction('Dismiss blank screen');
    _blankScreenCountdownTimer?.cancel();
    _blankScreenCountdownTimer = null;
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
    AppLogger.serviceDispose('EyeCareProvider');
    _stopForegroundTimers();
    _blankScreenCountdownTimer?.cancel();
    _blankScreenCountdownTimer = null;
    _backgroundService.dispose();
    super.dispose();
  }
}
