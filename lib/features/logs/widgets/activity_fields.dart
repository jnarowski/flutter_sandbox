import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import './shared/date_time_picker.dart';

class ActivityFields extends ConsumerStatefulWidget {
  final Log log;

  const ActivityFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<ActivityFields> createState() => _ActivityFieldsState();
}

class _ActivityFieldsState extends ConsumerState<ActivityFields> {
  final List<String> _activities = [
    'tummy time',
    'bath',
    'play',
    'reading',
    'walk',
    'massage',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log),
        const SizedBox(height: 16),

        // Activity type selector
        CupertinoFormSection.insetGrouped(
          header: const Text('Activity'),
          children: [
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: widget.log.category ?? _activities[0],
                children: {
                  for (final activity in _activities)
                    activity: Text(
                      activity[0].toUpperCase() + activity.substring(1),
                      textAlign: TextAlign.center,
                    ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    ref.read(logFormProvider.notifier)
                      ..updateLog(widget.log.copyWith(category: value))
                      ..setLastUsedCategory('activity', value);
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
