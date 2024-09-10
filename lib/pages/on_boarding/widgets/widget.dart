import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/fonts.gen.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final String? hint;
  final Function(String)? onChanged;
  final onTap;
  final focusNode;
  final nextNode;
  final readOnly;
  final prefix;
  final sufix;
  final List<TextInputFormatter>? textInputFormatter;

  final String? Function(String?)? validator;
  final keyboardType;
  final Function(String?)? onFieldSubmitted;

  CustomTextField(
      {super.key,
      this.controller,
      this.maxLines = 1,
      this.maxLength,
      this.validator,
      this.readOnly,
      this.onFieldSubmitted,
      this.onTap,
      this.keyboardType,
      this.hint,
      this.focusNode,
      this.nextNode,
      this.onChanged,
      this.textInputFormatter,
      this.prefix,
      this.sufix
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: textInputFormatter,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      keyboardType: keyboardType ?? TextInputType.text,
      readOnly: readOnly ?? false,
      style: TextStyle(
        fontFamily: FontFamily.poppins,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: appColors.black,
      ),
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: appColors.grey,
          ),
          prefixIcon: prefix,
          suffixIcon: sufix,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
          counterText: "",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: appColors.textColor.withOpacity(0.2),
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: appColors.textColor.withOpacity(0.2),
              )),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: appColors.textColor.withOpacity(0.2),
              ))),
    );
  }
}
