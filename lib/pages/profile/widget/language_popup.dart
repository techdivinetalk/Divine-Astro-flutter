
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

class LanguagePopup extends StatelessWidget {
  const LanguagePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
              color: AppColors.white,
            ),
            child: Column(
              children: [
                Text(
                  'Choose Your App Language',
                  style: AppTextStyle.textStyle20(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  height: 270.h,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 30.h,
                      crossAxisSpacing: 30.h,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => LanguageWidget(index: index),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  color: AppColors.lightYellow,
                  minWidth: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: const StadiumBorder(),
                  child: Text(
                    'Set Language',
                    style: AppTextStyle.textStyle16(fontWeight: FontWeight.w600,fontColor: AppColors.brownColour),


                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageWidget extends StatelessWidget {
  final int index;

  LanguageWidget({super.key, required this.index});

  final List<String> languagesMain = ["Eng", "हिन्दी", "मराठी", "ગુજરાતી"];
  final List<String> languages = ["English", "Hindi", "Marathi", "Gujarati"];
  final List<Color> colors = [
    AppColors.appYellowColour,
    AppColors.teal,
    AppColors.pink,
    AppColors.pink
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Ink(
            height: 100.h,
            width: 100.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colors[index].withOpacity(0),
                  colors[index].withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  languagesMain[index],
                  style: AppTextStyle.textStyle20(fontWeight: FontWeight.w700),


                ),
                SizedBox(height: 10.h),
                Text(
                  languages[index],
                  style: AppTextStyle.textStyle16(),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
