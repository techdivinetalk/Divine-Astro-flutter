import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PujaSubmitedBottomSheet extends StatelessWidget {
  const PujaSubmitedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(48.h)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SvgPicture.asset("assets/svg/done.svg"),
              const SizedBox(height: 8),
              Text(
                "Product Submitted",
                style: AppTextStyle.textStyle20(
                  fontColor: appColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We will review your product details to begin showcasing on your profile for purchase.",
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14(
                  fontColor: appColors.textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.back(result: 1);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: appColors.guideColor,
                  ),
                  child: Text(
                    "Got it",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyle20(
                      fontColor: appColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
