import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_sandbox/features/logs/llm_logging_service.dart';

part 'llm_logging_provider.g.dart';

@riverpod
LLMLoggingService llmLoggingService(ref) {
  return LLMLoggingService();
}
