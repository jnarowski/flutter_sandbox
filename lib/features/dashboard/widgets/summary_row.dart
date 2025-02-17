import 'package:flutter/cupertino.dart';
import '../../../core/models/log.dart';
import 'package:intl/intl.dart';

class SummaryRow extends StatelessWidget {
  final String type;
  final double total;
  final DateTime lastActivity;

  const SummaryRow({
    super.key,
    required this.type,
    required this.total,
    required this.lastActivity,
  });

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
    return Padding(
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
                type.substring(0, 1).toUpperCase() + type.substring(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                _formatAmount(type, total),
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Last $type at ${_formatTime(lastActivity)} • ${_formatTimeAgo(lastActivity)}',
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
