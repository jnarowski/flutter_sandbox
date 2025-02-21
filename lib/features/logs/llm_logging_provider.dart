import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_sandbox/features/logs/llm_logging_service.dart';
// import 'package:flutter_sandbox/core/models/log.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/features/kids/kid_provider.dart';
import 'package:flutter_sandbox/features/logs/log_provider.dart';
part 'llm_logging_provider.g.dart';

@riverpod
LLMLoggingService llmLoggingService(ref) {
  final appState = ref.read(appProvider);
  final kidService = ref.read(kidServiceProvider);
  final logService = ref.read(logServiceProvider);

  return LLMLoggingService(
    appState: appState,
    kidService: kidService,
    logService: logService,
  );
}
