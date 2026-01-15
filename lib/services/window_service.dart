import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../utils/platform_utils.dart';

/// Window management service for desktop platforms
class WindowService with WindowListener {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();

  bool _isInitialized = false;
  bool _isAlwaysOnTop = false;
  bool _wasHiddenBeforeOverlay = false;
  bool _isInOverlayMode = false;
  VoidCallback? onCloseRequested;

  bool get isAlwaysOnTop => _isAlwaysOnTop;
  bool get isInOverlayMode => _isInOverlayMode;

  Future<void> initialize() async {
    if (!PlatformUtils.isDesktop || _isInitialized) return;

    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(400, 700),
      minimumSize: Size(350, 500),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Eye Care',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    windowManager.addListener(this);
    _isInitialized = true;
  }

  Future<void> setAlwaysOnTop(bool value) async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.setAlwaysOnTop(value);
    _isAlwaysOnTop = value;
  }

  Future<void> toggleAlwaysOnTop() async {
    await setAlwaysOnTop(!_isAlwaysOnTop);
  }

  Future<void> minimizeToTray() async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.hide();
  }

  Future<void> minimize() async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.minimize();
  }

  Future<void> showFromTray() async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> focus() async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.focus();
  }

  Future<void> blur() async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.blur();
  }

  Future<bool> isMinimized() async {
    if (!PlatformUtils.isDesktop) return false;
    return await windowManager.isMinimized();
  }

  Future<bool> isVisible() async {
    if (!PlatformUtils.isDesktop) return true;
    return await windowManager.isVisible();
  }

  /// Enter overlay mode - shows fullscreen overlay on top of all windows.
  /// Tracks whether the window was hidden before so we can restore state after.
  Future<void> enterOverlayMode() async {
    if (!PlatformUtils.isDesktop) return;
    if (_isInOverlayMode) return; // Already in overlay mode

    // IMPORTANT: Check visibility BEFORE showing the window
    _wasHiddenBeforeOverlay = !(await windowManager.isVisible());
    _isInOverlayMode = true;

    // Show and prepare window for overlay
    await windowManager.show();
    await windowManager.setAlwaysOnTop(true);
    _isAlwaysOnTop = true;
    await windowManager.setFullScreen(true);
    await windowManager.focus();
  }

  /// Exit overlay mode - restores window to previous state.
  /// If window was hidden before overlay, it will be hidden again.
  ///
  /// On Windows, we need special handling because setFullScreen(false) triggers
  /// window restoration that can bring the app to foreground.
  /// Solution: Hide WHILE still in fullscreen, then exit fullscreen in background.
  Future<void> exitOverlayMode() async {
    if (!PlatformUtils.isDesktop) return;
    if (!_isInOverlayMode) return; // Not in overlay mode

    _isInOverlayMode = false;
    final shouldHide = _wasHiddenBeforeOverlay;

    if (PlatformUtils.isWindows && shouldHide) {
      // WINDOWS-SPECIFIC: Hide window WHILE STILL IN FULLSCREEN
      // This is the key - we hide before exiting fullscreen so the
      // window restoration happens while hidden and user never sees it.

      // First remove always-on-top
      await windowManager.setAlwaysOnTop(false);
      _isAlwaysOnTop = false;

      // Hide immediately while still in fullscreen
      await windowManager.hide();

      // Now exit fullscreen - window is already hidden so user won't see it
      await windowManager.setFullScreen(false);
    } else {
      // Non-Windows OR window was visible before - standard handling
      await windowManager.setAlwaysOnTop(false);
      _isAlwaysOnTop = false;
      await windowManager.setFullScreen(false);

      if (shouldHide) {
        await windowManager.hide();
      }
    }

    // Reset the flag
    _wasHiddenBeforeOverlay = false;
  }

  Future<void> setFullScreen(bool value) async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.setFullScreen(value);
  }

  Future<bool> isFullScreen() async {
    if (!PlatformUtils.isDesktop) return false;
    return await windowManager.isFullScreen();
  }

  Future<void> setOpacity(double opacity) async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.setOpacity(opacity);
  }

  Future<void> close() async {
    if (!PlatformUtils.isDesktop) return;
    await windowManager.close();
  }

  @override
  void onWindowClose() {
    onCloseRequested?.call();
  }

  @override
  void onWindowFocus() {}

  @override
  void onWindowBlur() {}

  @override
  void onWindowMaximize() {}

  @override
  void onWindowUnmaximize() {}

  @override
  void onWindowMinimize() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowResize() {}

  @override
  void onWindowMove() {}

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowLeaveFullScreen() {}

  void dispose() {
    if (PlatformUtils.isDesktop) {
      windowManager.removeListener(this);
    }
  }
}
