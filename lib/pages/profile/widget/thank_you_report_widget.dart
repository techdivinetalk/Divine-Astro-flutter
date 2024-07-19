import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/custom_widgets.dart';

class ThankYouReportUI extends StatelessWidget {
  const ThankYouReportUI({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: appColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: appColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                CustomText("thankYouForReporting".tr,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    fontColor: appColors.darkBlue),
                SizedBox(height: 20.h),
                Text(
                  "thankYouDes".tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textStyle16(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 30.h),
                MaterialButton(
                    elevation: 0,
                    height: 56,
                    minWidth: Get.width,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    onPressed: onPressed,
                    color: appColors.guideColor,
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