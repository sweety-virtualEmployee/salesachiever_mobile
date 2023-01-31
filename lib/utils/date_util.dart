import 'package:intl/intl.dart';

class DateUtil {
  static String getFormattedDate(String? date) {
    if (date == null || date == '') {
      return '';
    }

    var dt = DateTime.parse(date);
    var formatter = new DateFormat('MMM dd, yyyy');
    //var formatter = new DateFormat('dd MMM, yyyy');
    String formatted = formatter.format(dt);
    return formatted;
  }

  static String getFormattedTime(String? date) {
    if (date == null || date == '') {
      return '';
    }

    var dt = DateTime.parse(date);
    var formatter = new DateFormat('h:mm a');
    String formatted = formatter.format(dt);
    return formatted;
  }

  static String getFormattedDateTime(String? date) {
    if (date == null || date == '') {
      return '';
    }

    var dt = DateTime.parse(date);
    var formatter = new DateFormat('MMM dd, yyyy HH:mm');
    String formatted = formatter.format(dt);
    return formatted;
  }
}
