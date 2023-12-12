import 'package:intl/intl.dart';

class DateUtil {

  static String formatDate(String dateFromMySQL) {
    final DateTime parsedDate = DateTime.parse(dateFromMySQL);
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(parsedDate);

    if (difference.inHours < 24) {
      return '${difference.inHours}시간 전1';
    } else {
      return DateFormat('yy-MM-dd').format(parsedDate);
    }
  }
}