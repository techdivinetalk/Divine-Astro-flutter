import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            width: 90,
            height: 37,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.darkBlue, width: 1.0),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Center(
              child: Text(
                leftBtnTitle,
                style: AppTextStyle.textStyle14(
                    fontWeight: FontWeight.w500, fontColor: AppColors.darkBlue),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onRightTap,
          child: Container(
            width: 172,
            height: 37,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 1.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.appYellowColour, AppColors.gradientBottom],
              ),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Center(
              child: Text(
                "suggestRemedies".tr,
                style: AppTextStyle.textStyle14(
                    fontColor: AppColors.brownColour,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        )
      ],
    );
  }
}
