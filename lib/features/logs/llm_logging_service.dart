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
8. Never use 'Z' suffix in timestamps - always use the provided timezone offset

Log fields:
- kidId (string - required) - find the closest match to the kid's name from the kids in the context
- type (string - required: possible values: sleep, formula, nursing, medicine)
- startAt (ISO 8601 datetime - required)
- endAt (ISO 8601 datetime, optional)
- amount (number, required for formula/medicine)
- data (object, optional, used only for solids and pumping)

Example inputs and outputs:

Input: "Oliver nursed for 10 mins on the left and then 5 on the right at 4pm"
{
    "kidId": "<oliver_id>",
    "type": "feeding",
    "category": "nursing", // possible values: bottle, nursing
    "amount": 5,
    "startAt": "2024-01-01T16:00:00Z",
    "data": {
        "durationLeft": 10,
        "durationRight": 5,
        "last": "right"
    }
} 

Input: "Oliver drank 5oz of formula at 4pm"
{
    "kidId": "<oliver_id>",
    "type": "feeding",
    "category": "bottle", // possible values: bottle, nursing
    "subCategory": "formula", // possible values: breast milk, goat milk, cow's milk, formula, tube feeding, soy milk, other
    "amount": 5,
    "unit": "oz",
    "startAt": "2024-01-01T16:00:00Z",
}

Input: "Oliver slept for 30 mins"
{
    "kidId": "<oliver_id>",
    "type": "sleep",
    "amount": 30,
    "startAt": "<current_time-30min>",
    "endAt": "<current_time>"
}

Input: "Oliver ate avacado and banana"
{
    "kidId": "<oliver_id>",
    "type": "solids",
    "startAt": "<current_time>",
    "data": {
        "food": ["avacado", "banana"]
    }
}

Input: "Oliver did Tummy Time for 10 mins"
{
    "kidId": "<oliver_id>",
    "type": "activity",
    "category": "tummy time",
    "startAt": "<current_time-10min>",
    "endAt": "<current_time>",
    "amount": 10
}

Input: "Oliver had 2.5ml of tylenol"
{
    "kidId": "<oliver_id>",
    "type": "medicine",
    "amount": 2.5,
    "unit": "ml",
    "category": "tylenol",
    "startAt": "<current_time>",
    "data": {
        "food": ["avacado", "banana"]
    }
}

Respond with a single valid JSON object matching the schema.
''';

  DateTime? parseToUTC(String? localTimeStr) {
    if (localTimeStr == null) {
      return null;
    }
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
      'types': LogType.values.map((e) => e.name).toList(),
    };

    print('LLM CONTEXT');
    print(context);
    print('.................');

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
    print('.................');
    print('LLM Response:');
    print(response.text);
    print('.................');

    final log = Log(
      id: Uuid().v4(),
      kidId: response.structuredData?['kidId'] as String?,
      type: response.structuredData?['type'] as String,
      startAt:
          parseToUTC(response.structuredData?['startAt']) ?? DateTime.now(),
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
