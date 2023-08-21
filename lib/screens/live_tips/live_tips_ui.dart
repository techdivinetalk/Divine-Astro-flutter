import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'live_tips_controller.dart';

class LiveTipsUI extends GetView<LiveTipsController> {
  const LiveTipsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: <Widget>[
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
            ).createShader(
                Rect.fromLTRB(0, -140, rect.width, rect.height - 20));
          },
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: FractionalOffset(0, 0),
                  end: FractionalOffset(0, 1),
                  stops: [0.0, 2.0],
                  tileMode: TileMode.clamp),
              image: DecorationImage(
                image: ExactAssetImage('assets/images/bg_liveTemp.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.chevron_left_outlined,
                      color: AppColors.white,
                      size: 45.sp,
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 0,
                child: Text(
                  "tips".tr,
                  style: TextStyle(
                      fontSize: 32.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                flex: 0,
                child: Text(
                  "Please make sure you and your background environment are ready to start a live check   your video and audio.",
                  style: AppTextStyle.textStyle16(
                      fontColor: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                flex: 0,
                child: Text(
                  "To guarantee the user experience, please make sure you can live for 30 mins at least.",
                  style: AppTextStyle.textStyle16(
                      fontColor: AppColors.white, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Expanded(
                flex: 0,
                child: InkWell(
                  onTap: () {
                    // showCupertinoModalPopup(
                    //   context: context,
                    //   barrierColor: AppColors.darkBlue.withOpacity(0.5),
                    //   builder: (context) => const GiftPopup(),
                    // );
                    //controller.giftPopup(Get.context!);
                    controller.jumpToLivePage();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.lightYellow,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Text(
                          "startLive".tr,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.brownColour,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
