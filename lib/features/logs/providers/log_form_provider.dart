import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../../../core/services/logger.dart';
import '../log_service.dart';
import '../../../core/providers/app_provider.dart';
import '../../../features/logs/log_provider.dart';

class LogFormState {
  final Map<String, String> lastUsedCategory;
  final Map<String, String> lastUsedUnit;
  final bool isLoading;
  final String? error;
  final Log? currentLog;
  final bool isValid;
  final Map<String, dynamic>? data;

  LogFormState({
    this.lastUsedCategory = const {},
    this.lastUsedUnit = const {},
    this.isLoading = false,
    this.error,
    this.currentLog,
    this.isValid = false,
    this.data,
  });

  LogFormState copyWith({
    Map<String, String>? lastUsedCategory,
    Map<String, String>? lastUsedUnit,
    bool? isLoading,
    String? error,
    Log? currentLog,
    bool? isValid,
    Map<String, dynamic>? data,
  }) {
    return LogFormState(
      lastUsedCategory: lastUsedCategory ?? this.lastUsedCategory,
      lastUsedUnit: lastUsedUnit ?? this.lastUsedUnit,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentLog: currentLog ?? this.currentLog,
      isValid: isValid ?? this.isValid,
      data: data ?? this.data,
    );
  }
}

class LogFormNotifier extends StateNotifier<LogFormState> {
  final LogService _logService;
  final AppState _appState;

  LogFormNotifier(this._logService, this._appState) : super(LogFormState());

  void initializeForm(String type, {Log? existingLog}) {
    logger.d('Initializing form with type: $type');

    final log = existingLog ??
        Log(
          type: type,
          startAt: DateTime.now(),
          accountId: _appState.account!.id,
          kidId: _appState.currentKid!.id,
          category: state.lastUsedCategory[type],
          unit: state.lastUsedUnit[type],
          // Initialize data for solids type
          data: type == 'solids'
              ? {
                  'foods': [
                    {'name': 'banana', 'notes': ''},
                  ],
                }
              : null,
        );

    state = state.copyWith(
      currentLog: log,
      error: null,
      isLoading: false,
    );

    validateForm();
  }

  void updateLog(Log updatedLog) {
    state = state.copyWith(
      currentLog: updatedLog,
      error: null,
    );
    validateForm();
  }

  void setLastUsedCategory(String type, String category) {
    state = state.copyWith(
      lastUsedCategory: {...state.lastUsedCategory, type: category},
    );
    logger.d('Updated last used category for $type: $category');
  }

  void setLastUsedUnit(String type, String unit) {
    state = state.copyWith(
      lastUsedUnit: {...state.lastUsedUnit, type: unit},
    );
    logger.d('Updated last used unit for $type: $unit');
  }

  void validateForm() {
    final log = state.currentLog;
    if (log == null) {
      state = state.copyWith(isValid: false);
      return;
    }

    bool isValid = true;

    // Type-specific validation
    switch (log.type) {
      case 'feeding':
        if (log.category == 'nursing') {
          // Nursing requires both sides to have some duration
          final leftDuration = log.data?['durationLeft'] ?? 0;
          final rightDuration = log.data?['durationRight'] ?? 0;
          isValid = leftDuration > 0 || rightDuration > 0;
        } else if (log.category == 'bottle') {
          // Bottle requires amount and unit
          isValid = log.amount != null && log.amount! > 0;
        }
        break;

      case 'medicine':
        // Medicine requires amount and unit
        isValid = log.amount != null && log.amount! > 0;
        break;

      case 'sleep':
        // Sleep requires at least 5 minutes
        if (log.endAt != null) {
          final duration = log.endAt!.difference(log.startAt);
          isValid = duration.inMinutes >= 5;
        } else {
          isValid = false;
        }
        break;

      case 'solids':
        // Solids requires at least one food and a reaction
        final foods = (log.data?['foods'] as List<dynamic>?) ?? [];
        isValid = foods.isNotEmpty && log.category != null;
        break;

      case 'bathroom':
        // Bathroom requires category and subcategory
        isValid = log.category != null && log.subCategory != null;
        break;

      case 'pumping':
        // Pumping requires some duration on either side
        final leftDuration = log.data?['leftDuration'] ?? 0;
        final rightDuration = log.data?['rightDuration'] ?? 0;
        isValid = leftDuration > 0 || rightDuration > 0;
        break;

      case 'activity':
        // Activity just requires a category
        isValid = log.category != null;
        break;

      case 'growth':
        // Growth requires at least one measurement
        final height = log.data?['height'];
        final weight = log.data?['weight'];
        final head = log.data?['head'];
        isValid = height != null || weight != null || head != null;
        break;
    }

    logger.d('Form validation: $isValid for log: ${log.type}');
    state = state.copyWith(isValid: isValid);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
    logger.e('Form error: $error');
  }

  Future<void> saveLog() async {
    if (!state.isValid || state.currentLog == null) {
      setError('Form is not valid');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final log = state.currentLog!.copyWith(
          accountId: _appState.account?.id, kidId: _appState.currentKid?.id);

      if (log.id != null) {
        await _logService.update(log);
        logger.i('Updated log: ${log.id}');
      } else {
        final newLog = log.copyWith();
        await _logService.create(newLog);
        logger.i('Created new log');
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      logger.e('Error saving log: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save log: $e',
      );
      rethrow;
    }
  }

  Future<void> deleteLog(String id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _logService.delete(id);
      logger.i('Deleted log: $id');
      state = state.copyWith(isLoading: false);
    } catch (e) {
      logger.e('Error deleting log: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete log: $e',
      );
      rethrow;
    }
  }
}

final logFormProvider =
    StateNotifierProvider<LogFormNotifier, LogFormState>((ref) {
  final logService = ref.watch(logServiceProvider);
  final appState = ref.watch(appProvider);
  return LogFormNotifier(logService, appState);
});
