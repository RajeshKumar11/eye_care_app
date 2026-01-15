import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/window_service.dart';

/// Full black screen blink reminder with countdown
class BlinkReminderScreen extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const BlinkReminderScreen({
    super.key,
    this.durationSeconds = 3,
    this.onComplete,
    this.onSkip,
  });

  @override
  State<BlinkReminderScreen> createState() => _BlinkReminderScreenState();
}

class _BlinkReminderScreenState extends State<BlinkReminderScreen>
    with SingleTickerProviderStateMixin {
  late int _countdown;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final WindowService _windowService = WindowService();

  @override
  void initState() {
    super.initState();
    _countdown = widget.durationSeconds;

    // Pulse animation for the eye icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // Make window fullscreen and always on top for desktop
    // Uses centralized WindowService to track visibility state
    _windowService.enterOverlayMode();

    // Start countdown
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        _handleComplete();
      }
    });
  }

  void _handleComplete() {
    _windowService.exitOverlayMode();
    widget.onComplete?.call();
  }

  void _handleSkip() {
    _timer?.cancel();
    _windowService.exitOverlayMode();
    widget.onSkip?.call();
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
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleSkip,
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
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.eyeIconColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(60),
                          border: Border.all(
                            color: AppColors.eyeIconColor.withAlpha(100),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: AppColors.eyeIconColor,
                          size: 56,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Blink message
                    const Text(
                      'BLINK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rest your eyes',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Countdown
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(40),
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
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _countdown == 1 ? 'second' : 'seconds',
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Skip hint at bottom
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Tap anywhere to skip',
                    style: TextStyle(
                      color: AppColors.textHint.withAlpha(150),
                      fontSize: 12,
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
                  value: _countdown / widget.durationSeconds,
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

/// Overlay container for blink reminder screen
class BlinkOverlayContainer extends StatelessWidget {
  final bool visible;
  final int countdown;
  final VoidCallback? onDismiss;

  const BlinkOverlayContainer({
    super.key,
    required this.visible,
    this.countdown = 3,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned.fill(
      child: BlinkReminderScreen(
        durationSeconds: countdown,
        onComplete: onDismiss,
        onSkip: onDismiss,
      ),
    );
  }
}
