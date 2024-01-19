import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_screen.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
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
    print("ZegoService: zegoLogin: $userID $userName");
    Future<void>.value();
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
          ? await controller.sendCallInvitation(
              invitees: [ZegoCallUser(targetUserID, targetUserName)],
              isVideoCall: isVideoCall,
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
