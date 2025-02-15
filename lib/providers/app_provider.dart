import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/providers/kids_provider.dart';
import 'auth_providers.dart';
import '../models/account.dart';
import '../models/kid.dart';
import '../providers/account_provider.dart';
import '../providers/user_provider.dart';
import '../providers/kids_provider.dart';

// Define the state class
class AppState {
  final Account? account;
  final Kid? currentKid;

  AppState({this.account, this.currentKid});

  AppState copyWith({Account? account, Kid? currentKid}) {
    return AppState(
      account: account ?? this.account,
      currentKid: currentKid ?? this.currentKid,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  final Ref ref;

  AppNotifier(this.ref) : super(AppState());

  Future<void> initialize() async {
    try {
      final authUser = ref.read(currentUserProvider);
      final userService = ref.read(userServiceProvider);
      final accountService = ref.read(accountServiceProvider);
      final kidsService = ref.read(kidsServiceProvider);

      if (authUser == null) {
        throw Exception('No authenticated user found');
      }

      // Fetch user data
      final user = await userService.fetchUser(authUser.uid);

      if (user == null) {
        throw Exception('No user found');
      }

      // Fetch account
      final account = await accountService.fetch(user.accountId);

      if (account == null) {
        throw Exception('No account found for user');
      }

      // Fetch kid
      final currentKid = await kidsService.fetch(account.currentKidId ?? '');

      if (currentKid == null) {
        throw Exception('No kid found for account');
      }

      state = AppState(account: account, currentKid: currentKid);
    } catch (e) {
      print('Error initializing app: $e');
      rethrow;
    }
  }

  Future<void> setCurrentKid(Kid kid) async {
    try {
      if (state.account != null) {
        final accountService = ref.read(accountServiceProvider);
        await accountService.updateCurrentKid(state.account!.id, kid.id!);
        state = state.copyWith(currentKid: kid);
      }
    } catch (e) {
      print('Error setting current kid: $e');
      rethrow;
    }
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(ref);
});
