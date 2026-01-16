import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import '../utils/platform_utils.dart';
import '../utils/app_logger.dart';
import 'window_service.dart';

/// System tray service for desktop platforms.
///
/// Provides system tray icon and context menu functionality
/// on Windows, macOS, and Linux. On mobile platforms, this
/// service is a no-op.
///
/// Features:
/// - System tray icon with tooltip
/// - Context menu for quick actions
/// - Click handling to show/hide window
///
/// Example:
/// ```dart
/// final tray = TrayService();
/// await tray.initialize();
/// tray.onShowWindow = () => windowService.show();
/// tray.onQuitApp = () => exit(0);
/// ```
class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();

  /// Factory constructor returns the singleton instance.
  factory TrayService() => _instance;

  TrayService._internal();

  bool _isInitialized = false;
  final WindowService _windowService = WindowService();

  /// Callback invoked when "Show" is clicked or tray icon is clicked.
  VoidCallback? onShowWindow;

  /// Callback invoked when "Quit" is clicked.
  VoidCallback? onQuitApp;

  /// Callback invoked when "Toggle Blink Reminder" is clicked.
  VoidCallback? onToggleBlinkReminder;

  /// Whether the tray service has been initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize the system tray.
  ///
  /// Sets up the tray icon, tooltip, and context menu.
  /// Safe to call multiple times - subsequent calls are no-ops.
  /// Does nothing on non-desktop platforms.
  ///
  /// Returns `true` if initialization was successful, `false` otherwise.
  Future<bool> initialize() async {
    if (!PlatformUtils.isDesktop) {
      AppLogger.debug('TrayService: Skipping init on non-desktop platform');
      return false;
    }

    if (_isInitialized) {
      AppLogger.debug('TrayService: Already initialized');
      return true;
    }

    try {
      // Set tray icon based on platform
      final iconPath = _getIconPath();
      AppLogger.debug('TrayService: Setting icon from $iconPath');

      await trayManager.setIcon(iconPath);
      await trayManager.setToolTip('Eye Care - Protecting your eyes');

      // Set up context menu
      await _setupContextMenu();

      trayManager.addListener(this);
      _isInitialized = true;
      AppLogger.serviceInit('TrayService');
      return true;
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize system tray',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    } catch (e, stackTrace) {
      // Catch any other errors (e.g., missing icon file)
      AppLogger.error(
        'Unexpected error initializing system tray',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get the appropriate icon path for the current platform.
  String _getIconPath() {
    if (PlatformUtils.isWindows) {
      return 'assets/icons/app_icon.ico';
    } else {
      return 'assets/icons/app_icon.png';
    }
  }

  /// Set up the context menu items.
  Future<void> _setupContextMenu() async {
    try {
      final menu = Menu(
        items: [
          MenuItem(
            key: 'show',
            label: 'Show Eye Care',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'toggle_blink',
            label: 'Toggle Blink Reminder',
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'quit',
            label: 'Quit',
          ),
        ],
      );

      await trayManager.setContextMenu(menu);
      AppLogger.debug('TrayService: Context menu configured');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to setup tray context menu',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void onTrayIconMouseDown() {
    AppLogger.debug('TrayService: Tray icon clicked');
    try {
      _windowService.showFromTray();
      onShowWindow?.call();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling tray icon click',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    AppLogger.debug('TrayService: Tray icon right-clicked');
    try {
      trayManager.popUpContextMenu();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error showing tray context menu',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    AppLogger.debug('TrayService: Menu item clicked: ${menuItem.key}');
    try {
      switch (menuItem.key) {
        case 'show':
          _windowService.showFromTray();
          onShowWindow?.call();
          break;
        case 'toggle_blink':
          onToggleBlinkReminder?.call();
          break;
        case 'quit':
          onQuitApp?.call();
          break;
        default:
          AppLogger.warning('Unknown menu item: ${menuItem.key}');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling tray menu item: ${menuItem.key}',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update the tray tooltip text.
  ///
  /// Use this to show status information like "Protection active"
  /// or countdown timers.
  Future<void> updateTooltip(String message) async {
    if (!PlatformUtils.isDesktop || !_isInitialized) return;

    try {
      await trayManager.setToolTip(message);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update tray tooltip',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Dispose of the tray service.
  ///
  /// Removes the listener and destroys the tray icon.
  void dispose() {
    if (!PlatformUtils.isDesktop || !_isInitialized) return;

    try {
      trayManager.removeListener(this);
      trayManager.destroy();
      _isInitialized = false;
      AppLogger.serviceDispose('TrayService');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error disposing tray service',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
