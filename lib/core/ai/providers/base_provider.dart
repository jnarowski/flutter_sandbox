import '../llm_options.dart';
import '../llm_response.dart';

abstract class BaseLLMProvider {
  final String apiKey;

  BaseLLMProvider({required this.apiKey});

  Future<LLMResponse> processMessage(String message, LLMOptions? options);
}
