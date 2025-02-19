import 'package:flutter_sandbox/core/models/account.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:flutter_sandbox/features/kids/kid_service.dart';
import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:flutter_sandbox/core/firebase/repository.dart';
import 'package:uuid/uuid.dart';

class AccountService {
  final FirebaseRepository<Account> _repository;

  AccountService()
      : _repository = FirebaseRepository<Account>(
          collectionName: 'accounts',
          fromMap: Account.fromMap,
        );

  Future<Account?> fetch(String accountId) async {
    try {
      return await _repository.get(accountId);
    } catch (e) {
      logger.i('Error fetching account: $e');
      rethrow;
    }
  }

  Future<Account> create() async {
    try {
      final account = Account(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return await _repository.create(account);
    } catch (e) {
      logger.i('Error creating account: $e');
      rethrow;
    }
  }

  Future<Account> update(Account account) async {
    try {
      await _repository.update(account);
      return (await _repository.get(account.id))!;
    } catch (e) {
      logger.i('Error updating account: $e');
      rethrow;
    }
  }

  Future<void> updateCurrentKid(String accountId, String kidId) async {
    try {
      final account = Account(
          id: accountId, currentKidId: kidId, updatedAt: DateTime.now());
      await _repository.update(account);
    } catch (e) {
      logger.i('Error updating current kid: $e');
      rethrow;
    }
  }

  Future<Kid> createFirstKid({
    required String accountId,
    required String name,
    required DateTime dob,
    required String gender,
  }) async {
    final kidService = KidService();

    final kid = Kid(
      id: const Uuid().v4(),
      accountId: accountId,
      name: name,
      dob: dob,
      gender: gender,
    );

    final newKid = await kidService.create(kid);
    await updateCurrentKid(accountId, newKid.id);

    return newKid;
  }
}
