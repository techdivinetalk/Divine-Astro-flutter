import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RetentionWidget extends StatelessWidget {
  final Color? borderColor;
  final Color? bottomColor;
  final Color? bottomTextColor;
  final String? title;
  final String? subTitle;
  final Widget? child;

  final VoidCallback? onTap;

  const RetentionWidget({
    super.key,
    this.onTap,
    this.borderColor,
    this.bottomColor,
    this.bottomTextColor,
    this.title,
    this.subTitle,
    this.child,


  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: appColors.transparent,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child ?? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title ?? "",
                  style: AppTextStyle.textStyle9(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:  borderColor ?? Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    subTitle ?? "",
                    style: AppTextStyle.textStyle9(
                      fontWeight: FontWeight.w400,
                      fontColor: bottomTextColor ?? appColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
