import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _disposed = false;

  final _soundLevelController = StreamController<double>.broadcast();
  Stream<double> get soundLevelStream => _soundLevelController.stream;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _isInitialized = await _speechToText.initialize(
      onError: (error) => debugPrint('Speech to text error: $error'),
      onStatus: (status) => debugPrint('Speech to text status: $status'),
      debugLogging: kDebugMode,
    );

    return _isInitialized;
  }

  Future<void> startListening({
    required void Function(String) onTextUpdate,
    required void Function(String) onTextComplete,
  }) async {
    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onTextComplete(result.recognizedWords);
        }

        onTextUpdate(result.recognizedWords);
      },
      onSoundLevelChange: (level) {
        _soundLevelController.add(level);
      },
      pauseFor: const Duration(seconds: 2),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
      ),
    );
  }

  Future<void> stopListening() async {
    if (_disposed) return;
    await _speechToText.stop();
    _soundLevelController.add(0);
  }

  void dispose() {
    print('disposing voice service...');

    _disposed = true;
    _speechToText.stop();
    _soundLevelController.close();
  }

  bool get isListening => _speechToText.isListening;
}
