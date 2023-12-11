import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";
// import 'package:firebase_database/firebase_database.dart';

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

  Map<String, dynamic> data = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    // FirebaseDatabase.instance.ref().child("live").onValue.listen(
    //   (DatabaseEvent event) {
    //     if (event.snapshot.value == null) {
    //       data = <String, dynamic>{};
    //     } else {
    //       data = event.snapshot.value as Map<String, dynamic>;
    //       if (data.isEmpty) {
    //       } else if (data.isNotEmpty) {
    //         _controller.liveId = data.keys.elementAt(0);
    //       } else {}
    //     }

    //     final int index = data.keys.toList().indexWhere(
    //       (element) {
    //         return element == _controller.liveId;
    //       },
    //     );
    //     print("index: $index");
    //   },
    // );
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
            config: streamingConfig
              ..innerText = textConfig
              ..layout = galleryLayout
              ..swipingConfig = swipingConfig
              ..avatarBuilder = (
                BuildContext context,
                Size size,
                ZegoUIKitUser? user,
                Map<String, dynamic> extraInfo,
              ) {
                return avatarWidget(user: user);
              },
          );
        },
      ),
    );
  }

  ZegoUIKitPrebuiltLiveStreamingConfig get streamingConfig {
    final ZegoUIKitSignalingPlugin plugin = ZegoUIKitSignalingPlugin();
    final List<IZegoUIKitPlugin> pluginsList = <IZegoUIKitPlugin>[plugin];
    return _controller.isHost
        ? ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: pluginsList)
        : ZegoUIKitPrebuiltLiveStreamingConfig.audience(plugins: pluginsList);
  }

  ZegoInnerText get textConfig {
    return _controller.isHost ? ZegoInnerText() : ZegoInnerText();
  }

  ZegoLayout get galleryLayout {
    return _controller.isHost ? ZegoLayout.gallery() : ZegoLayout.gallery();
  }

  Widget avatarWidget({required ZegoUIKitUser? user}) {
    return user != null
        ? CircleAvatar(
            foregroundImage: NetworkImage(
              "https://robohash.org/${user.id}.png",
            ),
          )
        : const SizedBox();
  }

  ZegoLiveStreamingSwipingConfig? get swipingConfig {
    return _controller.isHost
        ? null
        : ZegoLiveStreamingSwipingConfig(
            requirePreviousLiveID: () {
              return "";
            },
            requireNextLiveID: () {
              return "";
            },
          );
  }
}
