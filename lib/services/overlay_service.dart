import 'package:flutter_overlay_window/flutter_overlay_window.dart' as overlay;
import '../utils/platform_utils.dart';

/// Service for managing system overlay window
/// Shows the blink reminder on top of any app
class OverlayService {
  static final OverlayService _instance = OverlayService._internal();
  factory OverlayService() => _instance;
  OverlayService._internal();

  bool _isInitialized = false;

  /// Check if overlay permission is granted
  Future<bool> isPermissionGranted() async {
    if (!PlatformUtils.isAndroid) return false;
    return await overlay.FlutterOverlayWindow.isPermissionGranted();
  }

  /// Request overlay permission (opens system settings)
  Future<bool> requestPermission() async {
    if (!PlatformUtils.isAndroid) return false;
    final result = await overlay.FlutterOverlayWindow.requestPermission();
    return result ?? false;
  }

  /// Initialize the overlay service
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  /// Show the blink reminder overlay on top of other apps
  Future<bool> showBlinkOverlay({int durationSeconds = 3}) async {
    if (!PlatformUtils.isAndroid) return false;

    // Check permission first
    final hasPermission = await isPermissionGranted();
    if (!hasPermission) {
      return false;
    }

    // Check if overlay is already showing
    final isActive = await overlay.FlutterOverlayWindow.isActive();
    if (isActive) {
      return true; // Already showing
    }

    // Show the overlay window
    await overlay.FlutterOverlayWindow.showOverlay(
      enableDrag: false,
      overlayTitle: "Eye Care - Blink Reminder",
      overlayContent: "Rest your eyes",
      flag: overlay.OverlayFlag.defaultFlag,
      visibility: overlay.NotificationVisibility.visibilityPublic,
      positionGravity: overlay.PositionGravity.auto,
      height: overlay.WindowSize.fullCover,
      width: overlay.WindowSize.fullCover,
      startPosition: const overlay.OverlayPosition(0, 0),
    );

    return true;
  }

  /// Close the overlay window
  Future<void> closeOverlay() async {
    if (!PlatformUtils.isAndroid) return;

    final isActive = await overlay.FlutterOverlayWindow.isActive();
    if (isActive) {
      await overlay.FlutterOverlayWindow.closeOverlay();
    }
  }

  /// Check if overlay is currently showing
  Future<bool> isOverlayActive() async {
    if (!PlatformUtils.isAndroid) return false;
    return await overlay.FlutterOverlayWindow.isActive();
  }
}
