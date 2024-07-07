// import 'dart:ui';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';

// import 'type_two_action.dart';

// showSecondNotification(
//     String title, String body, Map<String, dynamic> payload) async {
//   Map<String, String?>? payloadData = {};
//   payload.forEach((key, value) {
//     payloadData[key] = value.toString();
//   });
//   // await AwesomeNotifications().requestPermissionToSendNotifications();
//   await AwesomeNotifications().initialize(
//     // set the icon to null if you want to use the default app icon
//     'resource://drawable/divine_logo_tran',
//     [
//       NotificationChannel(
//         channelGroupKey: 'DivineAstrologer',
//         channelKey: 'DivineAstrologer',
//         channelName: 'DivineAstrologer',
//         channelDescription: 'DivineAstrologer',
//         // defaultColor: Color(0xFF9D50DD),
//         ledColor: Colors.white,
//         playSound: true,
//         enableVibration: true,
//         importance: NotificationImportance.High,
//         defaultPrivacy: NotificationPrivacy.Public,
//         soundSource: 'resource://raw/notification_ring',
//         ledOnMs: 1000,
//         ledOffMs: 500,
//         enableLights: true,
//         criticalAlerts: true,
//         locked: true,
//       )
//     ],
//     // Channel groups are only visual and are not required
//     channelGroups: [
//       NotificationChannelGroup(
//           channelGroupKey: 'DivineAstrologer',
//           channelGroupName: 'DivineAstrologer')
//     ],
//     debug: true,
//   );

//   int id = DateTime.now().second;

//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: id,
//       channelKey: 'DivineAstrologer',
//       title: title,
//       body: body,
//       actionType: ActionType.Default,
//       payload: payloadData,
//       notificationLayout: NotificationLayout.Default,
//       // bigPicture: payload['image'],
//       customSound: 'resource://raw/notification_ring',
//       largeIcon: 'resource://drawable/divine_logo_tran',
//       icon: 'resource://drawable/divine_logo_tran',
//       ticker: 'ticker',
//       hideLargeIconOnExpand: true,
//     ),
//     actionButtons: [
//       NotificationActionButton(
//         key: 'GO_TO_CHAT',
//         label: 'Go to chat',
//         enabled: true,
//         // icon: 'resource://drawable/divine_logo_tran',
//       ),
//     ],
//   );

//   await AwesomeNotifications().setListeners(
//     onActionReceivedMethod: onActionReceivedMethod,
//   );
// }
