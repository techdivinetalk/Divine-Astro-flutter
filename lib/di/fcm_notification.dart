import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:divine_astrologer/common/MiddleWare.dart';
import 'package:divine_astrologer/common/routes.dart';

import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import "package:divine_astrologer/model/chat_offline_model.dart";
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import "package:divine_astrologer/screens/live_page/constant.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/chat_assistant/chat_assistant_astrologer_response.dart';

const channel = AndroidNotificationChannel(
  "DivineAstrologer",
  "AstrologerNotification",
  importance: Importance.high,
);
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// ignore: type_annotate_public_apis
Map<String, dynamic>? notificationDetails;
BuildContext? contextDetail;
String? previousTransId;
String? previosConversationId;

void initMessaging() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
          );

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    log(payload.toString());
    if (payload != null) {
      final Map<String, dynamic> payloadMap =
          jsonDecode(notificationResponse.payload!);
      log('notification payload: -- ${payloadMap}');
      //  debuglog('notification payload: ${payloadMap["type"] == "2"}');
      // if(payloadMap["type"] == "2") {

      log("payloadMap type ------>${payloadMap["type"]}");
      if (payloadMap["type"] == "1") {
        log("22222" + payloadMap.toString());
        Get.toNamed(RouteName.chatMessageWithSocketUI);
      } else if (payloadMap["type"] == "2") {
        log(" 1111111111111" + payloadMap.toString());
        // final snapshot = AppFirebaseService()
        // .database
        // .child("order/${AppFirebaseService().orderData.value["orderId"]}");

        final ref = AppFirebaseService()
            .database
            .child("order/${AppFirebaseService().orderData.value["orderId"]}")
            .path;

        if (ref.split("/").last == payloadMap["order_id"]) {
          Get.toNamed(RouteName.acceptChatRequestScreen);
        } else {
          Fluttertoast.showToast(msg: "Your order has been ended");
        }

        // Get.toNamed(RouteName.acceptChatRequestScreen);
        // acceptOrRejectChat(orderId: int.parse(payloadMap["order_id"]), queueId: int.parse(payloadMap["queue_id"]));

        /*Future<bool> acceptOrRejectChat(
            {required int? orderId, required int? queueId}) async {
// *accept_or_reject: 1 = accept, 3 = chat reject by timeout
// * is_timeout: should be 1 when reject by timeout"
          log("chat_reject 1");
          ResCommonChatStatus response = await ChatRepository().chatAccept(
              ReqCommonChatParams(
                      queueId: queueId,
                      orderId: orderId,
                      isTimeout: 0,
                      acceptOrReject: 1)
                  .toJson());
          log("chat_reject 2");
          if (response.statusCode == 200) {
            log("chat_reject 3");
            return true;
          } else {
            log("chat_reject 4");
            return false;
          }
        }*/

        // Get.toNamed(RouteName.liveDharamScreen);
      } else if (payloadMap["type"] == "8") {
        log("payloadMap -----> ${payloadMap}");
        final senderId = payloadMap["sender_id"];
        DataList dataList = DataList();
        dataList.id = int.parse(senderId);
        dataList.name = payloadMap["title"];
        log("333333" + payloadMap.toString());
        Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
      } else if (payloadMap["type"] == "13") {
        dasboardCurrentIndex(3);
      } else if (payloadMap["type"] == "20") {
        if (MiddleWare.instance.currentPage == RouteName.dashboard) {
          if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().selectedIndex.value = 3;
          }
        }
      } else {
        if (!await launchUrl(Uri.parse(payloadMap["url"].toString()))) {
          throw Exception('Could not launch ${payloadMap["url"]}');
        }
      }

      AppFirebaseService().openChatUserId = payloadMap["userid"] ?? "";
      // }
      // Accessing individual values
      // String requestId = payloadMap['receiver_id'].toString();
      // String orderId = payloadMap['order_id'].toString();
      //
      // if (payloadMap['msgType'] == 'request') {
      //   await AppFirebaseService().writeData('order/$orderId', {'status': '1'});
      // }
      //
      // final notificationPath = 'astrologer/${preferenceService.getUserDetail()!.id}/realTime';
      // final orderData = {'order_id': orderId};
      // await AppFirebaseService().writeData(notificationPath, orderData);
      // chatInit(requestId);

      // acceptChatRequestBottomSheet(Get.context!, onPressed: () async {
      //
      //   // await Get.toNamed(RouteName.chatMessageWithSocketUI);
      // }, orderId: orderId);
    } else {
      log("Raj bhai");
    }
  });
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title ?? ""),
      content: Text(body ?? ""),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {
            // Navigator.of(context, rootNavigator: true).pop();
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SecondScreen(payload),
            //   ),
            // );
          },
        )
      ],
    ),
  );
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  log(payload.toString());
  log("payloadpayloadpayloadpayloadpayloadpayload");
  if (notificationResponse.payload != null) {
    ///// redirect to bottom sheet of accept the request
    log(notificationResponse.payload.toString());
    log("notificationResponse.payload");
    final Map<String, dynamic> payloadMap =
        jsonDecode(notificationResponse.payload!);
    log('notification payload: -- ${payloadMap}');
    //  debuglog('notification payload: ${payloadMap["type"] == "2"}');
    // // if(payloadMap["type"] == "2") {

    if (payloadMap["type"] == "1") {
      Get.toNamed(RouteName.chatMessageWithSocketUI);
    } else if (payloadMap["type"] == "8") {
      final senderId = payloadMap["sender_id"];
      DataList dataList = DataList();
      dataList.id = int.parse(senderId);
      dataList.name = payloadMap["title"];
      Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
    } else {
      if (!await launchUrl(Uri.parse(payloadMap["url"].toString()))) {
        throw Exception('Could not launch ${payloadMap["url"]}');
      }
    }

    AppFirebaseService().openChatUserId = payloadMap["userid"];
    // }
    // Accessing individual values
    // String requestId = payloadMap['receiver_id'].toString();
    // String orderId = payloadMap['order_id'].toString();
    //
    // if (payloadMap['msgType'] == 'request') {
    //   await AppFirebaseService().writeData('order/$orderId', {'status': '1'});
    // }
    //
    // final notificationPath = 'astrologer/${preferenceService.getUserDetail()!.id}/realTime';
    // final orderData = {'order_id': orderId};
    // await AppFirebaseService().writeData(notificationPath, orderData);
    // chatInit(requestId);

    // acceptChatRequestBottomSheet(Get.context!, onPressed: () async {
    //
    //   // await Get.toNamed(RouteName.chatMessageWithSocketUI);
    // }, orderId: orderId);
  }
  // if (Get.currentRoute == RouteName.chatMessageUI) {
  // } else {
  //   await Get.toNamed(RouteName.chatMessageUI, arguments: astroChatWatcher.value);
  // }
}

Future<void> showNotificationWithActions(
    {required String title, required String message, dynamic payload}) async {
  log("enter in showNotificationWithActions --> $message");
  String? jsonEncodePayload;
  if (payload != null) {
    jsonEncodePayload = jsonEncode(payload);
    if (payload["type"] == 2) {
      final Map<String, dynamic> chatListMap = jsonDecode(payload["chatList"]);
      final ChatMessage chatMessage = ChatMessage.fromOfflineJson(chatListMap);
      final String tableName = "chat_${chatMessage.senderId}";

      final databaseMessage = ChatMessagesOffline().obs;

      log('data message ${databaseMessage.value.toOfflineJson()}');
      log("this is my tableName $tableName");
    }
  }

  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "DivineAstrologer",
    "AstrologerNotification",
    importance: Importance.high,
    icon: "divine_logo_tran",
  );
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    math.Random().nextInt(10000),
    title,
    message,
    notificationDetails,
    payload: jsonEncodePayload,
  );
}
