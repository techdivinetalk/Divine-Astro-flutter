import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/common_bottomsheet.dart';
import '../../../common/custom_widgets.dart';
import '../performance_controller.dart';

class DateSelection extends GetView<PerformanceController> {
  const DateSelection({super.key});

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
                  'Select Custom Date',
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectDateOrTime(Get.context!,
                              title: "Select Start Date",
                              btnTitle: "Confirm",
                              pickerStyle: "DateCalendar",
                              looping: true,
                              onConfirm: (value) {},
                              onChange: (value) {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(width: 0.6, color: Colors.grey)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 18.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.images.icCalendar.svg(height: 20.h),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Start Date",
                                  style: AppTextStyle.textStyle16(
                                      fontColor: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          selectDateOrTime(Get.context!,
                              title: "Select End Date",
                              btnTitle: "Confirm",
                              pickerStyle: "DateCalendar",
                              looping: true,
                              onConfirm: (value) {},
                              onChange: (value) {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border:
                                  Border.all(width: 0.6, color: Colors.grey)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 18.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.images.icCalendar.svg(height: 20.h),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "End Date",
                                  style: AppTextStyle.textStyle16(
                                      fontColor: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
