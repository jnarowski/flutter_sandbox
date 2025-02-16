import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../llm_response.dart';
import 'base_provider.dart';

class ClaudeProvider extends BaseLLMProvider {
  ClaudeProvider({required super.apiKey});

  @override
  Future<LLMResponse> processMessage(
    String message,
    Map<String, dynamic>? options,
  ) async {
    final stopwatch = Stopwatch()..start();

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: json.encode({
        'model': options?['model'] ?? 'claude-3-sonnet-20240229',
        'max_tokens': options?['maxTokens'] ?? 1000,
        'messages': [
          {
            'role': 'user',
            'content': message,
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get response from Claude: ${response.body}');
    }

    final data = json.decode(response.body);
    stopwatch.stop();

    return LLMResponse(
      text: data['content'][0]['text'],
      provider: 'claude',
      tokensUsed:
          data['usage']['output_tokens'] + data['usage']['input_tokens'],
      processingTime: stopwatch.elapsed,
      structuredData: _tryParseStructuredData(data['content'][0]['text']),
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
