import 'dart:convert';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../firebase_service/firebase_service.dart';
//
//

class ZegoService {
  static final ZegoService _singleton = ZegoService._internal();

  factory ZegoService() {
    return _singleton;
  }

  ZegoService._internal();

  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  final controller = ZegoUIKitPrebuiltCallController();

  Rx<Size> ourSize = const Size(0, 0).obs;
  RxBool isFront = true.obs;
  RxBool isCamOn = true.obs;
  RxBool isMicOn = true.obs;
  Rx<DateTime> endTime = DateTime(1970, 01, 01).obs;
  Rx<String> currentUserOnScreen = "".obs;
  Rx<Duration> onTickDuration = Duration.zero.obs;
  RxBool isCardVisible = false.obs;
  RxBool isAstrologer = true.obs;

  Future<void> zegoLogin() async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: (_pref.getUserDetail()?.id ?? "").toString(),
      userName: _pref.getUserDetail()?.name ?? "",
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoAndroidNotificationConfig(
          channelID: "ZegoUIKit",
          channelName: "Call Notifications",
          sound: "accept_ring",
          icon: "call",
        ),
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onIncomingCallAcceptButtonPressed: () {
          endTime(DateTime(1970, 01, 01));
        },
        onOutgoingCallAccepted: (String callID, ZegoCallUser callee) {
          endTime(DateTime(1970, 01, 01));
        },
      ),
      uiConfig: ZegoCallInvitationUIConfig(
        prebuiltWithSafeArea: false,
        callingBackgroundBuilder: (
          BuildContext context,
          Size size,
          ZegoCallingBackgroundBuilderInfo info,
        ) {
          return info.callType == ZegoCallType.voiceCall
              ? backgroundImage(needBlendedColor: true)
              : null;
        },
      ),
      requireConfig: (ZegoCallInvitationData data) {
        final Map map = json.decode(data.customData);
        // final String astrId = map["astr_id"];
        // final String astrName = map["astr_name"];
        final String astrImage = map["astr_image"];
        // final String custId = map["cust_id"];
        // final String custName = map["cust_name"];
        final String custImage = map["cust_image"];
        final String callTime = map["time"];
        if (endTime.value == DateTime(1970, 01, 01)) {
          endTime(
            DateTime.now().add(
              Duration(
                hours: DateFormat("hh:mm:ss").parse(callTime).hour,
                minutes: DateFormat("hh:mm:ss").parse(callTime).minute,
                seconds: DateFormat("hh:mm:ss").parse(callTime).second,
              ),
            ),
          );
        } else {}
        final Color color = data.type == ZegoCallType.videoCall
            ? AppColors.white
            : AppColors.brown;
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
          return avatarWidget(user, astrImage, custImage);
        };
        config.topMenuBar = ZegoCallTopMenuBarConfig(buttons: []);
        config.bottomMenuBar = ZegoCallBottomMenuBarConfig(buttons: []);
        config.audioVideoView = ZegoCallAudioVideoViewConfig(
          useVideoViewAspectFill: true,
          showSoundWavesInAudioMode: false,
          showCameraStateOnView: data.type == ZegoCallType.videoCall,
          showUserNameOnView: false,
          backgroundBuilder: (
            BuildContext context,
            Size size,
            ZegoUIKitUser? user,
            Map<String, dynamic> extraInfo,
          ) {
            WidgetsBinding.instance.addPostFrameCallback(
              (Duration duration) {
                currentUserOnScreen(user?.name ?? "");
                ourSize(
                  ourSize.value == const Size(0, 0) ? size : ourSize.value,
                );
              },
            );
            return size == ourSize.value
                ? backgroundImage(needBlendedColor: false)
                : Container(height: Get.height, width: Get.width, color: color);
          },
        );
        config.foreground = Positioned.fill(
          child: Obx(
            () {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 32),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Image.asset(
                          data.type == ZegoCallType.videoCall
                              ? "assets/images/chat_video_call_lock.png"
                              : "assets/images/chat_voice_call_lock.png",
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "100% Private Call",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: color,
                          shadows: [
                            Shadow(
                              color: color,
                              offset: const Offset(1.0, 1.0),
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUserOnScreen.value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: color,
                      shadows: [
                        Shadow(
                          color: color,
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  commonTimerCountdown(color, false),
                  SizedBox(height: Get.height * 0.60),
                  commonBottomCard(),
                  const SizedBox(height: 16),
                  settingsColForCust(data.type),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
        return config;
      },
    );
    Future<void>.value();
  }

  Widget backgroundImage({required bool needBlendedColor}) {
    return Image.asset(
      "assets/images/bg_chat_wallpaper.png",
      height: Get.height,
      width: Get.width,
      fit: BoxFit.fill,
      color: needBlendedColor ? const Color.fromRGBO(255, 255, 255, 0.5) : null,
      colorBlendMode: needBlendedColor ? BlendMode.modulate : null,
    );
  }

  Widget commonTimerCountdown(Color color, bool isForBottomCard) {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: TextStyle(
        fontSize: isForBottomCard ? 12 : 20,
        fontWeight: FontWeight.w400,
        color: color,
        shadows: [
          Shadow(
            color: color,
            offset: const Offset(1.0, 1.0),
            blurRadius: 1.0,
          ),
        ],
      ),
      timeTextStyle: TextStyle(
        fontSize: isForBottomCard ? 12 : 20,
        fontWeight: FontWeight.w400,
        color: color,
        shadows: [
          Shadow(
            color: color,
            offset: const Offset(1.0, 1.0),
            blurRadius: 1.0,
          ),
        ],
      ),
      onTick: (Duration duration) {
        onTickDuration(duration);
        if (endTime.value != DateTime(1970, 01, 01)) {
          endTime(DateTime.now().add(duration));
        } else {}
        isCardVisible(duration <= const Duration(seconds: 30));
      },
      endTime: endTime.value,
      onEnd: () async {
        await controller.hangUp(Get.context!);
      },
    );
  }

  Widget commonBottomCard() {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: isCardVisible.value && !isAstrologer.value,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: AppColors.white,
        ),
        child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          horizontalTitleGap: 0,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: 40,
              width: 64,
              child: Image.asset("assets/images/chat_common_clock.png"),
            ),
          ),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '${onTickDuration.value.inHours}:${onTickDuration.value.inMinutes}:${onTickDuration.value.inSeconds}',
                  style: const TextStyle(color: AppColors.red, fontSize: 12),
                ),
                const TextSpan(
                  text:
                      ' are remaining! Please recharge to continue the chat and get Offer% + ',
                  style: TextStyle(color: AppColors.black, fontSize: 12),
                ),
                const TextSpan(
                  text: '5% Extra!',
                  style: TextStyle(color: AppColors.red, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing: InkWell(
            onTap: () async {
              // await Get.toNamed(RouteName.wallet);
              // if (onTickDuration.value == Duration.zero) {
              //   await controller.hangUp(Get.context!);
              //   Get.back();
              // } else {}
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 40,
                width: 64,
                child: Image.asset("assets/images/chat_common_recharge.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget avatarWidget(ZegoUIKitUser? user, String astrImage, String custImage) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      child: SizedBox(
        height: 100,
        width: 100,
        child: CustomImageWidget(
          imageUrl:
              (user?.id ?? "") == (_pref.getUserDetail()?.id ?? "").toString()
                  ? astrImage
                  : custImage,
          rounded: false,
          typeEnum: TypeEnum.user,
        ),
      ),
    );
  }

  Widget settingsColForCust(ZegoCallType type) {
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: type == ZegoCallType.videoCall
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
                      await controller.hangUp(Get.context!);
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
              : type == ZegoCallType.voiceCall
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
                          await controller.hangUp(Get.context!);
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
    required Map customData,
  }) {
    return InkWell(
      onTap: () async {
        await newOnPressed(
          isVideoCall: isVideoCall,
          targetUserID: targetUserID,
          targetUserName: targetUserName,
          checkOppositeSidePermGranted: checkOppositeSidePermGranted,
          customData: customData,
        );
      },
      child: SizedBox(
        height: 32,
        width: 32,
        child: Image.asset(
          isVideoCall
              ? "assets/images/chat_video_call_icon.png"
              : "assets/images/chat_voice_call_icon.png",
        ),
      ),
    );
  }

  Future<void> newOnPressed({
    required bool isVideoCall,
    required String targetUserID,
    required String targetUserName,
    required Function() checkOppositeSidePermGranted,
    required Map customData,
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
              customData: json.encode(customData),
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
    final int orderId = AppFirebaseService().orderData.value["orderId"] ?? 0;
    if (orderId == 0) {
    } else {
      final DatabaseReference ref = FirebaseDatabase.instance.ref();
      await ref.child("order/$orderId").update({"astrologer_permission": value});
    }
    return Future<void>.value();
  }

  Future<bool> checkOppositeSidePermission() async {
    final int orderId = AppFirebaseService().orderData.value["orderId"] ?? 0;
    bool hasPermission = false;
    if (orderId == 0) {
    } else {
      final DatabaseReference ref = FirebaseDatabase.instance.ref();
      final DataSnapshot dataSnapshot = await ref.child("order/$orderId").get();
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          hasPermission = map["customer_permission"] ?? false;
        } else {}
      } else {}
    }
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
