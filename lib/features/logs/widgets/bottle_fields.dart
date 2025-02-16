import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import './shared/date_time_picker.dart';

class BottleFields extends ConsumerStatefulWidget {
  final Log log;

  const BottleFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<BottleFields> createState() => _BottleFieldsState();
}

class _BottleFieldsState extends ConsumerState<BottleFields> {
  late final TextEditingController _amountController;

  final List<String> _subCategories = [
    'breast milk',
    'formula',
    'goat milk',
    "cow's milk",
    'tube feeding',
    'soy milk',
    'other'
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.log.amount?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateAmount(String value) {
    final amount = double.tryParse(value);
    ref.read(logFormProvider.notifier).updateLog(
          widget.log.copyWith(amount: amount),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log),
        const SizedBox(height: 16),
        // Subcategory selector
        CupertinoFormSection.insetGrouped(
          header: const Text('Type'),
          children: [
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: widget.log.subCategory ?? _subCategories[0],
                children: {
                  for (final category in _subCategories)
                    category: Text(
                      category
                          .split(' ')
                          .map((word) =>
                              word[0].toUpperCase() + word.substring(1))
                          .join(' '),
                      textAlign: TextAlign.center,
                    ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    ref.read(logFormProvider.notifier)
                      ..updateLog(widget.log.copyWith(subCategory: value))
                      ..setLastUsedCategory('feeding_sub', value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Amount and unit inputs
        CupertinoFormSection.insetGrouped(
          header: const Text('Amount'),
          children: [
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoTextField(
                controller: _amountController,
                placeholder: 'Enter amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: _updateAmount,
              ),
            ),
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: widget.log.unit ?? 'oz',
                children: const {
                  'oz': Text('oz'),
                  'ml': Text('ml'),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    ref.read(logFormProvider.notifier)
                      ..updateLog(widget.log.copyWith(unit: value))
                      ..setLastUsedUnit('feeding', value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
