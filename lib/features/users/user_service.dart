import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user.dart';
import '../../core/services/logger.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
    await _usersCollection.doc(id).set({
      'accountId': accountId,
      'email': email,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });

    final docSnap = await _usersCollection.doc(id).get();

    return User.fromMap({'id': docSnap.id, ...docSnap.data()!});
  }

  Future<void> update(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      logger.i('Error updating user: $e');
      rethrow;
    }
  }
}
