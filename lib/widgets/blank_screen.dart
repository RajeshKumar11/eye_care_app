import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/window_service.dart';

/// Full black screen for eye rest breaks
class BlankScreen extends StatefulWidget {
  final int countdown;
  final VoidCallback? onSkip;

  const BlankScreen({
    super.key,
    required this.countdown,
    this.onSkip,
  });

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  final WindowService _windowService = WindowService();

  @override
  void initState() {
    super.initState();
    // Uses centralized WindowService to track visibility state
    _windowService.enterOverlayMode();
  }

  void _handleSkip() {
    _windowService.exitOverlayMode();
    widget.onSkip?.call();
  }

  @override
  void dispose() {
    // Ensure we exit overlay mode when disposed
    _windowService.exitOverlayMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            // Main content - centered countdown
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Eye icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.cardDark.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.visibility_off,
                      color: AppColors.textSecondary,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Message
                  const Text(
                    'Rest Your Eyes',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Countdown
                  Text(
                    '${widget.countdown}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'seconds remaining',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Skip button at bottom
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  onPressed: _handleSkip,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            // Progress indicator at top
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: widget.countdown > 0 ? 1.0 : 0.0,
                backgroundColor: AppColors.cardDark,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overlay wrapper for blank screen
class BlankScreenOverlay extends StatelessWidget {
  final bool visible;
  final int countdown;
  final VoidCallback? onSkip;

  const BlankScreenOverlay({
    super.key,
    required this.visible,
    required this.countdown,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned.fill(
      child: BlankScreen(
        countdown: countdown,
        onSkip: onSkip,
      ),
    );
  }
}
