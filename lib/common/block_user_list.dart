import 'dart:ui';

import 'package:divine_astrologer/common/cached_network_image.dart';
import 'package:divine_astrologer/common/custom_text.dart';
import 'package:divine_astrologer/common/unblock_user.dart';
import 'package:divine_astrologer/screens/live_page/live_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'colors.dart';

class BlockUserList extends GetView<LiveController> {
  const BlockUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
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
                border: Border.all(color: AppColors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: AppColors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(50.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(50.0)),
                  color: AppColors.white.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    CustomText("Blocked User",
                        fontSize: 16.sp,
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.bold),
                    Obx(
                      () => ListView.separated(
                        itemCount: controller.blockCustomer.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        itemBuilder: (context, index) {
                          var item = controller.blockCustomer[index];
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                    color: AppColors.appYellowColour),
                                color: AppColors.white),
                            height: 50.h,
                            child: Row(
                              children: [
                                SizedBox(width: 20.w),
                                SizedBox(
                                    width: 20.w,
                                    child: CustomText(
                                      (index + 1).toString(),
                                      fontColor: AppColors.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    )),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 32.w,
                                  height: 32.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.blackColor),
                                  child: CachedNetworkPhoto(
                                    url: item.getCustomers?.avatar,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                CustomText(item.getCustomers?.name ?? "",
                                    fontSize: 16.sp,
                                    fontColor: AppColors.textColor,
                                    fontWeight: FontWeight.w600),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return UnblockOrBlockUser(
                                            name: item.getCustomers?.name ?? "",
                                            isForBlocUser: false,
                                            blockUnblockTap: () {
                                              Get.back();
                                              controller.unblockUser(
                                                  customerId: item.customerId
                                                      .toString(),
                                                  name:
                                                      item.getCustomers?.name ??
                                                          "");
                                            },
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.more_vert))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20.h);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
