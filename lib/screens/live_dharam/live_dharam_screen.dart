// ignore_for_file: lines_longer_than_80_chars

import "dart:async";
import "dart:convert";

import "package:after_layout/after_layout.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_gift.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
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

  final StreamController<List<ZegoInRoomMessage>> _zegoMessageStreamController =
      StreamController<List<ZegoInRoomMessage>>.broadcast();

  late StreamSubscription<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      _zegocloudSubscription;

  // late StreamSubscription<DatabaseEvent> _firebaseSubscription;

  final TextEditingController _editingController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _streamingController.message
        .stream()
        .listen(_zegoMessageStreamController.sink.add);

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
    unawaited(_zegoMessageStreamController.close());
    unawaited(_zegocloudSubscription.cancel());
    // unawaited(_firebaseSubscription.cancel());
    _editingController.dispose();
    _scrollController.dispose();

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
                    ..previewConfig.showPreviewForHost = false
                    ..maxCoHostCount = 1
                    ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                      showUserNameOnView: false,
                    )
                    ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                      hostButtons: _controller.isHost
                          ? <ZegoMenuBarButtonName>[
                              ZegoMenuBarButtonName.toggleCameraButton,
                              ZegoMenuBarButtonName.toggleMicrophoneButton,
                            ]
                          : <ZegoMenuBarButtonName>[],
                    )
                    ..layout = galleryLayout
                    ..swipingConfig = swipingConfig
                    ..onLiveStreamingStateUpdate = onLiveStreamingStateUpdate
                    ..avatarBuilder = avatarWidget
                    ..topMenuBarConfig = ZegoTopMenuBarConfig(
                      hostAvatarBuilder: (ZegoUIKitUser host) {
                        return const SizedBox();
                      },
                      showCloseButton: false,
                    )
                    ..memberButtonConfig = ZegoMemberButtonConfig(
                      builder: (int memberCount) {
                        return const SizedBox();
                      },
                    )
                    ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                      showInRoomMessageButton: false,
                    )
                    ..foreground = foregroundWidget()
                    ..inRoomMessageConfig = ZegoInRoomMessageConfig(
                      itemBuilder: (
                        BuildContext context,
                        ZegoInRoomMessage message,
                        Map<String, dynamic> extraInfo,
                      ) {
                        return const SizedBox();
                      },
                    ),
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
    // final String astroUser = (_controller.details.data?.id ?? 0).toString();
    return CustomImageWidget(
      imageUrl: zegoUser == mineUser
          ? _controller.avatar
          // : zegoUser == astroUser
          //     ? (_controller.details.data?.image ?? "")
          : "https://robohash.org/avatarWidget",
    );
  }

  ZegoLiveStreamingSwipingConfig? get swipingConfig {
    return _controller.isHost
        ? null
        : ZegoLiveStreamingSwipingConfig(
            requirePreviousLiveID: () => "",
            requireNextLiveID: () => "",
          );
  }

  Widget foregroundWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight - 16.0),
      child: Column(
        children: <Widget>[
          appBarWidget(),
          const SizedBox(height: 16),
          astrologerLiveStar(),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 16),
                Expanded(child: liveZegoMsg()),
                const SizedBox(width: 16),
                verticleLiveFeatures(),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // const SizedBox(height: 16),
          // horizontalGiftBar(),
          const SizedBox(height: 16),
          bottomBarWidget(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget appBarWidget() {
    return SizedBox(
      height: 50,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 16),
          IconButton(
            onPressed: () async {
              await _streamingController.leave(context, showConfirmation: true);
            },
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          ),
          Flexible(
            flex: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(color: AppColors.black.withOpacity(0.2)),
                color: AppColors.black.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 4),
                    CircleAvatar(
                      child: CustomImageWidget(
                        imageUrl: _controller.avatar,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _controller.userName,
                            style: const TextStyle(color: AppColors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "<<Speciality>>",
                            style: TextStyle(color: AppColors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 16),
          if (_controller.isHost)
            Switch(
              value: _controller.isHostAvailable,
              onChanged: (bool value) async {
                _controller.isHostAvailable = value;
                await _controller.updateHostAvailability();
              },
            )
          else
            const SizedBox(),
          // DecoratedBox(
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          //     border: Border.all(color: AppColors.black.withOpacity(0.2)),
          //     color: AppColors.black.withOpacity(0.2),
          //   ),
          //   child: Padding(
          //     padding: EdgeInsets.zero,
          //     child: Row(
          //       children: <Widget>[
          //         InkWell(
          //           onTap: () async {
          //             await _controller.followOrUnfollowAstrologer();
          //             await _controller.getAstrologerDetails();
          //           },
          //           child: Image.asset(
          //             _controller.details.data?.isFollow == 1
          //                 ? "assets/images/live_new_unfollow.png"
          //                 : "assets/images/live_new_follow.png",
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget astrologerLiveStar() {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child("live/${_controller.liveId}/leaderboard")
          .onValue
          .asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        _controller.getLatestLeaderboard(
          snapshot.data?.snapshot,
          () {},
          () {},
        );
        return AnimatedOpacity(
          opacity: _controller.leaderboardModel.isEmpty ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: _controller.leaderboardModel.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: AppColors.black.withOpacity(0.2),
                            ),
                            color: AppColors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 4),
                                CircleAvatar(
                                  child: CustomImageWidget(
                                    imageUrl: _controller
                                        .leaderboardModel.first.avatar,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Text(
                                        "Astrologer's Live Star",
                                        style:
                                            TextStyle(color: AppColors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _controller
                                            .leaderboardModel.first.userName,
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const CircleAvatar(
                                  backgroundColor: AppColors.transparent,
                                  foregroundImage: AssetImage(
                                    "assets/images/live_star.png",
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // Widget horizontalGiftBar() {
  //   return SizedBox(
  //     height: 50 + 28,
  //     child: ListView.builder(
  //       itemCount: _controller.customGiftModel.length,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (BuildContext context, int index) {
  //         final CustomGiftModel item = _controller.customGiftModel[index];
  //         return InkWell(
  //           onTap: () async {
  //             final bool hasBalance = _controller.hasBalance(
  //               quantity: 1,
  //               amount: item.giftPrice,
  //             );
  //             if (hasBalance) {
  //               LiveGiftWidget.show(context, item.giftSvga);
  //               await _controller.sendGiftAPI(
  //                 count: 1,
  //                 svga: item.giftSvga,
  //                 successCallback: log,
  //                 failureCallback: log,
  //               );
  //               await _controller.addUpdateLeaderboard(
  //                 quantity: 1,
  //                 amount: item.giftPrice,
  //               );
  //             } else {
  //               await lowBalancePopup();
  //             }
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 SizedBox(
  //                   height: 50,
  //                   width: 50,
  //                   child: CustomImageWidget(imageUrl: item.giftImage),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "₹${item.giftPrice}",
  //                   style: const TextStyle(color: AppColors.white),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget bottomBarWidget() {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _editingController,
            onSubmitted: (String value) async {
              final String msg = _editingController.value.text;
              await _streamingController.message.send(msg);
              _editingController.clear();
              FocusManager.instance.primaryFocus?.unfocus();
              scrollDown();
            },
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              suffixIcon: IconButton(
                onPressed: () async {
                  final String msg = _editingController.value.text;
                  await _streamingController.message.send(msg);
                  _editingController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                  scrollDown();
                },
                icon: const Icon(Icons.send, color: Colors.white),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: AppColors.white.withOpacity(0.2),
              hintText: "Say Hi",
              hintStyle: const TextStyle(color: AppColors.white),
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(50.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ),
        // const SizedBox(width: 16),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: InkWell(
        //     onTap: giftPopup,
        //     child: SizedBox(
        //       height: 50,
        //       width: 50,
        //       child: CustomLottieWidget(
        //         path: "assets/lottie/gift.json",
        //         fit: BoxFit.cover,
        //         height: 50,
        //         width: 50,
        //         repeat: true,
        //         onLoaded: (LottieComposition comp) {},
        //       ),
        //     ),
        //   ),
        // ),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget liveZegoMsg() {
    return MediaQuery.of(context).viewInsets.bottom != 0
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: Get.height / 3.5),
              Expanded(child: inRoomMessage()),
            ],
          );
  }

  Widget inRoomMessage() {
    return StreamBuilder<List<ZegoInRoomMessage>>(
      stream: _zegoMessageStreamController.stream.asBroadcastStream(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ZegoInRoomMessage>> snapshot,
      ) {
        final List<ZegoInRoomMessage> messages =
            snapshot.data ?? <ZegoInRoomMessage>[];
        return ListView.builder(
          shrinkWrap: true,
          itemCount: messages.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            final ZegoInRoomMessage message = messages[index];
            final String zegoUser = message.user.id;
            final String mineUser = _controller.userId;
            // final String astroUser =
            //     (_controller.details.data?.id ?? 0).toString();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: AppColors.black.withOpacity(0.2)),
                  color: AppColors.black.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 4),
                      CircleAvatar(
                        child: CustomImageWidget(
                          imageUrl: zegoUser == mineUser
                              ? _controller.avatar
                              // : zegoUser == astroUser
                              //     ? (_controller.details.data?.image ?? "")
                              : "https://robohash.org/sa",
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              message.user.name,
                              style: const TextStyle(color: AppColors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              message.message,
                              style: const TextStyle(color: AppColors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget verticleLiveFeatures() {
    return MediaQuery.of(context).viewInsets.bottom != 0
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/images/live_new_hourglass.png"),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: leaderboardPopup,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/images/live_new_podium.png"),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset("assets/images/live_call_btn.png"),
                  ),
                ),
              ),
            ],
          );
  }

  Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
    // final bool condition1 = _controller.isHost == false;
    // final bool condition2 = state == ZegoLiveStreamingState.ended;
    // if (condition1 == false && condition2) {
    //   await showAstrologerLeftDialog();
    // } else {}
    return Future<void>.value();
  }

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

  // Future<void> giftPopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return GiftWidget(
  //         onClose: Get.back,
  //         list: _controller.customGiftModel,
  //         onSelect: (CustomGiftModel item, num quantity) async {
  //           Get.back();
  //           final bool hasBalance = _controller.hasBalance(
  //             quantity: quantity,
  //             amount: item.giftPrice,
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
  //               amount: item.giftPrice,
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

  // Future<void> congratulationsPopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CongratulationsWidget(
  //         onClose: Get.back,
  //         imageURL: _controller.avatar,
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // Future<void> lowBalancePopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return LowBalanceWidget(
  //         onClose: Get.back,
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // Future<void> callAstrologerPopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return CallAstrologerWidget(
  //         onClose: Get.back,
  //         details: _controller.details,
  //         onSelect: (String type, int amount) async {
  //           final bool hasBalance = _controller.hasBalance(
  //             quantity: 1,
  //             amount: amount,
  //           );
  //           if (hasBalance) {
  //           } else {
  //             await lowBalancePopup();
  //           }
  //         },
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

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

  void scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    return;
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    // await _controller.getAllGifts();
    // _controller.mapAndMergeGiftsWithConstant();
    return Future<void>.value();
  }
  /*
  */
}
