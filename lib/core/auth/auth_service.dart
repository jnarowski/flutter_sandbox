// lib/services/auth_service.dart
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sandbox/core/firebase/auth.dart';
import 'package:flutter_sandbox/core/services/logger.dart';

class AuthService {
  final Auth _auth = auth;

  // Stream of auth state changes
  Stream<AuthUser?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  AuthUser? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<AuthUserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign up with email and password
  Future<AuthUserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      logger.i('ERROR with sign up: $e');
      logger.i(e.toString());
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is AuthUserException) {
      switch (e.code) {
        case 'user-not-found':
          return AuthException('No user found with this email');
        case 'wrong-password':
          return AuthException('Incorrect password');
        case 'email-already-in-use':
          return AuthException('Email is already registered');
        case 'invalid-email':
          return AuthException('Invalid email address');
        case 'weak-password':
          return AuthException('Password is too weak');
        default:
          return AuthException(e.message ?? 'Authentication failed');
      }
    }
    return AuthException('Authentication failed');
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
