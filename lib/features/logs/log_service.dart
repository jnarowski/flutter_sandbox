import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sandbox/core/models/log.dart';
import 'package:flutter_sandbox/core/firebase/repository.dart';

class LogService {
  final FirebaseRepository<Log> _repository;

  LogService()
      : _repository = FirebaseRepository<Log>(
          collectionName: 'logs',
          fromMap: Log.fromMap,
        );

  Future<Log?> fetch(String id) => _repository.get(id);

  Stream<List<Log>> getAll(String accountId) {
    return _repository.getAllStream({'accountId': accountId});
  }

  Future<void> create(Log log) async {
    final params = {
      'accountId': log.accountId,
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
      'createdAt': DateTime.now(),
    };

    await _repository.create(Log.fromMap(params));
  }

  Future<void> update(Log log) async {
    final updates = Log.fromMap({
      'id': log.id,
      'accountId': log.accountId,
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
    });

    await _repository.update(updates);
  }

  Future<void> delete(String logId) => _repository.delete(logId);

  Stream<List<Log>> getTodayLogs({
    required String kidId,
    required String accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    Query<Map<String, dynamic>> query = _repository.query({
      'accountId': accountId,
      'kidId': kidId,
    });

    query = query
        .where('startAt', isGreaterThanOrEqualTo: startDate)
        .where('startAt', isLessThan: endDate)
        .orderBy('startAt', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Log.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    });
  }
}
