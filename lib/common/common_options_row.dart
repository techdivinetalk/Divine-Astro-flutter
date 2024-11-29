import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'app_textstyle.dart';
import 'colors.dart';

/*class CommonOptionRow extends StatelessWidget {
  final String leftBtnTitle;
  final VoidCallback onLeftTap;
  final String rightBtnTitle;
  final VoidCallback onRightTap;
  final int? feedbackReviewStatus;

  const CommonOptionRow({
    super.key,
    required this.leftBtnTitle,
    required this.onLeftTap,
    required this.rightBtnTitle,
    required this.onRightTap,
    this.feedbackReviewStatus,
  });

  @override
  Widget build(BuildContext context) {
    bool hasReview = feedbackReviewStatus == 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        ).expand(),
        SizedBox(width: 15.w),
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
                    fontWeight: FontWeight.w500,
                    fontColor: appColors.red,
                  ),
                ),
                SizedBox(width: 8.w),
                if (hasReview)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.h),
                    decoration: BoxDecoration(
                      color: appColors.red,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "New",
                      style: AppTextStyle.textStyle12(
                        fontWeight: FontWeight.w500,
                        fontColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ).expand(),
      ],
    );
  }
}*/

class CommonOptionRow extends StatelessWidget {
  final String leftBtnTitle;
  final VoidCallback onLeftTap;
  final String rightBtnTitle;
  final VoidCallback onRightTap;
  final int? feedbackReviewStatus;

  const CommonOptionRow({
    super.key,
    required this.leftBtnTitle,
    required this.onLeftTap,
    required this.rightBtnTitle,
    required this.onRightTap,
    this.feedbackReviewStatus,
  });

  @override
  Widget build(BuildContext context) {
    bool hasReview = feedbackReviewStatus == 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          //onTap: onRightTap,
          child: /*Container(
            height: 37,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 3.0),
                ),
              ],
              gradient: LinearGradient(
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )*/ Container(),
        ).expand(),
        SizedBox(width: 15.w),
        if (feedbackReviewStatus != 0) // Conditionally show/hide based on feedbackReviewStatus
          InkWell(
            onTap: onLeftTap,
            child: Container(
              height: 37,
              decoration: BoxDecoration(
                border: hasReview != false ? Border.all(color: appColors.red, width: 1.0) : Border.all(color: appColors.black, width: 1.0),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    leftBtnTitle,
                    style: AppTextStyle.textStyle12(
                      fontWeight: FontWeight.w500,
                      fontColor: hasReview != false ? appColors.red : appColors.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  if (hasReview)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.h),
                      decoration: BoxDecoration(
                        color: appColors.red,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        "New",
                        style: AppTextStyle.textStyle12(
                          fontWeight: FontWeight.w500,
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ).expand(),
      ],
    );
  }
}


