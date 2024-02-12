import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/generated/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

abstract class AppException implements Exception {
  void onException(
      {Function()? onButtonClick,
      String title,
      Function()? onDismissClick,
      String buttonText,
      String dismissButtonText});
}

class NoInternetException extends AppException {
  String message;

  NoInternetException(this.message);
  @override
  void onException(
      {Function()? onButtonClick,
      String title = "",
      Function()? onDismissClick,
      String buttonText = "",
      String dismissButtonText = ""}) {
    divineSnackBar(data: message, color: appColors.redColor);
  }
}

class CustomException extends AppException {
  String message;

  CustomException(this.message);

  @override
  void onException(
      {Function()? onButtonClick,
      String title = "Sorry",
      Function()? onDismissClick,
      String buttonText = "Ok",
      String? dismissButtonText,
      shouldShowFlushBar = true}) {
    if (shouldShowFlushBar) {
      divineSnackBar(data: message, color: appColors.redColor);
    } else {
      debugPrint(message);
    }
  }
}

class OtpInvalidTimerException implements Exception {
  final String message;

  OtpInvalidTimerException(this.message);

  @override
  String toString() {
    return 'MyCustomException: $message';
  }
}


class ManyTimeExException extends StatelessWidget {
  final String? message;
  const ManyTimeExException({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
               SvgPicture.asset("assets/svg/caution.svg",height: 64.h,width: 64.w,),
                SizedBox(height: 20.h),
                CustomText("${message!.split(".").first}!",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: appColors.appRedColour),
                SizedBox(height: 10.h),
                Text(
                  "${message!.split(".").last}",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 20.h),
                MaterialButton(
                    elevation: 0,
                    height: 56,
                    minWidth: Get.width,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    color: appColors.lightYellow,
                    child: Text(
                      "okay".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: appColors.brownColour,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

