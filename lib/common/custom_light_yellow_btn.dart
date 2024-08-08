import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_textstyle.dart';
import 'colors.dart';

class CustomLightYellowButton extends StatelessWidget {
  final String name;
  final Widget? widget;
  final VoidCallback onTaped;

  CustomLightYellowButton(
      {super.key, required this.name, required this.onTaped, this.widget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
      child: InkWell(
        onTap: () => onTaped(),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: appColors.guideColor,
                borderRadius: BorderRadius.circular(12)),
            child: widget ?? Center(
                child: Padding(
              padding: EdgeInsets.all(18.h),
              child: Text(
                name,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w600,
                    fontColor: appColors.white),
              ),
            ))),
      ),
    );
  }
}

class CustomLightYellowCurveButton extends StatelessWidget {
  final String name;
  final VoidCallback onTaped;
  final Color? btnColor;
  final Color? textColor;

  const CustomLightYellowCurveButton(
      {super.key,
      required this.name,
      required this.onTaped,
      this.btnColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: InkWell(
        onTap: () => onTaped(),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: btnColor ?? appColors.guideColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(12.h),
              child: Text(
                name,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w600,
                    fontColor: textColor ?? appColors.brownColour),
              ),
            ))),
      ),
    );
  }
}
