import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class PermissionHelper {
  askPermissions() async {
    var result = await [
      Permission.camera,
      Permission.microphone,
    ].request().then((value) => getBothPermissionStatus());
    return result;
  }

  askMediaPermission() async {
    //Camera, Gallery (32 > photos : storage)
    Permission permission = await getPermissionFromAPILevel(Permission.photos);
    var result = await [
      Permission.camera,
      permission,
    ].request().then((value) => getMediaPermissionStatus(permission));
    return result;
  }

  askStoragePermission(Permission permission) async {
    Permission askPermission = await getPermissionFromAPILevel(permission);
    var result = await askPermission
        .request()
        .then((value) => getPermissionStatus(askPermission));
    return result;
  }

  askNotificationPermission() async {
    //Permission askPermission = await getPermissionFromAPILevel(Permission.notification);
    var result = await [Permission.notification]
        .request()
        .then((value) => getPermissionStatus(Permission.notification));
    return result;
  }

  askCustomPermission(Permission permission) async {
    var result = await permission
        .request()
        .then((value) => getPermissionStatus(permission));
    return result;
  }

  getPermissionStatus(Permission permission) async {
    int result = await checkPermission(permission);

    if (result == 0) {
      return true;
    } else {
      showPermissionDialog(getPermissionNameString(permission));
    }
  }

  getBothPermissionStatus() async {
    int cameraResult = await checkPermission(Permission.camera);
    int micResult = await checkPermission(Permission.microphone);

    ///0 - granted, 1 - permanentlyDenied
    if (cameraResult == 0 && micResult == 0) {
      return true;
    } else if (cameraResult == 1) {
      showPermissionDialog(getPermissionNameString(Permission.camera));
      return false;
    } else if (micResult == 1) {
      showPermissionDialog(getPermissionNameString(Permission.microphone));
      return false;
    }
  }

  getMediaPermissionStatus(Permission permission) async {
    int cameraResult = await checkPermission(Permission.camera);
    int storageResult = await checkPermission(permission);

    ///0 - granted, 1 - permanentlyDenied
    if (cameraResult == 0 && storageResult == 0) {
      return true;
    } else if (cameraResult == 1) {
      showPermissionDialog(getPermissionNameString(Permission.camera));
      return false;
    } else if (storageResult == 1) {
      showPermissionDialog(getPermissionNameString(permission));
      return false;
    }
  }

  checkPermission(Permission permission) async {
    if (await permission.isGranted) {
      return 0;
    } else if (await permission.isDenied ||
        await permission.isPermanentlyDenied) {
      return 1;
    }
  }

  Future<Permission> getPermissionFromAPILevel(Permission permission) async {
    if (Platform.isAndroid) {
      var deviceInfo = await DeviceInfoPlugin().androidInfo;
      int sdkInt = deviceInfo.version.sdkInt;
      return sdkInt > 32 ? (permission) : Permission.storage;
    } else {
      return permission;
    }
  }

  askPermissionDialog(Permission permission, String permissionName) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (context) => AskPermissionDialog(
          permission: permission, permissionName: permissionName),
    );
  }

  showPermissionDialog(String permissionName) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: appColors.darkBlue.withOpacity(0.5),
      builder: (context) => PermissionDialog(permissionName: permissionName),
    );
  }

  getPermissionNameString(Permission permission) {
    if (permission == Permission.camera) {
      return 'camera';
    } else if (permission == Permission.microphone) {
      return 'microphone';
    } else if (permission == Permission.photos) {
      return 'photos';
    } else if (permission == Permission.storage) {
      return 'storage';
    } else if (permission == Permission.videos) {
      return 'videos';
    } else if (permission == Permission.contacts) {
      return 'contacts';
    } else if (permission == Permission.notification) {
      return 'notification';
    }
  }

  Future<bool> getAllPermissionForCamera() async {
    var cameraPermissionStatus = await Permission.camera.status;
    var storagePermissionStatus = await Permission.storage.status;
    var microphonePermissionStatus = await Permission.microphone.status;

    if (!cameraPermissionStatus.isGranted ||
        !storagePermissionStatus.isGranted ||
        !microphonePermissionStatus.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.microphone,
        Permission.storage,
      ].request();

      if (statuses[Permission.camera] == PermissionStatus.granted &&
          statuses[Permission.microphone] == PermissionStatus.granted &&
          statuses[Permission.storage] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }

    return true;
  }
}

class AskPermissionDialog extends StatelessWidget {
  final String permissionName;
  final Permission permission;

  const AskPermissionDialog(
      {super.key, required this.permission, required this.permissionName});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              // onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: appColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: context.width,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                color: appColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Icon(
                    Icons.query_builder_rounded,
                    color: appColors.redColor,
                    size: 60.h,
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    'Allow $permissionName access',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    maxLines: 3,
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomText(
                      'We require $permissionName permission to access $permissionName features in the app!',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () async {
                              // Get.back();
                              Navigator.pop(context);
                              await permission.request();
                            },
                            radius: 100.r,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            color: appColors.guideColor,
                            child: Center(
                              child: CustomText(
                                'Grant Permission',
                                fontSize: 20.sp,
                                fontColor: appColors.brownColour,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionDialog extends StatelessWidget {
  final String permissionName;
  final bool? isForOverlayPermission;

  const PermissionDialog(
      {super.key, required this.permissionName, this.isForOverlayPermission});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: appColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: appColors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: context.width,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                color: appColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Icon(
                    Icons.query_builder_rounded,
                    color: appColors.redColor,
                    size: 60.h,
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    'Allow $permissionName access',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: CustomText(
                      'We require $permissionName permission to access $permissionName features in the app!',
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () async {
                              Get.back();
                              // Navigator.pop(context);
                              await Future.delayed(const Duration(seconds: 1));
                              (isForOverlayPermission ?? false) == true
                                  ? await FlutterOverlayWindow
                                      .requestPermission()
                                  : await AppSettings.openAppSettings();
                            },
                            radius: 100.r,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            color: appColors.guideColor,
                            child: Center(
                              child: CustomText(
                                'Open Settings',
                                fontSize: 20.sp,
                                fontColor: appColors.brownColour,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
