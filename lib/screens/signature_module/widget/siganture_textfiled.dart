import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';

class SignatureTextFiled extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? suffixOnTap;
  final Function(String)? onChanged;
  final Function()? onTap;

  const SignatureTextFiled(
      {this.controller, this.suffixOnTap, this.onChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        /*gradient: LinearGradient(colors: [
            AppColors.textFiledGradiantOne.withOpacity(0.4),
            AppColors.textFiledGradiantTwo.withOpacity(0.4),
          ])*/
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: appColors.guideColor,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: "Your signature",
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: appColors.guideColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: appColors.guideColor)),
        ),
      ),
    );
  }
}
