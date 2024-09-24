import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:divine_astrologer/common/MiddleWare.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/di/fcm_notification.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_astrologer_response.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/screens/dashboard/dashboard_controller.dart';
import 'package:divine_astrologer/screens/live_page/constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
AndroidNotificationChannel channel = const AndroidNotificationChannel(
'high_importance_channel',
'High Importance Notifications',
description: 'This channel is used for important notifications.',
showBadge: true,
importance: Importance.high,
);
class NotificationHelper {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final notifications = FlutterLocalNotificationsPlugin();
  final DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings(
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
  );
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/divine_logo_tran');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  firebaseNotificationInit() async {
    // todo: ask permission to user for notification
    notificationPermission();

    // todo: initialize of app icon set for android and few settings of notification(Android/IOS both)
    var initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS, android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        print("notificationResponse.actionId-->>${notificationResponse.actionId}");
        final String? payload = notificationResponse.payload;
        log(payload.toString());
        if (payload != null) {
          final Map<String, dynamic> payloadMap =
          jsonDecode(notificationResponse.payload!);
          log('notification payload: -- ${payloadMap}');

          if (payloadMap["type"] == "1") {

            Get.toNamed(RouteName.chatMessageWithSocketUI);
          } else if (payloadMap["type"] == "2") {

            final ref = AppFirebaseService()
                .database
                .child("order/${AppFirebaseService().orderData.value["orderId"]}")
                .path;

            if (ref.split("/").last == payloadMap["order_id"]) {
              Get.toNamed(RouteName.acceptChatRequestScreen);
            } else {
              Fluttertoast.showToast(msg: "Your order has been ended");
            }
          } else if (payloadMap["type"] == "8") {

            final senderId = payloadMap["sender_id"];
            DataList dataList = DataList();
            dataList.id = int.parse(senderId);
            dataList.name = payloadMap["title"];
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
        } else {

        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // if(m){}
    });

    firebaseMessaging.getInitialMessage().then((value) {});

    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  Future<void> showFlutterNotification(RemoteMessage message) async {
    AndroidNotificationDetails? androidNotificationDetails;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    log("check on message notification : ${message.data}------${message.data["type"]}");
    log("pushNotification1 ${message.notification?.title ?? ""}");
    // if (message.notification?.title != null) {

    // if (message.data["title"] != null && message.data["title"].isNotEmpty) {
    // }
    // }
    if (message.data["type"].toString() == "1") {
      if (MiddleWare.instance.currentPage !=
          RouteName.chatMessageWithSocketUI) {
        log("messageReceive21 ${MiddleWare.instance.currentPage}");
        showNotification(
            message.data["title"] ?? "",
            message.data["message"] ?? "",
            message.data['type'] ?? "",
            message.data);
      }
      HashMap<String, dynamic> updateData = HashMap();
      updateData[message.data["chatId"] ?? "0"] = 1;
      log('Message data-:-users ${message.data}');
      log("test_notification: Enable fullscreen incoming call notification");
      sendBroadcast(
          BroadcastMessage(name: "messageReceive", data: message.data));
    } else if (message.data["type"] == "8") {
      log("inside page for realtime notification ${message.data} ${MiddleWare.instance.currentPage}");
      if (MiddleWare.instance.currentPage == RouteName.chatMessageUI &&
          chatAssistantCurrentUserId.value.toString() ==
              message.data['sender_id'].toString()) {
        assistChatNewMsg([...assistChatNewMsg, message.data]);
        assistChatNewMsg.refresh();
        // sendBroadcast(
        //     BroadcastMessage(name: "chatAssist", data: {'msg': message.data}));
      } else {
        // assistChatUnreadMessages([...assistChatUnreadMessages, message.data]);
        if (dasboardCurrentIndex.value == 2) {
          final responseMsg = message.data;
          assistChatUnreadMessages([
            ...assistChatUnreadMessages,
            AssistChatData(
                message: responseMsg["message"],
                id: int.parse(responseMsg["chatId"].toString() ?? ''),
                customerId:
                int.parse(responseMsg["sender_id"].toString() ?? ''),
                createdAt: DateTime.parse(responseMsg["created_at"])
                    .millisecondsSinceEpoch
                    .toString(),
                isSuspicious: 0,
                suggestedRemediesId:
                int.parse(responseMsg["suggestedRemediesId"] ?? "0"),
                isPoojaProduct:
                responseMsg['is_pooja_product'].toString() == '1'
                    ? true
                    : false,
                productId: responseMsg["product_id"].toString(),
                shopId: responseMsg["shop_id"].toString(),
                sendBy: SendBy.astrologer,
                msgType: responseMsg['msg_type'] != null
                    ? msgTypeValues.map[responseMsg["msg_type"]]
                    : MsgType.text,
                seenStatus: SeenStatus.received,
                astrologerId: int.parse(responseMsg["userid"] ?? 0))
          ]);
        }
        switch (message.data['msg_type']) {
          case "0":
            showNotification(message.data["title"], message.data["message"],
                message.data['type'], message.data);
            break;
          case "1":
            showNotification(message.data["title"], 'sendNotificationImage'.tr,
                message.data['type'], message.data);
            break;
          case "2":
            showNotification(message.data["title"], 'sendNotificationRemedy'.tr,
                message.data['type'], message.data);
            break;
          case "3":
            showNotification(
                message.data["title"],
                'sendNotificationProduct'.tr,
                message.data['type'],
                message.data);
            break;
          case "8":
            showNotification(message.data["title"], 'sendNotificationGift'.tr,
                message.data['type'], message.data);
            break;
        }
      }
    } else {
      if (message.data['type'] != "2") {
        showNotification(message.data["title"], message.data["message"],
            message.data['type'], message.data);
      }
    }

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification?.title}');
    }

    if (notification != null && android != null && Platform.isAndroid) {}
  }

  Future<void> showNotification(String title, String message, String type,
      Map<String, dynamic> data) async {
    // androidNotificationDetails;

    AndroidNotificationDetails? androidNotificationDetails;
    if (type == "2") {

      androidNotificationDetails = const AndroidNotificationDetails(
        "DivineAstrologer",
        "AstrologerNotification",
        importance: Importance.max,
        priority: Priority.high,
        icon: "divine_logo_tran",
        autoCancel: true,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('accept'),
        setAsGroupSummary: true,
        styleInformation: const BigTextStyleInformation(''),
        actions: [
          AndroidNotificationAction(
            'accept',
            'CHAT NOW',
          )
        ],
      );
    } else {

      // Default notification (no custom sound)
      androidNotificationDetails = const AndroidNotificationDetails(
        "DivineAstrologer_Other_type",
        "AstrologerNotification_other_type",
        importance: Importance.max,
        priority: Priority.high,
        icon: "divine_logo_tran",
        autoCancel: true,
        playSound: true,
        setAsGroupSummary: true,
        styleInformation: BigTextStyleInformation(''),
      );
    }

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Show notification
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(90000), title, message, notificationDetails,
        payload: json.encode(data));

  }

  void notificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User grander provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
