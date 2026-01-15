import 'package:flutter_tts/flutter_tts.dart';
import '../utils/platform_utils.dart';

/// Mobile implementation of TTS service using flutter_tts
class TtsServiceImpl {
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isEnabled = true;
  bool _isSupported = false;

  bool get isEnabled => _isEnabled;
  bool get isSupported => _isSupported;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // TTS is supported on mobile platforms
    _isSupported = PlatformUtils.isMobile;

    if (!_isSupported) {
      _isInitialized = true;
      return;
    }

    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.45);
      await _flutterTts?.setVolume(0.8);
      await _flutterTts?.setPitch(1.0);
    } catch (e) {
      _isSupported = false;
    }

    _isInitialized = true;
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      stop();
    }
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || !_isSupported || _flutterTts == null) return;

    if (!_isInitialized) {
      await initialize();
    }

    await _flutterTts?.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts?.stop();
  }

  Future<void> pause() async {
    await _flutterTts?.pause();
  }

  Future<void> setRate(double rate) async {
    await _flutterTts?.setSpeechRate(rate);
  }

  Future<void> setVolume(double volume) async {
    await _flutterTts?.setVolume(volume);
  }

  Future<void> dispose() async {
    await _flutterTts?.stop();
  }
}
