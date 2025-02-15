import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_provider.dart';

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

        return widget.child;
      },
    );
  }
}
