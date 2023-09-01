import 'dart:io';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WrapperContainer extends StatelessWidget {
  const WrapperContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: child,
    );
  }
}

class BackNavigationWidget extends StatelessWidget {
  const BackNavigationWidget({
    Key? key,
    this.onPressedBack,
    this.title,
    this.trailingIcon,
  }) : super(key: key);

  final void Function()? onPressedBack;
  final String? title;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              onPressedBack != null
                  ? Column(
                      children: [
                        SizedBox(width: 16.w),
                        IconButton(
                          onPressed: onPressedBack,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              title != null
                  ? Column(
                      children: [
                        SizedBox(width: 20.w),
                        Text(
                          title.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.sp,
            ),
            child: trailingIcon,
          )
        ],
      ),
    );
  }
}

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    Key? key,
    required this.buttonName,
    this.onPressed,
    this.height,
    this.color,
    this.textColor,
    this.fontWeight,
    this.style,
  }) : super(key: key);

  final String buttonName;
  final void Function()? onPressed;
  final double? height;
  final Color? color;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.sp),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              height: height ?? 55.h,
              color: color ?? AppColors.yellow,
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(79.sp),
              ),
              elevation: 0.0,
              onPressed: onPressed,
              child: Text(
                buttonName,
                style: style ??
                    TextStyle(
                      fontSize: 20.sp,
                      color: textColor ?? AppColors.blackColor,
                      fontWeight: fontWeight ?? FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.file,
  }) : super(key: key);

  final String title;
  final void Function() onTap;
  final File? file;

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.file(widget.file!, fit: BoxFit.fill),
                )
              : InkWell(
                  onTap: widget.onTap,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Assets.svg.greyContainer.svg(),
                      Assets.svg.icAdd.svg(),
                    ],
                  ),
                ),
          SizedBox(height: 5.h),
          Text(widget.title),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}

class BankDetailsField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Icon? icon;
  final Widget? suffixIcon;
  final Color? errorBorder;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;

  const BankDetailsField({
    super.key,
    required this.hintText,
    required this.inputType,
    required this.inputAction,
    this.errorBorder,
    this.icon,
    this.suffixIcon,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 1.0,
            offset: const Offset(0.1, 1.0),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        textInputAction: inputAction,
        decoration: InputDecoration(
          isDense: true,
          errorStyle: const TextStyle(height: 0),
          hintText: hintText,
          helperStyle: AppTextStyle.textStyle16(),
          fillColor: AppColors.white,
          hintStyle: AppTextStyle.textStyle16(fontColor: AppColors.grey),
          hoverColor: AppColors.white,
          prefixIcon: icon,
          suffixIcon: suffixIcon,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: errorBorder ?? AppColors.white,
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: errorBorder ?? AppColors.white,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.redColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: AppColors.yellow,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

String? bankDetailValidator(String? value) {
  if (value!.isEmpty) {
    return '';
  }
  return null;
}
