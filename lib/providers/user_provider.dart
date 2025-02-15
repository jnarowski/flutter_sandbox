import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';
import '../models/user.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

// Provides the current user data (not auth user)
final userDataProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<User?> {
  final Ref ref;

  UserNotifier(this.ref) : super(null);

  Future<void> loadUser(String userId) async {
    try {
      final userService = ref.read(userServiceProvider);
      final user = await userService.fetchUser(userId);

      state = user;
    } catch (e) {
      print('Error loading user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final userService = ref.read(userServiceProvider);
      await userService.updateUser(user);
      state = user;
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
}
