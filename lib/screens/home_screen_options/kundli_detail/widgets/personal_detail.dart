import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  Text("Birth Date",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Birth Time",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Birth Place",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Gan",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Sign Lord",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Sign",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Yoni",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Nakshatra Lord",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Nakshatra",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Varna",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Vashya",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Nadi",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Charan",
                      style: AppTextStyle.textStyle14(
                          fontWeight: FontWeight.w400,
                          fontColor: AppColors.darkBlue.withOpacity(0.5))),
                  SizedBox(height: 16.h),
                  Text("Tatva",
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
