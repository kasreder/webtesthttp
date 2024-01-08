import 'package:intl/intl.dart';

class DateUtil {

  static String formatDate(String dateFromMySQL) {
    final DateTime parsedDate = DateTime.parse(dateFromMySQL);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(parsedDate);

    if (difference.inMinutes < 360) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 6) {
      return '${difference.inHours}시간 전';
    } else {
      return DateFormat('yy-MM-dd').format(parsedDate);
    }
  }
}