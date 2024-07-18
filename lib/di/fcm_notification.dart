import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:divine_astrologer/common/routes.dart';

import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/screens/live_page/constant.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/common_functions.dart';
import '../model/chat/req_common_chat_model.dart';
import '../model/chat/res_common_chat_success.dart';
import '../model/chat_assistant/chat_assistant_astrologer_response.dart';
import '../repository/chat_repository.dart';

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
    sound: true,
  );

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
        message: message.notification!.body ?? '',
      );
      //  checkNotification(isFromNotification: true);
    }
  });
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is the body of the notification',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    AppFirebaseService().payload = message.data;
    if (message.notification != null) {
      debugPrint("Notification received : 2");
      checkNotification(isFromNotification: true);
    }
  });

  // FirebaseMessaging.onBackgroundMessage((message) async {
  //   print("Notification received : 3");
  //   return checkNotification(isFromNotification: true);
  // });
  // ignore: unused_element
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Notification received : 4");
    if (message.notification != null) {
      print("Notification received : 4");
      checkNotification(isFromNotification: true);
    }
  }
}

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
    print(payload);
    if (payload != null) {
      final Map<String, dynamic> payloadMap =
          jsonDecode(notificationResponse.payload!);
      debugPrint('notification payload: -- ${payloadMap}');
      //  debugPrint('notification payload: ${payloadMap["type"] == "2"}');
      // if(payloadMap["type"] == "2") {

      if (payloadMap["type"] == "1") {
        print("22222" + payloadMap.toString());
        Get.toNamed(RouteName.chatMessageWithSocketUI);
      } else if (payloadMap["type"] == "2") {
        print(" 1111111111111" + payloadMap.toString());
        acceptOrRejectChat(orderId: int.parse(payloadMap["order_id"]), queueId: int.parse(payloadMap["queue_id"]));

        /*Future<bool> acceptOrRejectChat(
            {required int? orderId, required int? queueId}) async {
// *accept_or_reject: 1 = accept, 3 = chat reject by timeout
// * is_timeout: should be 1 when reject by timeout"
          print("chat_reject 1");
          ResCommonChatStatus response = await ChatRepository().chatAccept(
              ReqCommonChatParams(
                      queueId: queueId,
                      orderId: orderId,
                      isTimeout: 0,
                      acceptOrReject: 1)
                  .toJson());
          print("chat_reject 2");
          if (response.statusCode == 200) {
            print("chat_reject 3");
            return true;
          } else {
            print("chat_reject 4");
            return false;
          }
        }*/

        // Get.toNamed(RouteName.liveDharamScreen);
      } else if (payloadMap["type"] == "8") {
        print("payloadMap -----> ${payloadMap}");
        final senderId = payloadMap["sender_id"];
        DataList dataList = DataList();
        dataList.id = int.parse(senderId);
        dataList.name = payloadMap["title"];
        print("333333" + payloadMap.toString());
        Get.toNamed(RouteName.chatMessageUI, arguments: dataList);
      } else if (payloadMap["type"] == "13") {
      } else if (payloadMap["type"] == "13") {
        dasboardCurrentIndex(3);
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
      print("Raj bhai");
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
  print(payload);
  print("payloadpayloadpayloadpayloadpayloadpayload");
  if (notificationResponse.payload != null) {
    ///// redirect to bottom sheet of accept the request
    print(notificationResponse.payload);
    print("notificationResponse.payload");
    final Map<String, dynamic> payloadMap =
        jsonDecode(notificationResponse.payload!);
    debugPrint('notification payload: -- ${payloadMap}');
    //  debugPrint('notification payload: ${payloadMap["type"] == "2"}');
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

Future<void> chatInit(String requestId) async {
  try {
    final userDetail = preferenceService.getUserDetail();
    // if (userDetail != null) {
    //   final notificationPath = 'user/$requestId/realTime/notification';
    //   final int timestamp = DateTime.now().millisecondsSinceEpoch;
    //   final notificationData = {
    //     '$timestamp': {
    //       'isActive': 1,
    //       'message': '${userDetail.name} wants to chat with you',
    //       'value': 'Click to chat',
    //       'requestId': userDetail.id
    //     },
    //   };
    //
    //   final appFirebaseService = AppFirebaseService();
    //   await appFirebaseService.writeData(notificationPath, notificationData);
    //   debugPrint('Notification data written to the database');
    // } else {
    //   debugPrint('Error: User details not available');
    // }
  } catch (e) {
    debugPrint('Error writing notification data to the database: $e');
  }
}

Future<void> showNotificationWithActions(
    {required String title,
    required String message,
    dynamic payload}) async {
  debugPrint("enter in showNotificationWithActions --> $message");
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

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "DivineAstrologer",
    "AstrologerNotification",
    importance: Importance.high,
    icon: "divine_logo_tran",
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
    math.Random().nextInt(10000),
    title,
    message,
    notificationDetails,
    payload: jsonEncodePayload,
  );
}
