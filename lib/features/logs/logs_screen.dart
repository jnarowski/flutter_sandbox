import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/features/logs/log_provider.dart';
import 'widgets/log_form.dart';
import 'widgets/log_list_tile.dart';
import 'package:flutter_sandbox/core/models/log.dart';

// State provider for selected week
final selectedWeekProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Helper class to group logs by day
class DayGroup {
  final DateTime date;
  final List<Log> logs;
  DayGroup(this.date, this.logs);
}

class LogsScreen extends ConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final logStream = ref.watch(logStreamProvider(appState.account!.id));
    final selectedWeek = ref.watch(selectedWeekProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Activities'),
        trailing: AddLogButton(),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Week selector
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10, // Show last 10 weeks
                itemBuilder: (context, index) {
                  final weekDate = DateTime.now().subtract(
                    Duration(days: index * 7),
                  );
                  final isSelected = _isSameWeek(weekDate, selectedWeek);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: isSelected ? CupertinoColors.activeBlue : null,
                      onPressed: () => ref
                          .read(selectedWeekProvider.notifier)
                          .state = weekDate,
                      child: Text(
                        _formatWeekButton(weekDate),
                        style: TextStyle(
                          color: isSelected
                              ? CupertinoColors.white
                              : CupertinoColors.label,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Activities list
            Expanded(
              child: logStream.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return const Center(
                      child: Text('No activities logged yet'),
                    );
                  }

                  // Filter logs for selected week
                  final weekStart = DateTime(
                    selectedWeek.year,
                    selectedWeek.month,
                    selectedWeek.day - selectedWeek.weekday + 1,
                  );
                  final weekEnd = weekStart.add(const Duration(days: 7));

                  final filteredLogs = logs.where((log) {
                    return log.startAt.isAfter(weekStart) &&
                        log.startAt.isBefore(weekEnd);
                  }).toList();

                  // Group logs by day
                  final groupedLogs = _groupLogsByDay(filteredLogs);

                  if (groupedLogs.isEmpty) {
                    return const Center(
                      child: Text('No activities this week'),
                    );
                  }

                  return ListView.builder(
                    itemCount: groupedLogs.length,
                    itemBuilder: (context, index) {
                      final group = groupedLogs[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DayHeader(date: group.date),
                          _DaySummary(logs: group.logs),
                          ...group.logs.map((log) => LogListTile(log: log)),
                        ],
                      );
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
          ],
        ),
      ),
    );
  }

  List<DayGroup> _groupLogsByDay(List<Log> logs) {
    final groups = <DateTime, List<Log>>{};

    for (final log in logs) {
      final date = DateTime(
        log.startAt.year,
        log.startAt.month,
        log.startAt.day,
      );

      groups.putIfAbsent(date, () => []).add(log);
    }

    return groups.entries.map((e) => DayGroup(e.key, e.value)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  String _formatWeekButton(DateTime date) {
    // Get start and end of week
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Format dates
    final startStr = '${weekStart.month}/${weekStart.day}';
    final endStr = '${weekEnd.month}/${weekEnd.day}';

    return '$startStr-$endStr';
  }

  bool _isSameWeek(DateTime date1, DateTime date2) {
    // Get the start of week for both dates
    final start1 = date1.subtract(Duration(days: date1.weekday - 1));
    final start2 = date2.subtract(Duration(days: date2.weekday - 1));

    return start1.year == start2.year &&
        start1.month == start2.month &&
        start1.day == start2.day;
  }
}

class _DayHeader extends StatelessWidget {
  final DateTime date;

  const _DayHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        _formatDayHeader(date),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDayHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return '${date.month}/${date.day}/${date.year}';
  }
}

class _DaySummary extends StatelessWidget {
  final List<Log> logs;

  const _DaySummary({required this.logs});

  @override
  Widget build(BuildContext context) {
    // Count activities by type
    final summary = <String, int>{};
    for (final log in logs) {
      summary[log.type] = (summary[log.type] ?? 0) + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: summary.entries.map((entry) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getIconForType(entry.key),
                const SizedBox(width: 4),
                Text('${entry.value}x ${entry.key}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Icon _getIconForType(String type) {
    switch (type) {
      case 'feeding':
        return const Icon(CupertinoIcons.heart_fill, size: 16);
      case 'sleep':
        return const Icon(CupertinoIcons.moon_fill, size: 16);
      case 'diaper':
        return const Icon(CupertinoIcons.star_fill, size: 16);
      default:
        return const Icon(CupertinoIcons.circle_fill, size: 16);
    }
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
