import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  Future<void> _handleSubmit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUp) {
        await ref.read(authControllerProvider.notifier).signUp(
              email: _emailController.text,
              password: _passwordController.text,
            );
      } else {
        await ref.read(authControllerProvider.notifier).signIn(
              _emailController.text,
              _passwordController.text,
            );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CupertinoTextField(
          controller: _emailController,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
        ),
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: _passwordController,
          placeholder: 'Password',
          obscureText: true,
          autocorrect: false,
        ),
        const SizedBox(height: 24),
        if (_isLoading)
          const Center(child: CupertinoActivityIndicator())
        else
          CupertinoButton.filled(
            onPressed: _handleSubmit,
            child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
          ),
        const SizedBox(height: 16),
        CupertinoButton(
          onPressed: _toggleMode,
          child:
              Text(_isSignUp ? 'Already have an account?' : 'Need an account?'),
        ),
      ],
    );
  }
}
