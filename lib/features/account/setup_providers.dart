import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/features/kids/kid_provider.dart';
import 'package:flutter_sandbox/features/account/account_provider.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:uuid/uuid.dart';

final createFirstKidProvider = Provider.autoDispose((ref) => ({
      required String accountId,
      required String name,
      required DateTime dob,
      required String gender,
    }) async {
      final accountService = ref.read(accountServiceProvider);
      final kidService = ref.read(kidServiceProvider);
      final appState = ref.read(appProvider);

      final kid = Kid(
        id: const Uuid().v4(),
        accountId: appState.account!.id,
        name: name,
        dob: dob,
        gender: gender,
      );

      final newKid = await kidService.create(kid);

      await accountService.updateCurrentKid(accountId, newKid.id!);

      await ref.read(appProvider.notifier).setCurrentKid(newKid);
    });
