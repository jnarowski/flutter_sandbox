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
    // Handle both Timestamp and String (ISO8601) formats
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      return null;
    }

    return Account(
      id: data['id']?.toString() ?? '',
      currentKidId: data['currentKidId'] as String?,
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currentKidId': currentKidId,
      // Store as Timestamp for Firestore
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
