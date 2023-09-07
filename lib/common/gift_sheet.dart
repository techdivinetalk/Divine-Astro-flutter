import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'cached_network_image.dart';
import 'colors.dart';

class GiftSheet extends StatelessWidget {
  final String? url, name;
  const GiftSheet({Key? key, this.url, this.name}) : super(key: key);

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
          const SizedBox(height: 15),
          Stack(
            children: [
              Container(
                width: Get.width,
                margin: EdgeInsets.only(top: 45.h),
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(50.0)),
                  color: AppColors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 55.h),
                    Text(name ?? "",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue)),
                    SizedBox(height: 8.h),
                    Text("Congratulations!",
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkBlue)),
                    SizedBox(height: 4.h),
                    Text("You've Have Received 4 Gifts",
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.darkBlue)),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 155.h,
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                SizedBox(width: 32.w),
                                Container(
                                  width: 34.w,
                                  height: 34.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: Assets.images.avatar.svg(),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Rahul",
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.darkBlue)),
                                    Text("Has given 3 hears",
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.darkBlue)),
                                  ],
                                ),
                                const Spacer(),
                                Text("₹15",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkBlue)),
                                SizedBox(width: 10.w),
                                SizedBox(
                                  width: 34.w,
                                  height: 34.h,
                                  child: Assets.images.giftTotal.svg(),
                                ),
                                SizedBox(width: 32.w),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20.h);
                          },
                          itemCount: 3),
                    ),
                    SizedBox(height: 20.h),
                    Divider(height: 1.h, endIndent: 20.w, indent: 20.w),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        SizedBox(width: 32.w),
                        Text("Total Recieved",
                            style: TextStyle(
                                fontSize: 20.sp, color: AppColors.darkBlue)),
                        const Spacer(),
                        Text("₹15",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue)),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: 34.w,
                          height: 34.h,
                          child: Assets.images.giftTotal.svg(),
                        ),
                        SizedBox(width: 32.w),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 90.w,
                  height: 90.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 90.w,
                        height: 90.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkPhoto(
                          width: 90.w,
                          height: 90.h,
                          url: url ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: 90.w,
                        height: 90.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.appYellowColour, width: 2),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
