import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';

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
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: FractionalOffset(0, 0),
                  end: FractionalOffset(0, 1),
                  stops: [0.0, 2.0],
                  tileMode: TileMode.clamp),
              image: DecorationImage(
                image: ExactAssetImage(Assets.images.bgLiveTemp.path),
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
              Row(
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
                  const Spacer(),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: InkWell(
                        onTap: () {
                          controller.isFrontCamera.value =
                              !controller.isFrontCamera.value;
                        },
                        child: Obx(
                          () => Icon(
                            controller.isFrontCamera.value
                                ? Icons.camera_front
                                : Icons.camera_alt,
                            color: AppColors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  onTap: () async {
                    // showCupertinoModalPopup(
                    //   context: context,
                    //   barrierColor: AppColors.darkBlue.withOpacity(0.5),
                    //   builder: (context) => const GiftPopup(),
                    // );
                    //controller.giftPopup(Get.context!);
                    // if (await PermissionHelper().askPermissions()) {
                    //   // controller.jumpToLivePage(controller.isFrontCamera.value);
                    //   await controller.myFun();
                    // }

                    // Socket By: Vimal Solanki
                    /*
                    join-live
                    userType : customer/astrologer
                    userId : id of customer or astrologer as per userType
                    */

                    final int id = controller.pref.getUserDetail()?.id ?? 0;
                    if (id == 0) {
                      // todo
                    } else {
                      bool hasAllPerm = false;
                      await AppPermissionService.instance.onPressedJoinButton(
                        "Video",
                        () async {
                          hasAllPerm = true;
                        },
                      );
                      if (hasAllPerm) {
                        AppSocket().joinLive(
                          userType: "astrologer",
                          userId: controller.pref.getUserDetail()?.id ?? 0,
                        );
                        await controller.myFun();
                      } else {}
                    }
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
