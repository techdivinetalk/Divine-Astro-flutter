import 'dart:developer';

import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/firebase_service/firebase_service.dart';
import 'package:divine_astrologer/model/astrologer_gift_response.dart';
import 'package:divine_astrologer/model/live/notice_board_res.dart';

import 'package:divine_astrologer/new_live/new_live_controller.dart';
import 'package:divine_astrologer/new_live/widget/snack_bar_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/gifts_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_dharam_controller.dart';
import 'package:divine_astrologer/screens/live_dharam/live_global_singleton.dart';
import 'package:divine_astrologer/screens/live_dharam/live_screen_widgets/live_keyboard.dart';
import 'package:divine_astrologer/screens/live_dharam/live_tarot_game/show_card_deck_to_user.dart';
import 'package:divine_astrologer/screens/live_dharam/live_tarot_game/waiting_for_user_to_select_cards.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/astro_wait_list_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/block_unlock_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/common_button.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/custom_image_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/gift_widget.dart';
import 'package:divine_astrologer/screens/live_dharam/widgets/more_options_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../screens/live_dharam/widgets/leaderboard_widget.dart';

class NewLiveScreen extends GetView<NewLiveController> {
  const NewLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewLiveController>(
      assignId: true,
      init: NewLiveController(),
      builder: (controller) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            floatingActionButton:
                astrologerSettingButton(controller: controller),
            appBar: PreferredSize(
                preferredSize: const Size(double.infinity, 150),
                child: appBarWidget(controller: controller)),
            body: ZegoUIKitPrebuiltLiveStreaming(
                appID: controller.appID,
                appSign: controller.appSign,
                userID: "3878",
                userName: 'user_3878',
                liveID: "3878",
                config: controller.streamingConfig
                  ..slideSurfaceToHide = false
                  ..duration.isVisible = false

                  /// Live before Preview
                  // ..preview.beautyEffectIcon = SvgPicture.asset(
                  //   "assets/svg/beauty_icon.svg",
                  //   height: 50,
                  //   width: 50,
                  // )
                  // ..preview.startLiveButtonBuilder =
                  //     (BuildContext context, VoidCallback startLive) {
                  //   return Expanded(
                  //     child: CommonButton(
                  //       buttonText: "startLive".tr,
                  //       buttonCallback: () async {
                  //         startLive();
                  //         await controller.furtherProcedure();
                  //       },
                  //     ),
                  //   );
                  // }
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
                  ..beautyConfig = ZegoBeautyPluginConfig(
                    effectsTypes: ZegoBeautyPluginConfig.beautifyEffectsTypes(
                          enableBasic: true,
                          enableAdvanced: true,
                          enableMakeup: true,
                          enableStyle: true,
                        ) +
                        ZegoBeautyPluginConfig.filterEffectsTypes(),
                  )
                  ..video = ZegoUIKitVideoConfig.preset1080P()
                  ..coHost.maxCoHostCount = 1
                  ..preview.showPreviewForHost = false
                  ..bottomMenuBar = ZegoLiveStreamingBottomMenuBarConfig(
                    showInRoomMessageButton: false,
                    hostButtons: <ZegoLiveStreamingMenuBarButtonName>[],
                    coHostButtons: <ZegoLiveStreamingMenuBarButtonName>[],
                  )
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
                  ..foreground = foregroundWidget(controller: controller)
                  ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(
                    itemBuilder: (
                      BuildContext context,
                      ZegoInRoomMessage message,
                      Map<String, dynamic> extraInfo,
                    ) {
                      return const SizedBox();
                    },
                  )));
      },
    );
  }

  /// --------------------- App bar for back and settings ----------------------- ///
  Widget appBarWidget({NewLiveController? controller}) {
    return Obx(() {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: controller!.exitFunc,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      final ZegoUIKit instance = ZegoUIKit.instance;
                      controller.isFront.value = !controller.isFront.value;
                      instance.useFrontFacingCamera(controller.isFront.value);
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
                            controller.isFront.value
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
                      controller.isCamOn.value = !controller.isCamOn.value;
                      instance.turnCameraOn(controller.isCamOn.value);
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
                            controller.isCamOn.value
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
                      controller.isMicOn.value = !controller.isMicOn.value;

                      instance.turnMicrophoneOn(controller.isMicOn.value,
                          muteMode: true);
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
                            controller.isMicOn.value
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
            ],
          ),
        ),
      );
    });
  }

  /// --------------------- bottom bar for chat ----------------------- ///
  Widget foregroundWidget({NewLiveController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight - 16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      noticeBoard(controller: controller),
                      SizedBox(
                          height:
                              (controller!.noticeBoardRes!.data ?? []).isEmpty
                                  ? 0.0
                                  : 4.0),
                      LiveMessageUpdateToZego(controller: controller),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                //
                // verticalDefault(),
                //
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AstroLiveBottomBar(controller: controller),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget AstroLiveBottomBar({NewLiveController? controller}) {
    return Row(
      children: [
        const SizedBox(width: 8),

        /// Message widget
        GestureDetector(
          onTap: () async {
            controller!.isKeyboardSheetOpen = true;
            LiveGlobalSingleton().isKeyboardPopupOpen = true;
            await showModalBottomSheet(
              context: Get.context!,
              elevation: 0,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return LiveKeyboard(
                    sendKeyboardMesage: controller.sendKeyboardMesage);
              },
            );
            controller.isKeyboardSheetOpen = false;
            LiveGlobalSingleton().isKeyboardPopupOpen = false;
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appColors.guideColor,
              ),
              color: appColors.black.withOpacity(0.2),
            ),
            child: Image.asset(
              "assets/images/live_new_chat_icon.png",
            ),
          ),
        ),
        const SizedBox(width: 8),
        controller!.currentCaller!.isEngaded
            ? newAppBarCenterWithCall(controller: controller)
            : newAppBarCenter(),
        const SizedBox(width: 8),

        /// Leave live
        GestureDetector(
          onTap: () async {
            await controller.exitFunc();
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.black.withOpacity(0.2),
            ),
            child: Image.asset(
              controller.currentCaller!.isEngaded
                  ? "assets/images/live_new_hang_up.png"
                  : "assets/images/live_exit_red.png",
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget newAppBarCenterWithCall({NewLiveController? controller}) {
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${controller!.astroName.value} with ${controller.currentCaller!.userName}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          "${controller!.currentCaller!.callType.capitalize ?? ""} Call:",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: newTimerWidget()),
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

  Widget newTimerWidget() {
    final String source = /*controller.engagedCoHostWithAstro().totalTime*/ "0";

    final int epoch = int.parse(source.isEmpty ? "0" : source);
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      enableDescriptions: false,
      spacerWidth: 4,
      colonsTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      timeTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
      onTick: (Duration duration) async {
        // final bool cond1 = isLessThanOneMinute(duration);
        // final bool cond2 = !controller.extendTimeWidgetVisible;
        // final bool cond3 = controller.currentCaller.id == controller.userId;

        // if (cond1 && cond2 && cond3) {
        //   controller.extendTimeWidgetVisible = true;
        //   await extendTimeWidgetPopup();
        // } else {}
      },
      endTime: dateTime,
      onEnd: () async {
        print("time is ending newTimerWidget");
        // await removeCoHostOrStopCoHost();
      },
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
                  imageUrl: controller.astroAvatar.value,
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
                      controller.astroName.value,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.getSpeciality(),
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
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------ Notice board ------------------ ///
  Widget noticeBoard({NewLiveController? controller}) {
    // do not remove
    print("timerCurrentIndex: ${controller!.timerCurrentIndex - 1}");
    //
    return AnimatedOpacity(
      opacity: (controller.noticeBoardRes!.data ?? []).isEmpty ? 0.0 : 1.0,
      duration: const Duration(seconds: 1),
      child: (controller.noticeBoardRes!.data ?? []).isEmpty
          ? const SizedBox()
          : SizedBox(
              width: Get.width / 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  final int timerCurrentIndex =
                      controller.timerCurrentIndex.value - 1;
                  final NoticeBoardResData noticeBoardResData =
                      controller.noticeBoardRes!.data?[timerCurrentIndex] ??
                          NoticeBoardResData();
                  final String title = noticeBoardResData.title ?? "";
                  final String description =
                      noticeBoardResData.description ?? "";
                  // final String createdAt =
                  //     noticeBoardResData.createdAt ?? DateTime.now().toString();
                  // final DateTime tzDateTime = DateTime.parse(createdAt).toUtc();
                  // final String formattedDate = formatDate(tzDateTime);
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
                          // Text(
                          //   description,
                          //   style: const TextStyle(
                          //     fontSize: 10,
                          //     color: Colors.white,
                          //   ),
                          //   maxLines: 5,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          /*const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),*/
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

  /// ------------------ Live Zego msg ---------------- ///
  Widget LiveMessageUpdateToZego({NewLiveController? controller}) {
    return SizedBox(
      height: Get.height * 0.30,
      child: StreamBuilder<List<ZegoInRoomMessage>>(
        stream: controller!.zegoController.message.stream(),
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
            itemCount: messages.length,
            controller: controller.scrollControllerForBottom,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final ZegoInRoomMessage message = messages[index];
              final ZegoCustomMessage msg =
                  controller.receiveMessageToZego(message.message);
              final bool isBlocked =
                  controller.firebaseBlockUsersIds.contains(msg.userId);
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
                                  Text(
                                    msg.userName ?? "",
                                    // nameWithWithoutIDs(msg, isModerator),
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
                                  Text(
                                    msg.message ?? "",
                                    maxLines: 2,
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
                              SizedBox(
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
                                      controller: controller,
                                      isBlocked: controller.isBlocked(
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

  /// User settings options like ask for audio call private call video call

  Future<void> moreOptionsPopup(
      {required String userId,
      required String userName,
      required bool isBlocked,
      NewLiveController? controller}) async {
    LiveGlobalSingleton().isMoreOptionsPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
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
            await giftPopup(
                ctx: context,
                userId: userId,
                userName: userName,
                controller: controller);
            liveSnackBar(msg: "Gift");
          },
          onTapAskForVideoCall: () async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": controller!.liveId,
                "user_id": userId,
                "user_name": userName,
                "item": item.toJson(),
                "type": "Ask For Video Call",
              };
              await controller.sendGiftAPI(
                data: data,
              );
            } else {}
            liveSnackBar(msg: "Video Call");
          },
          onTapAskForAudioCall: () async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": controller!.liveId,
                "user_id": userId,
                "user_name": userName,
                "item": item.toJson(),
                "type": "Ask For Voice Call",
              };
              await controller.sendGiftAPI(
                data: data,
              );
            } else {}
            liveSnackBar(msg: "Voice Call");
          },
          onTapAskForPrivateCall: () async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": controller!.liveId,
                "user_id": userId,
                "user_name": userName,
                "item": item.toJson(),
                "type": "Ask For Private Call",
              };
              await controller.sendGiftAPI(
                data: data,
              );
            } else {}
            liveSnackBar(msg: "Private Call");
          },
          onTapAskForBlockUnBlockUser: () async {
            Get.back();
            await blockUnblockPopup(
              isAlreadyBeenBlocked: isBlocked,
              performAction: () async {
                if (userId != "0") {
                  await controller!.callblockCustomer(
                    id: int.parse(userId),
                  );
                  var data = {
                    "room_id": controller.liveId,
                    "user_id": userId,
                    "user_name": userName,
                    "item": item.toJson(),
                    "type": "Block/Unblock",
                  };
                  await controller.sendGiftAPI(
                    data: data,
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

  /// Block pop up
  Future<void> blockUnblockPopup({
    required bool isAlreadyBeenBlocked,
    required Function() performAction,
  }) async {
    LiveGlobalSingleton().isBlockUnblockPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
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

  /// Gift pop up
  Future<void> giftPopup(
      {required BuildContext ctx,
      required String userId,
      required String userName,
      NewLiveController? controller}) async {
    LiveGlobalSingleton().isGiftPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return GiftWidget(
          onClose: Get.back,
          list: GiftsSingleton().gifts.data ?? <GiftData>[],
          onSelect: (GiftData item, num quantity) async {
            Get.back();
            if (userId != "0") {
              var data = {
                "room_id": controller!.liveId.value,
                "user_id": userId,
                "user_name": userName,
                "item": item.toJson(),
                "type": "Ask For Gift",
              };
              await controller.sendGiftAPI(
                data: data,
              );
            }
          },
          isHost: true,
          walletBalance: 0,
        );
      },
    );
    LiveGlobalSingleton().isGiftPopupOpen = false;
    return Future<void>.value();
  }

  Widget astrologerSettingButton({NewLiveController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 55),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return AnimatedOpacity(
                opacity: !controller!.currentCaller!.isEngaded ? 0.0 : 1.0,
                duration: const Duration(seconds: 1),
                child: !controller.currentCaller!.isEngaded
                    ? const SizedBox()
                    : Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              // await controller.addOrUpdateCard();
                              await showCardDeckToUserPopup();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                border: Border.all(
                                  color: appColors.guideColor,
                                ),
                                color: appColors.black.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/live_tarot_new_icon.png",
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Ask User",
                            style:
                                TextStyle(fontSize: 8, color: appColors.white),
                          ),
                          Text(
                            "for tarot",
                            style:
                                TextStyle(fontSize: 8, color: appColors.white),
                          ),
                          Text(
                            "reading",
                            style:
                                TextStyle(fontSize: 8, color: appColors.white),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
              );
            },
          ),
          //
          AnimatedOpacity(
            opacity: controller!.waitList.isEmpty ? 0.0 : 1.0,
            duration: const Duration(seconds: 1),
            child: controller.waitList.isEmpty
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
                                  controller!.waitList.isEmpty
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
                                                controller!.waitList.length
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
          ),
          AnimatedOpacity(
            opacity: controller.leaderboardModel.isEmpty ? 0.0 : 1.0,
            duration: const Duration(seconds: 1),
            child: controller.leaderboardModel.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          LiveGlobalSingleton().isLeaderboardPopupOpen = true;
                          await showCupertinoModalPopup(
                            context: Get.context!,
                            builder: (BuildContext context) {
                              return LeaderboardWidget(
                                onClose: Get.back,
                                leaderboardModel: controller.leaderboardModel,
                                liveId: controller.liveId.value,
                              );
                            },
                          );
                          LiveGlobalSingleton().isLeaderboardPopupOpen = false;
                          controller.update();
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
                ZegoUIKit.instance.getBeautyPlugin().showBeautyUI(Get.context!);
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
                    style: TextStyle(
                        fontFamily: "Metropolis", color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          /*controller.isHost
              ?*/
          StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Obx(() {
                return AnimatedOpacity(
                  opacity: isLiveCall.value == 0 ? 0.0 : 1.0,
                  duration: const Duration(seconds: 1),
                  child: isLiveCall.value == 0
                      ? const SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                controller.isHostAvailable.value =
                                    !controller.isHostAvailable.value;

                                controller.reference
                                    .child(
                                        "liveTest/${controller.liveId.value}")
                                    .update({
                                  "isAvailable":
                                      controller.isHostAvailable.value,
                                });
                              },
                              child: SizedBox(
                                height: 84 - 50,
                                width: 84,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50.0)),
                                    border:
                                        Border.all(color: appColors.guideColor),
                                    color: appColors.black.withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Image.asset(
                                      controller.isHostAvailable.value
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
              });
            },
          )
          /*: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return AnimatedOpacity(
                opacity:
                (!controller.isHost && !controller.isHostAvailable) ||
                    isLiveCall.value == 0
                    ? 0.0
                    : 1.0,
                //
                //
                //
                duration: const Duration(seconds: 1),
                child:
                (!controller.isHost && !controller.isHostAvailable) ||
                    isLiveCall.value == 0
                //
                //
                //
                    ? const SizedBox()
                    : Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        // controller.isCustBlocked.data
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
                                  // child: Text(controller.testingVar.toString()),
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
          ),*/
        ],
      ),
    );
  }

  /// wait list who want to do call
  Future<void> waitListPopup() async {
    LiveGlobalSingleton().isWaitListPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        // return WaitListWidget(
        return AstroWaitListWidget(
          onClose: Get.back,
          isInCall: controller.currentCaller!.isEngaded,
          waitTime: controller.getTotalWaitTime(),
          myUserId: controller.astroId.value,
          list: controller.waitList,
          hasMyIdInWaitList: false,
          onExitWaitList: () async {
            // Get.back();
            // await exitWaitListPopup(
            //   noDisconnect: () {},
            //   yesDisconnect: () async {
            //   },
            // );
          },
          astologerName: controller.astroName.value,
          astologerImage: controller.astroAvatar.value,
          astologerSpeciality: controller.hostSpeciality.value,
          isHost: true,
          onAccept: () async {
            Get.back();
            final String id = controller.waitList.first.id;
            final String name = controller.waitList.first.userName;
            final String avatar = controller.waitList.first.avatar;
            final ZegoUIKitUser user = ZegoUIKitUser(id: id, name: name);
            final connectInvite = controller.zegoController.coHost;
            await connectInvite.hostSendCoHostInvitationToAudience(user);
          },
          onReject: Get.back,
          model: controller.currentCaller!,
        );
      },
    );
    LiveGlobalSingleton().isWaitListPopupOpen = false;
    return Future<void>.value();
  }

  Future<void> showCardDeckToUserPopup({NewLiveController? controller}) async {
    LiveGlobalSingleton().isShowCardDeckToUserPopupOpen = true;
    await showCupertinoModalPopup(
      context: Get.context!,
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
              senderId: controller!.astroId.value,
              receiverId: controller.currentCaller!.id,
            );
            Future.delayed(const Duration(milliseconds: 200));
            var data = {
              "room_id": controller.liveId.value,
              "user_id": controller.astroId.value,
              "user_name": controller.astroName.value,
              "item": item.toJson(),
              "type": "Tarot Card",
            };
            await controller.sendGiftAPI(data: data);

            controller.waitingForUserToSelectCardsPopupVisible.value = true;
            LiveGlobalSingleton().isWaitingForUserToSelectCardsPopupOpen = true;
            await showCupertinoModalPopup(
              context: Get.context!,
              builder: (BuildContext context) {
                return WaitingForUserToSelectCards(
                  onClose: Get.back,
                  userName: controller.currentCaller!.userName,
                  onTimeout: () async {
                    Get.back();
                    liveSnackBar(
                      msg: "Card Selection Timeout",
                    );
                    // await sendTaroCardClose();
                  },
                );
              },
            );
            controller.waitingForUserToSelectCardsPopupVisible.value = false;
            LiveGlobalSingleton().isWaitingForUserToSelectCardsPopupOpen =
                false;
            controller.update();
          },
          userName: controller!.currentCaller!.userName,
          onTimeout: () async {
            Get.back();
            await controller.sendTaroCardClose();
          },
          totalTime: /*controller.engagedCoHostWithAstro().totalTime*/ "0",
        );
      },
    );
    LiveGlobalSingleton().isShowCardDeckToUserPopupOpen = false;
    return Future<void>.value();
  }
}
