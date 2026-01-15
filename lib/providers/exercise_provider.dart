import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';
import '../services/tts_service.dart';

/// Provider for managing eye training exercises
class ExerciseProvider extends ChangeNotifier {
  final TtsService _ttsService = TtsService();

  Exercise? _currentExercise;
  int _currentStepIndex = 0;
  int _stepTimeRemaining = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  Timer? _timer;

  Exercise? get currentExercise => _currentExercise;
  int get currentStepIndex => _currentStepIndex;
  int get stepTimeRemaining => _stepTimeRemaining;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  ExerciseStep? get currentStep {
    if (_currentExercise == null ||
        _currentStepIndex >= _currentExercise!.steps.length) {
      return null;
    }
    return _currentExercise!.steps[_currentStepIndex];
  }

  double get progress {
    if (_currentExercise == null) return 0;
    final totalSteps = _currentExercise!.steps.length;
    if (totalSteps == 0) return 0;
    return (_currentStepIndex + 1) / totalSteps;
  }

  int get totalTimeRemaining {
    if (_currentExercise == null) return 0;
    int remaining = _stepTimeRemaining;
    for (int i = _currentStepIndex + 1; i < _currentExercise!.steps.length; i++) {
      remaining += _currentExercise!.steps[i].durationSeconds;
    }
    return remaining;
  }

  void startExercise(ExerciseType type) {
    switch (type) {
      case ExerciseType.twentyTwentyTwenty:
        _currentExercise = Exercise.twentyTwentyTwenty;
        break;
      case ExerciseType.focusShifting:
        _currentExercise = Exercise.focusShifting;
        break;
      case ExerciseType.figureEight:
        _currentExercise = Exercise.figureEight;
        break;
    }

    _currentStepIndex = 0;
    _isRunning = true;
    _isPaused = false;
    _startCurrentStep();
    notifyListeners();
  }

  void _startCurrentStep() {
    if (_currentExercise == null ||
        _currentStepIndex >= _currentExercise!.steps.length) {
      _completeExercise();
      return;
    }

    final step = _currentExercise!.steps[_currentStepIndex];
    _stepTimeRemaining = step.durationSeconds;

    // Speak instruction if TTS is enabled and text is available
    if (step.ttsText != null) {
      _ttsService.speak(step.ttsText!);
    }

    notifyListeners();
    _startStepTimer();
  }

  void _startStepTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      _stepTimeRemaining--;
      notifyListeners();

      if (_stepTimeRemaining <= 0) {
        timer.cancel();
        _moveToNextStep();
      }
    });
  }

  void _moveToNextStep() {
    _currentStepIndex++;
    if (_currentStepIndex < (_currentExercise?.steps.length ?? 0)) {
      _startCurrentStep();
    } else {
      _completeExercise();
    }
  }

  void _completeExercise() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _isPaused = false;
    notifyListeners();
  }

  void pauseExercise() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    _ttsService.pause();
    notifyListeners();
  }

  void resumeExercise() {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    notifyListeners();
  }

  void stopExercise() {
    _timer?.cancel();
    _timer = null;
    _currentExercise = null;
    _currentStepIndex = 0;
    _stepTimeRemaining = 0;
    _isRunning = false;
    _isPaused = false;
    _ttsService.stop();
    notifyListeners();
  }

  void skipStep() {
    if (!_isRunning) return;
    _timer?.cancel();
    _ttsService.stop();
    _moveToNextStep();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ttsService.stop();
    super.dispose();
  }
}
