import 'package:divine_astrologer/satsang_module/satsang_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class SatSangPage extends GetView<SatSangController> {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<SatSangController>(
      assignId: true,
      init: SatSangController(),
      builder: (controller) {
        return controller.userId.value.isNotEmpty ?  SafeArea(
          child: ZegoUIKitPrebuiltLiveAudioRoom(
            appID: 696414715,
            appSign: "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa",
            userID: controller.userId.value,
            userName:  controller.userName.value,
            roomID: controller.userId.value,
            config: (controller.isHost.value)
                ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
                : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience(),
          ),
        ):SizedBox();
      },
    );
  }
}