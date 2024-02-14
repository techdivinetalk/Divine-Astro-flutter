import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/appbar.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_shimmer.dart';
import 'package:divine_astrologer/common/text_field_custom.dart';
import 'package:divine_astrologer/screens/home_screen_options/discount_offers/discount_offers_controller.dart';
import 'package:divine_astrologer/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DiscountOfferUI extends GetView<DiscountOffersController> {
  const DiscountOfferUI({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DiscountOffersController());
    return Scaffold(
      appBar: commonDetailAppbar(title: 'selectOffer'.tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'callAndChat'.tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
              ),
              Container(
                width: 125.w,
                height: 2.h,
                decoration: BoxDecoration(
                    color: appColors.appColorDark,
                    borderRadius: BorderRadius.circular(10.w)),
              ),
              GetBuilder<DiscountOffersController>(
                builder: (controller) {
                  if (controller.loading == Loading.initial ||
                      controller.loading == Loading.loading) {
                    return loadingWidget();
                  }
                  if (controller.loading == Loading.loaded) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.discountOffers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final offer = controller.discountOffers[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10.w),
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.w),
                                color: appColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 6.w),
                                    blurRadius: 5.0,
                                  ),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${'offerName'.tr} :',
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    Text(
                                      '${offer.offerName ?? ''}',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      height: 0,
                                      child: Switch(
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      '${'displayName'.tr} :',
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    Text(
                                      ' ${offer.offerPercentage ?? ''}% off',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: appColors.lightGreen,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      '${'userType'.tr} :',
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    Text(
                                      ' ${offer.offerName ?? ''}',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: appColors.lightGreen,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      'India : ',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: appColors.blackColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${'price'.tr} :',
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    Text(
                                      ' ₹100',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: appColors.lightGreen,
                                          fontWeight: FontWeight.w600),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    Text(
                                      '${'discountedPrice'.tr}:',
                                      style: TextStyle(fontSize: 15.sp),
                                    ),
                                    Text(
                                      ' ₹${100 % (offer.offerPercentage ?? 0)}',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: appColors.lightGreen,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return ListView.builder(
      itemCount: 4,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(10.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              color: appColors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomShimmer.shimmerTile(width: 100.w),
                  Spacer(),
                  CustomShimmer.shimmerTile(width: 60.w, height: 25.h),
                ],
              ),
              CustomShimmer.shimmerTile(height: 100.h, width: 200.w),
            ],
          ),
        );
      },
    );
  }
}
