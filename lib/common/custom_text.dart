import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class CustomText extends StatelessWidget {
  final int? maxLines;
  final String text;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const CustomText(this.text,
      {super.key,
      this.fontColor,
      this.maxLines,
      this.overflow,
      this.fontSize,
      this.fontWeight,
      this.textAlign,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? DefaultTextStyle.of(context).maxLines,
      style: TextStyle(

        color: fontColor ?? AppColors.darkBlue,
        fontSize: fontSize ?? 15.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: textDecoration ?? TextDecoration.none,
      ),

    );
  }
}
