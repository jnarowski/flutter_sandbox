import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/kid.dart';
import '../../core/services/logger.dart';

class KidService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _kidsCollection;

  KidService()
      : _kidsCollection = FirebaseFirestore.instance.collection('kids');

  Future<Kid?> fetch(String id) async {
    try {
      final doc = await _kidsCollection.doc(id).get();
      if (!doc.exists) return null;

      return Kid.fromMap({'id': doc.id, ...doc.data()!});
    } catch (e) {
      logger.i('Error fetching kid: $e');
      rethrow;
    }
  }

  Stream<List<Kid>> getAll(String accountId) {
    return _kidsCollection
        .where('accountId', isEqualTo: accountId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Kid.fromMap({'id': doc.id, ...doc.data()}))
            .toList());
  }

  Future<void> create(Kid kid) async {
    await _kidsCollection.add(kid.toMap());
  }

  Future<void> update(Kid kid) async {
    await _kidsCollection.doc(kid.id).update(kid.toMap());
  }

  Future<void> delete(String kidId) async {
    await _kidsCollection.doc(kidId).delete();
  }
}
