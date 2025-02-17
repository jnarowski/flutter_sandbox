import 'package:flutter/cupertino.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:flutter_sandbox/features/dashboard/widgets/summary_row.dart';

class SummaryCard extends StatelessWidget {
  final List<Log> logs;

  const SummaryCard({super.key, required this.logs});

  Map<String, _ActivitySummary> _calculateSummaries() {
    final summaries = <String, _ActivitySummary>{};

    for (final log in logs) {
      if (!summaries.containsKey(log.type)) {
        summaries[log.type] = _ActivitySummary(
          total: log.amount ?? 0,
          lastActivity: log.startAt,
        );
      } else {
        final current = summaries[log.type]!;
        if (log.amount != null) {
          summaries[log.type] = _ActivitySummary(
            total: current.total + log.amount!,
            lastActivity: log.startAt.isAfter(current.lastActivity)
                ? log.startAt
                : current.lastActivity,
          );
        }
      }
    }

    return summaries;
  }

  @override
  Widget build(BuildContext context) {
    final summaries = _calculateSummaries();

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
          const Text(
            'Daily Totals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (summaries.isEmpty)
            const Text(
              'No activities recorded today',
              style: TextStyle(
                color: CupertinoColors.systemGrey,
              ),
            )
          else
            ...summaries.entries.map((entry) => SummaryRow(
                  type: entry.key,
                  total: entry.value.total,
                  lastActivity: entry.value.lastActivity,
                )),
        ],
      ),
    );
  }
}

class _ActivitySummary {
  final double total;
  final DateTime lastActivity;

  _ActivitySummary({
    required this.total,
    required this.lastActivity,
  });
}
