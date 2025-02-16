import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/log.dart';
import '../../providers/log_form_provider.dart';

class DateTimePicker extends ConsumerWidget {
  final Log log;
  final String label;

  const DateTimePicker({
    super.key,
    required this.log,
    this.label = 'Time',
  });

  void _showPicker(BuildContext context, WidgetRef ref) {
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
            initialDateTime: log.startAt,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: false,
            onDateTimeChanged: (DateTime newTime) {
              ref.read(logFormProvider.notifier).updateLog(
                    log.copyWith(startAt: newTime),
                  );
            },
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day} '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} '
        '${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoFormSection.insetGrouped(
      header: Text(label),
      children: [
        CupertinoFormRow(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () => _showPicker(context, ref),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(_formatDateTime(log.startAt)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
