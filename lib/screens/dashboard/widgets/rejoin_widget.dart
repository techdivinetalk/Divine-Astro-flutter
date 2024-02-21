import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/cached_network_image.dart';
import '../../../common/colors.dart';
import '../../../common/common_functions.dart';
import '../../../common/custom_widgets.dart';

class RejoinWidget extends StatelessWidget {
  const RejoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: appColors.guideColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                offset: const Offset(3, 0)),
          ],

        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Wrap(direction: Axis.horizontal, children: [
                CustomText('Your Customer ', fontSize: 10.sp),
                CustomText(AppFirebaseService().orderData.value['customerName'],
                    fontSize: 10.sp,
                    fontColor: appColors.brown,
                    fontWeight: FontWeight.w700),
                CustomText('already joined', fontSize: 10.sp),
                SizedBox(width: 8.w),
              ]),
            ),
            CustomButton(
              onTap: () => Get.toNamed(
                RouteName.chatMessageWithSocketUI,
              ),
              color: appColors.guideColor,
              radius: 10.r,
              child: Assets.svg.rejoinChatIcon.svg(),
            ),
            SizedBox(width: 20.w),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10.r),
            //   child: SizedBox(
            //     height: 32.h,
            //     width: 32.h,
            //     child: CachedNetworkPhoto(
            //         url: "${preferenceService.getAmazonUrl()}${data['orderData']['customerImage']}"),
            //   ),
            // ),
            Obx(
              () {
                Map<String, dynamic> order = {};
                order = AppFirebaseService().orderData.value;
                String imageURL = order["customerImage"] ?? "";
                String appended =
                    "${preferenceService.getAmazonUrl()}/$imageURL";
                print("img:: $appended");
                return SizedBox(
                  height: 32,
                  width: 32,
                  child: CustomImageWidget(
                    imageUrl: appended,
                    rounded: true,
                    typeEnum: TypeEnum.user,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
