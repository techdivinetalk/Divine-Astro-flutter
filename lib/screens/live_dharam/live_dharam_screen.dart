// ignore_for_file: lines_longer_than_80_chars

import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:after_layout/after_layout.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/screens/live_dharam/gifts_singleton.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_gift.dart";
import "package:divine_astrologer/screens/live_dharam/live_screen_widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/live_screen_widgets/live_keyboard.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/astro_wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/call_accept_or_reject_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/disconnect_call_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/end_session_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/exit_wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/gift_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/more_options_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/notif_overlay.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/zeo_team/player.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:get/get.dart";
import "package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart";
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import "package:divine_astrologer/screens/live_dharam/widgets/show_all_avail_astro_widget.dart";
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
    with WidgetsBindingObserver, AfterLayoutMixin<LiveDharamScreen> {
  final LiveDharamController _controller = Get.find();

  final ZegoUIKitPrebuiltLiveStreamingController _zegoController =
      ZegoUIKitPrebuiltLiveStreamingController();

  final StreamController<List<ZegoInRoomMessage>> _zegoMessageStreamController =
      StreamController<List<ZegoInRoomMessage>>.broadcast();

  final StreamController<List<ZegoInRoomMessage>>
      _zegoMessageStreamControllerTop =
      StreamController<List<ZegoInRoomMessage>>.broadcast();

  late StreamSubscription<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      _zegocloudSubscription;

  late StreamSubscription<DatabaseEvent> _firebaseSubscription;

  // final TextEditingController _editingController = TextEditingController();

  final ScrollController _scrollControllerForTop = ScrollController();
  final ScrollController _scrollControllerForBottom = ScrollController();

  final keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> keyboardSubscription;

  bool _isKeyboardSheetOpen = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _zegoController.message
        .stream()
        .listen(_zegoMessageStreamController.sink.add);

    _zegoController.message.stream().listen(
      (event) async {
        _controller.showTopBanner = true;
        _zegoMessageStreamControllerTop.sink.add(event);
        await Future.delayed(const Duration(seconds: 06));
        _controller.showTopBanner = false;
        _zegoMessageStreamControllerTop.sink.add(event);
      },
    );

    _zegocloudSubscription = ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream()
        .listen(onInRoomCommandMessageReceived);

    _firebaseSubscription =
        FirebaseDatabase.instance.ref().child("live").onValue.listen(
      (event) {
        _controller.eventListner(
          event: event,
          zeroAstro: () async {
            if (mounted) {
              await _zegoController.leave(context);
            } else {}
          },
          engaging: (WaitListModel currentCaller) async {
            final String id = currentCaller.id;
            final String name = currentCaller.userName;
            final String avatar = currentCaller.avatar;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);

            WidgetsBinding.instance.endOfFrame.then(
              (_) async {
                if (mounted) {
                  await onCoHostRequest(
                    user: user,
                    userId: id,
                    userName: name,
                    avatar: avatar,
                  );
                } else {}
              },
            );
          },
          showFollowPopup: () {
            // WidgetsBinding.instance.endOfFrame.then(
            //   (_) async {
            //     if (mounted) {
            //       if (_controller.details.data?.isFollow == 0) {
            //         await Future.delayed(const Duration(seconds: 12));
            //         await exitPopup();
            //       } else {}
            //     } else {}
            //   },
            // );
          },
        );
      },
    );

    ZegoUIKit().getUserJoinStream().listen(onUserJoin);

    keyboardSubscription = keyboardVisibilityController.onChange.listen(
      (bool visible) {
        if (visible == false && _isKeyboardSheetOpen == true) {
          Navigator.of(context).pop();
        } else {}
      },
    );
  }

  Future<void> onUserJoin(List<ZegoUIKitUser> users) async {
    // final ZegoCustomMessage model = ZegoCustomMessage(
    //   type: 1,
    //   liveId: _controller.liveId,
    //   userId: _controller.userId,
    //   userName: _controller.userName,
    //   avatar: _controller.avatar,
    //   message: "${_controller.userName} Joined",
    //   timeStamp: DateTime.now().toString(),
    //   fullGiftImage: "",
    // );
    // await sendMessageToZego(model);
    Future<void>.value();
  }

  @override
  void dispose() {
    // keyboardSubscription.cancel();
    // unawaited(_zegoMessageStreamController.close());
    // unawaited(_zegoMessageStreamControllerTop.close());
    // unawaited(_zegocloudSubscription.cancel());
    // unawaited(_firebaseSubscription.cancel());
    // _editingController.dispose();
    // _scrollControllerForTop.dispose();
    // _scrollControllerForBottom.dispose();
    // WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        onPopInvoked: (pop) async {
          await exitFunc();
        },
        child: Obx(
          () {
            return _controller.liveId == ""
                ? const Center(child: CircularProgressIndicator())
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
                      ..audioVideoViewConfig = ZegoPrebuiltAudioVideoViewConfig(
                        showUserNameOnView: false,
                        showAvatarInAudioMode: true,
                        useVideoViewAspectFill: true,
                        showSoundWavesInAudioMode: true,
                      )
                      ..audioVideoViewConfig.playCoHostAudio = (
                        ZegoUIKitUser localUser,
                        ZegoLiveStreamingRole localRole,
                        ZegoUIKitUser coHost,
                      ) {
                        if (_controller.isHost) {
                        } else {
                          callJoinConfiguration();
                        }

                        final callType = _controller.currentCaller.callType;
                        //
                        if (callType == "private") {
                          if (ZegoLiveStreamingRole.host == localRole ||
                              ZegoLiveStreamingRole.coHost == localRole) {
                            return true;
                          }
                          return false;
                        }
                        return true;
                      }
                      ..audioVideoViewConfig.playCoHostVideo = (
                        ZegoUIKitUser localUser,
                        ZegoLiveStreamingRole localRole,
                        ZegoUIKitUser coHost,
                      ) {
                        if (_controller.isHost) {
                        } else {
                          callJoinConfiguration();
                        }

                        final callType = _controller.currentCaller.callType;
                        //
                        if (callType == "private" || callType == "audio") {
                          return false;
                        }
                        return true;
                      }
                      ..bottomMenuBarConfig = ZegoBottomMenuBarConfig(
                        showInRoomMessageButton: false,
                        hostButtons: <ZegoMenuBarButtonName>[],
                        coHostButtons: <ZegoMenuBarButtonName>[],
                      )
                      ..layout = galleryLayout()
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
                      )
                      ..slideSurfaceToHide = false
                      ..durationConfig.isVisible = false,
                    controller: _zegoController,
                    events: events,
                  );
          },
        ),
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

  ZegoLayout galleryLayout() {
    // final bool isEngaged = _controller.engagedCoHostWithAstro().isEngaded;
    // final String callType = _controller.engagedCoHostWithAstro().callType;
    final bool isEngaged = _controller.currentCaller.isEngaded;
    final String callType = _controller.currentCaller.callType;
    return isEngaged == true && callType == "video"
        ? ZegoLayout.gallery()
        : ZegoLayout.pictureInPicture(smallViewSize: const Size(0, 0));
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomImageWidget(
        imageUrl: zegoUser == mineUser
            ? _controller.avatar
            // : zegoUser == astroUser
            //     ? (_controller.details.data?.image ?? "")
            : "https://robohash.org/avatarWidget",
        rounded: true,
      ),
    );
  }

  ZegoLiveStreamingSwipingConfig? get swipingConfig {
    return _controller.isHost
        ? null
        : ZegoLiveStreamingSwipingConfig(
            //
            requirePreviousLiveID: () => "",
            //
            //
            //
            requireNextLiveID: () => "",
            //
          );
  }

  Widget foregroundWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight - 16.0),
      child: Column(
        children: <Widget>[
          appBarWidget(),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 8),
                Expanded(child: inRoomMessage()),
                const SizedBox(width: 8),
                //
                verticalDefault(),
                //
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // horizontalGiftBar(ctx: context),
          // const SizedBox(height: 8),
          newUI(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget appBarWidget() {
    return SizedBox(
      height: 32 + 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          backbtn(),
          Column(
            children: [
              newLeaderboard(),
              const SizedBox(height: 32),
              inRoomMessageTop(),
            ],
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _controller.isHost,
            child: settingsRowForAstro(),
          ),
        ],
      ),
    );
  }

  Widget newLeaderboard() {
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
              : LeaderBoardWidget(
                  avatar: _controller.leaderboardModel.first.avatar,
                  userName: _controller.leaderboardModel.first.userName,
                  fullGiftImage: "",
                ),
        );
      },
    );
  }

  // Widget horizontalGiftBar({required BuildContext ctx}) {
  //   final List<GiftData> tempData = [...GiftsSingleton().gifts.data ?? []];
  //   final GiftData emptyGiftIbject = GiftData(
  //     id: 0,
  //     giftName: "",
  //     giftImage: "",
  //     giftPrice: 0,
  //     giftStatus: 0,
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     fullGiftImage: "",
  //     animation: "",
  //   );
  //   if (tempData[0].id != 0) {
  //     tempData.insert(0, emptyGiftIbject);
  //   } else {}
  //   if (tempData[1].id != 0) {
  //     tempData.insert(1, emptyGiftIbject);
  //   } else {}
  //   return SizedBox(
  //     height: 50,
  //     child: ListView.builder(
  //       padding: EdgeInsets.zero,
  //       itemCount: tempData.length,
  //       scrollDirection: Axis.horizontal,
  //       cacheExtent: tempData.length.toDouble(),
  //       itemBuilder: (BuildContext context, int index) {
  //         final GiftData item = tempData[index];
  //         var offerData = _controller.details.data?.offerData ?? OfferData();
  //         return index == 0
  //             ? Padding(
  //                 padding: EdgeInsets.only(
  //                   left: index == 0 ? 8.0 : 16.0,
  //                   right: _controller.details.data?.isFollow == 0 ? 0 : 8.0,
  //                 ),
  //                 child: InkWell(
  //                   onTap: () async {
  //                     await Get.toNamed(
  //                       RouteName.paymentSummary,
  //                       arguments: CommonOffer(
  //                         extraAmount: offerData.extra_amount,
  //                         offerAmount: offerData.offer_amount,
  //                         percentage: offerData.percentage,
  //                         rechargeAmount: offerData.recharge_amount,
  //                       ),
  //                     );
  //                   },
  //                   child: SizedBox(
  //                     height: 50,
  //                     width: 100,
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(vertical: 4.0),
  //                       decoration: BoxDecoration(
  //                         borderRadius: const BorderRadius.all(
  //                           Radius.circular(10.0),
  //                         ),
  //                         border: Border.all(
  //                           color: AppColors.yellow,
  //                         ),
  //                         color: AppColors.black.withOpacity(0.2),
  //                       ),
  //                       child: Row(
  //                         children: <Widget>[
  //                           const SizedBox(width: 8),
  //                           SizedBox(
  //                             height: 24,
  //                             width: 24,
  //                             child: Image.asset(
  //                               "assets/images/live_new_money.png",
  //                             ),
  //                           ),
  //                           const SizedBox(width: 8),
  //                           Flexible(
  //                             child: Row(
  //                               children: [
  //                                 Flexible(
  //                                   child: Column(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           const Text(
  //                                             "Pay ",
  //                                             style: TextStyle(
  //                                               fontSize: 10,
  //                                               color: Colors.white,
  //                                             ),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                           Text(
  //                                             "₹${offerData.recharge_amount ?? 0}",
  //                                             style: const TextStyle(
  //                                               fontSize: 10,
  //                                               color: Colors.white,
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                           const Text(
  //                                             ",",
  //                                             style: TextStyle(
  //                                               fontSize: 10,
  //                                               color: Colors.white,
  //                                             ),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           const Text(
  //                                             "Get ",
  //                                             style: TextStyle(
  //                                               fontSize: 10,
  //                                               color: Colors.white,
  //                                             ),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                           Text(
  //                                             "₹${offerData.offer_amount ?? 0}",
  //                                             style: const TextStyle(
  //                                               fontSize: 10,
  //                                               color: AppColors.yellow,
  //                                               fontWeight: FontWeight.bold,
  //                                             ),
  //                                             overflow: TextOverflow.ellipsis,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           const SizedBox(width: 8),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             : index == 1
  //                 ? (_controller.details.data?.isFollow == 1)
  //                     ? const SizedBox()
  //                     : Padding(
  //                         padding:
  //                             const EdgeInsets.only(left: 16.0, right: 16.0),
  //                         child: InkWell(
  //                           onTap: () async {
  //                             if (_controller.details.data?.isFollow == 0) {
  //                               final ZegoCustomMessage model =
  //                                   ZegoCustomMessage(
  //                                 type: 1,
  //                                 liveId: _controller.liveId,
  //                                 userId: _controller.userId,
  //                                 userName: _controller.userName,
  //                                 avatar: _controller.avatar,
  //                                 message:
  //                                     "${_controller.userName} Started following",
  //                                 timeStamp: DateTime.now().toString(),
  //                                 fullGiftImage: item.fullGiftImage,
  //                               );
  //                               await sendMessageToZego(model);
  //                             } else {}
  //                             await _controller.followOrUnfollowAstrologer();
  //                             await _controller.getAstrologerDetails();
  //                           },
  //                           child: SizedBox(
  //                             height: 52,
  //                             width: 52,
  //                             child: DecoratedBox(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: const BorderRadius.all(
  //                                   Radius.circular(50.0),
  //                                 ),
  //                                 border: Border.all(
  //                                   color: Colors.transparent,
  //                                 ),
  //                                 color: Colors.transparent,
  //                               ),
  //                               child: Column(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: <Widget>[
  //                                   Image.asset(
  //                                     height: 32,
  //                                     width: 32,
  //                                     _controller.details.data?.isFollow == 1
  //                                         ? "assets/images/live_new_follower_button.png"
  //                                         : "assets/images/live_new_follower_button.png",
  //                                   ),
  //                                   const SizedBox(height: 4),
  //                                   const Text(
  //                                     "Follow",
  //                                     style: TextStyle(
  //                                       fontSize: 10,
  //                                       color: AppColors.white,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                 : Padding(
  //                     padding: EdgeInsets.only(
  //                       left: _controller.details.data?.isFollow == 0 ? 0 : 8.0,
  //                       right: (tempData.length - 1 == index) ? 8.0 : 16.0,
  //                     ),
  //                     child: InkWell(
  //                       onTap: () async {
  //                         await sendGiftFunc(ctx: ctx, item: item, quantity: 1);
  //                       },
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //                           SizedBox(
  //                             height: 32,
  //                             width: 32,
  //                             child: CustomImageWidget(
  //                               imageUrl: item.fullGiftImage,
  //                               rounded: false,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             "₹${item.giftPrice}",
  //                             style: const TextStyle(
  //                               fontSize: 10,
  //                               color: AppColors.white,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //       },
  //     ),
  //   );
  // }

  // Future<void> sendGiftFunc({
  //   required BuildContext ctx,
  //   required GiftData item,
  //   required num quantity,
  // }) async {
  //   final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
  //   if (hasMyIdInWaitList) {
  //     await alreadyInTheWaitListDialog();
  //   } else {
  //     final bool hasBal = await _controller.hasBalanceForSendingGift(
  //       giftId: item.id,
  //       giftName: item.giftName,
  //       giftQuantity: int.parse(quantity.toString()),
  //       giftAmount: item.giftPrice,
  //       needRecharge: (bal.InsufficientBalModel balModel) async {
  //         await lowBalancePopup(
  //           balModel: balModel,
  //           callbackBalModelData: (data) async {
  //             await Get.toNamed(
  //               RouteName.paymentSummary,
  //               arguments: CommonOffer(
  //                 extraAmount: data.extraAmount,
  //                 offerAmount: data.offerAmount,
  //                 percentage: data.percentage?.toInt(),
  //                 rechargeAmount: data.rechargeAmount,
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //     if (hasBal) {
  //       if (mounted) {
  //         ZegoGiftPlayer().play(
  //           ctx,
  //           GiftPlayerData(GiftPlayerSource.url, item.animation),
  //         );
  //       } else {}
  //       var data = {
  //         "room_id": _controller.liveId,
  //         "user_id": _controller.userId,
  //         "user_name": _controller.userName,
  //         "item": item.toJson(),
  //         "type": "",
  //       };
  //       await _controller.sendGiftAPI(
  //         data: data,
  //         count: quantity,
  //         svga: item.animation,
  //         successCallback: log,
  //         failureCallback: log,
  //       );
  //       await _controller.addUpdateLeaderboard(
  //         quantity: quantity,
  //         amount: item.giftPrice,
  //       );
  //       final ZegoCustomMessage model0 = ZegoCustomMessage(
  //         type: 0,
  //         liveId: _controller.liveId,
  //         userId: _controller.userId,
  //         userName: _controller.userName,
  //         avatar: _controller.avatar,
  //         message: quantity > 1
  //             ? "${_controller.userName} sent a ${item.giftName} ${quantity}X"
  //             : "${_controller.userName} sent a ${item.giftName}",
  //         timeStamp: DateTime.now().toString(),
  //         fullGiftImage: item.fullGiftImage,
  //       );
  //       await sendMessageToZego(model0);

  //       await Future.delayed(const Duration(seconds: 1));

  //       final ZegoCustomMessage model1 = ZegoCustomMessage(
  //         type: 1,
  //         liveId: _controller.liveId,
  //         userId: _controller.userId,
  //         userName: _controller.userName,
  //         avatar: _controller.avatar,
  //         message: quantity > 1
  //             ? "${_controller.userName} sent a ${item.giftName} (${quantity}X)"
  //             : "${_controller.userName} sent a ${item.giftName}",
  //         timeStamp: DateTime.now().toString(),
  //         fullGiftImage: item.fullGiftImage,
  //       );
  //       await sendMessageToZego(model1);
  //     } else {}
  //   }
  //   return Future<void>.value();
  // }

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
          itemCount:
              messages.isNotEmpty && messages.length >= 5 ? 5 : messages.length,
          controller: _scrollControllerForBottom,
          itemBuilder: (BuildContext context, int index) {
            final ZegoInRoomMessage message = messages[index];
            final ZegoCustomMessage msg = receiveMessageToZego(message.message);
            return msg.type == 0
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      color: Colors.transparent,
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: CustomImageWidget(
                            imageUrl: msg.avatar ?? "",
                            rounded: true,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.userName ?? "",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      msg.message ?? "",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    size: 16,
                                    color: AppColors.yellow,
                                  ),
                                  onPressed: () async {
                                    await moreOptionsPopup(
                                      userId: msg.userId ?? "",
                                      userName: msg.userName ?? "",
                                      isBlocked: _controller.isBlocked(
                                        id: int.parse(msg.userId ?? ""),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }

  Widget inRoomMessageTop() {
    return StreamBuilder<List<ZegoInRoomMessage>>(
      stream: _zegoMessageStreamControllerTop.stream.asBroadcastStream(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ZegoInRoomMessage>> snapshot,
      ) {
        List<ZegoInRoomMessage> messages =
            snapshot.data ?? <ZegoInRoomMessage>[];
        messages = messages.reversed.toList();
        return AnimatedOpacity(
          opacity: !_controller.showTopBanner ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: messages.isEmpty
              ? const SizedBox()
              : Transform.scale(
                  scale: 1.50,
                  child: SizedBox(
                    height: 32,
                    width: Get.width / 3,
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: messages.isNotEmpty && messages.length >= 1
                          ? 1
                          : messages.length,
                      controller: _scrollControllerForTop,
                      itemBuilder: (BuildContext context, int index) {
                        final ZegoInRoomMessage message = messages[index];
                        final ZegoCustomMessage msg =
                            receiveMessageToZego(message.message);
                        return msg.type == 1
                            ? const SizedBox()
                            : LeaderBoardWidget(
                                avatar: msg.avatar ?? "",
                                userName: msg.userName ?? "",
                                fullGiftImage: msg.fullGiftImage ?? "",
                              );
                      },
                    ),
                  ),
                ),
        );
      },
    );
  }

  // Widget callStack() {
  //   String singleColumn0 = "";
  //   String doubleColumn1 = "";
  //   String doubleColumn2 = "";
  //   String doubleColumn3 = "";

  //   final Data data = _controller.details.data ?? Data();
  //   final OfferDetails offerDetails = data.offerDetails ?? OfferDetails();
  //   final bool isOfferAvailable = offerDetails.offerId != null;

  //   final int videoOriginal = data.videoCallAmount ?? 0;
  //   final int audioOriginal = data.audioCallAmount ?? 0;
  //   final int privateOriginal = data.anonymousCallAmount ?? 0;

  //   final List<int> originalList = [
  //     videoOriginal,
  //     audioOriginal,
  //     privateOriginal,
  //   ];
  //   originalList.sort(
  //     (a, b) {
  //       return a.compareTo(b);
  //     },
  //   );

  //   if (isOfferAvailable) {
  //     if (offerDetails.specialOfferText != null) {
  //       doubleColumn1 = offerDetails.specialOfferText ?? "";
  //       doubleColumn2 = offerDetails.offerText ?? "";
  //       doubleColumn3 = originalList.first.toString();
  //     } else {
  //       doubleColumn1 = offerDetails.offerText ?? "";
  //       doubleColumn2 = originalList.first.toString();
  //     }
  //   } else {
  //     singleColumn0 = originalList.first.toString();
  //   }

  //   if (isOfferAvailable) {
  //     if (offerDetails.specialOfferText != null) {
  //       return Column(
  //         children: <Widget>[
  //           Text(
  //             doubleColumn1,
  //             style: const TextStyle(
  //               fontSize: 8,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.red,
  //             ),
  //           ),
  //           Text(
  //             doubleColumn2,
  //             style: const TextStyle(
  //               fontSize: 8,
  //             ),
  //           ),
  //           Text(
  //             "₹$doubleColumn3/Min",
  //             style: const TextStyle(
  //               fontSize: 8,
  //               decoration: TextDecoration.lineThrough,
  //               decorationColor: Colors.red,
  //             ),
  //           ),
  //         ],
  //       );
  //     } else {
  //       return Column(
  //         children: <Widget>[
  //           Text(
  //             doubleColumn1,
  //             style: const TextStyle(
  //               fontSize: 8,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             "₹$doubleColumn2/Min",
  //             style: const TextStyle(
  //               fontSize: 8,
  //               decoration: TextDecoration.lineThrough,
  //               decorationColor: Colors.red,
  //             ),
  //           ),
  //         ],
  //       );
  //     }
  //   } else {
  //     return Column(
  //       children: [
  //         Text(
  //           "₹$singleColumn0/Min",
  //           style: const TextStyle(
  //             fontSize: 8,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     );
  //   }

  //   // return (isOfferAvailable)
  //   //     ? Column(
  //   //         children: <Widget>[
  //   //           Text(
  //   //             doubleColumn1,
  //   //             style: const TextStyle(
  //   //               fontSize: 10,
  //   //               fontWeight: FontWeight.bold,
  //   //             ),
  //   //           ),
  //   //           const SizedBox(width: 4.0),
  //   //           Text(
  //   //             "₹$doubleColumn2/Min",
  //   //             style: const TextStyle(
  //   //               fontSize: 10,
  //   //               decoration: TextDecoration.lineThrough,
  //   //               decorationColor: Colors.red,
  //   //             ),
  //   //           ),
  //   //         ],
  //   //       )
  //   //     : Column(
  //   //         children: <Widget>[
  //   //           const SizedBox(height: 4.0),
  //   //           Text(
  //   //             "₹$singleColumn0/Min",
  //   //             style: const TextStyle(
  //   //               fontSize: 10,
  //   //               fontWeight: FontWeight.bold,
  //   //             ),
  //   //           ),
  //   //         ],
  //   //       );
  // }

  Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
    if (state == ZegoLiveStreamingState.idle) {
      ZegoGiftPlayer().clear();
    } else {}
    return Future<void>.value();
  }

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

  Future<void> youAreInTheWaitListDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "You're in the Wait List",
          ),
          content: Text(
            "You are not able to perform this action because you're the Wait List of Astrologer ${_controller.userName}.",
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

  Future<void> giftPopup({
    required BuildContext ctx,
    required String userId,
    required String userName,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return GiftWidget(
          onClose: Get.back,
          list: GiftsSingleton().gifts.data ?? <GiftData>[],
          onSelect: (GiftData item, num quantity) async {
            Get.back();
            if (_controller.isHost) {
              await sendGiftFuncAstro(
                ctx: ctx,
                item: item,
                quantity: quantity,
                userId: userId,
                userName: userName,
              );
            } else {
              // await sendGiftFunc(ctx: ctx, item: item, quantity: quantity);
            }
          },
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> sendGiftFuncAstro({
    required BuildContext ctx,
    required GiftData item,
    required num quantity,
    required String userId,
    required String userName,
  }) async {
    var data = {
      "room_id": _controller.liveId,
      "user_id": userId,
      "user_name": userName,
      "item": item.toJson(),
      "type": "Ask For Gift",
    };
    await _controller.sendGiftAPI(
      data: data,
      count: quantity,
      svga: "",
      successCallback: log,
      failureCallback: log,
    );
    return Future<void>.value();
  }

  Future<void> leaderboardPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LeaderboardWidget(
          onClose: Get.back,
          liveId: _controller.liveId,
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> waitListPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        // return WaitListWidget(
        return AstroWaitListWidget(
          onClose: Get.back,
          waitTime: _controller.getTotalWaitTime(),
          myUserId: _controller.userId,
          list: _controller.waitListModel,
          hasMyIdInWaitList: false,
          onExitWaitList: () async {
            Get.back();
            await exitWaitListPopup(
              noDisconnect: () {},
              yesDisconnect: () async {
                if (!_controller.isHost) {
                  await _controller.removeFromWaitList();
                } else {}
              },
            );
          },
          astologerName: _controller.userName,
          astologerImage: _controller.avatar,
          astologerSpeciality: _controller.hostSpeciality,
          isHost: _controller.isHost,
          onAccept: () async {
            Get.back();
            final String id = _controller.waitListModel.last.id;
            final String name = _controller.waitListModel.last.userName;
            final String avatar = _controller.waitListModel.last.avatar;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);
            final connectInvite = _zegoController.connectInvite;
            await connectInvite.hostSendCoHostInvitationToAudience(user);
          },
          onReject: Get.back,
          model: _controller.currentCaller,
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
          custoAvatar: _controller.currentCaller.avatar,
          custoUserName: _controller.currentCaller.userName,
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> exitWaitListPopup({
    required Function() noDisconnect,
    required Function() yesDisconnect,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ExitWaitListWidget(
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
          custoAvatar: _controller.currentCaller.avatar,
          custoUserName: _controller.currentCaller.userName,
        );
      },
    );
    return Future<void>.value();
  }

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
  //           if (_controller.details.data?.isFollow == 0) {
  //             await _controller.followOrUnfollowAstrologer();
  //           } else {}
  //         },
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  Future<void> endLiveSession({required void Function() endLive}) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return EndSessionWidget(
          onClose: Get.back,
          continueLive: Get.back,
          endLive: () {
            Get.back();
            endLive();
          },
        );
      },
    );
    return Future<void>.value();
  }

  // Future<void> lowBalancePopup({
  //   required bal.InsufficientBalModel balModel,
  //   required Function(bal.Data data) callbackBalModelData,
  // }) async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return LowBalanceWidget(
  //         onClose: Get.back,
  //         balModel: balModel,
  //         callbackBalModelData: (bal.Data data) {
  //           Get.back();
  //           callbackBalModelData(data);
  //         },
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
  //         onSelect: (String type) async {
  //           Get.back();
  //           await sendCallFunc(
  //             type: type,
  //             needRecharge: (bal.InsufficientBalModel balModel) async {
  //               await lowBalancePopup(
  //                 balModel: balModel,
  //                 callbackBalModelData: (data) async {
  //                   final CommonOffer arg = CommonOffer(
  //                     extraAmount: data.extraAmount,
  //                     offerAmount: data.offerAmount,
  //                     percentage: data.percentage?.toInt(),
  //                     rechargeAmount: data.rechargeAmount,
  //                   );
  //                   await Get.toNamed(RouteName.paymentSummary, arguments: arg);
  //                 },
  //               );
  //             },
  //           );
  //         },
  //         list: _controller.waitListModel,
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // Future<void> sendCallFunc({
  //   required String type,
  //   required dynamic Function(bal.InsufficientBalModel) needRecharge,
  // }) async {
  //   final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
  //   if (hasMyIdInWaitList) {
  //     await alreadyInTheWaitListDialog();
  //   } else {
  //     final bool canOrder = await _controller.canPlaceLiveOrder(
  //       talkType: type,
  //       needRecharge: needRecharge,
  //     );
  //     if (canOrder) {
  //       await _controller.addUpdateToWaitList(
  //         userId: _controller.userId,
  //         callType: type,
  //         isEngaded: false,
  //         isRequest: false,
  //       );
  //     } else {}
  //   }
  //   return Future<void>.value();
  // }

  Future<void> moreOptionsPopup({
    required String userId,
    required String userName,
    required bool isBlocked,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        var item = GiftData(
          id: 0,
          giftName: "",
          giftImage: "",
          giftPrice: 0,
          giftStatus: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          fullGiftImage: "",
          animation: "",
        );

        return MoreOptionsWidget(
          onClose: Get.back,
          isHost: _controller.isHost,
          onTapAskForGifts: () async {
            Get.back();
            await giftPopup(ctx: context, userId: userId, userName: userName);
          },
          onTapAskForVideoCall: () async {
            Get.back();
            var data = {
              "room_id": _controller.liveId,
              "user_id": userId,
              "user_name": userName,
              "item": item.toJson(),
              "type": "Ask For Video Call",
            };
            await _controller.sendGiftAPI(
              data: data,
              count: 1,
              svga: "",
              successCallback: log,
              failureCallback: log,
            );
            await _controller.addUpdateToWaitList(
              userId: userId,
              callType: "Video",
              isEngaded: false,
              isRequest: true,
            );
            final String id = userId;
            final String name = userName;
            // final String avatar = _controller.waitListModel.last.avatar;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);
            final connectInvite = _zegoController.connectInvite;
            await connectInvite.hostSendCoHostInvitationToAudience(user);
          },
          onTapAskForAudioCall: () async {
            Get.back();
            var data = {
              "room_id": _controller.liveId,
              "user_id": userId,
              "user_name": userName,
              "item": item.toJson(),
              "type": "Ask For Voice Call",
            };
            await _controller.sendGiftAPI(
              data: data,
              count: 1,
              svga: "",
              successCallback: log,
              failureCallback: log,
            );
            await _controller.addUpdateToWaitList(
              userId: userId,
              callType: "Audio",
              isEngaded: false,
              isRequest: true,
            );
            final String id = userId;
            final String name = userName;
            // final String avatar = _controller.waitListModel.last.avatar;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);
            final connectInvite = _zegoController.connectInvite;
            await connectInvite.hostSendCoHostInvitationToAudience(user);
          },
          onTapAskForPrivateCall: () async {
            Get.back();
            var data = {
              "room_id": _controller.liveId,
              "user_id": userId,
              "user_name": userName,
              "item": item.toJson(),
              "type": "Ask For Private Call",
            };
            await _controller.sendGiftAPI(
              data: data,
              count: 1,
              svga: "",
              successCallback: log,
              failureCallback: log,
            );
            await _controller.addUpdateToWaitList(
              userId: userId,
              callType: "Private",
              isEngaded: false,
              isRequest: true,
            );
            final String id = userId;
            final String name = userName;
            // final String avatar = _controller.waitListModel.last.avatar;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);
            final connectInvite = _zegoController.connectInvite;
            await connectInvite.hostSendCoHostInvitationToAudience(user);
          },
          onTapAskForBlockUnBlockUser: () async {
            Get.back();
            await _controller.callblockCustomer(id: int.parse(userId));
            var data = {
              "room_id": _controller.liveId,
              "user_id": userId,
              "user_name": userName,
              "item": item.toJson(),
              "type": "Block/Unblock",
            };
            await _controller.sendGiftAPI(
              data: data,
              count: 1,
              svga: "",
              successCallback: log,
              failureCallback: log,
            );
          },
          isBlocked: isBlocked,
        );
      },
    );
    return Future<void>.value();
  }

  // Future<void> onInRoomCommandMessageReceived(
  //   ZegoSignalingPluginInRoomCommandMessageReceivedEvent event,
  // ) async {
  //   final List<ZegoSignalingPluginInRoomCommandMessage> msgs = event.messages;
  //   for (final ZegoSignalingPluginInRoomCommandMessage commandMessage in msgs) {
  //     final String senderUserID = commandMessage.senderUserID;
  //     final String message = utf8.decode(commandMessage.message);
  //     final Map<String, dynamic> decodedMessage = jsonDecode(message);

  //     // final String svga = decodedMessage["gift_type"];
  //     final String roomId = decodedMessage["room_id"];
  //     final num giftCount = decodedMessage["gift_count"];

  //     final animation = decodedMessage["gift_type"]["item"]["animation"];
  //     print("decodedMessage: $animation");

  //     if (senderUserID != _controller.userId) {
  //       if (roomId == _controller.liveId) {
  //         for (int i = 0; i < giftCount; i++) {
  //           ZegoGiftPlayer().play(
  //             context,
  //             GiftPlayerData(GiftPlayerSource.url, animation),
  //           );
  //         }
  //       } else {}
  //     } else {}
  //   }
  //   return Future<void>.value();
  // }

  Future<void> onInRoomCommandMessageReceived(
    ZegoSignalingPluginInRoomCommandMessageReceivedEvent event,
  ) async {
    final List<ZegoSignalingPluginInRoomCommandMessage> msgs = event.messages;
    for (final ZegoSignalingPluginInRoomCommandMessage commandMessage in msgs) {
      final String senderUserID = commandMessage.senderUserID;
      final String message = utf8.decode(commandMessage.message);
      final Map<String, dynamic> decodedMessage = jsonDecode(message);
      // final int appId = decodedMessage["app_id"];
      // final String serverSecret = decodedMessage["server_secret"];
      final String roomId = decodedMessage["room_id"];
      final String userId = decodedMessage["user_id"];
      final String userName = decodedMessage["user_name"];
      final Map<String, dynamic> giftType = decodedMessage["gift_type"];
      final Map<String, dynamic> item = decodedMessage["gift_type"]["item"];
      final String type = decodedMessage["gift_type"]["type"];
      final num giftCount = decodedMessage["gift_count"];
      // final String accessToken = decodedMessage["access_token"];
      // final int timestamp = decodedMessage["timestamp"];
      if (senderUserID != _controller.userId) {
        if (roomId == _controller.liveId) {
          if (type == "") {
            if (mounted) {
              ZegoGiftPlayer().play(
                context,
                GiftPlayerData(GiftPlayerSource.url, item["animation"]),
              );
            } else {}
          } else if (type == "Ask For Gift") {
            // await commonRequest(type: type, item: item, giftCount: giftCount);
          } else if (type == "Ask For Video Call") {
            // await commonRequest(type: type, item: item, giftCount: giftCount);
          } else if (type == "Ask For Voice Call") {
            // await commonRequest(type: type, item: item, giftCount: giftCount);
          } else if (type == "Ask For Private Call") {
            // await commonRequest(type: type, item: item, giftCount: giftCount);
          } else if (type == "Block/Unblock") {
            // await _controller.isCustomerBlocked();
          } else {}
        } else {}
      } else {}
    }
    return Future<void>.value();
  }

  // Future<void> commonRequest({
  //   required String type,
  //   required Map<String, dynamic> item,
  //   required num giftCount,
  // }) async {
  //   WidgetsBinding.instance.endOfFrame.then(
  //     (_) async {
  //       if (mounted) {
  //         await requestPopup(
  //           ctx: context,
  //           type: type,
  //           giftData: GiftData.fromJson(item),
  //           giftCount: giftCount,
  //         );
  //       } else {}
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // Future<void> requestPopup({
  //   required BuildContext ctx,
  //   required String type,
  //   required GiftData giftData,
  //   required num giftCount,
  // }) async {
  //   await showCupertinoDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return RequestPopupWidget(
  //         onClose: Get.back,
  //         details: _controller.details,
  //         speciality: _controller.getSpeciality(),
  //         type: type,
  //         onTapAcceptForGifts: () async {
  //           Get.back();
  //           await sendGiftFunc(ctx: ctx, item: giftData, quantity: giftCount);
  //         },
  //         onTapAcceptForVideoCall: () async {
  //           Get.back();
  //           final connectInvite = _zegoController.connectInvite;
  //           await _controller.makeAPICallForStartCall(hasAccepted: true);
  //           await connectInvite.audienceAgreeCoHostInvitation();
  //         },
  //         onTapAcceptForAudioCall: () async {
  //           Get.back();
  //           final connectInvite = _zegoController.connectInvite;
  //           await _controller.makeAPICallForStartCall(hasAccepted: true);
  //           await connectInvite.audienceAgreeCoHostInvitation();
  //         },
  //         onTapAcceptForPrivateCall: () async {
  //           Get.back();
  //           final connectInvite = _zegoController.connectInvite;
  //           await _controller.makeAPICallForStartCall(hasAccepted: true);
  //           await connectInvite.audienceAgreeCoHostInvitation();
  //         },
  //         giftData: giftData,
  //         giftCount: giftCount,
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // Future<void> youAreBlocked() async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           "You're Blocked by Astrologer ${_controller.details.data?.name ?? ""}",
  //         ),
  //         content: Text(
  //           "You are not able to perform this action because you're blocked by Astrologer ${_controller.details.data?.name ?? ""}.",
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

  void scrollDownForTop() {
    final double maxScr = _scrollControllerForTop.position.maxScrollExtent;
    _scrollControllerForTop.jumpTo(maxScr);
    return;
  }

  void scrollDownForBottom() {
    final double maxScr = _scrollControllerForBottom.position.maxScrollExtent;
    _scrollControllerForBottom.jumpTo(maxScr);
    return;
  }

  Widget newAppBarLeft() {
    return InkWell(
      onTap: keyboardPop,
      child: SizedBox(
        height: 50,
        width: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: AppColors.yellow,
            ),
            color: AppColors.black.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/live_new_chat_icon.png",
            ),
          ),
        ),
      ),
    );
  }

  Widget newAppBarCenter() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: AppColors.yellow,
            ),
            color: AppColors.black.withOpacity(0.2),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              InkWell(
                onTap: navigate,
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CustomImageWidget(
                    imageUrl: _controller.avatar,
                    rounded: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: navigate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _controller.userName,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _controller.getSpeciality(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  // _controller.isCustBlocked.data?.isCustomerBlocked == 1
                  //     ? await youAreBlocked()
                  //     : await callAstrologerPopup();
                },
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                      border: Border.all(
                        color: AppColors.yellow,
                      ),
                      color: AppColors.black.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset(
                        "assets/images/live_new_plus_icon.png",
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget newAppBarCenterWithCall() {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: AppColors.yellow,
            ),
            color: AppColors.black.withOpacity(0.2),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              InkWell(
                onTap: navigate,
                child: SizedBox(
                  height: 32,
                  width: 52,
                  child: stacked(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: navigate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_controller.userName} with ${_controller.currentCaller.userName}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            "${_controller.currentCaller.callType.capitalize ?? ""} Call:",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8),
                          newTimerWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget newAppBarRight() {
    return InkWell(
      onTap: () async {
        // await giftPopup(
        //   ctx: context,
        //   userId: _controller.userId,
        //   userName: _controller.userName,
        // );
      },
      child: SizedBox(
        height: 50,
        width: 50,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            border: Border.all(
              color: AppColors.yellow,
            ),
            color: AppColors.black.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/live_new_gift_latest.png",
            ),
          ),
        ),
      ),
    );
  }

  Widget newTimerWidget() {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      timeTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      endTime: DateTime.now().add(
        Duration(
          days: 0,
          hours: 0,
          minutes: int.parse(_controller.currentCaller.totalTime ?? "0"),
          seconds: 0,
        ),
      ),
      onEnd: () async {
        final bool isEngaded = _controller.currentCaller.isEngaded;
        if (isEngaded) {
        } else {
          await removeCoHostOrStopCoHost();
        }
      },
    );
  }

  Widget stacked() {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 32,
          width: 32,
          child: CustomImageWidget(
            imageUrl: _controller.avatar,
            rounded: true,
          ),
        ),
        Positioned(
          left: 20.0,
          child: SizedBox(
            height: 32,
            width: 32,
            child: CustomImageWidget(
              imageUrl: _controller.currentCaller.avatar,
              rounded: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget newUI() {
    return Row(
      children: [
        const SizedBox(width: 8),
        newAppBarLeft(),
        const SizedBox(width: 8),
        _controller.currentCaller.isEngaded
            ? newAppBarCenterWithCall()
            : newAppBarCenter(),
        const SizedBox(width: 8),
        newAppBarRight(),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget settingsRowForAstro() {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () async {
                final ZegoUIKit instance = ZegoUIKit.instance;
                _controller.isFront = !_controller.isFront;
                instance.useFrontFacingCamera(_controller.isFront);
              },
              child: SizedBox(
                height: 32,
                width: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    border: Border.all(
                      color: AppColors.yellow,
                    ),
                    color: AppColors.black.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      _controller.isFront
                          ? "assets/images/live_switch_cam_new.png"
                          : "assets/images/live_switch_cam_new.png",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final ZegoUIKit instance = ZegoUIKit.instance;
                _controller.isCamOn = !_controller.isCamOn;
                instance.turnCameraOn(_controller.isCamOn);
              },
              child: SizedBox(
                height: 32,
                width: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    border: Border.all(
                      color: AppColors.yellow,
                    ),
                    color: AppColors.black.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      _controller.isCamOn
                          ? "assets/images/live_cam_on.png"
                          : "assets/images/live_cam_off.png",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                final ZegoUIKit instance = ZegoUIKit.instance;
                _controller.isMicOn = !_controller.isMicOn;
                instance.turnMicrophoneOn(_controller.isMicOn);
              },
              child: SizedBox(
                height: 32,
                width: 32,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    border: Border.all(
                      color: AppColors.yellow,
                    ),
                    color: AppColors.black.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      _controller.isMicOn
                          ? "assets/images/live_mic_on.png"
                          : "assets/images/live_mic_off.png",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 0),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  callJoinConfiguration() {
    final bool isEngaded = _controller.currentCaller.isEngaded;
    final String type = _controller.currentCaller.callType;
    final bool condForVideoCall = isEngaded && type == "video";
    final bool condForAudioCall =
        isEngaded && (type == "private" || type == "audio");

    final ZegoUIKit instance = ZegoUIKit.instance;

    if (condForVideoCall) {
      if (_controller.isFront == false) {
        _controller.isFront = true;
        instance.useFrontFacingCamera(true);
      } else {}
      if (_controller.isCamOn == false) {
        _controller.isCamOn = true;
        instance.turnCameraOn(true);
      } else {}
      if (_controller.isMicOn == false) {
        _controller.isMicOn = true;
        instance.turnMicrophoneOn(true);
      } else {}
    } else {}

    if (condForAudioCall) {
      if (_controller.isFront == true) {
        _controller.isFront = false;
        instance.useFrontFacingCamera(false);
      } else {}
      if (_controller.isCamOn == true) {
        _controller.isCamOn = false;
        instance.turnCameraOn(false);
      } else {}
      if (_controller.isMicOn == false) {
        _controller.isMicOn = true;
        instance.turnMicrophoneOn(true);
      } else {}
    } else {}
  }

  Widget settingsColForCust() {
    final bool isEngaded = _controller.currentCaller.isEngaded;
    final String type = _controller.currentCaller.callType;
    final bool condForVideoCall = isEngaded && type == "video";
    final bool condForAudioCall =
        isEngaded && (type == "private" || type == "audio");

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedOpacity(
          opacity: false ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: false
              ? const SizedBox()
              : Column(
                  children: [
                    InkWell(
                      onTap: exitFunc,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            border: Border.all(
                              color: AppColors.yellow,
                            ),
                            color: AppColors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              _controller.currentCaller.isEngaded
                                  ? "assets/images/live_new_hang_up.png"
                                  : "assets/images/live_exit_red.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
        AnimatedOpacity(
          opacity: !condForVideoCall ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: !condForVideoCall
              ? const SizedBox()
              : Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final ZegoUIKit instance = ZegoUIKit.instance;
                        _controller.isFront = !_controller.isFront;
                        instance.useFrontFacingCamera(_controller.isFront);
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            border: Border.all(
                              color: AppColors.yellow,
                            ),
                            color: AppColors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              _controller.isFront
                                  ? "assets/images/live_switch_cam_new.png"
                                  : "assets/images/live_switch_cam_new.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
        AnimatedOpacity(
          opacity: !condForVideoCall ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: !condForVideoCall
              ? const SizedBox()
              : Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final ZegoUIKit instance = ZegoUIKit.instance;
                        _controller.isCamOn = !_controller.isCamOn;
                        instance.turnCameraOn(_controller.isCamOn);
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            border: Border.all(
                              color: AppColors.yellow,
                            ),
                            color: AppColors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              _controller.isCamOn
                                  ? "assets/images/live_cam_on.png"
                                  : "assets/images/live_cam_off.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
        AnimatedOpacity(
          opacity: !(condForVideoCall || condForAudioCall) ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: !(condForVideoCall || condForAudioCall)
              ? const SizedBox()
              : Column(
                  children: [
                    InkWell(
                      onTap: () {
                        final ZegoUIKit instance = ZegoUIKit.instance;
                        _controller.isMicOn = !_controller.isMicOn;
                        instance.turnMicrophoneOn(_controller.isMicOn);
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            border: Border.all(
                              color: AppColors.yellow,
                            ),
                            color: AppColors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              _controller.isMicOn
                                  ? "assets/images/live_mic_on.png"
                                  : "assets/images/live_mic_off.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 0),
                  ],
                ),
        ),
      ],
    );
  }

  Widget verticalDefault() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return AnimatedOpacity(
              opacity: !_controller.isHost ? 0.0 : 1.0,
              duration: const Duration(seconds: 1),
              child: !_controller.isHost
                  ? const SizedBox()
                  : Column(
                      children: [
                        InkWell(
                          onTap: exitFunc,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                border: Border.all(
                                  color: AppColors.yellow,
                                ),
                                color: AppColors.black.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  _controller.currentCaller.isEngaded
                                      ? "assets/images/live_new_hang_up.png"
                                      : "assets/images/live_exit_red.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
            );
          },
        ),
        StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("live/${_controller.liveId}/waitList")
              .onValue
              .asBroadcastStream(),
          builder: (context, snapshot) {
            _controller.getLatestWaitList(snapshot.data?.snapshot);
            return AnimatedOpacity(
              opacity: _controller.waitListModel.isEmpty ? 0.0 : 1.0,
              duration: const Duration(seconds: 1),
              child: _controller.waitListModel.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: [
                        InkWell(
                          onTap: waitListPopup,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                border: Border.all(
                                  color: AppColors.yellow,
                                ),
                                color: AppColors.black.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Image.asset(
                                      "assets/images/live_new_hourglass.png",
                                    ),
                                    _controller.waitListModel.isEmpty
                                        ? const Positioned(child: SizedBox())
                                        : Positioned(
                                            top: -10,
                                            right: -10,
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    AppColors.yellow,
                                                child: Text(
                                                  _controller
                                                      .waitListModel.length
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
            );
          },
        ),
        StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("live/${_controller.liveId}/leaderboard")
              .onValue
              .asBroadcastStream(),
          builder: (context, snapshot) {
            _controller.getLatestLeaderboard(snapshot.data?.snapshot);
            return AnimatedOpacity(
              opacity: _controller.leaderboardModel.isEmpty ? 0.0 : 1.0,
              duration: const Duration(seconds: 1),
              child: _controller.leaderboardModel.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: [
                        InkWell(
                          onTap: leaderboardPopup,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                border: Border.all(
                                  color: AppColors.yellow,
                                ),
                                color: AppColors.black.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/live_new_podium.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
            );
          },
        ),
        _controller.isHost
            ? StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return AnimatedOpacity(
                    opacity: !_controller.isHost ? 0.0 : 1.0,
                    duration: const Duration(seconds: 1),
                    child: !_controller.isHost
                        ? const SizedBox()
                        : Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  _controller.isHostAvailable =
                                      !_controller.isHostAvailable;
                                  await _controller.updateHostAvailability();
                                },
                                child: SizedBox(
                                  height: 84 - 50,
                                  width: 84,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      border: Border.all(
                                        color: AppColors.yellow,
                                      ),
                                      color: AppColors.black.withOpacity(0.2),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        _controller.isHostAvailable
                                            ? "assets/images/live_calls_on_new.png"
                                            : "assets/images/live_calls_off_new.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 0),
                            ],
                          ),
                  );
                },
              )
            : StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return AnimatedOpacity(
                    opacity: !_controller.isHost && !_controller.isHostAvailable
                        ? 0.0
                        : 1.0,
                    //
                    //
                    duration: const Duration(seconds: 1),
                    child: !_controller.isHost && !_controller.isHostAvailable
                        //
                        //
                        ? const SizedBox()
                        : Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  // _controller.isCustBlocked.data
                                  //             ?.isCustomerBlocked ==
                                  //         1
                                  //     ? await youAreBlocked()
                                  //     : await callAstrologerPopup();
                                },
                                child: SizedBox(
                                  height: 84,
                                  width: 84 - 20,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                      color: Colors.transparent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/live_call_btn.png",
                                          ),
                                          const Positioned(
                                            top: 46,
                                            child: SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 0),
                            ],
                          ),
                  );
                },
              ),
      ],
    );
  }

  Widget backbtn() {
    return Row(
      children: [
        const SizedBox(width: 8),
        InkWell(
          onTap: exitFunc,
          child: SizedBox(
            height: 32,
            width: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                border: Border.all(
                  color: AppColors.yellow,
                ),
                color: AppColors.black.withOpacity(0.2),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> navigate() async {
    // await Get.toNamed(
    //   RouteName.astrologerProfile,
    //   arguments: <String, dynamic>{"astrologer_id": _controller.liveId},
    // );
    return Future<void>.value();
  }

  Future<void> sendMessageToZego(ZegoCustomMessage model) async {
    final String encodedstring = json.encode(model.toJson());
    await _zegoController.message.send(encodedstring);
    return Future<void>.value();
  }

  ZegoCustomMessage receiveMessageToZego(String model) {
    final Map<String, dynamic> decodedMap = json.decode(model);
    final ZegoCustomMessage msgModel = ZegoCustomMessage.fromJson(decodedMap);
    return msgModel;
  }

  Future<void> exitFunc() async {
    // final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
    // if (hasMyIdInWaitList) {
    //   await exitWaitListPopup(
    //     noDisconnect: () {},
    //     yesDisconnect: () async {
    //       if (!_controller.isHost) {
    //         await _controller.removeFromWaitList();
    //       } else {}
    //     },
    //   );
    //   return Future<void>.value();
    // } else {}

    final bool isEngaded = _controller.currentCaller.isEngaded;
    if (isEngaded) {
      await disconnectPopup(
        noDisconnect: () {},
        yesDisconnect: removeCoHostOrStopCoHost,
      );
    } else {
      if (_controller.isHost) {
        await endLiveSession(
          endLive: () async {
            if (mounted) {
              await _zegoController.leave(context);
            } else {}
          },
        );
      } else {
        // await showAllAvailAstroPopup(
        //   exitLive: () async {
        //     if (mounted) {
        //       await _zegoController.leave(context);
        //     } else {}
        //   },
        // );
      }
    }
    return Future<void>.value();
  }

  Future<void> keyboardPop() async {
    _isKeyboardSheetOpen = true;
    await showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // return Container(
        //   padding: EdgeInsets.only(
        //     bottom: MediaQuery.of(context).viewInsets.bottom,
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: TextField(
        //       autofocus: true,
        //       controller: _editingController,
        //       onSubmitted: (String value) async {
        //         await sendKeyboardMesage();
        //       },
        //       cursorColor: AppColors.yellow,
        //       style: const TextStyle(color: AppColors.yellow),
        //       decoration: InputDecoration(
        //         contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        //         suffixIcon: IconButton(
        //           onPressed: sendKeyboardMesage,
        //           icon: Image.asset(
        //             "assets/images/live_send_message_new.png",
        //             color: AppColors.yellow,
        //           ),
        //         ),
        //         floatingLabelBehavior: FloatingLabelBehavior.never,
        //         filled: true,
        //         fillColor: AppColors.white,
        //         hintText: "Say Hi",
        //         hintStyle: const TextStyle(color: AppColors.yellow),
        //         border: OutlineInputBorder(
        //           borderSide: const BorderSide(
        //             width: 2,
        //             color: AppColors.yellow,
        //           ),
        //           borderRadius: BorderRadius.circular(50.0),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderSide: const BorderSide(
        //             width: 2,
        //             color: AppColors.yellow,
        //           ),
        //           borderRadius: BorderRadius.circular(50.0),
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //           borderSide: const BorderSide(
        //             width: 2,
        //             color: AppColors.yellow,
        //           ),
        //           borderRadius: BorderRadius.circular(50.0),
        //         ),
        //       ),
        //     ),
        //   ),
        // );
        return LiveKeyboard(sendKeyboardMesage: sendKeyboardMesage);
      },
    );
    _isKeyboardSheetOpen = false;
    return Future<void>.value();
  }

  Future<void> sendKeyboardMesage(msg) async {
    // final String msg = _editingController.value.text;
    final ZegoCustomMessage model = ZegoCustomMessage(
      type: 1,
      liveId: _controller.liveId,
      userId: _controller.userId,
      userName: _controller.userName,
      avatar: _controller.avatar,
      message: msg,
      timeStamp: DateTime.now().toString(),
      fullGiftImage: "",
    );
    await sendMessageToZego(model);
    // _editingController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    scrollDownForTop();
    scrollDownForBottom();
    if (mounted) {
      Navigator.of(context).pop();
    } else {}
    return Future<void>.value();
  }

  // d

  ZegoUIKitPrebuiltLiveStreamingEvents get events {
    return ZegoUIKitPrebuiltLiveStreamingEvents(
      hostEvents: ZegoUIKitPrebuiltLiveStreamingHostEvents(
        onCoHostRequestReceived: (ZegoUIKitUser user) async {
          showNotifOverlay(user: user, msg: "onCoHostRequestReceived");
          await onCoHostRequest(
            user: user,
            userId: user.id,
            userName: user.name,
            avatar: "https://robohash.org/avatarWidget",
          );
        },
        onCoHostRequestCanceled: (ZegoUIKitUser user) async {
          showNotifOverlay(user: user, msg: "onCoHostRequestCanceled");
          // await onCoHostRequestCanceled(user);
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

  Future<void> onCoHostRequest({
    required ZegoUIKitUser user,
    required String userId,
    required String userName,
    required String avatar,
  }) async {
    await hostingAndCoHostingPopup(
      onClose: () {},
      needAcceptButton: true,
      needDeclinetButton: false,
      onAcceptButton: () async {
        final connectInvite = _zegoController.connectInvite;
        await connectInvite.hostSendCoHostInvitationToAudience(user);
      },
      onDeclineButton: () {},
      user: user,
      userId: userId,
      userName: userName,
      avatar: avatar,
    );
    return Future<void>.value();
  }

  Future<void> removeCoHostOrStopCoHost() async {
    ZegoUIKitUser user = ZegoUIKitUser(
      id: _controller.currentCaller.id,
      name: _controller.currentCaller.userName,
    );
    final ZegoLiveStreamingConnectController connect = _zegoController.connect;
    final bool removed = _controller.isHost
        ? await connect.removeCoHost(user)
        : await connect.stopCoHost(showRequestDialog: false);
    if (removed) {
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
    required ZegoUIKitUser user,
    required String userId,
    required String userName,
    required String avatar,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CallAcceptOrRejectWidget(
          onClose: () {
            Get.back();
            onClose();
          },
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
          userId: userId,
          avatar: avatar,
          userName: userName,
          isHost: _controller.isHost,
          onTimeout: () {
            Get.back();
            if (_controller.isHost) {
            } else {
              onDeclineButton();
            }
          },
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> showAllAvailAstroPopup({
    required void Function() exitLive,
  }) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ShowAllAvailAstroWidget(
          onClose: Get.back,
          data: _controller.data,
          onSelect: (liveId) {
            Get.back();
            if (liveId == _controller.liveId) {
            } else {}
          },
          onFollowAndLeave: () async {
            Get.back();
            // if (_controller.details.data?.isFollow == 0) {
            //   await _controller.followOrUnfollowAstrologer();
            // } else {}
            exitLive();
          },
          onLeave: () {
            Get.back();
            exitLive();
          },
        );
      },
    );
    return Future<void>.value();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
      // if (hasMyIdInWaitList) {
      //   await _controller.removeFromWaitList();
      // } else {}
      await _controller.removeMyNode();
    } else {}
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _controller.callBlockedCustomerListRes();

    _controller.blockedCustomerList.data?.forEach((element) {
      print("blockedCustomerList: id:   ${element.getCustomers?.id}");
      print("blockedCustomerList: name: ${element.getCustomers?.name}");
    });
    return Future<void>.value();
  }
}
