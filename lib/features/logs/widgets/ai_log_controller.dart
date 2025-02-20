import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:flutter_sandbox/features/logs/llm_logging_provider.dart';
import 'package:flutter_sandbox/core/voice/voice_provider.dart';

class AILogController extends ChangeNotifier {
  final Ref ref;
  final TextEditingController textController = TextEditingController();

  bool isProcessing = false;
  bool isInitializing = true;
  bool isStopping = false;
  Log? log;

  AILogController(this.ref) {
    textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  bool get isValidText {
    final text = textController.text.trim();
    final wordCount = text.split(' ').where((word) => word.isNotEmpty).length;
    return wordCount >= 3;
  }

  Future<void> initializeSpeech() async {
    try {
      final voiceService = ref.read(voiceServiceProvider);

      final isAvailable = await voiceService.initialize();
      if (!isAvailable) {
        throw Exception('Speech recognition not available');
      }

      await Future.delayed(const Duration(milliseconds: 350));

      if (voiceService.isListening) {
        await voiceService.stopListening();
      }

      await voiceService.startListening(
        onTextUpdate: (text) {
          textController.text = text;
          notifyListeners();
        },
        onTextComplete: (text) {
          processAIRequest();
        },
      );
    } catch (e) {
      logger.error('Speech initialization error: $e');
      isInitializing = false;
      notifyListeners();
      rethrow;
    } finally {
      isInitializing = false;
      notifyListeners();
    }
  }

  // String _getKidId(Log parsedLog) {
  //   final appState = ref.read(appProvider);
  //   final kidId = parsedLog.kidId ?? appState.account?.currentKidId;
  //   if (kidId == null) {
  //     throw Exception(
  //         'No kid ID available - both parsed log and current kid ID are null');
  //   }
  //   return kidId;
  // }

  Future<void> processAIRequest() async {
    if (textController.text.isEmpty) return;

    isProcessing = true;
    notifyListeners();

    try {
      final llmLoggingService = ref.read(llmLoggingServiceProvider);
      final newLog =
          await llmLoggingService.parseAndCreateLog(textController.text);
      log = newLog;
      isProcessing = false;
      notifyListeners();
    } catch (e, stacktrace) {
      logger.error('AI Log Error: $e');
      logger.error('AI Log Stacktrace: $stacktrace');
      isProcessing = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> stopListening() async {
    isStopping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 50));
    final voiceService = ref.read(voiceServiceProvider);
    if (voiceService.isListening) {
      await voiceService.stopListening();
    }
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }
}

final aiLogControllerProvider = ChangeNotifierProvider.autoDispose((ref) {
  return AILogController(ref);
});
