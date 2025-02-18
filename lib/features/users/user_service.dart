import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user.dart';
import '../../core/services/logger.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class UserService {
  final CollectionReference<Map<String, dynamic>> _usersCollection;

  UserService()
      : _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<User?> fetch(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();

      if (!doc.exists) return null;
      final user = User.fromMap({'id': doc.id, ...doc.data()!});
      return user;
    } catch (e) {
      logger.i('Error fetching user: $e');
      rethrow;
    }
  }

  // create
  Future<User> create({
    required String id,
    required String accountId,
    required String email,
  }) async {
    try {
      print('creating user');
      final user = User(
        id: id,
        accountId: accountId,
        email: email,
        status: UserStatus.active,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _usersCollection.doc(id).set(user.toMap());

      print('user created');

      return user;
    } catch (e) {
      logger.i('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> update(User user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toMap());
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

      await _usersCollection.doc(inviteToken).set(user.toMap());

      // TODO: Send invitation email with verification code
      // This would typically be handled by a Cloud Function

      return user;
    } catch (e) {
      logger.e('Error inviting user: $e');
      rethrow;
    }
  }

  /// Accepts an invitation using verification code
  Future<User?> verifyInvitationCode({
    required String verificationCode,
  }) async {
    final query = _usersCollection
        .where('status', isEqualTo: UserStatus.invited.toJson())
        .where('verificationCode', isEqualTo: verificationCode);

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final userDoc = querySnapshot.docs.first;
    return User.fromMap({...userDoc.data(), 'id': userDoc.id});
  }

  /// Accepts an invitation for a user
  Future<void> acceptInvitation({
    required String inviteToken,
    required String newUserId,
  }) async {
    try {
      final userDoc = await _usersCollection.doc(inviteToken).get();

      if (!userDoc.exists) {
        throw Exception('Invitation not found');
      }

      final userData = userDoc.data()!;
      userData['id'] = newUserId;
      userData['status'] = UserStatus.active.toJson();
      userData['updatedAt'] = DateTime.now().toIso8601String();
      userData['verificationCode'] = null; // Clear the verification code

      // Create new document with the Firebase Auth UID
      await _usersCollection.doc(newUserId).set(userData);

      // Delete the temporary invitation document
      await _usersCollection.doc(inviteToken).delete();
    } catch (e) {
      logger.e('Error accepting invitation: $e');
      rethrow;
    }
  }

  /// Deletes a user document
  Future<void> delete(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      logger.e('Error deleting user: $e');
      rethrow;
    }
  }

  /// Gets a stream of all users for a specific account
  Stream<List<User>> getAll({required String accountId}) {
    logger.d('Creating users query for account: $accountId');

    return _usersCollection
        .where('accountId', isEqualTo: accountId)
        .snapshots()
        .map((snapshot) {
      logger
          .d('Received users snapshot with ${snapshot.docs.length} documents');
      return snapshot.docs
          .map((doc) => User.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }
}
