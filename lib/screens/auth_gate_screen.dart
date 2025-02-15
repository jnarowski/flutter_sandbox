// lib/screens/auth_gate.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_init_gate.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late final Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    _authStateStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return CupertinoPageScaffold(
            child: Center(
              child: Text('Authentication error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        return AppInitGate(
          key: ValueKey(snapshot.data?.uid),
          child: const HomeScreen(),
        );
      },
    );
  }
}
