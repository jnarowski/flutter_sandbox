import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/core/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/models/user.dart';

class JoinForm extends ConsumerStatefulWidget {
  const JoinForm({super.key});

  @override
  ConsumerState<JoinForm> createState() => _JoinAccountFormState();
}

class _JoinAccountFormState extends ConsumerState<JoinForm> {
  final _verificationCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _foundEmail;
  bool _isTokenVerified = false;
  User? _foundUser;

  @override
  void dispose() {
    _verificationCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verifyToken() async {
    if (_verificationCodeController.text.length != 6) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user =
          await ref.read(authControllerProvider.notifier).lookupInvitation(
                verificationCode: _verificationCodeController.text,
              );

      setState(() {
        _foundUser = user;
        _foundEmail = user?.email;
        _isTokenVerified = true;
      });
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

  Future<void> _handleSubmit() async {
    if (!_isTokenVerified ||
        _passwordController.text.isEmpty ||
        _foundEmail == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authControllerProvider.notifier).acceptInvitation(
            user: _foundUser!,
            password: _passwordController.text,
          );

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Success'),
            content: const Text('Your account has been set up successfully.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to login screen
                },
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
    final bool canSubmit = _isTokenVerified &&
        _foundEmail != null &&
        _passwordController.text.isNotEmpty;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Join Account'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the 6-digit verification code from your invitation.',
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: 24),
              CupertinoTextField(
                controller: _verificationCodeController,
                placeholder: '6-digit code',
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  if (value.length == 6) {
                    _verifyToken();
                  }
                },
              ),
              if (_foundEmail != null) ...[
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: CupertinoColors.activeGreen,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Invite Successfully Found',
                      style: TextStyle(
                        color: CupertinoColors.activeGreen,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  enabled: false,
                  placeholder: 'Email',
                  controller: TextEditingController(text: _foundEmail),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Create Password',
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CupertinoActivityIndicator())
              else
                CupertinoButton.filled(
                  onPressed: canSubmit ? _handleSubmit : null,
                  child: const Text('Accept Invitation'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
