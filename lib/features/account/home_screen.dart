// lib/screens/home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Baby Tracker'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            ref.read(authControllerProvider.notifier).signOut();
          },
          child: const Text('Sign Out'),
        ),
      ),
      child: const SafeArea(
        child: Center(
          child: Text('Welcome to Baby Tracker!'),
        ),
      ),
    );
  }
}
