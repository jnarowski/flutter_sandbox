import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import './shared/date_time_picker.dart';

class SolidsFields extends ConsumerStatefulWidget {
  final Log log;

  const SolidsFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<SolidsFields> createState() => _SolidsFieldsState();
}

class _SolidsFieldsState extends ConsumerState<SolidsFields> {
  final List<String> _foods = [
    'banana',
    'avocado',
    'apple',
    'pear',
    'sweet potato',
    'carrot',
    'peas',
    'other',
  ];

  final Map<String, String> _reactions = {
    'loved it': '😍',
    'meh': '😐',
    'hated it': '😖',
    'allergy': '⚠️',
  };

  // Add this map to store controllers
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    // Clean up controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Add this method to get or create a controller for an index
  TextEditingController _getControllerForIndex(int index, String initialText) {
    if (!_controllers.containsKey(index)) {
      _controllers[index] = TextEditingController(text: initialText);
    }
    return _controllers[index]!;
  }

  void _addFood() {
    final currentFoods = List<Map<String, dynamic>>.from(
        (widget.log.data?['foods'] as List<dynamic>?) ?? []);

    ref.read(logFormProvider.notifier).updateLog(
          widget.log.copyWith(
            data: {
              ...widget.log.data ?? {},
              'foods': [
                ...currentFoods,
                <String, dynamic>{'name': _foods[0], 'notes': ''},
              ],
            },
          ),
        );
  }

  void _removeFood(int index) {
    // Add this to dispose the controller when removing a food
    _controllers[index]?.dispose();
    _controllers.remove(index);

    final currentFoods = List<Map<String, dynamic>>.from(
        (widget.log.data?['foods'] as List<dynamic>?) ?? []);
    currentFoods.removeAt(index);

    ref.read(logFormProvider.notifier).updateLog(
          widget.log.copyWith(
            data: {
              ...widget.log.data ?? {},
              'foods': currentFoods,
            },
          ),
        );
  }

  void _updateFood(int index, String? name, String? notes) {
    final currentFoods = List<Map<String, dynamic>>.from(
        (widget.log.data?['foods'] as List<dynamic>?) ?? []);

    final updatedFood = <String, dynamic>{
      'name': name ?? currentFoods[index]['name'] as String,
      'notes': notes ?? currentFoods[index]['notes'] as String,
    };

    currentFoods[index] = updatedFood;

    ref.read(logFormProvider.notifier).updateLog(
          widget.log.copyWith(
            data: {
              ...widget.log.data ?? {},
              'foods': currentFoods,
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final foods = List<Map<String, dynamic>>.from(
        (widget.log.data?['foods'] as List<dynamic>?) ?? []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log),
        const SizedBox(height: 16),

        // Reaction selector
        CupertinoFormSection.insetGrouped(
          header: const Text('Reaction'),
          children: [
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: widget.log.category,
                children: _reactions.map(
                  (key, value) => MapEntry(key, Text(value)),
                ),
                onValueChanged: (value) {
                  if (value != null) {
                    ref.read(logFormProvider.notifier)
                      ..updateLog(widget.log.copyWith(category: value))
                      ..setLastUsedCategory('solids', value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Foods list
        CupertinoFormSection.insetGrouped(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Foods'),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _addFood,
                child: const Text('Add Food'),
              ),
            ],
          ),
          children: [
            for (var i = 0; i < foods.length; i++)
              Column(
                children: [
                  CupertinoFormRow(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoSlidingSegmentedControl<String>(
                            groupValue: foods[i]['name'] as String,
                            children: {
                              for (final food in _foods)
                                food: Text(
                                  food[0].toUpperCase() + food.substring(1),
                                ),
                            },
                            onValueChanged: (value) {
                              if (value != null) {
                                _updateFood(i, value, null);
                              }
                            },
                          ),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () => _removeFood(i),
                          child: const Icon(
                            CupertinoIcons.minus_circle_fill,
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoFormRow(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CupertinoTextField(
                      placeholder: 'Notes for ${foods[i]['name']}',
                      onChanged: (value) => _updateFood(i, null, value),
                      controller: _getControllerForIndex(
                        i,
                        foods[i]['notes'] as String? ?? '',
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
