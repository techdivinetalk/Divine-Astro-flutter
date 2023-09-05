import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'colors.dart';
import 'custom_widgets.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({Key? key}) : super(key: key);

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
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1),
                ),
                child: ListView.separated(
                  itemCount: 5,
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: AppColors.appYellowColour),
                          color: AppColors.white),
                      height: 80.h,
                      child: Row(
                        children: [
                          SizedBox(width: 20.w),
                          buildMedal(index + 1),
                          SizedBox(width: 8.w),
                          Container(
                            width: 48.w,
                            height: 48.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.blackColor),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText("Username_1",
                                  fontSize: 16.sp,
                                  fontColor: AppColors.darkBlue,
                                  fontWeight: FontWeight.bold),
                              CustomText("₹1000",
                                  fontSize: 18.sp,
                                  fontColor: AppColors.darkBlue),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20.h);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMedal(int index) {
    if (index == 1) {
      return Assets.images.medalOne.image(width: 32.w);
    } else if (index == 2) {
      return Assets.images.medalTwo.image(width: 32.w);
    } else if (index == 3) {
      return Assets.images.medalThree.image(width: 32.w);
    } else {
      return SizedBox(
          width: 32.w,
          child: CustomText(
            index.toString(),
            fontColor: AppColors.darkBlue,
            fontSize: 32.sp,
          ));
    }
  }
}
