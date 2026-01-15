import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/constants.dart';
import '../utils/platform_utils.dart';
import 'background_service.dart';

/// Notification service for blink reminders and blank screen alerts
/// Only functional on mobile platforms (Android/iOS)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FlutterLocalNotificationsPlugin? _notifications;
  bool _isInitialized = false;
  bool _isSupported = false;

  bool get isSupported => _isSupported;

  /// Callback when blink reminder notification is tapped
  Function()? onBlinkReminderTapped;

  /// Callback when blank screen notification is tapped
  Function()? onBlankScreenTapped;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Only initialize notifications on mobile platforms
    _isSupported = PlatformUtils.isMobile;
    if (!_isSupported) {
      _isInitialized = true;
      return;
    }

    _notifications = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationTapped,
    );

    if (PlatformUtils.isAndroid) {
      await _createNotificationChannels();
    }

    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    if (_notifications == null) return;

    final androidPlugin = _notifications!
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // High priority channel for blink reminders
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          BackgroundService.blinkChannelId,
          'Blink Reminders',
          description: 'Background blink reminders',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      // High priority channel for blank screen reminders
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          BackgroundService.blankChannelId,
          'Rest Reminders',
          description: 'Background rest reminders',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Low priority channel for service notification
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          AppConstants.serviceChannelId,
          'Eye Care Service',
          description: 'Background service notification',
          importance: Importance.low,
          playSound: false,
        ),
      );
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == 'blink_reminder') {
      onBlinkReminderTapped?.call();
      cancelNotification(BackgroundService.blinkNotificationId);
    } else if (payload == 'blank_screen_reminder') {
      onBlankScreenTapped?.call();
      cancelNotification(BackgroundService.blankNotificationId);
    }
  }

  Future<void> cancelAllNotifications() async {
    if (!_isSupported || _notifications == null) return;
    await _notifications!.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    if (!_isSupported || _notifications == null) return;
    await _notifications!.cancel(id);
  }

  Future<bool> requestPermissions() async {
    if (!_isSupported || _notifications == null) return true;

    if (PlatformUtils.isAndroid) {
      final androidPlugin = _notifications!
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    } else if (PlatformUtils.isIOS) {
      final iosPlugin = _notifications!
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }
}

/// Top-level function for handling background notification responses
@pragma('vm:entry-point')
void _onBackgroundNotificationTapped(NotificationResponse response) {
  // This is called when notification is tapped while app is in background/terminated
  // The app will be launched and the payload can be processed in main
}
