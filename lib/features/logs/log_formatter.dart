import 'package:flutter/cupertino.dart';
import '../../core/models/log.dart';

class LogFormatter {
  static IconData getIcon(Log log) {
    switch (log.type) {
      case 'feeding':
        if (log.category == 'nursing') {
          return CupertinoIcons.heart_fill;
        } else {
          return CupertinoIcons.drop_fill;
        }

      case 'sleep':
        return CupertinoIcons.moon_fill;

      case 'medicine':
        return CupertinoIcons.bandage_fill;

      case 'solids':
        return CupertinoIcons.cart_fill;

      case 'bathroom':
        if (log.category == 'diaper') {
          return CupertinoIcons.sparkles;
        } else {
          return CupertinoIcons.circle_grid_hex_fill;
        }

      case 'pumping':
        return CupertinoIcons.drop_triangle_fill;

      case 'activity':
        switch (log.category) {
          case 'tummy time':
            return CupertinoIcons.person_crop_circle_fill;
          case 'bath':
            return CupertinoIcons.drop_fill;
          case 'walk':
            return CupertinoIcons.paw_solid;
          case 'reading':
            return CupertinoIcons.book_fill;
          default:
            return CupertinoIcons.star_fill;
        }

      case 'growth':
        return CupertinoIcons.graph_circle_fill;

      default:
        return CupertinoIcons.circle_fill;
    }
  }

  static String getTitle(Log log) {
    switch (log.type) {
      case 'feeding':
        if (log.category == 'nursing') {
          final leftDuration =
              Duration(seconds: log.data?['durationLeft'] ?? 0);
          final rightDuration =
              Duration(seconds: log.data?['rightDuration'] ?? 0);
          final total = leftDuration + rightDuration;
          return 'Nursing - ${total.inMinutes} minutes';
        } else {
          return 'Bottle - ${log.amount} ${log.unit}';
        }

      case 'sleep':
        if (log.endAt != null) {
          final duration = log.endAt!.difference(log.startAt);
          return 'Sleep - ${duration.inMinutes} minutes';
        }
        return 'Sleep';

      case 'medicine':
        return 'Medicine - ${log.amount} ${log.unit}';

      case 'solids':
        final foods = (log.data?['foods'] as List<dynamic>?)
            ?.map((f) => f['name'])
            .join(', ');
        return 'Solids - ${foods ?? 'Unknown food'}';

      case 'bathroom':
        final type = log.category == 'diaper' ? 'Diaper' : 'Potty';
        final subType = log.subCategory
            ?.split(' ')
            .map((word) => word[0].toUpperCase() + word.substring(1))
            .join(' ');
        return '$type - $subType';

      case 'pumping':
        final leftDuration = Duration(seconds: log.data?['leftDuration'] ?? 0);
        final rightDuration =
            Duration(seconds: log.data?['rightDuration'] ?? 0);
        final total = leftDuration + rightDuration;
        return 'Pumping - ${total.inMinutes} minutes';

      case 'activity':
        return 'Activity - ${log.category?.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ')}';

      case 'growth':
        final measurements = <String>[];
        if (log.data?['height'] != null) {
          measurements.add('${log.data!['height']} ${log.data!['heightUnit']}');
        }
        if (log.data?['weight'] != null) {
          measurements.add('${log.data!['weight']} ${log.data!['weightUnit']}');
        }
        if (log.data?['head'] != null) {
          measurements.add('${log.data!['head']} ${log.data!['headUnit']}');
        }
        return 'Growth - ${measurements.join(', ')}';

      default:
        return log.type;
    }
  }

  static String getSubtitle(Log log) {
    final time = _formatTime(log.startAt);
    final notes = log.notes?.isNotEmpty == true ? ' - ${log.notes}' : '';
    return '$time$notes';
  }

  static String _formatTime(DateTime time) {
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
