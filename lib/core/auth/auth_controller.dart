// lib/controllers/auth_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_sandbox/core/auth/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_sandbox/features/account/account_provider.dart';
import 'package:flutter_sandbox/features/users/user_provider.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/core/models/user.dart';
part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final auth.FirebaseAuth _auth;

  AuthController({auth.FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? auth.FirebaseAuth.instance;

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
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Remove state updates since Firebase Auth will handle the state
    } catch (e) {
      throw 'Failed to sign in: $e';
    }
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
      await userService.create(
          id: userCredential.user!.uid, accountId: account.id, email: email);
      // Remove state updates since Firebase Auth will handle the state
    } catch (e) {
      throw 'Failed to sign up: $e';
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

  Future<User?> lookupInvitation({
    required String verificationCode,
  }) async {
    try {
      final userService = ref.read(userServiceProvider);
      final user = await userService.verifyInvitationCode(
        verificationCode: verificationCode,
      );

      if (user == null) {
        throw 'Invalid verification code';
      }

      return user;
    } catch (e) {
      throw 'Invalid verification code';
    }
  }

  Future<void> acceptInvitation({
    required User user,
    required String password,
  }) async {
    final userService = ref.read(userServiceProvider);

    // Create Firebase Auth user
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    // Create user in Firestore
    await userService.create(
      id: userCredential.user!.uid,
      accountId: user.accountId,
      email: user.email,
    );

    // Delete the invited user
    await userService.delete(user.id);
  }
}
