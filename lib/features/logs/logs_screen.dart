import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/features/logs/log_provider.dart';
import 'widgets/log_form.dart';
import 'widgets/log_list_tile.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final logStream = ref.watch(logStreamProvider(appState.account!.id));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Logs'),
        trailing: AddLogButton(),
      ),
      child: SafeArea(
        child: logStream.when(
          data: (logs) {
            if (logs.isEmpty) {
              return const Center(
                child: Text('No logs added yet'),
              );
            }

            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return LogListTile(log: log);
              },
            );
          },
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}

class AddLogButton extends ConsumerWidget {
  const AddLogButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showLogForm(context, ref),
      child: const Icon(CupertinoIcons.add),
    );
  }

  void _showLogForm(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => LogForm(
          type: 'feeding', // We'll make this selectable later
          onSaved: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
