import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/log.dart';
import '../log_formatter.dart';
import '../widgets/log_form.dart';

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
