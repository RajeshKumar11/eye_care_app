import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart' as overlay;
import 'providers/settings_provider.dart';
import 'providers/eye_care_provider.dart';
import 'providers/exercise_provider.dart';
import 'services/storage_service.dart';
import 'services/tts_service.dart';
import 'services/window_service.dart';
import 'services/tray_service.dart';
import 'services/background_service.dart';
import 'utils/constants.dart';
import 'utils/platform_utils.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService().initialize();
  await TtsService().initialize();

  // Initialize background service for scheduled notifications
  if (PlatformUtils.isAndroid) {
    await BackgroundService().initialize();
  }

  // Initialize desktop-specific services
  if (PlatformUtils.isDesktop) {
    await WindowService().initialize();
    await TrayService().initialize();
  }

  runApp(const EyeCareApp());
}

/// Entry point for the overlay window
/// This runs as a separate Flutter engine on top of other apps
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlinkOverlayWidget(),
  ));
}

class EyeCareApp extends StatefulWidget {
  const EyeCareApp({super.key});

  @override
  State<EyeCareApp> createState() => _EyeCareAppState();
}

class _EyeCareAppState extends State<EyeCareApp> with WidgetsBindingObserver {
  final BackgroundService _backgroundService = BackgroundService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // App starts in foreground
    _backgroundService.setAppInForeground(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Track whether app is in foreground or background
    if (state == AppLifecycleState.resumed) {
      _backgroundService.setAppInForeground(true);
    } else if (state == AppLifecycleState.paused ||
               state == AppLifecycleState.inactive ||
               state == AppLifecycleState.hidden) {
      _backgroundService.setAppInForeground(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => EyeCareProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}

/// The black screen overlay widget shown on top of other apps
class BlinkOverlayWidget extends StatefulWidget {
  const BlinkOverlayWidget({super.key});

  @override
  State<BlinkOverlayWidget> createState() => _BlinkOverlayWidgetState();
}

class _BlinkOverlayWidgetState extends State<BlinkOverlayWidget>
    with SingleTickerProviderStateMixin {
  int _countdown = 3;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the eye icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // Start countdown
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        _timer = null;
        _closeOverlay();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _closeOverlay() async {
    try {
      // Stop animation before closing
      _pulseController.stop();

      // Close the overlay
      final isActive = await overlay.FlutterOverlayWindow.isActive();
      if (isActive) {
        await overlay.FlutterOverlayWindow.closeOverlay();
      }
    } catch (e) {
      // Force close on error
      try {
        await overlay.FlutterOverlayWindow.closeOverlay();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _closeOverlay,
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated eye icon
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.eyeIconColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: AppColors.eyeIconColor.withAlpha(100),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: AppColors.eyeIconColor,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Blink message
                    const Text(
                      'BLINK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rest your eyes',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Countdown
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(100),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$_countdown',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _countdown == 1 ? 'second' : 'seconds',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Skip hint at bottom
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Tap anywhere to skip',
                    style: TextStyle(
                      color: AppColors.textHint.withAlpha(150),
                      fontSize: 11,
                    ),
                  ),
                ),
              ),

              // Progress bar at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _countdown / 3,
                  backgroundColor: AppColors.cardDark,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withAlpha(180),
                  ),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
