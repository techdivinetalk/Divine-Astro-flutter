import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/colors.dart';
import '../../../../common/custom_progress_dialog.dart';

class BasicPanchangUi extends StatelessWidget {
  final KundliDetailController controller;

  const BasicPanchangUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: (controller.birthDetails.value.data?.day == null && controller.astroDetails.value.data?.tithi == null)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          secondChild: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: kToolbarHeight.h * 2.5),
              SizedBox(height: 150.h),
              const LoadingWidget(),
            ],
          ),
          firstChild: Column(
            children: [
              SizedBox(height: kToolbarHeight.h * 2.5),
              SizedBox(height: 40.h),
              detailTile(
                "day".tr,
                controller.birthDetails.value.data?.day == null
                    ? ""
                    : DateFormat("EEEE")
                        .format(DateTime(
                            controller.birthDetails.value.data?.year??0,
                            controller.birthDetails.value.data?.month??0,
                            controller.birthDetails.value.data?.day??0))
                        .toString(),
              ),
              detailTile(
                "tithi".tr,
                controller.astroDetails.value.data?.tithi == null
                    ? ""
                    : controller.astroDetails.value.data?.tithi ?? '',
              ),
              detailTile(
                "yog".tr,
                controller.astroDetails.value.data?.yog == null
                    ? ""
                    : controller.astroDetails.value.data?.yog ?? '',
              ),
              detailTile(
                "nakshatra".tr,
                controller.astroDetails.value.data?.naksahtra == null
                    ? ""
                    : controller.astroDetails.value.data?.naksahtra??'',
              ),
              detailTile(
                "sunrise".tr,
                controller.birthDetails.value.data?.sunrise == null
                    ? ""
                    : controller.birthDetails.value.data?.sunrise??'',
              ),
              detailTile(
                "sunset".tr,
                controller.birthDetails.value.data?.sunset == null
                    ? ""
                    : controller.birthDetails.value.data?.sunset??'',
              ),
              detailTile(
                "karana".tr,
                controller.astroDetails.value.data?.karan == null
                    ? ""
                    : controller.astroDetails.value.data?.karan??'',
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
                fontColor: appColors.darkBlue.withOpacity(0.5),
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
