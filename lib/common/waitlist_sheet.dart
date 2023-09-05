import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'colors.dart';
import 'custom_widgets.dart';

class WaitList extends StatelessWidget {
  final VoidCallback? onReject, onAccept;

  const WaitList({Key? key, this.onReject, this.onAccept}) : super(key: key);

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
                border: Border.all(color: AppColors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: AppColors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50.0)),
                color: AppColors.white,
                border: Border.all(color: AppColors.appYellowColour)),
            child: Column(
              children: [
                SizedBox(height: 32.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 21.w),
                    child: CustomText("Waitlist",
                        fontSize: 20.sp, fontColor: AppColors.darkBlue),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 100.h,
                  child: ListView.separated(
                    itemCount: 3,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(color: AppColors.white),
                        child: Row(
                          children: [
                            SizedBox(width: 32.w),
                            Container(
                              width: 34.w,
                              height: 34.h,
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Assets.images.avatar.svg(),
                            ),
                            SizedBox(width: 10.w),
                            CustomText("Rahul",
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
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20.h);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 21.w),
                    child: CustomText("Next In Line",
                        fontSize: 20.sp, fontColor: AppColors.darkBlue),
                  ),
                ),
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
                      CustomText("Rahul",
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
                  children: [
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: CustomButton(
                            onTap: () {
                              onReject!();
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
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: CustomButton(
                            onTap: () {
                              onAccept!();
                              Get.back();
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
