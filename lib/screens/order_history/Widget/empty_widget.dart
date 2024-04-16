import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Center buildEmpty(String text) =>
    Center(child: CustomText(text, fontSize: 20.sp));

Widget buildEmptyNew(String text, {IconData? icon}) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.maxFinite, height: icon == null ? 80 : 40),
          Icon(
            icon ?? CupertinoIcons.list_bullet_below_rectangle,
            size: 40,
            color: appColors.grey,
          ),
          const SizedBox(height: 20),
          CustomText(
            text,
            fontWeight: FontWeight.w500,
            fontColor: appColors.grey,
          ),
          SizedBox(width: double.maxFinite, height: icon == null ? 80 : 40),
        ],
      ),
    );
