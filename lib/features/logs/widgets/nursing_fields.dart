import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import 'duration_timer.dart';
import './shared/date_time_picker.dart';

class NursingFields extends ConsumerStatefulWidget {
  final Log log;

  const NursingFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<NursingFields> createState() => _NursingFieldsState();
}

class _NursingFieldsState extends ConsumerState<NursingFields> {
  bool _isLeftRunning = false;
  bool _isRightRunning = false;
  Duration _leftDuration = Duration.zero;
  Duration _rightDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Initialize from existing log if editing
    if (widget.log.data != null) {
      final data = widget.log.data!;
      if (data['durationLeft'] != null) {
        _leftDuration = Duration(seconds: data['durationLeft']);
      }
      if (data['durationRight'] != null) {
        _rightDuration = Duration(seconds: data['durationRight']);
      }
    }
  }

  void _updateLogData() {
    final updatedLog = widget.log.copyWith(
      data: {
        'durationLeft': _leftDuration.inSeconds,
        'durationRight': _rightDuration.inSeconds,
        'last': _isLeftRunning
            ? 'left'
            : _isRightRunning
                ? 'right'
                : null,
      },
      amount: (_leftDuration + _rightDuration).inMinutes.toDouble(),
    );
    ref.read(logFormProvider.notifier).updateLog(updatedLog);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log, label: 'Start Time'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  DurationTimer(
                    label: 'Left Side',
                    isRunning: _isLeftRunning,
                    initialDuration: _leftDuration,
                    onDurationChanged: (duration) {
                      _leftDuration = duration;
                      _updateLogData();
                    },
                  ),
                  const SizedBox(height: 8),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    onPressed: () {
                      setState(() {
                        _isLeftRunning = !_isLeftRunning;
                        if (_isLeftRunning) {
                          _isRightRunning = false;
                        }
                      });
                    },
                    child: Text(_isLeftRunning ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  DurationTimer(
                    label: 'Right Side',
                    isRunning: _isRightRunning,
                    initialDuration: _rightDuration,
                    onDurationChanged: (duration) {
                      _rightDuration = duration;
                      _updateLogData();
                    },
                  ),
                  const SizedBox(height: 8),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    onPressed: () {
                      setState(() {
                        _isRightRunning = !_isRightRunning;
                        if (_isRightRunning) {
                          _isLeftRunning = false;
                        }
                      });
                    },
                    child: Text(_isRightRunning ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Total Time: ${(_leftDuration + _rightDuration).inMinutes} minutes',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
