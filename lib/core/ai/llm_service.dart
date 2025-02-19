import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/openai_provider.dart';
import 'llm_response.dart';
import 'llm_options.dart';

class LLMService {
  final OpenAIProvider _openAIProvider;

  LLMService({
    required String openAIApiKey,
  }) : _openAIProvider = OpenAIProvider(apiKey: openAIApiKey);

  Future<LLMResponse> processMessage({
    required String message,
    LLMOptions? options,
  }) async {
    try {
      return await _openAIProvider.processMessage(message, options);
    } catch (e) {
      rethrow;
    }
  }
}

// Global instance
final llmService = LLMService(
  openAIApiKey: dotenv.env['OPENAI_API_KEY'] ?? '',
);
