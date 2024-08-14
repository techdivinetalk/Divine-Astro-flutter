import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureController extends GetxController {
  GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();
  bool isRadius = true;
  double minimumStrokeWidth = 3;
  TextEditingController signature = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  Color selectedBackgroundColor = Colors.white;

  Color selectedStrokeColor = appColors.guideColor;
  Color containerColor = Color(0xffFFFFFF);
  String selectedBackgroundImage = "";

  @override
  void onInit() {
    getDeviceDetails();
    super.onInit();
  }

  saveDrawSignature() {
    if (signaturePadKey.currentState!.toPathList().isNotEmpty) {
      screenShotImage();
    } else {
      divineSnackBar(data: "Please draw signature");
    }
  }

  screenShotImage() async {
    screenshotController.capture().then((Uint8List? image) async {
      Directory downloadPath = await getDownloadPath();
      String fileName =
          "${downloadPath.path}/Draw_signature_${DateTime.now().microsecond}${DateTime.now().millisecond}.png";
      bool isPermission = await askStoragePermission();
      print("isPermission ----->$isPermission");
      if (isPermission) {
        File(fileName).writeAsBytes(image!);
      } else {
        divineSnackBar(data: "Permission denied");
      }
      isRadius = true;
      update();
    }).catchError((onError) {
      print(onError);
    });
    isRadius = false;
    update();
  }

  Future<Directory> getDownloadPath() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      return directory;
    } else {
      Directory appDocDirFolder = Directory('/storage/emulated/0/Download');
      bool isPermission = await askStoragePermission();
      if (isPermission) {
        directory = Directory('/storage/emulated/0/Download');
        appDocDirFolder = Directory('${directory.path}/divinetalkAstrology');
        if (await appDocDirFolder.exists()) {
          return appDocDirFolder;
        } else {
          final Directory _appDocDirNewFolder =
              await appDocDirFolder.create(recursive: true);
          return _appDocDirNewFolder;
        }
      }
      return appDocDirFolder;
    }
  }

  Future<bool> askStoragePermission() async {
    bool isPermission = false;
    if (currentSdk >= 32) {
      var checkPermission = await Permission.photos.status;
      if (checkPermission.isDenied) {
        var status = await Permission.photos.request();
        if (status.isGranted) {
          isPermission = true;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else if (checkPermission.isGranted) {
        isPermission = true;
      } else if (checkPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      var checkPermission = await Permission.storage.status;

      if (checkPermission.isDenied) {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          isPermission = true;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else if (checkPermission.isGranted) {
        isPermission = true;
      } else if (checkPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    }
    return isPermission;
  }

  int currentSdk = 0;

  getDeviceDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      currentSdk = androidDeviceInfo.version.sdkInt ?? 0;
      debugPrint("currentSdk : $currentSdk");
      update();
    }
  }
}
