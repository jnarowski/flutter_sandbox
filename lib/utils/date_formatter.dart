import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _defaultFormat =
      DateFormat('MMM d, yyyy'); // Jan 1, 2024
  static final DateFormat _shortFormat = DateFormat('MM/dd/yyyy'); // 01/01/2024

  static String format(DateTime? date, {DateFormat? formatter}) {
    if (date == null) return 'No date';
    return (formatter ?? _defaultFormat).format(date);
  }

  static String formatShort(DateTime? date) {
    return format(date, formatter: _shortFormat);
  }
}
