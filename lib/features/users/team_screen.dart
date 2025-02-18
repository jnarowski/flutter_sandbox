import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user.dart';
import 'user_provider.dart';
import 'invite_user_dialog.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStreamProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Team Management'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.person_add),
          onPressed: () => _showInviteDialog(context, ref),
        ),
      ),
      child: SafeArea(
        child: usersAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (users) {
            final activeUsers =
                users.where((u) => u.status == 'active').toList();
            final invitedUsers =
                users.where((u) => u.status == 'invited').toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection('Active Users', activeUsers, ref, context),
                const SizedBox(height: 24),
                _buildSection(
                    'Pending Invitations', invitedUsers, ref, context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<User> users, WidgetRef ref, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (users.isNotEmpty)
          CupertinoListSection.insetGrouped(
            children: users
                .map((user) => CupertinoListTile(
                      leading: const Icon(CupertinoIcons.person),
                      title: Text(user.email ?? 'No email'),
                      subtitle: Text(user.name ?? 'No name'),
                      trailing: user.status == 'invited'
                          ? CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(
                                CupertinoIcons.delete,
                                color: CupertinoColors.destructiveRed,
                              ),
                              onPressed: () =>
                                  _deleteInvitation(context, ref, user),
                            )
                          : null,
                    ))
                .toList(),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('No ${title.toLowerCase()} found'),
          ),
      ],
    );
  }

  void _showInviteDialog(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => const InviteUserDialog(),
    );
  }

  Future<void> _deleteInvitation(
      BuildContext context, WidgetRef ref, User user) async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Invitation'),
        content: Text(
            'Are you sure you want to delete the invitation for ${user.email}?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(userServiceProvider).delete(user.id);
    }
  }
}
