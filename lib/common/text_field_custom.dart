// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_textstyle.dart';
import 'colors.dart';

class TextFieldCustom extends StatefulWidget {
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;

  const TextFieldCustom(this.hintText, this.inputType, this.inputAction,
      {super.key});

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return TextField(
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      autocorrect: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle:  TextStyle(color: appColors.greyColor),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder:  OutlineInputBorder(
          borderRadius:const BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: appColors.guideColor, width: 1),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius:const BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: appColors.guideColor),
        ),
      ),
    );
  }
}

class WhiteTextField extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final bool? enabled;
  final int maxLines;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Icon? icon;
  final Widget? suffixIcon;
  final Color? errorBorder;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final void Function(String? value)? onChanged;

  const WhiteTextField(
      {super.key,
      required this.hintText,
      required this.inputType,
      required this.inputAction,
        this.errorText,
        this.enabled,
      this.maxLines = 1,
      this.controller,
      this.errorBorder,
      this.icon,
      this.isDense = false,
      this.suffixIcon,
      this.onChanged,
      this.contentPadding,
      this.validator});

  @override
  State<WhiteTextField> createState() => _WhiteTextFieldState();
}

class _WhiteTextFieldState extends State<WhiteTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            offset: const Offset(0.3, 1.0),
          ),
        ],
      ),
      child: TextFormField(
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        validator: widget.validator,
        controller: widget.controller,
        maxLines: widget.maxLines,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        decoration: InputDecoration(
          hintText: widget.hintText,
          errorText: widget.errorText,
          isDense: widget.isDense,
          contentPadding: widget.contentPadding,
          helperStyle: AppTextStyle.textStyle16(),
          fillColor: appColors.white,
          hintStyle: AppTextStyle.textStyle16(fontColor: appColors.greyColor),
          hoverColor: appColors.white,
          prefixIcon: widget.icon,
          suffixIcon: widget.suffixIcon,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: widget.errorBorder ?? appColors.white,
                width: 1.0,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:  BorderSide(
                color: appColors.guideColor,
                width: 1.0,
              )),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  AppTextField(
      {Key? key,
      this.controller,
      this.validator,
      this.prefixIcon,
      this.hintText,
      this.readOnly,
      this.textInputType,
      this.onTap})
      : super(key: key);
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? hintText;
  final bool? readOnly;
  final VoidCallback? onTap;
  TextInputType? textInputType = TextInputType.name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
        color: appColors.darkBlue,
      ),
      readOnly: readOnly ?? false,
      onTap: () {
        onTap!.call();
      },
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: appColors.darkBlue.withOpacity(.15),
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: appColors.darkBlue.withOpacity(.15),
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: appColors.darkBlue.withOpacity(.15),
            )),
        isDense: true,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 10.w),
                  SizedBox(
                    height: 30.h,
                    width: 15.w,
                    child: prefixIcon,
                  ),
                  SizedBox(width: 8.w),
                ],
              )
            : const SizedBox(),
        prefixIconConstraints: BoxConstraints(minHeight: 24.h, minWidth: 24.w),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16.sp,
          color: appColors.darkBlue.withOpacity(.5),
        ),
      ),
    );
  }
}
