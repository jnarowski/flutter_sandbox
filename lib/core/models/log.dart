import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String? id;
  String? accountId;
  String? kidId;
  String type;
  String? category;
  String? subCategory;
  DateTime startAt;
  DateTime? endAt;
  double? amount;
  String? unit;
  String? notes;
  Map<String, dynamic>? data;
  DateTime? createdAt;
  DateTime? updatedAt;

  Log({
    this.id,
    this.accountId,
    this.kidId,
    required this.type,
    this.category,
    this.subCategory,
    required this.startAt,
    this.endAt,
    this.amount,
    this.unit,
    this.notes,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  Log copyWith({
    String? id,
    String? accountId,
    String? kidId,
    String? type,
    String? category,
    String? subCategory,
    DateTime? startAt,
    DateTime? endAt,
    double? amount,
    String? unit,
    String? notes,
    Map<String, dynamic>? data,
  }) {
    return Log(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      kidId: kidId ?? this.kidId,
      type: type ?? this.type,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      data: data ?? this.data,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    );
  }

  factory Log.fromMap(Map<String, dynamic> data) {
    return Log(
      id: data['id'],
      accountId: data['accountId'],
      kidId: data['kidId'],
      type: data['type'] ?? '',
      category: data['category'],
      subCategory: data['subCategory'],
      startAt: _parseDateTime(data['startAt']) ?? DateTime.now(),
      endAt: _parseDateTime(data['endAt']),
      amount: (data['amount'] ?? 0).toDouble(),
      unit: data['unit'],
      notes: data['notes'],
      data: data['data'] as Map<String, dynamic>?,
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'kidId': kidId,
      'type': type,
      'category': category,
      'subCategory': subCategory,
      'startAt': startAt,
      'endAt': endAt,
      'amount': amount,
      'unit': unit,
      'notes': notes,
      'data': data,
      'createdAt':
          createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
      'updatedAt':
          updatedAt != null ? Timestamp.fromDate(updatedAt!) : Timestamp.now(),
    };
  }
}

// Enums for type validation
enum LogType {
  feeding,
  medicine,
  sleep,
  solids,
  pumping,
  bathroom,
  activity,
  growth,
}

// Common units
enum LogUnit {
  oz,
  ml,
  drops,
  tsp,
  minutes,
  hours,
  inches,
  cm,
  lbs,
  kg,
}
