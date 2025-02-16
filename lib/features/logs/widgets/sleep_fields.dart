import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import 'duration_timer.dart';

class SleepFields extends ConsumerStatefulWidget {
  final Log log;

  const SleepFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<SleepFields> createState() => _SleepFieldsState();
}

class _SleepFieldsState extends ConsumerState<SleepFields> {
  bool _isTimerRunning = false;
  bool _isManualEntry = false;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Initialize duration if editing existing log
    if (widget.log.endAt != null) {
      _duration = widget.log.endAt!.difference(widget.log.startAt);
      _isManualEntry = true;
    }
  }

  void _updateLogTimes(DateTime? start, DateTime? end) {
    final updatedLog = widget.log.copyWith(
      startAt: start ?? widget.log.startAt,
      endAt: end,
      amount: end?.difference(start ?? widget.log.startAt).inMinutes.toDouble(),
    );
    ref.read(logFormProvider.notifier).updateLog(updatedLog);
  }

  void _showTimePicker(bool isStartTime) {
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
            initialDateTime: isStartTime
                ? widget.log.startAt
                : widget.log.endAt ?? DateTime.now(),
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: false,
            onDateTimeChanged: (DateTime newTime) {
              if (isStartTime) {
                _updateLogTimes(newTime, widget.log.endAt);
              } else {
                _updateLogTimes(widget.log.startAt, newTime);
              }
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Entry mode selector
        CupertinoFormSection.insetGrouped(
          header: const Text('Entry Mode'),
          children: [
            CupertinoFormRow(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoSlidingSegmentedControl<bool>(
                groupValue: _isManualEntry,
                children: const {
                  false: Text('Timer'),
                  true: Text('Manual'),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _isManualEntry = value;
                      if (!value) {
                        // Reset end time when switching to timer
                        _updateLogTimes(widget.log.startAt, null);
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_isManualEntry)
          // Manual time entry
          CupertinoFormSection.insetGrouped(
            header: const Text('Sleep Time'),
            children: [
              CupertinoFormRow(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () => _showTimePicker(true),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start Time'),
                      Text(_formatDateTime(widget.log.startAt)),
                    ],
                  ),
                ),
              ),
              CupertinoFormRow(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () => _showTimePicker(false),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('End Time'),
                      if (widget.log.endAt != null)
                        Text(_formatDateTime(widget.log.endAt!))
                      else
                        const Text('Select Time'),
                    ],
                  ),
                ),
              ),
            ],
          )
        else
          // Timer mode
          Column(
            children: [
              DurationTimer(
                label: 'Sleep Duration',
                isRunning: _isTimerRunning,
                initialDuration: _duration,
                onDurationChanged: (duration) {
                  _duration = duration;
                  if (_isTimerRunning) {
                    _updateLogTimes(
                      widget.log.startAt,
                      widget.log.startAt.add(duration),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                onPressed: () {
                  setState(() {
                    _isTimerRunning = !_isTimerRunning;
                  });
                },
                child: Text(_isTimerRunning ? 'Stop' : 'Start'),
              ),
            ],
          ),

        if (widget.log.endAt != null) ...[
          const SizedBox(height: 16),
          Text(
            'Total Sleep: ${widget.log.endAt!.difference(widget.log.startAt).inMinutes} minutes',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
