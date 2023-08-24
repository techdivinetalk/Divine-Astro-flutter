import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveController extends GetxController {
  ZegoUIKitUser? coHostUser;
  var msg = TextEditingController();
  var isCoHosting = false.obs;
  var isCameraOn = true.obs;
  var isMicroPhoneOn = true.obs;
}
