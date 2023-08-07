// ignore_for_file: file_names

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/colors.dart';

class DoshaUi extends StatelessWidget {
  const DoshaUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight.h * 2.5),
          SizedBox(height: 25.h),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                details(
                    title: "Manglik Dosha",
                    details:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specim"),
                details(
                    title: "Kalsarp Dosha",
                    details:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's "),
                details(
                    title: "Sadesathi Dosha",
                    details:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's "),
                details(
                    title: "Pitri Dosha",
                    details:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specim"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget details({required String title, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTextStyle.textStyle20(
                fontWeight: FontWeight.w500,
                fontColor: AppColors.appYellowColour)),
        SizedBox(height: 5.h),
        Text(
          details,
          style: AppTextStyle.textStyle12(
              fontWeight: FontWeight.w500, fontColor: AppColors.greyColor),
        ),
        SizedBox(height: 16.h)
      ],
    );
  }
}
