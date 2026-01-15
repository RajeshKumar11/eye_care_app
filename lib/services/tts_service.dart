/// Text-to-Speech service for voice guidance
/// Currently uses stub implementation (TTS disabled)
/// To enable TTS on mobile, uncomment flutter_tts in pubspec.yaml
/// and use the mobile implementation

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  bool _isInitialized = false;
  bool _isEnabled = true;
  final bool _isSupported = false; // TTS not currently available

  bool get isEnabled => _isEnabled;
  bool get isSupported => _isSupported;

  Future<void> initialize() async {
    if (_isInitialized) return;
    // TTS is currently disabled - stub implementation
    _isInitialized = true;
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> speak(String text) async {
    // No-op - TTS disabled
  }

  Future<void> stop() async {
    // No-op - TTS disabled
  }

  Future<void> pause() async {
    // No-op - TTS disabled
  }

  Future<void> setRate(double rate) async {
    // No-op - TTS disabled
  }

  Future<void> setVolume(double volume) async {
    // No-op - TTS disabled
  }

  Future<void> dispose() async {
    // No-op - TTS disabled
  }
}
