import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';
import '../../../../common/custom_progress_dialog.dart';

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
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: (controller.manglikDosh.value.data?.manglik
                  ?.manglikReport ==
                  null && controller.kalsarpaDosh.value.data
                  ?.kalsarpaDetails?.oneLine ==
                  null && controller.sadesathiDosh.value.data?.sadhesatiCurrentStatus?.isUndergoingSadhesati ==
                  null && controller.pitraDosh.value.data?.pitraDoshaReport?.conclusion == null)
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    details(
                        title: "Manglik Dosha",
                        details: controller.manglikDosh.value.data?.manglik
                                    ?.manglikReport ==
                                null
                            ? ""
                            : controller.manglikDosh.value.data?.manglik
                                    ?.manglikReport ??
                                ''),
                    details(
                        title: "Kalsarp Dosha",
                        details: controller.kalsarpaDosh.value.data
                                    ?.kalsarpaDetails?.oneLine ==
                                null
                            ? ""
                            : controller.kalsarpaDosh.value.data?.kalsarpaDetails
                                    ?.oneLine ??
                                ''),
                    details(
                      title: "Sadesathi Dosha",
                      details: controller
                                  .sadesathiDosh
                                  .value
                                  .data
                                  ?.sadhesatiCurrentStatus
                                  ?.isUndergoingSadhesati ==
                              null
                          ? ""
                          : "${controller.sadesathiDosh.value.data?.sadhesatiCurrentStatus?.isUndergoingSadhesati} ${(controller.sadesathiDosh.value.data?.sadhesatiCurrentStatus?.sadhesatiStatus ?? false) ? " ${controller.sadesathiDosh.value.data?.sadhesatiCurrentStatus?.sadhesatiPhase ?? ''} of Sadesathi from ${controller.sadesathiDosh.value.data?.sadhesatiCurrentStatus?.startDate ?? ''} to ${controller.sadesathiDosh.value.data?.sadhesatiCurrentStatus?.endDate ?? ''}." : ""}",
                    ),
                    details(
                      title: "Pitri Dosha",
                      details: controller.pitraDosh.value.data?.pitraDoshaReport
                                  ?.conclusion ==
                              null
                          ? ""
                          : controller.pitraDosh.value.data?.pitraDoshaReport
                                  ?.conclusion ??
                              '',
                    ),
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
