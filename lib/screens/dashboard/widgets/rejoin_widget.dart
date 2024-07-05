import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: appColors.white,
          border: Border.all(
            color: Colors.grey, // Choose your border color here
            width: 2, // Adjust the width as needed
          ),
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
                CustomText(' already joined', fontSize: 10.sp),
                SizedBox(width: 8.w),
              ]),
            ),
           /* CustomButton(
              onTap: () => Get.toNamed(
                RouteName.chatMessageWithSocketUI,
              ),
              color: appColors.guideColor,
              radius: 10.r,
              child: Assets.svg.rejoinChatIcon.svg(),
            ),*/
            Card(
              color: appColors.guideColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: InkWell(
                onTap: () async {
                  debugPrint('rejoinChatIcon');
                  Get.toNamed(RouteName.newChat);
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0.sp), // Adjust padding as needed
                  child: Row(
                    children: [
                      CustomText(
                        "Re-Join Chat",
                        fontSize: 12.sp,
                        fontColor: appColors.white,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 5.w),
                      Assets.svg.rejoin.svg(height:12.sp)
                    ],
                  ),
                ),
              ),
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
      ).px4(),
    );
  }
}
