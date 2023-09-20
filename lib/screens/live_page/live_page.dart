// ignore_for_file: depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:divine_astrologer/common/block_user_list.dart';
import 'package:divine_astrologer/common/co-host_request.dart';
import 'package:divine_astrologer/common/end_cohost.dart';
import 'package:divine_astrologer/common/end_session_dialog.dart';
import 'package:divine_astrologer/common/gift_sheet.dart';
import 'package:divine_astrologer/common/unblock_user.dart';
import 'package:divine_astrologer/screens/live_page/live_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../common/cached_network_image.dart';
import '../../common/colors.dart';
import '../../common/custom_widgets.dart';
import '../../common/custom_text_field.dart';
import '../../common/leader_board_sheet.dart';
import '../../common/waitlist_sheet.dart';
import '../../gen/assets.gen.dart';
import '../../repository/user_repository.dart';
import 'constant.dart';
import 'gift.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost, isFrontCamera;
  final String localUserID;
  final String? astrologerName, astrologerImage;

  const LivePage({
    Key? key,
    required this.liveID,
    required this.localUserID,
    this.astrologerImage,
    this.astrologerName,
    this.isHost = false,
    this.isFrontCamera = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage>
    with SingleTickerProviderStateMixin {
  //final liveController = ZegoUIKitPrebuiltLiveStreamingController();
  final event = ZegoUIKitPrebuiltLiveStreamingEvents();
  final List<StreamSubscription<dynamic>?> subscriptions = [];
  final controller = Get.put(LiveController(Get.put(UserRepository())));
  final liveStateNotifier =
      ValueNotifier<ZegoLiveStreamingState>(ZegoLiveStreamingState.idle);

  @override
  void initState() {
    super.initState();
    controller.astroId = widget.localUserID;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.listenCallStatus();
      controller.listenWaitlistRemove();
      controller.setAvailibility(
        widget.localUserID,
        true,
      );
      //controller.getBlockedCustomerList();
      event.hostEvents.onCoHostRequestReceived = (user) async {
        controller.coHostUser = user;
        String type = await controller.getCallType(widget.localUserID);
        int duration = await controller.getDuration(widget.localUserID);
        //controller.setVisibilityCoHost(type);
        showCupertinoModalPopup(
            context: Get.context!,
            builder: (BuildContext context) {
              return CoHostRequest(
                  name: user.name,
                  onReject: () {
                    controller.liveController.connect
                        .hostRejectCoHostRequest(user);
                    controller.setBusyStatus(widget.localUserID, 0,
                        customerId: "");
                    controller.setCallType(widget.localUserID);
                  },
                  onAccept: () {
                    controller.liveController.connect
                        .hostAgreeCoHostRequest(user)
                        .then((value) {
                      controller.setBusyStatus(widget.localUserID, 1,
                          customerId: user.id);
                    });
                    controller.isCoHosting.value = true;
                    //timeController.start();
                  });
            });
      };
      subscriptions.addAll([
        ZegoUIKit()
            .getSignalingPlugin()
            .getInRoomCommandMessageReceivedEventStream()
            .listen((event) {
          onInRoomCommandMessageReceived(event);
        }),
      ]);
      controller.liveController.message.stream().listen((event) {
        controller.jumpToBottom();
      });
    });
    Future.delayed(const Duration(seconds: 1)).then((value) {
      ZegoUIKit().useFrontFacingCamera(widget.isFrontCamera);
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    );

    final giftButton = ZegoMenuBarExtendButton(
      index: 0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: const CircleBorder()),
        onPressed: () {
          sendGift();
        },
        child: const Icon(Icons.blender),
      ),
    );

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    )..bottomMenuBarConfig.coHostExtendButtons = [giftButton];
    //..bottomMenuBarConfig.audienceExtendButtons = [giftButton];

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EndSession(
                onNo: () {},
                onYes: () {
                  controller.stopTimer();
                  //controller.setBusyStatus(widget.localUserID, 0, customerId: "");
                  GiftWidget.clear();
                  controller.stopStream(widget.localUserID);
                });
          },
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(builder: (context, constraints) {
            return ZegoUIKitPrebuiltLiveStreaming(
              appID: yourAppID,
              appSign: yourAppSign /*input your AppSign*/,
              userID: widget.localUserID,
              userName: widget.astrologerName ?? "user_${widget.localUserID}",
              liveID: widget.liveID,
              controller: controller.liveController,
              config: (widget.isHost ? controller.hostConfig : audienceConfig)
                ..avatarBuilder = customAvatarBuilder
                ..memberButtonConfig.icon = const SizedBox()
                ..stopCoHostingWhenMicCameraOff = false
                ..confirmDialogInfo = null
                ..markAsLargeRoom = false
                ..bottomMenuBarConfig.hostButtons = const [
                  //ZegoMenuBarButtonName.soundEffectButton,
                  //ZegoMenuBarButtonName.switchCameraButton,
                  //ZegoMenuBarButtonName.toggleCameraButton,
                  //ZegoMenuBarButtonName.toggleMicrophoneButton,
                ]
                ..bottomMenuBarConfig.coHostButtons = [
                  ZegoMenuBarButtonName.toggleCameraButton,
                  ZegoMenuBarButtonName.toggleMicrophoneButton,
                  ZegoMenuBarButtonName.coHostControlButton,
                  ZegoMenuBarButtonName.switchCameraButton,
                  ZegoMenuBarButtonName.soundEffectButton,
                ]
                ..bottomMenuBarConfig.showInRoomMessageButton = false
                ..bottomMenuBarConfig.audienceButtons = []
                ..audioVideoViewConfig.useVideoViewAspectFill = true
                ..audioVideoViewConfig.showUserNameOnView = false
                ..maxCoHostCount = 1

                /// gallery-layout, show top and bottom if have two audio-video views
                ..layout = ZegoLayout.gallery()
                ..topMenuBarConfig = ZegoTopMenuBarConfig(
                  height: 0,
                  showCloseButton: false
                )

                /// hide the co-host audio-video view to audience and other co-hosts
                /*..audioVideoViewConfig.visible = (
                  ZegoUIKitUser localUser,
                  ZegoLiveStreamingRole localRole,
                  ZegoUIKitUser targetUser,
                  ZegoLiveStreamingRole targetUserRole,
                ) {
                  if (ZegoLiveStreamingRole.host == localRole) {
                    /// host can see all user's view
                    return true;
                  }

                  /// comment below if you want the co-host hide their own audio-video view.
                  if (localUser.id == targetUser.id) {
                    /// local view
                    return true;
                  }

                  /// if user is a co-host, only show host's audio-video view
                  return targetUserRole == ZegoLiveStreamingRole.host;
                }*/
                ..onLiveStreamingStateUpdate = (ZegoLiveStreamingState state) {
                  liveStateNotifier.value = state;
                }
                ..inRoomMessageConfig.visible = false
                ..foreground = foreground(constraints),
            );
          }),
        ),
      ),
    );
  }

  Widget messageWidget() {
    return StreamBuilder<List<ZegoInRoomMessage>>(
      stream: controller.liveController.message.stream(),
      builder: (context, snapshot) {
        var messages = snapshot.data ?? <ZegoInRoomMessage>[];
        messages = messages.reversed.toList();
        return Center(
          child: SizedBox(
            width: Get.width - 120.w,
            height: 200.h,
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: controller.scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messageItem(messages[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget messageItem(ZegoInRoomMessage message) {
    bool isOtherUser = widget.localUserID != message.user.id;
    return Align(
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () {
          if(controller.isCoHosting.isFalse){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                if (controller.blockIds.contains(message.user.id)) {
                  return UnblockOrBlockUser(
                    name: message.user.name,
                    isForBlocUser: false,
                    blockUnblockTap: () {
                      controller.unblockUser(
                          customerId: message.user.id, name: message.user.name);
                    },
                  );
                } else {
                  return UnblockOrBlockUser(
                    name: message.user.name,
                    isForBlocUser: true,
                    blockUnblockTap: () {
                      controller.blockUser(
                          customerId: message.user.id, name: message.user.name);
                    },
                  );
                }
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 2,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 1.w,
          ),
          decoration: BoxDecoration(
            //border: Border.all(color: AppColors.white, width: .8),
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(5),
          ),
          child: RichText(
            maxLines: 4,
            text: TextSpan(
              children: [
                WidgetSpan(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 4.w),
                    SizedBox(
                      width: 18,
                      child: Center(
                        child: ZegoAvatar(
                          user: message.user,
                          avatarSize: const Size(18, 18),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${message.user.name}: ',
                      style: const TextStyle(
                        color: AppColors.appYellowColour,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        message.message,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    isOtherUser
                        ? const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )
                        : const SizedBox()
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAstrologerLiveStartWidget() {
    return Visibility(
      visible: controller.showLiveStar.value,
      child: Container(
        height: 57.h,
        margin: EdgeInsets.only(left: 22.w, top: 15.h),
        decoration: BoxDecoration(
            color: AppColors.lightBlack.withOpacity(.3),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10.w),
            Container(
              width: 32.w,
              height: 32.h,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: circleAvatar(),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText("Astrologers's Live Star",
                    fontSize: 14.sp,
                    fontColor: AppColors.white,
                    fontWeight: FontWeight.bold),
                CustomText("${controller.liveStar["name"]}",
                    fontSize: 10.sp, fontColor: AppColors.white),
              ],
            ),
            // Assets.images.starLive.image(),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }

  Container buildCallDurationWidget() {
    return Container(
      height: 65.h,
      margin: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
          color: AppColors.lightBlack.withOpacity(.3),
          borderRadius: BorderRadius.circular(18)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 40.h,
            decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(18)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 6.w),
                Container(
                  width: 32.w,
                  height: 32.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: circleAvatar(),
                ),
                //SizedBox(width: 8.w),
                //Lottie.asset('assets/lottie/sound_waves.json'),
                SizedBox(width: 4.w),
                buildCustomTimer(),
                SizedBox(width: 16.w),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 4.0.w),
                child: CustomText(
                    "${controller.coHostUser?.name ?? ""} is on call",
                    fontSize: 12.sp,
                    fontColor: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomText buildCustomTimer() {
    if (controller.hour.value == "00") {
      return CustomText("${controller.min}:${controller.sec}",
          fontSize: 14.sp, fontColor: AppColors.white);
    }
    return CustomText("${controller.hour}:${controller.min}:${controller.sec}",
        fontSize: 14.sp, fontColor: AppColors.white);
  }

  Widget foreground(BoxConstraints constraints) {
    const shortMessageHeight = 30.0;
    const padding = 10.0;

    final messageView = SizedBox(
      width: Get.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 15.w),
          messageWidget(),
          const Spacer(),
          sideButtons(),
          SizedBox(width: 10.w)
        ],
      ),
    );

    List<String> shortMessages = [
      'Hi! 🖐🏻',
      'Namastey 🙏🏻',
      'Hello ❤️',
      'Hey 🔥',
      'Buy 👋🏻',
      'Morning ☀️',
      'Night 🌛'
    ];
    final shortMessageView = SizedBox(
      width: constraints.maxWidth - padding * 5,
      height: shortMessageHeight,
      child: ListView.separated(
        itemCount: shortMessages.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white38),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  controller.liveController.message.send(shortMessages[index]);
                },
                child: Text(
                  shortMessages[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 5);
        },
      ),
    );
    return foregroundView(messageView);
  }

  foregroundView(messageView) {
    return Stack(
      children: [
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: ValueListenableBuilder<ZegoLiveStreamingState>(
              valueListenable: liveStateNotifier,
              builder: (context, liveState, _) {
                return ZegoLiveStreamingState.idle == liveState
                    ? Container()
                    : SizedBox(
                        height: Get.height - 22.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Spacer(),
                            messageView,
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: SizedBox(
                                width: Get.width,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: CustomTextField(
                                            align: TextAlignVertical.center,
                                            height: 50.h,
                                            onSubmit: (value) {
                                              FocusScope.of(context).unfocus();
                                              if (value.isNotEmpty) {
                                                if (controller.badWordsData!
                                                    .contains(value)) {
                                                  controller.msg.text = "";
                                                } else {
                                                  controller
                                                      .liveController.message
                                                      .send(value);
                                                  controller.msg.text = "";
                                                  controller.jumpToBottom();
                                                }
                                              }
                                            },
                                            // height: ,
                                            inputAction: TextInputAction.send,
                                            readOnly: false,
                                            hintText: 'Say Hi...',
                                            hintColor: AppColors.white,
                                            controller: controller.msg,
                                            keyboardType: TextInputType.text,
                                            suffixIconPadding: 8.w,
                                            isDense: true,
                                            textInputFormatter: [
                                              FilteringTextInputFormatter(
                                                  RegExp(r'^[a-zA-Z ]*$'),
                                                  allow: true)
                                            ],

                                            inputBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppColors.white
                                                    .withOpacity(0.15),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(40.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          ZegoUIKit.instance.turnMicrophoneOn(
                                              !controller.isMicroPhoneOn.value,muteMode: true);
                                          controller.isMicroPhoneOn.value =
                                              !controller.isMicroPhoneOn.value;
                                        },
                                        icon: Obx(() =>
                                            controller.isMicroPhoneOn.value
                                                ? Assets.images.audioEnableLive
                                                    .svg()
                                                : Assets.images.audioDisableLive
                                                    .svg())),
                                    IconButton(
                                        onPressed: () {
                                          ZegoUIKit.instance.turnCameraOn(
                                              !controller.isCameraOn.value);
                                          controller.isCameraOn.value =
                                              !controller.isCameraOn.value;
                                        },
                                        icon: Obx(() =>
                                            controller.isCameraOn.value
                                                ? Assets.images.vidioEnableLive
                                                    .svg()
                                                : Assets.images.videoDisableLive
                                                    .svg()))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      );
              },
            ),
          ),
        ),
        Positioned(
          top: 10.h,
          child: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTopMenu(),
                Obx(() {
                  if (controller.isCoHosting.isTrue) {
                    return const SizedBox();
                  } else {
                    if (controller.liveStar.isNotEmpty) {
                      return buildAstrologerLiveStartWidget();
                    } else {
                      return const SizedBox();
                    }
                  }
                })
              ],
            ),
          ),
        ),
      ],
    );
  }

  InkWell sendMsg() {
    return InkWell(
        onTap: () {
          if (controller.msg.text.isNotEmpty) {
            controller.liveController.message.send(controller.msg.text);
            controller.msg.text = "";
            Get.back();
          }
        },
        child: Assets.images.icSendMsg.svg());
  }

  Widget buildTopMenu() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              padding: EdgeInsets.only(top: 5.h),
              alignment: Alignment.topCenter,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EndSession(
                        onNo: () {},
                        onYes: () {
                          if (controller.coHostUser != null) {
                            controller.setCallType(widget.localUserID);
                          }
                          controller.stopStream(widget.localUserID);
                        });
                  },
                );
              },
              icon: Assets.images.leftArrow.svg()),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                decoration: BoxDecoration(
                    color: AppColors.blackColor.withOpacity(.3),
                    borderRadius: BorderRadius.circular(40)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30.w,
                      height: 30.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: circleAvatar(),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      widget.astrologerName != null
                          ? widget.astrologerName!.isNotEmpty &&
                                  widget.astrologerName!.length > 8
                              ? "${widget.astrologerName!.substring(0, 8)}..."
                              : widget.astrologerName ?? ""
                          : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          InkWell(
              onTap: () {
                controller.isStarHide.value = !controller.isStarHide.value;
              },
              child: Assets.images.starLive.image()),
          SizedBox(width: 1.w),
          Obx(() => controller.isCoHosting.value
              ? buildCallDurationWidget()
              : SizedBox()),
          Spacer(),
          Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlutterSwitch(
                    activeColor: AppColors.appYellowColour.withOpacity(0.7),
                    inactiveColor: AppColors.grey.withOpacity(0.7),
                    activeText: "Call",
                    inactiveText: "Call",
                    activeTextColor: AppColors.white,
                    inactiveTextColor: AppColors.white,
                    showOnOff: true,
                    height: 28.h,
                    padding: 2,
                    width: 70.w,
                    activeTextFontWeight: FontWeight.normal,
                    inactiveTextFontWeight: FontWeight.normal,
                    value: controller.isCallOnOff.value,
                    onToggle: (val) {
                      controller.setAvailibility(
                        widget.localUserID,
                        !controller.isCallOnOff.value,
                      );
                      controller.isCallOnOff.value =
                          !controller.isCallOnOff.value;
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  /*Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: AppColors.grey.withOpacity(0.5)),
                    child: CustomText(
                      controller.isCallOnOff.value ? "Call on" : "Call off",
                      fontSize: 8.sp,
                      fontColor: AppColors.white,
                    ),
                  ),*/
                ],
              )),
          SizedBox(width: 10.w)
        ],
      ),
    );
  }

  Widget circleAvatar() {
    if (widget.astrologerImage != null || widget.astrologerImage!.isNotEmpty) {
      return CachedNetworkPhoto(
        url: widget.astrologerImage,
        fit: BoxFit.fill,
      );
    }
    return CircleAvatar(
      child: Text(widget.astrologerName![0].toUpperCase()),
    );
  }

  Widget sideButtons() {
    return Column(
      children: [
        Obx(
          () => controller.isCoHosting.value
              ? ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EndCoHost(
                                name: controller.coHostUser!.name,
                                onNo: () {},
                                onYes: () {
                                  if (controller.coHostUser != null) {
                                    controller.setCallType(widget.localUserID);
                                  }
                                  controller.setCallStatus();
                                  controller.stopTimer();
                                  controller.setBusyStatus(
                                      widget.localUserID, 0,
                                      customerId: "");
                                  controller.liveController.connect
                                      .removeCoHost(controller.coHostUser!);
                                  controller.removeFromWaitList();
                                  controller.isCoHosting.value = false;
                                });
                          },
                        );
                      },
                      child: Container(
                        width: 46.w,
                        height: 46.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.redColor),
                        child: Assets.svg.disconnect.svg(),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
        SizedBox(height: 12.h),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EndSession(
                        onNo: () {},
                        onYes: () {
                          if (controller.coHostUser != null) {
                            controller.setCallType(widget.localUserID);
                          }
                          //controller.setBusyStatus(widget.localUserID, 0, customerId: "");
                          controller.stopStream(widget.localUserID);
                        });
                  },
                );
              },
              child: Container(
                width: 46.w,
                height: 46.h,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.appRedColour),
                child: const Center(
                    child: Icon(Icons.exit_to_app, color: AppColors.white)),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => controller.leaderBoard.value.users?.isNotEmpty ?? false
              ? ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: InkWell(
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return const LeaderBoard();
                            });
                      },
                      child: Container(
                        width: 46.w,
                        height: 46.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withOpacity(.6)),
                        child:
                            Center(child: Assets.images.leaderboardLive.svg()),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ),
        Obx(() => controller.leaderBoard.value.users?.isNotEmpty ?? false
            ? SizedBox(height: 12.h)
            : SizedBox()),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: InkWell(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return BlockUserList(
                        hostId: widget.localUserID,
                      );
                    });
              },
              child: Container(
                width: 46.w,
                height: 46.h,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(.6)),
                child: Center(
                    child: Assets.svg.blockUser.svg(width: 30.w, height: 30.w)),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          ()=> Visibility(
            visible: (controller.allGiftList.value.giftDetails?.isNotEmpty ?? false),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                child: InkWell(
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return GiftSheet(
                            url: widget.astrologerImage,
                            name: widget.astrologerName,
                          );
                        });
                  },
                  child: Container(
                    width: 46.w,
                    height: 46.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withOpacity(.6)),
                    child: Center(child: Assets.images.giftLive.svg()),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        StreamBuilder<DatabaseEvent>(
            stream: controller.database
                .ref()
                .child("live/${widget.localUserID}/waitList")
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SizedBox();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center();
              } else if (!snapshot.hasData) {
                return const SizedBox();
              } else if (snapshot.data == null) {
                return const SizedBox();
              } else if (snapshot.data!.snapshot.children.isNotEmpty) {
                return Badge(
                  backgroundColor: Colors.redAccent,
                  isLabelVisible: true,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  label: Text(snapshot.data!.snapshot.children.length.toString()),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                      child: InkWell(
                        onTap: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return WaitList(
                                  showNext: false,
                                  data: snapshot.data!.snapshot.children,
                                  astroId: widget.localUserID,
                                  onAccept: (id, name) {},
                                );
                              });
                        },
                        child: Container(
                          width: 46.w,
                          height: 46.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withOpacity(.6)),
                          child: Center(child: Assets.images.waitlistLive.svg()),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
      ],
    );
  }

  /// if you use unreliable message channel, you need subscription this method.
  Future<void> onInRoomCommandMessageReceived(
    ZegoSignalingPluginInRoomCommandMessageReceivedEvent event,
  ) async {
    final messages = event.messages;

    /// You can display different animations according to gift-type
    for (final commandMessage in messages) {
      final senderUserID = commandMessage.senderUserID;
      final message = utf8.decode(commandMessage.message);
      debugPrint('onInRoomCommandMessageReceived: $message');
      if (senderUserID != widget.localUserID) {
        var data = jsonDecode(message);
        for (var i = 0; i < data["gift_count"]; i++) {
          await Future.delayed(const Duration(seconds: 1));
          GiftWidget.show(context,
              "assets/svga/${controller.svgaAnime[data["gift_type"]]}");
        }
      }
    }
  }

  void sendGift() async {
    final data = json.encode({
      'app_id': yourAppID,
      'server_secret': yourServerSecret,
      'room_id': widget.liveID,
      'user_id': widget.localUserID,
      'user_name': 'user_${widget.localUserID}',
      'gift_type': 1001,
      'gift_count': 1,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    try {
      // const url = 'http://localhost:3000/api/send_gift';
      const url = 'https://zego-virtual-gift.vercel.app/api/send_gift';
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: data);
      if (response.statusCode == 200) {
        GiftWidget.show(context, "assets/sports-car.svga");
      } else {
        debugPrint('[ERROR], Send Gift Fail: ${response.statusCode}');
      }
    } on Exception catch (error) {
      debugPrint("[ERROR], Send Gift Fail, ${error.toString()}");
    }
  }

  Widget customAvatarBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return CachedNetworkImage(
      imageUrl: 'https://robohash.org/${user?.id}.png',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        ZegoLoggerService.logInfo(
          '$user avatar url is invalid',
          tag: 'live audio',
          subTag: 'live page',
        );
        return ZegoAvatar(user: user, avatarSize: size);
      },
    );
  }
}
