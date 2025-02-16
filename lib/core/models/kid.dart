import 'package:cloud_firestore/cloud_firestore.dart';

class Kid {
  final String? id;
  String? accountId;
  final String name;
  final DateTime dob;
  final String gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Kid({
    this.id,
    required this.name,
    required this.dob,
    required this.gender,
    this.accountId,
    this.createdAt,
    this.updatedAt,
  });

  Kid copyWith({
    String? id,
    String? accountId,
    String? name,
    DateTime? dob,
    String? gender,
  }) {
    return Kid(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }

  factory Kid.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAtTimestamp = data['createdAt'] as Timestamp?;
    final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

    return Kid(
      id: doc.id,
      accountId: data['accountId'] ?? '',
      name: data['name'] ?? '',
      dob: (data['dob'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gender: data['gender'] ?? '',
      createdAt: createdAtTimestamp?.toDate(),
      updatedAt: updatedAtTimestamp?.toDate(),
    );
  }

  factory Kid.fromMap(Map<String, dynamic> data) {
    final createdAtTimestamp = data['createdAt'] as Timestamp?;
    final updatedAtTimestamp = data['updatedAt'] as Timestamp?;

    return Kid(
      id: data['id'],
      accountId: data['accountId'] ?? '',
      name: data['name'] ?? '',
      dob: (data['dob'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gender: data['gender'] ?? '',
      createdAt: createdAtTimestamp?.toDate(),
      updatedAt: updatedAtTimestamp?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'name': name,
      'dob': Timestamp.fromDate(dob),
      'gender': gender,
      'createdAt':
          createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
      'updatedAt':
          updatedAt != null ? Timestamp.fromDate(updatedAt!) : Timestamp.now(),
    };
  }
}
