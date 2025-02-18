import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/features/auth/login_form.dart';
import 'package:flutter_sandbox/features/auth/signup_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Welcome'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSlidingSegmentedControl<bool>(
                groupValue: _showLogin,
                children: const {
                  true: Text('Login'),
                  false: Text('Sign Up'),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _showLogin = value);
                  }
                },
              ),
              const SizedBox(height: 32),
              _showLogin ? const LoginForm() : const SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
