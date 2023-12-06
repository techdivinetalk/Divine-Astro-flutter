import 'dart:convert';

import 'package:divine_astrologer/common/accept_chat_request_screen.dart';
import 'package:divine_astrologer/common/common_functions.dart';
import 'package:divine_astrologer/di/fcm_notification.dart';
import 'package:divine_astrologer/screens/side_menu/settings/settings_controller.dart';
import 'package:divine_astrologer/watcher/real_time_watcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppFirebaseService {
  AppFirebaseService._privateConstructor();

  static final AppFirebaseService _instance = AppFirebaseService._privateConstructor();

  factory AppFirebaseService() {
    return _instance;
  }

  var watcher = RealTimeWatcher();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> writeData(String path, Map<String, dynamic> data) async {
    try {
      await _database.child(path).set(data);
    } catch (e) {
      debugPrint('Error writing data to the database: $e');
    }
  }

  readData(String path) async {
    try {
      _database.child(path).onValue.listen((event) async {
        debugPrint('real time $path ---> ${event.snapshot.value}');
        if (preferenceService.getToken() == null || preferenceService.getToken() == "") {
          return;
        }
        if (event.snapshot.value is Map<Object?, Object?>) {
          Map<String, dynamic>? realTimeData =
              Map<String, dynamic>.from(event.snapshot.value! as Map<Object?, Object?>);

          if (realTimeData['notification'] != null) {
            realTimeData['notification'].forEach((key, value) {
              debugPrint('local notification $value');
              _showLocalNotification(value, key);
            });
            final databaseReference = FirebaseDatabase.instance.ref('$path/notification');
            databaseReference.remove();
          }

          if (realTimeData['uniqueId'] != null) {
            String uniqueId = await getDeviceId() ?? '';
            debugPrint('check uniqueId ${realTimeData['uniqueId']}\ngetDeviceId ${uniqueId.toString()}');
            if (realTimeData['uniqueId'] != uniqueId) {
              Get.put(SettingsController()).logOut();
            }
          }
          if (realTimeData['order_id'] != null) {
            watcher.strValue = realTimeData['order_id'];
          }
        }
      });
    } catch (e) {
      debugPrint('Error reading data from the database: $e');
    }

    watcher.nameStream.listen((value) {
      if (value != '') {
        _database.child('order/$value').onValue.listen((event) {
          if (event.snapshot.value != null) {
            Map<String, dynamic>? orderData = event.snapshot.value as Map<String, dynamic>?;
            if (orderData!['status'] != null) {
              if (orderData['status'] == '1') {
                acceptChatRequestBottomSheet(Get.context!, onPressed: () {}, orderId: value.toString());
              }
            }
          }
        });
      }

      debugPrint('value changed to: $value');
    });
  }

  Future<void> _showLocalNotification(Map<dynamic, dynamic>? data, key) async {
    if (data != null) {
      Map<String, dynamic> payloadMap = {'timeStamp': key, 'requestId': data['requestId']};
      debugPrint('local notification ${data.toString()}');

      showNotificationWithActions(
          title: data['value'] ?? '', message: data['message'] ?? '', payload: jsonEncode(payloadMap));
    }
  }

  void firebaseDisconnect() {
    FirebaseDatabase.instance.goOffline();
  }

  void firebaseConnect() {
    FirebaseDatabase.instance.goOnline();
  }
}
