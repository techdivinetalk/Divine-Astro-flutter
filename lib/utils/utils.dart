import 'package:intl/intl.dart';

class Utils {
  static const animationDuration = Duration(milliseconds: 200);

  static String dateToString(DateTime now, {String format = 'dd MMMM yyyy'}) {
    return DateFormat(format).format(now);
  }
}
