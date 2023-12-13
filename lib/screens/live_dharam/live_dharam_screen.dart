// ignore_for_file: lines_longer_than_80_chars

import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:after_layout/after_layout.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_gift.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/gift_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/leaderboard_widget.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart";
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";

const int appID = 696414715;
const String appSign =
    "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa";
const String serverSecret = "89ceddc6c59909af326ddb7209cb1c16";

class LiveDharamScreen extends StatefulWidget {
  const LiveDharamScreen({super.key});

  @override
  State<LiveDharamScreen> createState() => _LivePage();
}

class _LivePage extends State<LiveDharamScreen>
    with AfterLayoutMixin<LiveDharamScreen> {
  final LiveDharamController _controller = Get.find();

  final ZegoUIKitPrebuiltLiveStreamingController _streamingController =
      ZegoUIKitPrebuiltLiveStreamingController();

  late StreamSubscription<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      _zegocloudSubscription;

  // late StreamSubscription<DatabaseEvent> _firebaseSubscription;

  @override
  void initState() {
    super.initState();

    _zegocloudSubscription = ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream()
        .listen(onInRoomCommandMessageReceived);

    // _firebaseSubscription = FirebaseDatabase.instance
    //     .ref()
    //     .child("live")
    //     .onValue
    //     .listen(_controller.eventListner);
  }

  @override
  void dispose() {
    unawaited(_zegocloudSubscription.cancel());

    // unawaited(_firebaseSubscription.cancel());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return _controller.liveId == ""
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ZegoUIKitPrebuiltLiveStreaming(
                  appID: appID,
                  appSign: appSign,
                  userID: _controller.userId,
                  userName: _controller.userName,
                  liveID: _controller.liveId,
                  config: streamingConfig
                    ..innerText = textConfig
                    ..layout = galleryLayout
                    ..swipingConfig = swipingConfig
                    // ..onLiveStreamingStateUpdate = onLiveStreamingStateUpdate
                    ..avatarBuilder = avatarWidget
                    ..bottomMenuBarConfig.coHostExtendButtons = extendButton
                    ..bottomMenuBarConfig.audienceExtendButtons = extendButton,
                  controller: _streamingController,
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

  Widget avatarWidget(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    final String zegoUser = user?.id ?? "";
    final String mineUser = _controller.userId;
    return CircleAvatar(
      foregroundImage: NetworkImage(
        zegoUser == mineUser
            ? _controller.avatar
            : "https://images.hindustantimes.com/rf/image_size_640x362/HT/p1/2011/12/31/Incoming/Pictures/789560_Wallpaper2.jpg",
      ),
    );
  }

  ZegoLiveStreamingSwipingConfig? get swipingConfig {
    return _controller.isHost
        ? null
        : ZegoLiveStreamingSwipingConfig(
            requirePreviousLiveID: _controller.requirePreviousLiveID,
            requireNextLiveID: _controller.requireNextLiveID,
          );
  }

  // Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
  //   if (state == ZegoLiveStreamingState.ended) {
  //     await showAstrologerLeftDialog();
  //   } else {}
  //   return Future<void>.value();
  // }

  // Future<void> showAstrologerLeftDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           "Astrologer left",
  //         ),
  //         content: const Text(
  //           "This astrologer left this live session. You can wait here for this astrologer if you wish to, or you can explore another astrologer by swiping up or down.",
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             onPressed: Get.back,
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // ZegoMenuBarExtendButton get newGiftButton0 {
  //   return ZegoMenuBarExtendButton(
  //     index: 0,
  //     child: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         shape: const CircleBorder(),
  //       ),
  //       onPressed: giftPopup,
  //       child: const Icon(Icons.abc),
  //     ),
  //   );
  // }

  ZegoMenuBarExtendButton get newGiftButton1 {
    return ZegoMenuBarExtendButton(
      index: 1,
      child: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance
            .ref()
            .child("live/${_controller.liveId}/leaderboard")
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          _controller.getLatestLeaderboard(snapshot.data?.snapshot);
          return _controller.leaderboardModel.isEmpty
              ? const SizedBox()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: leaderboardPopup,
                  child: const Icon(Icons.abc),
                );
        },
      ),
    );
  }

  // Future<void> giftPopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return GiftWidget(
  //         onClose: Get.back,
  //         list: _controller.customGiftModel,
  //         onSelect: (CustomGiftModel item, num quantity, num amount) async {
  //           Get.back();
  //           final bool hasBalance = _controller.hasBalance(
  //             quantity: quantity,
  //             amount: amount,
  //           );
  //           if (hasBalance) {
  //             LiveGiftWidget.show(context, item.giftSvga);
  //             await _controller.sendGiftAPI(
  //               count: quantity,
  //               svga: item.giftSvga,
  //               successCallback: log,
  //               failureCallback: log,
  //             );
  //             await _controller.addUpdateLeaderboard(
  //               quantity: quantity,
  //               amount: amount,
  //             );
  //           } else {}
  //         },
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  Future<void> leaderboardPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LeaderboardWidget(
          onClose: Get.back,
          list: _controller.leaderboardModel,
        );
      },
    );
    return Future<void>.value();
  }

  List<ZegoMenuBarExtendButton> get extendButton {
    return <ZegoMenuBarExtendButton>[/*newGiftButton0,*/ newGiftButton1];
  }

  void onInRoomCommandMessageReceived(
    ZegoSignalingPluginInRoomCommandMessageReceivedEvent event,
  ) {
    final List<ZegoSignalingPluginInRoomCommandMessage> msgs = event.messages;
    for (final ZegoSignalingPluginInRoomCommandMessage commandMessage in msgs) {
      final String senderUserID = commandMessage.senderUserID;
      final String message = utf8.decode(commandMessage.message);
      final Map<String, dynamic> decodedMessage = jsonDecode(message);
      final String svga = decodedMessage["gift_type"];
      if (senderUserID != _controller.userId) {
        LiveGiftWidget.show(context, svga);
      } else {}
    }
    return;
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    // await _controller.getAllGifts();
    // _controller.mapAndMergeGiftsWithConstant();
    return Future<void>.value();
  }
}
