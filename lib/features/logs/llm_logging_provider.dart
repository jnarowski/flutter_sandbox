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

// @riverpod
// class LLMLogging extends _$LLMLogging {
//   @override
//   LLMLoggingService build() {
//     return LLMLoggingService();
//   }

//   Future<Log> process(String text) async {
//     final appState = ref.read(appProvider);
//     final kidService = ref.read(kidServiceProvider);
//     final logService = ref.read(logServiceProvider);

//     if (appState.account?.id == null) {
//       throw Exception('No account ID available');
//     }

//     final kids = await kidService.getAll(appState.account!.id);
//     final parsedLog = await state.parseLogFromText(
//       text: text,
//       kids: kids,
//     );

//     final kidId = parsedLog.kidId ?? appState.account?.currentKidId;
//     if (kidId == null) {
//       throw Exception('No kid ID available');
//     }
//     final newLog = parsedLog.copyWith(kidId: kidId);

//     await logService.create(newLog);
//     return newLog;
//   }
// }
