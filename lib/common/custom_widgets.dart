import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final int? maxLines;
  final String text;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const CustomText(
    this.text, {
    super.key,
    this.fontColor,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.textDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? DefaultTextStyle.of(context).maxLines,
      style: TextStyle(
        color: fontColor ?? appColors.darkBlue,
        fontSize: fontSize ?? 15.sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        decoration: textDecoration ?? TextDecoration.none,
      ),
    );
  }
}

class CustomTextStyle extends StatelessWidget {
  const CustomTextStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CustomButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final EdgeInsets? padding;
  final double? radius;
  final Color? color;
  final BoxBorder? border;

  const CustomButton(
      {super.key,
      required this.onTap,
      this.radius,
      required this.child,
      this.padding,
      this.color,
      this.border});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 5.sp),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          child: Ink(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: color ?? Colors.transparent,
              borderRadius: BorderRadius.circular(radius ?? 5.sp),
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
