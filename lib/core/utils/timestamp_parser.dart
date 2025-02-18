import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampParser {
  static DateTime? parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
