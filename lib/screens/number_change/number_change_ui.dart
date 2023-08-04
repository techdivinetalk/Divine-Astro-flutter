import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/strings.dart';
import 'number_change_controller.dart';

class NumberChangeReqUI extends GetView<NumberChangeReqController> {
  const NumberChangeReqUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          AppString.numberChangeRequest,
          style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppString.numChangeMsgTitle,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.greyColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.greyColor),
              ),
              SizedBox(
                height: 20.h,
              ),
              //primary Phone Number
              Text(
                AppString.primaryPhoneNumber,
                style: AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  Text(
                    "+91",
                    style:
                        AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: TextField(
                    style:
                        AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyColor),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.extraLightGrey),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.h),
                        child: Center(
                          child: Text(
                            AppString.update,
                            style: AppTextStyle.textStyle16(
                                fontColor: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),
              //Secondary Phone Number
              Text(
                AppString.secondaryPhoneNumber,
                style: AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  Text(
                    "+91",
                    style:
                        AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                      child: TextField(
                    style:
                        AppTextStyle.textStyle20(fontColor: AppColors.darkBlue),
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      counterText: "",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greyColor),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.lightYellow),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 10.h),
                        child: Center(
                          child: Text(
                            AppString.update,
                            style: AppTextStyle.textStyle16(
                                fontColor: AppColors.brownColour),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
