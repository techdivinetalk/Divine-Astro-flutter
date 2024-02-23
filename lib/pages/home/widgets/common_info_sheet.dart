import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonInfoSheet extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const CommonInfoSheet({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 20,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: CircleAvatar(
            backgroundColor: appColors.textColor,
            radius: 35,
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ),
        ),
        // const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 30.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(48.h)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Text(
                title ?? "",
                style: AppTextStyle.textStyle20(
                  fontColor: appColors.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                subTitle ?? "",
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle16(
                  fontColor: appColors.textColor,
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
                      fontColor: appColors.brownColour,
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
