import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../widgets/log_form.dart';
import 'log_row.dart';

class LogListTile extends ConsumerWidget {
  final Log log;

  const LogListTile({super.key, required this.log});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoListTile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: LogRow(
        log: log,
        onEdit: () => _showEditLogForm(context, ref),
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
