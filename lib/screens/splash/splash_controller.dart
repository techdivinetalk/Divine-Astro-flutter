import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

import '../../common/colors.dart';
import '../../common/common_functions.dart';
import '../../common/permission_handler.dart';
import '../../common/routes.dart';
import '../../di/shared_preference_service.dart';
import '../../model/important_numbers.dart';
import '../../repository/important_number_repository.dart';

class SplashController extends GetxController {
  SharedPreferenceService preferenceService =
      Get.find<SharedPreferenceService>();
  List<MobileNumber> importantNumbers = <MobileNumber>[];
  @override
  Future<void> onInit() async {
    super.onInit();
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    notificationPermission();
   // fetchImportantNumbers();
    navigation();
  }
  notificationPermission() async {
    await PermissionHelper().askNotificationPermission();
  }

  fetchImportantNumbers() async {
    try {
      // Fetch important numbers from the repository
      final response = await ImportantNumberRepo().fetchData();
      if (response.data != null) {
        importantNumbers = response.data!;
      }
      print("isAllNumbersExist entering number state");
      // Create a map of all contacts (this should be done once and can be reused)
      List<Contact> allContacts = getAllContacts() as List<Contact>; // You need to define this method to fetch all contacts
      Map<String, Set<String>> contactsMap = createContactsMap(allContacts);

      // Check if all important numbers exist using the contacts map
      bool isAllNumbersExist = checkForALlContact(importantNumbers, contactsMap);
      print("isAllNumbersExist ${isAllNumbersExist}");
      // Show the bottom sheet with important numbers
   //   importantNumberBottomsheet();
    } catch (error) {
      // Show an error message if something goes wrong
      divineSnackBar(data: error.toString(), color: AppColors.redColor);
    }
  }

  Future<List<Contact>> getAllContacts() async {
    // Request permissions (if not already granted)
    if (await Permission.contacts.request().isGranted) {
      // Fetch all contacts
      List<Contact> contacts = await ContactsService.getContacts();
      return contacts;
    } else {
      // Handle the scenario when permission is not granted
      // You might want to throw an exception or return an empty list
      return [];
    }
  }
    bool checkForALlContact(List<MobileNumber> importantNumbers, Map<String, Set<String>> contactsMap) {
      for (MobileNumber number in importantNumbers) {
        if (!checkForContactExist(number, contactsMap)) {
          return false;
        }
      }
      return true;
    }

    Map<String, Set<String>> createContactsMap(List<Contact> allContacts) {
    Map<String, Set<String>> contactsMap = {};

    for (Contact contact in allContacts) {
      if (contact.phones != null) {
        for (var phone in contact.phones!) {
          String name = contact.displayName ?? "";
          if (!contactsMap.containsKey(name)) {
            contactsMap[name] = {};
          }
          contactsMap[name]!.add(phone.value ?? "");
        }
      }
    }

    return contactsMap;
  }

  bool checkForContactExist(MobileNumber number, Map<String, Set<String>> contactsMap) {
    String name = number.title ?? "";
    String phoneNumber = number.mobileNumber ?? "";

    if (!contactsMap.containsKey(name)) {
      return false;
    }

    return contactsMap[name]!.contains(phoneNumber);
  }

  final repository = Get.put(UserRepository());

  void navigation() async {
    if (preferenceService.getToken() == null ||
        preferenceService.getToken() == "") {
      await getInitialLoginImages().then(
        (value) async => await preferenceService
            .saveLoginImages(jsonEncode(value.toJson()))
            .then((value) => Get.offAllNamed(RouteName.login)),
      );
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
}
