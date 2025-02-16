// lib/providers/auth_providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_service.dart';

part 'auth_providers.g.dart';

// Provider for AuthService
@Riverpod(keepAlive: true)
AuthService authService(ref) {
  return AuthService();
}

// Provider for auth state changes stream
@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Provides the current user synchronously
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser;
});
