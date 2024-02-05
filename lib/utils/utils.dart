import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/internet_speed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/date_time_picker.dart';

class Utils {
  static const animationDuration = Duration(milliseconds: 200);

  static String dateToString(DateTime now, {String format = 'dd MMMM yyyy'}) {
    return DateFormat(format).format(now);
  }

  static selectDateOrTime(
      {required String title,
        required String btnTitle,
        required String pickerStyle,
        DateTime? initialDate,
        required Function(String datetime) onChange,
        required Function(String datetime) onConfirm,
        required bool looping}) {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) => DateTimePicker(
        initialDate: initialDate,
        pickerStyle: pickerStyle,
        title: title,
        buttonTitle: btnTitle,
        onChange: (value) => onChange(value),
        onConfirm: (value) => onConfirm(value),
        looping: looping,
      ),
    );
  }

}

 checkInternetSpeed(bool checkDownloadSpeed,BuildContext context)async{
  final internetSpeedController =  Get.put<InternetSpeedController>(InternetSpeedController());
  final speed =  checkDownloadSpeed?await internetSpeedController.getDownloadSpeed():await internetSpeedController.getUploadSpeed();
  if(speed<50){
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: const Text('Low Speed Connection'),

      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.w),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 200.h,
          right: 20.w,
          left: 20.w),
    ));
  }print("current Download Speed is $speed");
}

double viewBottomPadding(double padding) {
  return Get.mediaQuery.viewPadding.bottom > 0
      ? Get.mediaQuery.viewPadding.bottom
      : padding;
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
