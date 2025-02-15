import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/log.dart';
import '../providers/log_provider.dart';
import '../providers/auth_providers.dart';

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final logsAsync = ref.watch(logsProvider(user?.uid ?? ''));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Logs'),
        trailing: AddLogButton(),
      ),
      child: SafeArea(
        child: logsAsync.when(
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
      onTap: () => _showAddLogDialog(context, ref),
      child: const Icon(CupertinoIcons.add),
    );
  }

  void _showAddLogDialog(BuildContext context, WidgetRef ref) {
    final noteController = TextEditingController();
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add New Log'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: noteController,
              placeholder: 'Note',
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: amountController,
              placeholder: 'Amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: Text(
                'Date: ${selectedDate.toString().split(' ')[0]}',
              ),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Container(
                    height: 216,
                    color: CupertinoColors.systemBackground,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      onDateTimeChanged: (date) {
                        selectedDate = date;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Add'),
            onPressed: () {
              final note = noteController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0;
              if (note.isNotEmpty) {
                final user = ref.read(authStateChangesProvider).value;
                final log = Log(
                  note: note,
                  amount: amount,
                  date: selectedDate,
                  accountId: user?.uid,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                ref.read(logsProvider(user?.uid ?? '').notifier).create(log);
                Navigator.pop(context);
              }
            },
          ),
        ],
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
      title: Text(log.note ?? ''),
      subtitle: Text('Amount: ${log.amount ?? 0}'),
      trailing: GestureDetector(
        onTap: () => _showEditLogDialog(context, ref),
        child: const Icon(CupertinoIcons.pencil),
      ),
    );
  }

  void _showEditLogDialog(BuildContext context, WidgetRef ref) {
    final noteController = TextEditingController(text: log.note);
    final amountController =
        TextEditingController(text: log.amount?.toString());
    DateTime selectedDate = log.date ?? DateTime.now();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit Log'),
        content: Column(
          children: [
            CupertinoTextField(
              controller: noteController,
              placeholder: 'Note',
            ),
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: amountController,
              placeholder: 'Amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              child: Text(
                'Date: ${selectedDate.toString().split(' ')[0]}',
              ),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => Container(
                    height: 216,
                    color: CupertinoColors.systemBackground,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      onDateTimeChanged: (date) {
                        selectedDate = date;
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              final user = ref.read(authStateChangesProvider).value;
              ref.read(logsProvider(user?.uid ?? '').notifier).delete(log.id!);
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Save'),
            onPressed: () {
              final note = noteController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0;
              if (note.isNotEmpty) {
                final updatedLog = log.copyWith(
                  note: note,
                  amount: amount,
                  date: selectedDate,
                );
                final user = ref.read(authStateChangesProvider).value;
                ref
                    .read(logsProvider(user?.uid ?? '').notifier)
                    .updateLog(updatedLog);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
