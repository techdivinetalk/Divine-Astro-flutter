import "dart:developer";

// import 'package:flutter/widgets.dart';
import "package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart";
// import 'package:overlay_support/overlay_support.dart';

void showNotifOverlay({required ZegoUIKitUser? user, required String msg}) {
  final ZegoUIKitUser? zegoUIKitUser = user;
  final String message = msg;

  log("showNotifOverlay: ${zegoUIKitUser?.id}:${zegoUIKitUser?.name}:$message");
  // showSimpleNotification(Text(message));
  return;
}
