import 'dart:async';

import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallController extends GetxController {
  RxBool muteValue = false.obs,
      videoValue = false.obs,
      frontCamValue = true.obs;

  Rx<Duration> callDuration = const Duration(seconds: 0).obs;
  final callController = ZegoUIKitPrebuiltCallController();

  Timer? timer;

  @override
  void onReady() {
    super.onReady();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callDuration.value = Duration(seconds: callDuration.value.inSeconds + 1);
      if (callDuration.value.inSeconds > (60 * 5)) {
        onHangUp();
      }
    });
  }

  onHangUp() {
    timer?.cancel();
    callController.hangUp(Get.context!, showConfirmation: true);
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
