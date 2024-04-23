import "dart:collection";
import "dart:convert";
import "dart:io";
import "dart:ui";

import "package:audio_waveforms/audio_waveforms.dart";
import "package:camera/camera.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:divine_astrologer/common/app_textstyle.dart";
import "package:divine_astrologer/common/camera.dart";

import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/custom_widgets.dart";
import "package:divine_astrologer/common/message_view.dart";

import "package:divine_astrologer/common/routes.dart";

import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/screens/chat_message_with_socket/custom_puja/saved_remedies.dart";
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
import "package:get/get_state_manager/get_state_manager.dart";
import "package:lottie/lottie.dart";
import "package:permission_handler/permission_handler.dart";
import "package:simple_html_css/simple_html_css.dart";

import "package:voice_message_package/voice_message_package.dart";

import "../../model/message_template_response.dart";
import "../live_dharam/widgets/custom_image_widget.dart";
import "chat_message_with_socket_controller.dart";

class ChatMessageWithSocketUI extends GetView<ChatMessageWithSocketController> {
  const ChatMessageWithSocketUI({super.key});

  @override
  Widget build(BuildContext context) {
    controller.setContext(context);
    List<String> myList = [];
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: GetBuilder<ChatMessageWithSocketController>(builder: (controller) {
        return Stack(
          children: [
            Assets.images.bgChatWallpaper.image(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                AstrologerChatAppBar(),
                // permissionRequestWidget(),
                controller.noticeDataChat.isNotEmpty ? const SizedBox(height: 10): const SizedBox.shrink(),
                controller.noticeDataChat.isNotEmpty ? CarouselSlider(
                  options: CarouselOptions(
                    height: 50,
                    autoPlay: true,
                    aspectRatio: 1,
                    viewportFraction: 1,
                  ),
                  items: controller.noticeDataChat.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            clipBehavior: Clip.none,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: appColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: appColors.textColor.withOpacity(0.4),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  )
                                ],
                                // border:
                                //     Border.all(color: appColors.red, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text:
                              HTML.toTextSpan(context, i.description ?? ""),
                              maxLines: 2,
                            ));
                      },
                    );
                  }).toList(),
                ) : const SizedBox.shrink(),
                Expanded(
                  child: Stack(
                    children: [
                      Obx(
                            () =>
                            ListView.builder(
                              controller: controller.messgeScrollController,
                              itemCount: controller.chatMessages.length,
                              shrinkWrap: true,
                              reverse: false,
                              itemBuilder: (context, index) {
                                var chatMessage = controller
                                    .chatMessages[index];
                                print(
                                    "${myList.length < 3 &&
                                        chatMessage.msgType == MsgType.text &&
                                        chatMessage.orderId ==
                                            AppFirebaseService()
                                                .orderData["orderId"]}");
                                print(
                                    "${AppFirebaseService()
                                        .orderData["orderId"]}");
                                if (myList.length < 3 &&
                                    chatMessage.msgType == MsgType.text &&
                                    chatMessage.orderId ==
                                        AppFirebaseService()
                                            .orderData["orderId"]) {
                                  myList.add(chatMessage.time.toString());
                                  print("timeSet ${chatMessage.time}");
                                  print("${chatMessage.msgType}");
                                  print("${chatMessage.msgType}");
                                }
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4.h, horizontal: 12.w),
                                      child: MessageView(
                                        index: index,
                                        nextChatMessage: index ==
                                            controller.chatMessages.length - 1
                                            ? controller.chatMessages[index]
                                            : controller.chatMessages[index +
                                            1],
                                        chatMessage: chatMessage,
                                        /*  yourMessage: "${chatMessage.senderId.toString()}" ==
                                              "${preferenceService.getUserDetail()!.id.toString()}",*/
                                        yourMessage: chatMessage.msgSendBy ==
                                            "1",
                                        userName: controller.customerName.value,
                                        unreadMessage:
                                        controller.unreadMessageIndex.value,
                                        myList: myList,
                                      ),
                                    ),
                                    if (index ==
                                        (controller.chatMessages.length - 1))
                                      typingWidget()
                                  ],
                                );
                              },
                            ),
                      ),
                      Positioned(
                        bottom: 4.h,
                        right: 25.w,
                        child: Obx(() =>
                        controller.scrollToBottom.value
                            ? InkWell(
                          onTap: () {
                            //  controller.scrollToBottomFunc();
                            //  controller.updateReadMessageStatus();
                          },
                          child: Badge(
                            backgroundColor: appColors.darkBlue,
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
                                color: appColors.guideColor,
                                size: 40.h),
                          ),
                        )
                            : const SizedBox()),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return Visibility(
                      visible:
                      AppFirebaseService().orderData.value["card"] != null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F2F2F),
                            borderRadius: BorderRadius.circular(
                                14), // First container border radius
                          ), // First container color
                          child: !controller.isCardVisible.value
                              ? Text(
                            "${AppFirebaseService().orderData
                                .value["customerName"]} is picking tarot cards...",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.textStyle15(
                              fontColor: appColors.white,
                            ),
                          )
                              : Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseDatabase.instance
                                          .ref(
                                          "order/${AppFirebaseService()
                                              .orderData
                                              .value["orderId"]}/card")
                                          .remove();
                                      controller.isCardVisible.value =
                                      false;
                                    },
                                    child: Icon(Icons.cancel,
                                        color: appColors.white),
                                  ),
                                  const Text(
                                    "Chosen cards",
                                    style: TextStyle(
                                        color: Color(0x00ffffff)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    controller
                                        .getListOfCardLength(context),
                                        (index) =>
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Container(
                                              width: double.infinity,
                                              height: 120,
                                              // Adjust the height as needed
                                              decoration: BoxDecoration(
                                                color:
                                                const Color(0xFF212121),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10), // Second container border radius
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                child: Image.network(
                                                  "${controller.pref
                                                      .getAmazonUrl() ??
                                                      ""}/${controller
                                                      .getValueByPosition(
                                                      index)}",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                );
                              }),
                              Obx(() {
                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    controller
                                        .getListOfCardLength(context),
                                        (index) =>
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  // Add this line for text alignment
                                                  controller
                                                      .getKeyByPosition(index),
                                                  style: TextStyle(
                                                    color: appColors.white,
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
                                );
                              }),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ));
                }),
                SizedBox(height: 10.h),
                Obx(() =>
                    Visibility(
                        visible: controller.showTalkTime.value == "-1",
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: appColors.grey, width: 2),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                                color: appColors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Chat Ended you can still send message till ${controller
                                        .extraTalkTime.value}",
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center),
                              )),
                        ))),
                Obx(
                      () =>
                      Column(
                        children: [
                          messageTemplateRow(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                ),
                chatBottomBar(context),
                Obx(() =>
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: controller.isEmojiShowing.value ? 300 : 0,
                      child: SizedBox(
                        height: 300,
                        child: EmojiPicker(
                            onBackspacePressed: () {
                              _onBackspacePressed();
                            },
                            textEditingController: controller.messageController,
                            config: Config()),
                      ),
                    )),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget giftSendUi(BuildContext context, ChatMessage chatMessage,
      bool yourMessage) {
    return Container(
      color: appColors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
        child: Row(
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
            Flexible(
                child: Text(
                  "You have received ${chatMessage.message}",
                  style: const TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }

  // Widget permissionRequestWidget() {
  //   return StreamBuilder<DatabaseEvent>(
  //     stream: FirebaseDatabase.instance
  //         .ref()
  //         .child("order/${AppFirebaseService().orderData.value["orderId"]}")
  //         .onValue
  //         .asBroadcastStream(),
  //     builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
  //      // final astPerm = hasAstrologerPermission(snapshot.data?.snapshot);
  //     //  final cusPerm = hasCustomerPermission(snapshot.data?.snapshot);
  //       return AnimatedOpacity(
  //         opacity: astPerm ? 0.0 : 1.0,
  //         duration: const Duration(seconds: 1),
  //         child: astPerm ? const SizedBox.shrink() : commonRedContainer(),
  //       );
  //     },
  //   );
  // }

  /// open setting comment code
  Widget commonRedContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: appColors.red, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: appColors.white,
      ),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        leading: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
        ),
        title: Text(
          "Enable required settings before initiating or accepting the call.",
          style: TextStyle(
            color: appColors.red,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: OutlinedButton(
            onPressed: ZegoService().newOnBannerPressed,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              side: BorderSide(color: appColors.red, width: 1),
            ),
            child: Text(
              "Open Settings",
              style: TextStyle(
                color: appColors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // bool hasAstrologerPermission(DataSnapshot? dataSnapshot) {
  //   bool hasPermission = false;
  //   if (dataSnapshot != null) {
  //     if (dataSnapshot.exists) {
  //       if (dataSnapshot.value is Map<dynamic, dynamic>) {
  //         Map<dynamic, dynamic> map = <dynamic, dynamic>{};
  //         map = (dataSnapshot.value ?? <dynamic, dynamic>{})
  //             as Map<dynamic, dynamic>;
  //         hasPermission = map["astrologer_permission"] ?? false;
  //       } else {}
  //     } else {}
  //   } else {}
  //   return hasPermission;
  // }

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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        color: appColors.white,
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
            style: AppTextStyle.textStyle12(fontColor: appColors.red),
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
          late final MessageTemplates msg;
          return index == 0
              ? GestureDetector(
            onTap: () async {
              await Get.toNamed(RouteName.messageTemplate);
              controller.getMessageTemplatesLocally();
              controller.update();
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD196),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Text(
                '+ Add',
                style:
                AppTextStyle.textStyle12(fontColor: appColors.white),
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
              decoration: BoxDecoration(
                color: appColors.brownColour,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
              ),
              child: Text(
                '${controller.messageTemplates[index - 1].message}',
                style:
                AppTextStyle.textStyle12(fontColor: appColors.white),
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
      child: Obx(() =>
          AnimatedContainer(
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
                animate: true,
              ),
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
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: controller.isRecording.value
                              ? AudioWaveforms(
                            enableGesture: true,
                            size: Size(
                                MediaQuery
                                    .of(Get.context!)
                                    .size
                                    .width,
                                50),
                            recorderController:
                            controller.recorderController!,
                            waveStyle: WaveStyle(
                              waveColor: appColors.guideColor,
                              extendWaveform: true,
                              showMiddleLine: false,
                            ),
                            decoration: BoxDecoration(
                                color: appColors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                      Colors.black.withOpacity(0.3),
                                      blurRadius: 3.0,
                                      offset: const Offset(0.3, 3.0))
                                ]),
                            padding: const EdgeInsets.only(left: 18),
                            margin: const EdgeInsets.only(left: 15),
                          )
                              : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                      Colors.black.withOpacity(0.3),
                                      blurRadius: 3.0,
                                      offset: const Offset(0.3, 3.0))
                                ]),
                            child: TextFormField(
                              controller: controller.messageController,
                              keyboardType: TextInputType.text,
                              minLines: 1,
                              maxLines: 3,
                              onTap: () {
                                if (controller.isEmojiShowing.value) {
                                  controller.isEmojiShowing.value = false;
                                }
                              },
                              scrollController:
                              controller.typingScrollController,
                              onChanged: (value) {
                                controller.tyingSocket();
                                // controller.update();
                              },
                              decoration: InputDecoration(
                                hintText: "message".tr,
                                isDense: true,
                                helperStyle: AppTextStyle.textStyle16(),
                                fillColor: appColors.white,
                                hintStyle: AppTextStyle.textStyle16(
                                    fontColor: appColors.grey),
                                hoverColor: appColors.white,
                                prefixIcon: InkWell(
                                  onTap: () async {
                                    controller.isEmojiShowing.value =
                                    !controller.isEmojiShowing.value;
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        6.w, 5.h, 6.w, 8.h),
                                    child: Assets.images.icEmojiShare
                                        .image(),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    showCurvedBottomSheet(context);

                                    // Move focus to an invisible focus node to dismiss the keyboard
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    // if (controller.isOngoingChat.value) {

                                    //   } else {
                                    //     divineSnackBar(
                                    //         data: "${'chatEnded'.tr}.", color: appColors.appYellowColour);
                                    //   }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.w, 9.h, 10.w, 10.h),
                                    child:
                                    Assets.images.icAttechment.svg(),
                                  ),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(30.0.sp),
                                    borderSide: BorderSide(
                                      color: appColors.white,
                                      width: 1.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(30.0.sp),
                                    borderSide: BorderSide(
                                      color: appColors.guideColor,
                                      width: 1.0,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      controller.isRecording.value
                          ? GestureDetector(
                          onTap: () => controller.refreshWave(),
                          child: Container(
                            height: kToolbarHeight - Get.width * 0.008,
                            width: kToolbarHeight - Get.width * 0.008,
                            decoration: BoxDecoration(
                              color: appColors.guideColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Assets.images.icClose.svg(
                                height: 20,
                              ),
                            ),
                          ))
                          : Obx(() {
                        return isGifts.value == 1  ? GestureDetector(
                          onTap: () {
                            controller.askForGift();
                          },
                          child:
                          SvgPicture.asset('assets/svg/chat_gift.svg'),
                        ):SizedBox();
                      }),
                      const SizedBox(width: 10),
                      controller.hasMessage.value == false
                          ? GestureDetector(
                          onTap: controller.startOrStopRecording,
                          child: Container(
                            height: kToolbarHeight - Get.width * 0.008,
                            width: kToolbarHeight - Get.width * 0.008,
                            margin: EdgeInsets.only(right: 10.h),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD196),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                controller.isRecording.value
                                    ? Icons.send
                                    : Icons.mic,
                                color: appColors.white,
                              ),
                            ),
                          ))
                          : InkWell(
                          onTap: () {
                            controller.sendMsg();
                          },
                          child: Container(
                            height: kToolbarHeight - Get.width * 0.008,
                            width: kToolbarHeight - Get.width * 0.008,
                            margin: EdgeInsets.only(right: 10.h),
                            decoration: BoxDecoration(
                              color: appColors.guideColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.send,
                                color: appColors.white,
                              ),
                            ),
                          )),
                      // const SizedBox(width: 10),
                    ],
                  ),
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
    // List<SvgPicture> itemList = [
    //   SvgPicture.asset('assets/svg/camera_icon.svg'),
    //   SvgPicture.asset('assets/svg/gallery_icon.svg'),
    //   SvgPicture.asset('assets/svg/remedies_icon.svg'),
    //   SvgPicture.asset('assets/svg/deck_icon.svg'),
    //   SvgPicture.asset('assets/svg/product.svg'),
    //   SvgPicture.asset('assets/svg/custom.svg'),
    // ];
    List<BottomSheetModel> itemList = [
      BottomSheetModel(
          svgPicture: SvgPicture.asset('assets/svg/deck_icon.svg'),
          title: "deck"),
    ];
    if (isCamera.value == 1) {
      itemList.add(BottomSheetModel(
          svgPicture: SvgPicture.asset('assets/svg/camera_icon.svg'),
          title: "camera"));
      itemList.add(BottomSheetModel(
          svgPicture: SvgPicture.asset('assets/svg/gallery_icon.svg'),
          title: "gallery"));
    }
    if (isRemidies.value == 1) {
      itemList.add(BottomSheetModel(
          svgPicture: SvgPicture.asset('assets/svg/remedies_icon.svg'),
          title: "remedies"));
    }
    if (isEcom.value == 1) {
      itemList.add(BottomSheetModel(
          svgPicture: SvgPicture.asset('assets/svg/product.svg'),
          title: "product"));
      itemList.add(BottomSheetModel(
          svgPicture: SvgPicture.asset('assets/svg/custom.svg'),
          title: "custom"));
    }
    // isCall
    // isRemidies
    // isEcom
    // isChatAssistance
    // isChat
    // isKundli
    // isTemplates
    // isCamera
    // isLive
    // isQueue
    // isGifts
    // isTruecaller
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.sp),
                topRight: Radius.circular(30.sp),
              ),
            ),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(itemList.length, (index) {
                BottomSheetModel data = itemList[index];
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    switch (data.title) {
                      case "camera":
                        controller.getImage(true);
                        break;
                      case "gallery":
                        controller.getImage(false);
                        break;
                      case "remedies":
                        var result =
                        await Get.toNamed(RouteName.chatSuggestRemedy);
                        if (result != null) {
                          final String time =
                              "${DateTime
                              .now()
                              .millisecondsSinceEpoch ~/ 1000}";
                          controller.addNewMessage(
                            time,
                            MsgType.remedies,
                            messageText: result.toString(),
                          );
                        }
                        break;
                      case "deck":
                        controller.isCardBotOpen.value = true;
                        showCardChoiceBottomSheet(context, controller);
                        break;
                      case "product":
                        var result = await Get.toNamed(
                            RouteName.chatAssistProductPage,
                            arguments: {
                              'customerId': int.parse(AppFirebaseService()
                                  .orderData
                                  .value["userId"]
                                  .toString())
                            });
                        if (result != null) {
                          final String time =
                              "${DateTime
                              .now()
                              .millisecondsSinceEpoch ~/ 1000}";
                          controller.addNewMessage(
                            time,
                            MsgType.product,
                            data: {
                              'data': result,
                            },
                            messageText: 'Product',
                          );
                        }
                        break;
                      case "custom":
                        print(controller.customProductData);
                        print("controller.customProductData");
                        Get.bottomSheet(
                          SavedRemediesBottomSheet(
                            controller: controller,
                            customProductData: controller.customProductData,
                          ),
                        );

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
                      data.svgPicture ?? const SizedBox(),
                      // Replace with your asset images
                    ],
                  ),
                );
              }),
            ),
          );
        });
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
  //                                 appColors.darkBlue.withOpacity(0.0),
  //                                 appColors.darkBlue.withOpacity(0.0),
  //                                 appColors.darkBlue.withOpacity(0.5),
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
  //                                 style: AppTextStyle.textStyle10(fontColor: appColors.white),
  //                               ),
  //                               if (yourMessage) SizedBox(width: 8.w),
  //                               if (yourMessage)
  //                                 msgType.value == 0
  //                                     ? Assets.images.icSingleTick.svg()
  //                                     : msgType.value == 1
  //                                         ? Assets.images.icDoubleTick.svg(
  //                                             colorFilter: const ColorFilter.mode(
  //                                                 appColors.greyColor, BlendMode.srcIn))
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
  //                           color: appColors.darkBlue.withOpacity(0.3),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(Icons.download_rounded, color: appColors.white),
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
  //                                   appColors.darkBlue.withOpacity(0.0),
  //                                   appColors.darkBlue.withOpacity(0.0),
  //                                   appColors.darkBlue.withOpacity(0.5),
  //                                 ],
  //                                 begin: Alignment.topLeft,
  //                                 end: Alignment.bottomCenter,
  //                               ),
  //                             ),
  //                             child: Text(
  //                               messageDateTime(chatDetail.time ?? 0),
  //                               style: AppTextStyle.textStyle10(fontColor: appColors.white),
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

  _onBackspacePressed() {
    controller.messageController
      ..text = controller.messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: controller.messageController.text.length));
  }
}

class BottomSheetModel {
  final SvgPicture? svgPicture;
  final String? title;

  BottomSheetModel({
    this.svgPicture,
    this.title,
  });
}

class AstrologerChatAppBar extends StatelessWidget {
  AstrologerChatAppBar({super.key});

  final ChatMessageWithSocketController controller =
  Get.find<ChatMessageWithSocketController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) {
        controller.backFunction();
      },
      child: Container(
        // height: 90.h + Get.mediaQuery.viewPadding.top.h,
        alignment: Alignment.center,
        // margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.only(bottom: 12.h),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFEFDA),
              Color(0xFFFFD196),
            ],
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
                        // SizedBox(width: 16.w),
                        IconButton(
                          onPressed: controller.backFunction,
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        //SizedBox(width: 8.w),
                        Row(
                          children: [
                            // CachedNetworkPhoto(
                            //     height: 45.h,
                            //     width: 45.w,
                            //     url: controller.profileImage.value),

                            Obx(
                                  () {
                                Map<String, dynamic> order = {};
                                order = AppFirebaseService().orderData.value;
                                String imageURL = order["customerImage"] ?? "";
                                String appended =
                                    "${controller.preference
                                    .getAmazonUrl()}/$imageURL";
                                print("img:: $appended");
                                return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CustomImageWidget(
                                    imageUrl: appended,
                                    rounded: true,
                                    typeEnum: TypeEnum.user,
                                  ),
                                );
                              },
                            ),

                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                      () =>
                                      Text(
                                        AppFirebaseService()
                                            .orderData
                                            .value["customerName"] ??
                                            "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                            color: appColors.darkBlue),
                                      ),
                                ),
                                Obx(() =>
                                    AnimatedCrossFade(
                                      duration:
                                      const Duration(milliseconds: 200),
                                      crossFadeState: CrossFadeState.showFirst,
                                      secondChild: const SizedBox(),
                                      firstChild: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.showTalkTime.value ==
                                                "-1"
                                                ? "Chat Ended"
                                                : controller.showTalkTime.value,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                                color: appColors.brownColour),
                                          ),
                                          Text(
                                            "Chat in progress",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.sp,
                                                color: appColors.darkGreen),
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
                        Obx(
                              () {
                            Map orderData =
                                AppFirebaseService().orderData.value;
                            final String astrImage =
                                orderData["astroImage"] ?? "";
                            final String custImage =
                                orderData["customerImage"] ?? "";

                            String appendedAstrImage =
                                "${controller.preference
                                .getAmazonUrl()}/$astrImage";
                            String appendedCustImage =
                                "${controller.preference
                                .getAmazonUrl()}/$custImage";

                            return false
                                ? const SizedBox()
                                : ZegoService().buttonUI(
                              isVideoCall: false,
                              targetUserID: orderData["userId"] ?? "",
                              targetUserName:
                              orderData["customerName"] ?? "",
                              checkOppositeSidePermGranted: () {
                                String name = preferenceService
                                    .getUserDetail()
                                    ?.name ??
                                    "";
                                String message =
                                    "$name wants to start a call, please allow all required permissions";
                                controller.messageController.text =
                                    message;
                                controller.sendMsg();
                              },
                              customData: {
                                "astr_id": orderData["astroId"] ?? "",
                                "astr_name":
                                orderData["astrologerName"] ?? "",
                                "astr_image": appendedAstrImage,
                                "cust_id": orderData["userId"] ?? "",
                                "cust_name":
                                orderData["customerName"] ?? "",
                                "cust_image": appendedCustImage,
                                // "time": "00:20:00",
                                "time": controller.showTalkTime.value,
                              },
                              isAstrologer: true,
                              astrologerDisabledCalls: () {
                                astroNotAcceptingCallsSnackBar(
                                  context: context,
                                  isVideoCall: false,
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(width: 10.w),
                        Obx(
                              () {
                            Map orderData =
                                AppFirebaseService().orderData.value;
                            final String astrImage =
                                orderData["astroImage"] ?? "";
                            final String custImage =
                                orderData["customerImage"] ?? "";

                            String appendedAstrImage =
                                "${controller.preference
                                .getAmazonUrl()}/$astrImage";
                            String appendedCustImage =
                                "${controller.preference
                                .getAmazonUrl()}/$custImage";

                            return false
                                ? const SizedBox()
                                : ZegoService().buttonUI(
                              isVideoCall: true,
                              targetUserID: orderData["userId"] ?? "",
                              targetUserName:
                              orderData["customerName"] ?? "",
                              checkOppositeSidePermGranted: () {
                                String name = preferenceService
                                    .getUserDetail()
                                    ?.name ??
                                    "";
                                String message =
                                    "$name wants to start a call, please allow all required permissions";
                                controller.messageController.text =
                                    message;
                                controller.sendMsg();
                              },
                              customData: {
                                "astr_id": orderData["astroId"] ?? "",
                                "astr_name":
                                orderData["astrologerName"] ?? "",
                                "astr_image": appendedAstrImage,
                                "cust_id": orderData["userId"] ?? "",
                                "cust_name":
                                orderData["customerName"] ?? "",
                                "cust_image": appendedCustImage,
                                // "time": "00:20:00",
                                "time": controller.showTalkTime.value,
                              },
                              isAstrologer: true,
                              astrologerDisabledCalls: () {
                                astroNotAcceptingCallsSnackBar(
                                  context: context,
                                  isVideoCall: true,
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(width: 5.w),
                        // PopupMenuButton(
                        //   surfaceTintColor: Colors.transparent,
                        //   color: Colors.white,
                        //   itemBuilder: (context) => [
                        //     PopupMenuItem(
                        //         child: InkWell(
                        //       onTap: () {
                        //         // Navigator.pop(context);
                        //         //
                        //         // showCupertinoModalPopup(
                        //         //   barrierColor:
                        //         //   appColors.darkBlue.withOpacity(0.5),
                        //         //   context: context,
                        //         //   builder: (context) => ReportPostReasons(
                        //         //       reviewData?.id.toString() ?? ''),
                        //         //
                        //         //   // builder: (context) => ReportPostReasons(reviewData?.id.),
                        //         // );
                        //       },
                        //       child: Text(
                        //         "Chat History",
                        //         style: AppTextStyle.textStyle13(),
                        //       ),
                        //     )),
                        //   ],
                        //   child: const Icon(Icons.more_vert_rounded),
                        // ),
                        SizedBox(width: 10.w),
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
      ),
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: double.maxFinite),
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: appColors.guideColor,
            ),
          ),
        ),
      ],
    );
  }
}

void astroNotAcceptingCallsSnackBar({
  required bool isVideoCall,
  required BuildContext context,
}) {
  final String type = isVideoCall == true ? "Video" : "Voice";
  final SnackBar snackBar = SnackBar(
    content: Text(
      'Astrologer is not accepting the $type call at this moment.',
      style: const TextStyle(fontSize: 10, color: Colors.black),
      overflow: TextOverflow.ellipsis,
    ),
    backgroundColor: appColors.guideColor,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  return;
}
