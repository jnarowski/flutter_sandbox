import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:flutter_sandbox/features/logs/log_provider.dart';
import 'package:flutter_sandbox/features/dashboard/widgets/activity_card.dart';
import 'package:flutter_sandbox/features/dashboard/widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLogs = ref.watch(todayLogsProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Dashboard'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    "Today's Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  todayLogs.when(
                    data: (logs) => SummaryCard(logs: logs),
                    loading: () => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Today's Activity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  todayLogs.when(
                    data: (logs) => ActivityCard(logs: logs),
                    loading: () => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Builder(
                        builder: (context) {
                          logger.i('Dashboard error: $error');
                          return Text('Error: $error');
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
