import "dart:convert";

import "package:divine_astrologer/common/accept_chat_request_screen.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/di/fcm_notification.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/screens/side_menu/settings/settings_controller.dart";
import "package:divine_astrologer/watcher/real_time_watcher.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:get/get.dart";

import "../screens/live_page/constant.dart";

class AppFirebaseService {
  AppFirebaseService._privateConstructor();

  static final AppFirebaseService _instance = AppFirebaseService._privateConstructor();

  factory AppFirebaseService() {
    return _instance;
  }

  var watcher = RealTimeWatcher();
  var acceptBottomWatcher = RealTimeWatcher();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> writeData(String path, Map<String, dynamic> data) async {
    try {
      await _database.child(path).update(data);
    } catch (e) {
      debugPrint("Error writing data to the database: $e");
    }
  }

  readData(String path) async {
    try {
      _database.child(path).onValue.listen((event) async {
        debugPrint("real time $path ---> ${event.snapshot.value}");
        if (preferenceService.getToken() == null || preferenceService.getToken() == "") {
          return;
        }
        if (event.snapshot.value is Map<Object?, Object?>) {
          Map<String, dynamic>? realTimeData =
              Map<String, dynamic>.from(event.snapshot.value! as Map<Object?, Object?>);

          if (realTimeData['callKundli'] != null) {
            Map<String, dynamic>? callKundli =
            Map<String, dynamic>.from(realTimeData['callKundli'] as Map<Object?, Object?>);
            sendBroadcast(
                BroadcastMessage(name: "callKundli", data: callKundli));
          }

          if (realTimeData["notification"] != null) {
            realTimeData["notification"].forEach((key, notificationData) {
              debugPrint("local notification $notificationData");
              if (notificationData != null) {
                showNotificationWithActions(
                    title: notificationData["value"] ?? "",
                    message: notificationData["message"] ?? "",
                    payload: notificationData);
              }
            });
            FirebaseDatabase.instance.ref("$path/notification").remove();
          }

          if (realTimeData["uniqueId"] != null) {
            String uniqueId = await getDeviceId() ?? "";
            debugPrint('check uniqueId ${realTimeData['uniqueId']}\ngetDeviceId ${uniqueId.toString()}');
            if (realTimeData["uniqueId"] != uniqueId) {
              Get.put(SettingsController()).logOut();
            }
          }
          if (realTimeData["order_id"] != null) {
            watcher.strValue = realTimeData["order_id"].toString();
          }
        }
      });
    } catch (e) {
      debugPrint("Error reading data from the database: $e");
    }

    watcher.nameStream.listen((value) {
      if (value != "") {
        _database.child("order/$value").onValue.listen((event) {
          if (event.snapshot.value != null) {
            Map<String, dynamic>? orderData =
                Map<String, dynamic>.from(event.snapshot.value! as Map<Object?, Object?>);
            debugPrint("orderData-------> $orderData");
            if (orderData["status"] != null) {
              if (orderData["status"] == "0") {
                sendBroadcast(
                    BroadcastMessage(name: "AcceptChat", data: {"orderId": value, "orderData": orderData}));
                acceptChatRequestBottomSheet(Get.context!, onPressed: () async {
                  if (await acceptOrRejectChat(
                      orderId: int.parse(value.toString()), queueId: orderData["queue_id"])) {
                    acceptBottomWatcher.strValue = "1";
                    writeData("order/$value", {"status": "1"});
                  }
                },
                    orderStatus: orderData["status"],
                    customerName: orderData["customerName"].toString(),
                    dob: orderData["dob"].toString(),
                    placeOfBirth: orderData["placeOfBirth"].toString(),
                    timeOfBirth: orderData["timeOfBirth"].toString(),
                    maritalStatus: orderData["maritalStatus"].toString(),
                    walletBalance: orderData["walletBalance"].toString(),
                    problemArea: orderData["problemArea"].toString());
              } else if (orderData["status"] == "1") {
                if (acceptBottomWatcher.currentName != "1") {
                  acceptBottomWatcher.strValue = "1";
                  acceptChatRequestBottomSheet(Get.context!,
                      onPressed: () {},
                      orderStatus: orderData["status"],
                      customerName: orderData["customerName"].toString(),
                      dob: orderData["dob"].toString(),
                      walletBalance: orderData["walletBalance"].toString(),
                      placeOfBirth: orderData["placeOfBirth"].toString(),
                      timeOfBirth: orderData["timeOfBirth"].toString(),
                      maritalStatus: orderData["maritalStatus"].toString(),
                      problemArea: orderData["problemArea"].toString());
                }
              } else if (orderData["status"] == "3") {
                sendBroadcast(
                    BroadcastMessage(name: "ReJoinChat", data: {"orderId": value, "orderData": orderData}));
                Get.toNamed(RouteName.chatMessageWithSocketUI, arguments: {"orderData": orderData});
              }
            }
          } else {
            preferenceService.remove(SharedPreferenceService.talkTime);
            debugPrint("remove method called");
            sendBroadcast(BroadcastMessage(name: "EndChat"));
          }
        });
      }

      debugPrint("value changed to: $value");
    });
  }
}
