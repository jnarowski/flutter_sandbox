// lib/controllers/auth_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_providers.dart';
part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref
        .read(authServiceProvider)
        .signInWithEmailAndPassword(email: email, password: password));
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref
        .read(authServiceProvider)
        .createUserWithEmailAndPassword(email: email, password: password));
  }

  Future<void> signOut() async {
    state =
        await AsyncValue.guard(() => ref.read(authServiceProvider).signOut());
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(authServiceProvider).sendPasswordResetEmail(email));
  }
}
