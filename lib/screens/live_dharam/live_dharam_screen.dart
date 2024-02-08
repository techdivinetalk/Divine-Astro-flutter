// ignore_for_file: lines_longer_than_80_chars

import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:math" as math;

import "package:after_layout/after_layout.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/model/astrologer_gift_response.dart";
import "package:divine_astrologer/model/live/deck_card_model.dart";
import "package:divine_astrologer/model/live/notice_board_res.dart";
import "package:divine_astrologer/screens/live_dharam/gifts_singleton.dart";
import "package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart";
import "package:divine_astrologer/screens/live_dharam/live_screen_widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/live_screen_widgets/live_keyboard.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/chosen_cards.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/live_carousal.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/show_card_deck_to_user.dart";
import "package:divine_astrologer/screens/live_dharam/live_tarot_game/waiting_for_user_to_select_cards.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/already_in_waitlist_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/astro_wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/block_unlock_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/call_accept_or_reject_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/disconnect_call_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/end_session_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/exit_wait_list_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/follow_player.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/gift_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/leaderboard_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/more_options_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/notif_overlay.dart";
import "package:divine_astrologer/screens/live_dharam/you_are_blocked_widget.dart";
import "package:divine_astrologer/screens/live_dharam/zego_team/player.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_broadcasts/flutter_broadcasts.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart";
import "package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart";
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import "package:divine_astrologer/screens/live_dharam/widgets/show_all_avail_astro_widget.dart";
import "package:divine_astrologer/screens/live_dharam/widgets/extend_time_widget.dart";
import 'package:random_name_generator/random_name_generator.dart';
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

  late StreamSubscription<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      _zegocloudSubscription;

  late StreamSubscription<DatabaseEvent> _firebaseSubscription;

  final ScrollController _scrollControllerForTop = ScrollController();
  final ScrollController _scrollControllerForBottom = ScrollController();

  final keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> keyboardSubscription;

  bool _isKeyboardSheetOpen = false;
  Timer? _timer;
  Timer? _msgTimer;
  Timer? _msgTimerLiveMonitoring;
  Timer? _msgTimerForFollowPopup;

  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>["LiveDharamScreen_eventListner"],
  );

  final List<String> indianGreetings = <String>[
    // # English
    "Hi", "Hello", "Good morning", "Good afternoon", "Good evening", "Hey",
    // # Hindi
    "नमस्ते", "हाय", "हेलो", "नमस्कार", "नमस्ते जी",
    // # Bengali
    "হাই", "হ্যালো", "নমস্কার",
    // # Telugu
    "నమస్కారం", "హలో", "హాయ్",
    // # Tamil
    "வணக்கம்", "ஹலோ", "அருங்காட்சி",
    // # Kannada
    "ಹಲೋ", "ಹಾಯ್", "ನಮಸ್ಕಾರ",
    // # Malayalam
    "നമസ്കാരം", "ഹലോ", "ഹായ്",
    // # Punjabi
    "ਹੈਲੋ", "ਹੈ", "ਨਮਸਤੇ",
    // # Gujarati
    "હેલો", "નમસ્તે", "નમસ્કાર",
    // # Marathi
    "नमस्कार", "हॅलो", "हाय",
    // # Urdu
    "ہیلو", "ہائے", "سلام",
    // # Sanskrit
    "नमस्ते", "सुप्रभातम्", "अय्यो",
    // # Odia
    "ହେଲୋ", "ନମସ୍କାର", "ହାଇ"
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _zegocloudSubscription = ZegoUIKit()
        .getSignalingPlugin()
        .getInRoomCommandMessageReceivedEventStream()
        .listen(onInRoomCommandMessageReceived);

    _firebaseSubscription =
        FirebaseDatabase.instance.ref().child("live").onValue.listen(
      (event) async {
        final DataSnapshot dataSnapshot = event.snapshot;
        await _controller.eventListner(
          snapshot: dataSnapshot,
          zeroAstro: zeroAstro,
          engaging: engaging,
          showFollowPopup: _restartMsgTimerForFollowPopup,
          successCallBack: (String message) async {
            await successAndFailureCallBack(
              message: message,
              isForSuccess: true,
              isForFailure: false,
            );
          },
          failureCallBack: (String message) async {
            await successAndFailureCallBack(
              message: message,
              isForSuccess: false,
              isForFailure: true,
            );
          },
        );
      },
    );

    ZegoUIKit().getUserJoinStream().listen(onUserJoin);
    ZegoUIKit().getUserLeaveStream().listen(onUserLeave);

    keyboardSubscription = keyboardVisibilityController.onChange.listen(
      (bool visible) {
        if (visible == false && _isKeyboardSheetOpen == true) {
          Navigator.of(context).pop();
        } else {}
      },
    );

    _startTimer();
    // _startMsgTimer();
    _startMsgTimerLiveMonitoring();
    // _startMsgTimerForFollowPopup();

    receiver.start();
    receiver.messages.listen(
      (event) async {
        final DatabaseReference ref = FirebaseDatabase.instance.ref();
        final DataSnapshot dataSnapshot = await ref.child("live").get();
        await _controller.eventListner(
          snapshot: dataSnapshot,
          zeroAstro: zeroAstro,
          engaging: engaging,
          showFollowPopup: _restartMsgTimerForFollowPopup,
          successCallBack: (String message) async {
            await successAndFailureCallBack(
              message: message,
              isForSuccess: true,
              isForFailure: false,
            );
          },
          failureCallBack: (String message) async {
            await successAndFailureCallBack(
              message: message,
              isForSuccess: false,
              isForFailure: true,
            );
          },
        );
      },
    );
  }

  Future<void> successAndFailureCallBack({
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
            backgroundColor: AppColors.yellow,
            behavior: SnackBarBehavior.floating,
          );
          if (isForSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (isForFailure) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {}
        } else {}
      },
    );
    return Future<void>.value();
  }

  Future<void> zeroAstro() async {
    // if (mounted) {
    //   _timer?.cancel();
    //   _msgTimer?.cancel();
    //   _msgTimerLiveMonitoring?.cancel();
    //   _msgTimerForFollowPopup?.cancel();
    //   await _zegoController.leave(context);
    //   // unawaited(_zegoController.leave(context));
    // } else {}
    return Future<void>.value();
  }

  // Future<void> engaging(WaitListModel currentCaller) async {
  //   final String id = currentCaller.id;
  //   final String name = currentCaller.userName;
  //   final String avatar = currentCaller.avatar;
  //   final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);

  //   WidgetsBinding.instance.endOfFrame.then(
  //     (_) async {
  //       if (mounted) {
  //         await onCoHostRequest(
  //           user: user,
  //           userId: id,
  //           userName: name,
  //           avatar: avatar,
  //         );
  //       } else {}
  //     },
  //   );
  //   return Future<void>.value();
  // }

  Future<void> engaging(WaitListModel currentCaller) async {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          final bool preCond1 =
              _controller.openAceeptRejectDialogForId != currentCaller.id;
          final bool preCond2 = _controller.hasCallAcceptRejectPopupOpen;

          preCond1 && preCond2
              ? Get.back()
              : _controller.openAceeptRejectDialogForId = currentCaller.id;

          final bool cond1 = _controller.isHost;
          final bool cond2 = _controller.waitListModel.length > 0;
          final bool cond3 = currentCaller.id.isNotEmpty;
          final bool cond4 = !currentCaller.isEngaded;
          final bool cond5 = !currentCaller.isRequest;

          if (cond1 && cond2 && cond3 && cond4 && cond5) {
            final String id = currentCaller.id;
            final String name = currentCaller.userName;
            final String avatar = currentCaller.avatar;
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

  Future<void> showFollowPopup() async {
    // WidgetsBinding.instance.endOfFrame.then(
    //   (_) async {
    //     if (mounted) {
    //       final String liveId = _controller.liveId;
    //       final isNotFollowing = (_controller.details.data?.isFollow ?? 0) == 0;
    //       final hasDataId =  (_controller.details.data?.id ?? 0) != 0;
    //       final hasntSeenPopup = !_controller.astroFollowPopup.contains(liveId);
    //       final hasntOpenPopup = !_controller.hasFollowPopupOpen;
    //       if (isNotFollowing && hasDataId && hasntSeenPopup && hasntOpenPopup) {
    //         _controller.astroFollowPopup = [
    //           ...[_controller.liveId]
    //         ];
    //         await exitPopup();
    //       } else {}
    //     } else {}
    //   },
    // );
    return Future<void>.value();
  }

  void _startTimer() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          const duration = Duration(seconds: 1);
          _timer = Timer.periodic(
            duration,
            (Timer timer) {
              if (timer.tick % 15 == 0) {
                _controller.timerCurrentIndex++;
                if (_controller.timerCurrentIndex >
                    (_controller.noticeBoardRes.data?.length ?? 0)) {
                  _controller.timerCurrentIndex = 1;
                } else {}
              } else {}
            },
          );
        } else {}
      },
    );
  }

  void _startMsgTimer() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          const duration = Duration(seconds: 1);
          _msgTimer = Timer.periodic(
            duration,
            (Timer timer) async {
              if (timer.tick % 5 == 0) {
                math.Random.secure().nextInt(50).isEven
                    ? await manMessage()
                    : await womanMessage();
              } else {}
            },
          );
        } else {}
      },
    );
  }

  void _startMsgTimerForFollowPopup() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          const duration = Duration(seconds: 1);
          _msgTimerForFollowPopup = Timer.periodic(
            duration,
            (Timer timer) async {
              if (timer.tick % 15 == 0) {
                await showFollowPopup();
              } else {}
            },
          );
        } else {}
      },
    );
  }

  void _restartMsgTimerForFollowPopup() {
    _msgTimerForFollowPopup?.cancel();
    _startMsgTimerForFollowPopup();
    return;
  }

  Future<void> manMessage() async {
    var num = math.Random.secure().nextInt(50);
    var url = "https://xsgames.co/randomusers/assets/avatars/male/$num.jpg";
    final String fullName = RandomNames(Zone.india).manFullName();
    final ZegoCustomMessage model = ZegoCustomMessage(
      type: 1,
      liveId: _controller.liveId,
      userId: "0",
      userName: fullName,
      avatar: url,
      message: indianGreetings[num],
      timeStamp: DateTime.now().toString(),
      fullGiftImage: "",
      isBlockedCustomer: _controller.isCustomerBlockedBool(),
    );
    await sendMessageToZego(model);
    return Future<void>.value();
  }

  Future<void> womanMessage() async {
    var num = math.Random.secure().nextInt(50);
    var url = "https://xsgames.co/randomusers/assets/avatars/female/$num.jpg";
    final String fullName = RandomNames(Zone.india).womanFullName();
    final ZegoCustomMessage model = ZegoCustomMessage(
      type: 1,
      liveId: _controller.liveId,
      userId: "0",
      userName: fullName,
      avatar: url,
      message: indianGreetings[num],
      timeStamp: DateTime.now().toString(),
      fullGiftImage: "",
      isBlockedCustomer: _controller.isCustomerBlockedBool(),
    );
    await sendMessageToZego(model);
    return Future<void>.value();
  }

  void _startMsgTimerLiveMonitoring() {
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          const duration = Duration(minutes: 1);
          _msgTimerLiveMonitoring = Timer.periodic(
            duration,
            (Timer timer) async {
              if (timer.tick % 15 == 0) {
                final ZegoCustomMessage model = ZegoCustomMessage(
                  type: 1,
                  liveId: _controller.liveId,
                  userId: "0",
                  userName: "Live Monitoring Team",
                  avatar:
                      "https://divinenew-prod.s3.ap-south-1.amazonaws.com/divine/January2024/fGfpNU1Y40lV0ojgh0JBpgbc4mJtAdV6hgG5xZXJ.jpg",
                  message: "Live Monitoring Team Joined",
                  timeStamp: DateTime.now().toString(),
                  fullGiftImage: "",
                  isBlockedCustomer: false,
                );
                await sendMessageToZego(model);
              } else {}
            },
          );
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
    //   isBlockedCustomer: _controller.isCustomerBlockedBool(),
    // );
    // await sendMessageToZego(model);
    Future<void>.value();
  }

  Future<void> onUserLeave(List<ZegoUIKitUser> users) async {
    if (_controller.currentCaller.isEngaded) {
      await removeCoHostOrStopCoHost();
    } else {}
    Future<void>.value();
  }

  @override
  void dispose() {
    // keyboardSubscription.cancel();
    // unawaited(_zegocloudSubscription.cancel());
    // unawaited(_firebaseSubscription.cancel());
    // _scrollControllerForTop.dispose();
    // _scrollControllerForBottom.dispose();
    // _timer?.cancel();
    // _msgTimer?.cancel();
    // _msgTimerLiveMonitoring?.cancel();
    // _msgTimerForFollowPopup?.cancel();
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
                      ..preview.showPreviewForHost = false
                      ..maxCoHostCount = 1
                      ..confirmDialogInfo = null
                      ..disableCoHostInvitationReceivedDialog = true
                      ..audioVideoView = ZegoLiveStreamingAudioVideoViewConfig(
                        showUserNameOnView: false,
                        showAvatarInAudioMode: true,
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
                      ..turnOnCameraWhenCohosted = () {
                        final callType = _controller.currentCaller.callType;
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
                      ..audioVideoView.playCoHostVideo = (
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
                      ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                        showInRoomMessageButton: false,
                        hostButtons: <ZegoMenuBarButtonName>[],
                        coHostButtons: <ZegoMenuBarButtonName>[],
                      )
                      ..layout = galleryLayout()
                      // ..swipingConfig = swipingConfig
                      ..swiping = swipingConfig
                      // ..onLiveStreamingStateUpdate = onLiveStreamingStateUpdate
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
                          // return Row(
                          //   children: [
                          //     SizedBox(
                          //       height: 32,
                          //       width: 48,
                          //       child: DecoratedBox(
                          //         decoration: BoxDecoration(
                          //           borderRadius: const BorderRadius.all(
                          //             Radius.circular(50.0),
                          //           ),
                          //           border: Border.all(
                          //             color: AppColors.yellow,
                          //           ),
                          //           color: AppColors.black.withOpacity(0.2),
                          //         ),
                          //         child: Padding(
                          //           padding: const EdgeInsets.symmetric(
                          //             horizontal: 8.0,
                          //           ),
                          //           child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.center,
                          //             children: [
                          //               const Icon(
                          //                 Icons.remove_red_eye,
                          //                 color: Colors.white,
                          //                 size: 16,
                          //               ),
                          //               Text(
                          //                 memberCount.toString(),
                          //                 style: const TextStyle(
                          //                   color: Colors.white,
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: _controller.isHost ? (16 + 2) : (8 + 2),
                          //     ),
                          //   ],
                          // );
                          return const SizedBox();
                        },
                      )
                      ..memberList = ZegoLiveStreamingMemberListConfig(
                        // onClicked: (ZegoUIKitUser user) {},
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
                    // controller: _zegoController,
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
            // : "https://robohash.org/avatarWidget",
            : "",
        rounded: true,
        typeEnum: TypeEnum.user,
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
          ElevatedButton(
            onPressed: _restartMsgTimerForFollowPopup,
            child: Text("Reset"),
          ),
          // Text(_controller.liveId),
          // const SizedBox(height: 8),
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

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMM yyyy');
    return formatter.format(dateTime);
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
                  final int id = noticeBoardResData.id ?? 0;
                  final String title = noticeBoardResData.title ?? "";
                  final String description =
                      noticeBoardResData.description ?? "";
                  final String createdAt = noticeBoardResData.createdAt ?? "";
                  final DateTime tzDateTime = DateTime.parse(createdAt).toUtc();
                  final String formattedDate = formatDate(tzDateTime);
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      border: Border.all(
                        color: AppColors.yellow,
                      ),
                      color: AppColors.black.withOpacity(0.2),
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
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
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
      // height: 32 + 120,
      height: 32 + 100,
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
        bool isEngaged = _controller.isHost
            ? _controller.currentCaller.isEngaded
            : _controller.engagedCoHostWithAstro().isEngaded;
        return AnimatedOpacity(
          opacity:
              _controller.leaderboardModel.isEmpty || isEngaged ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: _controller.leaderboardModel.isEmpty || isEngaged
              ? const SizedBox()
              : LeaderBoardWidget(
                  avatar: _controller.leaderboardModel.first.avatar,
                  userName: _controller.leaderboardModel.first.userName,
                  fullGiftImage: "",
                  astrologerName: "Astrologer",
                  //
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
  //       // cacheExtent: tempData.length.toDouble(),
  //       cacheExtent: 9999,
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
  //                     height: 52,
  //                     width: 52 * 2,
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
  //                 ? ((_controller.details.data?.isFollow ?? 0) == 1)
  //                     ? const SizedBox()
  //                     : Padding(
  //                         padding:
  //                             const EdgeInsets.only(left: 16.0, right: 16.0),
  //                         child: InkWell(
  //                           onTap: () async {
  //                             await followOrUnfollowFunction();
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
  //                               typeEnum: TypeEnum.gift,
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
  //     // await alreadyInTheWaitListDialog();
  //     await alreadyInWaitlistPopup();
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
  //       successCallBack: (String message) async {
  //           await eventListnerSuccessAndFailureCallBack(
  //             message: message,
  //             isForSuccess: true,
  //             isForFailure: false,
  //           );
  //         },
  //         failureCallBack: (String message) async {
  //           await eventListnerSuccessAndFailureCallBack(
  //             message: message,
  //             isForSuccess: false,
  //             isForFailure: true,
  //           );
  //         },
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
  //         isBlockedCustomer: _controller.isCustomerBlockedBool(),
  //       );
  //       await sendMessageToZego(model0);
  //       // await Future.delayed(const Duration(seconds: 1));
  //       await showHideTopBanner();
  //       // final ZegoCustomMessage model1 = ZegoCustomMessage(
  //       //   type: 1,
  //       //   liveId: _controller.liveId,
  //       //   userId: _controller.userId,
  //       //   userName: _controller.userName,
  //       //   avatar: _controller.avatar,
  //       //   message: quantity > 1
  //       //       ? "${_controller.userName} sent a ${item.giftName} (${quantity}X)"
  //       //       : "${_controller.userName} sent a ${item.giftName}",
  //       //   timeStamp: DateTime.now().toString(),
  //       //   fullGiftImage: item.fullGiftImage,
  //       //   isBlockedCustomer: _controller.isCustomerBlockedBool(),
  //       // );
  //       // await sendMessageToZego(model1);
  //       // await Future.delayed(const Duration(seconds: 1));
  //     } else {}
  //   }
  //   return Future<void>.value();
  // }

  Widget inRoomMessage() {
    return StreamBuilder<List<ZegoInRoomMessage>>(
      stream: _zegoController.message.stream(),
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
          itemCount:
              messages.isNotEmpty && messages.length >= 5 ? 5 : messages.length,
          controller: _scrollControllerForBottom,
          itemBuilder: (BuildContext context, int index) {
            final ZegoInRoomMessage message = messages[index];
            final ZegoCustomMessage msg = receiveMessageToZego(message.message);
            final bool isBlocked =
                _controller.firebaseBlockUsersIds.contains(msg.userId);
            final isLiveMonitoringTeam = msg.userName == "Live Monitoring Team";
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
                            typeEnum: TypeEnum.user,
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
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isBlocked
                                            ? Colors.red
                                            : isLiveMonitoringTeam
                                                ? AppColors.yellow
                                                : Colors.white,
                                        shadows: const [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      msg.message ?? "",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isBlocked
                                            ? Colors.red
                                            : isLiveMonitoringTeam
                                                ? AppColors.yellow
                                                : Colors.white,
                                        shadows: const [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              _controller.isHost &&
                                      !_controller.currentCaller.isEngaded &&
                                      !isLiveMonitoringTeam
                                  ? SizedBox(
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
                                    )
                                  : const SizedBox(),
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
    return SizedBox(
      height: 32,
      width: Get.width / 1.5,
      child: StreamBuilder<List<ZegoInRoomMessage>>(
        stream: _zegoController.message.stream(),
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

  // Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
  //   if (state == ZegoLiveStreamingState.idle) {
  //     ZegoGiftPlayer().clear();
  //   } else {}

  //   if (state == ZegoLiveStreamingState.ended) {
  //     ZegoGiftPlayer().clear();
  //     await _controller.updateInfo();
  //     final List<dynamic> list = await _controller.onLiveStreamingEnded();
  //     final bool canNext = _zegoController.swiping.next();
  //     if (canNext) {
  //       await _controller.updateInfo();
  //       return Future<void>.value();
  //     } else {}
  //     final bool canPrevious = _zegoController.swiping.previous();
  //     if (canPrevious) {
  //       await _controller.updateInfo();
  //       return Future<void>.value();
  //     } else {}
  //   } else {}
  //   return Future<void>.value();
  // }

  Future<void> onLiveStreamingStateUpdate(ZegoLiveStreamingState state) async {
    if (state == ZegoLiveStreamingState.idle) {
      ZegoGiftPlayer().clear();
    } else {}

    if (state == ZegoLiveStreamingState.ended) {
      ZegoGiftPlayer().clear();

      _controller.updateInfo();
      List<dynamic> list = await _controller.onLiveStreamingEnded();
      if (list.isNotEmpty) {
        _zegoController.swiping.next();

        _controller.initData();
        _controller.updateInfo();
      } else {}
    } else {}

    return Future<void>.value();
  }

  // Future<void> alreadyInTheWaitListDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           "Already in the Wait List",
  //         ),
  //         content: const Text(
  //           "You're already in the Astrologer's Wait List. Tap on hourglass to see your waiting time.",
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

  // Future<void> youAreInTheWaitListDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           "You're in the Wait List",
  //         ),
  //         content: Text(
  //           "You are not able to perform this action because you're the Wait List of Astrologer ${_controller.userName}.",
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

  Future<void> alreadyInWaitlistPopup() async {
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
          isHost: _controller.isHost,
          walletBalance: 0,
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
    if (userId != "0") {
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
    } else {}
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

            _controller.endTime = DateTime.now().add(
              Duration(
                days: 0,
                hours: 0,
                minutes: int.parse(_controller.currentCaller.totalTime),
                seconds: 0,
              ),
            );

            final connectInvite = _zegoController.coHost;
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
  //           await followOrUnfollowFunction();
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
  //           //
  //           // Exceptional Case Start
  //           //
  //           _controller.isWaitingForCallAstrologerPopupResponse = true;
  //           //
  //           // Exceptional Case End
  //           //
  //           bool hasAllPerm = false;
  //           await AppPermissionService.instance.onPressedJoinButton(
  //             type,
  //             () async {
  //               hasAllPerm = true;
  //             },
  //           );
  //           if (hasAllPerm) {
  //             await sendCallFunc(
  //               type: type,
  //               needRecharge: (bal.InsufficientBalModel balModel) async {
  //                 await lowBalancePopup(
  //                   balModel: balModel,
  //                   callbackBalModelData: (data) async {
  //                     final CommonOffer arg = CommonOffer(
  //                       extraAmount: data.extraAmount,
  //                       offerAmount: data.offerAmount,
  //                       percentage: data.percentage?.toInt(),
  //                       rechargeAmount: data.rechargeAmount,
  //                     );
  //                     await Get.toNamed(
  //                       RouteName.paymentSummary,
  //                       arguments: arg,
  //                     );
  //                   },
  //                 );
  //               },
  //             );
  //           } else {}
  //           //
  //           // Exceptional Case Start
  //           //
  //           _controller.isWaitingForCallAstrologerPopupResponse = false;
  //           //
  //           // Exceptional Case End
  //           //
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
  //     // await alreadyInTheWaitListDialog();
  //     await alreadyInWaitlistPopup();
  //   } else {
  //     final bool canOrder = await _controller.canPlaceLiveOrder(
  //       talkType: type,
  //       needRecharge: needRecharge,
  //       successCallBack: (String message) async {
  //         await eventListnerSuccessAndFailureCallBack(
  //           message: message,
  //           isForSuccess: true,
  //           isForFailure: false,
  //         );
  //       },
  //       failureCallBack: (String message) async {
  //         await eventListnerSuccessAndFailureCallBack(
  //           message: message,
  //           isForSuccess: false,
  //           isForFailure: true,
  //         );
  //       },
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
            showacknowledgementSnackBar("Gift");
          },
          onTapAskForVideoCall: () async {
            Get.back();
            if (userId != "0") {
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
            } else {}
            showacknowledgementSnackBar("Video Call");
          },
          onTapAskForAudioCall: () async {
            Get.back();
            if (userId != "0") {
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
            } else {}
            showacknowledgementSnackBar("Voice Call");
          },
          onTapAskForPrivateCall: () async {
            Get.back();
            if (userId != "0") {
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
                    successCallBack: (String message) async {
                      await successAndFailureCallBack(
                        message: message,
                        isForSuccess: true,
                        isForFailure: false,
                      );
                    },
                    failureCallBack: (String message) async {
                      await successAndFailureCallBack(
                        message: message,
                        isForSuccess: false,
                        isForFailure: true,
                      );
                    },
                  );
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
                } else {}
              },
            );
          },
          isBlocked: isBlocked,
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> blockUnblockPopup({
    required bool isAlreadyBeenBlocked,
    required Function() performAction,
  }) async {
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
    return Future<void>.value();
  }

  void showacknowledgementSnackBar(String type) {
    final SnackBar snackBar = SnackBar(
      width: Get.width / 1.5,
      content: Text(
        "$type Request Sent",
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: AppColors.yellow,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
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
        if (roomId == _controller.liveId) {
          if (type == "") {
            if (mounted) {
              ZegoGiftPlayer().play(
                context,
                GiftPlayerData(GiftPlayerSource.url, item["animation"]),
              );
            } else {}
            await showHideTopBanner();
          } else if (type == "Started following") {
            FollowPlayer().play(
              context,
              FollowPlayerData(
                // FollowPlayerSource.url,
                // "https://lottie.host/0b77dd9f-a81e-4268-8fb5-cc7f5b958e00/rtEwgdQPKc.json",
                FollowPlayerSource.asset,
                "assets/lottie/live_follow_heart.json",
                userName,
              ),
            );
          } else if (askFor) {
            if (receiverUserId == _controller.userId) {
              // await commonRequest(type: type, item: item, giftCount: giftCount);
            } else {}
          } else if (type == "Block/Unblock") {
            // await _controller.isCustomerBlocked(
            //   successCallBack: (String message) async {
            //     await eventListnerSuccessAndFailureCallBack(
            //       message: message,
            //       isForSuccess: true,
            //       isForFailure: false,
            //     );
            //   },
            //   failureCallBack: (String message) async {
            //     await eventListnerSuccessAndFailureCallBack(
            //       message: message,
            //       isForSuccess: false,
            //       isForFailure: true,
            //     );
            //   },
            // );
          } else if (type == "Tarot Card") {
            TarotGameModel model = TarotGameModel.fromJson(item);
            _controller.tarotGameModel = model;

            final int currentStep = _controller.tarotGameModel.currentStep ?? 0;
            if (waitingForUserToSelectCardsPopupVisible) {
              Get.back();
            } else {}
            switch (currentStep) {
              case 0:
                await showCardDeckToUserPopup();
                break;
              case 1:
                await showCardDeckToUserPopup1();
                break;
              case 2:
                await showCardDeckToUserPopup2();
                break;
              default:
                break;
            }
          } else {}
        } else {}
      } else {}
    }
    return Future<void>.value();
  }

  bool waitingForUserToSelectCardsPopupVisible = false;
  Future<void> waitingForUserToSelectCardsPopup() async {
    waitingForUserToSelectCardsPopupVisible = true;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return WaitingForUserToSelectCards(
          onClose: Get.back,
          userName: _controller.currentCaller.userName,
        );
      },
    );
    waitingForUserToSelectCardsPopupVisible = false;
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ShowCardDeckToUser(
          onClose: Get.back,
          onSelect: (int value) async {
            Get.back();

            var item = TarotGameModel(
              currentStep: 1,
              canPick: value,
              userPicked: [],
            );
            await sendTaroCard(item);

            if (_controller.isHost) {
              await waitingForUserToSelectCardsPopup();
            } else {}
          },
          userName: _controller.currentCaller.userName,
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup1() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return LiveCarousal(
          onClose: Get.back,
          allCards: _controller.deckCardModelList,
          onSelect: (List<DeckCardModel> selectedCards) async {
            Get.back();

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
            );
            await sendTaroCard(item);

            if (_controller.isHost) {
            } else {}
          },
          numOfSelection: _controller.tarotGameModel.canPick ?? 0,
          userName: _controller.currentCaller.userName,
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup2() async {
    await showCupertinoModalPopup(
      context: context,
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
          userName: "Dharam",
        );
      },
    );
    return Future<void>.value();
  }

  Future<void> sendTaroCard(item) async {
    var data = {
      "room_id": _controller.liveId,
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

  Future<void> showHideTopBanner() async {
    _controller.showTopBanner = true;
    await Future<void>.delayed(const Duration(seconds: 15));
    _controller.showTopBanner = false;
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
  //           await requestCallFunction(type: "Video");
  //         },
  //         onTapAcceptForAudioCall: () async {
  //           Get.back();
  //           await requestCallFunction(type: "Audio");
  //         },
  //         onTapAcceptForPrivateCall: () async {
  //           Get.back();
  //           await requestCallFunction(type: "Private");
  //         },
  //         giftData: giftData,
  //         giftCount: giftCount,
  //       );
  //     },
  //   );
  //   return Future<void>.value();
  // }

  // Future<void> requestCallFunction({required String type}) async {
  //   bool hasAllPerm = false;
  //   await AppPermissionService.instance.onPressedJoinButton(
  //     type,
  //     () async {
  //       hasAllPerm = true;
  //     },
  //   );
  //   if (hasAllPerm) {
  //     await sendCallFunc(
  //       type: type,
  //       needRecharge: (bal.InsufficientBalModel balModel) async {
  //         await lowBalancePopup(
  //           balModel: balModel,
  //           callbackBalModelData: (data) async {
  //             final CommonOffer arg = CommonOffer(
  //               extraAmount: data.extraAmount,
  //               offerAmount: data.offerAmount,
  //               percentage: data.percentage?.toInt(),
  //               rechargeAmount: data.rechargeAmount,
  //             );
  //             await Get.toNamed(RouteName.paymentSummary, arguments: arg);
  //           },
  //         );
  //       },
  //     );
  //   } else {}

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

  // Future<void> youAreBlocked() async {
  //   await showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return YouAreBlockedWidget(
  //         onClose: Get.back,
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
      onTap: () async {
        if (_controller.isHost) {
          await keyboardPop();
        } else {
          //  _controller.isCustBlocked.data?.isCustomerBlocked == 1
          //     ? await youAreBlocked()
          //     : await keyboardPop();
        }
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
                    typeEnum: TypeEnum.user,
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
        //
        //
        await exitFunc();
        //
        //
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
            padding: const EdgeInsets.all(0.0),
            child: Image.asset(
              _controller.currentCaller.isEngaded
                  ? "assets/images/live_new_hang_up.png"
                  : "assets/images/live_exit_red.png",
            ),
          ),
        ),
      ),
    );
  }

  // temporary purpose
  // DateTime? endTime;
  //

  Widget newTimerWidget() {
    // endTime ??= DateTime.now().add(
    //   Duration(
    //     days: 0,
    //     hours: 0,
    //     minutes: int.parse(_controller.currentCaller.totalTime),
    //     seconds: 0,
    //   ),
    // );
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      timeTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      onTick: (Duration duration) async {
        _controller.endTime = DateTime.now().add(duration);

        if (isLessThanOneMinute(duration) && !extendTimeWidgetVisible) {
          extendTimeWidgetVisible = true;
          await extendTimeWidgetPopup();
        } else {}
      },
      endTime: _controller.endTime,
      onEnd: removeCoHostOrStopCoHost,
    );
  }

  bool isLessThanOneMinute(Duration duration) {
    return duration < const Duration(minutes: 1);
  }

  // temporary purpose
  bool extendTimeWidgetVisible = false;
  //

  Future<void> extendTimeWidgetPopup() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ExtendTimeWidget(
          onClose: Get.back,
          isAstro: _controller.isHost,
          yesExtend: () {
            Get.back();
          },
          noExtend: () {
            Get.back();
          },
        );
      },
    );
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
              imageUrl: _controller.currentCaller.avatar,
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
                instance.turnMicrophoneOn(_controller.isMicOn, muteMode: true);
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
        instance.turnMicrophoneOn(true, muteMode: true);
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
        instance.turnMicrophoneOn(true, muteMode: true);
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
                        instance.turnMicrophoneOn(_controller.isMicOn,
                            muteMode: true);
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
        // StreamBuilder<Object>(
        //   stream: null,
        //   builder: (context, snapshot) {
        //     return AnimatedOpacity(
        //       opacity: !_controller.isHost ? 0.0 : 1.0,
        //       duration: const Duration(seconds: 1),
        //       child: !_controller.isHost
        //           ? const SizedBox()
        //           : Column(
        //               children: [
        //                 InkWell(
        //                   onTap: exitFunc,
        //                   child: SizedBox(
        //                     height: 50,
        //                     width: 50,
        //                     child: DecoratedBox(
        //                       decoration: BoxDecoration(
        //                         borderRadius: const BorderRadius.all(
        //                           Radius.circular(50.0),
        //                         ),
        //                         border: Border.all(
        //                           color: AppColors.yellow,
        //                         ),
        //                         color: AppColors.black.withOpacity(0.2),
        //                       ),
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(0.0),
        //                         child: Image.asset(
        //                           _controller.currentCaller.isEngaded
        //                               ? "assets/images/live_new_hang_up.png"
        //                               : "assets/images/live_exit_red.png",
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(height: 8),
        //               ],
        //             ),
        //     );
        //   },
        // ),
        //
        StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return AnimatedOpacity(
              opacity:
                  _controller.isHost && !_controller.currentCaller.isEngaded
                      ? 0.0
                      : 1.0,
              duration: const Duration(seconds: 1),
              child: _controller.isHost && !_controller.currentCaller.isEngaded
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
                                  color: AppColors.yellow,
                                ),
                                color: AppColors.black.withOpacity(0.2),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.category,
                                  color: AppColors.yellow,
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
        //
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
    // await _controller.getAstrologerDetails(
    //   successCallBack: (String message) async {
    //     await eventListnerSuccessAndFailureCallBack(
    //       message: message,
    //       isForSuccess: true,
    //       isForFailure: false,
    //     );
    //   },
    //   failureCallBack: (String message) async {
    //     await eventListnerSuccessAndFailureCallBack(
    //       message: message,
    //       isForSuccess: false,
    //       isForFailure: true,
    //     );
    //   },
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
    final bool isEngaded = _controller.currentCaller.isEngaded;
    // final bool hasMyIdInWaitList = _controller.hasMyIdInWaitList();
    if (isEngaded) {
      await disconnectPopup(
        noDisconnect: () {},
        yesDisconnect: removeCoHostOrStopCoHost,
      );
    }
    // else if (hasMyIdInWaitList) {
    //   await exitWaitListPopup(
    //     noDisconnect: () {},
    //     yesDisconnect: () async {
    //       if (!_controller.isHost) {
    //         await _controller.removeFromWaitList();
    //       } else {}
    //     },
    //   );
    //   return Future<void>.value();
    // }
    else {
      if (_controller.isHost) {
        await endLiveSession(
          endLive: () async {
            if (mounted) {
              _timer?.cancel();
              _msgTimer?.cancel();
              _msgTimerLiveMonitoring?.cancel();
              _msgTimerForFollowPopup?.cancel();
              await _zegoController.leave(context);
              // unawaited(_zegoController.leave(context));
            } else {}
          },
        );
      } else {
        await showAllAvailAstroPopup(
          exitLive: () async {
            if (mounted) {
              _timer?.cancel();
              _msgTimer?.cancel();
              _msgTimerLiveMonitoring?.cancel();
              _msgTimerForFollowPopup?.cancel();
              await _zegoController.leave(context);
              // unawaited(_zegoController.leave(context));
            } else {}
          },
        );
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
        return LiveKeyboard(sendKeyboardMesage: sendKeyboardMesage);
      },
    );
    _isKeyboardSheetOpen = false;
    return Future<void>.value();
  }

  Future<void> sendKeyboardMesage(msg) async {
    final ZegoCustomMessage model = ZegoCustomMessage(
      type: 1,
      liveId: _controller.liveId,
      userId: _controller.userId,
      userName: _controller.userName,
      avatar: _controller.avatar,
      message: msg,
      timeStamp: DateTime.now().toString(),
      fullGiftImage: "",
      isBlockedCustomer: _controller.isCustomerBlockedBool(),
    );
    await sendMessageToZego(model);
    FocusManager.instance.primaryFocus?.unfocus();
    scrollDownForTop();
    scrollDownForBottom();
    if (mounted) {
      Navigator.of(context).pop();
    } else {}
    return Future<void>.value();
  }

  // Future<void> followOrUnfollowFunction() async {
  //   final ZegoCustomMessage model = ZegoCustomMessage(
  //     type: 1,
  //     liveId: _controller.liveId,
  //     userId: _controller.userId,
  //     userName: _controller.userName,
  //     avatar: _controller.avatar,
  //     message: "${_controller.userName} Started following",
  //     timeStamp: DateTime.now().toString(),
  //     fullGiftImage: "",
  //     isBlockedCustomer: _controller.isCustomerBlockedBool(),
  //   );
  //   await sendMessageToZego(model);

  //   await _controller.followOrUnfollowAstrologer(
  //     successCallBack: (String message) async {
  //       await eventListnerSuccessAndFailureCallBack(
  //         message: message,
  //         isForSuccess: true,
  //         isForFailure: false,
  //       );
  //     },
  //     failureCallBack: (String message) async {
  //       await eventListnerSuccessAndFailureCallBack(
  //         message: message,
  //         isForSuccess: false,
  //         isForFailure: true,
  //       );
  //     },
  //   );
  //   await _controller.getAstrologerDetails(
  //     successCallBack: (String message) async {
  //       await eventListnerSuccessAndFailureCallBack(
  //         message: message,
  //         isForSuccess: true,
  //         isForFailure: false,
  //       );
  //     },
  //     failureCallBack: (String message) async {
  //       await eventListnerSuccessAndFailureCallBack(
  //         message: message,
  //         isForSuccess: false,
  //         isForFailure: true,
  //       );
  //     },
  //   );

  //   var item = GiftData(
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
  //   var data = {
  //     "room_id": _controller.liveId,
  //     "user_id": _controller.userId,
  //     "user_name": _controller.userName,
  //     "item": item.toJson(),
  //     "type": "Started following",
  //   };
  //   await _controller.sendGiftAPI(
  //     data: data,
  //     count: 1,
  //     svga: "",
  //     successCallback: log,
  //     failureCallback: log,
  //   );

  //   if (mounted) {
  //     FollowPlayer().play(
  //       context,
  //       FollowPlayerData(
  //         // FollowPlayerSource.url,
  //         // "https://lottie.host/0b77dd9f-a81e-4268-8fb5-cc7f5b958e00/rtEwgdQPKc.json",
  //         FollowPlayerSource.asset,
  //         "assets/lottie/live_follow_heart.json",
  //         _controller.userName,
  //       ),
  //     );
  //   } else {}
  //   return Future<void>.value();
  // }

  // d

  // ZegoUIKitPrebuiltLiveStreamingEvents get events {
  //   return ZegoUIKitPrebuiltLiveStreamingEvents(
  //     hostEvents: ZegoUIKitPrebuiltLiveStreamingHostEvents(
  //       onCoHostRequestReceived: (ZegoUIKitUser user) async {
  //         showNotifOverlay(user: user, msg: "onCoHostRequestReceived");
  //         await onCoHostRequest(
  //           user: user,
  //           userId: user.id,
  //           userName: user.name,
  //           avatar: "https://robohash.org/avatarWidget",
  //         );
  //       },
  //       onCoHostRequestCanceled: (ZegoUIKitUser user) async {
  //         showNotifOverlay(user: user, msg: "onCoHostRequestCanceled");
  //         // await onCoHostRequestCanceled(user);
  //       },
  //       onCoHostRequestTimeout: (ZegoUIKitUser user) {
  //         showNotifOverlay(user: user, msg: "onCoHostRequestTimeout");
  //       },
  //       onActionAcceptCoHostRequest: () {
  //         showNotifOverlay(user: null, msg: "onActionAcceptCoHostRequest");
  //       },
  //       onActionRefuseCoHostRequest: () {
  //         showNotifOverlay(user: null, msg: "onActionRefuseCoHostRequest");
  //       },
  //       onCoHostInvitationSent: (ZegoUIKitUser user) {
  //         showNotifOverlay(user: user, msg: "onCoHostInvitationSent");
  //       },
  //       onCoHostInvitationTimeout: (ZegoUIKitUser user) {
  //         showNotifOverlay(user: user, msg: "onCoHostInvitationTimeout");
  //       },
  //       onCoHostInvitationAccepted: (ZegoUIKitUser user) {
  //         showNotifOverlay(user: user, msg: "onCoHostInvitationAccepted");
  //       },
  //       onCoHostInvitationRefused: (ZegoUIKitUser user) {
  //         showNotifOverlay(user: user, msg: "onCoHostInvitationRefused");
  //       },
  //     ),
  //     audienceEvents: ZegoUIKitPrebuiltLiveStreamingAudienceEvents(
  //       onCoHostRequestSent: () {
  //         showNotifOverlay(user: null, msg: "onCoHostRequestSent");
  //       },
  //       onActionCancelCoHostRequest: () {
  //         showNotifOverlay(user: null, msg: "onActionCancelCoHostRequest");
  //       },
  //       onCoHostRequestTimeout: () {
  //         showNotifOverlay(user: null, msg: "onCoHostRequestTimeout");
  //       },
  //       onCoHostRequestAccepted: () {
  //         showNotifOverlay(user: null, msg: "onCoHostRequestAccepted");
  //       },
  //       onCoHostRequestRefused: () {
  //         showNotifOverlay(user: null, msg: "onCoHostRequestRefused");
  //       },
  //       onCoHostInvitationReceived: (ZegoUIKitUser user) {
  //         showNotifOverlay(user: user, msg: "onCoHostInvitationReceived");
  //       },
  //       onCoHostInvitationTimeout: () {
  //         showNotifOverlay(user: null, msg: "onCoHostInvitationTimeout");
  //       },
  //       onActionAcceptCoHostInvitation: () {
  //         showNotifOverlay(user: null, msg: "onActionAcceptCoHostInvitation");
  //       },
  //       onActionRefuseCoHostInvitation: () {
  //         showNotifOverlay(user: null, msg: "onActionRefuseCoHostInvitation");
  //       },
  //     ),
  //   );
  // }

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
        host: ZegoLiveStreamingCoHostHostEvents(
          onRequestReceived: (ZegoUIKitUser user) async {
            showNotifOverlay(user: user, msg: "onCoHostRequestReceived");
            await onCoHostRequest(
              user: user,
              userId: user.id,
              userName: user.name,
              avatar: "https://robohash.org/avatarWidget",
            );
          },
          onRequestCanceled: (ZegoUIKitUser user) async {
            showNotifOverlay(user: user, msg: "onCoHostRequestCanceled");
            // await onCoHostRequestCanceled(user);
          },
          onRequestTimeout: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostRequestTimeout");
          },
          onActionAcceptRequest: () {
            showNotifOverlay(user: null, msg: "onActionAcceptCoHostRequest");
          },
          onActionRefuseRequest: () {
            showNotifOverlay(user: null, msg: "onActionRefuseCoHostRequest");
          },
          onInvitationSent: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationSent");
          },
          onInvitationTimeout: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationTimeout");
          },
          onInvitationAccepted: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationAccepted");
          },
          onInvitationRefused: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationRefused");
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
          onRequestAccepted: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestAccepted");
          },
          onRequestRefused: () {
            showNotifOverlay(user: null, msg: "onCoHostRequestRefused");
          },
          onInvitationReceived: (ZegoUIKitUser user) {
            showNotifOverlay(user: user, msg: "onCoHostInvitationReceived");
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
    );
  }

  Future<void> onCoHostRequest({
    required ZegoUIKitUser user,
    required String userId,
    required String userName,
    required String avatar,
  }) async {
    _controller.hasCallAcceptRejectPopupOpen = true;
    await hostingAndCoHostingPopup(
      onClose: () {},
      needAcceptButton: true,
      needDeclinetButton: false,
      onAcceptButton: () async {
        if (_controller.openAceeptRejectDialogForId == userId) {
          _controller.endTime = DateTime.now().add(
            Duration(
              days: 0,
              hours: 0,
              minutes: int.parse(_controller.currentCaller.totalTime),
              seconds: 0,
            ),
          );

          final connectInvite = _zegoController.coHost;
          await connectInvite.hostSendCoHostInvitationToAudience(user);
        } else {}
      },
      onDeclineButton: () {},
      user: user,
      userId: userId,
      userName: userName,
      avatar: avatar,
    );
    _controller.hasCallAcceptRejectPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> removeCoHostOrStopCoHost() async {
    ZegoUIKitUser user = ZegoUIKitUser(
      id: _controller.currentCaller.id,
      name: _controller.currentCaller.userName,
    );
    final connect = _zegoController.coHost;
    final bool removed = _controller.isHost
        ? await connect.removeCoHost(user)
        : await connect.stopCoHost(showRequestDialog: false);
    if (removed) {
      await _controller.makeAPICallForEndCall(
        successCallBack: (String message) async {
          await successAndFailureCallBack(
            message: message,
            isForSuccess: true,
            isForFailure: false,
          );
        },
        failureCallBack: (String message) async {
          await successAndFailureCallBack(
            message: message,
            isForSuccess: false,
            isForFailure: true,
          );
        },
      );
    } else {}
    if (removed) {
      _controller.isHost
          ? await _controller.removeFromWaitListWhereEngadedIsTrue()
          : await _controller.removeFromWaitList();
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
          onSelect: (liveId) async {
            Get.back();

            _controller.updateInfo();
            List<dynamic> list = await _controller.onLiveStreamingEnded();
            _controller.liveId = liveId;
            _controller.currentIndex = list.indexWhere((e) => e == liveId);
            _zegoController.swiping.jumpTo(liveId);

            _controller.initData();
            _controller.updateInfo();
          },
          onFollowAndLeave: () async {
            Get.back();
            // await followOrUnfollowFunction();
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

  Future<void> initTarot() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<dynamic> list = jsonDecode(prefs.getString('tarot_cards') ?? "");

    for (var element in list) {
      _controller.deckCardModelList = [
        ...[DeckCardModel.fromJson(element)]
      ];
    }
    for (var element in _controller.deckCardModelList) {
      element.image = "${_controller.pref.getAmazonUrl()}/${element.image}";
    }

    return Future<void>.value();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _controller.noticeBoard(
      successCallBack: (String message) async {
        await successAndFailureCallBack(
          message: message,
          isForSuccess: true,
          isForFailure: false,
        );
      },
      failureCallBack: (String message) async {
        await successAndFailureCallBack(
          message: message,
          isForSuccess: false,
          isForFailure: true,
        );
      },
    );
    await _controller.callBlockedCustomerListRes(
      successCallBack: (String message) async {
        await successAndFailureCallBack(
          message: message,
          isForSuccess: true,
          isForFailure: false,
        );
      },
      failureCallBack: (String message) async {
        await successAndFailureCallBack(
          message: message,
          isForSuccess: false,
          isForFailure: true,
        );
      },
    );
    await initTarot();
    return Future<void>.value();
  }
}
