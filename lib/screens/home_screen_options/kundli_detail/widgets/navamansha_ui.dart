import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/custom_progress_dialog.dart';
import '../../../../tarotCard/widget/custom_image_view.dart';

class NavamanshaUi extends StatelessWidget {
  final KundliDetailController controller;

  const NavamanshaUi({Key? key, required this.controller}) : super(key: key);

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
              crossFadeState: controller.navamashaChart.value.data?.svg == null
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
              firstChild: controller.navamashaChart.value.data?.svg != null
                  ? Center(
                      child: CustomImageView(
                        // height: 40,
                        // width: 40,
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.navamashaChart.value.data!.svg}",
                        radius: BorderRadius.circular(10),
                        placeHolder: "assets/images/default_profile.png",
                        fit: BoxFit.cover,
                      ),
                    )

                  // SvgPicture.string(
                  //     controller.moonChart.value.data?.svg ?? '',
                  //   )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
