import 'package:flutter/cupertino.dart';
import '../../../core/models/log.dart';
import 'package:intl/intl.dart';

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

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime).toLowerCase();
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
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            _formatAmount(entry.key, entry.value.total),
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Last ${entry.key} at ${_formatTime(entry.value.lastActivity)} • ${_formatTimeAgo(entry.value.lastActivity)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.systemGrey.withOpacity(0.8),
                          ),
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

class _ActivitySummary {
  final double total;
  final DateTime lastActivity;

  _ActivitySummary({
    required this.total,
    required this.lastActivity,
  });
}
