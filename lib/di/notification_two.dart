import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'type_two_action.dart';

showSecondNotification(
    String title, String body, Map<String, String?>? payload) {
  AwesomeNotifications().requestPermissionToSendNotifications();
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/divine_logo_tran',
    [
      NotificationChannel(
        channelGroupKey: 'pushnotificationapp',
        channelKey: 'pushnotificationapp',
        channelName: 'pushnotificationapp',
        channelDescription: 'pushnotificationapp',
        // defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        playSound: true,
        enableVibration: true,
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Public,
        soundSource: 'resource://raw/accept_ring',
        ledOnMs: 1000,
        ledOffMs: 500,
        enableLights: true,
        criticalAlerts: true,
        locked: true,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'pushnotificationapp',
          channelGroupName: 'pushnotificationapp')
    ],
    debug: true,
  );

  int id = DateTime.now().second;

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'pushnotificationapp',
      title: 'title',
      body: 'body',
      actionType: ActionType.Default,
      fullScreenIntent: true,
      payload: payload,
      notificationLayout: NotificationLayout.Default,
      // bigPicture: payload['image'],
      customSound: 'resource://raw/accept_ring',
      largeIcon: 'resource://drawable/divine_logo_tran',
      icon: 'resource://drawable/divine_logo_tran',
      ticker: 'ticker',
      hideLargeIconOnExpand: true,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'GO_TO_CHAT',
        label: 'Go to chat',
        enabled: true,
        // icon: 'resource://drawable/divine_logo_tran',
      ),
    ],
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
  );
}
