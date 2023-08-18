import 'package:divine_astrologer/screens/home_screen_options/kundli_detail/kundli_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SunChartUi extends StatelessWidget {
  final KundliDetailController controller;

  const SunChartUi({Key? key, required this.controller}) : super(key: key);

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
              crossFadeState: controller.sunChart.value.svg == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              secondChild: const SizedBox(width: double.maxFinite),
              firstChild: SvgPicture.string(
                controller.sunChart.value.svg!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
