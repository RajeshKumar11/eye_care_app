import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../utils/constants.dart';

/// Card widget for displaying an exercise option
class ExerciseCard extends StatelessWidget {
  final ExerciseType exerciseType;
  final VoidCallback onTap;

  const ExerciseCard({
    super.key,
    required this.exerciseType,
    required this.onTap,
  });

  IconData get _icon {
    switch (exerciseType) {
      case ExerciseType.twentyTwentyTwenty:
        return Icons.visibility;
      case ExerciseType.focusShifting:
        return Icons.center_focus_strong;
      case ExerciseType.figureEight:
        return Icons.all_inclusive;
    }
  }

  Color get _iconColor {
    switch (exerciseType) {
      case ExerciseType.twentyTwentyTwenty:
        return const Color(0xFF64B5F6);
      case ExerciseType.focusShifting:
        return const Color(0xFF81C784);
      case ExerciseType.figureEight:
        return const Color(0xFFFFB74D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _icon,
                  color: _iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseType.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exerciseType.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Duration badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${exerciseType.durationSeconds}s',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textHint,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
