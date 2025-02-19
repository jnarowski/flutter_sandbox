import 'package:flutter_sandbox/core/models/kid.dart';
import 'package:flutter_sandbox/core/firebase/repository.dart';

class KidService {
  final FirebaseRepository<Kid> _repository;

  KidService()
      : _repository = FirebaseRepository<Kid>(
          collectionName: 'kids',
          fromMap: Kid.fromMap,
        );

  Future<Kid?> fetch(String id) async {
    return _repository.get(id);
  }

  Future<List<Kid>> getAll(String accountId) {
    return _repository.getAll({'accountId': accountId});
  }

  Stream<List<Kid>> getAllStream(String accountId) {
    return _repository.getAllStream({'accountId': accountId});
  }

  Future<Kid> create(Kid kid) async {
    return _repository.create(kid);
  }

  Future<void> update(Kid kid) async {
    // Only allow updating mutable fields
    final updates = Kid(
      id: kid.id,
      accountId: kid.accountId,
      name: kid.name,
      dob: kid.dob,
      gender: kid.gender,
      createdAt: kid.createdAt,
      updatedAt: DateTime.now(),
    );

    await _repository.update(updates);
  }

  Future<void> delete(String kidId) async {
    await _repository.delete(kidId);
  }
}
