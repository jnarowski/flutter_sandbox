import 'package:flutter/cupertino.dart';
import 'dart:async';

class DurationTimer extends StatefulWidget {
  final void Function(Duration) onDurationChanged;
  final bool isRunning;
  final Duration? initialDuration;
  final String label;

  const DurationTimer({
    super.key,
    required this.onDurationChanged,
    required this.isRunning,
    required this.label,
    this.initialDuration,
  });

  @override
  State<DurationTimer> createState() => _DurationTimerState();
}

class _DurationTimerState extends State<DurationTimer> {
  late Duration _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _duration = widget.initialDuration ?? Duration.zero;
    if (widget.isRunning) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(DurationTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRunning != oldWidget.isRunning) {
      if (widget.isRunning) {
        _startTimer();
      } else {
        _stopTimer();
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
        widget.onDurationChanged(_duration);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.label),
        const SizedBox(height: 8),
        Text(
          _formatDuration(_duration),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
