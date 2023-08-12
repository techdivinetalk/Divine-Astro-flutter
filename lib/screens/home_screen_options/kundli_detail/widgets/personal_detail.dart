import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/colors.dart';

class PersonalDetailUi extends StatelessWidget {
  const PersonalDetailUi({Key? key}) : super(key: key);

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
                  Text("birthDate".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("birthTime".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("birthPlace".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("gan".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("signLord".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("sign".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("yoni".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("nakshatraLord".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("nakshatra".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("varna".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("vashya".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("nadi".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("charan".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("tatva".tr,
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("16-04-1998",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("9:40 PM",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("New Delhi, Delhi",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Rakshasha",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Mars",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Scorpio",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Mrig",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Mercury",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Jeyshtha",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Vipra",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Keetak",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Adi",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("3",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue)),
                  SizedBox(height: 16.h),
                  Text("Water",
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
