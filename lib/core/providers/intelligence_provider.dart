import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelligence/intelligence.dart';
import 'package:flutter_sandbox/core/services/logger.dart';

class IntelligenceNotifier extends StateNotifier<List<String>> {
  final _intelligencePlugin = Intelligence();

  IntelligenceNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    logger.i('Initializing Intelligence plugin');

    try {
      _intelligencePlugin.selectionsStream().listen(_handleVoiceInput);
    } on PlatformException catch (e) {
      logger.e('Intelligence plugin error: $e');
    }
  }

  void _handleVoiceInput(String message) {
    state = [message, ...state];
  }
}

final intelligenceProvider =
    StateNotifierProvider<IntelligenceNotifier, List<String>>((ref) {
  return IntelligenceNotifier();
});
