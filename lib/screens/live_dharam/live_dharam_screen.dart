// ignore_for_file: lines_longer_than_80_chars

import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:after_layout/after_layout.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:divine_astrologer/common/app_textstyle.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_bottomsheet.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/generic_loading_widget.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/model/live/deck_card_model.dart";
import "package:divine_astrologer/model/live/notice_board_res.dart";
import "package:divine_astrologer/screens/live_dharam/gifts_singleton.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_global_singleton.dart";
import "package:divine_astrologer/screens/live_dharam/live_screen_widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/live_screen_widgets/live_keyboard.dart";
import "package:divine_astrologer/screens/live_dharam/live_shared_preferences_singleton.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/chosen_cards.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/live_carousal.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/show_card_deck_to_user.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/waiting_for_user_to_select_cards.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/already_in_waitlist_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/astro_wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/block_unlock_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/call_accept_or_reject_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/cannot_spend_money_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/disconnect_call_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/end_session_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/exit_wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/extend_time_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/follow_player.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/gift_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/more_options_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/notif_overlay.dart";
import "package:divine_astrologer/screens/live_dharam/zego_team/player.dart";

// import "package:divine_astrologer/screens/live_dharam/zego_team/player.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import "package:flutter_svg/svg.dart";
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:simple_html_css/simple_html_css.dart";
import "package:svgaplayer_flutter/parser.dart";
import "package:svgaplayer_flutter/player.dart";
import "package:velocity_x/velocity_x.dart";
import "package:zego_express_engine/zego_express_engine.dart";
import "package:zego_uikit_beauty_plugin/zego_uikit_beauty_plugin.dart";
import "package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart";
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";

import '../../cache/custom_cache_manager.dart';
import "../../model/live/blocked_customer_list_res.dart";

const int appID = 696414715;
const String appSign =
    "bf7174a98b7d6fb6e2dc7ae60f6ed932d6a9794dad8a5cae22e29ad8abfac1aa";
const String serverSecret = "89ceddc6c59909af326ddb7209cb1c16";

final ZegoUIKitPrebuiltLiveStreamingController zegoController =
    ZegoUIKitPrebuiltLiveStreamingController();

class LiveDharamScreen extends StatefulWidget {
  const LiveDharamScreen({super.key});

  @override
  State<LiveDharamScreen> createState() => _LivePage();
}

class _LivePage extends State<LiveDharamScreen>
    with
        WidgetsBindingObserver,
        AfterLayoutMixin<LiveDharamScreen>,
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin {
  final LiveDharamController _controller = Get.find();

  final ScrollController _scrollControllerForTop = ScrollController();
  final ScrollController _scrollControllerForBottom = ScrollController();

  final keyboardVisibilityController = KeyboardVisibilityController();
  late SVGAAnimationController _svgController;

  bool _isKeyboardSheetOpen = false;
  Timer? _timer;
  Timer? _msgTimerForFollowPopup;
  Timer? _msgTimerForTarotCardPopup;

  @override
  void initState() {
    super.initState();
    _svgController = SVGAAnimationController(vsync: this);
    _svgController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _svgController.reset();
        svgaUrls.remove(svgaUrls.entries.first.key);
        List<dynamic> giftList = [];
        for (var gift in svgaUrls.entries) {
          giftList.add({gift.key: gift.value});
        }
        // remove from firestore
        await _controller.liveStore.doc(_controller.userId).update({
          "gift": giftList,
        });
        print('gift - removed - from - firestore');
        if (svgaUrls.isNotEmpty) {
          await _loadRandomAnimation();
        }
        if (svgaUrls.isEmpty) {
          print("Animation -removed");
          _removeOverlay();
        }
      }
    });

    WidgetsBinding.instance.addObserver(this);

    ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream()
        .listen(onInRoomCommandMessageReceived);

    zegoController.coHost.audienceLocalConnectStateNotifier
        .addListener(onAudienceLocalConnectStateChanged);
    _controller.liveStore.doc(_controller.userId).snapshots().listen(
        (DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = {};

        var snapshotData = snapshot.data() as Map<String, dynamic>?;
        if (snapshotData != null) {
          data["isAvailable"] = snapshotData["isAvailable"];
          data["blockList"] = snapshotData["blockList"];
          data["LiveOrder"] = snapshotData["LiveOrder"];
          data["waitList"] = snapshotData["waitList"];
          data["leaderBoard"] = snapshotData["leaderBoard"];
          data["gift"] = snapshotData["gift"];
        } else {
          print("Snapshot data is null");
        }
        print(data);
        print("retrie data from firestore");
        await _controller.eventListner(
          snapshot: data,
          engaging: engaging,
        );
        if (data['gift'] != null) {
          List<dynamic> giftList = data['gift'] ?? [];
          for (var gift in giftList) {
            gift.forEach((key, value) {
              svgaUrls[key.toString()] = value.toString();
            });
          }
          _loadRandomAnimation(gifts: svgaUrls, giftList: giftList);
          // if (!_controller.areMapsSame(svgaUrls, newUrls) &&
          //     giftList.isNotEmpty &&
          //     newUrls.length == 1) {
          //   svgaUrls = newUrls;
          //   _loadRandomAnimation(gifts: svgaUrls, giftList: giftList);
          // }
        }
      } else {
        print('Document does not exist');
      }
    }, onError: (error) {
      print("Error listening to snapshots: $error");
    });

    keyboardVisibilityController.onChange.listen(
      (bool visible) {
        if (visible == false && _isKeyboardSheetOpen == true) {
          Navigator.of(context).pop();
        } else {}
      },
    );

    _startTimer();
    if (kDebugMode) {
      _controller.isCamOn = false;
      zegoController.audioVideo.camera
          .turnOn(_controller.isCamOn, userID: _controller.userId);
      _controller.isCamOn = !_controller.isCamOn;
      zegoController.audioVideo.camera
          .turnOn(_controller.isCamOn, userID: _controller.userId);
      _controller.update();
    }
  }

  Future<void> _showOverlay() async {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: SVGAImage(
              _svgController,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadRandomAnimation(
      {Map<String, dynamic>? gifts, List? giftList}) async {
    if (_svgController.isAnimating) {
      return;
    }
    if (svgaUrls.isEmpty) {
      return;
    }
    print("_loadRandomAnimation-2");
    _showOverlay();
    const SVGAParser parser = SVGAParser();
    String giftInfo = svgaUrls.entries.first.value;
    File file = await CustomCacheManager().getFile(giftInfo);
    var videoItem = await parser.decodeFromBuffer(file.readAsBytesSync());
    print("svgaUrls.videoItem");
    _svgController.videoItem = videoItem;
    _svgController.forward();
  }

  void successAndFailureCallBack({
    required String message,
    required bool isForSuccess,
    required bool isForFailure,
  }) {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          final SnackBar snackBar = SnackBar(
            content: Text(
              message,
              style: const TextStyle(fontSize: 10, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: appColors.guideColor,
            behavior: SnackBarBehavior.floating,
          );
          if (isForSuccess) {
          } else if (isForFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {}
        } else {}
      },
    );
    return;
  }

  void getUntil() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          final int length = LiveGlobalSingleton().getCountOfOpenDialogs();
          print("getUntil():: closing $length items");
          for (int i = 0; i < length; i++) {
            Navigator.of(context).pop();
          }
        } else {}
      },
    );
    return;
  }

  bool isAcceptPopupOpen = false;
  ZegoUIKitUser isAcceptPopupOpenFor = ZegoUIKitUser(id: "", name: "");

  /*
   * Dear Maintainer
   *
   * Once you are done trying to ‘optimize’ this engaging,
   * and you have realized what a terrible mistake that was,
   * please increment the following counter as a warning
   * to the next guy.
   *
   * total_hours_wasted_here = 1
   */

  Future<void> engaging(WaitListModel currentCaller) async {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          final bool cond1 = true;
          final bool cond2 = _controller.waitListModel.isNotEmpty;
          final bool cond3 = _controller.currentCaller.id!.isEmpty;
          final bool cond4 = !isAcceptPopupOpen;

          bool cond5 = true;
          for (var e in _controller.waitListModel) {
            if (e.callStatus == 1) cond5 = false;
          }

          bool cond6 = false;
          for (var e in _controller.waitListModel) {
            if (e.callStatus == 0 && !e.isEngaded! && !e.isRequest!) {
              cond6 = true;
            }
          }

          if (cond1 && cond2 && cond3 && cond4 && cond5 && cond6) {
            final String id = _controller.waitListModel.first.id!;
            final String name = _controller.waitListModel.first.userName!;
            final String avatar = _controller.waitListModel.first.avatar!;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);

            await onCoHostRequest(
              user: user,
              userId: id,
              userName: name,
              avatar: avatar,
            );
          } else {}
        } else {}
      },
    );
    return Future<void>.value();
  }

  void _startTimer() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          const duration = Duration(seconds: 1);
          _timer = Timer.periodic(
            duration,
            (Timer timer) async {
              if (timer.tick % 30 == 0) {
                _controller.timerCurrentIndex++;
                if (_controller.timerCurrentIndex >
                    (_controller.noticeBoardRes.data?.length ?? 0)) {
                  _controller.timerCurrentIndex = 1;
                } else {}
              } else {}

              if (timer.tick % 300 == 0) {
                final ZegoCustomMessage model = ZegoCustomMessage(
                  type: 1,
                  liveId: _controller.userId,
                  userId: "0",
                  userName: "Live Monitoring Team",
                  avatar:
                      "https://divineprod.blob.core.windows.net/divineprod/astrologers/February2024/j2Jk4GAUbEipC81xRPKt.png",
                  message: "Joined",
                  timeStamp: DateTime.now().toString(),
                  fullGiftImage: "",
                  isBlockedCustomer: false,
                  isMod: true,
                );
                await sendMessageToZego(model);
              } else {}

              if (timer.tick % 600 == 0) {
                final ZegoCustomMessage model = ZegoCustomMessage(
                  type: 1,
                  liveId: _controller.userId,
                  userId: "0",
                  userName: "Quality Team",
                  avatar:
                      "https://divineprod.blob.core.windows.net/divineprod/astrologers/February2024/j2Jk4GAUbEipC81xRPKt.png",
                  message: "Joined",
                  timeStamp: DateTime.now().toString(),
                  fullGiftImage: "",
                  isBlockedCustomer: false,
                  isMod: true,
                );
                await sendMessageToZego(model);
              } else {}
            },
          );
        } else {}
      },
    );
  }

  void _startMsgTimerForTarotCardPopup() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          const duration = Duration(seconds: 1);
          _msgTimerForTarotCardPopup = Timer.periodic(
            duration,
            (Timer timer) async {
              print("_startMsgTimerForTarotCardPopup(): ${timer.tick}");

              if (timer.tick % 60 == 0) {
                if (showCardDeckToUserPopupTimeoutHappening) {
                  Get.back();
                  _endMsgTimerForTarotCardPopup();
                } else {}

                successAndFailureCallBack(
                  message: "Card Selection Timeout",
                  isForSuccess: false,
                  isForFailure: true,
                );

                _endMsgTimerForTarotCardPopup();
              } else {}
            },
          );
        } else {}
      },
    );
  }

  void _endMsgTimerForTarotCardPopup() {
    if (_msgTimerForTarotCardPopup?.isActive ?? false) {
      _msgTimerForTarotCardPopup?.cancel();
    } else {}
    return;
  }

  Future<void> onUserLeave(ZegoUIKitUser zegoUIKitUser) async {
    final bool cond1 = true;
    final bool cond2 = _controller.currentCaller.isEngaded!;
    final bool cond3 = _controller.currentCaller.id! == zegoUIKitUser.id;
    final bool cond4 = zegoUIKitUser.id != _controller.userId;
    if (cond1 && cond2 && cond3 && cond4) {
      print("on user leave");
      await removeCoHostOrStopCoHost();
    } else {}
    return Future<void>.value();
  }

  @override
  void dispose() {
    _scrollControllerForTop.dispose();
    _scrollControllerForBottom.dispose();
    _timer?.cancel();
    _msgTimerForFollowPopup?.cancel();
    _msgTimerForTarotCardPopup?.cancel();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry?.markNeedsBuild();
      _overlayEntry = null; // Clear the reference
    }
  }

  Future<void> onAudienceLocalConnectStateChanged() async {
    final audienceConnectState =
        zegoController.coHost.audienceLocalConnectStateNotifier.value;
    print(audienceConnectState.name);
    print(
        "audienceConnectStateaudienceConnectStateaudienceConnectStateaudienceConnectState");
    switch (audienceConnectState) {
      case ZegoLiveStreamingAudienceConnectState.idle:
        break;
      case ZegoLiveStreamingAudienceConnectState.connecting:
        break;
      case ZegoLiveStreamingAudienceConnectState.connected:
        break;
    }
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    //
    LiveGlobalSingleton().buildContext = context;
    //

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await exitFunc();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(
          () {
            return _controller.userId == ""
                ? const Center(child: GenericLoadingWidget())
                : ZegoUIKitPrebuiltLiveStreaming(
                    appID: appID,
                    appSign: appSign,
                    userID: _controller.userId,
                    userName: _controller.userName,
                    liveID: _controller.userId,
                    config: streamingConfig
                      ..beautyConfig = ZegoBeautyPluginConfig(
                        effectsTypes:
                            ZegoBeautyPluginConfig.beautifyEffectsTypes(
                                  enableBasic: true,
                                  enableAdvanced: true,
                                  enableMakeup: true,
                                  enableStyle: true,
                                ) +
                                ZegoBeautyPluginConfig.filterEffectsTypes(),
                      )
                      ..video = ZegoUIKitVideoConfig.preset540P()
                      ..preview.showPreviewForHost = false
                      // ..audioVideoView.isVideoMirror = false
                      ..coHost.maxCoHostCount = 1
                      ..confirmDialogInfo = null
                      ..coHost.disableCoHostInvitationReceivedDialog = true
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
                      )
                      ..coHost.turnOnCameraWhenCohosted = () {
                        final callType = _controller.currentCaller.callType!;
                        //
                        if (callType == "video") {
                          return true;
                        } else if (callType == "private" ||
                            callType == "audio") {
                          return false;
                        }
                        return false;
                      }
                      ..audioVideoView.playCoHostAudio = (
                        ZegoUIKitUser localUser,
                        ZegoLiveStreamingRole localRole,
                        ZegoUIKitUser coHost,
                      ) {
                        final callType = _controller.currentCaller.callType!;
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
                      ..audioVideoView.playCoHostVideo = (
                        ZegoUIKitUser localUser,
                        ZegoLiveStreamingRole localRole,
                        ZegoUIKitUser coHost,
                      ) {
                        // if (_controller.isHost) {
                        // } else {
                        //   callJoinConfiguration();
                        // }
                        final callType = _controller.currentCaller.callType!;
                        //
                        if (callType == "private" || callType == "audio") {
                          return false;
                        }
                        return true;
                      }
                      ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                        showInRoomMessageButton: false,
                        hostButtons: <ZegoLiveStreamingMenuBarButtonName>[],
                        coHostButtons: <ZegoLiveStreamingMenuBarButtonName>[],
                      )
                      ..layout = galleryLayout()
                      ..avatarBuilder = avatarWidget
                      ..topMenuBar = ZegoLiveStreamingTopMenuBarConfig(
                        hostAvatarBuilder: (ZegoUIKitUser host) {
                          return const SizedBox();
                        },
                        showCloseButton: false,
                      )
                      ..memberButton = ZegoLiveStreamingMemberButtonConfig(
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        builder: (int memberCount) {
                          return const SizedBox();
                        },
                      )
                      ..memberList = ZegoLiveStreamingMemberListConfig(
                        itemBuilder: (
                          BuildContext context,
                          Size size,
                          ZegoUIKitUser user,
                          Map<String, dynamic> extraInfo,
                        ) {
                          return ListTile(
                            dense: true,
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      )
                      ..foreground = foregroundWidget()
                      ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(
                        itemBuilder: (
                          BuildContext context,
                          ZegoInRoomMessage message,
                          Map<String, dynamic> extraInfo,
                        ) {
                          return const SizedBox();
                        },
                      )
                      ..slideSurfaceToHide = false
                      ..duration.isVisible = false,
                    events: events,
                  );
          },
        ),
      ),
      // ),
    );
  }

  Future<void> reJoinAsAudience(String coHostID) async {
    // Log the co-host out of the room
    ZegoExpressEngine.instance.logoutRoom(coHostID);
    await Future<void>.delayed(const Duration(seconds: 1));
    ZegoExpressEngine.instance
        .loginRoom(coHostID, ZegoUser(coHostID, 'co-host'));
  }

  ZegoUIKitPrebuiltLiveStreamingConfig get streamingConfig {
    final ZegoUIKitSignalingPlugin plugin = ZegoUIKitSignalingPlugin();
    final List<IZegoUIKitPlugin> pluginsList = <IZegoUIKitPlugin>[
      plugin,
      ZegoUIKitSignalingPlugin(),
      getBeautyPlugin()
    ];
    return ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: pluginsList);
  }

  ZegoUIKitBeautyPlugin getBeautyPlugin() {
    final plugin = ZegoUIKitBeautyPlugin();
    final config = ZegoBeautyParamConfig(
        ZegoBeautyPluginEffectsType.beautyBasicSmoothing, true,
        value: 80);
    final config1 = ZegoBeautyParamConfig(
        ZegoBeautyPluginEffectsType.backgroundMosaicing, true,
        value: 90);
    plugin.setBeautyParams([config, config1], forceUpdateCache: true);
    return plugin;
  }

  ZegoLayout galleryLayout() {
    final bool isEngaged = _controller.currentCaller.isEngaded!;
    final String callType = _controller.currentCaller.callType!;
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
            //  : zegoUser == astroUser
            //     ? (_controller.details.data?.image ?? "")
            : "",
        rounded: true,
        typeEnum: TypeEnum.user,
      ),
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
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      noticeBoard(),
                      // requestedBoard(),
                      SizedBox(
                          height:
                              (_controller.noticeBoardRes.data ?? []).isEmpty
                                  ? 0.0
                                  : 4.0),
                      inRoomMessage(),
                    ],
                  ),
                ),
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

  Widget noticeBoard() {
    // do not remove
    print("timerCurrentIndex: ${_controller.timerCurrentIndex - 1}");
    //
    return AnimatedOpacity(
      opacity: (_controller.noticeBoardRes.data ?? []).isEmpty ? 0.0 : 1.0,
      duration: const Duration(seconds: 1),
      child: (_controller.noticeBoardRes.data ?? []).isEmpty
          ? const SizedBox()
          : SizedBox(
              width: Get.width / 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  final int timerCurrentIndex =
                      _controller.timerCurrentIndex - 1;
                  final NoticeBoardResData noticeBoardResData =
                      _controller.noticeBoardRes.data?[timerCurrentIndex] ??
                          NoticeBoardResData();
                  final String title = noticeBoardResData.title ?? "";
                  final String description =
                      noticeBoardResData.description ?? "";
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(
                        color: appColors.guideColor,
                      ),
                      color: appColors.black.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.center,
                            text: HTML.toTextSpan(context, description ?? "",
                                defaultTextStyle: AppTextStyle.textStyle14(
                                  fontColor: appColors.white,
                                )),
                            maxLines: 5,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget appBarWidget() {
    return SizedBox(
      height: 162,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          backbtn(),
          Column(
            children: [
              newLeaderboard(),
              const SizedBox(height: 64),
              inRoomMessageTop(),
            ],
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: true,
            child: settingsRowForAstro(),
          ),
        ],
      ),
    );
  }

  OverlayEntry? _overlayEntry;
  StreamSubscription<DatabaseEvent>? _subscription;
  Map<String, dynamic> svgaUrls = {};

  Widget newLeaderboard() {
    List<LeaderboardModel> newList = [];
    newList.addAll(_controller.leaderboardModel);
    newList.sort((a, b) => b.amount!.compareTo(a.amount!));
    return AnimatedOpacity(
      opacity: newList.isEmpty ? 0.0 : 1.0,
      duration: const Duration(seconds: 1),
      child: newList.isEmpty
          ? const SizedBox()
          : LeaderBoardWidget(
              avatar: newList.first.avatar,
              userName: newList.first.userName,
              fullGiftImage: "",
              astrologerName: "Astrologer",
              //
            ),
    );
  }

  Widget inRoomMessage() {
    return SizedBox(
      height: Get.height * 0.30,
      child: StreamBuilder<List<ZegoInRoomMessage>>(
        stream: zegoController.message.stream(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<ZegoInRoomMessage>> snapshot,
        ) {
          List<ZegoInRoomMessage> messages =
              snapshot.data ?? <ZegoInRoomMessage>[];
          messages = messages.reversed.toList();
          return ListView.separated(
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            // itemCount:
            //     messages.isNotEmpty && messages.length >= 5 ? 5 : messages.length,
            itemCount: messages.length,
            controller: _scrollControllerForBottom,
            cacheExtent: 9999,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final ZegoInRoomMessage message = messages[index];
              final ZegoCustomMessage msg =
                  receiveMessageToZego(message.message);
              final bool isBlocked =
                  _controller.firebaseBlockUsersIds.contains(msg.userId);
              // final isLiveMonitoringTeam =
              //     msg.userName == "Live Monitoring Team";
              final isModerator = msg.isMod;
              return msg.type == 0
                  ? const SizedBox()
                  : Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: msg.message.contains("Started following")
                                ? appColors.yellow
                                : msg.fullGiftImage.isNotEmpty
                                    ? appColors.white
                                    : appColors.black.withOpacity(0.3),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 30,
                                margin: const EdgeInsets.only(top: 3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appColors.guideColor,
                                ),
                                child: Text(
                                    msg.userName.split("").first.toUpperCase(),
                                    style: TextStyle(
                                      color: appColors.whiteGuidedColor,
                                      fontSize: 12,
                                      fontFamily: "Metropolis",
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: Get.width /
                                          2.5, // Define the maximum width here
                                    ),
                                    child: Text(
                                      msg.userName ?? "",
                                      // nameWithWithoutIDs(msg, isModerator),
                                      maxLines: 100000,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isBlocked
                                            ? Colors.red
                                            : isModerator
                                                ? appColors.guideColor
                                                : msg.fullGiftImage.isNotEmpty
                                                    ? appColors.black
                                                    : msg.message.contains(
                                                            "Started following")
                                                        ? appColors.black
                                                        : Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: Get.width /
                                          2.5, // Define the maximum width here
                                    ),
                                    child: Text(
                                      msg.message ?? "",
                                      maxLines: 100000,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isBlocked
                                            ? Colors.red
                                            : isModerator
                                                ? appColors.guideColor
                                                : msg.fullGiftImage.isNotEmpty
                                                    ? appColors.black
                                                    : msg.message.contains(
                                                            "Started following")
                                                        ? appColors.black
                                                        : Colors.white,
                                      ),
                                      // maxLines: 2,
                                      // overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              msg.fullGiftImage.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CustomImageWidget(
                                        imageUrl: msg.fullGiftImage,
                                        rounded: true,
                                        radius: 13,
                                        typeEnum: TypeEnum.gift,
                                      ),
                                    )
                                  : const SizedBox(),
                              msg.userId == _controller.userId ||
                                      msg.userId == "0"
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: 16,
                                          color: appColors.guideColor,
                                        ),
                                        onPressed: () async {
                                          await moreOptionsPopup(
                                            userId: msg.userId ?? "",
                                            userName: msg.userName ?? "",
                                            avatar: msg.avatar ?? "",
                                            isBlocked: _controller.isBlocked(
                                              id: int.parse(
                                                msg.userId ?? "",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
          );
        },
      ),
    );
  }

  bool moreOptionConditions(ZegoCustomMessage msg, bool isModerator) {
    final bool cond1 = msg.userId != _controller.userId;
    final bool cond2 = !(_controller.currentCaller.id == (msg.userId ?? ""));
    final bool cond4 = msg.userId != _controller.userId;
    return cond1 && cond2;
  }

  Widget inRoomMessageTop() {
    return SizedBox(
      height: 32,
      width: Get.width / 1.5,
      child: StreamBuilder<List<ZegoInRoomMessage>>(
        stream: zegoController.message.stream(),
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
            padding: EdgeInsets.zero,
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
                  : Obx(
                      () {
                        //
                        print("showTopBanner: ${_controller.showTopBanner}");
                        //
                        return AnimatedOpacity(
                          opacity: !_controller.showTopBanner ? 0.0 : 1.0,
                          duration: const Duration(seconds: 1),
                          child: LeaderBoardWidget(
                            avatar: msg.avatar ?? "",
                            userName: "${msg.message}",
                            fullGiftImage: msg.fullGiftImage ?? "",
                            astrologerName: "",
                          ),
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }

  Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
    if (state == ZegoLiveStreamingState.idle) {
      ZegoGiftPlayer().clear();
    } else {}

    if (state == ZegoLiveStreamingState.ended) {
      ZegoGiftPlayer().clear();

      getUntil();

      await Future<void>.delayed(const Duration(seconds: 2));

      _controller.initData();
    } else {}

    return Future<void>.value();
  }

  Future<void> alreadyInWaitlistPopup() async {
    LiveGlobalSingleton().isAlreadyInWaitlistPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return AlreadyInWaitlistWidget(
          onClose: Get.back,
          openWaitlist: () async {
            Get.back();
            await waitListPopup();
          },
        );
      },
    );
    LiveGlobalSingleton().isAlreadyInWaitlistPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> cannotSpendMoney({
    required bool isForCall,
    required bool isForWaitList,
  }) async {
    LiveGlobalSingleton().isCannotSpendMoneyPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CannotSpendMoneyWidget(
          onClose: Get.back,
          isForCall: isForCall,
          isForWaitList: isForWaitList,
        );
      },
    );
    LiveGlobalSingleton().isCannotSpendMoneyPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> giftPopup({
    required BuildContext ctx,
    required String userId,
    required String userName,
  }) async {
    LiveGlobalSingleton().isGiftPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return GiftWidget(
          onClose: Get.back,
          list: GiftsSingleton().gifts.data ?? <GiftData>[],
          onSelect: (GiftData item, num quantity) async {
            Get.back();
            await sendGiftFuncAstro(
              ctx: ctx,
              item: item,
              quantity: quantity,
              userId: userId,
              userName: userName,
            );
          },
          isHost: true,
          walletBalance: 0,
        );
      },
    );
    LiveGlobalSingleton().isGiftPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> sendGiftFuncAstro({
    required BuildContext ctx,
    required GiftData item,
    required num quantity,
    required String userId,
    required String userName,
  }) async {
    if (userId != "0") {
      var data = {
        "room_id": _controller.userId,
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
    } else {}
    return Future<void>.value();
  }

  Future<void> leaderboardPopup() async {
    LiveGlobalSingleton().isLeaderboardPopupOpen = true;
    List<LeaderboardModel> newList = [];
    newList.addAll(_controller.leaderboardModel);
    newList.sort((a, b) => b.amount!.compareTo(a.amount!));
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LeaderboardWidget(
          onClose: Get.back,
          liveId: _controller.userId,
          leaderboardModel: newList,
        );
      },
    );
    LiveGlobalSingleton().isLeaderboardPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> waitListPopup() async {
    LiveGlobalSingleton().isWaitListPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        // return WaitListWidget(
        return AstroWaitListWidget(
          onClose: Get.back,
          isInCall: _controller.currentCaller.isEngaded!,
          waitTime: _controller.getTotalWaitTime(),
          myUserId: _controller.userId,
          list: _controller.waitListModel,
          hasMyIdInWaitList: false,
          onExitWaitList: () async {
            Get.back();
          },
          astologerName: _controller.userName,
          astologerImage: _controller.avatar,
          astologerSpeciality: _controller.hostSpeciality,
          isHost: true,
          onAccept: () async {
            Get.back();
            print("connectInvite-1 ");
            final String id = _controller.waitListModel.first.id!;
            print("connectInvite-2 ");
            final String name = _controller.waitListModel.first.userName!;
            print("connectInvite-3 ");
            final String avatar = _controller.waitListModel.first.avatar!;
            print("connectInvite-4 ");
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);
            print("connectInvite-5 ");
            final connectInvite = zegoController.coHost;
            print("connectInvite-6 ");
            var result =
                await connectInvite.hostSendCoHostInvitationToAudience(user);
            print("connectInvite-7 $result");
          },
          onReject: Get.back,
          model: _controller.currentCaller,
        );
      },
    );
    LiveGlobalSingleton().isWaitListPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> notifyAstroForExitWaitList() async {
    var data = {
      "room_id": _controller.userId,
      "user_id": _controller.userId,
      "user_name": _controller.userName,
      "item": {},
      "type": "Notify Astro For Exit WaitList",
    };

    await _controller.sendGiftAPI(
      data: data,
      count: 1,
      svga: "",
      successCallback: log,
      failureCallback: log,
    );
    return Future<void>.value();
  }

  Future<void> disconnectPopup({
    required Function() noDisconnect,
    required Function() yesDisconnect,
  }) async {
    LiveGlobalSingleton().isDisconnectPopupOpen = true;
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
          isAstro: true,
          astroAvatar: _controller.avatar,
          astroUserName: _controller.userName,
          custoAvatar: _controller.currentCaller.avatar!,
          custoUserName: _controller.currentCaller.userName!,
        );
      },
    );
    LiveGlobalSingleton().isDisconnectPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> exitWaitListPopup({
    required Function() noDisconnect,
    required Function() yesDisconnect,
  }) async {
    LiveGlobalSingleton().isExitWaitListPopupOpen = true;
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
          isAstro: true,
          astroAvatar: _controller.avatar,
          astroUserName: _controller.userName,
          custoAvatar: _controller.currentCaller.avatar!,
          custoUserName: _controller.currentCaller.userName!,
        );
      },
    );
    LiveGlobalSingleton().isExitWaitListPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> endLiveSession({required void Function() endLive}) async {
    LiveGlobalSingleton().isEndLiveSessionPopupOpen = true;
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
    LiveGlobalSingleton().isEndLiveSessionPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> moreOptionsPopup({
    required String userId,
    required String userName,
    required String avatar,
    required bool isBlocked,
  }) async {
    LiveGlobalSingleton().isMoreOptionsPopupOpen = true;
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
          isHost: true,
          onTapAskForGifts: () async {
            Get.back();
            await giftPopup(ctx: context, userId: userId, userName: userName);
            showacknowledgementSnackBar("Gift");
          },
          onTapAskForVideoCall: () async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": _controller.userId,
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
            } else {}
            showacknowledgementSnackBar("Video Call");
          },
          onTapAskForAudioCall: () async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": _controller.userId,
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
            } else {}
            showacknowledgementSnackBar("Voice Call");
          },
          onTapAskForPrivateCall: () async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": _controller.userId,
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
            } else {}
            showacknowledgementSnackBar("Private Call");
          },
          onTapAskForBlockUnBlockUser: () async {
            Get.back();
            await blockUnblockPopup(
              isAlreadyBeenBlocked: isBlocked,
              performAction: () async {
                if (userId != "0") {
                  await _controller.callblockCustomer(
                    id: int.parse(userId),
                    successCallBack: (String message) {
                      successAndFailureCallBack(
                        message: message,
                        isForSuccess: true,
                        isForFailure: false,
                      );
                    },
                    failureCallBack: (String message) {
                      successAndFailureCallBack(
                        message: message,
                        isForSuccess: false,
                        isForFailure: true,
                      );
                    },
                  );
                  var data = {
                    "room_id": _controller.userId,
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
                } else {}
              },
            );
          },
          isBlocked: isBlocked,
        );
      },
    );
    LiveGlobalSingleton().isMoreOptionsPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> blockUnblockPopup({
    required bool isAlreadyBeenBlocked,
    required Function() performAction,
  }) async {
    LiveGlobalSingleton().isBlockUnblockPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return BlockUnblockWidget(
          onClose: Get.back,
          isAlreadyBeenBlocked: isAlreadyBeenBlocked,
          performAction: () {
            Get.back();
            performAction();
          },
        );
      },
    );
    LiveGlobalSingleton().isBlockUnblockPopupOpen = false;
    return Future<void>.value();
  }

  void showacknowledgementSnackBar(String type) {
    final SnackBar snackBar = SnackBar(
      width: Get.width / 1.5,
      content: Text(
        "$type Request Sent",
        style: TextStyle(
          fontSize: 16,
          color: appColors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: appColors.guideColor,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }

  Future<void> onInRoomCommandMessageReceived(
      ZegoSignalingPluginInRoomCommandMessageReceivedEvent event) async {
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
      final String receiverUserId = decodedMessage["gift_type"]["user_id"];
      final num giftCount = decodedMessage["gift_count"];
      // final String accessToken = decodedMessage["access_token"];
      // final int timestamp = decodedMessage["timestamp"];

      final bool askForGift = type == "Ask For Gift";
      final bool askForVideo = type == "Ask For Video Call";
      final bool askForVoice = type == "Ask For Voice Call";
      final bool askForPrivate = type == "Ask For Private Call";
      final bool askFor =
          askForGift || askForVideo || askForVoice || askForPrivate;

      if (senderUserID != _controller.userId) {
        if (roomId == _controller.userId) {
          if (type == "") {
            if (mounted) {
              print(item["animation"]);
              print("objectobjectobjectobject");
              // ZegoGiftPlayer().play(
              //   context,
              //   GiftPlayerData(GiftPlayerSource.url, item["animation"]),
              // );
            } else {}
            await showHideTopBanner();
          } else if (type == "Started following") {
            FollowPlayer().play(
              context,
              FollowPlayerData(
                FollowPlayerSource.asset,
                "assets/lottie/live_follow_heart.json",
                userName,
              ),
            );
          } else if (askFor) {
            if (receiverUserId == _controller.userId) {
              // await commonRequest(type: type, item: item, giftCount: giftCount);
              // _controller.requestClass = RequestClass(
              //   type: type,
              //   giftData: GiftData.fromJson(item),
              //   giftCount: giftCount,
              // );
            } else {}
          } else if (type == "Block/Unblock") {
            // await _controller.isCustomerBlocked(
            //   successCallBack: (String message) {
            //     eventListnerSuccessAndFailureCallBack(
            //       message: message,
            //       isForSuccess: true,
            //       isForFailure: false,
            //     );
            //   },
            //   failureCallBack: (String message) {
            //     eventListnerSuccessAndFailureCallBack(
            //       message: message,
            //       isForSuccess: false,
            //       isForFailure: true,
            //     );
            //   },
            // );
          } else if (type == "Tarot Card") {
            final TarotGameModel model = TarotGameModel.fromJson(item);

            if (model.receiverId == _controller.userId) {
              _controller.tarotGameModel = model;
              final int step = _controller.tarotGameModel.currentStep ?? 0;
              if (waitingForUserToSelectCardsPopupVisible) {
                Get.back();
              } else {}
              // if (showCardDeckToUserPopupTimeoutHappening) {
              //   Get.back();
              // } else {}
              switch (step) {
                case 0:
                  await showCardDeckToUserPopup();
                  break;
                case 1:
                  final singleton = LiveSharedPreferencesSingleton();
                  final String tarotCard = singleton.getSingleTarotCard();
                  tarotCard.isEmpty
                      ? WidgetsBinding.instance.endOfFrame.then(
                          (_) async {
                            if (mounted) {
                              successAndFailureCallBack(
                                message: "Unable to load tarot card game.",
                                isForSuccess: false,
                                isForFailure: true,
                              );
                              await sendTaroCardClose();
                            } else {}
                          },
                        )
                      : await showCardDeckToUserPopup1();
                  break;
                case 2:
                  await showCardDeckToUserPopup2();
                  break;
                default:
                  break;
              }
            } else {}
          } else if (type == "Tarot Card Close") {
            if (waitingForUserToSelectCardsPopupVisible) {
              Get.back();
            } else {}
            // if (showCardDeckToUserPopupTimeoutHappening) {
            //   Get.back();
            // } else {}
            successAndFailureCallBack(
              message: "User closed Card Selection",
              isForSuccess: false,
              isForFailure: true,
            );
          } else if (type == "Notify Astro For Exit WaitList") {
            final bool cond1 = true;
            final bool cond2 = isAcceptPopupOpen;
            final bool cond3 = roomId == _controller.userId;
            final bool cond4 = userId == isAcceptPopupOpenFor.id;
            final bool cond5 = userName == isAcceptPopupOpenFor.name;

            if (cond1 && cond2 && cond3 && cond4 && cond5) {
              Get.back();
            } else {}
          } else {}
        } else {}
      } else {}
    }
    return Future<void>.value();
  }

  bool waitingForUserToSelectCardsPopupVisible = false;
  bool showCardDeckToUserPopupTimeoutHappening = false;

  Future<void> waitingForUserToSelectCardsPopup() async {
    waitingForUserToSelectCardsPopupVisible = true;
    LiveGlobalSingleton().isWaitingForUserToSelectCardsPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return WaitingForUserToSelectCards(
          onClose: Get.back,
          userName: _controller.currentCaller.userName!,
          onTimeout: () async {
            Get.back();
            successAndFailureCallBack(
              message: "Card Selection Timeout",
              isForSuccess: false,
              isForFailure: true,
            );
            // await sendTaroCardClose();
          },
        );
      },
    );
    waitingForUserToSelectCardsPopupVisible = false;
    LiveGlobalSingleton().isWaitingForUserToSelectCardsPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup() async {
    LiveGlobalSingleton().isShowCardDeckToUserPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowCardDeckToUser(
          onClose: Get.back,
          onSelect: (int value) async {
            Get.back();

            var item = TarotGameModel(
              currentStep: 1,
              canPick: value,
              userPicked: [],
              senderId: _controller.userId,
              receiverId: _controller.currentCaller.id!,
            );
            await sendTaroCard(item);

            await waitingForUserToSelectCardsPopup();
          },
          userName: _controller.currentCaller.userName!,
          onTimeout: () async {
            Get.back();
            await sendTaroCardClose();
          },
          totalTime: _controller.currentCaller.totalTime!,
        );
      },
    );
    LiveGlobalSingleton().isShowCardDeckToUserPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup1() async {
    if (_controller.deckCardModelList.isEmpty) {
      await _controller.tarotCardInit();
      showCardDeckToUserPopup1();
      return;
    }
    showCardDeckToUserPopupTimeoutHappening = true;
    LiveGlobalSingleton().isShowCardDeckToUser1PopupOpen = true;

    _startMsgTimerForTarotCardPopup();

    bool hasSelected = false;

    await showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        print(_controller.deckCardModelList);
        print("_controller.deckCardModelList");
        return LiveCarousal(
          onClose: () async {
            Get.back();
            _endMsgTimerForTarotCardPopup();

            await sendTaroCardClose();
          },
          allCards: _controller.deckCardModelList,
          onSelect: (List<DeckCardModel> selectedCards) async {
            Get.back();
            _endMsgTimerForTarotCardPopup();

            hasSelected = true;

            final List<UserPicked> userPicked = [];
            for (DeckCardModel element in selectedCards) {
              userPicked.add(
                UserPicked(
                  id: element.id,
                  name: element.name,
                  status: element.status,
                  image: element.image,
                ),
              );
            }
            var item = TarotGameModel(
              currentStep: 2,
              canPick: _controller.tarotGameModel.canPick ?? 0,
              userPicked: userPicked,
              senderId: _controller.userId,
              receiverId: _controller.currentCaller.id!,
            );
            await sendTaroCard(item);
          },
          numOfSelection: _controller.tarotGameModel.canPick ?? 0,
          userName: _controller.currentCaller.userName!,
        );
      },
    );

    showCardDeckToUserPopupTimeoutHappening = false;
    LiveGlobalSingleton().isShowCardDeckToUser1PopupOpen = false;

    _endMsgTimerForTarotCardPopup();

    if (hasSelected) {
    } else {
      await sendTaroCardClose();
    }
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup2() async {
    LiveGlobalSingleton().isShowCardDeckToUser2PopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final List<DeckCardModel> userPicked = [];
        for (UserPicked element
            in _controller.tarotGameModel.userPicked ?? []) {
          userPicked.add(
            DeckCardModel(
              id: element.id,
              name: element.name,
              status: element.status,
              image: element.image,
            ),
          );
        }
        return ChosenCards(
          onClose: Get.back,
          userChosenCards: userPicked,
          userName: _controller.currentCaller.userName! ?? "",
        );
      },
    );
    LiveGlobalSingleton().isShowCardDeckToUser2PopupOpen = false;
    return Future<void>.value();
  }

  Future<void> sendTaroCard(item) async {
    var data = {
      "room_id": _controller.userId,
      "user_id": _controller.userId,
      "user_name": _controller.userName,
      "item": item.toJson(),
      "type": "Tarot Card",
    };
    await _controller.sendGiftAPI(
      data: data,
      count: 1,
      svga: "",
      successCallback: log,
      failureCallback: log,
    );
    return Future<void>.value();
  }

  Future<void> sendTaroCardClose() async {
    var data = {
      "room_id": _controller.userId,
      "user_id": _controller.userId,
      "user_name": _controller.userName,
      "item": {},
      "type": "Tarot Card Close",
    };
    await _controller.sendGiftAPI(
      data: data,
      count: 1,
      svga: "",
      successCallback: log,
      failureCallback: log,
    );
    return Future<void>.value();
  }

  Future<void> showHideTopBanner() async {
    _controller.showTopBanner = true;
    await Future<void>.delayed(const Duration(seconds: 15));
    _controller.showTopBanner = false;
    return Future<void>.value();
  }

  void scrollDownForTop() {
    if (_scrollControllerForTop.hasClients) {
      final double maxScr = _scrollControllerForTop.position.minScrollExtent;
      _scrollControllerForTop.animateTo(
        maxScr,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    } else {}
    return;
  }

  void scrollDownForBottom() {
    if (_scrollControllerForBottom.hasClients) {
      final double maxScr = _scrollControllerForBottom.position.minScrollExtent;
      _scrollControllerForBottom.animateTo(
        maxScr,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    } else {}
    return;
  }

  Widget newAppBarLeft() {
    return InkWell(
      onTap: () async {
        await keyboardPop();
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
              color: appColors.guideColor,
            ),
            color: appColors.black.withOpacity(0.2),
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
              color: appColors.guideColor,
            ),
            color: appColors.black.withOpacity(0.2),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                width: 32,
                child: CustomImageWidget(
                  imageUrl: _controller.avatar,
                  rounded: true,
                  typeEnum: TypeEnum.user,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
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
              const SizedBox(width: 8),
              // StreamBuilder<Object>(
              //   stream: null,
              //   builder: (context, snapshot) {
              //     return AnimatedOpacity(
              //       // opacity:
              //       //     !_controller.isHost && !_controller.isHostAvailable ||
              //       //             _controller.hasMyIdInWaitList()
              //       //         ? 0.0
              //       //         : 1.0,
              //       opacity: !callButtonVisibility() ? 0.0 : 1.0,
              //       duration: const Duration(seconds: 1),
              //       // child: !_controller.isHost &&
              //       //             !_controller.isHostAvailable ||
              //       //         _controller.hasMyIdInWaitList()
              //       child: !callButtonVisibility()
              //           ? const SizedBox()
              //           : Row(
              //               children: [
              //                 InkWell(
              //                   onTap: () async {
              //                     _controller.isCustBlocked.data
              //                                 ?.isCustomerBlocked ==
              //                             1
              //                         ? await youAreBlocked()
              //                         : await callAstrologerPopup();
              //                   },
              //                   child: SizedBox(
              //                     height: 32,
              //                     width: 32,
              //                     child: DecoratedBox(
              //                       decoration: BoxDecoration(
              //                         borderRadius: const BorderRadius.all(
              //                           Radius.circular(50.0),
              //                         ),
              //                         border: Border.all(
              //                           color: appColors.guideColor,
              //                         ),
              //                         color: appColors.black.withOpacity(0.2),
              //                       ),
              //                       child: Padding(
              //                         padding: const EdgeInsets.all(0.0),
              //                         child: Image.asset(
              //                           "assets/images/live_new_plus_icon.png",
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //                 const SizedBox(width: 8),
              //               ],
              //             ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool callButtonVisibility() {
    // final Data data = _controller.details.data ?? Data();
    // final bool isLiveVideo = (data.is_live_video_call ?? 0) == 1;
    // final bool isLiveAudio = (data.is_live_audio_call ?? 0) == 1;
    // final bool isLiveAnonymous = (data.is_live_anonymous_call ?? 0) == 1;

    // final bool cond1 = !_controller.isHost;
    // final bool cond2 = _controller.isHostAvailable;
    // final bool cond3 = !_controller.hasMyIdInWaitList();
    // final bool cond4 = isLiveVideo || isLiveAudio || isLiveAnonymous;

    // final bool result = cond1 && cond2 && cond3 && cond4;
    // return result;
    return false;
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
              color: appColors.guideColor,
            ),
            color: appColors.black.withOpacity(0.2),
          ),
          child: Row(
            children: <Widget>[
              /*const SizedBox(width: 8),
              InkWell(
                onTap: navigate,
                child: SizedBox(
                  height: 32,
                  width: 52,
                  child: stacked(),
                ),
              ),*/
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_controller.userName} with ${_controller.currentCaller.userName!}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          "${_controller.currentCaller.callType!.capitalize ?? ""} Call:",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: newTimerWidget()),
                        /*Expanded(child: Obx(() {
                          // newTimerWidget();
                          return diff.value != ""
                              ? Text(
                                  diff.value,
                                  style: AppTextStyle.textStyle14(
                                    fontColor: appColors.white,
                                  ),
                                )
                              : Text("");
                        })),*/
                      ],
                    ),
                  ],
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
    return Obx(
      () => InkWell(
        onTap: () async {
          //
          //
          await exitFunc();
          //
          //
        },
        child: _controller.isEndCallLoading.value
            ? const SizedBox.shrink()
            : SizedBox(
                height: 50,
                width: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                    border: Border.all(
                      color: appColors.guideColor,
                    ),
                    color: appColors.black.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      _controller.currentCaller.isEngaded!
                          ? "assets/images/live_new_hang_up.png"
                          : "assets/images/live_exit_red.png",
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  RxString diff = "".obs;
  Timer? countDownTimer;

  // int epoch = 0;

  newTimerWidget() {
    final String source = _controller.currentCaller.totalTime!;
    int epoch = int.parse(source.isEmpty ? "0" : source);
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      timeTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      onTick: (Duration duration) async {},
      endTime: dateTime,
      onEnd: () async {
        print("time is ending newTimerWidget");
        await removeCoHostOrStopCoHost();
      },
    );
  }

  bool isLessThanOneMinute(Duration duration) {
    return duration < const Duration(minutes: 1);
  }

  Future<void> extendTimeWidgetPopup() async {
    LiveGlobalSingleton().isExtendTimeWidgetPopupOpen = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ExtendTimeWidget(
          onClose: Get.back,
          isAstro: true,
          yesExtend: () async {
            Get.back();
            // await _controller.extendTime();
          },
          noExtend: () {
            Get.back();
          },
        );
      },
    );
    LiveGlobalSingleton().isExtendTimeWidgetPopupOpen = false;
    return Future<void>.value();
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
            typeEnum: TypeEnum.user,
          ),
        ),
        Positioned(
          left: 20.0,
          child: SizedBox(
            height: 32,
            width: 32,
            child: CustomImageWidget(
              imageUrl: _controller.currentCaller.avatar!,
              rounded: true,
              typeEnum: TypeEnum.user,
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
        _controller.currentCaller.isEngaded!
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
                _controller.isFront = !_controller.isFront;
                zegoController.audioVideo.camera
                    .switchFrontFacing(_controller.isFront);
                _controller.update();
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
                      color: appColors.transparent,
                    ),
                    color: appColors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
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
                _controller.isCamOn = !_controller.isCamOn;
                await _controller.liveStore.doc(_controller.userId).update({
                  'isCamOn': _controller.isCamOn,
                }).then((value) {
                  print("update isCamOn");
                });
                zegoController.audioVideo.camera
                    .turnOn(_controller.isCamOn, userID: _controller.userId);
                _controller.update();
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
                      // color: appColors.guideColor,
                      color: appColors.transparent,
                    ),
                    // color: appColors.black.withOpacity(0.2),
                    color: appColors.transparent,
                  ),
                  child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(0.0),
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
                _controller.isMicOn = !_controller.isMicOn;

                zegoController.audioVideo.microphone
                    .turnOn(_controller.isMicOn, userID: _controller.userId);
                _controller.update();
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
                      // color: appColors.guideColor,
                      color: appColors.transparent,
                    ),
                    // color: appColors.black.withOpacity(0.2),
                    color: appColors.transparent,
                  ),
                  child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      _controller.isMicOn
                          ? "assets/images/live_mic_on.png"
                          : "assets/images/live_mic_off.png",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget settingsColForCust() {
    final bool isEngaded = _controller.currentCaller.isEngaded!;
    final String type = _controller.currentCaller.callType!;
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
                              color: appColors.guideColor,
                            ),
                            color: appColors.black.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset(
                              _controller.currentCaller.isEngaded!
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
                        _controller.isFront = !_controller.isFront;
                        zegoController.audioVideo.camera
                            .switchFrontFacing(_controller.isFront);
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
                              color: appColors.guideColor,
                            ),
                            color: appColors.black.withOpacity(0.2),
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
                        // final ZegoUIKit instance = ZegoUIKit.instance;
                        _controller.isCamOn = !_controller.isCamOn;
                        // instance.turnCameraOn(_controller.isCamOn);
                        zegoController.audioVideo.camera.turnOn(
                            _controller.isCamOn,
                            userID: _controller.userId);
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
                              color: appColors.guideColor,
                            ),
                            color: appColors.black.withOpacity(0.2),
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
                        // final ZegoUIKit instance = ZegoUIKit.instance;
                        _controller.isMicOn = !_controller.isMicOn;
                        // instance.turnMicrophoneOn(_controller.isMicOn,
                        //     muteMode: true);
                        zegoController.audioVideo.microphone.turnOn(
                            _controller.isMicOn,
                            userID: _controller.userId);
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
                              color: appColors.guideColor,
                            ),
                            color: appColors.black.withOpacity(0.2),
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
        Obx(
          () => _controller.blockedCustomerList.isEmpty
              ? SizedBox.shrink()
              : Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        openBottomSheet(
                          context,
                          functionalityWidget: Container(
                            constraints: BoxConstraints(
                              maxHeight: Get.height - 200,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Blocked Customers",
                                  style: TextStyle(
                                    color: appColors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        _controller.blockedCustomerList.length,
                                    itemBuilder: (context, index) {
                                      BlockedCustomerListResData item =
                                          _controller
                                              .blockedCustomerList[index];
                                      GetCustomers? customer =
                                          item.getCustomers;
                                      return ListTile(
                                        leading: Container(
                                          height: 30,
                                          width: 30,
                                          margin: const EdgeInsets.only(top: 3),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: appColors.guideColor,
                                          ),
                                          child: Text(
                                              customer?.name
                                                      ?.split("")
                                                      .first
                                                      .toUpperCase() ??
                                                  'N',
                                              style: TextStyle(
                                                color:
                                                    appColors.whiteGuidedColor,
                                                fontSize: 12,
                                                fontFamily: "Metropolis",
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                        title: Text(customer?.name ?? 'N/A'),
                                        // subtitle: Text(customer.email!),
                                        trailing: SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  appColors.guideColor,
                                            ),
                                            onPressed: () async {
                                              await blockUnblockPopup(
                                                  isAlreadyBeenBlocked: true,
                                                  performAction: () async {
                                                    await _controller
                                                        .callblockCustomer(
                                                      id: customer?.id ?? 0,
                                                      successCallBack:
                                                          (String message) {
                                                        successAndFailureCallBack(
                                                          message: message,
                                                          isForSuccess: true,
                                                          isForFailure: false,
                                                        );
                                                      },
                                                      failureCallBack:
                                                          (String message) {
                                                        successAndFailureCallBack(
                                                          message: message,
                                                          isForSuccess: false,
                                                          isForFailure: true,
                                                        );
                                                      },
                                                    );
                                                    var data = {
                                                      "room_id":
                                                          _controller.userId,
                                                      "user_id": customer?.id,
                                                      "user_name":
                                                          customer?.name,
                                                      "item": item.toJson(),
                                                      "type": "Block/Unblock",
                                                    };
                                                    await _controller
                                                        .sendGiftAPI(
                                                      data: data,
                                                      count: 1,
                                                      svga: "",
                                                      successCallback: log,
                                                      failureCallback: log,
                                                    );
                                                  });
                                            },
                                            child: Text("Unblock",
                                                style: TextStyle(
                                                  color: appColors.white,
                                                )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(0.0),
                          //   child: Icon(
                          //     Icons.category,
                          //     color: appColors.guideColor,
                          //   ),
                          // ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/svg/block-user-new.svg",
                              height: 25,
                              width: 25,
                              color: Colors.white,
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
          opacity: !_controller.currentCaller.isEngaded! ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: !_controller.currentCaller.isEngaded!
              ? const SizedBox()
              : Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        // await _controller.addOrUpdateCard();
                        await showCardDeckToUserPopup();
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
                              color: appColors.guideColor,
                            ),
                            color: appColors.black.withOpacity(0.2),
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(0.0),
                          //   child: Icon(
                          //     Icons.category,
                          //     color: appColors.guideColor,
                          //   ),
                          // ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/images/live_tarot_new_icon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "Ask User",
                      style: TextStyle(fontSize: 8, color: appColors.white),
                    ),
                    Text(
                      "for tarot",
                      style: TextStyle(fontSize: 8, color: appColors.white),
                    ),
                    Text(
                      "reading",
                      style: TextStyle(fontSize: 8, color: appColors.white),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
        ),
        //
        Obx(() {
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
                                color: appColors.guideColor,
                              ),
                              color: appColors.black.withOpacity(0.2),
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
                                                  appColors.guideColor,
                                              child: Text(
                                                _controller.waitListModel.length
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
        }),
        AnimatedOpacity(
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
                              color: appColors.guideColor,
                            ),
                            color: appColors.black.withOpacity(0.2),
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
        ),
        GestureDetector(
          onTap: () {
            if (ZegoUIKit.instance.getPlugin(ZegoUIKitPluginType.beauty) !=
                null) {
              ZegoUIKit.instance.getBeautyPlugin().showBeautyUI(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  "assets/svg/beauty_icon.svg",
                  height: 50,
                  width: 50,
                ),
                const Text(
                  "Beautify",
                  style:
                      TextStyle(fontFamily: "Metropolis", color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          return AnimatedOpacity(
            opacity: isLiveCall.value == 0 ? 0.0 : 1.0,
            duration: const Duration(seconds: 1),
            child: isLiveCall.value == 0
                ? const SizedBox()
                : Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          _controller.isHostAvailable.value =
                              !_controller.isHostAvailable.value;
                          await _controller.liveStore
                              .doc(_controller.userId)
                              .update(
                            {
                              "isAvailable": _controller.isHostAvailable.value,
                            },
                          );
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
                                color: appColors.guideColor,
                              ),
                              color: appColors.black.withOpacity(0.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.asset(
                                _controller.isHostAvailable.value
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
        }),
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
                  color: appColors.guideColor,
                ),
                color: appColors.black.withOpacity(0.2),
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

  Future<void> sendMessageToZego(ZegoCustomMessage model) async {
    final String encodedstring = json.encode(model.toJson());
    print(encodedstring);
    print("encodedstringencodedstring");
    await zegoController.message.send(encodedstring);
    return Future<void>.value();
  }

  ZegoCustomMessage receiveMessageToZego(String model) {
    final Map<String, dynamic> decodedMap = json.decode(model);
    final ZegoCustomMessage msgModel = ZegoCustomMessage.fromJson(decodedMap);
    return msgModel;
  }

  Future<void> exitFunc() async {
    final bool isEngaded = _controller.currentCaller.isEngaded!;
    // final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
    if (isEngaded) {
      await disconnectPopup(
        noDisconnect: () {},
        yesDisconnect: () async {
          print("when exit function");
          await removeCoHostOrStopCoHost();
        },
      );
    } else {
      await endLiveSession(
        endLive: () async {
          if (mounted) {
            _timer?.cancel();
            _msgTimerForFollowPopup?.cancel();
            _msgTimerForTarotCardPopup?.cancel();
            await _controller.liveStore.doc(_controller.userId).delete();
            await _controller.liveCount.doc(_controller.userId).delete();
            await zegoController.leave(context);
          } else {}
        },
      );
    }
    return Future<void>.value();
  }

  Future<void> keyboardPop() async {
    _isKeyboardSheetOpen = true;
    LiveGlobalSingleton().isKeyboardPopupOpen = true;
    await showModalBottomSheet(
      context: context,
      elevation: 0,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return LiveKeyboard(sendKeyboardMesage: sendKeyboardMesage);
      },
    );
    _isKeyboardSheetOpen = false;
    LiveGlobalSingleton().isKeyboardPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> sendKeyboardMesage(msg) async {
    final String text = _controller.algoForSendMessage(msg);
    final bool hasBadWord = _controller.hasMessageContainsAnyBadWord(msg);
    if (text.isNotEmpty) {
      successAndFailureCallBack(
        message: "$text is restricted text",
        isForSuccess: false,
        isForFailure: true,
      );
    } else if (hasBadWord) {
      successAndFailureCallBack(
        message: "Bad words are restricted",
        isForSuccess: false,
        isForFailure: true,
      );
    } else {
      final ZegoCustomMessage model = ZegoCustomMessage(
        type: 1,
        liveId: _controller.userId,
        userId: _controller.userId,
        userName: _controller.userName,
        avatar: _controller.avatar,
        message: msg,
        timeStamp: DateTime.now().toString(),
        fullGiftImage: "",
        isBlockedCustomer: _controller.isCustomerBlockedBool(),
        isMod: _controller.isMod,
      );
      await sendMessageToZego(model);
    }

    FocusManager.instance.primaryFocus?.unfocus();
    scrollDownForTop();
    scrollDownForBottom();
    getUntil();
    return Future<void>.value();
  }

  ZegoUIKitPrebuiltLiveStreamingEvents get events {
    return ZegoUIKitPrebuiltLiveStreamingEvents(
      onStateUpdated: onLiveStreamingStateUpdate,
      audioVideo: ZegoLiveStreamingAudioVideoEvents(
        onCameraTurnOnByOthersConfirmation: (context) {
          return Future<bool>.value(true);
        },
        onMicrophoneTurnOnByOthersConfirmation: (context) {
          return Future<bool>.value(true);
        },
      ),
      topMenuBar: ZegoLiveStreamingTopMenuBarEvents(
        onHostAvatarClicked: (host) {},
      ),
      memberList: ZegoLiveStreamingMemberListEvents(
        onClicked: (user) {},
      ),
      inRoomMessage: ZegoLiveStreamingInRoomMessageEvents(
        onClicked: (message) {},
        onLocalSend: (message) {},
        onLongPress: (message) {},
      ),
      duration: ZegoLiveStreamingDurationEvents(
        onUpdated: (duration) {},
      ),
      coHost: ZegoLiveStreamingCoHostEvents(
        coHost: ZegoLiveStreamingCoHostCoHostEvents(
          onLocalDisconnected: () {
            Fluttertoast.showToast(msg: "user left");
          },
          onLocalConnectStateUpdated:
              (ZegoLiveStreamingAudienceConnectState connectState) {
            print(connectState);
            print("connectState");
          },
        ),
        host: ZegoLiveStreamingCoHostHostEvents(
          onRequestReceived:
              (ZegoLiveStreamingCoHostHostEventRequestReceivedData user) async {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostRequestReceived");

            if (_controller.extendTimeWidgetVisible) {
              _controller.extendTimeWidgetVisible = false;
            } else {}

            await onCoHostRequest(
              user: user.audience,
              userId: user.audience.id,
              userName: user.audience.name,
              avatar: "https://robohash.org/avatarWidget",
            );
          },
          onRequestCanceled:
              (ZegoLiveStreamingCoHostHostEventRequestCanceledData user) async {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostRequestCanceled");
            // await onCoHostRequestCanceled(user);
          },
          onRequestTimeout:
              (ZegoLiveStreamingCoHostHostEventRequestTimeoutData user) {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostRequestTimeout");
          },
          onActionAcceptRequest: () {
            showNotifOverlay(user: null, msg: "onActionAcceptCoHostRequest");
          },
          onActionRefuseRequest: () {
            showNotifOverlay(user: null, msg: "onActionRefuseCoHostRequest");
          },
          onInvitationSent:
              (ZegoLiveStreamingCoHostHostEventInvitationSentData user) async {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostInvitationSent");
            await _controller.addUpdateToWaitList(
              customerId: user.audience.id,
              callType: "",
              isEngaded: false,
              isRequest: false,
              callStatus: 1,
            );
          },
          onInvitationTimeout:
              (ZegoLiveStreamingCoHostHostEventInvitationTimeoutData user) {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostInvitationTimeout");
            print(user.audience.id);
            print("user.id");
            if (isAcceptPopupOpen) {
              Get.back();
              print("if timeout");
            } else {
              print("else timeout");
            }
            // _controller.removeFromWaitList(customerId:user.id);
            successAndFailureCallBack(
              message: "${user.audience.name} timeout to take the call",
              isForSuccess: false,
              isForFailure: true,
            );
          },
          onInvitationAccepted:
              (ZegoLiveStreamingCoHostHostEventInvitationAcceptedData user) {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostInvitationAccepted");
          },
          onInvitationRefused:
              (ZegoLiveStreamingCoHostHostEventInvitationRefusedData user) {
            showNotifOverlay(
                user: user.audience, msg: "onCoHostInvitationRefused");

            if (isAcceptPopupOpen) {
              Get.back();
            } else {}

            successAndFailureCallBack(
              message: "${user.audience.name} refused to take the call",
              isForSuccess: false,
              isForFailure: true,
            );
          },
        ),
        audience: ZegoLiveStreamingCoHostAudienceEvents(
          onRequestSent: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestSent");
          },
          onActionCancelRequest: () {
            showNotifOverlay(user: null, msg: "onActionCancelCoHostRequest");
          },
          onRequestTimeout: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestTimeout");
          },
          onRequestAccepted:
              (ZegoLiveStreamingCoHostAudienceEventRequestAcceptedData user) {
            showNotifOverlay(user: null, msg: "onCoHostRequestAccepted");
          },
          onRequestRefused:
              (ZegoLiveStreamingCoHostAudienceEventRequestRefusedData user) {
            showNotifOverlay(user: null, msg: "onCoHostRequestRefused");
          },
          onInvitationReceived:
              (ZegoLiveStreamingCoHostAudienceEventRequestReceivedData user) {
            showNotifOverlay(
                user: user.host, msg: "onCoHostInvitationReceived");
          },
          onInvitationTimeout: () {
            showNotifOverlay(user: null, msg: "onCoHostInvitationTimeout");
          },
          onActionAcceptInvitation: () {
            showNotifOverlay(user: null, msg: "onActionAcceptCoHostInvitation");
          },
          onActionRefuseInvitation: () {
            showNotifOverlay(user: null, msg: "onActionRefuseCoHostInvitation");
          },
        ),
      ),
      onEnded: (ZegoLiveStreamingEndEvent event, VoidCallback defaultAction) {},
      room: ZegoLiveStreamingRoomEvents(
        onStateChanged: (value) {},
      ),
      user: ZegoLiveStreamingUserEvents(
        onEnter: (ZegoUIKitUser zegoUIKitUser) async {
          // await onUserJoin(zegoUIKitUser);
        },
        onLeave: (ZegoUIKitUser zegoUIKitUser) async {
          await onUserLeave(zegoUIKitUser);
        },
      ),
    );
  }

  List joinedAstrologerList = [];

  Future<void> onCoHostRequest({
    required ZegoUIKitUser user,
    required String userId,
    required String userName,
    required String avatar,
  }) async {
    isAcceptPopupOpen = true;
    isAcceptPopupOpenFor = user;
    await hostingAndCoHostingPopup(
      onClose: () {},
      needAcceptButton: true,
      needDeclinetButton: false,
      onAcceptButton: () async {
        print("${user.id}");
        print("user name ---- ${user.name}");
        print("calling accept button");
        final connectInvite = zegoController.coHost;
        print("calling accept button");
        await connectInvite.hostSendCoHostInvitationToAudience(user);
        Get.back();
      },
      onDeclineButton: () {},
      user: user,
      userId: userId,
      userName: userName,
      avatar: avatar,
    );
    isAcceptPopupOpen = false;
    isAcceptPopupOpenFor = ZegoUIKitUser(id: "", name: "");
    return Future<void>.value();
  }

  Future<void> removeCoHostOrStopCoHost() async {
    final ZegoUIKitUser user = ZegoUIKitUser(
      id: _controller.currentCaller.id!,
      name: _controller.currentCaller.userName!,
    );
    final connect = zegoController.coHost;
    final bool removed = await connect.removeCoHost(user);
    if (kDebugMode) {
      divineSnackBar(data: "Call disconnected");
      print(removed);
      print("removing-co-host");
    }

    if (removed) {
      _controller.isEndCallLoading.value = true;
      await _controller.makeAPICallForEndCall(
        successCallBack: (String message) async {
          _controller.isEndCallLoading.value = false;
          successAndFailureCallBack(
              message: message, isForSuccess: true, isForFailure: false);
          await _controller.removeFromOrder();
        },
        failureCallBack: (String message) async {
          _controller.isEndCallLoading.value = false;
          await _controller.removeFromOrder();
          successAndFailureCallBack(
            message: message,
            isForSuccess: false,
            isForFailure: true,
          );
        },
      );
    }
    print("Removing after Call");
    // reJoinAsAudience(user.id);
    if (_controller.extendTimeWidgetVisible) {
      _controller.extendTimeWidgetVisible = false;
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
    LiveGlobalSingleton().isHostingAndCoHostingPopupOpen = true;
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
          onAcceptButton: onAcceptButton,
          onDeclineButton: () {
            Get.back();
            onDeclineButton();
          },
          userId: userId,
          avatar: avatar,
          userName: userName,
          isHost: true,
          onTimeout: () {
            Get.back();
          },
        );
      },
    );
    LiveGlobalSingleton().isHostingAndCoHostingPopupOpen = false;
    return Future<void>.value();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("app is detached");
      // await LiveGlobalSingleton().leaveLiveIfIsInLiveScreen();
      await _controller.removeMyNode(context);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    _controller.tarotCardInit();
    await _controller.noticeBoard(
      successCallBack: (String message) {
        successAndFailureCallBack(
          message: message,
          isForSuccess: true,
          isForFailure: false,
        );
      },
      failureCallBack: (String message) {
        successAndFailureCallBack(
          message: message,
          isForSuccess: false,
          isForFailure: true,
        );
      },
    );
    await _controller.callBlockedCustomerListRes(
      successCallBack: (String message) {
        successAndFailureCallBack(
          message: message,
          isForSuccess: true,
          isForFailure: false,
        );
      },
      failureCallBack: (String message) {
        successAndFailureCallBack(
          message: message,
          isForSuccess: false,
          isForFailure: true,
        );
      },
    );
    return Future<void>.value();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
