import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../llm_response.dart';
import 'base_provider.dart';

class OpenAIProvider extends BaseLLMProvider {
  OpenAIProvider({required super.apiKey});

  @override
  Future<LLMResponse> processMessage(
    String message,
    Map<String, dynamic>? options,
  ) async {
    final stopwatch = Stopwatch()..start();

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': options?['model'] ?? 'gpt-4-turbo-preview',
        'messages': [
          {
            'role': 'user',
            'content': message,
          }
        ],
        'max_tokens': options?['maxTokens'] ?? 1000,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get response from OpenAI: ${response.body}');
    }

    final data = json.decode(response.body);
    stopwatch.stop();

    return LLMResponse(
      text: data['choices'][0]['message']['content'],
      provider: 'openai',
      tokensUsed: data['usage']['total_tokens'],
      processingTime: stopwatch.elapsed,
      structuredData:
          _tryParseStructuredData(data['choices'][0]['message']['content']),
    );
  }

  Map<String, dynamic>? _tryParseStructuredData(String text) {
    try {
      // Attempt to find JSON-like content within the text
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        return json.decode(jsonMatch.group(0)!);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
