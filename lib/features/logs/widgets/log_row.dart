import 'package:flutter/cupertino.dart';
import '../../../core/models/log.dart';
import '../log_formatter.dart';

class LogRow extends StatelessWidget {
  final Log log;
  final VoidCallback onEdit;

  const LogRow({
    super.key,
    required this.log,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          LogFormatter.getIcon(log),
          color: CupertinoColors.systemGrey,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LogFormatter.getTitle(log),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                LogFormatter.getSubtitle(log),
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Icon(CupertinoIcons.pencil),
        ),
      ],
    );
  }
}
