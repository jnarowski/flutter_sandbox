import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'providers/claude_provider.dart';
import 'providers/openai_provider.dart';
import 'llm_response.dart';

enum LLMProvider {
  claude,
  openAI,
}

class LLMService {
  final ClaudeProvider _claudeProvider;
  final OpenAIProvider _openAIProvider;
  final LLMProvider defaultProvider;

  LLMService({
    required this.defaultProvider,
    required String claudeApiKey,
    required String openAIApiKey,
  })  : _claudeProvider = ClaudeProvider(apiKey: claudeApiKey),
        _openAIProvider = OpenAIProvider(apiKey: openAIApiKey);

  Future<LLMResponse> processMessage({
    required String message,
    LLMProvider? provider,
    Map<String, dynamic>? options,
  }) async {
    final selectedProvider = provider ?? defaultProvider;

    try {
      switch (selectedProvider) {
        case LLMProvider.claude:
          return await _claudeProvider.processMessage(message, options);
        case LLMProvider.openAI:
          return await _openAIProvider.processMessage(message, options);
      }
    } catch (e) {
      // If primary provider fails, try fallback
      if (selectedProvider == defaultProvider) {
        final fallbackProvider = selectedProvider == LLMProvider.claude
            ? LLMProvider.openAI
            : LLMProvider.claude;

        return await processMessage(
          message: message,
          provider: fallbackProvider,
          options: options,
        );
      }
      rethrow;
    }
  }
}

// Global instance
final llmService = LLMService(
  defaultProvider: LLMProvider.openAI,
  claudeApiKey: dotenv.env['CLAUDE_API_KEY'] ?? '',
  openAIApiKey: dotenv.env['OPENAI_API_KEY'] ?? '',
);
