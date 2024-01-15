import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  static final ZegoService _singleton = ZegoService._internal();

  factory ZegoService() {
    return _singleton;
  }

  ZegoService._internal();

  final SharedPreferenceService _pref = Get.put(SharedPreferenceService());

  final controller = ZegoUIKitPrebuiltCallController();

  Future<void> zegoLogin() async {
    String userID = (_pref.getUserDetail()?.id ?? "").toString();
    String userName = _pref.getUserDetail()?.name ?? "";
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: appID,
      appSign: appSign,
      userID: userID,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      controller: controller,
      androidNotificationConfig: ZegoAndroidNotificationConfig(
        channelID: "ZegoUIKit",
        channelName: "Call Notifications",
        sound: "accept_ring",
        icon: "call",
      ),
    );
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
          bool condi = await AppPermissionService.instance.hasAllPermissions();
          if (condi) {
            bool checkOppositeSidePerm = await checkOppositeSidePermission();
            if (checkOppositeSidePerm) {
              await controller.sendCallInvitation(
                invitees: [ZegoCallUser(targetUserID, targetUserName)],
                isVideoCall: isVideoCall,
              );
            } else {
              checkOppositeSidePermGranted();
            }
          } else {
            await ZegoService().onPressed();
          }
        },
        child: Icon(isVideoCall ? Icons.video_call : Icons.call),
      ),
    );
  }

  Future<void> zegoLogout() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    Future<void>.value();
  }

  Future<void> goInsideChat({
    required Function() successCallback,
    required Function() failureCallback,
  }) async {
    bool hasAllPerm = false;
    await AppPermissionService.instance.zegoOnPressedJoinButton(
      () {
        hasAllPerm = true;
      },
    );
    if (hasAllPerm) {
      await zegoLogin();
      successCallback();
    } else {
      failureCallback();
    }
    return Future<void>.value();
  }

  Future<void> startZegoService({
    required Function() successCallback,
    required Function() failureCallback,
  }) async {
    bool condi = await AppPermissionService.instance.hasAllPermissions();
    if (condi == false) {
      await AppPermissionService.instance.showAlertDialog(
        "Chat",
        ["Allow display over other apps", "Camera", "Microphone"],
      );
    } else {}
    await goInsideChat(
      successCallback: successCallback,
      failureCallback: failureCallback,
    );
    return Future<void>.value();
  }

  Future<void> onPressed() async {
    bool value = false;
    await ZegoService().startZegoService(
      successCallback: () {
        value = true;
      },
      failureCallback: () {
        value = false;
      },
    );
    FirebaseDatabase.instance
        .ref()
        .child("order/${Get.arguments["orderData"]["orderId"]}")
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
}
