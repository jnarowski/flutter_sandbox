import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user.dart';
import 'user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final usersStreamProvider = StreamProvider<List<User>>((ref) {
  final usersCollection = FirebaseFirestore.instance.collection('users');
  return usersCollection.snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) => User.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  });
});
