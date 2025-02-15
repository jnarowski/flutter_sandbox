import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/log.dart';

class LogService {
  final CollectionReference<Map<String, dynamic>> _logsCollection;

  LogService()
      : _logsCollection = FirebaseFirestore.instance.collection('logs');

  Future<Log?> fetch(String id) async {
    try {
      final doc = await _logsCollection.doc(id).get();
      if (!doc.exists) return null;

      return Log.fromMap({'id': doc.id, ...doc.data()!});
    } catch (e) {
      print('Error fetching log: $e');
      rethrow;
    }
  }

  Stream<List<Log>> getAll(String accountId) {
    return _logsCollection
        .where('accountId', isEqualTo: accountId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Log.fromMap(doc.data())).toList());
  }

  Future<void> create(Log log) async {
    await _logsCollection.add(log.toMap());
  }

  Future<void> update(Log log) async {
    await _logsCollection.doc(log.id).update(log.toMap());
  }

  Future<void> delete(String logId) async {
    await _logsCollection.doc(logId).delete();
  }
}
