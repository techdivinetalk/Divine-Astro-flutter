import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'colors.dart';
import 'custom_widgets.dart';

class CoHostRequest extends StatelessWidget {
  final VoidCallback? onReject, onAccept;
  final String? name;

  const CoHostRequest({Key? key, this.onReject, this.onAccept, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50.0)),
                color: AppColors.white,
                border: Border.all(color: AppColors.appYellowColour)),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  decoration: const BoxDecoration(color: AppColors.white),
                  child: Row(
                    children: [
                      SizedBox(width: 32.w),
                      Container(
                        width: 34.w,
                        height: 34.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Assets.images.avatar.svg(),
                      ),
                      SizedBox(width: 10.w),
                      CustomText(name ?? "",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: AppColors.darkBlue),
                      const Spacer(),
                      const Icon(Icons.call,
                          color: AppColors.darkBlue, size: 16),
                      SizedBox(width: 10.w),
                      CustomText("09 M 38 S",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: AppColors.darkBlue),
                      SizedBox(width: 32.w),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w),
                   /* SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: CustomButton(
                            onTap: () {
                              onReject!.call();
                              Get.back();
                            },
                            color: AppColors.white,
                            border: Border.all(color: AppColors.darkBlue),
                            radius: 28,
                            child: Center(
                              child: CustomText("Reject",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontColor: AppColors.darkBlue),
                            )),
                      ),
                    ),
                    SizedBox(width: 10.w),*/
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: CustomButton(
                            onTap: () {
                              Get.back();
                              onAccept!.call();
                            },
                            color: AppColors.appYellowColour,
                            radius: 28,
                            child: Center(
                              child: CustomText("Accept",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontColor: AppColors.brownColour),
                            )),
                      ),
                    ),
                    SizedBox(width: 20.w),
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
