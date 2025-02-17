import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:flutter_sandbox/features/logs/widgets/log_list_tile.dart';

class ActivityCard extends StatelessWidget {
  final List<Log> logs;

  const ActivityCard({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${logs.length} Activities',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (logs.isEmpty)
            const Text(
              'No activities recorded today',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.take(5).length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return LogListTile(log: log);
              },
            ),
        ],
      ),
    );
  }
}
