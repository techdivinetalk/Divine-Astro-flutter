import 'dart:convert';
import 'dart:io';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/constants.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:divine_astrologer/zego_call/chat_call_on_off_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../firebase_service/firebase_service.dart';
import '../screens/live_page/constant.dart';

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
  RxBool isInCallScreen = true.obs;

  void micTurnOnOff() {
    final ZegoUIKit instance = ZegoUIKit.instance;
    isMicOn(!isMicOn.value);
    debugPrint("isMicOn: ${isMicOn.value.toString()}");
    instance.turnMicrophoneOn(
      isMicOn.value,
      muteMode: true,
      userID: (_pref.getUserDetail()?.id ?? "").toString(),
    );
  }

  Future<void> zegoLogin() async {
    print("test_call_zego_service: zegoLogin");
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: (_pref.getUserDetail()?.id ?? "").toString(),
      userName: _pref.getUserDetail()?.name ?? "",
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
          androidNotificationConfig: ZegoCallAndroidNotificationConfig(
            showFullScreen: true,
            channelID: "ZegoUIKit",
            channelName: "Call Notifications",
            sound: "accept_ring",
            icon: "call",
          ),
          iOSNotificationConfig: ZegoCallIOSNotificationConfig(
            systemCallingIconName: 'CallKitIcon',
            certificateIndex: ZegoSignalingPluginMultiCertificate.secondCertificate,
          )),

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
          inviter: ZegoCallInvitationInviterUIConfig(
            backgroundBuilder: (context, size, info) {
              return info.callType == ZegoCallType.voiceCall
                  ? backgroundImage(needBlendedColor: true)
                  : null;
            },
          ),
          invitee: ZegoCallInvitationInviteeUIConfig(
            backgroundBuilder: (context, size, info) {
              return info.callType == ZegoCallType.voiceCall
                  ? backgroundImage(needBlendedColor: true)
                  : null;
            },
          )),
      // events: ZegoUIKitPrebuiltCallEvents(
      //   onCallEnd: (
      //     ZegoCallEndEvent event,
      //     VoidCallback defaultAction,
      //   ) {
      //     print("event:: ${event.reason.name}");
      //     print('event:: onCallEnd, do whatever you want');
      //     print('event:: ${isInCallScreen.value}');
      //     if (isInCallScreen.value) {
      //       defaultAction.call();
      //     } else {}
      //   },
      // ),
      requireConfig: (ZegoCallInvitationData data) {
        print("test_isCamOn.value: ${isCamOn.value}");

        isFront.value = true;
        isCamOn.value = true;
        isMicOn.value = true;

        // if (Constants.isUploadMode) {
        // ZegoUIKitPrebuiltCallController().audioVideo.microphone.turnOn(bool isOn, {String? userID});

        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            micTurnOnOff();

            Future.delayed(
              const Duration(milliseconds: 500),
              () {
                micTurnOnOff();
              },
            );
          },
        );
        // }

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
            ? appColors.white
            : appColors.brown;
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
          child: LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints boxConstraints,
            ) {
              return SizedBox(
                height: boxConstraints.maxHeight,
                width: boxConstraints.maxWidth,
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
                          AppFirebaseService().orderData.value["customerName"],
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
                        // SizedBox(height: Get.height * 0.60),
                        const Spacer(),
                        commonBottomCard(),
                        const SizedBox(height: 16),
                        settingsColForCust(data.type),
                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
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
    return Text(showTalkTime.value);
    // return TimerCountdown(
    //   format: CountDownTimerFormat.hoursMinutesSeconds,
    //   enableDescriptions: false,
    //   spacerWidth: 4,
    //   colonsTextStyle: TextStyle(
    //     fontSize: isForBottomCard ? 12 : 20,
    //     fontWeight: FontWeight.w400,
    //     color: color,
    //     shadows: [
    //       Shadow(
    //         color: color,
    //         offset: const Offset(1.0, 1.0),
    //         blurRadius: 1.0,
    //       ),
    //     ],
    //   ),
    //   timeTextStyle: TextStyle(
    //     fontSize: isForBottomCard ? 12 : 20,
    //     fontWeight: FontWeight.w400,
    //     color: color,
    //     shadows: [
    //       Shadow(
    //         color: color,
    //         offset: const Offset(1.0, 1.0),
    //         blurRadius: 1.0,
    //       ),
    //     ],
    //   ),
    //   onTick: (Duration duration) {
    //     onTickDuration(duration);
    //     if (endTime.value != DateTime(1970, 01, 01)) {
    //       endTime(DateTime.now().add(duration));
    //     } else {}
    //     isCardVisible(duration <= const Duration(seconds: 10));
    //   },
    //   endTime: endTime.value,
    //   onEnd: () async {
    //     if (isInCallScreen.value) {
    //       await controller.hangUp(Get.context!);
    //     } else {}
    //   },
    // );
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
          border: Border.all(color: appColors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: appColors.white,
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
                  style: TextStyle(color: appColors.red, fontSize: 12),
                ),
                TextSpan(
                  text:
                      ' are remaining! Please recharge to continue the chat and get Offer% + ',
                  style: TextStyle(color: appColors.black, fontSize: 12),
                ),
                TextSpan(
                  text: '5% Extra!',
                  style: TextStyle(color: appColors.red, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing: InkWell(
            onTap: () async {
              // isInCallScreen(false);
              // await Get.toNamed(RouteName.wallet);
              // isInCallScreen(true);
              // if (onTickDuration.value == Duration.zero) {
              //   await controller.hangUp(Get.context!);
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
        debugPrint("test_isMicOn.value: ${isMicOn.value}");

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
                      // if (Constants.isUploadMode) {
                      micTurnOnOff();
                      // } else {
                      //   final ZegoUIKit instance = ZegoUIKit.instance;
                      //   isMicOn(!isMicOn.value);
                      //   debugPrint("isMicOn: ${isMicOn.value.toString()}");
                      //   instance.turnMicrophoneOn(isMicOn.value,
                      //       muteMode: true);
                      // }
                    },
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      // child: Image.asset(
                      //   isMicOn.value
                      //       ? "assets/images/chat_video_call_mic_on.png"
                      //       : "assets/images/chat_video_call_mic_off.png",
                      // ),
                      child: !isMicOn.value
                          ? Image.asset(
                              "assets/images/chat_voice_call_mic_on.png",
                            )
                          : Image.asset(
                              color: appColors.white,
                              "assets/images/chat_voice_call_mic_off.png",
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
                          // if (Constants.isUploadMode) {
                          micTurnOnOff();
                          // } else {
                          //   final ZegoUIKit instance = ZegoUIKit.instance;
                          //   isMicOn(!isMicOn.value);
                          //   instance.turnMicrophoneOn(isMicOn.value,
                          //       muteMode: true);
                          // }
                        },
                        child: SizedBox(
                          height: 64,
                          width: 64,
                          child: Image.asset(
                            !isMicOn.value
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
    required Function() astrologerDisabledCalls,
    required bool isAstrologer,
  }) {
    var orderData = AppFirebaseService().orderData.value;
    final bool isAccepting = isVideoCall
        ? orderData["astr_accepting_video_calls"] ?? false
        : orderData["astr_accepting_voice_calls"] ?? false;
    return InkWell(
      onTap: () async {
        isAstrologer
            ? await chatCallOnOffWidgetPopup(
                makeCallFunction: () async {
                  await newOnPressed(
                    isVideoCall: isVideoCall,
                    targetUserID: targetUserID,
                    targetUserName: targetUserName,
                    checkOppositeSidePermGranted: checkOppositeSidePermGranted,
                    customData: customData,
                  );
                },
                makeTurnOnOffCallsFunction: () async {
                  await addUpdateCallOnOff(isVideoCall: isVideoCall);
                },
                isVideoCall: isVideoCall,
              )
            : isAccepting
                ? await newOnPressed(
                    isVideoCall: isVideoCall,
                    targetUserID: targetUserID,
                    targetUserName: targetUserName,
                    checkOppositeSidePermGranted: checkOppositeSidePermGranted,
                    customData: customData,
                  )
                : astrologerDisabledCalls();
      },
      child: SizedBox(
        height: 24,
        width: 24,
        child: SvgPicture.asset(
          isVideoCall
              ? isAccepting
                  ? "assets/svg/new_chat_video.svg"
                  : "assets/svg/new_chat_video_disabled.svg"
              : isAccepting
                  ? "assets/svg/new_chat_call.svg"
                  : "assets/svg/new_chat_call_diabled.svg",
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
      print("AppPermissionService.instance.hasAllPermissions-->>$value");
      await canInit();
      final bool checkOppositeSidePerm = await checkOppositeSidePermission();
      checkOppositeSidePerm
          ? await ZegoUIKitPrebuiltCallInvitationService().send(
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
    print("test_call_zego_service: canInit");
    final bool value = await AppPermissionService.instance.hasAllPermissions();

    print("test_call_zego_service: hasAllPermissions: $value");

    if (value) {
      await zegoLogin();
    } else {}
    await addUpdatePermission();
    Future<void>.value();
  }

  Future<void> addUpdatePermission() async {
    print("test_call_zego_service: addUpdatePermission");
    final bool value = await AppPermissionService.instance.hasAllPermissions();
    final int orderId = AppFirebaseService().orderData.value["orderId"] ?? 0;
    if (orderId != 0) {
      final DatabaseReference ref = FirebaseDatabase.instance.ref();
      await ref.child("order/$orderId").update(
        {
          "astrologer_permission": value,
        },
      );
    } else {}
    return Future<void>.value();
  }

  Future<bool> checkOppositeSidePermission() async {
    bool hasPermission =
        AppFirebaseService().orderData.value["customer_permission"] ?? false;
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

  Future<void> addUpdateCallOnOff({required bool isVideoCall}) async {
    var orderData = AppFirebaseService().orderData.value;
    final int orderId = orderData["orderId"] ?? 0;
    final bool isAccepting = isVideoCall
        ? orderData["astr_accepting_video_calls"] ?? false
        : orderData["astr_accepting_voice_calls"] ?? false;
    if (orderId != 0) {
      final DatabaseReference ref = FirebaseDatabase.instance.ref();
      final Map<String, dynamic> map = isVideoCall
          ? {"astr_accepting_video_calls": !isAccepting}
          : {"astr_accepting_voice_calls": !isAccepting};
      await ref.child("order/$orderId").update(map);
    } else {}
    return Future<void>.value();
  }

  Future<void> chatCallOnOffWidgetPopup({
    required bool isVideoCall,
    required Function() makeCallFunction,
    required Function() makeTurnOnOffCallsFunction,
  }) async {
    var orderData = AppFirebaseService().orderData.value;
    final bool currentStatus = isVideoCall
        ? orderData["astr_accepting_video_calls"] ?? false
        : orderData["astr_accepting_voice_calls"] ?? false;
    await showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return ChatCallOnOffWidget(
          onClose: Get.back,
          makeCall: () {
            Get.back();

            if (currentStatus) {
            } else {
              makeTurnOnOffCallsFunction();
            }
            makeCallFunction();
          },
          makeTurnOnOffCalls: () {
            Get.back();
            makeTurnOnOffCallsFunction();
          },
          currentStatus: currentStatus,
          isVideoCall: isVideoCall,
        );
      },
    );
    return Future<void>.value();
  }
}
