import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/colors.dart';

class LoginMobileTextField extends StatelessWidget {
  const LoginMobileTextField({
    Key? key,
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
    this.borderColor,
  }) : super(key: key);

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
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: TextFormField(
        onTap: onTap,
        focusNode: focusNode,
        enabled: enabled,
        showCursor: showCursor,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        cursorColor: appColors.darkBlue.withOpacity(0.15),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0.sp, horizontal: 6.sp),
            child: prefixIcon,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.sp,
            ),
            child: suffixIcon,
          ),
          hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: appColors.darkBlue.withOpacity(0.5),
          ),
          enabledBorder: buildOutlineInputBorder(),
          focusedBorder: buildOutlineInputBorder(),
          disabledBorder: buildOutlineInputBorder(),
          border: buildOutlineInputBorder(),
          errorBorder: buildOutlineInputBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor ?? appColors.guideColor,
      ),
      borderRadius: BorderRadius.circular(10.sp),
    );
  }
}
