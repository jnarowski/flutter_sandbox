import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/auth/auth_providers.dart';
import 'package:flutter_sandbox/features/users/team_screen.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appProvider).user;
    final authService = ref.watch(authServiceProvider);
    final email = user?.email ?? 'No email';

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Account'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CupertinoListSection(
              header: const Text('Profile'),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: const Text('Email'),
                  enabled: false,
                  initialValue: email,
                ),
              ],
            ),
            CupertinoListSection(
              header: const Text('Team'),
              children: [
                CupertinoListTile(
                  title: const Text('Team Management'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const TeamScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                color: CupertinoColors.destructiveRed,
                child: const Text('Logout'),
                onPressed: () async {
                  await authService.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
