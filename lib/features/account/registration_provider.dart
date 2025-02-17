import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/models/user.dart' as app_models;
import 'registration_service.dart';

part 'registration_provider.g.dart';

@riverpod
RegistrationService registrationService(ref) {
  return RegistrationService();
}

class RegistrationNotifier extends StateNotifier<AsyncValue<app_models.User?>> {
  final RegistrationService _registrationService;

  RegistrationNotifier(this._registrationService)
      : super(const AsyncValue.data(null));

  Future<void> createAccount(firebase_auth.User firebaseUser) async {
    try {
      state = const AsyncValue.loading();

      final user = await _registrationService.create(firebaseUser);

      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createFirstKid(firebase_auth.User firebaseUser) async {
    try {
      state = const AsyncValue.loading();

      final user = await _registrationService.create(firebaseUser);

      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final registrationProvider =
    StateNotifierProvider<RegistrationNotifier, AsyncValue<app_models.User?>>(
        (ref) {
  final registrationService = ref.watch(registrationServiceProvider);
  return RegistrationNotifier(registrationService);
});
