import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise_model.dart';
import '../utils/constants.dart';
import '../widgets/figure_eight_animation.dart';

/// Screen for running eye training exercises
class ExerciseScreen extends StatefulWidget {
  final ExerciseType exerciseType;

  const ExerciseScreen({
    super.key,
    required this.exerciseType,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    // Keep screen awake during exercise
    WakelockPlus.enable();

    // Start the exercise
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().startExercise(widget.exerciseType);
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Consumer<ExerciseProvider>(
          builder: (context, exerciseProvider, child) {
            if (!exerciseProvider.isRunning) {
              // Exercise completed
              return _buildCompletionScreen(context);
            }

            return _buildExerciseScreen(context, exerciseProvider);
          },
        ),
      ),
    );
  }

  Widget _buildExerciseScreen(
      BuildContext context, ExerciseProvider provider) {
    final step = provider.currentStep;
    if (step == null) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _showExitDialog(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
                Text(
                  widget.exerciseType.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 48), // Balance the close button
              ],
            ),
            const SizedBox(height: 16),

            // Progress indicator
            LinearProgressIndicator(
              value: provider.progress,
              backgroundColor: AppColors.cardDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Text(
              'Step ${provider.currentStepIndex + 1} of ${provider.currentExercise!.steps.length}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),

            const Spacer(),

            // Animation area (for figure eight)
            if (step.showAnimation &&
                widget.exerciseType == ExerciseType.figureEight)
              const FigureEightAnimation(
                size: 300,
                duration: Duration(seconds: 4),
              )
            else
              _buildInstructionIcon(),

            const SizedBox(height: 32),

            // Instruction text
            Text(
              step.instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w300,
                height: 1.4,
              ),
            ),

            const Spacer(),

            // Timer display
            _buildTimerDisplay(provider.stepTimeRemaining),
            const SizedBox(height: 24),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pause/Resume button
                IconButton(
                  onPressed: () {
                    if (provider.isPaused) {
                      provider.resumeExercise();
                    } else {
                      provider.pauseExercise();
                    }
                  },
                  iconSize: 48,
                  icon: Icon(
                    provider.isPaused ? Icons.play_circle : Icons.pause_circle,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 24),
                // Skip button
                TextButton(
                  onPressed: provider.skipStep,
                  child: const Text('Skip Step'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionIcon() {
    IconData icon;
    Color color;

    switch (widget.exerciseType) {
      case ExerciseType.twentyTwentyTwenty:
        icon = Icons.visibility;
        color = const Color(0xFF64B5F6);
        break;
      case ExerciseType.focusShifting:
        icon = Icons.center_focus_strong;
        color = const Color(0xFF81C784);
        break;
      case ExerciseType.figureEight:
        icon = Icons.all_inclusive;
        color = const Color(0xFFFFB74D);
        break;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(60),
      ),
      child: Icon(
        icon,
        size: 64,
        color: color,
      ),
    );
  }

  Widget _buildTimerDisplay(int seconds) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            '$seconds',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'sec',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Exercise Complete!',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ve completed ${widget.exerciseType.title}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                context.read<ExerciseProvider>().stopExercise();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Stop Exercise?'),
        content: const Text(
          'Are you sure you want to stop this exercise?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ExerciseProvider>().stopExercise();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close exercise screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
