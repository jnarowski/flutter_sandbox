import 'package:flutter_sandbox/core/ai/llm_options.dart';
import 'package:flutter_sandbox/core/ai/llm_service.dart';
import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:timezone/timezone.dart' as tz;

class LLMLoggingService {
  final LLMService _llmService = llmService;

  static const String _systemPrompt = '''
You are a helpful AI assistant that converts natural language descriptions of baby-related activities into structured log entries.

Rules:
1. Convert all times to ISO 8601 format using the provided timezone
2. If no time is specified, use the current time
3. For relative times (e.g. "5 minutes ago"), calculate based on current time
4. For feeding/nursing duration, estimate 15 minutes if not specified
5. For medicine, assume endAt is same as startAt
6. All numerical values should be converted to their base unit (ml, oz, minutes)
7. Match kid names to the provided kid IDs in context
8. If no kid is specified and there's only one kid, use that kid's ID

Required fields for all logs:
- kidId (string)
- type (string: sleep, formula, nursing, medicine)
- startAt (ISO 8601 datetime)
- endAt (ISO 8601 datetime, optional for medicine)
- amount (number, required for formula/medicine)
- duration (number, required for sleep/nursing)

Example inputs and outputs:
Input: "Oliver drank 5oz of formula at 4pm"
{
    "kidId": "<oliver_id>",
    "type": "formula",
    "amount": 5,
    "startAt": "2024-01-01T16:00:00Z",
    "endAt": "2024-01-01T16:15:00Z"
}

Input: "Oliver slept for 30 mins"
{
    "kidId": "<oliver_id>",
    "type": "sleep",
    "duration": 30,
    "startAt": "<current_time-30min>",
    "endAt": "<current_time>"
}

Respond with a single valid JSON object matching the schema.
''';

  Future<Log> parseLogFromText({
    required String text,
    required List<Kid> kids,
  }) async {
    final timezone = tz.local;
    final now = tz.TZDateTime.now(timezone);

    print('parseLogFromText');

    final context = {
      'current_time': now.toIso8601String(),
      'timezone': timezone.name,
      'kids': kids
          .map((Kid k) => {
                'id': k.id,
                'name': k.name,
              })
          .toList(),
      'log_types': LogType.values.map((e) => e.name).toList(),
    };

    final response = await _llmService.processMessage(
      message: text,
      options: LLMOptions(
        systemMessage: _systemPrompt,
        context: context,
        jsonResponse: true,
        model: 'gpt-3.5-turbo',
      ),
    );

    print('LLM Response:');
    print(response.text);

    // if (!response.success) {
    //   throw Exception('Failed to parse log: ${response.error}');
    // }

    return Log.fromMap({});
  }
}
