// lib/screens/login_screen.dart
import 'package:flutter/cupertino.dart';
import '../../core/auth/auth_controller.dart';
import 'join_account_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void _navigateToJoinAccount() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const JoinAccountForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sign in with email and password.',
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: 24),
              const LoginForm(),
              const SizedBox(height: 16),
              CupertinoButton(
                onPressed: _navigateToJoinAccount,
                child: const Text('Join Existing Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
