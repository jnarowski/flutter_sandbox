import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/models/user.dart';
import 'user_service.dart';

part 'user_provider.g.dart';

@riverpod
UserService userService(ref) {
  return UserService();
}

final usersStreamProvider =
    StreamProvider.family<List<User>, String>((ref, accountId) {
  final userService = ref.watch(userServiceProvider);
  return userService.getAll(accountId: accountId);
});
