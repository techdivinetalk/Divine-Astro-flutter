import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';

class DoshaUi extends StatelessWidget {
  final KundliDetailController controller;

  const DoshaUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 40.h),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  details(
                      title: "Manglik Dosha",
                      details: controller.manglikDosh.value.manglikReport == null
                          ? ""
                          : controller.manglikDosh.value.manglikReport!),
                  details(
                      title: "Kalsarp Dosha",
                      details: controller.kalsarpaDosh.value.oneLine == null
                          ? ""
                          : controller.kalsarpaDosh.value.oneLine!),
                  details(
                    title: "Sadesathi Dosha",
                    details: controller.sadesathiDosh.value.isUndergoingSadhesati == null
                        ? ""
                        : "${controller.sadesathiDosh.value.isUndergoingSadhesati!} ${controller.sadesathiDosh.value.sadhesatiStatus! ? " ${controller.sadesathiDosh.value.sadhesatiPhase!} of Sadesathi from ${controller.sadesathiDosh.value.startDate!} to ${controller.sadesathiDosh.value.endDate!}." : ""}",
                  ),
                  details(
                    title: "Pitri Dosha",
                    details: controller.pitraDosh.value.conclusion == null
                        ? ""
                        : controller.pitraDosh.value.conclusion!,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget details({required String title, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w500, fontColor: AppColors.appYellowColour)),
        SizedBox(height: 5.h),
        Text(
          details,
          style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w500, fontColor: AppColors.blackColor.withOpacity(.5)),
        ),
        SizedBox(height: 16.h)
      ],
    );
  }
}
