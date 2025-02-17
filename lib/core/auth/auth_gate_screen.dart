// lib/screens/auth_gate.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/auth/login_screen.dart';
import 'package:flutter_sandbox/core/auth/auth_providers.dart';
import 'package:flutter_sandbox/core/screens/loading_screen.dart';
import 'package:flutter_sandbox/core/screens/error_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authState = ref.watch(authStateChangesProvider);

        return authState.when(
          data: (user) => user != null ? child : const LoginScreen(),
          loading: () => const LoadingScreen(),
          error: (error, stack) => ErrorScreen(error: error.toString()),
        );
      },
    );
  }
}
