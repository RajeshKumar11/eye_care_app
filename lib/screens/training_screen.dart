import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../utils/constants.dart';
import '../widgets/exercise_card.dart';
import 'exercise_screen.dart';

/// Screen displaying available eye training exercises
class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Training'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.self_improvement,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Train Your Eyes',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Regular exercises help reduce eye strain and improve focus',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Exercises section
            const Text(
              'Available Exercises',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Exercise cards
            ExerciseCard(
              exerciseType: ExerciseType.twentyTwentyTwenty,
              onTap: () => _startExercise(context, ExerciseType.twentyTwentyTwenty),
            ),
            ExerciseCard(
              exerciseType: ExerciseType.focusShifting,
              onTap: () => _startExercise(context, ExerciseType.focusShifting),
            ),
            ExerciseCard(
              exerciseType: ExerciseType.figureEight,
              onTap: () => _startExercise(context, ExerciseType.figureEight),
            ),

            const SizedBox(height: 24),

            // Tips section
            const Text(
              'Tips for Best Results',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _buildTipCard(
              icon: Icons.lightbulb_outline,
              title: 'Proper Lighting',
              description: 'Ensure your room has adequate lighting to reduce strain.',
            ),
            _buildTipCard(
              icon: Icons.remove_red_eye,
              title: 'Relax Your Eyes',
              description: 'Don\'t squint or strain. Let your eyes move naturally.',
            ),
            _buildTipCard(
              icon: Icons.schedule,
              title: 'Be Consistent',
              description: 'Practice daily for the best results.',
            ),
          ],
        ),
      ),
    );
  }

  void _startExercise(BuildContext context, ExerciseType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseScreen(exerciseType: type),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
