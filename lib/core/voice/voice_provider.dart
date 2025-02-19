import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/voice/voice_service.dart';

final voiceServiceProvider = Provider<VoiceService>((ref) {
  final service = VoiceService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});
