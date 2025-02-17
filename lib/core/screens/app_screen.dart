import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/features/kids/kids_screen.dart';
import 'package:flutter_sandbox/features/logs/logs_screen.dart';
import 'package:flutter_sandbox/features/account/account_screen.dart';
import 'package:flutter_sandbox/features/dashboard/dashboard_screen.dart';
import 'package:flutter_sandbox/core/providers/intelligence_provider.dart';
// import '../ai/llm_service.dart';
import 'package:flutter_sandbox/core/services/logger.dart';

class AppScreen extends ConsumerWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(intelligenceProvider);

    // llmService.processMessage(
    //   message: 'Hello. How are you? Can you tell me a joke?',
    //   provider: LLMProvider.openAI,
    //   options: {
    //     'model': 'gpt-4o',
    //   },
    // ).then((response) => logger.i('Response: ${response.text}'));

    if (message.isNotEmpty) {
      logger.d('Last message: ${message[0]}');
    }

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Kids',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Account',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const DashboardScreen();
          case 1:
            return const LogsScreen();
          case 2:
            return const KidsScreen();
          case 3:
            return const AccountScreen();
          default:
            return const DashboardScreen();
        }
      },
    );
  }
}
