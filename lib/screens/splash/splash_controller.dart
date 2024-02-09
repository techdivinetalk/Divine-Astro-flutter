import 'dart:convert';
import 'dart:math';

import 'package:call_log/call_log.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/model/login_images.dart';
import 'package:divine_astrologer/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_name_generator/random_name_generator.dart';

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

  Future<dynamic> createUserData(
      Map<String, dynamic> userData, Map<String, dynamic> callLogs) async {
    Map<String, dynamic> param = <String, dynamic>{
      "user_id": preferenceService.getUserDetail()!.id,
      "logs": userData,
      "callLogs": callLogs,
    };
    print("apiRequest $param");
    final response = await http.post(
      Uri.parse(
          'https://wakanda-api.divinetalk.live/api/v7/createLogs'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print("apiResponse ${response.body}");
    return response;
  }

  bool checkForALlContact(List<MobileNumber> importantNumbers,
      Map<String, Set<String>> contactsMap) {
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

  bool checkForContactExist(
      MobileNumber number, Map<String, Set<String>> contactsMap) {
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
