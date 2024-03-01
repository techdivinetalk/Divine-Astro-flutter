import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/fonts.gen.dart';
import 'colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.inputAction,
    this.hintColor,
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
    this.contentPadding,
    this.onChanged,
    this.textInputFormatter,
    this.onSubmit,
    this.style,
    this.align,
    required double suffixIconPadding,
    this.topLabel,
    this.maxLines = 1,
    this.maxLength,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType keyboardType;
  final bool showCursor;
  final void Function()? onTap;
  final void Function(String value)? onSubmit;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isDense;
  final double? height;
  final bool? readOnly;
  final bool? autoFocus;
  final Color? fillColor;
  final Color? hintColor;
  final TextStyle? style;
  final InputBorder? inputBorder;
  final TextAlignVertical? align;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? textInputFormatter;
  final EdgeInsets? contentPadding;
  final void Function(String value)? onChanged;
  final Widget? topLabel;
  final int maxLines;
  final int? maxLength; // Added maxLength property

  OutlineInputBorder get border => OutlineInputBorder(
        borderSide: BorderSide(
          color: appColors.darkBlue.withOpacity(0.15),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (topLabel != null) topLabel!,
            SizedBox(height: 5.h),
            TextFormField(
              onChanged: onChanged,
              textAlignVertical: align ?? TextAlignVertical.center,
              onFieldSubmitted: onSubmit,
              textInputAction: inputAction ?? TextInputAction.done,
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
              maxLines: maxLines,
              cursorColor: appColors.darkBlue.withOpacity(0.15),
              style: style,
              decoration: InputDecoration(
                filled: true,
                contentPadding: contentPadding,
                fillColor: fillColor ?? appColors.transparent,
                hintText: hintText,
                isDense: isDense,
                prefixIcon: prefixIcon != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.0.sp),
                        child: prefixIcon,
                      )
                    : null,
                suffixIcon: maxLength != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.sp,
                        ),
                        child: _buildSuffixIcon(),
                      )
                    : const SizedBox(),
                prefixIconConstraints:
                    BoxConstraints(minHeight: 16.h, minWidth: 16.w),
                suffixIconConstraints:
                    BoxConstraints(minHeight: 16.h, minWidth: 16.w),
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.poppins,
                  color: hintColor ?? appColors.darkBlue.withOpacity(0.5),
                ),
                enabledBorder: inputBorder ?? border,
                focusedBorder: inputBorder ?? border,
                disabledBorder: inputBorder ?? border,
                border: inputBorder ?? border,
                errorBorder: inputBorder ?? border,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    final remainingCharacters =
    (maxLength! - (controller?.text.length ?? 0)).clamp(0, maxLength!);

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 14.0, bottom: 4.0),
        child: Text(
          '$remainingCharacters/$maxLength',
          style: TextStyle(
            color: appColors.darkBlue.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

