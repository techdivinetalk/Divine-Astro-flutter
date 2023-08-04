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
        hintStyle: const TextStyle(color: AppColors.greyColor),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: AppColors.darkYellow, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: AppColors.darkYellow),
        ),
      ),
    );
  }
}

class WhiteTextField extends StatefulWidget {
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Icon? icon;
  final Color? errorBorder;

  const WhiteTextField(
      {super.key,
      required this.hintText,
      required this.inputType,
      required this.inputAction,
      this.errorBorder,
      this.icon});

  @override
  State<WhiteTextField> createState() => _WhiteTextFieldState();
}

class _WhiteTextFieldState extends State<WhiteTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3.0,
            offset: const Offset(0.3, 3.0)),
      ]),
      child: TextFormField(
        maxLines: 3,
        keyboardType: widget.inputType,
        textInputAction: widget.inputAction,
        decoration: InputDecoration(
          hintText: widget.hintText,
          helperStyle: AppTextStyle.textStyle16(),
          fillColor: AppColors.white,
          hoverColor: AppColors.white,
          prefixIcon: widget.icon,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: widget.errorBorder ?? AppColors.white,
                width: 1.0,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: AppColors.darkYellow,
                width: 1.0,
              )),
        ),
      ),
    );
  }
}
