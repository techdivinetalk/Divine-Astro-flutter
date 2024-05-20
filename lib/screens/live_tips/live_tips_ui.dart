import 'dart:io';

import 'package:camera/camera.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/gen/assets.gen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/common_button.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'live_tips_controller.dart';

class LiveTipsUI extends GetView<LiveTipsController> {
  const LiveTipsUI({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveTipsController>(
      assignId: true,
      init: LiveTipsController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: CameraPreview(
                controller.controller!,
              ),
            ),
            /*ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ).createShader(
                  Rect.fromLTRB(0, -140, rect.width, rect.height - 20),
                );
              },
              blendMode: BlendMode.darken,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: FractionalOffset(0, 0),
                    end: FractionalOffset(0, 1),
                    stops: [
                      0.0,
                      2.0,
                    ],
                    tileMode: TileMode.clamp,
                  ),
                  image: DecorationImage(
                    image: ExactAssetImage(Assets.images.bgLiveTemp.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),*/
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
                              color: appColors.white,
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
                              // controller.toggleCameraLens();
                            },
                            child: Obx(
                              () => Icon(
                                controller.isFrontCamera.value
                                    ? Icons.camera_front
                                    : Icons.camera_alt,
                                color: appColors.white,
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
                          color: appColors.white,
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
                          fontColor: appColors.white,
                          fontWeight: FontWeight.w500),
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
                          fontColor: appColors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  StreamBuilder<Object>(
                    initialData: false,
                    stream:
                        controller.streamController.stream.asBroadcastStream(),
                    builder: (context, snapshot) {
                      return CommonButton(
                        buttonText: "startLive".tr,
                        buttonCallback: snapshot.hasData &&
                                snapshot.data == false
                            ? () async {
                                controller.streamController.add(true);
                                await furtherProcedure(controller: controller);
                                controller.streamController.add(false);
                              }
                            : () {
                                divineSnackBar(data: "Loading, please wait...");
                              },
                      );
                    },
                  ),
                  // Expanded(
                  //   flex: 0,
                  //   child: InkWell(
                  //     onTap: () async {},
                  //     child: Container(
                  //       width: double.infinity,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(50),
                  //         color: appColors.lightYellow,
                  //       ),
                  //       child: Center(
                  //         child: Padding(
                  //           padding: EdgeInsets.symmetric(vertical: 20.h),
                  //           child: Text(
                  //             "startLive".tr,
                  //             style: TextStyle(
                  //               fontSize: 20.sp,
                  //               color: appColors.brownColour,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ]),
        );
      },
    );
  }

  Future<void> furtherProcedure({LiveTipsController? controller}) async {
    // showCupertinoModalPopup(
    //   context: context,
    //   barrierColor: appColors.darkBlue.withOpacity(0.5),
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
    // final int id = controller.pref.getUserDetail()?.id ?? 0;
    // if (id == 0) {
    //   divineSnackBar(data: "Unknown Error Occurred");
    // } else {
    //   bool hasAllPerm = false;

    //   await AppPermissionService.instance.onPressedAstrologerGoLive(
    //     () async {
    //       hasAllPerm = true;
    //     },
    //   );

    //   if (hasAllPerm) {
    //     bool canEnter = false;

    //     await controller.astroOnlineAPI(
    //       entering: true,
    //       successCallBack: (message) {
    //         canEnter = true;
    //         divineSnackBar(data: message);
    //       },
    //       failureCallBack: (message) {
    //         canEnter = false;
    //         divineSnackBar(data: message);
    //       },
    //     );

    //     if (canEnter) {
    //       await controller.furtherProcedure(
    //         successCallBack: (message) async {
    //           divineSnackBar(data: message);

    //           await controller.astroOnlineAPI(
    //             entering: false,
    //             successCallBack: (message) {
    //               divineSnackBar(data: message);
    //             },
    //             failureCallBack: (message) {
    //               divineSnackBar(data: message);
    //             },
    //           );
    //         },
    //         failureCallBack: (message) {
    //           divineSnackBar(data: message);
    //         },
    //       );
    //     } else {
    //       divineSnackBar(data: "errorLine1".tr);
    //     }
    //   } else {
    //     divineSnackBar(data: "Insufficient Permission");
    //   }
    // }

    final bool hasAllPermission = await permissionCheck();
    if (hasAllPermission) {
      final bool hasAllData = await dataCheck(controller: controller);
      if (hasAllData) {
        final (bool, String) can1 = await canEnter(controller: controller);
        if (can1.$1 == true && can1.$2 == "") {
          connectSocket(controller: controller);
          await controller!.furtherProcedure();
          final (bool, String) can2 = await canExit(controller: controller);
          if (can2.$1 == true && can2.$2 == "") {
          } else {
            divineSnackBar(data: can2.$2);
          }
        } else {
          divineSnackBar(data: can1.$2);
        }
      } else {
        divineSnackBar(data: "Insufficient data, Please try to Re-login");
      }
    } else {
      divineSnackBar(data: "Insufficient Permissions, allow all Permissions");
    }

    return Future<void>.value();
  }

  //
  Future<bool> permissionCheck() async {
    bool hasAllPerm = false;
    await AppPermissionService.instance.onPressedAstrologerGoLive(
      () async {
        hasAllPerm = true;
      },
    );
    return Future<bool>.value(hasAllPerm);
  }

  Future<bool> dataCheck({LiveTipsController? controller}) async {
    bool hasAllData = false;

    var pref = controller!.pref;

    final String userId = (pref.getUserDetail()?.id ?? "").toString();
    final String userName = pref.getUserDetail()?.name ?? "";
    // final String awsURL = pref.getAmazonUrl() ?? "";
    // final String image = pref.getUserDetail()?.image ?? "";

    final bool cond1 = userId.isNotEmpty;
    final bool cond2 = userName.isNotEmpty;
    // final bool cond3 = awsURL.isNotEmpty;
    // final bool cond4 = image.isNotEmpty;

    hasAllData = cond1 && cond2 /* && cond3 && cond4 */;

    return Future<bool>.value(hasAllData);
  }

  Future<(bool, String)> canEnter({LiveTipsController? controller}) async {
    bool returnBool = false;
    String returnString = "";
    await controller!.astroOnlineAPI(
      entering: true,
      successCallBack: (message) {
        returnBool = true;
        returnString = "";
      },
      failureCallBack: (message) {
        returnBool = false;
        returnString = message;
      },
    );
    return Future<(bool, String)>.value((returnBool, returnString));
  }

  void connectSocket({LiveTipsController? controller}) {
    final int userId = controller!.pref.getUserDetail()?.id ?? 0;
    AppSocket().joinLive(userType: "astrologer", userId: userId);
    return;
  }

  Future<(bool, String)> canExit({LiveTipsController? controller}) async {
    bool returnBool = false;
    String returnString = "";
    await controller!.astroOnlineAPI(
      entering: false,
      successCallBack: (message) {
        returnBool = true;
        returnString = "";
      },
      failureCallBack: (message) {
        returnBool = false;
        returnString = message;
      },
    );
    return Future<(bool, String)>.value((returnBool, returnString));
  }
}
