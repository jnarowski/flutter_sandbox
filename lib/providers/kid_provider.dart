import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/kid.dart';
import '../services/kid_service.dart';

part 'kid_provider.g.dart';

@riverpod
KidService kidService(ref) {
  return KidService();
}

@riverpod
class KidsController extends _$KidsController {
  @override
  FutureOr<void> build() {}

  Future<void> addKid(Kid kid) async {
    state = await AsyncValue.guard(() async {
      await ref.read(kidServiceProvider).create(kid);
    });
  }

  Future<void> updateKid(Kid kid) async {
    state = await AsyncValue.guard(() async {
      await ref.read(kidServiceProvider).update(kid);
    });
  }

  Future<void> deleteKid(String kidId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(kidServiceProvider).delete(kidId);
    });
  }
}
