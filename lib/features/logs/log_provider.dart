import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/models/log.dart';
import 'log_service.dart';
import '../../core/providers/app_provider.dart';

part 'log_provider.g.dart';

@riverpod
LogService logService(ref) {
  return LogService();
}

@riverpod
Stream<List<Log>> todayLogs(ref) {
  final appState = ref.watch(appProvider);
  final logService = ref.watch(logServiceProvider);

  if (appState.currentKid == null) {
    throw Exception('No kid selected');
  }

  // Get start and end of today
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return logService.getTodayLogs(
    accountId: appState.account!.id!,
    kidId: appState.currentKid!.id!,
    startDate: startOfDay,
    endDate: endOfDay,
  );
}

final logStreamProvider =
    StreamProvider.family<List<Log>, String>((ref, accountId) {
  final logService = ref.watch(logServiceProvider);
  return logService.getAll(accountId);
});
