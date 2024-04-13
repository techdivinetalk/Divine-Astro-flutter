import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/common/important_number_bottomsheet.dart';

import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/routes.dart';
import '../../di/shared_preference_service.dart';

import '../../repository/important_number_repository.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    notificationPermission();
    // requestPermissions();
    // checkImportantNumbers();
    // navigation();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }

  notificationPermission() async {
    print("splash screen");
    await recurringFunction(onComplete: navigation);
  }

  Future<void> recurringFunction({required void Function() onComplete}) async {
    bool hasAllPerm = false;
    await AppPermissionService.instance.hasRequiredPermForSplash(
      () async {
        hasAllPerm = true;
      },
    );
    hasAllPerm ? onComplete() : await recurringFunction(onComplete: onComplete);
    return Future<void>.value();
  }

  List isAllDone = [];
  double progessValue = 0.0;
  List<ImportantNumber> importantNumbers = [];

  Future<void> checkImportantNumbers() async {
    final response = await ImportantNumberRepo().fetchData();
    bool isPermission = await requestPermissions();
    if (response.data != null) {
      if (isPermission) {
        importantNumbers = parseImportantNumbers(jsonEncode(response));
        for (final importantNumber in importantNumbers) {
          for (int i = 0; i < importantNumber.mobileNumbers!.length; i++) {
            bool numberSaved = await isNumberSaved(
                importantNumber.mobileNumbers![i].replaceAll("+91-", ""));
            print(
                "Number ${importantNumber.mobileNumbers![i]} -- is saved ${numberSaved}");
            importantNumber.isSave = numberSaved;
            if (numberSaved) {
              progessValue = (i + 1) / importantNumber.mobileNumbers!.length;
            } else {
              progessValue = (i - 1) / importantNumber.mobileNumbers!.length;
            }
            update();
          }
        }
        for (int i = 0; i < importantNumbers.length; i++) {
          if (!importantNumbers[i].isSave!) {
            Get.bottomSheet(
                    importantNumberBottomSheet(Get.context!,
                        importantNumbers: importantNumbers,
                        isAllDone: isAllDone),
                    isDismissible: false,
                    enableDrag: false)
                .then((value) {
              if (value == 3) {
                navigation();
              }
            });
            break;
          } else {
            isAllDone.add(importantNumbers[i].title);
            update();
          }
        }
        if (isAllDone.length == 3) {
          navigation();
        }
        print(isAllDone.length);
        print("isAllDone.length");
      } else {
        openAppSettings();
      }
    }
  }

  List<ImportantNumber> parseImportantNumbers(String responseBody) {
    final parsed = json.decode(responseBody);
    return parsed["data"]
        .map<ImportantNumber>((json) => ImportantNumber.fromJson(json))
        .toList();
  }

  Future<bool> isNumberSaved(String phoneNumber) async {
    String normalizedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Request permissions if not already granted

    // Fetch all contacts
    Iterable<Contact> contacts =
        await ContactsService.getContacts(withThumbnails: false);

    // Check if any contact contains the phone number
    for (final contact in contacts) {
      for (final item in contact.phones!) {
        String normalizedContactNumber =
            item.value!.replaceAll(RegExp(r'\D'), '');
        if (normalizedContactNumber.contains(normalizedPhoneNumber)) {
          return true;
        }
      }
    }

    // Number not found in any contact
    return false;
  }

  final repository = Get.put(UserRepository());

  navigation() async {
    if (preferenceService.getUserDetail() == null ||
        preferenceService.getToken() == null ||
        preferenceService.getToken() == "") {
      Get.offAllNamed(RouteName.login);
      // await getInitialLoginImages().then(
      //   (value) async => await preferenceService
      //       .saveLoginImages(jsonEncode(value.toJson()))
      //       .then((value) => Get.offAllNamed(RouteName.login)),
      // );
    } else {
      // final socket = AppSocket();
      //  final appFirebaseService = AppFirebaseService();
      //  socket.socketConnect();
      //  debugPrint('preferenceService.getUserDetail()!.id ${preferenceService.getUserDetail()!.id}');
      // appFirebaseService.readData('astrologer/${preferenceService.getUserDetail()!.id}/realTime');
      Future.delayed(
        const Duration(seconds: 1),
        () => Get.offAllNamed(RouteName.dashboard),
      );
    }
  }

  Future<LoginImages> getInitialLoginImages() async {
    final response = await repository.getInitialLoginImages();
    return response;
  }

  requestPermissions() async {
    var status = await Permission.contacts.status;
    bool isGranted = false;
    if (!status.isGranted) {
      await Permission.contacts.request().then((value) {
        print("is granted contact permission ? ==> ${isGranted}");
      });
    } else {}
    return Permission.contacts.isGranted;
  }
}

class ImportantNumber {
  final int? id;
  final String? type;
  final String? title;
  bool? isSave;
  final List<String>? mobileNumbers;

  ImportantNumber(
      {this.id, this.type, this.title, this.isSave, this.mobileNumbers});

  factory ImportantNumber.fromJson(Map<String, dynamic> json) {
    List<String> numbers = json['mobile_number'].split(',');
    return ImportantNumber(
      id: json['id'] ?? "",
      type: json['type'] ?? "",
      isSave: json['isSave'] ?? false,
      title: json['title'] ?? "",
      mobileNumbers: numbers,
    );
  }
}
