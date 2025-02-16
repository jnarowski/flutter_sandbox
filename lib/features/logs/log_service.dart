import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/models/log.dart';
import '../../core/services/logger.dart';

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
      logger.i('Error fetching log: $e');
      rethrow;
    }
  }

  Stream<List<Log>> getAll(String accountId) {
    return _logsCollection
        .where('accountId', isEqualTo: accountId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Log.fromMap({'id': doc.id, ...doc.data()}))
            .toList());
  }

  Future<void> create(Log log) async {
    await _logsCollection.add(log.toMap());
  }

  Future<void> update(Log log) async {
    // Only allow updating mutable fields, excluding id and accountId
    final updates = {
      'kidId': log.kidId,
      'type': log.type,
      'category': log.category,
      'subCategory': log.subCategory,
      'startAt': log.startAt,
      'endAt': log.endAt,
      'amount': log.amount,
      'unit': log.unit,
      'notes': log.notes,
      'data': log.data,
      'updatedAt': DateTime.now(),
    };

    await _logsCollection.doc(log.id).update(updates);
  }

  Future<void> delete(String logId) async {
    await _logsCollection.doc(logId).delete();
  }

  Stream<List<Log>> getTodayLogs({
    required String kidId,
    required String accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _logsCollection
        .where('accountId', isEqualTo: accountId)
        .where('kidId', isEqualTo: kidId)
        .where('startAt', isGreaterThanOrEqualTo: startDate)
        .where('startAt', isLessThan: endDate)
        .orderBy('startAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Log.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    });
  }
}
