// ignore_for_file: lines_longer_than_80_chars

import "dart:async";
import "dart:convert";

import "package:after_layout/after_layout.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_gift.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/call_accept_or_reject_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/disconnect_call_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/more_options_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/notif_overlay.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/wait_list_widget.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart";
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";
//
//
//
//
//
//
//
//
//
//

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

  final ZegoUIKitPrebuiltLiveStreamingController _zegoController =
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

    _zegoController.message
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
                    ..confirmDialogInfo = null
                    ..disableCoHostInvitationReceivedDialog = true
                    // ..turnOnCameraWhenJoining = _controller.isCamOn
                    // ..turnOnMicrophoneWhenJoining = _controller.isMicOn
                    ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                      showUserNameOnView: false,
                    )
                    ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                      showInRoomMessageButton: false,
                      hostButtons: <ZegoMenuBarButtonName>[],
                      coHostButtons: <ZegoMenuBarButtonName>[],
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
                  controller: _zegoController,
                  events: events,
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
      rounded: true,
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
          const SizedBox(height: 16),
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
              await _zegoController.leave(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          ),
          Flexible(
            flex: 3,
            child: InkWell(
              onTap: () async {
                //
                //
                // No need to
                // navigate anywhere
                //
                //
              },
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
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CustomImageWidget(
                          imageUrl: _controller.avatar,
                          rounded: true,
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
                            Text(
                              _controller.hostSpeciality,
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
        _controller.getLatestLeaderboard(snapshot.data?.snapshot);
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
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CustomImageWidget(
                                    imageUrl: _controller
                                        .leaderboardModel.first.avatar,
                                    rounded: true,
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
                                Image.asset(
                                  "assets/images/live_star.png",
                                  height: 40,
                                  width: 40,
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
  //     height: 50 + 32,
  //     child: ListView.builder(
  //       itemCount: _controller.customGiftModel.length,
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (BuildContext context, int index) {
  //         final CustomGiftModel item = _controller.customGiftModel[index];
  //         return InkWell(
  //           onTap: () async {
  //             final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
  //             if (hasMyIdInWaitList) {
  //               await alreadyInTheWaitListDialog();
  //             } else {
  //               final bool hasBal = await _controller.hasBalanceForSendingGift(
  //                 giftId: item.giftId,
  //                 giftName: item.giftName,
  //                 giftQuantity: 1,
  //                 giftAmount: item.giftPrice,
  //               );
  //               if (hasBal) {
  //                 if (mounted) {
  //                   // LiveGiftWidget.show(context, item.giftSvga);
  //                   if (item.bytes.isEmpty) {
  //                     LiveGiftWidget.show(context, item.giftSvga);
  //                   } else {
  //                     LiveGiftCacheWidget.show(context, item.bytes);
  //                   }
  //                 } else {}
  //                 await _controller.sendGiftAPI(
  //                   count: 1,
  //                   svga: item.giftSvga,
  //                   successCallback: log,
  //                   failureCallback: log,
  //                 );
  //                 await _controller.addUpdateLeaderboard(
  //                   quantity: 1,
  //                   amount: item.giftPrice,
  //                 );
  //               } else {
  //                 await lowBalancePopup();
  //               }
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
  //                   child: CustomImageWidget(
  //                     imageUrl: item.giftImage,
  //                     rounded: false,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   "₹${item.giftPrice}",
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     color: AppColors.white,
  //                   ),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _editingController,
              onSubmitted: (String value) async {
                final String msg = _editingController.value.text;
                await _zegoController.message.send(msg);
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
                    await _zegoController.message.send(msg);
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
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () async {
            final ZegoUIKit instance = ZegoUIKit.instance;
            _controller.isCamOn = !_controller.isCamOn;
            instance.turnCameraOn(_controller.isCamOn);
          },
          child: Image.asset(
            height: 40,
            fit: BoxFit.cover,
            !_controller.isCamOn
                ? "assets/images/live_cam_on.png"
                : "assets/images/live_cam_off.png",
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            final ZegoUIKit instance = ZegoUIKit.instance;
            _controller.isMicOn = !_controller.isMicOn;
            instance.turnMicrophoneOn(_controller.isMicOn);
          },
          child: Image.asset(
            height: 40,
            fit: BoxFit.cover,
            !_controller.isMicOn
                ? "assets/images/live_mic_on.png"
                : "assets/images/live_mic_off.png",
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget liveZegoMsg() {
    // return MediaQuery.of(context).viewInsets.bottom != 0
    //     ? const SizedBox()
    //     : Column(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: <Widget>[
    //           SizedBox(height: Get.height / 3.5),
    //           Expanded(child: inRoomMessage()),
    //         ],
    //       );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
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
        List<ZegoInRoomMessage> messages =
            snapshot.data ?? <ZegoInRoomMessage>[];
        messages = messages.reversed.toList();
        return ListView.builder(
          reverse: true,
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
                        rounded: true,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
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
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () async {
                        await moreOptionsPopup(userId: message.user.id);
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                    const SizedBox(width: 4),
                  ],
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
              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child("live/${_controller.liveId}/waitList")
                    .onValue
                    .asBroadcastStream(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DatabaseEvent> snapshot,
                ) {
                  (
                    bool returnValueBool,
                    String returnValueString
                  ) multipleReturns;
                  multipleReturns = _controller.isEngaded(
                    snapshot.data?.snapshot,
                    isForMe: false,
                  );
                  final bool isEngaded = multipleReturns.$1;
                  final String type = multipleReturns.$2;
                  return IconButton(
                    onPressed: () async {
                      await exitFunc(isEngaded: isEngaded);
                    },
                    icon: Image.asset("assets/images/live_exit_red.png"),
                  );
                },
              ),
              const SizedBox(height: 16),
              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child("live/${_controller.liveId}/waitList")
                    .onValue
                    .asBroadcastStream(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DatabaseEvent> snapshot,
                ) {
                  _controller.getLatestWaitList(snapshot.data?.snapshot);
                  return AnimatedOpacity(
                    opacity: _controller.waitListModel.isEmpty ? 0.0 : 1.0,
                    duration: const Duration(seconds: 1),
                    child: _controller.waitListModel.isEmpty
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: waitListPopup,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  "assets/images/live_new_hourglass.png",
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 16),
              StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref()
                    .child("live/${_controller.liveId}/leaderboard")
                    .onValue
                    .asBroadcastStream(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<DatabaseEvent> snapshot,
                ) {
                  _controller.getLatestLeaderboard(snapshot.data?.snapshot);
                  return AnimatedOpacity(
                    opacity: _controller.leaderboardModel.isEmpty ? 0.0 : 1.0,
                    duration: const Duration(seconds: 1),
                    child: _controller.leaderboardModel.isEmpty
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: leaderboardPopup,
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  "assets/images/live_new_podium.png",
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
              // const SizedBox(height: 16),
              // AnimatedOpacity(
              //   opacity: !_controller.isHostAvailable ? 0.0 : 1.0,
              //   duration: const Duration(seconds: 1),
              //   child: !_controller.isHostAvailable
              //       ? const SizedBox()
              //       : Align(
              //           alignment: Alignment.centerRight,
              //           child: InkWell(
              //             onTap: callAstrologerPopup,
              //             child: SizedBox(
              //               height: 50,
              //               width: 50,
              //               child: Image.asset(
              //                 "assets/images/live_call_btn.png",
              //               ),
              //             ),
              //           ),
              //         ),
              // ),

              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
            ],
          );
  }

  // Widget callStack() {
  //   final Data data = _controller.details.data ?? Data();
  //   final int videoDiscount = data.videoDiscountedAmount ?? 0;
  //   final int videoOriginal = data.videoCallAmount ?? 0;
  //   return (videoDiscount == 0)
  //       ? Column(
  //           children: <Widget>[
  //             Text(
  //               "$videoOriginal",
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ],
  //         )
  //       : Column(
  //           children: <Widget>[
  //             Text(
  //               "₹$videoDiscount/Min",
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(width: 4.0),
  //             Text(
  //               "₹$videoOriginal/Min",
  //               style: const TextStyle(
  //                 fontSize: 10,
  //                 decoration: TextDecoration.lineThrough,
  //                 decorationColor: Colors.red,
  //               ),
  //             ),
  //           ],
  //         );
  // }

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

  Future<void> alreadyInTheWaitListDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Already in the Wait List",
          ),
          content: const Text(
            "You're already in the Astrologer's Wait List. Tap on hourglass to see your waiting time.",
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: Get.back,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    return Future<void>.value();
  }

  // Future<void> giftPopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return GiftWidget(
  //         onClose: Get.back,
  //         list: _controller.customGiftModel,
  //         onSelect: (CustomGiftModel item, num quantity) async {
  //           Get.back();
  //           final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
  //           if (hasMyIdInWaitList) {
  //             await alreadyInTheWaitListDialog();
  //           } else {
  //             final bool hasBal = await _controller.hasBalanceForSendingGift(
  //               giftId: item.giftId,
  //               giftName: item.giftName,
  //               giftQuantity: int.parse(quantity.toString()),
  //               giftAmount: item.giftPrice,
  //             );
  //             if (hasBal) {
  //               if (mounted) {
  //                 // LiveGiftWidget.show(context, item.giftSvga);
  //                 if (item.bytes.isEmpty) {
  //                   LiveGiftWidget.show(context, item.giftSvga);
  //                 } else {
  //                   LiveGiftCacheWidget.show(context, item.bytes);
  //                 }
  //               } else {}
  //               await _controller.sendGiftAPI(
  //                 count: quantity,
  //                 svga: item.giftSvga,
  //                 successCallback: log,
  //                 failureCallback: log,
  //               );
  //               await _controller.addUpdateLeaderboard(
  //                 quantity: quantity,
  //                 amount: item.giftPrice,
  //               );
  //             } else {
  //               await lowBalancePopup();
  //             }
  //           }
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

  Future<void> waitListPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return WaitListWidget(
          onClose: Get.back,
          waitTime: _controller.getTotalWaitTime(),
          myUserId: _controller.userId,
          list: _controller.waitListModel,
          hasMyIdInWaitList: false,
          onExitWaitList: () async {
            Get.back();
            // await _controller.removeFromWaitList();
          },
          astologerName: _controller.userName,
          astologerImage: _controller.avatar,
          astologerSpeciality: _controller.hostSpeciality,
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> disconnectPopup({
    required Function() noDisconnect,
    required Function() yesDisconnect,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DisconnectWidget(
          onClose: Get.back,
          noDisconnect: () {
            Get.back();
            noDisconnect();
          },
          yesDisconnect: () {
            Get.back();
            yesDisconnect();
          },
          isAstro: _controller.isHost,
          astroAvatar: _controller.avatar,
          astroUserName: _controller.userName,
          custoAvatar: _controller.waitListModel.first.avatar,
          custoUserName: _controller.waitListModel.first.userName,
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

  // Future<void> exitPopup() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ExitWidget(
  //         onClose: Get.back,
  //         astrologerAvatar: _controller.details.data?.image ?? "",
  //         astrologerUserName: _controller.details.data?.name ?? "",
  //         onFollow: () async {
  //           Get.back();
  //           final int isFollow = _controller.details.data?.isFollow ?? 0;
  //           if (isFollow == 1) {
  //           } else {
  //             await _controller.followOrUnfollowAstrologer();
  //           }
  //         },
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
  //         waitTime: _controller.getTotalWaitTime(),
  //         details: _controller.details,
  //         onSelect: (String type, int amount) async {
  //           Get.back();
  //           final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
  //           if (hasMyIdInWaitList) {
  //             await alreadyInTheWaitListDialog();
  //           } else {
  //             final bool canOrder = await _controller.canPlaceLiveOrder(
  //               talkType: type,
  //               talkAmount: amount,
  //             );
  //             if (canOrder) {
  //               await _controller.addUpdateToWaitList(
  //                 callType: type,
  //                 isEngaded: false,
  //               );
  //               await onCoHostRequestSent();
  //             } else {
  //               await lowBalancePopup();
  //             }
  //           }
  //         },
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  Future<void> moreOptionsPopup({required String userId}) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return MoreOptionsWidget(
          onClose: Get.back,
          isHost: _controller.isHost,
          onTapOnBlockUser: () async {
            Get.back();
            await _controller.addUpdateToBlockList(userId: userId);
          },
          onTapOnReportUser: Get.back,
          onTapOnRequestGift: Get.back,
        );
      },
    );
    return Future<void>.value();
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

  void scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    return;
  }

  // dharam

  Future<void> exitFunc({required bool isEngaded}) async {
    if (isEngaded) {
      await disconnectPopup(
        noDisconnect: () {},
        yesDisconnect: removeCoHostOrStopCoHost,
      );
    } else {
      if (mounted) {
        await _zegoController.leave(context);
        _controller.zegoUIKitUser = ZegoUIKitUser(id: "", name: "");
      } else {}
    }
    return Future<void>.value();
  }

  ZegoUIKitPrebuiltLiveStreamingEvents get events {
    return ZegoUIKitPrebuiltLiveStreamingEvents(
      hostEvents: ZegoUIKitPrebuiltLiveStreamingHostEvents(
        onCoHostRequestReceived: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostRequestReceived");
        },
        onCoHostRequestCanceled: (ZegoUIKitUser user) async {
          showNotifOverlay(user: user, msg: "onCoHostRequestCanceled");
          await onCoHostRequestCanceled(user);
        },
        onCoHostRequestTimeout: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostRequestTimeout");
        },
        onActionAcceptCoHostRequest: () {
          showNotifOverlay(user: null, msg: "onActionAcceptCoHostRequest");
        },
        onActionRefuseCoHostRequest: () {
          showNotifOverlay(user: null, msg: "onActionRefuseCoHostRequest");
        },
        onCoHostInvitationSent: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostInvitationSent");
        },
        onCoHostInvitationTimeout: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostInvitationTimeout");
        },
        onCoHostInvitationAccepted: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostInvitationAccepted");
        },
        onCoHostInvitationRefused: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostInvitationRefused");
        },
      ),
      audienceEvents: ZegoUIKitPrebuiltLiveStreamingAudienceEvents(
        onCoHostRequestSent: () {
          showNotifOverlay(user: null, msg: "onCoHostRequestSent");
        },
        onActionCancelCoHostRequest: () {
          showNotifOverlay(user: null, msg: "onActionCancelCoHostRequest");
        },
        onCoHostRequestTimeout: () {
          showNotifOverlay(user: null, msg: "onCoHostRequestTimeout");
        },
        onCoHostRequestAccepted: () {
          showNotifOverlay(user: null, msg: "onCoHostRequestAccepted");
        },
        onCoHostRequestRefused: () {
          showNotifOverlay(user: null, msg: "onCoHostRequestRefused");
        },
        onCoHostInvitationReceived: (ZegoUIKitUser user) {
          showNotifOverlay(user: user, msg: "onCoHostInvitationReceived");
        },
        onCoHostInvitationTimeout: () {
          showNotifOverlay(user: null, msg: "onCoHostInvitationTimeout");
        },
        onActionAcceptCoHostInvitation: () {
          showNotifOverlay(user: null, msg: "onActionAcceptCoHostInvitation");
        },
        onActionRefuseCoHostInvitation: () {
          showNotifOverlay(user: null, msg: "onActionRefuseCoHostInvitation");
        },
      ),
    );
  }

  Future<void> onCoHostRequestCanceled(ZegoUIKitUser user) async {
    await hostingAndCoHostingPopup(
      onClose: Get.back,
      needAcceptButton: true,
      needDeclinetButton: false,
      onAcceptButton: () async {
        final ZegoLiveStreamingConnectInviteController connectInvite =
            _zegoController.connectInvite;
        _controller.zegoUIKitUser = user;
        await connectInvite.hostSendCoHostInvitationToAudience(
          user,
        );
      },
      onDeclineButton: () {},
    );
    return Future<void>.value();
  }

  Future<void> removeCoHostOrStopCoHost() async {
    final ZegoLiveStreamingConnectController connect = _zegoController.connect;
    final bool removed = _controller.isHost
        ? await connect.removeCoHost(_controller.zegoUIKitUser)
        : await connect.stopCoHost();
    if (removed) {
      _controller.zegoUIKitUser = ZegoUIKitUser(id: "", name: "");
      _controller.isHost
          ? await _controller.removeFromWaitListWhereEngadedIsTrue()
          : await _controller.removeFromWaitList();
    } else {}
    if (removed && !_controller.isHost) {
      // await _controller.makeAPICallForEndCall();
    } else {}
    return Future<void>.value();
  }

  Future<void> hostingAndCoHostingPopup({
    required Function() onClose,
    required bool needAcceptButton,
    required bool needDeclinetButton,
    required Function() onAcceptButton,
    required Function() onDeclineButton,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CallAcceptOrRejectWidget(
          onClose: onClose,
          needAcceptButton: needAcceptButton,
          needDeclinetButton: needDeclinetButton,
          onAcceptButton: () {
            Get.back();
            onAcceptButton();
          },
          onDeclineButton: () {
            Get.back();
            onDeclineButton();
          },
          avatar:
              "https://divinenew-prod.s3.ap-south-1.amazonaws.com/customer/8790/profile_image1702965912.jpg",
          userName: 'Dharam',
        );
      },
    );
    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    // await _controller.getAllGifts();
    // _controller.mapAndMergeGiftsWithConstant();
    // await _controller.concurrentDownload(
    //   downloadStarted: () {
    //     print("concurrentDownload: downloadStarted");
    //   },
    //   downloadEnded: () {
    //     print("concurrentDownload: downloadEnded");
    //   },
    // );
    return Future<void>.value();
  }
}
