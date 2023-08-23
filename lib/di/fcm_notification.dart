// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// const channel = AndroidNotificationChannel(
//   "ChannelId",
//   "ChannelName",
//   importance: Importance.high,
// );
// final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// // ignore: type_annotate_public_apis
// Map<String, dynamic>? notificationDetails;
// BuildContext? contextDetail;
// String? previousTransId;
// String? previosConversationId;

// Future<void> firebaseMessagingConfig(BuildContext buildContext) async {
//   contextDetail = buildContext;
//   initMessaging();
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true);

//   _firebaseMessaging.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );

//   //Terminated Notification Configuration
//   FirebaseMessaging.instance.getInitialMessage().then((message) {
//     if (message != null) {
//       //   badgeCounter.value = badgeCounter.value + 1;
//       //   setInt(PreferenceKey.badge, badgeCounter.value);
//       //   FlutterAppBadger.updateBadgeCount(badgeCounter.value);
//       debugPrint("Notification Data : ${message.data}");
//       // navigateToScreen(message: message.data, fromNotification: true);
//     }
//   });

//   FirebaseMessaging.onMessage.listen((message) {
//     // if (NavigationUtils.getRouteName(contextDetail!) != routePaymentChat &&
//     //     !isPaymentScreen &&
//     //     (conversationIdDetail != message.data["conversationId"])) {
//     //   if (message.data['unreadCount'] != null) {
//     //     badgeCounter.value = int.parse(message.data['unreadCount'] ?? 0);
//     //   } else {}

//     //   //   setInt("badge", badgeCounter.value);
//     //   FlutterAppBadger.updateBadgeCount(badgeCounter.value);
//     //   showNotification(message);
//     // }
//     showNotification(message);
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     print('Message clicked!');
//     //  badgeCounter.value = badgeCounter.value + 1;
//     //  setInt(PreferenceKey.badge, badgeCounter.value);
//     //  FlutterAppBadger.updateBadgeCount(badgeCounter.value);
//     debugPrint("Notification Data : ${message.data}");
//     // navigateToScreen(message: message.data, fromNotification: true);
//   });

//   // ignore: unused_element
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     debugPrint("Notification Data : ${message.data}");
//     // navigateToScreen(message: message.data, fromNotification: true);
//   }

// //  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }

// void initMessaging() {
//   var initializationSettingsAndroid = AndroidInitializationSettings(
//       "@mipmap/ic_launcher"); // <- default icon name is @mipmap/ic_launcher
//   var initSetting = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   _flutterLocalNotificationsPlugin.initialize(
//     initSetting,
//   );
// }

// Future<void> onSelectNotification(String? payload) {
//   print(payload);
//   // badgeCounter.value = 0;
//   // // setInt(PreferenceKey.badge, 0);
//   // FlutterAppBadger.removeBadge();
//   // navigateToScreen(message: notificationDetails, fromNotification: true);
//   return Future.value();
// }

// void showNotification(RemoteMessage message) {
//   var notification = message.notification;
//   notificationDetails = message.data;
//   var android = message.notification?.android;
//   if (notification != null && android != null) {
//     _flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           icon: android.smallIcon,
//         ),
//       ),
//     );
//   }
// }
