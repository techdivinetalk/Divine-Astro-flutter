import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalDetailUi extends StatelessWidget {
  final KundliDetailController controller;

  const PersonalDetailUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: kToolbarHeight.h * 2.5),
            SizedBox(height: 40.h),
            detailTile(
              "birthDate".tr,
              controller.birthDetails.value.day == null
                  ? ""
                  : "${controller.birthDetails.value.day.toString().padLeft(2, '0')}-${controller.birthDetails.value.month.toString().padLeft(2, '0')}-${controller.birthDetails.value.year}",
            ),
            detailTile(
              "birthTime".tr,
              controller.birthDetails.value.hour == null
                  ? ""
                  : "${(controller.birthDetails.value.hour! > 12 ? controller.birthDetails.value.hour! - 12 : controller.birthDetails.value.hour).toString().padLeft(2, "0")}:${controller.birthDetails.value.minute.toString().padLeft(2, "0")} ${controller.birthDetails.value.hour! > 11 ? "PM" : "AM"}",
            ),
            detailTile(
              "birthPlace".tr,
              controller.kundliController.params.value.location!,
            ),
            detailTile(
              "gan".tr,
              controller.astroDetails.value.gan == null ? "" : controller.astroDetails.value.gan!,
            ),
            detailTile(
              "signLord".tr,
              controller.astroDetails.value.signLord == null
                  ? ""
                  : controller.astroDetails.value.signLord!,
            ),
            detailTile(
              "sign".tr,
              controller.astroDetails.value.sign == null ? "" : controller.astroDetails.value.sign!,
            ),
            detailTile(
              "yoni".tr,
              controller.astroDetails.value.yoni == null ? "" : controller.astroDetails.value.yoni!,
            ),
            detailTile(
              "nakshatraLord".tr,
              controller.astroDetails.value.naksahtraLord == null
                  ? ""
                  : controller.astroDetails.value.naksahtraLord!,
            ),
            detailTile(
              "nakshatra".tr,
              controller.astroDetails.value.naksahtra == null
                  ? ""
                  : controller.astroDetails.value.naksahtra!,
            ),
            detailTile(
              "varna".tr,
              controller.astroDetails.value.varna == null
                  ? ""
                  : controller.astroDetails.value.varna!,
            ),
            detailTile(
              "vashya".tr,
              controller.astroDetails.value.vashya == null
                  ? ""
                  : controller.astroDetails.value.vashya!,
            ),
            detailTile(
              "nadi".tr,
              controller.astroDetails.value.nadi == null ? "" : controller.astroDetails.value.nadi!,
            ),
            detailTile(
              "charan".tr,
              controller.astroDetails.value.charan == null
                  ? ""
                  : "${controller.astroDetails.value.charan!}",
            ),
            detailTile(
              "tatva".tr,
              controller.astroDetails.value.tatva == null
                  ? ""
                  : controller.astroDetails.value.tatva!,
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
