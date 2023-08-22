import 'package:divine_astrologer/di/api_provider.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/app_textstyle.dart';
import '../../common/colors.dart';
import '../../common/common_bottomsheet.dart';

import '../../gen/assets.gen.dart';
import '../live_page/constant.dart';
import '../live_page/live_page.dart';

class LiveTipsController extends GetxController {
  var pref = Get.find<SharedPreferenceService>();
  String liveId = "",name = "",image = "";

  @override
  void onReady() {
    var data = pref.getUserDetail();
    liveId = data!.id.toString();
    name = data.name!;
    image = ApiProvider.imageBaseUrl+data.image!;
    super.onReady();
  }

  jumpToLivePage() {
    Get.to(LivePage(
      liveID: "100",
      isHost: true,
      localUserID: localUserID,
      astrologerImage: image,
      astrologerName: name,
    ));
  }

  giftPopup(BuildContext context) async {
    await openBottomSheet(
      context,
      functionalityWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              color: AppColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),

                      // Image border
                      child: Assets.images.bgUserTmpPro
                          .image(height: 70.h, width: 70.h, fit: BoxFit.cover)),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "congratulations".tr,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Center(
                  child: Text(
                    "You've Have Received 4 Gifts",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20.h),
                MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: 2,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Assets.images.icBoyKundli.svg(
                                  height: 50.h, width: 50.h, fit: BoxFit.cover),
                              SizedBox(
                                width: 15.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rahul",
                                    style: AppTextStyle.textStyle16(
                                        fontColor: AppColors.darkBlue),
                                  ),
                                  Text(
                                    "has given you 3 hearts",
                                    style: AppTextStyle.textStyle12(
                                        fontColor: AppColors.darkBlue),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Row(
                                children: [
                                  Text(
                                    "₹15",
                                    style: AppTextStyle.textStyle16(
                                        fontWeight: FontWeight.w600,
                                        fontColor: AppColors.darkBlue),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Assets.images.bgHeart
                                      .image(height: 48.h, width: 48.h),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "totalEarning".tr,
                      style: AppTextStyle.textStyle16(
                          fontColor: AppColors.darkBlue,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "₹2115",
                      style: AppTextStyle.textStyle16(
                          fontColor: AppColors.darkBlue,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
