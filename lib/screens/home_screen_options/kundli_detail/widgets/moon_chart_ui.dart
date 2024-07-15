import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/custom_progress_dialog.dart';
import '../../../../tarotCard/widget/custom_image_view.dart';

class MoonChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const MoonChartUi({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.moonChart.value.data?.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const KundliLoading(),
                ],
              ),
              firstChild: controller.moonChart.value.data?.svg != null
                  ? Center(
                      child: CustomImageView(
                        // height: 40,
                        // width: 40,
                        imagePath:
                            "${controller.preference.getAmazonUrl()}/${controller.moonChart.value.data!.svg}",
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
            ),
          ),
        ],
      ),
    );
  }
}
