import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import './shared/date_time_picker.dart';

class MedicineFields extends ConsumerStatefulWidget {
  final Log log;

  const MedicineFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<MedicineFields> createState() => _MedicineFieldsState();
}

class _MedicineFieldsState extends ConsumerState<MedicineFields> {
  late final TextEditingController _amountController;

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
        DateTimePicker(log: widget.log, label: 'Time Given'),
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
                groupValue: widget.log.unit ?? 'ml',
                children: const {
                  'ml': Text('ml'),
                  'drops': Text('drops'),
                  'tsp': Text('tsp'),
                  'oz': Text('oz'),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    ref.read(logFormProvider.notifier)
                      ..updateLog(widget.log.copyWith(unit: value))
                      ..setLastUsedUnit('medicine', value);
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
