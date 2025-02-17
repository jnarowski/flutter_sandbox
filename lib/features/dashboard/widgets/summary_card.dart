import 'package:flutter/cupertino.dart';
import '../../../core/models/log.dart';

class SummaryCard extends StatelessWidget {
  final List<Log> logs;

  const SummaryCard({super.key, required this.logs});

  Map<String, double> _calculateSummaries() {
    final summaries = <String, double>{};

    for (final log in logs) {
      if (log.amount != null) {
        summaries[log.type] = (summaries[log.type] ?? 0) + log.amount!;
      }
    }

    return summaries;
  }

  String _formatAmount(String type, double amount) {
    switch (type) {
      case 'formula':
        return '${amount.toStringAsFixed(1)}oz';
      case 'sleep':
        final hours = (amount / 60).floor();
        final minutes = (amount % 60).floor();
        if (hours > 0) {
          return '$hours hr ${minutes}min';
        }
        return '$minutes min';
      case 'medicine':
        return '${amount.toStringAsFixed(1)}ml';
      default:
        return amount.toString();
    }
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
            ...summaries.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key.substring(0, 1).toUpperCase() +
                            entry.key.substring(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatAmount(entry.key, entry.value),
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
