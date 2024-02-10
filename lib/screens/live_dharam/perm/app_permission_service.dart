import "dart:developer";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/permission_handler.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:permission_handler/permission_handler.dart";
import "dart:io";

import "package:device_info_plus/device_info_plus.dart";

class AppPermissionService {
  AppPermissionService._();

  static final AppPermissionService instance = AppPermissionService._();

  Future<bool> permissionOvr() async {
    bool hasOverlayPermission = false;
    final PermissionStatus try0 = await Permission.systemAlertWindow.status;
    if (try0 == PermissionStatus.granted) {
      hasOverlayPermission = true;
    } else {
      final PermissionStatus try1 =
          await Permission.systemAlertWindow.request();
      if (try1 == PermissionStatus.granted) {
        hasOverlayPermission = true;
      } else {}
    }
    return Future<bool>.value(hasOverlayPermission);
  }

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

  Future<bool> permissionPhotos() async {
    bool hasPhotosPermission = false;
    final PermissionStatus try0 = await Permission.photos.status;
    if (try0 == PermissionStatus.granted) {
      hasPhotosPermission = true;
    } else {
      final PermissionStatus try1 = await Permission.photos.request();
      if (try1 == PermissionStatus.granted) {
        hasPhotosPermission = true;
      } else {}
    }
    return Future<bool>.value(hasPhotosPermission);
  }

  Future<bool> permissionStorage() async {
    bool hasStoragePermission = false;
    final PermissionStatus try0 = await Permission.storage.status;
    if (try0 == PermissionStatus.granted) {
      hasStoragePermission = true;
    } else {
      final PermissionStatus try1 = await Permission.storage.request();
      if (try1 == PermissionStatus.granted) {
        hasStoragePermission = true;
      } else {}
    }
    return Future<bool>.value(hasStoragePermission);
  }

  Future<bool> permissionPhotoOrStorage() async {
    bool perm = false;
    if (Platform.isIOS) {
      perm = await permissionPhotos();
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo android = await DeviceInfoPlugin().androidInfo;
      final int sdkInt = android.version.sdkInt;
      perm = sdkInt > 32 ? await permissionPhotos() : await permissionStorage();
    } else {}
    return Future<bool>.value(perm);
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
            await showPermissionDialog(
              permissionName: 'Camera',
              isForOverlayPermission: false,
            );
          } else if (!hasMicPerm) {
            await showPermissionDialog(
              permissionName: 'Microphone',
              isForOverlayPermission: false,
            );
          } else {}
        } else if (voi) {
          if (!hasMicPerm) {
            await showPermissionDialog(
              permissionName: 'Microphone',
              isForOverlayPermission: false,
            );
          } else {}
        } else {}
      }
    } else {
      log("Unknown type $type");
    }

    return Future<void>.value();
  }

  Future<void> onPressedAstrologerGoLive(Function() callback) async {
    bool hasAllPerm = false;
    bool hasCamPerm = false;
    bool hasMicPerm = false;
    bool hasOvrStrg = false;
    hasCamPerm = await AppPermissionService.instance.permissionCam();
    hasMicPerm = await AppPermissionService.instance.permissionMic();
    // hasOvrStrg = await AppPermissionService.instance.permissionStorage();
    hasOvrStrg = await AppPermissionService.instance.permissionPhotoOrStorage();
    hasAllPerm = hasCamPerm && hasMicPerm && hasOvrStrg;
    if (hasAllPerm) {
      log("hasAllPerm");
      callback();
    } else {
      if (!hasCamPerm) {
        await showPermissionDialog(
          permissionName: 'Camera',
          isForOverlayPermission: false,
        );
      } else if (!hasMicPerm) {
        await showPermissionDialog(
          permissionName: 'Microphone',
          isForOverlayPermission: false,
        );
      } else if (!hasOvrStrg) {
        await showPermissionDialog(
          permissionName: 'Storage',
          isForOverlayPermission: false,
        );
      } else {}
    }
    return Future<void>.value();
  }

  Future<void> zegoOnPressedJoinButton(Function() callback) async {
    bool hasAllPerm = false;
    bool hasOvrPerm = false;
    bool hasCamPerm = false;
    bool hasMicPerm = false;
    hasOvrPerm = await AppPermissionService.instance.permissionOvr();
    hasCamPerm = await AppPermissionService.instance.permissionCam();
    hasMicPerm = await AppPermissionService.instance.permissionMic();
    hasAllPerm = hasOvrPerm && hasCamPerm && hasMicPerm;
    if (hasAllPerm) {
      log("hasAllPerm");
      callback();
    } else {
      if (!hasOvrPerm) {
        await showPermissionDialog(
          permissionName: 'Draw Over Other Apps',
          isForOverlayPermission: true,
        );
      } else if (!hasCamPerm) {
        await showPermissionDialog(
          permissionName: 'Camera',
          isForOverlayPermission: false,
        );
      } else if (!hasMicPerm) {
        await showPermissionDialog(
          permissionName: 'Microphone',
          isForOverlayPermission: false,
        );
      } else {}
    }
    return Future<void>.value();
  }

  Future<void> showAlertDialog(String module, List<String> perms) async {
    await showDialog(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permission need for use $module"),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "In order to use $module in the app needed below-mentioned permissions:",
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: perms.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.circle),
                      title: Text(perms[index]),
                      onTap: () {},
                    );
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> showPermissionDialog({
    required String permissionName,
    required bool isForOverlayPermission,
  }) async {
    await showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (BuildContext context) {
        return PermissionDialog(
          permissionName: permissionName,
          isForOverlayPermission: isForOverlayPermission,
        );
      },
    );
    return Future<void>.value();
  }

  Future<bool> hasAllPermissions() async {
    final PermissionStatus perm1 = await Permission.systemAlertWindow.status;
    final PermissionStatus perm2 = await Permission.camera.status;
    final PermissionStatus perm3 = await Permission.microphone.status;

    final bool value = perm1.isGranted && perm2.isGranted && perm3.isGranted;

    return Future<bool>.value(value);
  }
}
