import 'dart:async';

import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/shared_preference_service.dart';
import 'package:divine_astrologer/model/speciality_list.dart';
import 'package:divine_astrologer/repository/pre_defind_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common_functions.dart';
import '../../di/fcm_notification.dart';
import '../../model/chat/res_astro_chat_listener.dart';
import '../../model/res_login.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PreDefineRepository repository;

  DashboardController(this.repository);

  RxInt selectedIndex = 0.obs;
  RxString userProfileImage = " ".obs;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  UserData? userData;
  StreamSubscription<DatabaseEvent>? realTimeListener;
  StreamSubscription<DatabaseEvent>? astroChatListener;

  @override
  void onInit() async {
    super.onInit();
    askPermission();
    var commonConstants = await userRepository.constantDetailsData();

    userData = preferenceService.getUserDetail();
    preferenceService
        .setBaseImageURL(commonConstants.data.awsCredentails.baseurl!);

    userProfileImage.value =
        "${preferenceService.getBaseImageURL()}/${userData?.image}";

    loadPreDefineData();
    firebaseMessagingConfig(Get.context!);
  }

  @override
  void onReady() {
    super.onReady();
    userData = preferenceService.getUserDetail();
    realTimeListener ??= FirebaseDatabase.instance
        .ref("astrologer/${userData?.id}/realTime/notification")
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value is Map) {
        final data = event.snapshot.value as Map;
        debugPrint("RealTime Lister value : $data");
        // walletBalance.value = data["walletBalance"] as int;
        if (data["notification"] != null) {
          checkNotification(
              isFromNotification: false, updatedData: data["notification"]);
        }
      }
    });
    astroChatListener ??= FirebaseDatabase.instance
        .ref("astroChat")
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value is Map) {
        for (final dataSnapShot in event.snapshot.children) {
          if (int.tryParse(dataSnapShot.key!) == userData!.id &&
              dataSnapShot.value != null) {
            DataSnapshot innerChild = dataSnapShot.children.first;

            final value = innerChild.value as Map;
            if (value['status'] == 1) {
              var astroChat = ResAstroChatListener(
                astroId: value['astroId'],
                astroImage: value['astroImage'],
                astroName: value['astroName'],
                chatMessage: value['chat_message'],
                customeName: value['custome_name'],
                customerImage: value['customer_image'],
                extraTalktime: value['extra_talktime'],
                isRechargeContinue: value['is_recharge_continue'],
                isTimeout: value['is_timeout'],
                ivrTime: value['ivr_time'],
                notification: value['notification'],
                orderId: value['orderId'],
                orderType: value['orderType'],
                queueId: value['queue_id'],
                status: value['status'],
              );
              debugPrint("Updated chat -- $astroChat");
              Get.toNamed(RouteName.videoCallPage, arguments: astroChat);
            }

            return;
          }
        }
      } else {}
    });
  }

  @override
  void onClose() {
    super.onClose();
    if (realTimeListener != null) {
      realTimeListener!.cancel();
    }
  }

  void loadPreDefineData() async {
    await Future.delayed(const Duration(milliseconds: 100));
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
          // await openAppSettings();
        } else {}
      } catch (e) {
        // await openAppSettings();
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

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: 'PERMISSION_DISABLED',
          message: 'Location data is not available on device',
          details: null);
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
