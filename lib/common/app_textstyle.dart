import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle textStyle10({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyle12({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyle13({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyle14({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyle15({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyle16({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStylebold16({Color? fontColor, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyleItalic16({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: fontColor ?? AppColors.blackColor,
    );
  }

  static TextStyle textStyleUtilsUnderLine14(
      {Color? color, FontWeight? fontWeight, double? thickness}) {
    return TextStyle(
      color: color ?? AppColors.blackColor,
      decoration: TextDecoration.underline,
      decorationThickness: thickness ?? 1.5,
      decorationColor: color ?? AppColors.blackColor,
      fontSize: 14.sp,
      fontWeight: fontWeight ?? FontWeight.w700,
    );
  }
}
