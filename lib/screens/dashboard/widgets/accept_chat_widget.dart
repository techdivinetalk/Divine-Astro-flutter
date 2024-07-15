import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/custom_widgets.dart';

class AcceptChatWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final void Function()? onTap;

  const AcceptChatWidget({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    debugPrint('accept data --- $data');
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: appColors.guideColor),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Wrap(direction: Axis.horizontal, children: [
              CustomText(data['orderData']['customerName'],
                  fontSize: 10.sp,
                  fontColor: appColors.brown,
                  fontWeight: FontWeight.w700),
              CustomText(
                  ' requested to start a\nconsultation with you via chat.',
                  fontSize: 10.sp),
              SizedBox(width: 8.w),
            ]),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: appColors.guideColor),
              child: Row(
                children: [
                  Text(' Accept Chat Now',
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: appColors.brown,
                          fontFamily: FontFamily.poppins)),
                  SizedBox(
                    width: 5.w,
                  ),
                  Assets.svg.forwardIcon.svg()
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              height: 32.h,
              width: 32.h,
              child: CachedNetworkPhoto(
                  url:
                      "${preferenceService.getAmazonUrl()}${data['orderData']['customerImage']}"),
            ),
          ),
        ],
      ),
    );
  }
}
