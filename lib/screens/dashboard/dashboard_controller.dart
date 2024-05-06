import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/constant_model_class.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:divine_astrologer/utils/force_update_sheet.dart';
import 'package:divine_astrologer/zego_call/zego_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/app_exception.dart';
import '../../common/app_textstyle.dart';
import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../di/fcm_notification.dart';
import '../../model/res_login.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  final PreDefineRepository repository;

  DashboardController(this.repository);

  RxInt selectedIndex = 0.obs;
  RxString userProfileImage = "".obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  UserData? userData;
  final appFirebaseService = AppFirebaseService();
  BroadcastReceiver broadcastReceiver =
      BroadcastReceiver(names: <String>["AcceptChat", "ReJoinChat"]);

  // StreamSubscription<DatabaseEvent>? realTimeListener;
  // StreamSubscription<DatabaseEvent>? astroChatListener;
  // Socket? socket;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check permissions when app is resumed
     // checkPermissions();
    }
  }

  void checkPermissions() async {
    if (await Permission.camera.isDenied ||
        await Permission.microphone.isDenied) {
      Get.bottomSheet(
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  "Permission Missing",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Allow permission to take audio and video calls smoothly",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  requestPermissions();
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appColors.guideColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    "Grant Permission",
                    style: AppTextStyle.textStyle20(
                      fontColor: appColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    }
  }

  void requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
    Get.back(); // Close the bottom sheet after requesting permissions
    await FlutterOverlayWindow
        .requestPermission();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
   // checkPermissions();
    print("microphone ${await FlutterOverlayWindow.isPermissionGranted()}");
    print("beforeGoing 2 - ${preferenceService.getUserDetail()?.id}");
    broadcastReceiver.start();
    broadcastReceiver.messages.listen((event) {
      print("broadCastResponse");
      print(AppFirebaseService().openChatUserId != "");
      print(event.data!["orderData"]);
      if (event.name == "ReJoinChat" &&
          AppFirebaseService().openChatUserId != "" &&
          event.data != null &&
          event.data!["orderData"]["status"] != null) {
        var orderData = event.data!["orderData"];
        Get.toNamed(RouteName.chatMessageWithSocketUI, arguments: orderData);
      }
    });
    if (!isLogOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 5), () {
          print("is logged in");
          appFirebaseService.readData(
              'astrologer/${preferenceService.getUserDetail()!.id}/realTime');
        });
        //appFirebaseService.masterData('masters');
      });
    } else {
      print("is logged out");
    }
    var commonConstants = await userRepository.constantDetailsData();
    preferenceService.setConstantDetails(commonConstants);
    preferenceService
        .setBaseImageURL(commonConstants.data!.awsCredentails.baseurl!);

    //added by: dev-dharam
    Get.find<SharedPreferenceService>()
        .setAmazonUrl(commonConstants.data!.awsCredentails.baseurl!);
    //
    String? baseAmazonUrl = preferenceService.getBaseImageURL();
    userData = preferenceService.getUserDetail();
    userImage(
        userData?.image != null ? "$baseAmazonUrl/${userData?.image}" : "");
    print(userData?.image);
    print(userProfileImage.value);
    print("userProfileImage.value");
    loadPreDefineData();
    firebaseMessagingConfig(Get.context!);
    getConstantDetailsData();
  }

  @override
  void onReady() {
    final socket = AppSocket();
    socket.socketConnect();

    super.onReady();
  }

  getConstantDetailsData() async {
    try {
      final data = await userRepository.constantDetailsData();
      if (data.data != null) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        print(data.data!.appVersion!.split(".").join(""));
        print(packageInfo.version.split(".").join(""));
        print('packageInfo.version!.split(".").join("")');
        if (int.parse(data.data!.appVersion!.split(".").join("")) >
            int.parse(packageInfo.version.split(".").join(""))) {
          print("objectobjectobjectobject");
          Get.bottomSheet(
            const ForceUpdateSheet(),
            isDismissible: false,
          );
        }
      }

      update();
    } catch (error) {
      debugPrint("error::::: $error");
      if (error is AppException) {
        error.onException();
      } else {
        divineSnackBar(data: error.toString(), color: appColors.red);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadPreDefineData() async {
    SpecialityList response = await repository.loadPreDefineData();
    await preferenceService.setSpecialAbility(response.toPrettyJson());
  }

  void askPermission() async {
    await [Permission.camera, Permission.microphone, Permission.contacts]
        .request();

    PermissionStatus? permissionStatus;
    if (permissionStatus == PermissionStatus.granted) {
      await checkContacts();
    }
    while (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await _getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
          await openAppSettings();
        } else {}
      } catch (e) {
        await openAppSettings();
      }
    }
  }

  checkContacts() async {
    var allContacts = await ContactsService.getContacts();
    var isContactExists = allContacts.any((element) {
      if (element.phones != null) {
        return element.phones!
            .any((element) => element.value!.contains("+91 9876543210"));
      } else {
        return false;
      }
    });
    if (!isContactExists) {
      Get.toNamed(RouteName.importantNumbers);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }
}
