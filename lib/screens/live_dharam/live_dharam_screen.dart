import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";

const int appID = 696414715;
const String appSign =
    "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa";

class LiveDharamScreen extends StatefulWidget {
  const LiveDharamScreen({super.key});

  @override
  State<LiveDharamScreen> createState() => _LivePage();
}

class _LivePage extends State<LiveDharamScreen> {
  final LiveDharamController _controller = Get.find();

  final ZegoUIKitPrebuiltLiveStreamingController
      _zegoUIKitPrebuiltLiveStreamingController =
      ZegoUIKitPrebuiltLiveStreamingController();

  final List<IZegoUIKitPlugin> plug = <IZegoUIKitPlugin>[
    ZegoUIKitSignalingPlugin()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return ZegoUIKitPrebuiltLiveStreaming(
            appID: appID,
            appSign: appSign,
            controller: _zegoUIKitPrebuiltLiveStreamingController,
            userID: _controller.userId,
            userName: _controller.userName,
            liveID: _controller.liveId,
            config: _controller.isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: plug)
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience(plugins: plug)
              ..innerText = _controller.isHost
                  ? ZegoInnerText()
                  : ZegoInnerText(requestCoHostButton: "Co-host")
              ..layout = ZegoLayout.gallery()
              ..avatarBuilder = (
                BuildContext context,
                Size size,
                ZegoUIKitUser? user,
                Map<String, dynamic> extraInfo,
              ) {
                return user != null
                    ? CircleAvatar(
                        foregroundImage: NetworkImage(
                          "https://robohash.org/${user.id}.png",
                        ),
                      )
                    : const SizedBox();
              },
          );
        },
      ),
    );
  }
}
