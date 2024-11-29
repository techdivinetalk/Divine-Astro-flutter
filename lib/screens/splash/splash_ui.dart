import 'package:divine_astrologer/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class SplashUI extends GetView<SplashController> {
  const SplashUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      assignId: true,
      init: SplashController(),

      builder: (controller) {
        return Scaffold(
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: appColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/ganesh_ji.png",
                  fit: BoxFit.cover,
                  width: 214.h,
                  height: 256.h,
                ),
                // const SizedBox(height: 20),
                // SizedBox(
                //   width: 300.h,
                //   child: LinearProgressIndicator(
                //     borderRadius: BorderRadius.circular(30),
                //     value: controller.progessValue, // Current progress
                //     backgroundColor: Colors.grey[300], // Background color
                //     color: appColors.guideColor,
                //   ),
                // ),
                // const SizedBox(height: 16),
                // Text(
                //   "Verifying your Details...",
                //   style: AppTextStyle.textStyle16(
                //     fontColor: appColors.textColor,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
