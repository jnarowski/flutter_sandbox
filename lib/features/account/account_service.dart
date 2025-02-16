import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/account.dart';
import '../../core/services/logger.dart';

class AccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _accountsCollection;

  AccountService()
      : _accountsCollection = FirebaseFirestore.instance.collection('accounts');

  Future<Account?> fetch(String accountId) async {
    try {
      final doc = await _firestore.collection('accounts').doc(accountId).get();
      if (!doc.exists) return null;

      return Account.fromMap({'id': doc.id, ...doc.data()!});
    } catch (e) {
      logger.i('Error fetching account: $e');
      rethrow;
    }
  }

  Future<void> updateCurrentKid(String accountId, String kidId) async {
    await _accountsCollection.doc(accountId).update({
      'currentKidId': kidId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
