import 'package:flutter/foundation.dart';

@immutable
class LogDataField {
  final String type;
  final bool isOptional;

  const LogDataField({
    required this.type,
    this.isOptional = false,
  });

  factory LogDataField.fromJson(dynamic json) {
    if (json is String) {
      return LogDataField(
        type: json.replaceAll('?', ''),
        isOptional: json.endsWith('?'),
      );
    }
    return LogDataField(
      type: json['type'],
      isOptional: json['optional'] ?? false,
    );
  }
}

@immutable
class LogTypeData {
  final Map<String, LogDataField> fields;

  const LogTypeData({required this.fields});

  factory LogTypeData.fromJson(Map<String, dynamic> json) {
    return LogTypeData(
      fields: Map.fromEntries(
        json.entries.map(
          (e) => MapEntry(e.key, LogDataField.fromJson(e.value)),
        ),
      ),
    );
  }
}

@immutable
class LogCategory {
  final List<String>? subCategories;
  final List<String>? units;
  final List<String> requiredFields;
  final LogTypeData? data;

  const LogCategory({
    this.subCategories,
    this.units,
    required this.requiredFields,
    this.data,
  });

  factory LogCategory.fromJson(Map<String, dynamic> json) {
    return LogCategory(
      subCategories: (json['subCategories'] as List?)?.cast<String>(),
      units: (json['units'] as List?)?.cast<String>(),
      requiredFields: (json['requiredFields'] as List).cast<String>(),
      data: json['data'] != null ? LogTypeData.fromJson(json['data']) : null,
    );
  }
}

@immutable
class LogType {
  final Map<String, LogCategory>? categories;
  final List<String>? requiredFields;
  final List<String>? optional;
  final Map<String, List<String>>? units;
  final LogTypeData? data;

  const LogType({
    this.categories,
    this.requiredFields,
    this.optional,
    this.units,
    this.data,
  });

  factory LogType.fromJson(Map<String, dynamic> json) {
    return LogType(
      categories: json['categories'] != null
          ? Map.fromEntries(
              (json['categories'] as Map<String, dynamic>).entries.map(
                    (e) => MapEntry(
                      e.key,
                      LogCategory.fromJson(e.value),
                    ),
                  ),
            )
          : null,
      requiredFields: (json['requiredFields'] as List?)?.cast<String>(),
      optional: (json['optional'] as List?)?.cast<String>(),
      units: json['units'] != null
          ? Map.fromEntries(
              (json['units'] as Map<String, dynamic>).entries.map(
                    (e) => MapEntry(e.key, (e.value as List).cast<String>()),
                  ),
            )
          : null,
      data: json['data'] != null ? LogTypeData.fromJson(json['data']) : null,
    );
  }
}

@immutable
class LogTypes {
  final Map<String, LogType> types;

  const LogTypes({required this.types});

  factory LogTypes.fromJson(Map<String, dynamic> json) {
    return LogTypes(
      types: Map.fromEntries(
        json.entries.map(
          (e) => MapEntry(e.key, LogType.fromJson(e.value)),
        ),
      ),
    );
  }

  static LogTypes get defaultTypes => LogTypes.fromJson(_defaultTypes);

  static Map<String, dynamic> get rawDefaultTypes => _defaultTypes;

  static const Map<String, dynamic> _defaultTypes = {
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
          'requiredFields': ['amount', 'unit', 'startAt']
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

  /// Converts the complex type structure into a simpler format for LLM consumption
  static Map<String, dynamic> get simplifiedTypes {
    return {
      'feeding': {
        'type': 'feeding',
        'categories': ['bottle', 'nursing'],
        'bottleTypes': [
          'formula',
          'breast milk',
          'goat milk',
          'cow milk',
          'tube feeding',
          'soy milk',
          'other'
        ],
        'units': ['oz', 'ml'],
        'nursingFields': {
          'durationLeft': 'number',
          'durationRight': 'number',
          'last': ['left', 'right']
        }
      },
      'sleep': {
        'type': 'sleep',
        'required': ['startAt', 'endAt'],
        'optional': ['notes']
      },
      'medicine': {
        'type': 'medicine',
        'categories': [
          'tylenol',
          'motrin',
          'ibuprofen',
          'acetaminophen',
          'other'
        ],
        'units': ['ml', 'mg'],
        'required': ['amount', 'unit', 'startAt', 'category']
      },
      'solids': {
        'type': 'solids',
        'required': ['startAt', 'food'],
        'food': 'string[]'
      },
      'activity': {
        'type': 'activity',
        'categories': ['tummy time', 'bath', 'play', 'reading', 'other'],
        'required': ['startAt', 'category'],
        'optional': ['endAt', 'amount', 'notes']
      },
      'diaper': {
        'type': 'diaper',
        'categories': ['wet', 'dirty', 'both'],
        'required': ['startAt', 'category']
      },
      'milestone': {
        'type': 'milestone',
        'required': ['startAt', 'description']
      },
      'measurement': {
        'type': 'measurement',
        'categories': ['weight', 'height', 'head'],
        'units': {
          'weight': ['lb', 'kg', 'oz', 'g'],
          'height': ['in', 'cm'],
          'head': ['in', 'cm']
        },
        'required': ['startAt', 'category', 'amount', 'unit']
      }
    };
  }
}
