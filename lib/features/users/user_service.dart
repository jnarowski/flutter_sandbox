import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user.dart';
import '../../core/services/logger.dart';
import 'package:uuid/uuid.dart';

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
    final user = User(
      id: id,
      accountId: accountId,
      email: email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _usersCollection.doc(id).set(user.toMap());

    return user;
  }

  Future<void> update(User user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      logger.i('Error updating user: $e');
      rethrow;
    }
  }

  /// Invites a new user to join the account
  Future<User> invite({
    required String email,
    required String accountId,
    required String invitedById,
  }) async {
    try {
      // Generate a unique invite token
      final inviteToken = const Uuid().v4();

      // Create a new user document with invited status
      final user = User(
        id: inviteToken, // We'll use this as temporary ID until they accept
        accountId: accountId,
        email: email,
        status: 'invited',
        inviteToken: inviteToken,
        invitedById: invitedById,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _usersCollection.doc(inviteToken).set(user.toMap());

      // TODO: Send invitation email
      // This would typically be handled by a Cloud Function

      return user;
    } catch (e) {
      logger.e('Error inviting user: $e');
      rethrow;
    }
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
      userData['status'] = 'active';
      userData['updatedAt'] = DateTime.now().toIso8601String();

      // Create new document with the Firebase Auth UID
      await _usersCollection.doc(newUserId).set(userData);

      // Delete the temporary invitation document
      await _usersCollection.doc(inviteToken).delete();
    } catch (e) {
      logger.e('Error accepting invitation: $e');
      rethrow;
    }
  }
}
