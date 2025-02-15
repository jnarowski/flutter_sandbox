import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kid.dart';

class KidsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'kids';

  // Get all kids for an account
  Stream<List<Kid>> getKids(String accountId) {
    return _firestore
        .collection(_collection)
        .where('accountId', isEqualTo: accountId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Kid.fromMap(doc.data())).toList());
  }

  // Add a new kid
  Future<void> addKid(Kid kid) async {
    await _firestore.collection(_collection).add(kid.toMap());
  }

  // Update a kid
  Future<void> updateKid(Kid kid) async {
    await _firestore.collection(_collection).doc(kid.id).update(kid.toMap());
  }

  // Delete a kid
  Future<void> deleteKid(String kidId) async {
    await _firestore.collection(_collection).doc(kidId).delete();
  }
}
