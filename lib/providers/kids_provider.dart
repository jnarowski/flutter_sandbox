import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/kid.dart';
import '../services/kids_service.dart';

part 'kids_provider.g.dart';

@riverpod
KidsService kidsService(ref) {
  return KidsService();
}

@riverpod
Stream<List<Kid>> kids(ref, String accountId) {
  final kidsService = ref.watch(kidsServiceProvider);
  return kidsService.getKids(accountId);
}

@riverpod
class KidsController extends _$KidsController {
  @override
  FutureOr<void> build() {}

  Future<void> addKid(Kid kid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(kidsServiceProvider).addKid(kid);
    });
  }

  Future<void> updateKid(Kid kid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(kidsServiceProvider).updateKid(kid);
    });
  }

  Future<void> deleteKid(String kidId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(kidsServiceProvider).deleteKid(kidId);
    });
  }
}
