import "dart:developer";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/permission_handler.dart";
import "package:flutter/cupertino.dart";
import "package:get/get.dart";
import "package:permission_handler/permission_handler.dart";

class AppPermissionService {
  AppPermissionService._();
  static final AppPermissionService instance = AppPermissionService._();

  Future<bool> permissionCam() async {
    bool hasCameraPermission = false;
    final PermissionStatus try0 = await Permission.camera.status;
    if (try0 == PermissionStatus.granted) {
      hasCameraPermission = true;
    } else {
      final PermissionStatus try1 = await Permission.camera.request();
      if (try1 == PermissionStatus.granted) {
        hasCameraPermission = true;
      } else {}
    }
    return Future<bool>.value(hasCameraPermission);
  }

  Future<bool> permissionMic() async {
    bool hasMicrophonePermission = false;
    final PermissionStatus try0 = await Permission.microphone.status;
    if (try0 == PermissionStatus.granted) {
      hasMicrophonePermission = true;
    } else {
      final PermissionStatus try1 = await Permission.microphone.request();
      if (try1 == PermissionStatus.granted) {
        hasMicrophonePermission = true;
      } else {}
    }
    return Future<bool>.value(hasMicrophonePermission);
  }

  Future<void> onPressedJoinButton(type, Function() callback) async {
    final bool vid = type == "Video";
    final bool voi = type == "Audio" || type == "Private";
    bool hasAllPerm = false;
    bool hasCamPerm = false;
    bool hasMicPerm = false;
    if (vid || voi) {
      if (vid) {
        hasCamPerm = await AppPermissionService.instance.permissionCam();
        hasMicPerm = await AppPermissionService.instance.permissionMic();
        hasAllPerm = hasCamPerm && hasMicPerm;
      } else if (voi) {
        hasMicPerm = await AppPermissionService.instance.permissionMic();
        hasAllPerm = hasMicPerm;
      } else {}
      if (hasAllPerm) {
        log("hasAllPerm");
        callback();
      } else {
        if (vid) {
          if (!hasCamPerm) {
            await showPermissionDialog('Camera');
          } else if (!hasMicPerm) {
            await showPermissionDialog('Microphone');
          } else {}
        } else if (voi) {
          if (!hasMicPerm) {
            await showPermissionDialog('Microphone');
          } else {}
        } else {}
      }
    } else {
      log("Unknown type $type");
    }

    return Future<void>.value();
  }

  Future<void> showPermissionDialog(String permissionName) async {
    await showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: AppColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return PermissionDialog(permissionName: permissionName);
      },
    );
    return Future<void>.value();
  }
}
