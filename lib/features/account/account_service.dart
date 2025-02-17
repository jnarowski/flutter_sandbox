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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';
// import '../../core/models/account.dart';
// import '../../core/services/logger.dart';
// import '../../features/kids/kid_service.dart';
// import '../../core/models/kid.dart';

// class AccountService {
//   final CollectionReference<Map<String, dynamic>> _accountsCollection;

//   AccountService()
//       : _accountsCollection = FirebaseFirestore.instance.collection('accounts');

//   Future<Account?> fetch(String accountId) async {
//     try {
//       final doc = await _accountsCollection.doc(accountId).get();
//       if (!doc.exists) return null;

//       return Account.fromMap({'id': doc.id, ...doc.data()!});
//     } catch (e) {
//       logger.i('Error fetching account: $e');
//       rethrow;
//     }
//   }

//   // create
//   // right now we don't have any fields for the account
//   Future<Account> create() async {
//     print('creating account 111');

//     final account = Account(
//       id: const Uuid().v4(),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );

//     // Create the account document
//     await _accountsCollection.doc(account.id).set(account.toMap());

//     print('creating account 222');

//     return account;
//   }

//   // update
//   Future<Account> update(Account account) async {
//     final updates = {
//       'currentKidId': account.currentKidId,
//       'updatedAt': DateTime.now(),
//     };

//     await _accountsCollection.doc(account.id).update(updates);
//     final doc = await _accountsCollection.doc(account.id).get();

//     return Account.fromMap({'id': doc.id, ...doc.data()!});
//   }

//   Future<void> updateCurrentKid(String accountId, String kidId) async {
//     await _accountsCollection.doc(accountId).update({
//       'currentKidId': kidId,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   Future<Kid> createFirstKid({
//     required String accountId,
//     required String name,
//     required DateTime dob,
//     required String gender,
//   }) async {
//     final kidService = KidService();

//     final kid = Kid(
//       accountId: accountId,
//       name: name,
//       dob: dob,
//       gender: gender,
//     );

//     final newKid = await kidService.create(kid);
//     await updateCurrentKid(accountId, newKid.id!);

//     return newKid;
//   }
// }
