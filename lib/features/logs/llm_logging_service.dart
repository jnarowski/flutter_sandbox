import 'package:flutter_sandbox/core/ai/llm_options.dart';
import 'package:flutter_sandbox/core/ai/llm_service.dart';
import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_sandbox/features/logs/models/log_types.dart';

class LLMLoggingService {
  final LLMService _llmService = llmService;
  // final LogTypes logTypes = LogTypes.defaultTypes;

  // I want to provide all the possible context to the @llm_logging_service.dart for all possible options. I don't want it to make up a value that isn't present.
  //
  // I want the structure to be like this:
  // {
  //    'types': {
  //       'feeding': {
  //          categories: {
  //             '
  //          }
  //       }
  //    }
  // }
  static const Map<String, dynamic> logTypes = {
    'feeding': {
      'categories': {
        'bottle': {
          'subCategories': [
            'formula',
            'breast milk',
            'goat milk',
            'cow milk',
            'tube feeding',
            'soy milk',
            'other'
          ],
          'units': ['oz', 'ml'],
          'requiredFields': ['amount', 'unit']
        },
        'nursing': {
          'requiredFields': ['startAt', 'data'],
          'data': {
            'durationLeft': 'number?',
            'durationRight': 'number?',
            'last': ['left', 'right']
          }
        }
      }
    },
    'sleep': {
      'requiredFields': ['startAt', 'endAt'],
      'optional': ['notes']
    },
    'medicine': {
      'categories': [
        'tylenol',
        'motrin',
        'ibuprofen',
        'acetaminophen',
        'other'
      ],
      'units': ['ml', 'mg'],
      'requiredFields': ['amount', 'unit', 'startAt', 'category']
    },
    'solids': {
      'requiredFields': ['startAt', 'data'],
      'data': {'food': 'string[]'}
    },
    'activity': {
      'categories': ['tummy time', 'bath', 'play', 'reading', 'other'],
      'requiredFields': ['startAt', 'category'],
      'optional': ['endAt', 'amount', 'notes']
    },
    'diaper': {
      'categories': ['wet', 'dirty', 'both'],
      'requiredFields': ['startAt', 'category']
    },
    'milestone': {
      'requiredFields': ['startAt', 'description']
    },
    'measurement': {
      'categories': ['weight', 'height', 'head'],
      'units': {
        'weight': ['lb', 'kg', 'oz', 'g'],
        'height': ['in', 'cm'],
        'head': ['in', 'cm']
      },
      'requiredFields': ['startAt', 'category', 'amount', 'unit']
    }
  };

  static const String _systemPrompt = '''
You are a helpful AI assistant that converts natural language descriptions of baby-related activities into structured log entries.

Rules:
1. Convert all times to ISO 8601 format using the provided timezone
2. If no startAt time is specified, use the current time
3. For relative times (e.g. "5 minutes ago"), calculate based on current time
4. Only use categories and values that are explicitly defined in the context.logTypes
5. All numerical values should be converted to their base unit (ml, oz, minutes)
6. Match kid names to the provided kid IDs in context
7. Never use 'Z' suffix in timestamps - always use the provided timezone offset
8. Ensure all required fields for the determined type and it's category are present
9. Do not make up or assume values that aren't explicitly mentioned
10. If critical required information is missing, return an error object instead

The context provides:
- current_time: The current time in ISO 8601
- timezone: The user's timezone
- kids: Array of {id, name} objects for matching names
- logTypes: Complete schema of all valid log types and their options. 

Log fields:
- kidId (string - required) - find the closest match to the kid's name from the kids in the context
- type (string - required: possible values: sleep, formula, nursing, medicine)
- startAt (ISO 8601 datetime - required)
- endAt (ISO 8601 datetime, optional)
- amount (number, required for formula/medicine)
- data (object, optional, use this field ONLY for solids and pumping)

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

Example response for missing required information:
{
    "error": "Missing required field: amount for medicine type"
}

Respond with either a valid JSON object matching the schema or an error object.
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
      'logTypes': LogTypes.simplifiedTypes,
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
