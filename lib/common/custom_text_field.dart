import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.controller,
      this.validator,
      this.enabled = true,
      this.keyboardType = TextInputType.name,
      this.showCursor = true,
      this.onTap,
      this.focusNode,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.isDense,
      this.height,
      this.readOnly,
      this.autoFocus,
      this.inputBorder,
      this.fillColor,
      this.suffixIconPadding,
      this.textInputFormatter})
      : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final bool showCursor;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isDense;
  final double? height;
  final bool? readOnly;
  final bool? autoFocus;
  final double? suffixIconPadding;
  final Color? fillColor;
  final InputBorder? inputBorder;
  final List<TextInputFormatter>? textInputFormatter;

  OutlineInputBorder get border => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.darkBlue.withOpacity(0.15),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: SizedBox(
        height: height,
        child: TextFormField(
          onTap: onTap,
          focusNode: focusNode,
          enabled: enabled,
          showCursor: showCursor,
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          autofocus: autoFocus ?? false,
          readOnly: readOnly ?? false,
          inputFormatters: textInputFormatter ?? [],
          cursorColor: AppColors.darkBlue.withOpacity(0.15),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? AppColors.transparent,
            hintText: hintText,
            isDense: isDense,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0.sp),
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: suffixIconPadding ?? 15.sp,
                    ),
                    child: suffixIcon,
                  )
                : const SizedBox(),
            hintStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.darkBlue.withOpacity(0.5),
            ),
            enabledBorder: inputBorder ?? border,
            focusedBorder: inputBorder ?? border,
            disabledBorder: inputBorder ?? border,
            border: inputBorder ?? border,
            errorBorder: inputBorder ?? border,
          ),
        ),
      ),
    );
  }
}
