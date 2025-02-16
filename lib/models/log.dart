import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String? id;
  String? accountId;
  String? note;
  String? kidId;
  String? type;
  DateTime? date;
  DateTime? dateEnd;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? amount;

  Log({
    this.id,
    this.accountId,
    this.amount,
    this.note,
    this.date,
    this.dateEnd,
    this.createdAt,
    this.kidId,
    this.type,
    this.updatedAt,
  });

  Log copyWith({
    String? id,
    double? amount,
    String? accountId,
    String? note,
    String? type,
    DateTime? date,
    DateTime? dateEnd,
  }) {
    return Log(
      accountId: this.accountId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      dateEnd: date ?? this.dateEnd,
      id: id ?? this.id,
      note: note ?? this.note,
      type: type ?? this.type,
    );
  }

  factory Log.fromMap(Map<String, dynamic> data) {
    return Log(
      accountId: data['accountId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      date: _parseDateTime(data['date']),
      dateEnd: _parseDateTime(data['dateEnd']),
      id: data['id'],
      kidId: data['kidId'] ?? '',
      note: data['note'] ?? '',
      type: data['type'] ?? '',
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

// Helper method to handle different datetime formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'amount': amount,
      'date': date,
      'dateEnd': dateEnd,
      'kidId': kidId,
      'note': note,
      'type': type,
      'createdAt':
          createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
      'updatedAt':
          updatedAt != null ? Timestamp.fromDate(updatedAt!) : Timestamp.now()
    };
  }
}
