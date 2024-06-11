import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class NewLiveCallScreen extends StatefulWidget {
  const NewLiveCallScreen({super.key});

  @override
  State<NewLiveCallScreen> createState() => _NewLiveCallScreenState();
}

class _NewLiveCallScreenState extends State<NewLiveCallScreen> {
   int appID = 696414715;

   String appSign =
      "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa";

   String serverSecret = "89ceddc6c59909af326ddb7209cb1c16";

  final ZegoUIKitPrebuiltLiveStreamingController zegoController =
  ZegoUIKitPrebuiltLiveStreamingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ZegoUIKitPrebuiltLiveStreaming(
        appID: 696414715,
        appSign: "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa",
        userID: "3878",
        userName: 'user_3878',
        liveID: "3878",
        config: streamingConfig
        ..audioVideoView = ZegoLiveStreamingAudioVideoViewConfig(
        showUserNameOnView: false,
        showAvatarInAudioMode: true,
        isVideoMirror: false,
        useVideoViewAspectFill: true,
        showSoundWavesInAudioMode: true,
        visible: (
            ZegoUIKitUser localUser,
            ZegoLiveStreamingRole localRole,
            ZegoUIKitUser targetUser,
            ZegoLiveStreamingRole targetUserRole,
            ) {
          return true;
        },
      ),
      ),
    );
  }

  ZegoUIKitPrebuiltLiveStreamingConfig get streamingConfig {
    final ZegoUIKitSignalingPlugin plugin = ZegoUIKitSignalingPlugin();
    final List<IZegoUIKitPlugin> pluginsList = <IZegoUIKitPlugin>[
      plugin,
    ];
    return ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: pluginsList);
  }
}
