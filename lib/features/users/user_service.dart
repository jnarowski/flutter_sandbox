import 'package:flutter_sandbox/core/models/user.dart';
import 'package:flutter_sandbox/core/firebase/repository.dart';
import 'package:flutter_sandbox/core/services/logger.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class UserService {
  final FirebaseRepository<User> _repository;

  UserService()
      : _repository = FirebaseRepository<User>(
          collectionName: 'users',
          fromMap: User.fromMap,
        );

  Future<User?> fetch(String userId) async {
    try {
      return await _repository.get(userId);
    } catch (e) {
      logger.i('Error fetching user: $e');
      rethrow;
    }
  }

  Future<User> create({
    required String id,
    required String accountId,
    required String email,
  }) async {
    try {
      final user = User(
        id: id,
        accountId: accountId,
        email: email,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return await _repository.create(user);
    } catch (e) {
      logger.i('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> update(User user) async {
    try {
      await _repository.update(user);
    } catch (e) {
      logger.i('Error updating user: $e');
      rethrow;
    }
  }

  String _generateVerificationCode() {
    final random = Random();
    return (100000 + random.nextInt(900000))
        .toString(); // Generates 6-digit code
  }

  /// Invites a new user to join the account
  Future<User> invite({
    required String email,
    required String accountId,
    required String invitedById,
  }) async {
    try {
      // Generate a unique invite token and verification code
      final inviteToken = const Uuid().v4();
      final verificationCode = _generateVerificationCode();

      // Create a new user document with invited status
      final user = User(
        id: inviteToken,
        accountId: accountId,
        email: email,
        status: UserStatus.invited,
        inviteToken: inviteToken,
        invitedById: invitedById,
        verificationCode: verificationCode,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.create(user);

      // TODO: Send invitation email with verification code
      // This would typically be handled by a Cloud Function

      return user;
    } catch (e) {
      logger.e('Error inviting user: $e');
      rethrow;
    }
  }

  Future<User?> findFirstBy(Map<String, dynamic> filters) async {
    try {
      return await _repository.findFirst(filters);
    } catch (e) {
      logger.e('Error finding user: $e');
      rethrow;
    }
  }

  /// Accepts an invitation using verification code
  Future<User?> verifyInvitationCode({
    required String verificationCode,
  }) async {
    return findFirstBy({
      'status': UserStatus.invited.toJson(),
      'verificationCode': verificationCode,
    });
  }

  /// Accepts an invitation for a user
  Future<void> acceptInvitation({
    required String verificationCode,
    required String password,
  }) async {
    try {
      final user = await findFirstBy({
        'status': UserStatus.invited.toJson(),
        'verificationCode': verificationCode,
      });

      if (user == null) {
        throw Exception('Invitation not found');
      }

      await _repository.update(user.copyWith(
        status: UserStatus.active,
        verificationCode: null,
      ));
    } catch (e) {
      logger.e('Error accepting invitation: $e');
      rethrow;
    }
  }

  /// Deletes a user document
  Future<void> delete(String userId) async {
    try {
      await _repository.delete(userId);
    } catch (e) {
      logger.e('Error deleting user: $e');
      rethrow;
    }
  }

  /// Gets a stream of all users for a specific account
  Stream<List<User>> getAll({required String accountId}) {
    logger.d('Creating users query for account: $accountId');

    return _repository.getAllStream({'accountId': accountId});
  }
}
