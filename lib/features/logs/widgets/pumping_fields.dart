import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../providers/log_form_provider.dart';
import 'duration_timer.dart';
import './shared/date_time_picker.dart';

class PumpingFields extends ConsumerStatefulWidget {
  final Log log;

  const PumpingFields({
    super.key,
    required this.log,
  });

  @override
  ConsumerState<PumpingFields> createState() => _PumpingFieldsState();
}

class _PumpingFieldsState extends ConsumerState<PumpingFields> {
  bool _isManualEntry = false;
  bool _isLeftRunning = false;
  bool _isRightRunning = false;
  Duration _leftDuration = Duration.zero;
  Duration _rightDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (widget.log.data != null) {
      _leftDuration = Duration(seconds: widget.log.data!['leftDuration'] ?? 0);
      _rightDuration =
          Duration(seconds: widget.log.data!['rightDuration'] ?? 0);
      _isManualEntry = widget.log.data!['isManual'] ?? false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateDurations() {
    ref.read(logFormProvider.notifier).updateLog(
          widget.log.copyWith(
            data: {
              ...widget.log.data ?? {},
              'leftDuration': _leftDuration.inSeconds,
              'rightDuration': _rightDuration.inSeconds,
              'totalDuration': (_leftDuration + _rightDuration).inSeconds,
              'isManual': _isManualEntry,
            },
            endAt: widget.log.startAt.add(_leftDuration + _rightDuration),
          ),
        );
  }

  void _showDurationPicker(bool isLeft) {
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
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: isLeft ? _leftDuration : _rightDuration,
            onTimerDurationChanged: (Duration value) {
              setState(() {
                if (isLeft) {
                  _leftDuration = value;
                } else {
                  _rightDuration = value;
                }
                _updateDurations();
              });
            },
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return hours > 0 ? '$hours hr $minutes min' : '$minutes min';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DateTimePicker(log: widget.log, label: 'Start Time'),
        const SizedBox(height: 16),

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
                      if (value) {
                        // Stop timers when switching to manual
                        _isLeftRunning = false;
                        _isRightRunning = false;
                      }
                      _updateDurations();
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_isManualEntry)
          // Manual duration inputs
          CupertinoFormSection.insetGrouped(
            header: const Text('Duration'),
            children: [
              CupertinoFormRow(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () => _showDurationPicker(true),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Left Side'),
                      Text(_formatDuration(_leftDuration)),
                    ],
                  ),
                ),
              ),
              CupertinoFormRow(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () => _showDurationPicker(false),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Right Side'),
                      Text(_formatDuration(_rightDuration)),
                    ],
                  ),
                ),
              ),
              if (_leftDuration > Duration.zero ||
                  _rightDuration > Duration.zero)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Total Time: ${(_leftDuration + _rightDuration).inMinutes} minutes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          )
        else
          // Timer interface
          CupertinoFormSection.insetGrouped(
            header: const Text('Timers'),
            children: [
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
                            _updateDurations();
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
                            _updateDurations();
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
              if (_leftDuration > Duration.zero ||
                  _rightDuration > Duration.zero)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Total Time: ${(_leftDuration + _rightDuration).inMinutes} minutes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}
