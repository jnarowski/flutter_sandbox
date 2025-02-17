import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';
import 'setup_screen.dart';

class AppInitGate extends ConsumerStatefulWidget {
  final Widget child;

  const AppInitGate({required this.child, super.key});

  @override
  ConsumerState<AppInitGate> createState() => _AppInitGateState();
}

class _AppInitGateState extends ConsumerState<AppInitGate> {
  late final Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = ref.read(appProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);

    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return CupertinoPageScaffold(
            child: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Check if we have an account but no kids
        if (appState.account != null && appState.currentKid == null) {
          return const SetupScreen();
        }

        // If we have both account and current kid, show the main app
        if (appState.account != null && appState.currentKid != null) {
          return widget.child;
        }

        // If we don't have an account yet, show loading
        return const CupertinoPageScaffold(
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}
