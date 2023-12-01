import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../common/common_functions.dart';
import '../common/routes.dart';
import '../screens/live_page/constant.dart';

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
      debugPrint("Notification received : 1");
      checkNotification(isFromNotification: true);
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
    debugPrint('notification payload: $payload');
  }
  if (Get.currentRoute == RouteName.chatMessageUI) {
  } else {
    await Get.toNamed(RouteName.chatMessageUI,
        arguments: astroChatWatcher.value);
  }
}

Future<void> showNotificationWithActions(
    {required String title, required String message}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "DivineAstrologer",
    "AstrologerNotification",
    importance: Importance.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      math.Random().nextInt(10000), title, message, notificationDetails);
}
