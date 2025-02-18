import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/logger.dart';
import '../models/base_model.dart';

class FirebaseRepository<T extends BaseModel> {
  final String collectionName;
  final T Function(Map<String, dynamic>) fromMap;
  late final CollectionReference<Map<String, dynamic>> _collection;

  FirebaseRepository({
    required this.collectionName,
    required this.fromMap,
  }) {
    _collection = FirebaseFirestore.instance.collection(collectionName);
  }

  Future<T?> get(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return fromMap({'id': doc.id, ...doc.data()!});
    } catch (e) {
      logger.e('Error fetching document from $collectionName: $e');
      rethrow;
    }
  }

  Future<T> create(T item) async {
    try {
      final docRef = _collection.doc(item.id);
      final data = item.toMap();
      await docRef.set(data);
      return item;
    } catch (e) {
      logger.e('Error creating document in $collectionName: $e');
      rethrow;
    }
  }

  Future<void> update(T item) async {
    try {
      await _collection.doc(item.id).update(item.toMap());
    } catch (e) {
      logger.e('Error updating document in $collectionName: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      logger.e('Error deleting document from $collectionName: $e');
      rethrow;
    }
  }

  Query<Map<String, dynamic>> query([Map<String, dynamic>? filters]) {
    Query<Map<String, dynamic>> query = _collection;

    if (filters != null) {
      filters.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });
    }

    return query;
  }

  Future<T?> findFirst([Map<String, dynamic>? filters]) async {
    try {
      final querySnapshot = await query(filters).limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      return fromMap({'id': doc.id, ...doc.data()});
    } catch (e) {
      logger.e('Error finding first document in $collectionName: $e');
      rethrow;
    }
  }

  Future<List<T>> getAll([Map<String, dynamic>? filters]) async {
    try {
      Query<Map<String, dynamic>> query = _collection;

      if (filters != null) {
        filters.forEach((field, value) {
          query = query.where(field, isEqualTo: value);
        });
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      logger.e('Error fetching documents from $collectionName: $e');
      rethrow;
    }
  }

  Stream<List<T>> getAllStream([Map<String, dynamic>? filters]) {
    try {
      Query<Map<String, dynamic>> query = _collection;

      if (filters != null) {
        filters.forEach((field, value) {
          query = query.where(field, isEqualTo: value);
        });
      }

      return query.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => fromMap({'id': doc.id, ...doc.data()}))
          .toList());
    } catch (e) {
      logger.e('Error creating stream for $collectionName: $e');
      rethrow;
    }
  }
}
