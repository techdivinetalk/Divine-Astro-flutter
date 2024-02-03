import 'dart:convert';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../firebase_service/firebase_service.dart';

class ZegoService {
  static final ZegoService _singleton = ZegoService._internal();

  factory ZegoService() {
    return _singleton;
  }

  ZegoService._internal();

  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  final controller = ZegoUIKitPrebuiltCallController();

  RxBool isFront = true.obs;
  RxBool isCamOn = true.obs;
  RxBool isMicOn = true.obs;

  Future<void> zegoLogin() async {
    String userID = (_pref.getUserDetail()?.id ?? "").toString();
    String userName = _pref.getUserDetail()?.name ?? "";
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoAndroidNotificationConfig(
          channelID: "ZegoUIKit",
          channelName: "Call Notifications",
          sound: "accept_ring",
          icon: "call",
        ),
      ),
      requireConfig: (ZegoCallInvitationData data) {
        final Map map = json.decode(data.customData);
        final String targetUserID = map["userId"];
        final String targetUserName = map["userName"];
        final String targetUserImage = map["userImage"];
        final Color color = data.type == ZegoCallType.videoCall
            ? AppColors.white
            : const Color(0xff5F3C08);

        ZegoUIKitPrebuiltCallConfig config = data.type == ZegoCallType.videoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        config.duration = ZegoCallDurationConfig(isVisible: false);
        config.avatarBuilder = (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map<String, dynamic> extraInfo,
        ) {
          return avatarWidget(context, size, user, extraInfo, targetUserImage);
        };
        config.topMenuBar = ZegoCallTopMenuBarConfig(buttons: []);
        config.bottomMenuBar = ZegoCallBottomMenuBarConfig(buttons: []);
        config.audioVideoView = ZegoCallAudioVideoViewConfig(
          useVideoViewAspectFill: true,

          // backgroundBuilder: (
          //   BuildContext context,
          //   Size size,
          //   ZegoUIKitUser? user,
          //   Map<String, dynamic> extraInfo,
          // ) {
          //   return (user?.id == targetUserID)
          //       ? Container(
          //           height: Get.height,
          //           width: Get.width,
          //           color: color,
          //         )
          //       : Image.asset(
          //           "assets/images/bg_chat_wallpaper.png",
          //           height: Get.height,
          //           width: Get.width,
          //           fit: BoxFit.fill,
          //         );
          // },
        );
        config.foreground = Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    color: color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "100% Private Call",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                targetUserName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "00:00:00",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
              ),
              SizedBox(height: Get.height * 0.64),
              settingsColForCust(data.type),
              const SizedBox(height: 16),
            ],
          ),
        );
        return config;
      },
    );
    print("ZegoService: zegoLogin: $userID $userName");
    Future<void>.value();
  }

  Widget avatarWidget(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
    String targetUserImage,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: SizedBox(
          height: 100,
          width: 100,
          child: CustomImageWidget(
            imageUrl: targetUserImage,
            rounded: false,
            typeEnum: TypeEnum.user,
          ),
        ),
      ),
    );
  }

  Widget settingsColForCust(ZegoCallType type) {
    final bool condForVideoCall = type == ZegoCallType.videoCall;
    final bool condForAudioCall = type == ZegoCallType.voiceCall;
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: condForVideoCall
              ? [
                  InkWell(
                    onTap: () async {
                      final ZegoUIKit instance = ZegoUIKit.instance;
                      isFront(!isFront.value);
                      instance.useFrontFacingCamera(isFront.value);
                    },
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: Image.asset(
                        isFront.value
                            ? "assets/images/chat_video_call_switch_cam.png"
                            : "assets/images/chat_video_call_switch_cam.png",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final ZegoUIKit instance = ZegoUIKit.instance;
                      isCamOn(!isCamOn.value);
                      instance.turnCameraOn(isCamOn.value);
                    },
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: Image.asset(
                        isCamOn.value
                            ? "assets/images/chat_video_call_camera_on.png"
                            : "assets/images/chat_video_call_camera_off.png",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final ZegoUIKit instance = ZegoUIKit.instance;
                      isMicOn(!isMicOn.value);
                      instance.turnMicrophoneOn(isMicOn.value, muteMode: true);
                    },
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: Image.asset(
                        isMicOn.value
                            ? "assets/images/chat_video_call_mic_on.png"
                            : "assets/images/chat_video_call_mic_off.png",
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      controller.hangUp(Get.context!, showConfirmation: true);
                    },
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: Image.asset(
                        "assets/images/chat_video_voice_hang_up.png",
                      ),
                    ),
                  ),
                ]
              : condForAudioCall
                  ? [
                      InkWell(
                        onTap: () {
                          final ZegoUIKit instance = ZegoUIKit.instance;
                          isMicOn(!isMicOn.value);
                          instance.turnMicrophoneOn(isMicOn.value,
                              muteMode: true);
                        },
                        child: SizedBox(
                          height: 64,
                          width: 64,
                          child: Image.asset(
                            isMicOn.value
                                ? "assets/images/chat_voice_call_mic_on.png"
                                : "assets/images/chat_voice_call_mic_off.png",
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          controller.hangUp(Get.context!,
                              showConfirmation: true);
                        },
                        child: SizedBox(
                          height: 64,
                          width: 64,
                          child: Image.asset(
                            "assets/images/chat_video_voice_hang_up.png",
                          ),
                        ),
                      ),
                    ]
                  : [],
        );
      },
    );
  }

  Future<void> zegoLogout() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    Future<void>.value();
  }

  Widget buttonUI({
    required bool isVideoCall,
    required String targetUserID,
    required String targetUserName,
    required Function() checkOppositeSidePermGranted,
  }) {
    return SizedBox(
      height: 32,
      width: 32,
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.appYellowColour,
        onPressed: () async {
          print("ZegoService: buttonUI: $targetUserID $targetUserName");
          await newOnPressed(
            isVideoCall: isVideoCall,
            targetUserID: targetUserID,
            targetUserName: targetUserName,
            checkOppositeSidePermGranted: checkOppositeSidePermGranted,
          );
        },
        child: Icon(isVideoCall ? Icons.video_call : Icons.call),
      ),
    );
  }

  Future<void> newOnPressed({
    required bool isVideoCall,
    required String targetUserID,
    required String targetUserName,
    required Function() checkOppositeSidePermGranted,
  }) async {
    final bool value = await AppPermissionService.instance.hasAllPermissions();
    if (value) {
      await canInit();
      final bool checkOppositeSidePerm = await checkOppositeSidePermission();
      checkOppositeSidePerm
          ? await controller.invitation.send(
              invitees: [ZegoCallUser(targetUserID, targetUserName)],
              isVideoCall: isVideoCall,
              resourceID: "zego_call",
              customData: json.encode(
                {
                  "userId": targetUserID,
                  "userName": targetUserName,
                  "userImage":
                      "https://divinenew-prod.s3.ap-south-1.amazonaws.com/divine/January2024/fGfpNU1Y40lV0ojgh0JBpgbc4mJtAdV6hgG5xZXJ.jpg",
                },
              ),
            )
          : checkOppositeSidePermGranted();
    } else {
      await AppPermissionService.instance.showAlertDialog(
        "Chat",
        ["Allow display over other apps", "Camera", "Microphone"],
      );
      await AppPermissionService.instance.zegoOnPressedJoinButton(() {});
      await canInit();
    }
    return Future<void>.value();
  }

  Future<void> canInit() async {
    final bool value = await AppPermissionService.instance.hasAllPermissions();
    if (value) {
      await zegoLogin();
    } else {}
    await addUpdatePermission();
    Future<void>.value();
  }

  Future<void> addUpdatePermission() async {
    final bool value = await AppPermissionService.instance.hasAllPermissions();
    FirebaseDatabase.instance
        .ref()
        .child("order/${AppFirebaseService().orderData.value["orderId"]}")
        .update(
      <String, dynamic>{"astrologer_permission": value},
    );
    return Future<void>.value();
  }

  Future<bool> checkOppositeSidePermission() async {
    bool hasPermission = false;
    final DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("order/${Get.arguments["orderData"]["orderId"]}")
        .get();
    if (dataSnapshot.exists) {
      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> map = <dynamic, dynamic>{};
        map = (dataSnapshot.value ?? <dynamic, dynamic>{})
            as Map<dynamic, dynamic>;
        hasPermission = map["customer_permission"] ?? false;
      } else {}
    } else {}
    return Future<bool>.value(hasPermission);
  }

  Future<void> newOnBannerPressed() async {
    await AppPermissionService.instance.showAlertDialog(
      "Chat",
      ["Allow display over other apps", "Camera", "Microphone"],
    );
    await AppPermissionService.instance.zegoOnPressedJoinButton(() {});
    await canInit();
    return Future<void>.value();
  }
}
