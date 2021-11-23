import 'package:intl/intl.dart';

class Format {
  //Get the DateTime object in hh:mm format
  static String getHourMinute(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  //Get the day of the week
  static String getWeekDay(DateTime dateTime) {
    return DateFormat.EEEE().format(dateTime);
  }
}
