import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import '../utils/platform_utils.dart';
import 'window_service.dart';

/// System tray service for desktop platforms
class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  bool _isInitialized = false;
  final WindowService _windowService = WindowService();

  VoidCallback? onShowWindow;
  VoidCallback? onQuitApp;
  VoidCallback? onToggleBlinkReminder;

  Future<void> initialize() async {
    if (!PlatformUtils.isDesktop || _isInitialized) return;

    try {
      // Set tray icon based on platform
      String iconPath;
      if (PlatformUtils.isWindows) {
        iconPath = 'assets/icons/app_icon.ico';
      } else {
        iconPath = 'assets/icons/app_icon.png';
      }

      await trayManager.setIcon(iconPath);
      await trayManager.setToolTip('Eye Care - Protecting your eyes');

      // Set up context menu
      await _setupContextMenu();

      trayManager.addListener(this);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize tray: $e');
    }
  }

  Future<void> _setupContextMenu() async {
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
  }

  @override
  void onTrayIconMouseDown() {
    _windowService.showFromTray();
    onShowWindow?.call();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
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
    }
  }

  Future<void> updateTooltip(String message) async {
    if (!PlatformUtils.isDesktop || !_isInitialized) return;
    await trayManager.setToolTip(message);
  }

  void dispose() {
    if (PlatformUtils.isDesktop && _isInitialized) {
      trayManager.removeListener(this);
      trayManager.destroy();
    }
  }
}
