import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../gen/assets.gen.dart';
import 'colors.dart';
import 'custom_widgets.dart';

class CoHostRequest extends StatelessWidget {
  final VoidCallback? onReject, onAccept;
  final String? name;
  final int? duration;

  const CoHostRequest(
      {Key? key, this.onReject, this.onAccept, this.name, this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(50.0)),
                color: appColors.white,
                border: Border.all(color: appColors.guideColor)),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  decoration:  BoxDecoration(color: appColors.white),
                  child: Row(
                    children: [
                      SizedBox(width: 32.w),
                      Container(
                        width: 34.w,
                        height: 34.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Assets.images.avatar.svg(),
                      ),
                      SizedBox(width: 10.w),
                      CustomText(name ?? "",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: appColors.darkBlue),
                      const Spacer(),
                       Icon(Icons.call,
                          color: appColors.darkBlue, size: 16),
                      SizedBox(width: 10.w),
                      CustomText(intToTimeLeft(duration ?? 0),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: appColors.darkBlue),
                      SizedBox(width: 32.w),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: CustomButton(
                            onTap: () {
                              onAccept!.call();
                            },
                            color: appColors.guideColor,
                            radius: 28,
                            child: Center(
                              child: CustomText("Accept",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontColor: appColors.brownColour),
                            )),
                      ),
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String intToTimeLeft(int value) {
  int h, m, s;

  h = value ~/ 3600;

  m = ((value - h * 3600)) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  String result = "$h h $m m $s s";
  return result;
}
