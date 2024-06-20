import 'package:divine_astrologer/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInfoWidget extends StatelessWidget {
  final String text;
  final String badgeText;

  const CustomInfoWidget({
    super.key,
    required this.text,
    required this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.sp,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 13),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 32.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    // maxLines: 3,
                    maxLines: 1000,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: appColors.extraLightGrey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                badgeText,
                style: TextStyle(
                  color: appColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
