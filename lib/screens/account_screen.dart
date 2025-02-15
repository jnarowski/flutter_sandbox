import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Account'),
      ),
      child: SafeArea(
        child: Center(
          child: CupertinoButton(
            color: CupertinoColors.destructiveRed,
            child: const Text('Logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ),
      ),
    );
  }
}
