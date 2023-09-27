import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/custom_progress_dialog.dart';

class PersonalDetailUi extends StatelessWidget {
  final KundliDetailController controller;

  const PersonalDetailUi({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => AnimatedCrossFade(
          crossFadeState: (controller.birthDetails.value.data?.day == null &&
                  controller.astroDetails.value.data?.gan == null)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          secondChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: kToolbarHeight.h * 4.5),
              SizedBox(height: 110.h),
              const LoadingWidget(),
            ],
          ),
          firstChild: Column(
            children: [
              SizedBox(height: kToolbarHeight.h * 2.5),
              SizedBox(height: 40.h),
              detailTile(
                "name".tr,
                controller.kundliParams.value.name == null
                    ? ""
                    : "${controller.kundliParams.value.name}",
              ),
              detailTile(
                "birthDate".tr,
                controller.birthDetails.value.data?.day == null
                    ? ""
                    : "${controller.birthDetails.value.data?.day.toString().padLeft(2, '0')}-${controller.birthDetails.value.data?.month.toString().padLeft(2, '0')}-${controller.birthDetails.value.data?.year}",
              ),
              detailTile(
                "birthTime".tr,
                controller.birthDetails.value.data?.hour == null
                    ? ""
                    : "${((controller.birthDetails.value.data?.hour ?? 0) > 12 ? (controller.birthDetails.value.data?.hour ?? 0) - 12 : controller.birthDetails.value.data?.hour).toString().padLeft(2, "0")}:${controller.birthDetails.value.data?.minute.toString().padLeft(2, "0")} ${(controller.birthDetails.value.data?.hour ?? 0) > 11 ? "PM" : "AM"}",
              ),
              detailTile(
                "birthPlace".tr,
                controller.kundliParams.value.location == null
                    ? ""
                    : (controller.kundliParams.value.location ?? ''),
              ),
              detailTile(
                "gan".tr,
                controller.astroDetails.value.data?.gan == null
                    ? ""
                    : controller.astroDetails.value.data?.gan ?? '',
              ),
              detailTile(
                "signLord".tr,
                controller.astroDetails.value.data?.signLord == null
                    ? ""
                    : controller.astroDetails.value.data?.signLord ?? '',
              ),
              detailTile(
                "sign".tr,
                controller.astroDetails.value.data?.sign == null
                    ? ""
                    : controller.astroDetails.value.data?.sign ?? '',
              ),
              detailTile(
                "yoni".tr,
                controller.astroDetails.value.data?.yoni == null
                    ? ""
                    : controller.astroDetails.value.data?.yoni ?? '',
              ),
              detailTile(
                "nakshatraLord".tr,
                controller.astroDetails.value.data?.naksahtraLord == null
                    ? ""
                    : controller.astroDetails.value.data?.naksahtraLord ?? '',
              ),
              detailTile(
                "nakshatra".tr,
                controller.astroDetails.value.data?.naksahtra == null
                    ? ""
                    : controller.astroDetails.value.data?.naksahtra ?? '',
              ),
              detailTile(
                "varna".tr,
                controller.astroDetails.value.data?.varna == null
                    ? ""
                    : controller.astroDetails.value.data?.varna ?? '',
              ),
              detailTile(
                "vashya".tr,
                controller.astroDetails.value.data?.vashya == null
                    ? ""
                    : controller.astroDetails.value.data?.vashya ?? '',
              ),
              detailTile(
                "nadi".tr,
                controller.astroDetails.value.data?.nadi == null
                    ? ""
                    : controller.astroDetails.value.data?.nadi ?? '',
              ),
              detailTile(
                "charan".tr,
                controller.astroDetails.value.data?.charan == null
                    ? ""
                    : "${controller.astroDetails.value.data?.charan ?? ''}",
              ),
              detailTile(
                "tatva".tr,
                controller.astroDetails.value.data?.tatva == null
                    ? ""
                    : controller.astroDetails.value.data?.tatva ?? '',
              ),
            ],
          ),
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
