import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoojaRemedyTextFiled extends StatelessWidget {
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool? isSuffix;
  final String? title;
  final Function(String)? onChanged;
  final focusNode;
  final List<TextInputFormatter>? textInputFormatter;
  final from;
  final String? Function(String?)? validator;
  final keyboardType;
  final Function(String?)? onFieldSubmitted;

  PoojaRemedyTextFiled(
      {super.key,
      this.controller,
      this.maxLines = 1,
      this.maxLength,
      this.validator,
      this.onFieldSubmitted,
      this.keyboardType,
      this.title,
      this.focusNode,
      this.onChanged,
      this.textInputFormatter,
      this.from,
      this.isSuffix = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: AppTextStyle.textStyle14(
            fontColor: appColors.textColor,
          ),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          maxLines: maxLines,
          maxLength: maxLength == 50 ? null : maxLength,
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          inputFormatters: textInputFormatter,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
              suffixIcon: from == "onBoarding"
                  ? isSuffix!
                      ? Padding(
                          padding: const EdgeInsets.only(top: 60, right: 4),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "${controller!.text.length}/${maxLength}",
                              textAlign: TextAlign.end,
                              style: AppTextStyle.textStyle12(
                                fontColor: appColors.textColor.withOpacity(0.5),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                  : isSuffix!
                      ? Center(
                          child: Text(
                            "${controller!.text.length}/${maxLength}",
                            style: AppTextStyle.textStyle12(
                              fontColor: appColors.textColor.withOpacity(0.5),
                            ),
                          ),
                        )
                      : const SizedBox(),
              suffixIconConstraints: BoxConstraints(
                  maxHeight: from == "onBoarding" ? 120 : 50, maxWidth: 60),
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
        )
      ],
    );
  }
}
