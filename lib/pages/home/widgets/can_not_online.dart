import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CantOnline extends StatelessWidget {
  const CantOnline({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 20,
      children: [
        // GestureDetector(
        //   onTap: () {
        //     Get.back();
        //   },
        //   child: Container(
        //     height: 60,
        //     width: 60,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         color: appColors.white,
        //       ),
        //     ),
        //     child: const Icon(
        //       Icons.close_rounded,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(48.h)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SvgPicture.asset("assets/svg/caution.svg"),
              const SizedBox(height: 8),
              Text(
                "Can’t Go Online",
                style: AppTextStyle.textStyle20(
                  fontWeight: FontWeight.w600,
                  fontColor: appColors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "To activate your presence ON THE PLATFORM, YOU NEED TO Stream live for 2 hours.",
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.back();
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
