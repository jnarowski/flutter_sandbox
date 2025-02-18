import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_provider.dart';

class InviteUserDialog extends ConsumerStatefulWidget {
  const InviteUserDialog({super.key});

  @override
  ConsumerState<InviteUserDialog> createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends ConsumerState<InviteUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _inviteUser() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userService = ref.read(userServiceProvider);

      // TODO: Get these from your auth/account providers
      const accountId = 'your-account-id';
      const invitedById = 'current-user-id';

      await userService.invite(
        email: _emailController.text,
        accountId: accountId,
        invitedById: invitedById,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Failed to send invitation: $e'),
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Invite Team Member'),
      content: Column(
        children: [
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: _emailController,
            placeholder: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
        CupertinoDialogAction(
          onPressed: _isLoading ? null : _inviteUser,
          child: _isLoading
              ? const CupertinoActivityIndicator()
              : const Text('Send Invitation'),
        ),
      ],
    );
  }
}
