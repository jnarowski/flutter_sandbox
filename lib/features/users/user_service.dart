import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user.dart';
import '../../core/services/logger.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> fetch(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) return null;
      final user = User.fromMap({'id': doc.id, ...doc.data()!});
      return user;
    } catch (e) {
      logger.i('Error fetching user: $e');
      rethrow;
    }
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
