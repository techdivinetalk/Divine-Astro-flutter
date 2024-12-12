import 'dart:io';
import "dart:math";

import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/screens/auth/login/login_controller.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../common/colors.dart';
import '../common/date_time_picker.dart';

class Utils {
  static const animationDuration = Duration(milliseconds: 200);

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement!.text;

    return parsedString;
  }

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

  Future<void> handleStatusCode400(String message) async {
    debugPrint("test_handleStatusCode400: call");

    /// response.statusCode == HttpStatus.badRequest

    divineSnackBar(data: message, color: appColors.redColor);
  }

  flutterDatePicker(
      {String? dateFormat,
      DateTime? lastDate,
      firstDate,
      DateTime? initialDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2500),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.guideColor,
              onPrimary: Colors.white,
              onSurface: appColors.guideColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appColors.guideColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String? formattedDate;
    if (pickedDate != null) {
      formattedDate = DateFormat(dateFormat ?? "dd/MM/yyyy").format(pickedDate);
    }
    return formattedDate;
  }

  Future<void> handleStatusCodeUnauthorizedBackend() async {
    debugPrint("test_handleStatusCodeUnauthorized: Backend");

    /// responseBody["status_code"] == HttpStatus.unauthorized
    // status code 401

    if (!isUnauthorizedUserCalled) {
      isUnauthorizedUserCalled = true;
      await preferenceService.erase();
      Get.delete<LoginController>(force: true);
      await Get.offAllNamed(RouteName.login);
    }
  }

  Future<void> handleStatusCodeUnauthorizedServer() async {
    debugPrint("test_handleStatusCodeUnauthorized: Server");

    /// response.statusCode == HttpStatus.unauthorized

    // await preferenceService.erase();
    // await Get.offAllNamed(RouteName.loginPage);
  }

  void handleCatchPreferenceServiceErase() {
    debugPrint("test_handleStatusCodeUnauthorized: Erase");

    /// catch (e, s) { preferenceService.erase(); }

    // preferenceService.erase();
  }

  // Function to convert hex color string to Color object
  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    }
    return Colors.black; // default color if invalid hexColor
  }
}

/*checkInternetSpeed(bool checkDownloadSpeed, BuildContext context) async {
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
}*/

double viewBottomPadding(double padding) {
  return Get.mediaQuery.viewPadding.bottom > 0
      ? Get.mediaQuery.viewPadding.bottom
      : padding;
}

// format file size
String getfilesizestring({required int bytes, int decimals = 0}) {
  if (bytes <= 0) return "0 bytes";
  const suffixes = [" bytes", "kb", "mb", "gb", "tb"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
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

