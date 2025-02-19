import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../llm_response.dart';
import 'base_provider.dart';
import '../llm_options.dart';

class OpenAIProvider extends BaseLLMProvider {
  static const String defaultModel = 'gpt-3.5-turbo';

  OpenAIProvider({required super.apiKey});

  @override
  Future<LLMResponse> processMessage(
    String message,
    LLMOptions? options,
  ) async {
    try {
      final messages = [
        if (options?.systemMessage != null || options?.context != null)
          {
            'role': 'system',
            'content': _buildSystemMessage(options),
          },
        {
          'role': 'user',
          'content': message,
        },
      ];

      final stopwatch = Stopwatch()..start();
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': options?.model ?? defaultModel,
          'messages': messages,
          'max_tokens': options?.maxTokens ?? 1000,
          'temperature': options?.temperature ?? 0.7,
          if (options?.jsonResponse == true)
            'response_format': {'type': 'json_object'},
        }),
      );
      stopwatch.stop();

      if (response.statusCode != 200) {
        throw Exception('Failed to get response from OpenAI: ${response.body}');
      }

      final data = json.decode(response.body);
      return LLMResponse(
        text: data['choices'][0]['message']['content'],
        provider: 'openai',
        tokensUsed: data['usage']['total_tokens'],
        processingTime: stopwatch.elapsed,
        structuredData: options?.jsonResponse == true
            ? json.decode(data['choices'][0]['message']['content'])
            : _tryParseStructuredData(data['choices'][0]['message']['content']),
      );
    } catch (e) {
      print('OpenAI Error: $e');
      rethrow;
    }
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

  String _buildSystemMessage(LLMOptions? options) {
    final List<String> parts = [];

    if (options?.systemMessage != null) {
      parts.add('Instructions:\n${options!.systemMessage}');
    }

    if (options?.context != null) {
      parts.add('Available Context (JSON):\n${json.encode(options!.context)}');
    }

    return parts.join('\n\n==========\n\n');
  }
}
