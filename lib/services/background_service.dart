import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart' as overlay;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../utils/platform_utils.dart';

/// Background service using scheduled notifications and system overlay
/// Only functional on Android - desktop platforms use foreground-only timers
class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  FlutterLocalNotificationsPlugin? _notifications;

  bool _isRunning = false;
  bool _isInitialized = false;
  bool _isSupported = false;
  Timer? _blinkTimer;
  Timer? _blankTimer;
  bool _appInForeground = true;

  bool get isRunning => _isRunning;
  bool get isSupported => _isSupported;

  /// Set whether app is in foreground (to avoid showing system overlay when app is visible)
  void setAppInForeground(bool inForeground) {
    _appInForeground = inForeground;
  }

  // Notification IDs
  static const int blinkNotificationId = 100;
  static const int blankNotificationId = 101;

  // Channel IDs
  static const String blinkChannelId = 'eye_care_blink_bg';
  static const String blankChannelId = 'eye_care_blank_bg';

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone for scheduled notifications
    tz_data.initializeTimeZones();

    // Background service only supported on Android
    _isSupported = PlatformUtils.isAndroid;

    if (_isSupported) {
      _notifications = FlutterLocalNotificationsPlugin();

      // Create notification channels
      final androidPlugin = _notifications!.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            blinkChannelId,
            'Blink Reminders',
            description: 'Background blink reminders',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );

        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            blankChannelId,
            'Rest Reminders',
            description: 'Background rest reminders',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );
      }
    }

    _isInitialized = true;
  }

  /// Check if overlay permission is granted
  Future<bool> hasOverlayPermission() async {
    if (!_isSupported) return false;
    return await overlay.FlutterOverlayWindow.isPermissionGranted();
  }

  /// Request overlay permission
  Future<bool> requestOverlayPermission() async {
    if (!_isSupported) return false;
    final result = await overlay.FlutterOverlayWindow.requestPermission();
    return result ?? false;
  }

  /// Start background reminders with the given intervals
  Future<void> start({
    required int blinkIntervalSeconds,
    required int blankScreenIntervalMinutes,
    required bool blinkEnabled,
    required bool blankScreenEnabled,
  }) async {
    if (!_isSupported) return;

    // Cancel any existing timers/notifications first
    await stop();

    // Save service state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('eye_care_service_running', true);
    await prefs.setInt('blink_interval_seconds', blinkIntervalSeconds);
    await prefs.setInt('blank_screen_interval_minutes', blankScreenIntervalMinutes);

    if (blinkEnabled) {
      // Schedule first notification as backup
      await _scheduleBlinkNotification(blinkIntervalSeconds);

      // Use a timer to show overlay directly when app is running
      _blinkTimer = Timer.periodic(
        Duration(seconds: blinkIntervalSeconds),
        (_) => _triggerBlinkReminder(),
      );
    }

    if (blankScreenEnabled) {
      await _scheduleBlankNotification(blankScreenIntervalMinutes);

      _blankTimer = Timer.periodic(
        Duration(minutes: blankScreenIntervalMinutes),
        (_) => _triggerBlankReminder(),
      );
    }

    _isRunning = true;
  }

  /// Trigger blink reminder - shows overlay if permission granted, else notification
  Future<void> _triggerBlinkReminder() async {
    if (!_isSupported) return;

    final prefs = await SharedPreferences.getInstance();
    final isRunning = prefs.getBool('eye_care_service_running') ?? false;
    if (!isRunning) return;

    // Only show system overlay when app is in background
    // When in foreground, the EyeCareProvider handles showing the in-app overlay
    if (!_appInForeground) {
      // Try to show overlay first
      final hasPermission = await hasOverlayPermission();
      if (hasPermission) {
        await _showOverlay();
      } else {
        // Fallback to notification
        await _showBlinkNotification();
      }
    }

    // Reschedule for next interval
    final intervalSeconds = prefs.getInt('blink_interval_seconds') ?? 15;
    await _scheduleBlinkNotification(intervalSeconds);
  }

  /// Trigger blank screen reminder
  Future<void> _triggerBlankReminder() async {
    if (!_isSupported) return;

    final prefs = await SharedPreferences.getInstance();
    final isRunning = prefs.getBool('eye_care_service_running') ?? false;
    if (!isRunning) return;

    // Only show system overlay when app is in background
    // When in foreground, the EyeCareProvider handles showing the in-app overlay
    if (!_appInForeground) {
      // Try to show overlay first
      final hasPermission = await hasOverlayPermission();
      if (hasPermission) {
        await _showOverlay();
      } else {
        // Fallback to notification
        await _showBlankNotification();
      }
    }

    // Reschedule for next interval
    final intervalMinutes = prefs.getInt('blank_screen_interval_minutes') ?? 20;
    await _scheduleBlankNotification(intervalMinutes);
  }

  /// Show the system overlay on top of other apps
  Future<void> _showOverlay() async {
    if (!_isSupported) return;

    try {
      // Check if overlay is already showing
      final isActive = await overlay.FlutterOverlayWindow.isActive();
      if (isActive) return;

      await overlay.FlutterOverlayWindow.showOverlay(
        enableDrag: false,
        overlayTitle: "Eye Care",
        overlayContent: "Blink Reminder",
        flag: overlay.OverlayFlag.defaultFlag,
        visibility: overlay.NotificationVisibility.visibilityPublic,
        positionGravity: overlay.PositionGravity.auto,
        height: overlay.WindowSize.fullCover,
        width: overlay.WindowSize.fullCover,
      );
    } catch (e) {
      // If overlay fails, show notification instead
      await _showBlinkNotification();
    }
  }

  /// Schedule a blink notification (fallback when no overlay permission)
  Future<void> _scheduleBlinkNotification(int intervalSeconds) async {
    if (!_isSupported || _notifications == null) return;

    final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: intervalSeconds));

    await _notifications!.zonedSchedule(
      blinkNotificationId,
      'BLINK NOW',
      'Rest your eyes! Tap to see full screen reminder.',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          blinkChannelId,
          'Blink Reminders',
          channelDescription: 'Background blink reminders',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          playSound: true,
          enableVibration: true,
          autoCancel: true,
          ticker: 'Blink Reminder',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'blink_reminder',
    );
  }

  /// Schedule a blank screen notification
  Future<void> _scheduleBlankNotification(int intervalMinutes) async {
    if (!_isSupported || _notifications == null) return;

    final scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: intervalMinutes));

    await _notifications!.zonedSchedule(
      blankNotificationId,
      'EYE REST TIME',
      'Take a 20 second break! Tap to open rest screen.',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          blankChannelId,
          'Rest Reminders',
          channelDescription: 'Background rest reminders',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          playSound: true,
          enableVibration: true,
          autoCancel: true,
          ticker: 'Eye Rest Time',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'blank_screen_reminder',
    );
  }

  /// Show blink notification immediately (fallback)
  Future<void> _showBlinkNotification() async {
    if (!_isSupported || _notifications == null) return;

    await _notifications!.show(
      blinkNotificationId,
      'BLINK NOW',
      'Rest your eyes! Tap to see full screen reminder.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          blinkChannelId,
          'Blink Reminders',
          channelDescription: 'Background blink reminders',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          playSound: true,
          enableVibration: true,
          autoCancel: true,
          ticker: 'Blink Reminder',
        ),
      ),
      payload: 'blink_reminder',
    );
  }

  /// Show blank screen notification immediately (fallback)
  Future<void> _showBlankNotification() async {
    if (!_isSupported || _notifications == null) return;

    await _notifications!.show(
      blankNotificationId,
      'EYE REST TIME',
      'Take a 20 second break! Tap to open rest screen.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          blankChannelId,
          'Rest Reminders',
          channelDescription: 'Background rest reminders',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          playSound: true,
          enableVibration: true,
          autoCancel: true,
          ticker: 'Eye Rest Time',
        ),
      ),
      payload: 'blank_screen_reminder',
    );
  }

  /// Stop all background reminders
  Future<void> stop() async {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    _blankTimer?.cancel();
    _blankTimer = null;

    // Cancel scheduled notifications (only on supported platforms)
    if (_isSupported && _notifications != null) {
      await _notifications!.cancel(blinkNotificationId);
      await _notifications!.cancel(blankNotificationId);

      // Close overlay if showing
      try {
        final isActive = await overlay.FlutterOverlayWindow.isActive();
        if (isActive) {
          await overlay.FlutterOverlayWindow.closeOverlay();
        }
      } catch (e) {
        // Ignore errors when closing overlay
      }
    }

    // Update shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('eye_care_service_running', false);

    _isRunning = false;
  }

  /// Update settings (will restart with new intervals)
  Future<void> updateSettings({
    required int blinkIntervalSeconds,
    required int blankScreenIntervalMinutes,
    required bool blinkEnabled,
    required bool blankScreenEnabled,
  }) async {
    if (!_isRunning) return;

    await start(
      blinkIntervalSeconds: blinkIntervalSeconds,
      blankScreenIntervalMinutes: blankScreenIntervalMinutes,
      blinkEnabled: blinkEnabled,
      blankScreenEnabled: blankScreenEnabled,
    );
  }

  void dispose() {
    stop();
  }
}
