/// Eye Training Exercise Types
enum ExerciseType {
  twentyTwentyTwenty,
  focusShifting,
  figureEight,
}

extension ExerciseTypeExtension on ExerciseType {
  String get title {
    switch (this) {
      case ExerciseType.twentyTwentyTwenty:
        return 'The 20-20-20 Rule';
      case ExerciseType.focusShifting:
        return 'Focus Shifting';
      case ExerciseType.figureEight:
        return 'Figure Eight';
    }
  }

  String get description {
    switch (this) {
      case ExerciseType.twentyTwentyTwenty:
        return 'Every 20 minutes, look at something 20 feet away for 20 seconds.';
      case ExerciseType.focusShifting:
        return 'Shift your focus between near and far objects to exercise eye muscles.';
      case ExerciseType.figureEight:
        return 'Trace a figure eight pattern with your eyes to improve flexibility.';
    }
  }

  String get iconName {
    switch (this) {
      case ExerciseType.twentyTwentyTwenty:
        return 'visibility';
      case ExerciseType.focusShifting:
        return 'center_focus_strong';
      case ExerciseType.figureEight:
        return 'all_inclusive';
    }
  }

  int get durationSeconds {
    switch (this) {
      case ExerciseType.twentyTwentyTwenty:
        return 28;
      case ExerciseType.focusShifting:
        return 60;
      case ExerciseType.figureEight:
        return 40;
    }
  }
}

class ExerciseStep {
  final String instruction;
  final int durationSeconds;
  final String? ttsText;
  final bool showAnimation;

  const ExerciseStep({
    required this.instruction,
    required this.durationSeconds,
    this.ttsText,
    this.showAnimation = false,
  });
}

class Exercise {
  final ExerciseType type;
  final List<ExerciseStep> steps;

  const Exercise({
    required this.type,
    required this.steps,
  });

  int get totalDuration {
    return steps.fold(0, (sum, step) => sum + step.durationSeconds);
  }

  static Exercise get twentyTwentyTwenty => const Exercise(
        type: ExerciseType.twentyTwentyTwenty,
        steps: [
          ExerciseStep(
            instruction: 'Find an object about 20 feet (6 meters) away',
            durationSeconds: 5,
            ttsText: 'Find an object about 20 feet away from you.',
          ),
          ExerciseStep(
            instruction: 'Focus on the distant object\nRelax your eyes',
            durationSeconds: 20,
            ttsText: 'Now focus on that distant object for 20 seconds. Relax your eyes.',
          ),
          ExerciseStep(
            instruction: 'Great job!\nYour eyes are refreshed',
            durationSeconds: 3,
            ttsText: 'Great job! Your eyes are now refreshed.',
          ),
        ],
      );

  static Exercise get focusShifting => const Exercise(
        type: ExerciseType.focusShifting,
        steps: [
          ExerciseStep(
            instruction: 'Hold your thumb about 10 inches from your face',
            durationSeconds: 5,
            ttsText: 'Hold your thumb about 10 inches from your face.',
          ),
          ExerciseStep(
            instruction: 'Focus on your thumb',
            durationSeconds: 10,
            ttsText: 'Focus on your thumb for 10 seconds.',
          ),
          ExerciseStep(
            instruction: 'Now focus on something 10-20 feet away',
            durationSeconds: 10,
            ttsText: 'Now shift your focus to something 10 to 20 feet away.',
          ),
          ExerciseStep(
            instruction: 'Focus on your thumb again',
            durationSeconds: 10,
            ttsText: 'Shift your focus back to your thumb.',
          ),
          ExerciseStep(
            instruction: 'Look at a distant object',
            durationSeconds: 10,
            ttsText: 'Now look at a distant object again.',
          ),
          ExerciseStep(
            instruction: 'Return focus to your thumb',
            durationSeconds: 10,
            ttsText: 'Return your focus to your thumb one more time.',
          ),
          ExerciseStep(
            instruction: 'Exercise complete!\nWell done!',
            durationSeconds: 5,
            ttsText: 'Excellent! Exercise complete. Your eye muscles are now relaxed.',
          ),
        ],
      );

  static Exercise get figureEight => const Exercise(
        type: ExerciseType.figureEight,
        steps: [
          ExerciseStep(
            instruction: 'Imagine a large figure 8 on its side in front of you',
            durationSeconds: 5,
            ttsText: 'Imagine a large figure 8 lying on its side, about 10 feet in front of you.',
          ),
          ExerciseStep(
            instruction: 'Follow the dot with your eyes\nTracing the figure 8',
            durationSeconds: 30,
            ttsText: 'Follow the moving dot with your eyes. Trace the figure 8 slowly and smoothly.',
            showAnimation: true,
          ),
          ExerciseStep(
            instruction: 'Great job!\nYour eye flexibility has improved',
            durationSeconds: 5,
            ttsText: 'Great job! Your eye flexibility has improved.',
          ),
        ],
      );
}
