import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/log.dart';
import 'log_provider.dart';
import '../../core/providers/app_provider.dart';
import '../../features/logs/widgets/log_form.dart';
import '../../features/logs/log_formatter.dart';

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

class LogListTile extends ConsumerWidget {
  final Log log;

  const LogListTile({super.key, required this.log});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoListTile(
      leading: Icon(
        LogFormatter.getIcon(log),
        color: CupertinoColors.systemGrey,
      ),
      title: Text(
        LogFormatter.getTitle(log),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(LogFormatter.getSubtitle(log)),
      trailing: GestureDetector(
        onTap: () => _showEditLogForm(context, ref),
        child: const Icon(CupertinoIcons.pencil),
      ),
    );
  }

  void _showEditLogForm(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => LogForm(
          type: log.type,
          existingLog: log,
          onSaved: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
