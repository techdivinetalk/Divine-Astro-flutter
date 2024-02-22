import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:divine_astrologer/common/accept_chat_request_screen.dart';
import 'package:divine_astrologer/common/routes.dart';
import "package:divine_astrologer/di/hive_services.dart";
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/screens/live_page/constant.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../common/common_functions.dart';
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

Future<void> firebaseMessagingConfig(BuildContext buildContext) async {
  contextDetail = buildContext;
  initMessaging();
  final firebaseMessaging = FirebaseMessaging.instance;

  await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);

  firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // //Terminated Notification Configuration
  // FirebaseMessaging.instance.getInitialMessage().then((message) {
  //   showNotificationWithActions(message: "Get", title: "Notification");
  // });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      debugPrint(
          "onMessage Notification received : ${message.notification?.title}");
      showNotificationWithActions(
          title: message.notification!.title ?? '',
          message: message.notification!.body ?? '');
      //  checkNotification(isFromNotification: true);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint('Got a message whilst in the foreground!');
    if (message.notification != null) {
      debugPrint("Notification received : 2");
      checkNotification(isFromNotification: true);
    }
  });

  FirebaseMessaging.onBackgroundMessage((message) async {
    debugPrint("Notification received : 3");
    return checkNotification(isFromNotification: true);
  });
  // ignore: unused_element
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (message.notification != null) {
      debugPrint("Notification received : 4");
      checkNotification(isFromNotification: true);
    }
  }
}

void initMessaging() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
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
  if (notificationResponse.payload != null) {
    ///// redirect to bottom sheet of accept the request
    final Map<String, dynamic> payloadMap =
        jsonDecode(notificationResponse.payload!);
    debugPrint('notification payload: -- ${payloadMap}');
    //  debugPrint('notification payload: ${payloadMap["type"] == "2"}');
    // // if(payloadMap["type"] == "2") {
    print("payload map type ${payloadMap}");
    if (payloadMap["type"] == "3") {
      Get.toNamed(RouteName.chatMessageSupportUI,
          arguments: DataList(
            id: int.parse( payloadMap["sender_id"],),
            name: payloadMap["title"],
          ));
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

Future<void> chatInit(String requestId) async {
  try {
    final userDetail = preferenceService.getUserDetail();
    if (userDetail != null) {
      final notificationPath = 'user/$requestId/realTime/notification';
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final notificationData = {
        '$timestamp': {
          'isActive': 1,
          'message': '${userDetail.name} wants to chat with you',
          'value': 'Click to chat',
          'requestId': userDetail.id
        },
      };

      final appFirebaseService = AppFirebaseService();
      await appFirebaseService.writeData(notificationPath, notificationData);
      debugPrint('Notification data written to the database');
    } else {
      debugPrint('Error: User details not available');
    }
  } catch (e) {
    debugPrint('Error writing notification data to the database: $e');
  }
}

Future<void> showNotificationWithActions(
    {required String title,
    required String message,
    dynamic payload,
    HiveServices? hiveServices}) async {
  debugPrint("enter in showNotificationWithActions --> $payload");
  String? jsonEncodePayload;
  if (payload != null) {
    jsonEncodePayload = jsonEncode(payload);
    if (payload["type"] == 2) {
      final Map<String, dynamic> chatListMap = jsonDecode(payload["chatList"]);
      final ChatMessage chatMessage = ChatMessage.fromOfflineJson(chatListMap);
      final String tableName = "chat_${chatMessage.senderId}";

      final databaseMessage = ChatMessagesOffline().obs;
      final res = await hiveServices?.getData(key: tableName);
      var msg = ChatMessagesOffline.fromOfflineJson(jsonDecode(res));
      var chatMessages = msg.chatMessages ?? [];
      chatMessages.add(chatMessage);
      databaseMessage.value.chatMessages = chatMessages;
      log('data message ${databaseMessage.value.toOfflineJson()}');
      await hiveServices?.addData(
          key: tableName,
          data: jsonEncode(databaseMessage.value.toOfflineJson()));
      final newRes = await hiveServices?.getData(key: tableName);
      log("this is my tableName $tableName");
      log("enter in if condition $newRes");
    }
  }

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "DivineAstrologer",
    "AstrologerNotification",
    importance: Importance.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      math.Random().nextInt(10000), title, message, notificationDetails,
      payload: jsonEncodePayload);
}
