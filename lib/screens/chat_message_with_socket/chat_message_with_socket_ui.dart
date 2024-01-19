import "dart:collection";
import "dart:convert";
import "dart:io";
import "dart:ui";

import "package:divine_astrologer/common/app_textstyle.dart";
import "package:divine_astrologer/common/cached_network_image.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/permission_handler.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/di/shared_preference_service.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/tarotCard/FlutterCarousel.dart";
import "package:divine_astrologer/zego_call/zego_service.dart";
import "package:emoji_picker_flutter/emoji_picker_flutter.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:lottie/lottie.dart";
import "package:permission_handler/permission_handler.dart";
import "package:social_media_recorder/audio_encoder_type.dart";
import "package:social_media_recorder/screen/social_media_recorder.dart";
import "package:voice_message_package/voice_message_package.dart";

import "../live_dharam/widgets/custom_image_widget.dart";
import "chat_message_with_socket_controller.dart";

class ChatMessageWithSocketUI extends GetView<ChatMessageWithSocketController> {
  const ChatMessageWithSocketUI({super.key});

  @override
  Widget build(BuildContext context) {
    var pref = Get.find<SharedPreferenceService>();
    return Scaffold(
      body: GetBuilder<ChatMessageWithSocketController>(builder: (controller) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                controller.isEmojiShowing.value = false;
              },
              child: Assets.images.bgChatWallpaper.image(
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth),
            ),
            Column(
              children: [
                AstrologerChatAppBar(),
                permissionRequestWidget(),
                Expanded(
                  child: Stack(
                    children: [
                      MediaQuery.removePadding(
                          context: context,
                          removeBottom: true,
                          removeTop: true,
                          child: Obx(
                            () => AnimatedCrossFade(
                              duration: const Duration(milliseconds: 200),
                              crossFadeState: controller.chatMessages.isEmpty ||
                                      controller.isDataLoad.value == false
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              secondChild: Container(),
                              firstChild: NotificationListener(
                                onNotification: (t) {
                                  if (t is ScrollEndNotification) {
                                    bool atScrollViewBottom = controller
                                            .messgeScrollController
                                            .position
                                            .pixels <
                                        controller.messgeScrollController
                                                .position.maxScrollExtent -
                                            100;
                                    controller.scrollToBottom.value =
                                        atScrollViewBottom;
                                    if (atScrollViewBottom == false &&
                                        controller.unreadMsgCount.value > 0) {
                                      controller.updateReadMessageStatus();
                                    }
                                  }
                                  return true;
                                },
                                child: ListView.builder(
                                  controller: controller.messgeScrollController,
                                  itemCount: controller.chatMessages.length,
                                  shrinkWrap: true,
                                  reverse: false,
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  itemBuilder: (context, index) {
                                    var chatMessage =
                                        controller.chatMessages[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 12.w),
                                          child: Column(
                                            children: [
                                              if (chatMessage.id ==
                                                  controller
                                                      .unreadMessageIndex.value)
                                                unreadMessageView(),
                                              chatMessage.msgType == "kundli"
                                                  ? kundliView(
                                                      chatDetail: chatMessage,
                                                      index: index)
                                                  : chatMessage.msgType ==
                                                          "image"
                                                      ? imageMsgView(
                                                          controller
                                                                  .chatMessages[
                                                                      index]
                                                                  .base64Image ??
                                                              "",
                                                          chatDetail: controller
                                                                  .chatMessages[
                                                              index],
                                                          index: index,
                                                          chatMessage.senderId ==
                                                              preferenceService
                                                                  .getUserDetail()!
                                                                  .id)
                                                      : chatMessage.msgType ==
                                                              "audio"
                                                          ? audioView(context,
                                                              chatDetail: controller
                                                                      .chatMessages[
                                                                  index],
                                                              yourMessage: chatMessage
                                                                      .senderId ==
                                                                  preferenceService
                                                                      .getUserDetail()!
                                                                      .id)
                                                          : chatMessage
                                                                      .msgType ==
                                                                  "gift"
                                                              ? giftMsgView(
                                                                  context,
                                                                  chatMessage,
                                                                  chatMessage
                                                                          .senderId ==
                                                                      preferenceService
                                                                          .getUserDetail()!
                                                                          .id,
                                                                )
                                                              : textMsgView(
                                                                  context,
                                                                  chatMessage,
                                                                  chatMessage
                                                                          .senderId ==
                                                                      preferenceService
                                                                          .getUserDetail()!
                                                                          .id),
                                            ],
                                          ),
                                        ),
                                        if (index ==
                                            (controller.chatMessages.length -
                                                1))
                                          typingWidget()
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          )),
                      Positioned(
                        bottom: 4.h,
                        right: 25.w,
                        child: Obx(() => controller.scrollToBottom.value
                            ? InkWell(
                                onTap: () {
                                  //  controller.scrollToBottomFunc();
                                  //  controller.updateReadMessageStatus();
                                },
                                child: Badge(
                                  backgroundColor: AppColors.darkBlue,
                                  offset: const Offset(4, -2),
                                  isLabelVisible:
                                      (controller.unreadMsgCount.value > 0),
                                  label: Text(
                                      "${controller.unreadMsgCount.value}"),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.w),
                                  smallSize: 14.sp,
                                  largeSize: 20.sp,
                                  child: Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                      color: AppColors.appYellowColour,
                                      size: 40.h),
                                ),
                              )
                            : const SizedBox()),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: controller.isCardVisible.value == true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F2F2F),
                          borderRadius: BorderRadius.circular(
                              14), // First container border radius
                        ), // First container color
                        child: Column(
                          children: [
                            const Center(
                                child: Text(
                              "Chosen cards",
                              style: TextStyle(color: Color(0xFCD194)),
                            )),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                controller.getListOfCardLength(),
                                (index) => Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      // Adjust the height as needed
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF212121),
                                        borderRadius: BorderRadius.circular(
                                            10), // Second container border radius
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Image.network(
                                          "${pref.getAmazonUrl()}/${controller.getValueByPosition(index)}",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                controller.getListOfCardLength(),
                                (index) => Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Center(
                                        child: Text(
                                      textAlign: TextAlign.center,
                                      // Add this line for text alignment
                                      controller.getKeyByPosition(index),
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize:
                                            12, // Adjust the font size as needed
                                      ),
                                      softWrap: true,
                                      maxLines: 3,
                                      // Maximum lines allowed
                                      overflow: TextOverflow
                                          .ellipsis, // Optional: use ellipsis to indicate text overflow
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 10.h),
                Obx(
                  () => controller.messageTemplates.isNotEmpty
                      ? Column(
                          children: [
                            messageTemplateRow(),
                            SizedBox(height: 20.h),
                          ],
                        )
                      : const SizedBox(),
                ),
                chatBottomBar(context),
                Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: controller.isEmojiShowing.value ? 300 : 0,
                      child: SizedBox(
                        height: 300,
                        child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              controller.typingScrollController.hasClients
                                  ? controller.typingScrollController.animateTo(
                                      controller.typingScrollController.position
                                          .maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.easeOut)
                                  : null;
                            },
                            onBackspacePressed: () {
                              _onBackspacePressed();
                            },
                            textEditingController: controller.messageController,
                            config: const Config(
                                columns: 7,
                                emojiSizeMax: 32.0,
                                verticalSpacing: 0,
                                horizontalSpacing: 0,
                                initCategory: Category.RECENT,
                                bgColor: Color(0xFFF2F2F2),
                                indicatorColor: AppColors.appRedColour,
                                iconColor: Colors.grey,
                                iconColorSelected: AppColors.appRedColour,
                                enableSkinTones: true,
                                recentTabBehavior: RecentTabBehavior.RECENT,
                                recentsLimit: 28,
                                replaceEmojiOnLimitExceed: false,
                                backspaceColor: AppColors.appRedColour,
                                categoryIcons: CategoryIcons(),
                                buttonMode: ButtonMode.MATERIAL)),
                      ),
                    ))
              ],
            ),
            // Obx(() => Visibility(
            //     visible: !controller.isDataLoad.value,
            //     child: const IgnorePointer(
            //       ignoring: true,
            //       child: LoadingIndicatorWidget(),
            //     ))),
          ],
        );
      }),
    );
  }

  Widget permissionRequestWidget() {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child("order/${AppFirebaseService().orderData.value["orderId"]}")
          .onValue
          .asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        final astPerm = hasAstrologerPermission(snapshot.data?.snapshot);
        final cusPerm = hasCustomerPermission(snapshot.data?.snapshot);
        return AnimatedOpacity(
          opacity: astPerm ? 0.0 : 1.0,
          duration: const Duration(seconds: 1),
          child: astPerm
              ? const SizedBox()
              : InkWell(
                  onTap: () async {
                    await ZegoService().onPressed();
                  },
                  child: const SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Card(
                      child: Center(
                        child: Text(
                          "Allow permissions required for Video / Audio calls.",
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  bool hasAstrologerPermission(DataSnapshot? dataSnapshot) {
    bool hasPermission = false;
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          hasPermission = map["astrologer_permission"] ?? false;
        } else {}
      } else {}
    } else {}
    return hasPermission;
  }

  bool hasCustomerPermission(DataSnapshot? dataSnapshot) {
    bool hasPermission = false;
    if (dataSnapshot != null) {
      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> map = <dynamic, dynamic>{};
          map = (dataSnapshot.value ?? <dynamic, dynamic>{})
              as Map<dynamic, dynamic>;
          hasPermission = map["customer_permission"] ?? false;
        } else {}
      } else {}
    } else {}
    return hasPermission;
  }

  Widget giftDisplayText(ChatMessage chatMessage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: CustomImageWidget(
              imageUrl: chatMessage.awsUrl ?? '',
              rounded: true,
              // added by divine-dharam
              typeEnum: TypeEnum.gift,
              //
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            '${controller.customerName} has sent you ${chatMessage.message}',
            style: AppTextStyle.textStyle12(fontColor: AppColors.red),
          ),
        ],
      ),
    );
  }

  Widget messageTemplateRow() {
    return SizedBox(
      height: 35,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: controller.messageTemplates.length + 1,
        separatorBuilder: (_, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          //MessageTemplates msg = controller.messageTemplates[index];
          return index == 0
              ? GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.addMessageTemplate,
                        arguments: [true, false]);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Text(
                      '+ Add',
                      style:
                          AppTextStyle.textStyle12(fontColor: AppColors.white),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    controller.sendMsgTemplate(
                        controller.messageTemplates[index - 1]);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.brownColour,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Text(
                      '${controller.messageTemplates[index - 1].message}',
                      style:
                          AppTextStyle.textStyle12(fontColor: AppColors.white),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget typingWidget() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: controller.isTyping.value
                ? Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3.0,
                            offset: const Offset(0.0, 3.0)),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    // child: Assets.images.icTyping.image(
                    //   width: 45,
                    //   height: 30,
                    // ),
                    child: Assets.lottie.loadingDots.lottie(
                        width: 45,
                        height: 30,
                        repeat: true,
                        frameRate: FrameRate(120),
                        animate: true),
                  )
                : const SizedBox(),
          )),
    );
  }

  Widget chatBottomBar(BuildContext context) {
    return Obx(
      () {
        debugPrint('is recording value ${controller.isRecording.value}');
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: controller.isRecording.value ? 0 : 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Visibility(
                    visible: !controller.isRecording.value,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainState: true,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3.0,
                                      offset: const Offset(0.3, 3.0)),
                                ]),
                            child: TextFormField(
                              controller: controller.messageController,
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 3,
                              onTap: () {
                                //  controller.userTypingSocket(isTyping: true);
                                controller.scrollToBottomFunc();
                                if (controller.isEmojiShowing.value) {
                                  controller.isEmojiShowing.value = false;
                                }
                              },
                              onChanged: (value) {
                                controller.tyingSocket();
                              },
                              scrollController:
                                  controller.typingScrollController,
                              onTapOutside: (value) {
                                FocusScope.of(Get.context!).unfocus();
                                //   controller.userTypingSocket(isTyping: false);
                              },
                              decoration: InputDecoration(
                                hintText: "message".tr,
                                isDense: true,
                                helperStyle: AppTextStyle.textStyle16(),
                                fillColor: AppColors.white,
                                hintStyle: AppTextStyle.textStyle16(
                                    fontColor: AppColors.grey),
                                hoverColor: AppColors.white,
                                prefixIcon: InkWell(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    controller.isEmojiShowing.value =
                                        !controller.isEmojiShowing.value;
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 11.h),
                                    child: Assets.images.icEmoji.svg(),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    showCurvedBottomSheet(context);
                                    // if (controller.isOngoingChat.value) {

                                    //   } else {
                                    //     divineSnackBar(
                                    //         data: "${'chatEnded'.tr}.", color: AppColors.appYellowColour);
                                    //   }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.w, 9.h, 10.w, 10.h),
                                    child: Assets.images.icAttechment.svg(),
                                  ),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0.sp),
                                    borderSide: const BorderSide(
                                      color: AppColors.white,
                                      width: 1.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0.sp),
                                    borderSide: const BorderSide(
                                      color: AppColors.appYellowColour,
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 15.w),
                        GestureDetector(
                          onTap: () {
                            controller.askForGift();
                          },
                            child: SvgPicture.asset('assets/svg/chat_gift.svg')),
                        const SizedBox(width: 10,),
                        Visibility(
                          visible: controller.hasMessage.value,
                          maintainAnimation: true,
                          maintainSize: true,
                          maintainState: true,
                          child: InkWell(
                              onTap: () => controller.sendMsg(),
                              child: Assets.images.icSendMsg.svg(height: 48.h)),
                        )
                      ],
                    ),
                  ),
                  if (!controller.hasMessage.value)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 500))
                              .then((value) =>
                                  controller.isRecording.value = false);
                        },
                        child: SocialMediaRecorder(
                          backGroundColor: AppColors.yellow,
                          cancelTextBackGroundColor: Colors.white,
                          recordIconBackGroundColor: AppColors.yellow,
                          radius: BorderRadius.circular(30),
                          initRecordPackageWidth:
                              kToolbarHeight - Get.width * 0.010,
                          recordIconWhenLockBackGroundColor: AppColors.yellow,
                          maxRecordTimeInSecond: 30,
                          startRecording: () {
                            controller.isRecording.value = true;
                          },
                          stopRecording: (time) {
                            controller.isRecording.value = false;
                          },
                          sendRequestFunction: (soundFile, time) {
                            controller.isRecording.value = false;
                            debugPrint("soundFile ${soundFile.path}");
                            controller.uploadAudioFile(soundFile);
                          },
                          encode: AudioEncoderType.AAC,
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void showCurvedBottomSheet(context) {
    List<SvgPicture> itemList = [
      SvgPicture.asset('assets/svg/camera_icon.svg'),
      SvgPicture.asset('assets/svg/gallery_icon.svg'),
      SvgPicture.asset('assets/svg/remedies_icon.svg'),
      SvgPicture.asset('assets/svg/deck_icon.svg'),
      SvgPicture.asset('assets/svg/kundli_icon.svg'),
      // Add more items as needed
    ];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: GridView.count(
              shrinkWrap:true,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(itemList.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    switch (index) {
                      case 0:
                        controller.getImage(false);
                        break;
                      case 1:
                        controller.getImage(false);
                        break;
                      case 2:
                        controller.getImage(false);
                        break;
                      case 3:
                        showCardChoiceBottomSheet(context, controller);
                        // showModalBottomSheet<void>(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return SizedBox(
                        //       height: 200,
                        //       child: Center(
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: <Widget>[
                        //             const Text('Modal BottomSheet'),
                        //             ElevatedButton(
                        //               child: const Text('Close BottomSheet'),
                        //               onPressed: () => Navigator.pop(context),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                        //  showOneCard(context);
                        break;
                      case 4:
                        controller.getImage(false);
                        break;
                    }
                  },
                  //     if (await PermissionHelper()
                  //     .askStoragePermission(
                  //     Permission.photos)) {
                  // }
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      itemList[index],
                      // Replace with your asset images
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

  Widget giftMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              border: Border.all(width: 2, color: AppColors.appColorDark),
              gradient: const LinearGradient(
                colors: [AppColors.white, AppColors.appColorDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            constraints: BoxConstraints(
                maxWidth: ScreenUtil().screenWidth * 0.8,
                minWidth: ScreenUtil().screenWidth * 0.27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 32,
                  width: 32,
                  child: CustomImageWidget(
                    imageUrl: chatMessage.awsUrl ?? '',
                    rounded: true,
                    // added by divine-dharam
                    typeEnum: TypeEnum.gift,
                    //
                  ),
                ),
                SizedBox(width: 6.w),
                Flexible(
                    child: Text(
                        'Astrologer has requested to send ${chatMessage.message}.'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textMsgView(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    RxInt msgType = (chatMessage.type ?? 0).obs;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 3.0)),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            constraints: BoxConstraints(
                maxWidth: ScreenUtil().screenWidth * 0.7,
                minWidth: ScreenUtil().screenWidth * 0.27),
            child: Stack(
              alignment:
                  yourMessage ? Alignment.centerRight : Alignment.centerLeft,
              children: [
                Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Text(
                          chatMessage.message ?? "",
                          style: AppTextStyle.textStyle14(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h)
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        messageDateTime(chatMessage.time ?? 0),
                        style: AppTextStyle.textStyle10(
                          fontColor: AppColors.darkBlue,
                        ),
                      ),
                      if (yourMessage) SizedBox(width: 8.w),
                      if (yourMessage)
                        Obx(() => msgType.value == 0
                            ? Assets.images.icSingleTick.svg()
                            : msgType.value == 1
                                ? Assets.images.icDoubleTick.svg(
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.greyColor, BlendMode.srcIn))
                                : msgType.value == 3
                                    ? Assets.images.icDoubleTick.svg()
                                    : Assets.images.icSingleTick.svg())
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget audioView(BuildContext context,
      {required ChatMessage chatDetail, required bool yourMessage}) {
    RxInt msgType = (chatDetail.type ?? 0).obs;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3.0,
                    offset: const Offset(0.0, 3.0))
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                VoiceMessageView(
                    controller: VoiceController(
                        audioSrc: chatDetail.awsUrl!,
                        maxDuration: const Duration(seconds: 120),
                        isFile: false,
                        onComplete: () => debugPrint("onComplete"),
                        onPause: () => debugPrint("onPause"),
                        onPlaying: () => debugPrint("onPlaying")),
                    innerPadding: 0,
                    cornerRadius: 20),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        messageDateTime(chatDetail.time ?? 0),
                        style: AppTextStyle.textStyle10(
                            fontColor: AppColors.black),
                      ),
                      if (yourMessage) SizedBox(width: 8.w),
                      if (yourMessage)
                        msgType.value == 0
                            ? Assets.images.icSingleTick.svg()
                            : msgType.value == 1
                                ? Assets.images.icDoubleTick.svg(
                                    colorFilter: const ColorFilter.mode(
                                        AppColors.lightGrey, BlendMode.srcIn))
                                : msgType.value == 3
                                    ? Assets.images.icDoubleTick.svg()
                                    : Assets.images.icSingleTick.svg()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget imageMsgView(String image, bool yourMessage,
      {required ChatMessage chatDetail, required int index}) {
    // Uint8List bytesImage = const Base64Decoder().convert(image);
    Uint8List bytesImage = base64.decode(image);
    RxInt msgType = (chatDetail.type ?? 0).obs;
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment:
            yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3.0,
                      offset: const Offset(0.0, 3.0)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
              ),
              constraints: BoxConstraints(
                  maxWidth: ScreenUtil().screenWidth * 0.7,
                  minWidth: ScreenUtil().screenWidth * 0.27),
              child: yourMessage
                  ? Stack(
                      children: [
                        Image.memory(
                          bytesImage,
                          fit: BoxFit.cover,
                          height: 200.h,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6)
                                .copyWith(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10.r)),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.darkBlue.withOpacity(0.0),
                                  AppColors.darkBlue.withOpacity(0.0),
                                  AppColors.darkBlue.withOpacity(0.5),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  messageDateTime(chatDetail.time ?? 0),
                                  style: AppTextStyle.textStyle10(
                                      fontColor: AppColors.white),
                                ),
                                if (yourMessage) SizedBox(width: 8.w),
                                if (yourMessage)
                                  msgType.value == 0
                                      ? Assets.images.icSingleTick.svg()
                                      : msgType.value == 1
                                          ? Assets.images.icDoubleTick.svg(
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      AppColors.greyColor,
                                                      BlendMode.srcIn))
                                          : msgType.value == 3
                                              ? Assets.images.icDoubleTick.svg()
                                              : Assets.images.icSingleTick.svg()
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : chatDetail.downloadedPath == ""
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Image.network(
                                  chatDetail.awsUrl ?? '',
                                  fit: BoxFit.cover,
                                  height: 200.h,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.downloadImage(
                                    fileName: image,
                                    chatDetail: chatDetail,
                                    index: index);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.darkBlue.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.download_rounded,
                                    color: AppColors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 6)
                                        .copyWith(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.r)),
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.darkBlue.withOpacity(0.0),
                                          AppColors.darkBlue.withOpacity(0.0),
                                          AppColors.darkBlue.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      messageDateTime(chatDetail.time ?? 0),
                                      style: AppTextStyle.textStyle10(
                                          fontColor: AppColors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            Get.toNamed(RouteName.imagePreviewUi,
                                arguments: chatDetail.downloadedPath);
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0.r),
                                child: Image.file(
                                  File(chatDetail.downloadedPath ?? ""),
                                  fit: BoxFit.cover,
                                  height: 200.h,
                                ),
                              ),
                            ],
                          ),
                        ))
        ],
      ),
    );
  }

  // Widget imageMsgView(String image, bool yourMessage, {required ChatMessage chatDetail, required int index}) {
  //   Uint8List bytesImage = const Base64Decoder().convert(image);
  //   RxInt msgType = (chatDetail.type ?? 0).obs;
  //   return SizedBox(
  //     width: double.maxFinite,
  //     child: Column(
  //       crossAxisAlignment: yourMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8.0),
  //           clipBehavior: Clip.antiAlias,
  //           decoration: BoxDecoration(
  //             boxShadow: [
  //               BoxShadow(
  //                   color: Colors.black.withOpacity(0.2), blurRadius: 3.0, offset: const Offset(0.0, 3.0)),
  //             ],
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(8.r)),
  //           ),
  //           constraints: BoxConstraints(
  //               maxWidth: ScreenUtil().screenWidth * 0.7, minWidth: ScreenUtil().screenWidth * 0.27),
  //           child: chatDetail.downloadedPath != ""
  //               ? InkWell(
  //                   onTap: () {
  //                     Get.toNamed(RouteName.imagePreviewUi, arguments: chatDetail.downloadedPath);
  //                   },
  //                   child: Stack(
  //                     children: [
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.circular(8.0.r),
  //                         child: Image.file(
  //                           File(chatDetail.downloadedPath ?? ""),
  //                           fit: BoxFit.cover,
  //                           height: 200.h,
  //                         ),
  //                       ),
  //                       Positioned(
  //                         bottom: 0,
  //                         right: 0,
  //                         child: Container(
  //                           padding: const EdgeInsets.symmetric(horizontal: 6).copyWith(left: 10),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r)),
  //                             gradient: LinearGradient(
  //                               colors: [
  //                                 AppColors.darkBlue.withOpacity(0.0),
  //                                 AppColors.darkBlue.withOpacity(0.0),
  //                                 AppColors.darkBlue.withOpacity(0.5),
  //                               ],
  //                               begin: Alignment.topLeft,
  //                               end: Alignment.bottomCenter,
  //                             ),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.end,
  //                             children: [
  //                               Text(
  //                                 messageDateTime(chatDetail.time ?? 0),
  //                                 style: AppTextStyle.textStyle10(fontColor: AppColors.white),
  //                               ),
  //                               if (yourMessage) SizedBox(width: 8.w),
  //                               if (yourMessage)
  //                                 msgType.value == 0
  //                                     ? Assets.images.icSingleTick.svg()
  //                                     : msgType.value == 1
  //                                         ? Assets.images.icDoubleTick.svg(
  //                                             colorFilter: const ColorFilter.mode(
  //                                                 AppColors.greyColor, BlendMode.srcIn))
  //                                         : msgType.value == 2
  //                                             ? Assets.images.icDoubleTick.svg()
  //                                             : Assets.images.icSingleTick.svg()
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               : Stack(
  //                   alignment: Alignment.center,
  //                   children: [
  //                     ClipRRect(
  //                       borderRadius: BorderRadius.circular(10.0.sp),
  //                       child: ImageFiltered(
  //                         imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
  //                         child: Image.memory(
  //                           bytesImage,
  //                           fit: BoxFit.cover,
  //                           height: 200.h,
  //                         ),
  //                       ),
  //                     ),
  //                     InkWell(
  //                       onTap: () {
  //                         controller.downloadImage(fileName: image, chatDetail: chatDetail, index: index);
  //                       },
  //                       child: Container(
  //                         padding: const EdgeInsets.all(10),
  //                         decoration: BoxDecoration(
  //                           color: AppColors.darkBlue.withOpacity(0.3),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(Icons.download_rounded, color: AppColors.white),
  //                       ),
  //                     ),
  //                     Positioned(
  //                       bottom: 0,
  //                       right: 0,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           Container(
  //                             padding: const EdgeInsets.symmetric(horizontal: 6).copyWith(left: 10),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r)),
  //                               gradient: LinearGradient(
  //                                 colors: [
  //                                   AppColors.darkBlue.withOpacity(0.0),
  //                                   AppColors.darkBlue.withOpacity(0.0),
  //                                   AppColors.darkBlue.withOpacity(0.5),
  //                                 ],
  //                                 begin: Alignment.topLeft,
  //                                 end: Alignment.bottomCenter,
  //                               ),
  //                             ),
  //                             child: Text(
  //                               messageDateTime(chatDetail.time ?? 0),
  //                               style: AppTextStyle.textStyle10(fontColor: AppColors.white),
  //                             ),
  //                           ),
  //                           SizedBox(width: 8.w),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget kundliView({required ChatMessage chatDetail, required int index}) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.kundliDetail, arguments: {
          "kundli_id": chatDetail.kundliId,
          "from_kundli": true,
          "birth_place": chatDetail.kundliPlace,
          "gender": chatDetail.gender,
          "name": chatDetail.kundliName,
        });
        debugPrint("KundliId : ${chatDetail.kundliId}");
      },
      child: Card(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        child: Container(
          padding: EdgeInsets.all(12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.extraLightGrey),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    chatDetail.kundliName?[0] ?? "",
                    style: AppTextStyle.textStyle24(
                        fontColor: AppColors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatDetail.kundliName ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliDateTime ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      chatDetail.kundliPlace ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget unreadMessageView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 1.0,
                offset: const Offset(0.0, 3.0)),
          ],
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text("unreadMessages".tr),
      ),
    );
  }

  _onBackspacePressed() {
    controller.messageController
      ..text = controller.messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.messageController.text.length));
  }
}

class AstrologerChatAppBar extends StatelessWidget {
  AstrologerChatAppBar({super.key});

  final ChatMessageWithSocketController controller =
      Get.find<ChatMessageWithSocketController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 90.h + Get.mediaQuery.viewPadding.top.h,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(20.r),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFEFDA), Color(0xFFFFD196)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 16.w),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      SizedBox(width: 8.w),
                      Row(
                        children: [
                          CachedNetworkPhoto(
                              height: 48.h,
                              width: 48.w,
                              url: controller.profileImage.value),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.customerName.value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: AppColors.darkBlue),
                                ),
                              ),
                              Obx(() => AnimatedCrossFade(
                                    duration: const Duration(milliseconds: 200),
                                    crossFadeState:
                                        controller.chatStatus.value != ""
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                    secondChild: const SizedBox(),
                                    firstChild: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.showTalkTime.value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.sp,
                                              color: AppColors.brownColour),
                                        ),
                                        Text(
                                          controller.chatStatus.value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13.sp,
                                              color:
                                                  controller.chatStatus.value !=
                                                          "Offline"
                                                      ? AppColors.darkGreen
                                                      : AppColors.redColor),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ZegoService().buttonUI(
                        isVideoCall: false,
                        targetUserID:
                            AppFirebaseService().orderData.value["userId"],
                        targetUserName: AppFirebaseService()
                            .orderData
                            .value["customerName"],
                        checkOppositeSidePermGranted: () {
                          String name =
                              preferenceService.getUserDetail()?.name ?? "";
                          String message =
                              "$name wants to start a call, please allow all required permissions";
                          controller.messageController.text = message;
                          controller.sendMsg();
                        },
                      ),
                      SizedBox(width: 16.w),
                      ZegoService().buttonUI(
                        isVideoCall: true,
                        targetUserID:
                            AppFirebaseService().orderData.value["userId"],
                        targetUserName: AppFirebaseService()
                            .orderData
                            .value["customerName"],
                        checkOppositeSidePermGranted: () {
                          String name =
                              preferenceService.getUserDetail()?.name ?? "";
                          String message =
                              "$name wants to start a call, please allow all required permissions";
                          controller.messageController.text = message;
                          controller.sendMsg();
                        },
                      ),
                      SizedBox(width: 16.w),
                      PopupMenuButton(
                        surfaceTintColor: Colors.transparent,
                        color: Colors.white,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child: InkWell(
                            onTap: () {
                              // Navigator.pop(context);
                              //
                              // showCupertinoModalPopup(
                              //   barrierColor:
                              //   AppColors.darkBlue.withOpacity(0.5),
                              //   context: context,
                              //   builder: (context) => ReportPostReasons(
                              //       reviewData?.id.toString() ?? ''),
                              //
                              //   // builder: (context) => ReportPostReasons(reviewData?.id.),
                              // );
                            },
                            child: Text(
                              "Chat History",
                              style: AppTextStyle.textStyle13(),
                            ),
                          )),
                        ],
                        child: const Icon(Icons.more_vert_rounded),
                      ),
                      SizedBox(width: 16.w),
                    ],
                  ),
                  // Obx(() => Visibility(
                  //     visible: controller.isOngoingChat.value,
                  //     child: Row(
                  //       children: [
                  //         InkWell(
                  //             onTap: () {
                  //               Duration initalTime = Duration(seconds: astroChatWatcher.value.talktime ?? 0);
                  //               var initalDateTime = DateTime(2001).copyWith(second: initalTime.inSeconds);
                  //               var currentTime = timer.chatDuration.value;
                  //               var currentDateTime = DateTime(2001).copyWith(second: currentTime.inSeconds);
                  //               int difference = initalDateTime.difference(currentDateTime).inSeconds;
                  //
                  //               if (difference < 60) {
                  //                 controller.cannotEndChat(Get.context!);
                  //               } else {
                  //                 controller.confirmChatEnd(Get.context!);
                  //               }
                  //             },
                  //             child: Assets.images.icEndChat.svg()),
                  //         SizedBox(width: 16.w),
                  //       ],
                  //     ))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.maxFinite),
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: AppColors.appYellowColour,
            ),
          ),
        ),
      ],
    );
  }
}
