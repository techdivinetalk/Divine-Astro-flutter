import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'app_textstyle.dart';
import 'colors.dart';

class CommonOptionRow extends StatelessWidget {
  final String leftBtnTitle;
  final VoidCallback onLeftTap;
  final String rightBtnTitle;
  final VoidCallback onRightTap;

  const CommonOptionRow({
    super.key,
    required this.leftBtnTitle,
    required this.onLeftTap,
    required this.rightBtnTitle,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onLeftTap,
          child: Container(
            height: 37,
            decoration: BoxDecoration(
              border: Border.all(color: appColors.red, width: 1.0),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  leftBtnTitle,
                  style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500, fontColor: appColors.red),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.h,),
                  decoration: BoxDecoration(
                    color: appColors.red, // Set the background color
                    borderRadius: BorderRadius.circular(20.0), // Set the border radius
                  ),
                  child: Text(
                    "New",
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: Colors.white, // Set the text color
                    ),
                  ),
                )
              ],
            ),
          ),
        ).expand(),
        SizedBox(width: 15.w),
        InkWell(
          onTap: onRightTap,
          child: Container(
            height: 37,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              gradient:  LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [appColors.appYellowColour, appColors.gradientBottom],
              ),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Center(
              child: Text(
                "suggestRemedies".tr,
                style: AppTextStyle.textStyle12(
                    fontColor: appColors.brownColour,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ).expand()
      ],
    );
  }
}
