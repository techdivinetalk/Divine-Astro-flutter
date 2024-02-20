import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import 'cached_network_image.dart';
import 'colors.dart';

class TotalEarning extends StatelessWidget {
  const TotalEarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration:  BoxDecoration(
                borderRadius:const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                color: appColors.darkBlue,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: Get.width,
            margin: EdgeInsets.only(top: 15.h),
            decoration:  BoxDecoration(
              borderRadius:const BorderRadius.vertical(top: Radius.circular(50.0)),
              color: appColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 90.w,
                    height: 90.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkPhoto(
                      width: 90.w,
                      height: 90.h,
                      url: "",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text("${"congratulations".tr}!",
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: appColors.textColor)),
                Text(
                    "YouHaveEarnedFromYourLastSession"
                        .trParams({"price": "2115"}),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        color: appColors.darkBlue)),
                SizedBox(height: 18.h),
                Divider(height: 1.h, endIndent: 20.w, indent: 20.w),
                SizedBox(height: 18.h),
                priceWidget(Assets.svg.callEarning.svg(), "fromCalls".tr,
                    "YouHaveReceivedCalls".trParams({"count": "10"}), "15"),
                SizedBox(height: 18.h),
                priceWidget(
                    Assets.svg.videoCallEarning.svg(),
                    "fromVideoCalls".tr,
                    "YouHaveReceivedVideoCalls".trParams({"count": "2"}),
                    "1115"),
                SizedBox(height: 18.h),
                priceWidget(
                    Assets.svg.privateCallEarning.svg(),
                    "fromPrivateCalls".tr,
                    "YouHaveReceivedPrivateCalls".trParams({"count": "3"}),
                    "1115"),
                SizedBox(height: 18.h),
                priceWidget(
                    Assets.svg.giftEarning.svg(),
                    "fromLiveGifts".tr,
                    "YouHaveReceivedLiveGifts".trParams({"count": "40"}),
                    "1115"),
                SizedBox(height: 18.h),
                Divider(height: 1.h, endIndent: 20.w, indent: 20.w),
                SizedBox(height: 18.h),
                Row(
                  children: [
                    SizedBox(width: 20.w),
                    Text("totalEarning".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: appColors.darkBlue)),
                    const Spacer(),
                    Text("₹2115",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: appColors.darkBlue)),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: MaterialButton(
                      height: 60,
                      minWidth: MediaQuery.sizeOf(context).width,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      ),
                      onPressed: () {},
                      color: appColors.guideColor,
                      child: Text(
                        "orderHistory".tr,
                        style: TextStyle(
                            color: appColors.brownColour,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp),
                      )),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget priceWidget(
      SvgPicture svg, String title, String discription, String price) {
    return Row(
      children: [
        SizedBox(width: 20.w),
        Container(
          width: 48.w,
          height: 48.w,
          clipBehavior: Clip.antiAlias,
          decoration:  BoxDecoration(
              color: appColors.guideColor, shape: BoxShape.circle),
          child: Center(
            child: svg,
          ),
        ),
        SizedBox(width: 20.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: appColors.darkBlue)),
            Text(discription,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: appColors.darkBlue)),
          ],
        ),
        const Spacer(),
        Text("₹$price",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: appColors.darkBlue)),
        SizedBox(width: 20.w),
      ],
    );
  }
}
