import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import './shared/date_time_picker.dart';

class GrowthFields extends ConsumerStatefulWidget {
  final Log log;

  const GrowthFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<GrowthFields> createState() => _GrowthFieldsState();
}

class _GrowthFieldsState extends ConsumerState<GrowthFields> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _headController;

  @override
  void initState() {
    super.initState();
    final data = widget.log.data ?? {};
    _heightController =
        TextEditingController(text: data['height']?.toString() ?? '');
    _weightController =
        TextEditingController(text: data['weight']?.toString() ?? '');
    _headController =
        TextEditingController(text: data['head']?.toString() ?? '');
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _headController.dispose();
    super.dispose();
  }

  void _updateMeasurements() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final head = double.tryParse(_headController.text);

    ref.read(logFormProvider.notifier).updateLog(
          widget.log.copyWith(
            data: {
              ...widget.log.data ?? {},
              'height': height,
              'weight': weight,
              'head': head,
              'heightUnit': widget.log.data?['heightUnit'] ?? 'in',
              'weightUnit': widget.log.data?['weightUnit'] ?? 'lb',
              'headUnit': widget.log.data?['headUnit'] ?? 'in',
            },
          ),
        );
  }

  void _showDateTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            initialDateTime: widget.log.startAt,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: false,
            onDateTimeChanged: (DateTime newTime) {
              ref.read(logFormProvider.notifier).updateLog(
                    widget.log.copyWith(startAt: newTime),
                  );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log),
        const SizedBox(height: 16),

        // Height
        CupertinoFormSection.insetGrouped(
          header: const Text('Height'),
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: _heightController,
                    placeholder: 'Enter height',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _updateMeasurements(),
                  ),
                ),
                const SizedBox(width: 16),
                CupertinoSlidingSegmentedControl<String>(
                  groupValue: widget.log.data?['heightUnit'] ?? 'in',
                  children: const {
                    'in': Text('in'),
                    'cm': Text('cm'),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(logFormProvider.notifier).updateLog(
                            widget.log.copyWith(
                              data: {
                                ...widget.log.data ?? {},
                                'heightUnit': value,
                              },
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Weight
        CupertinoFormSection.insetGrouped(
          header: const Text('Weight'),
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: _weightController,
                    placeholder: 'Enter weight',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _updateMeasurements(),
                  ),
                ),
                const SizedBox(width: 16),
                CupertinoSlidingSegmentedControl<String>(
                  groupValue: widget.log.data?['weightUnit'] ?? 'lb',
                  children: const {
                    'lb': Text('lb'),
                    'kg': Text('kg'),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(logFormProvider.notifier).updateLog(
                            widget.log.copyWith(
                              data: {
                                ...widget.log.data ?? {},
                                'weightUnit': value,
                              },
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Head Circumference
        CupertinoFormSection.insetGrouped(
          header: const Text('Head Circumference'),
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: _headController,
                    placeholder: 'Enter measurement',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _updateMeasurements(),
                  ),
                ),
                const SizedBox(width: 16),
                CupertinoSlidingSegmentedControl<String>(
                  groupValue: widget.log.data?['headUnit'] ?? 'in',
                  children: const {
                    'in': Text('in'),
                    'cm': Text('cm'),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(logFormProvider.notifier).updateLog(
                            widget.log.copyWith(
                              data: {
                                ...widget.log.data ?? {},
                                'headUnit': value,
                              },
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
