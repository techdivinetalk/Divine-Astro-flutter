

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/app_textstyle.dart';
import '../../../common/colors.dart';
import '../../../common/routes.dart';

Future GiftCountPopup(BuildContext context,
      {String? title, String? btnTitle,int? totaltGift}) {
    return showModalBottomSheet(
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
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: AppColors.white),
                  color: AppColors.transparent),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.white,
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
                        fontWeight: FontWeight.w600, fontColor: AppColors.appColorDark),
                  ),
                SizedBox(height: 10.h),
                Text(
              "${totaltGift} Gift${totaltGift! > 1 ? 's' : ''} Received",
                  style: AppTextStyle.textStyle14( fontColor: AppColors.black),
                ),
                SizedBox(height: 16.h),
                Image.asset("assets/images/bg_heart.png"),
                const SizedBox(height: 20),
                if (btnTitle != null)
                  GestureDetector(
                    onTap: () {
                      print("Clicked order history");
                      Get.toNamed(RouteName.orderHistory);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.appColorDark,
                        border: Border.all(color: AppColors.appColorDark, width: 2,),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          btnTitle,
                          style: AppTextStyle.textStyle15(
                            fontColor: AppColors.black,
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
    );
  }