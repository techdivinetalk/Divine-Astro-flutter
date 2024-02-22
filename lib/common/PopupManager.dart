import 'package:divine_astrologer/common/common_image_view.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'app_textstyle.dart';
import 'colors.dart';

class PopupManager {
  static bool isPopupOpen = false;

  static Future<void> showGiftCountPopup(BuildContext context,
      {String? title,
      String? btnTitle,
      int? totalGift,
      String? baseUrl}) async {
    print("${baseUrl}/${giftImageUpdate.value}");
    print("baseUrlgiftImageUpdate.value");
    if (isPopupOpen) {
      return;
    }

    isPopupOpen = true;

    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
              print("many time back ??");
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: appColors.white),
                  color: appColors.transparent),
              child: Icon(
                Icons.close_rounded,
                color: appColors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(50.0)),
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.white,
            ),
            child: Column(
              children: [
                if (title != null) SizedBox(height: 30.h),
                if (title != null)
                  Text(
                    title,
                    style: AppTextStyle.textStyle20(
                        fontWeight: FontWeight.w600,
                        fontColor: appColors.textColor),
                  ),
                SizedBox(height: 10.h),
                // Text(
                //   "$totalGift Gift${totalGift! > 1 ? 's' : ''} Received",
                //   style: AppTextStyle.textStyle14( fontColor: appColors.black),
                // ),
                Obx(() {
                  return Text(
                    "${giftCountUpdate.value} Gift${giftCountUpdate.value > 1 ? 's' : ''} Received",
                    style: AppTextStyle.textStyle14(fontColor: appColors.black),
                  );
                }),
                SizedBox(height: 16.h),
                Obx(() {
                  return CommonImageView(
                    imagePath: "${baseUrl}/${giftImageUpdate.value}",
                    height: 70.h,
                    width: 70.h,
                  );
                }),
                const SizedBox(height: 20),
                if (btnTitle != null)
                  GestureDetector(
                    onTap: () {
                      print("Clicked order history");
                      Get.back();

                      Get.toNamed(RouteName.orderHistory, arguments: 3);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: appColors.guideColor,
                        border: Border.all(
                          color: appColors.guideColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          btnTitle,
                          style: AppTextStyle.textStyle15(
                            fontColor: appColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                //     )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    ).then((_) => isPopupOpen = false);

    isPopupOpen = false;
  }
}
