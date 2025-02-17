import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/user.dart' as app_models;
import '../../core/models/account.dart';
import 'package:uuid/uuid.dart';

class RegistrationService {
  final FirebaseFirestore _firestore;

  RegistrationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<app_models.User> create(firebase_auth.User firebaseUser) async {
    // Create a new account first
    final account = Account(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    print('creating account');

    // Create the account document
    await _firestore
        .collection('accounts')
        .doc(account.id)
        .set(account.toMap());

    print('account created');

    // Create the user document
    final user = app_models.User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      accountId: account.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save the user document
    await _firestore.collection('users').doc(user.id).set(user.toMap());

    return user;
  }
}
