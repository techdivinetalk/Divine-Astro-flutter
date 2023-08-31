import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../di/shared_preference_service.dart';

class LiveController extends GetxController {
  var pref = Get.find<SharedPreferenceService>();
  var svgaAnime = [
    "blue_lover.svga",
    "box_of_roses.svga",
    "box_of_roses_second.svga",
    "christmas_reindeer_and_sleigh.svga",
    "lovers.svga",
    "new_year_countdown.svga",
    "new_year_gifts.svga",
    "sports_car.svga",
    "white_horse.svga"
  ];

  @override
  void dispose() {
    total = 0;
    duration.value = "";
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
    plugins: [ZegoUIKitSignalingPlugin()],
  )
    ..durationConfig.isVisible = false
    ..previewConfig.pageBackIcon = const SizedBox()
    ..previewConfig.beautyEffectIcon = const SizedBox()
    ..previewConfig.switchCameraIcon = const SizedBox()
    ..startLiveButtonBuilder = (context, VoidCallback startLive) {
      return const SizedBox();
    }
    ..previewConfig.showPreviewForHost = false;

  Timer? _timer;
  ZegoUIKitUser? coHostUser;
  var msg = TextEditingController();
  var isCoHosting = false.obs;
  var isCameraOn = true.obs;
  var isMicroPhoneOn = true.obs;
  var isCallOnOff = true.obs;
  var duration = "".obs;
  var typeOfCall = "";
  var audioStream = false;
  int total = 0;
  FirebaseDatabase database = FirebaseDatabase.instance;

  setCallType(String id) {
    database.ref().child("user/$id").update({"callType": ""});
  }

  setAvailibility(String id, bool available) {
    database.ref().child("astrologer/$id").update({"is_available": available});
  }

  setBusyStatus(String id, int status) {
    database.ref().child("astrologer/$id/realTime").update({"isEngagedStatus": status});
  }

  Future<String> getCallType(String id) async {
    var snapShot = await database.ref().child("user/$id").get();
    return (snapShot.value as Map)["callType"];
  }

  setVisibilityCoHost(String isAudioCall) {
    typeOfCall = isAudioCall;
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      total = total + 1;
      int h, m, s;

      h = total ~/ 3600;

      m = ((total - h * 3600)) ~/ 60;

      s = total - (h * 3600) - (m * 60);

      //String result = "$h:$m:$s";
      duration.value = "$m m $s s";
    });
  }

  stopTimer() {
    duration.value = "";
    total = 0;
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
