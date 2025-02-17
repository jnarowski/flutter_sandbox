// lib/controllers/auth_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_sandbox/core/auth/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sandbox/features/account/account_provider.dart';
import 'package:flutter_sandbox/features/users/user_provider.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final FirebaseAuth _auth;

  AuthController({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  @override
  FutureOr<void> build() {}

  Future<void> clearAppState() async {
    ref.invalidate(authServiceProvider);
    ref.invalidate(accountServiceProvider);
    ref.invalidate(userServiceProvider);
    ref.invalidate(appProvider);

    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref
        .read(authServiceProvider)
        .signInWithEmailAndPassword(email: email, password: password));
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      // 1. Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final accountService = ref.read(accountServiceProvider);
      final userService = ref.read(userServiceProvider);

      final account = await accountService.create();
      final user = await userService.create(
          id: userCredential.user!.uid, accountId: account.id, email: email);

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
