import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';

class BasicPanchangUi extends StatelessWidget {
  const BasicPanchangUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 25.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("day".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                  Text("tithi".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                  Text("yog".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                  Text("nakshatra".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                  Text("sunrise".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                  Text("sunset".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                  Text("karana".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(.5))),
                  SizedBox(height: 16.h),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Thrusday",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Krishna Panchami",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Variyaan",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Jyeshtha",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("05:55:10",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("18:47:20",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Kaulav",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                ],
              ),
              SizedBox(width: 80.w),
            ],
          ),
        ],
      ),
    );
  }
}
