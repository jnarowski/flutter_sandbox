import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelligence/intelligence.dart';

class IntelligenceNotifier extends StateNotifier<List<String>> {
  final _intelligencePlugin = Intelligence();

  IntelligenceNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    try {
      _intelligencePlugin.selectionsStream().listen(_handleVoiceInput);
    } on PlatformException catch (e) {
      print('Intelligence plugin error: $e');
    }
  }

  void _handleVoiceInput(String message) {
    print('Voice message received: $message');
    state = [...state, message];
  }
}

final intelligenceProvider =
    StateNotifierProvider<IntelligenceNotifier, List<String>>((ref) {
  return IntelligenceNotifier();
});
