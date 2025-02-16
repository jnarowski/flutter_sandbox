import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import './shared/date_time_picker.dart';

class BathroomFields extends ConsumerStatefulWidget {
  final Log log;

  const BathroomFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<BathroomFields> createState() => _BathroomFieldsState();
}

class _BathroomFieldsState extends ConsumerState<BathroomFields> {
  final Map<String, List<String>> _subCategories = {
    'diaper': ['pee', 'poo', 'mixed', 'dry'],
    'potty': ['sat but dry', 'potty', 'accident'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log),
        const SizedBox(height: 16),

        // Category selector
        CupertinoFormSection.insetGrouped(
          header: const Text('Type'),
          children: [
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: widget.log.category ?? 'diaper',
                children: const {
                  'diaper': Text('Diaper'),
                  'potty': Text('Potty'),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    ref.read(logFormProvider.notifier)
                      ..updateLog(widget.log.copyWith(
                        category: value,
                        subCategory: _subCategories[value]?[0],
                      ))
                      ..setLastUsedCategory('bathroom', value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Subcategory selector
        if (widget.log.category != null)
          CupertinoFormSection.insetGrouped(
            header: Text(
                '${widget.log.category == 'diaper' ? 'Diaper' : 'Potty'} Type'),
            children: [
              CupertinoFormRow(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CupertinoSlidingSegmentedControl<String>(
                  groupValue: widget.log.subCategory ??
                      _subCategories[widget.log.category]?[0],
                  children: {
                    for (final subCategory
                        in _subCategories[widget.log.category] ?? [])
                      subCategory: Text(
                        subCategory[0].toUpperCase() + subCategory.substring(1),
                      ),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(logFormProvider.notifier)
                        ..updateLog(widget.log.copyWith(subCategory: value))
                        ..setLastUsedCategory('bathroom_sub', value);
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
