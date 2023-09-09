import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';
import '../../../../common/custom_progress_dialog.dart';

class PredictionUi extends StatelessWidget {
  final KundliDetailController controller;

  const PredictionUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 40.h),
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: (controller.kundliPrediction.value.data?.physical?.first == null)
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: kToolbarHeight.h * 2.5),
                  SizedBox(height: 50.h),
                  const LoadingWidget(),
                ],
              ),
              firstChild: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    details(
                        // title: "Professional Life",
                        title: "Physical",
                        details: controller
                                .kundliPrediction.value.data?.physical?.first ??
                            ''),
                    // .join("\n")),
                    details(
                        // title: "Luck",
                        title: "Character",
                        details: controller
                                .kundliPrediction.value.data?.character?.first ??
                            ''),
                    // .join("\n")),
                    details(
                        title: "Health",
                        details: controller
                                .kundliPrediction.value.data?.health?.first ??
                            ''),
                    // .join("\n")),
                    details(
                        // title: "Profession",
                        title: "Education",
                        details: controller
                                .kundliPrediction.value.data?.education?.first ??
                            ''),
                    // .join("\n")),
                    details(
                        // title: "Emotion",
                        title: "Family",
                        details: controller
                                .kundliPrediction.value.data?.family?.first ??
                            ''),
                    // .join("\n")),
                  ],
                ),
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
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
        SizedBox(height: 5.h),
        Text(
          details,
          style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w500,
              fontColor: AppColors.blackColor.withOpacity(.5)),
        ),
        SizedBox(height: 16.h)
      ],
    );
  }
}
