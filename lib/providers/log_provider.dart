import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/log.dart';
import '../services/log_service.dart';

part 'log_provider.g.dart';

@riverpod
LogService logService(ref) {
  return LogService();
}

@riverpod
class Logs extends _$Logs {
  @override
  Stream<List<Log>> build(String accountId) {
    final logService = ref.watch(logServiceProvider);
    return logService.getAll(accountId);
  }

  Future<void> create(Log log) async {
    final logService = ref.read(logServiceProvider);
    await logService.create(log);
  }

  Future<void> updateLog(Log log) async {
    final logService = ref.read(logServiceProvider);
    await logService.update(log);
  }

  Future<void> delete(String logId) async {
    final logService = ref.read(logServiceProvider);
    await logService.delete(logId);
  }
}
