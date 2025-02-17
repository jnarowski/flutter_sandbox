// lib/controllers/auth_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/account/registration_service.dart';
import '../../features/account/setup_providers.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final FirebaseAuth _auth;
  final RegistrationService _registrationService;

  AuthController({
    FirebaseAuth? auth,
    RegistrationService? registrationService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _registrationService = registrationService ?? RegistrationService();

  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref
        .read(authServiceProvider)
        .signInWithEmailAndPassword(email: email, password: password));
  }

  Future<void> clearAppState() async {
    // Clear any cached data, providers, etc.
    ref.invalidate(authServiceProvider);
    // Add other providers that need to be cleared
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();

    // simple disposable composable provider
    // this will create the account and user
    final register = ref.read(registerProvider);

    try {
      // await clearAppState(); // Clear existing state before creating new account

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        print('user credential is null');
        return;
      }

      print('registering');

      await _registrationService.create(userCredential.user!);

      // state = await AsyncValue.guard(() async {
      //   print('registering...in guard');
      //   await register(
      //     uid: userCredential.user!.uid,
      //     email: email,
      //   );

      //   return null;
      // });
    } catch (e) {
      print('error registering');
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await clearAppState(); // Clear state on sign out
    state =
        await AsyncValue.guard(() => ref.read(authServiceProvider).signOut());
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(authServiceProvider).sendPasswordResetEmail(email));
  }
}
