import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  askPermissions() async {
    var result = await [
      Permission.camera,
      Permission.microphone,
    ].request().then((value) => getBothPermissionStatus());
    return result;
  }

  askMediaPermission() async {
    var result = await [
      Permission.camera,
      Permission.storage,
    ].request().then((value) => getMediaPermissionStatus());
    return result;
  }

  askCameraPermission() async {
    var result = await Permission.camera
        .request()
        .then((value) => getCameraPermissionStatus());
    return result;
  }

  askStoragePermission() async {
    var result = await Permission.storage
        .request()
        .then((value) => getStoragePermissionStatus());
    return result;
  }

  askMicPermission() async {
    var result = await Permission.microphone
        .request()
        .then((value) => getMicrophonePermissionStatus());
    return result;
  }

  getCameraPermissionStatus() async {
    int cameraResult = await checkCameraPermission();

    if (cameraResult == 0) {
      return true;
    } else {
      showPermissionDialog('camera');
    }
  }

  getStoragePermissionStatus() async {
    int storageResult = await checkStoragePermission();

    if (storageResult == 0) {
      return true;
    } else {
      showPermissionDialog('storage');
    }
  }

  getMicrophonePermissionStatus() async {
    int micResult = await checkMicrophonePermission();

    if (micResult == 0) {
      return true;
    } else {
      showPermissionDialog('microphone');
    }
  }

  getBothPermissionStatus() async {
    int cameraResult = await checkCameraPermission();
    int micResult = await checkMicrophonePermission();

    ///0 - granted, 1 - denied (ask again), 2 - permanentlyDenied
    print("results: cameraResult: $cameraResult, micResult: $micResult");
    if (cameraResult == 0 && micResult == 0) {
      return true;
    } else if (cameraResult == 1) {
      showPermissionDialog('camera');
      return false;
    } else if (micResult == 1) {
      showPermissionDialog('microphone');
      return false;
    }
  }

  getMediaPermissionStatus() async {
    int cameraResult = await checkCameraPermission();
    int storageResult = await checkStoragePermission();

    ///0 - granted, 1 - denied (ask again), 2 - permanentlyDenied
    print("results: cameraResult: $cameraResult, storageResult: $storageResult");
    if (cameraResult == 0 && storageResult == 0) {
      return true;
    } else if (cameraResult == 1) {
      showPermissionDialog('camera');
      return false;
    } else if (storageResult == 1) {
      showPermissionDialog('storage');
      return false;
    }
  }

  checkCameraPermission() async {
    Permission permission = Permission.camera;

    if (await permission.isGranted) {
      return 0;
    } else if (await permission.isDenied ||
        await permission.isPermanentlyDenied) {
      return 1;
    }
  }

  checkStoragePermission() async {
    Permission permission = Permission.storage;

    if (await permission.isGranted) {
      return 0;
    } else if (await permission.isDenied ||
        await permission.isPermanentlyDenied) {
      return 1;
    }
  }

  checkMicrophonePermission() async {
    Permission permission = Permission.microphone;

    if (await permission.isGranted) {
      return 0;
    } else if (await permission.isDenied ||
        await permission.isPermanentlyDenied) {
      return 1;
    }
  }

  askPermission(Permission permission, String permissionName) async {
    PermissionStatus request = await permission.request();
    if (request.isGranted) {
      return;
    } else if (request.isDenied) {
      askPermissionDialog(permission, permissionName);
    } else if (request.isPermanentlyDenied) {
      showPermissionDialog(permissionName);
    }
  }

  askPermissionDialog(Permission permission, String permissionName) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: AppColors.darkBlue.withOpacity(0.5),
      builder: (context) => AskPermissionDialog(
          permission: permission, permissionName: permissionName),
    );
  }

  showPermissionDialog(String permissionName) {
    showCupertinoModalPopup(
      context: Get.context!,
      barrierColor: AppColors.darkBlue.withOpacity(0.5),
      builder: (context) => PermissionDialog(permissionName: permissionName),
    );
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
      color: AppColors.transparent,
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
                  border: Border.all(color: AppColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: AppColors.white.withOpacity(0.2),
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
                color: AppColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Icon(
                    Icons.query_builder_rounded,
                    color: AppColors.redColor,
                    size: 60.h,
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    'Allow $permissionName access',
                    fontSize: 20.sp,
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
                              // Get.back();
                              Navigator.pop(context);
                              await permission.request();
                            },
                            radius: 100.r,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            color: AppColors.lightYellow,
                            child: Center(
                              child: CustomText(
                                'Grant Permission',
                                fontSize: 20.sp,
                                fontColor: AppColors.brownColour,
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

  const PermissionDialog({super.key, required this.permissionName});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
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
                  border: Border.all(color: AppColors.white),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  color: AppColors.white.withOpacity(0.2),
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
                color: AppColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Icon(
                    Icons.query_builder_rounded,
                    color: AppColors.redColor,
                    size: 60.h,
                  ),
                  SizedBox(height: 20.h),
                  CustomText(
                    'Allow $permissionName access',
                    fontSize: 20.sp,
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
                            onTap: () {
                              // Get.back();
                              Navigator.pop(context);
                              openAppSettings();
                            },
                            radius: 100.r,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            color: AppColors.lightYellow,
                            child: Center(
                              child: CustomText(
                                'Open Settings',
                                fontSize: 20.sp,
                                fontColor: AppColors.brownColour,
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
