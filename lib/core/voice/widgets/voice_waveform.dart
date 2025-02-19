import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/voice/voice_provider.dart';

class VoiceWaveform extends ConsumerWidget {
  const VoiceWaveform({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceService = ref.watch(voiceServiceProvider);

    return StreamBuilder<double>(
      stream: voiceService.soundLevelStream,
      builder: (context, snapshot) {
        final level = snapshot.data ?? 0.0;

        return Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: CustomPaint(
            painter: WaveformPainter(level: level),
            size: const Size(double.infinity, 50),
          ),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double level;

  WaveformPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.activeBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final mid = height / 2;

    final normalizedLevel = ((level + 50) / 50).clamp(0.0, 1.0);

    path.moveTo(0, mid);

    for (var i = 0; i < width; i++) {
      final amplitude = normalizedLevel * height / 4;
      final y = mid + amplitude * sin(i * 0.1);
      path.lineTo(i.toDouble(), y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => level != oldDelegate.level;
}
