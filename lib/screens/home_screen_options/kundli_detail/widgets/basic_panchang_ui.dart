import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/colors.dart';

class BasicPanchangUi extends StatelessWidget {
  final KundliDetailController controller;

  const BasicPanchangUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 40.h),
            detailTile(
              "day".tr,
              controller.birthDetails.value.day == null
                  ? ""
                  : DateFormat("EEEE")
                      .format(DateTime(controller.birthDetails.value.year!,
                          controller.birthDetails.value.month!, controller.birthDetails.value.day!))
                      .toString(),
            ),
            detailTile(
              "tithi".tr,
              controller.astroDetails.value.tithi == null
                  ? ""
                  : controller.astroDetails.value.tithi!,
            ),
            detailTile(
              "yog".tr,
              controller.astroDetails.value.yog == null ? "" : controller.astroDetails.value.yog!,
            ),
            detailTile(
              "nakshatra".tr,
              controller.astroDetails.value.naksahtra == null
                  ? ""
                  : controller.astroDetails.value.naksahtra!,
            ),
            detailTile(
              "sunrise".tr,
              controller.birthDetails.value.sunrise == null
                  ? ""
                  : controller.birthDetails.value.sunrise!,
            ),
            detailTile(
              "sunset".tr,
              controller.birthDetails.value.sunset == null
                  ? ""
                  : controller.birthDetails.value.sunset!,
            ),
            detailTile(
              "karana".tr,
              controller.astroDetails.value.karan == null
                  ? ""
                  : controller.astroDetails.value.karan!,
            ),
          ],
        ),
      ),
    );
  }

  Widget detailTile(String title, String data) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 20.w),
            Expanded(
              child: CustomText(
                title,
                fontSize: 14.sp,
                fontColor: AppColors.darkBlue.withOpacity(0.5),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: CustomText(
                data,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
