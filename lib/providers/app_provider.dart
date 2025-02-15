import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';
import '../models/account.dart';
import '../models/kid.dart';

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
      final user = ref.read(currentUserProvider);

      print('user: $user');

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // TODO: Fetch account data for user.uid
      // final account = await fetchAccountForUser(user.uid);
      // TODO: Fetch current kid if exists
      // final currentKid = await fetchCurrentKidForAccount(account);
      // state = AppState(account: account, currentKid: currentKid);
    } catch (e) {
      print('Error initializing app: $e');
      rethrow; // Rethrow to show error in AppInitGate
    }
  }

  Future<void> setCurrentKid(Kid kid) async {
    try {
      if (state.account != null) {
        // TODO: Update currentKidId in Firebase
        state = state.copyWith(currentKid: kid);
      }
    } catch (e) {
      print('Error setting current kid: $e');
    }
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(ref);
});
