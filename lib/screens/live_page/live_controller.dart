import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class LiveController extends GetxController {
  @override
  void dispose() {
    total = 0;
    duration.value = "";
    _timer.cancel();
    super.dispose();
  }

  final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
    plugins: [ZegoUIKitSignalingPlugin()],
  )..durationConfig.isVisible = false
  ..previewConfig.showPreviewForHost = false  ;
  late Timer _timer;
  ZegoUIKitUser? coHostUser;
  var msg = TextEditingController();
  var isCoHosting = false.obs;
  var isCameraOn = true.obs;
  var isMicroPhoneOn = true.obs;
  var isCallOnOff = true.obs;
  var duration = "".obs;
  int total = 0;

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
    _timer.cancel();
  }
}
