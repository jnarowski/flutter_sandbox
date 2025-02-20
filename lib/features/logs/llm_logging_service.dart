import 'package:flutter_sandbox/core/ai/llm_options.dart';
import 'package:flutter_sandbox/core/ai/llm_service.dart';
import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:uuid/uuid.dart';

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
9. Never use 'Z' suffix in timestamps - always use the provided timezone offset

Fields for all logs:
- kidId (string - required) - find the closest match to the kid's name from the kids in the context
- type (string - required: possible values: sleep, formula, nursing, medicine)
- startAt (ISO 8601 datetime - required)
- endAt (ISO 8601 datetime, required for sleep)
- amount (number, required for formula/medicine)
- duration (number, required for sleep/nursing

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

  DateTime parseToUTC(String localTimeStr) {
    // Parse the ISO 8601 string directly - DateTime.parse handles the timezone offset automatically
    return DateTime.parse(localTimeStr).toUtc();
  }

  Future<Log> parseLogFromText({
    required String text,
    required List<Kid> kids,
  }) async {
    final timezone = 'America/Denver';
    final now = DateTime.now();

    final context = {
      'current_time': now.toIso8601String(),
      'timezone': timezone,
      'kids': kids
          .map((Kid k) => {
                'id': k.id,
                'name': k.name,
              })
          .toList(),
      'log_types': LogType.values.map((e) => e.name).toList(),
    };

    print('context: $context');

    final response = await _llmService.processMessage(
      message: text,
      options: LLMOptions(
        systemMessage: _systemPrompt,
        context: context,
        jsonResponse: true,
        model: 'gpt-4o',
      ),
    );

    print('LLM Query:');
    print(text);
    print('...');
    print('LLM Response:');
    print(response.text);

    // if (!response.success) {
    //   throw Exception('Failed to parse log: ${response.error}');
    // }

    final log = Log(
      id: Uuid().v4(),
      kidId: response.structuredData?['kidId'] as String?,
      type: response.structuredData?['type'] as String,
      startAt: parseToUTC(response.structuredData?['startAt']),
      endAt: parseToUTC(response.structuredData?['endAt']),
      amount: (response.structuredData?['amount'] as num?)?.toDouble(),
    );

    print('log: $log');
    print('log.kidId: ${log.kidId}');
    print('log.type: ${log.type}');
    print('log.startAt: ${log.startAt}');
    print('log.endAt: ${log.endAt}');

    return log;
  }
}
