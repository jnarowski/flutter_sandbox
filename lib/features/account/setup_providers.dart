import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/features/kids/kid_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sandbox/features/account/account_provider.dart';
import 'package:flutter_sandbox/features/users/user_provider.dart';
import 'package:flutter_sandbox/core/providers/app_provider.dart';
import 'package:flutter_sandbox/core/models/kid.dart';

final registerProvider = Provider.autoDispose((ref) => ({
      required String uid,
      required String email,
    }) async {
      try {
        final accountService = ref.read(accountServiceProvider);
        final userService = ref.read(userServiceProvider);

        final account = await accountService.create();
        final user = await userService.create(
            id: uid, accountId: account.id, email: email);

        return {'account': account, 'user': user};
      } catch (e) {
        print('error registering');
        print(e);
        return null;
      }
    });

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
        accountId: appState.account!.id,
        name: name,
        dob: dob,
        gender: gender,
      );

      final newKid = await kidService.create(kid);

      await accountService.updateCurrentKid(accountId, newKid.id!);

      await ref.read(appProvider.notifier).setCurrentKid(newKid);
    });
