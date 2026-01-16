import 'package:flutter_test/flutter_test.dart';
import 'package:eye_care_app/models/exercise_model.dart';

void main() {
  group('ExerciseType', () {
    test('has correct number of types', () {
      expect(ExerciseType.values.length, 3);
    });

    test('values are in correct order', () {
      expect(ExerciseType.values[0], ExerciseType.twentyTwentyTwenty);
      expect(ExerciseType.values[1], ExerciseType.focusShifting);
      expect(ExerciseType.values[2], ExerciseType.figureEight);
    });
  });

  group('ExerciseTypeExtension', () {
    test('title returns non-empty strings for all types', () {
      for (final type in ExerciseType.values) {
        expect(type.title.isNotEmpty, true);
      }
    });

    test('description returns non-empty strings for all types', () {
      for (final type in ExerciseType.values) {
        expect(type.description.isNotEmpty, true);
      }
    });

    test('iconName returns non-empty strings for all types', () {
      for (final type in ExerciseType.values) {
        expect(type.iconName.isNotEmpty, true);
      }
    });

    test('durationSeconds returns positive values for all types', () {
      for (final type in ExerciseType.values) {
        expect(type.durationSeconds, greaterThan(0));
      }
    });

    test('twentyTwentyTwenty has correct title', () {
      expect(ExerciseType.twentyTwentyTwenty.title, 'The 20-20-20 Rule');
    });

    test('focusShifting has correct title', () {
      expect(ExerciseType.focusShifting.title, 'Focus Shifting');
    });

    test('figureEight has correct title', () {
      expect(ExerciseType.figureEight.title, 'Figure Eight');
    });

    test('twentyTwentyTwenty duration is 28 seconds', () {
      expect(ExerciseType.twentyTwentyTwenty.durationSeconds, 28);
    });

    test('focusShifting duration is 60 seconds', () {
      expect(ExerciseType.focusShifting.durationSeconds, 60);
    });

    test('figureEight duration is 40 seconds', () {
      expect(ExerciseType.figureEight.durationSeconds, 40);
    });
  });

  group('ExerciseStep', () {
    test('creates with required parameters', () {
      const step = ExerciseStep(
        instruction: 'Test instruction',
        durationSeconds: 10,
      );

      expect(step.instruction, 'Test instruction');
      expect(step.durationSeconds, 10);
      expect(step.ttsText, isNull);
      expect(step.showAnimation, false);
    });

    test('creates with all parameters', () {
      const step = ExerciseStep(
        instruction: 'Test instruction',
        durationSeconds: 15,
        ttsText: 'TTS text',
        showAnimation: true,
      );

      expect(step.instruction, 'Test instruction');
      expect(step.durationSeconds, 15);
      expect(step.ttsText, 'TTS text');
      expect(step.showAnimation, true);
    });

    test('showAnimation defaults to false', () {
      const step = ExerciseStep(
        instruction: 'Test',
        durationSeconds: 5,
      );
      expect(step.showAnimation, false);
    });
  });

  group('Exercise', () {
    test('creates with required parameters', () {
      const exercise = Exercise(
        type: ExerciseType.twentyTwentyTwenty,
        steps: [],
      );

      expect(exercise.type, ExerciseType.twentyTwentyTwenty);
      expect(exercise.steps, isEmpty);
    });

    test('totalDuration calculates correctly for empty steps', () {
      const exercise = Exercise(
        type: ExerciseType.twentyTwentyTwenty,
        steps: [],
      );

      expect(exercise.totalDuration, 0);
    });

    test('totalDuration calculates correctly for single step', () {
      const exercise = Exercise(
        type: ExerciseType.twentyTwentyTwenty,
        steps: [
          ExerciseStep(instruction: 'Test', durationSeconds: 10),
        ],
      );

      expect(exercise.totalDuration, 10);
    });

    test('totalDuration calculates correctly for multiple steps', () {
      const exercise = Exercise(
        type: ExerciseType.twentyTwentyTwenty,
        steps: [
          ExerciseStep(instruction: 'Step 1', durationSeconds: 5),
          ExerciseStep(instruction: 'Step 2', durationSeconds: 10),
          ExerciseStep(instruction: 'Step 3', durationSeconds: 15),
        ],
      );

      expect(exercise.totalDuration, 30);
    });
  });

  group('Exercise static instances', () {
    test('twentyTwentyTwenty has correct type', () {
      final exercise = Exercise.twentyTwentyTwenty;
      expect(exercise.type, ExerciseType.twentyTwentyTwenty);
    });

    test('twentyTwentyTwenty has steps', () {
      final exercise = Exercise.twentyTwentyTwenty;
      expect(exercise.steps.isNotEmpty, true);
    });

    test('twentyTwentyTwenty totalDuration matches type duration', () {
      final exercise = Exercise.twentyTwentyTwenty;
      expect(exercise.totalDuration, ExerciseType.twentyTwentyTwenty.durationSeconds);
    });

    test('focusShifting has correct type', () {
      final exercise = Exercise.focusShifting;
      expect(exercise.type, ExerciseType.focusShifting);
    });

    test('focusShifting has steps', () {
      final exercise = Exercise.focusShifting;
      expect(exercise.steps.isNotEmpty, true);
    });

    test('focusShifting totalDuration matches type duration', () {
      final exercise = Exercise.focusShifting;
      expect(exercise.totalDuration, ExerciseType.focusShifting.durationSeconds);
    });

    test('figureEight has correct type', () {
      final exercise = Exercise.figureEight;
      expect(exercise.type, ExerciseType.figureEight);
    });

    test('figureEight has steps', () {
      final exercise = Exercise.figureEight;
      expect(exercise.steps.isNotEmpty, true);
    });

    test('figureEight totalDuration matches type duration', () {
      final exercise = Exercise.figureEight;
      expect(exercise.totalDuration, ExerciseType.figureEight.durationSeconds);
    });

    test('figureEight has animation step', () {
      final exercise = Exercise.figureEight;
      final hasAnimation = exercise.steps.any((step) => step.showAnimation);
      expect(hasAnimation, true);
    });
  });

  group('Exercise steps content', () {
    test('all twentyTwentyTwenty steps have positive duration', () {
      final exercise = Exercise.twentyTwentyTwenty;
      for (final step in exercise.steps) {
        expect(step.durationSeconds, greaterThan(0));
      }
    });

    test('all focusShifting steps have positive duration', () {
      final exercise = Exercise.focusShifting;
      for (final step in exercise.steps) {
        expect(step.durationSeconds, greaterThan(0));
      }
    });

    test('all figureEight steps have positive duration', () {
      final exercise = Exercise.figureEight;
      for (final step in exercise.steps) {
        expect(step.durationSeconds, greaterThan(0));
      }
    });

    test('all steps have non-empty instructions', () {
      final exercises = [
        Exercise.twentyTwentyTwenty,
        Exercise.focusShifting,
        Exercise.figureEight,
      ];

      for (final exercise in exercises) {
        for (final step in exercise.steps) {
          expect(step.instruction.isNotEmpty, true);
        }
      }
    });

    test('steps with TTS text have non-empty TTS text', () {
      final exercises = [
        Exercise.twentyTwentyTwenty,
        Exercise.focusShifting,
        Exercise.figureEight,
      ];

      for (final exercise in exercises) {
        for (final step in exercise.steps) {
          if (step.ttsText != null) {
            expect(step.ttsText!.isNotEmpty, true);
          }
        }
      }
    });
  });
}
