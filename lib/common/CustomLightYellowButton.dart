import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_textstyle.dart';
import 'colors.dart';

class CustomLightYellowButton extends StatelessWidget {
  final String name;
  final VoidCallback onTaped;

  const CustomLightYellowButton({
    super.key,
    required this.name,
    required this.onTaped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
      child: InkWell(
        onTap: () => onTaped(),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.lightYellow,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(10.h),
              child: Text(
                name,
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.brownColour),
              ),
            ))),
      ),
    );
  }
}
