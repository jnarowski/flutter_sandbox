// lib/screens/login_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (_isSignUp) {
        await ref.read(authControllerProvider.notifier).signUp(email, password);
      } else {
        await ref.read(authControllerProvider.notifier).signIn(email, password);
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_isSignUp ? 'Sign Up' : 'Login'),
      ),
      child: SafeArea(
        child: authController.when(
          data: (_) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  padding: const EdgeInsets.all(16),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  obscureText: true,
                  padding: const EdgeInsets.all(16),
                ),
                const SizedBox(height: 32),
                CupertinoButton.filled(
                  onPressed: _submit,
                  child: Text(_isSignUp ? 'Sign Up' : 'Login'),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () {
                    setState(() {
                      _isSignUp = !_isSignUp;
                    });
                  },
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Login'
                        : 'Need an account? Sign Up',
                  ),
                ),
                if (!_isSignUp) ...[
                  const SizedBox(height: 16),
                  CupertinoButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        ref
                            .read(authControllerProvider.notifier)
                            .resetPassword(email);
                      } else {
                        _showError('Please enter your email');
                      }
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ],
            ),
          ),
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $error',
                  style: const TextStyle(color: CupertinoColors.destructiveRed),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: _submit,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
