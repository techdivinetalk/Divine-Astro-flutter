import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/internet_speed.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

 checkInternetSpeed(bool checkDownloadSpeed, BuildContext context) async {
  final internetSpeedController =
      Get.put<InternetSpeedController>(InternetSpeedController());
  final speed = checkDownloadSpeed
      ? await internetSpeedController.getDownloadSpeed()
      : await internetSpeedController.getUploadSpeed();
  if (speed < 50) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w), color: appColors.white),
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            Assets.images.tablet2353161.svg(),
            SizedBox(width: 4.w),
            Text(
              'raiseTechnicalIssues'.tr,
              style: AppTextStyle.textStyle14(fontColor: appColors.black),
            ),
            const Spacer(),
            const Icon(Icons.arrow_right)
          ],
        ),
      ),
      SizedBox(height: 7.h),
      Container(
        decoration: BoxDecoration(
            color: appColors.white, borderRadius: BorderRadius.circular(10.w)),
        padding: EdgeInsets.all(10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'internetSpeed'.tr} :',
                        style:
                            AppTextStyle.textStyle14(fontColor: appColors.black),
                      ),
                      Text(
                        'poor'.tr,
                        style: AppTextStyle.textStyle16(
                            fontColor: appColors.red,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    'badInternetConnection'.tr,
                    style: AppTextStyle.textStyle14(
                        fontColor: appColors.red, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Assets.images.group.svg(color: appColors.red)
          ],
        ),
      )
    ]),
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.w),
    ),
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 240.h,
        right: 20.w,
        left: 20.w),
  ));
  }
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
//             color: color != null ? appColors.white : appColors.blackColor),
//       ),
//       backgroundColor: color ?? appColors.lightYellow,
//       showCloseIcon: true,
//       closeIconColor: color != null ? appColors.white : appColors.blackColor,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
