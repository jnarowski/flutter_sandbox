import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/features/kids/kid_provider.dart';
import 'package:flutter_sandbox/core/auth/auth_providers.dart';
import 'package:flutter_sandbox/core/models/account.dart';
import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:flutter_sandbox/core/models/user.dart';
import 'package:flutter_sandbox/features/account/account_provider.dart';
import 'package:flutter_sandbox/features/users/user_provider.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:flutter_sandbox/core/voice/voice_provider.dart';

// Define the state class
class AppState {
  final Account? account;
  final Kid? currentKid;
  final auth.User? authUser;
  final User? user;

  AppState({this.account, this.currentKid, this.authUser, this.user});

  AppState copyWith({Account? account, User? user, Kid? currentKid}) {
    return AppState(
      account: account ?? this.account,
      authUser: authUser ?? authUser,
      currentKid: currentKid ?? this.currentKid,
      user: user ?? this.user,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  final Ref ref;

  AppNotifier(this.ref) : super(AppState());

  Future<void> initialize() async {
    try {
      await initializeVoiceService();
      await initializeData();
    } catch (e) {
      logger.error('Error during app initialization: $e');
      rethrow;
    }
  }

  Future<void> initializeVoiceService() async {
    await ref.read(voiceServiceProvider).initialize();
    logger.i('Voice service initialized');
  }

  Future<void> initializeData() async {
    final authUser = auth.FirebaseAuth.instance.currentUser;
    final userService = ref.read(userServiceProvider);
    final accountService = ref.read(accountServiceProvider);
    final kidService = ref.read(kidServiceProvider);

    if (authUser == null) {
      throw Exception('No authenticated user found');
    }

    // Fetch user data
    final user = await userService.fetch(authUser.uid);

    if (user == null) {
      ref.read(authServiceProvider).signOut();
      throw Exception('No user founds');
    }

    // Fetch account
    final account = await accountService.fetch(user.accountId);

    if (account == null) {
      throw Exception('No account found for user');
    }

    // If no current kid, initialize state with just the account
    if (account.currentKidId == null || account.currentKidId == '') {
      state = AppState(account: account);
      return;
    }

    final currentKid = await kidService.fetch(account.currentKidId ?? '');

    if (currentKid == null) {
      throw Exception('No kid found for account');
    }

    state = AppState(
        account: account,
        authUser: authUser,
        user: user,
        currentKid: currentKid);
  }

  Future<void> setCurrentKid(Kid kid) async {
    final account = state.account!;
    account.currentKidId = kid.id;

    state = state.copyWith(account: account, currentKid: kid);
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(ref);
});
