import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/common/important_number_bottomsheet.dart';
import 'package:divine_astrologer/screens/live_dharam/perm/app_permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/common_functions.dart';
import '../../common/routes.dart';
import '../../di/shared_preference_service.dart';
import '../../firebase_service/firebase_service.dart';
import '../../pages/home/home_controller.dart';
import '../../repository/important_number_repository.dart';
import '../live_page/constant.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();

  @override
  void onInit() {
    super.onInit();
    // maintenanceCheck();
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

  bool wherego = false;
  navigation() async {
    log("jsonEncode(preferenceService.getUserDetail())");
    log("jsonEncode(preferenceService.getUserDetail())");
    log("jsonEncode(preferenceService.getUserDetail())");
    log("jsonEncode(preferenceService.getUserDetail())");
    log("jsonEncode(preferenceService.getUserDetail())");

    log(jsonEncode(preferenceService.getUserDetail()));
    log("jsonEncode(preferenceService.getUserDetail())");
    if (preferenceService.getUserDetail() == null) {
      Get.offAllNamed(RouteName.login);
    } else {
      print("goining in else part");
      // if (wherego == true) {

      // } else {}
      fetchconstantsApi();
    }
  }

  fetchconstantsApi() async {
    print("------comes to hit constants api");
    try {
      var commonConstants = await userRepository.constantDetailsData();
      print("------hit constants api");
      if (commonConstants.success == true || commonConstants.data != null) {
        print("------get Data From constants api");

        if (verifyOnboarding.toString() == "0") {
          handleNavigate(commonConstants);
        } else {
          Future.delayed(
            const Duration(seconds: 1),
            () => Get.offAllNamed(RouteName.dashboard),
          );
        }
        update();
      } else {
        print("------Not get Data From constants api");
      }
    } catch (e) {
      debugPrint("------Throw error in the constants api" + e.toString());
    }
  }

  handleNavigate(commonConstants) {
    print("onboarding stated------");

    if (commonConstants.data.is_onboarding_in_process.toString() == "0" ||
        commonConstants.data.is_onboarding_in_process.toString() == "1") {
      print("--------on------");
      isNextPage.value = commonConstants.data.stage_no;

      Get.put(HomeController()).showPopup = false;
      onBoardingList = [1, 2, 3, 4, 5];
      isOnPage.value = 1;
      disableButton.value = false;

      // showORHide.value = 1;
      Get.toNamed(
        RouteName.onBoardingScreen,
      );
    } else if (commonConstants.data.is_onboarding_in_process.toString() ==
        "2") {
      Get.put(HomeController()).showPopup = false;
      if (commonConstants.data.onboarding_reject_stage_no.isNotEmpty) {
        disableButton.value = false;
        isRejected.value = true;

        onBoardingList = commonConstants.data.onboarding_reject_stage_no;

        if (onBoardingList.first == 1) {
          // onBoardingList
          //     .remove(commonConstants.data.onboarding_reject_stage_no.first);
          isOnPage.value = 1;

          Get.toNamed(
            RouteName.onBoardingScreen,
          );
        } else if (onBoardingList.first == 2) {
          // onBoardingList
          //     .remove(commonConstants.data.onboarding_reject_stage_no.first);
          isOnPage.value = 2;

          Get.toNamed(
            RouteName.onBoardingScreen2,
          );
        } else if (onBoardingList.first == 3) {
          // onBoardingList
          //     .remove(commonConstants.data.onboarding_reject_stage_no.first);
          isOnPage.value = 3;

          Get.toNamed(
            RouteName.onBoardingScreen3,
          );
        } else if (onBoardingList.first == 4) {
          // onBoardingList
          //     .remove(commonConstants.data.onboarding_reject_stage_no.first);
          isOnPage.value = 4;

          Get.toNamed(
            RouteName.onBoardingScreen4,
          );
        } else if (onBoardingList.first == 5) {
          // onBoardingList
          //     .remove(commonConstants.data.onboarding_reject_stage_no.first);
          isOnPage.value = 5;

          Get.toNamed(
            RouteName.onBoardingScreen5,
          );
        }
      } else {
        disableButton.value = false;

        if (commonConstants.data.stage_no.toString() == "0") {
          onBoardingList = [1, 2, 3, 4, 5];
          isOnPage.value = 1;

          Get.toNamed(
            RouteName.onBoardingScreen,
          );
        } else if (commonConstants.data.stage_no.toString() == "1") {
          onBoardingList = [2, 3, 4, 5];
          isOnPage.value = 2;

          Get.toNamed(
            RouteName.onBoardingScreen2,
          );
        } else if (commonConstants.data.stage_no.toString() == "2") {
          onBoardingList = [3, 4, 5];
          isOnPage.value = 3;

          Get.toNamed(
            RouteName.onBoardingScreen3,
          );
        } else if (commonConstants.data.stage_no.toString() == "3") {
          onBoardingList = [4, 5];
          isOnPage.value = 4;

          Get.toNamed(
            RouteName.onBoardingScreen4,
          );
        } else if (commonConstants.data.stage_no.toString() == "4") {
          onBoardingList = [5];
          isOnPage.value = 5;

          Get.toNamed(
            RouteName.onBoardingScreen5,
          );
        } else if (commonConstants.data.stage_no.toString() == "5") {
          // onBoardingList = [6];
          // isOnPage.value = 5;

          Get.toNamed(
            RouteName.addEcomAutomation,
          );
        } else if (commonConstants.data.stage_no.toString() == "6") {
          // onBoardingList = [6];
          // isOnPage.value = 5;

          Get.toNamed(
            RouteName.scheduleTraining1,
          );
        } else if (commonConstants.data.stage_no.toString() == "7") {
          // onBoardingList = [5];
          // isOnPage.value = 5;

          Get.toNamed(RouteName.scheduleTraining2, arguments: "sheduled");
        } else if (commonConstants.data.stage_no.toString() == "8") {
          // onBoardingList = [5];
          // isOnPage.value = 5;

          Get.toNamed(RouteName.scheduleTraining2, arguments: "sheduled");
        }
      }
    } else if (commonConstants.data.is_onboarding_in_process.toString() ==
        "3") {
      disableButton.value = true;
      if (commonConstants.data.stage_no.toString() == "4") {
        onBoardingList = [5];
        isOnPage.value = 5;

        Get.toNamed(
          RouteName.onBoardingScreen5,
        );
      } else if (commonConstants.data.stage_no.toString() == "5") {
        // onBoardingList = [6];
        // isOnPage.value = 5;

        Get.toNamed(
          RouteName.addEcomAutomation,
        );
      } else if (commonConstants.data.stage_no.toString() == "6") {
        // onBoardingList = [6];
        // isOnPage.value = 5;

        Get.toNamed(
          RouteName.scheduleTraining1,
        );
      } else if (commonConstants.data.stage_no.toString() == "7") {
        // onBoardingList = [5];
        // isOnPage.value = 5;

        Get.toNamed(RouteName.scheduleTraining2, arguments: "sheduled");
      } else if (commonConstants.data.stage_no.toString() == "8") {
        // onBoardingList = [5];
        // isOnPage.value = 5;

        Get.toNamed(RouteName.scheduleTraining2, arguments: "sheduled");
      }
    } else if (commonConstants.data.is_onboarding_in_process.toString() ==
        "4") {
      Get.offNamed(
        RouteName.dashboard,
      );
    }
  }
  // Future<LoginImages> getInitialLoginImages() async {
  //   final response = await repository.getInitialLoginImages();
  //   return response;
  // }

  requestPermissions() async {
    var status = await Permission.contacts.status;
    bool isGranted = false;
    if (!status.isGranted) {
      await Permission.contacts.request().then((value) {
        print("is granted contact permission ? ==> $isGranted");
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
