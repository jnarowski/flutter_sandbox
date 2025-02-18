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

class EmailLinkForm extends ConsumerStatefulWidget {
  const EmailLinkForm({super.key});

  @override
  ConsumerState<EmailLinkForm> createState() => _EmailLinkFormState();
}

class _EmailLinkFormState extends ConsumerState<EmailLinkForm> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_emailController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .sendLoginLink(_emailController.text);

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Check your email'),
            content: const Text(
                'We sent you a login link. Please check your email to continue.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
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
        const SizedBox(height: 24),
        if (_isLoading)
          const Center(child: CupertinoActivityIndicator())
        else
          CupertinoButton.filled(
            onPressed: _handleSubmit,
            child: const Text('Send Login Link'),
          ),
      ],
    );
  }
}
