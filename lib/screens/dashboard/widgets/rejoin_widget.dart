import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/custom_widgets.dart';

class RejoinWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const RejoinWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    debugPrint('rejoin data --- $data');
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                offset: const Offset(3, 0)),
          ],
          gradient: const LinearGradient(
              colors: [AppColors.white, AppColors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Wrap(direction: Axis.horizontal, children: [
                CustomText('Your Customer ', fontSize: 10.sp),
                CustomText(data['orderData']['customerName'],
                    fontSize: 10.sp, fontColor: AppColors.brown, fontWeight: FontWeight.w700),
                CustomText('already joined', fontSize: 10.sp),
                SizedBox(width: 8.w),
              ]),
            ),
            CustomButton(
              onTap: () => Get.toNamed(RouteName.chatMessageWithSocketUI, arguments: data),
              color: AppColors.appYellowColour,
              radius: 10.r,
              child: Assets.svg.rejoinChatIcon.svg(),
            ),
            SizedBox(width: 20.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                height: 32.h,
                width: 32.h,
                child: CachedNetworkPhoto(
                    url: "${preferenceService.getAmazonUrl()}${data['orderData']['customerImage']}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}