import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/custom_progress_dialog.dart';
import '../../../../tarotCard/widget/custom_image_view.dart';

class LagnaUi extends StatelessWidget {
  final KundliDetailController controller;

  const LagnaUi({Key? key, required this.controller}) : super(key: key);

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
              crossFadeState: controller.lagnaChart.value.data?.svg == null
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
              firstChild: controller.lagnaChart.value.data?.svg != null
                  ? Center(
                      child: CustomImageView(
                        // height: 40,
                        // width: 40,
                        imagePath:
                            "${controller.preference.getAmazonUrl()}${controller.lagnaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  //
                  // SvgPicture.string(
                  //     controller.moonChart.value.data?.svg ?? '',
                  //   )
                  : SizedBox(),
              // [log] http://13.235.46.27/api/astro/v7/getChartImage/MOON
              // [log] response: {"data":{"svg":"images\/divine_kundi_png_667bd87c25cac.png"},"success":true,"status_code":200,"message":"Data saved successfully!"}
              // [log] http://13.235.46.27/api/astro/v7/getChartImage/:chartId
              // [log] response: {"data":{"svg":"images\/divine_kundi_png_667bd82c8c6b1.png"},"success":true,"status_code":200,"message":"Data saved successfully!"}
            ),
          ),
        ],
      ),
    );
  }
}
