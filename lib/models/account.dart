import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  String? currentKidId;

  Account(
      {required this.id, this.createdAt, this.updatedAt, this.currentKidId});

  // this is cleaner than fromDocument as it doesn't depend on Firestore
  factory Account.fromMap(Map<String, dynamic> data) {
    final createdAtTimestamp = data['createdAt'] as Timestamp?;
    final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

    return Account(
      id: data['id']?.toString() ?? '', // Handle potential null id
      currentKidId: data['currentKidId'] as String?,
      createdAt: createdAtTimestamp?.toDate(),
      updatedAt: updatedAtTimestamp?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentKidId': currentKidId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
