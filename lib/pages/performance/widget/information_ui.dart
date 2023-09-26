import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/custom_widgets.dart';
import '../performance_controller.dart';

class InformationUI extends GetView<PerformanceController> {
  const InformationUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
              color: AppColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                CustomText(
                  'title'.tr,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  controller.txt,
                  style: AppTextStyle.textStyle16(fontColor: Colors.black),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.lightYellow,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          minimumSize: Size.zero,
                        ),
                        child: CustomText(
                          'gotIt'.tr,
                          fontSize: 16.sp,
                          fontColor: AppColors.brownColour,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
