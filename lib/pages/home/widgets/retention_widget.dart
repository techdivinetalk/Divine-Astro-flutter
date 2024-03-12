import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';

class RetentionWidget extends StatelessWidget {
  final Color? borderColor;
  final Color? bottomColor;
  final Color? bottomTextColor;
  final String? title;
  final String? subTitle;
  final Widget? child;

  const RetentionWidget({
    this.borderColor,
    this.bottomColor,
    this.bottomTextColor, this.title, this.subTitle, this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: appColors.transparent,
        border: Border.all(color: borderColor ?? appColors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child:child ?? Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                title ?? "",
                style: AppTextStyle.textStyle10(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bottomColor ?? appColors.green,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  subTitle ?? "",
                  style: AppTextStyle.textStyle10(
                    fontWeight: FontWeight.w400,
                    fontColor: bottomTextColor ?? appColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
