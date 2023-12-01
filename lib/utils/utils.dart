import 'package:intl/intl.dart';

class Utils {
  static const animationDuration = Duration(milliseconds: 200);

  static String dateToString(DateTime now, {String format = 'dd MMMM yyyy'}) {
    return DateFormat(format).format(now);
  }
}

// void divineSnackBar({required String data, Color? color}) {
//   BuildContext? context = navigator?.context;
//   if (data[data.length - 1] != ".") {
//     data = "$data.";
//   }
//   if (context != null) {
//     final snackBar = SnackBar(
//       content: Text(
//         data,
//         style: TextStyle(
//             color: color != null ? AppColors.white : AppColors.blackColor),
//       ),
//       backgroundColor: color ?? AppColors.lightYellow,
//       showCloseIcon: true,
//       closeIconColor: color != null ? AppColors.white : AppColors.blackColor,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
