import "dart:developer";

import "package:audio_waveforms/audio_waveforms.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:divine_astrologer/common/app_textstyle.dart";
import "package:divine_astrologer/common/colors.dart";
import "package:divine_astrologer/common/common_functions.dart";
import "package:divine_astrologer/common/custom_widgets.dart";
import "package:divine_astrologer/common/message_view.dart";
import "package:divine_astrologer/common/permission_handler.dart";
import "package:divine_astrologer/common/routes.dart";
import "package:divine_astrologer/firebase_service/firebase_service.dart";
import "package:divine_astrologer/gen/assets.gen.dart";
import "package:divine_astrologer/gen/fonts.gen.dart";
import "package:divine_astrologer/model/chat_offline_model.dart";
import "package:divine_astrologer/zego_call/zego_service.dart";
import "package:emoji_picker_flutter/emoji_picker_flutter.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:lottie/lottie.dart";
import "package:simple_html_css/simple_html_css.dart";
import "package:svgaplayer_flutter/svgaplayer_flutter.dart";

import "../../common/common_bottomsheet.dart";
import "../../model/message_template_response.dart";
import "../home_screen_options/check_kundli/kundli_controller.dart";
import "../live_dharam/widgets/custom_image_widget.dart";
import "../live_page/constant.dart";
import "chat_message_with_socket_controller.dart";

class ChatMessageWithSocketUI extends GetView<ChatMessageWithSocketController> {
  const ChatMessageWithSocketUI({super.key});

  @override
  Widget build(BuildContext context) {
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    List<String> myList = [];
    return WillPopScope(
      onWillPop: () => controller.checkIfEmojisOpen(),
      child: Scaffold(
        // resizeToAvoidBottomInset: true,

        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              GetBuilder<ChatMessageWithSocketController>(
                  init: ChatMessageWithSocketController(),
                  builder: (controller) {
                    if (keyboardVisible) {
                      controller.scrollToBottomFunc();
                    }
                    return Stack(
                      children: [
                        Assets.images.bgChatWallpaper.image(
                          width: MediaQuery.of(context).size.width,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          color: appColors.white,
                        ),
                        Column(
                          children: [
                            AstrologerChatAppBar(),
                            controller.noticeDataChat.isNotEmpty
                                ? CarouselSlider(
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
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffDA2439)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            alignment: Alignment.center,
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: HTML.toTextSpan(
                                                  context, i.description ?? ""),
                                              maxLines: 2,
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  )
                                : const SizedBox.shrink(),
                            Expanded(
                              child: Stack(
                                children: [
                                  Obx(
                                    () => ListView.builder(
                                      controller:
                                          controller.messgeScrollController,
                                      itemCount: controller.chatMessages.length,
                                      shrinkWrap: true,
                                      reverse: false,
                                      itemBuilder: (context, index) {
                                        var chatMessage =
                                            controller.chatMessages[index];
                                        print(
                                            "${myList.length < 3 && chatMessage.msgType == MsgType.text && chatMessage.orderId == AppFirebaseService().orderData["orderId"]}");
                                        print(
                                            "${AppFirebaseService().orderData["orderId"]}");
                                        if (myList.length < 3 &&
                                            chatMessage.msgType ==
                                                MsgType.text &&
                                            chatMessage.orderId ==
                                                AppFirebaseService()
                                                    .orderData["orderId"]) {
                                          myList
                                              .add(chatMessage.time.toString());
                                          print("timeSet ${chatMessage.time}");
                                          print("${chatMessage.msgType}");
                                          print("${chatMessage.msgType}");
                                        }
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.h,
                                                  horizontal: 10.w),
                                              child: MessageView(
                                                index: index,
                                                nextChatMessage: index ==
                                                        controller.chatMessages
                                                                .length -
                                                            1
                                                    ? controller
                                                        .chatMessages[index]
                                                    : controller.chatMessages[
                                                        index + 1],
                                                chatMessage: chatMessage,
                                                yourMessage:
                                                    chatMessage.msgSendBy ==
                                                        "1",
                                                userName: controller
                                                    .customerName.value,
                                                unreadMessage: controller
                                                    .unreadMessageIndex.value,
                                                myList: myList,
                                              ),
                                            ),
                                            if (index ==
                                                (controller
                                                        .chatMessages.length -
                                                    1))
                                              typingWidget()
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4.h,
                                    right: 25.w,
                                    child: Obx(
                                        () => controller.scrollToBottom.value
                                            ? InkWell(
                                                onTap: () {
                                                  //  controller.scrollToBottomFunc();
                                                  //  controller.updateReadMessageStatus();
                                                },
                                                child: Badge(
                                                  backgroundColor:
                                                      appColors.darkBlue,
                                                  offset: const Offset(4, -2),
                                                  isLabelVisible: (controller
                                                          .unreadMsgCount
                                                          .value >
                                                      0),
                                                  label: Text(
                                                      "${controller.unreadMsgCount.value}"),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.w),
                                                  smallSize: 14.sp,
                                                  largeSize: 20.sp,
                                                  child: Icon(
                                                      Icons
                                                          .arrow_drop_down_circle_outlined,
                                                      color:
                                                          appColors.guideColor,
                                                      size: 40.h),
                                                ),
                                              )
                                            : const SizedBox()),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              print("AppFirebaseServiceCard");
                              return Visibility(
                                  visible: AppFirebaseService()
                                              .orderData
                                              .value["card"] !=
                                          null &&
                                      controller.getListOfCardLength(context) >
                                          0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2F2F2F),
                                        borderRadius: BorderRadius.circular(
                                            14), // First container border radius
                                      ), // First container color
                                      child: (AppFirebaseService()
                                                      .orderData
                                                      .value["card"] !=
                                                  null
                                              ? !(AppFirebaseService()
                                                          .orderData
                                                          .value["card"]
                                                      ["isCardVisible"] ??
                                                  false)
                                              : false)
                                          ? Text(
                                              "${AppFirebaseService().orderData.value["customerName"]} is picking tarot cards...",
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
                                                        FirebaseDatabase
                                                            .instance
                                                            .ref(
                                                                "order/${AppFirebaseService().orderData.value["orderId"]}/card")
                                                            .remove();
                                                      },
                                                      child: Icon(Icons.cancel,
                                                          color:
                                                              appColors.white),
                                                    ),
                                                    const Text(
                                                      "Chosen cards",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0x00ffffff)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Obx(() {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(
                                                      controller
                                                          .getListOfCardLength(
                                                              context),
                                                      (index) => Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 120,
                                                            // Adjust the height as needed
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF212121),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10), // Second container border radius
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  Image.network(
                                                                "${controller.pref.getAmazonUrl() ?? ""}/${controller.getValueByPosition(index)}",
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(
                                                      controller
                                                          .getListOfCardLength(
                                                              context),
                                                      (index) => Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: Center(
                                                              child: Text(
                                                            textAlign: TextAlign
                                                                .center,
                                                            // Add this line for text alignment
                                                            controller
                                                                .getKeyByPosition(
                                                                    index),
                                                            style: TextStyle(
                                                              color: appColors
                                                                  .white,
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
                            Obx(
                              () => Visibility(
                                visible: AppFirebaseService()
                                        .orderData
                                        .value["status"]
                                        .toString() ==
                                    "4",
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: appColors.grey, width: 2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: appColors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "Chat Ended you can still send message till ${controller.extraTalkTime.value}",
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 11),
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Obx(
                            //   () => Column(
                            //     children: [
                            //       messageTemplateRow(),
                            //       SizedBox(height: 15.h),
                            //     ],
                            //   ),
                            // ),
                            /*Obx(() {
                          return Visibility(
                            visible: !controller.isKeyboardVisible.value,
                            child: Column(
                              children: [
                                messageTemplateRow(),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.openShowDeck(context, controller);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 12.h),
                                        width: 70.h,
                                        height: 90.h,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: appColors.red,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 25.h,
                                              height: 25.h,
                                              child: Assets.images.chatTarotCards.svg(),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              'tarotNCards'.tr,
                                              maxLines: 2,
                                              style: AppTextStyle.textStyle12(
                                                  fontColor: appColors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 90.h,
                                        margin: EdgeInsets.only(
                                          left: 10.h,
                                          right: 12.h,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8.h,
                                          horizontal: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: appColors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                          .openProduct(controller);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: appColors.red,
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(18)),
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional.center,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: 20.h,
                                                            height: 20.h,
                                                            child: Assets
                                                                .images.chatProduct
                                                                .svg(),
                                                          ),
                                                          SizedBox(width: 5.h),
                                                          Text(
                                                            'product'.tr,
                                                            style: AppTextStyle
                                                                .textStyle10(
                                                                    fontColor: appColors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.h),
                                                /*Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      controller
                                                          .openCustomShop(controller);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: appColors.red,
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(18)),
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional.center,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: 18.h,
                                                            height: 18.h,
                                                            child: Assets
                                                                .images.chatCustomShop
                                                                .svg(),
                                                          ),
                                                          SizedBox(width: 5.h),
                                                          Text(
                                                            'customShop'.tr,
                                                            maxLines: 2,
                                                            style: AppTextStyle
                                                                .textStyle10(
                                                                    fontColor: appColors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              'useTheseOptionsToSellECommerceProducts'
                                                  .tr,
                                              style: AppTextStyle.textStyle10(
                                                  fontColor: appColors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.h),
                              ],
                            ),
                          );
                        }),*/
                            Visibility(
                                visible: !keyboardVisible,
                                child: messageTemplateRow()),
                            const SizedBox(
                              height: 10,
                            ),
                            chatBottomBar(context, controller),
                            Obx(() => AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height:
                                      controller.isEmojiShowing.value ? 300 : 0,
                                  child: SizedBox(
                                    height: 300,
                                    child: EmojiPicker(
                                        onBackspacePressed: () {
                                          _onBackspacePressed();
                                        },
                                        textEditingController:
                                            controller.messageController,
                                        config: const Config()),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    );
                  }),
              Center(
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: SVGAImage(
                    controller.svgController,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget giftSendUi(
      BuildContext context, ChatMessage chatMessage, bool yourMessage) {
    return Container(
      color: appColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 4.0),
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
      child: Obx(() {
        print("controllerMessageTemplates");
        print(controller.messageTemplatesList.length);
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: controller.messageTemplatesList.length + 1,
          separatorBuilder: (_, index) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            late final MessageTemplates msg;
            return index == 0
                ? GestureDetector(
                    onTap: () async {
                      await Get.toNamed(RouteName.messageTemplate);
                      if (await controller.checkIfChatIsEnded()) {
                        controller.messageTemplatesList.value.clear();
                        controller.messageTemplatesList.refresh();
                        controller.getMessageTemplates();
                      }
                      // controller.getMessageTemplatesLocally();
                      // controller.update();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xffFFEEF0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Text(
                        '+ Add',
                        style: AppTextStyle.textStyle12(
                            fontColor: Color(0xff0E2339)),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      controller.sendMsgTemplate(
                          controller.messageTemplatesList[index - 1]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: const BoxDecoration(
                        color: Color(0xffFFEEF0),
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      child: Text(
                        '${controller.messageTemplatesList[index - 1].message}',
                        style: AppTextStyle.textStyle12(
                            fontColor: Color(0xff0E2339)),
                      ),
                    ),
                  );
          },
        );
      }),
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
                      animate: true,
                    ),
                  )
                : const SizedBox(),
          )),
    );
  }

  String convertDate(String inputDate) {
    try {
      // Define the input and output date formats
      DateFormat inputFormat = DateFormat("dd MMM yyyy");
      DateFormat outputFormat = DateFormat("dd/MM/yyyy");

      // Parse the input date string to a DateTime object
      DateTime parsedDate = inputFormat.parse(inputDate);

      // Format the DateTime object to the desired output format
      String formattedDate = outputFormat.format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle any parsing errors
      debugPrint("Error parsing or formatting date: $e");
      return "";
    }
  }

  DateTime parseDate(String dateStr) {
    try {
      // Define the input date format
      DateFormat inputFormat = DateFormat("dd/MM/yyyy");

      // Parse the input date string to a DateTime object
      DateTime parsedDate = inputFormat.parse(dateStr);

      return parsedDate;
    } catch (e) {
      // Handle any parsing errors
      debugPrint("Error parsing date: $e");
      return DateTime.now(); // Return the current date as a fallback
    }
  }

  Widget chatBottomBar(
      BuildContext context, ChatMessageWithSocketController? controller) {
    return Obx(
      () {
        debugPrint('is recording value ${controller!.isRecording.value}');
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: controller.isRecording.value ? 0 : 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: controller.isRecording.value
                          ? AudioWaveforms(
                              enableGesture: true,
                              size: Size(
                                  MediaQuery.of(Get.context!).size.width, 36),
                              recorderController:
                                  controller.recorderController!,
                              waveStyle: WaveStyle(
                                waveColor: appColors.guideColor,
                                extendWaveform: true,
                                showMiddleLine: false,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffF3F3F3),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.only(left: 18),
                              margin: const EdgeInsets.only(left: 15),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              // height: 44,
                              child: TextFormField(
                                controller: controller.messageController,
                                keyboardType: TextInputType.text,
                                // expands: true,
                                autofocus: false,
                                minLines: 1,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontFamily: FontFamily.metropolis,
                                  fontWeight: FontWeight.w500,
                                ),
                                onTap: () {
                                  if (controller.isEmojiShowing.value) {
                                    controller.isEmojiShowing.value = false;
                                  }
                                },
                                scrollController:
                                    controller.typingScrollController,
                                onChanged: (value) {
                                  controller.tyingSocket();
                                },
                                decoration: InputDecoration(
                                  hintText: "Type something".tr,
                                  isDense: true,
                                  helperStyle: AppTextStyle.textStyle16(),
                                  fillColor: Color(0xffF3F3F3),
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
                                      child: Assets.images.icEmojiShare.image(),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      !controller.hasMessage.value
                                          ? GestureDetector(
                                              onTap: () {
                                                controller.askForGift();
                                              },
                                              child: Center(
                                                child: SvgPicture.asset(
                                                    "assets/svg/chat_new_gift.svg"),
                                              ))
                                          : const SizedBox(),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          //todo
                                          openBottomSheet(
                                            context,
                                            btnBorderColor: AppColors().white,
                                            btnColor: AppColors().transparent,
                                            functionalityWidget: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    "${AppFirebaseService().orderData["customerName"]}'s Kundali Details",
                                                    style: AppTextStyle
                                                        .textStyle20(
                                                            fontColor:
                                                                AppColors()
                                                                    .blackColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 15),
                                                  Text(
                                                    "Name: ${AppFirebaseService().orderData["customerName"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  Text(
                                                    "Gender: ${AppFirebaseService().orderData["gender"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  Text(
                                                    "DOB: ${AppFirebaseService().orderData["dob"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  Text(
                                                    "POB: ${AppFirebaseService().orderData["placeOfBirth"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  Text(
                                                    "TOB: ${AppFirebaseService().orderData["timeOfBirth"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  Text(
                                                    "Marital Status: ${AppFirebaseService().orderData["maritalStatus"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  Text(
                                                    "Problem Area: ${AppFirebaseService().orderData["topic_of_concern"]}",
                                                    style: AppTextStyle
                                                        .textStyle14(),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CustomButton(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      color: AppColors().red,
                                                      onTap: () {
                                                        log("fjdfkdjfkdjkdjkfjd");
                                                        // Parse the date string to DateTime
                                                        DateTime date = DateFormat(
                                                                'd MMMM yyyy')
                                                            .parse(AppFirebaseService()
                                                                    .orderData[
                                                                "dob"]);

                                                        // Format the DateTime to 'dd/MM/yyyy'
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(date);

                                                        final dateData = DateFormat(
                                                                "dd/MM/yyyy")
                                                            .parse(
                                                                formattedDate);
                                                        DateTime timeData = DateFormat(
                                                                "h:mm a")
                                                            .parse(AppFirebaseService()
                                                                    .orderData[
                                                                "timeOfBirth"]);
                                                        Params params = Params(
                                                          name: AppFirebaseService()
                                                                  .orderData[
                                                              "customerName"],
                                                          day: dateData.day,
                                                          year: dateData.year,
                                                          month: dateData.month,
                                                          hour: timeData.hour,
                                                          min: timeData.minute,
                                                          lat: double.parse(
                                                              AppFirebaseService()
                                                                  .orderData[
                                                                      "lat"]
                                                                  .toString()),
                                                          long: double.parse(
                                                              AppFirebaseService()
                                                                      .orderData[
                                                                  "lng"]),
                                                          location:
                                                              AppFirebaseService()
                                                                      .orderData[
                                                                  "placeOfBirth"],
                                                        );

                                                        // Perform some action or close the BottomSheet
                                                        Get.toNamed(
                                                            RouteName
                                                                .kundliDetail,
                                                            arguments: {
                                                              "params": params,
                                                              "kundli_id": 0,
                                                              "from_kundli":
                                                                  false,
                                                              "gender":
                                                                  AppFirebaseService()
                                                                          .orderData[
                                                                      "gender"],
                                                            });
                                                      },
                                                      child: Text(
                                                        'Check Kundli Details',
                                                        style: AppTextStyle
                                                            .textStyle14(
                                                                fontColor:
                                                                    AppColors()
                                                                        .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                          debugPrint(
                                              "kundli datails ${AppFirebaseService().orderData["customerName"]}");
                                        },
                                        child: Container(
                                          // width: 30,
                                          // height: 20,
                                          margin: EdgeInsets.only(right: 6),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: AppColors().red,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Text(
                                            "Kundli",
                                            style: AppTextStyle.textStyle9(
                                                fontColor: AppColors().white),
                                          ),
                                        ),
                                      )
                                    ],
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
                                        color: appColors.transparent,
                                        width: 1.0,
                                      )),
                                ),
                              ),
                            ),
                    ),
                  ),
                  controller.isRecording.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                              onTap: () => controller.refreshWave(),
                              child: Center(
                                child: Assets.images.icClose.svg(
                                    height: 24,
                                    color: const Color(0xff0E2339)
                                        .withOpacity(0.5)),
                              )),
                        )
                      : const SizedBox(width: 5),
                  if (!controller.hasMessage.value)
                    GestureDetector(
                        onTap: controller.startOrStopRecording,
                        child: Center(
                          child: SvgPicture.asset(controller.isRecording.value
                              ? "assets/svg/new_chat_send.svg"
                              : "assets/svg/chat_new_mice.svg"),
                        ))
                  else
                    InkWell(
                        onTap: () {
                          controller.sendMsg();
                        },
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/svg/new_chat_send.svg",
                          ),
                        )),
                  const SizedBox(
                    width: 5,
                  )
                  // const SizedBox(width: 10),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    razorPayLink.value.toString() == "1"
                        ? Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    String message = razorPay.value.toString();
                                    controller.messageController.text = message;
                                    controller.sendMsg();
                                  },
                                  child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: Center(
                                        child: SvgPicture.asset(
                                            "assets/svg/rupee.svg")),
                                  )),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "RazorPay",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  color: appColors.black,
                                ),
                              )
                            ],
                          )
                        : isKundli.value == 1
                            ? Column(
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        Get.toNamed(RouteName.checkKundli);
                                        await controller.checkIfChatIsEnded();
                                      },
                                      child: Center(
                                          child: SvgPicture.asset(
                                              "assets/svg/new_chat_kundli.svg"))),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "Kundli",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                      color: appColors.black,
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox(),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.openProduct(controller);
                          },
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svg/chat_new_product.svg")),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Product",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: appColors.black,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.openCustomShop(controller);
                          },
                          child: Center(
                              child: SvgPicture.asset(
                                  "assets/svg/chat_new_custom_product.svg")),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "My Remedy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: appColors.black,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!AppFirebaseService()
                                .orderData
                                .value
                                .containsKey("card")) {
                              controller.openShowDeck(context, controller);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Tarot Card is still in progress...');
                            }
                          },
                          child: Center(
                            child: SvgPicture.asset(
                                "assets/svg/new_chat_tarrot_card.svg"),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Tarot",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp,
                            color: appColors.black,
                          ),
                        )
                      ],
                    ),
                    Obx(
                      () {
                        Map orderData = AppFirebaseService().orderData.value;
                        final String astrImage = orderData["astroImage"] ?? "";
                        final String custImage =
                            orderData["customerImage"] ?? "";

                        String appendedAstrImage =
                            "${controller.preference.getAmazonUrl()}/$astrImage";
                        String appendedCustImage =
                            "${controller.preference.getAmazonUrl()}/$custImage";

                        print("test_appendedCustImage: $appendedAstrImage");

                        return isVOIP.toString() == "0"
                            ? const SizedBox()
                            : Column(
                                children: [
                                  ZegoService().buttonUI(
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
                                      "time": showTalkTime.value,
                                    },
                                    isAstrologer: true,
                                    astrologerDisabledCalls: () {
                                      astroNotAcceptingCallsSnackBar(
                                        context: context,
                                        isVideoCall: false,
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "Audio",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                      color: appColors.black,
                                    ),
                                  )
                                ],
                              );
                      },
                    ),
                    Obx(
                      () {
                        Map orderData = AppFirebaseService().orderData.value;
                        final String astrImage = orderData["astroImage"] ?? "";
                        final String custImage =
                            orderData["customerImage"] ?? "";

                        String appendedAstrImage =
                            "${controller.preference.getAmazonUrl()}/$astrImage";
                        String appendedCustImage =
                            "${controller.preference.getAmazonUrl()}/$custImage";

                        return isVOIP.toString() == "0"
                            ? const SizedBox()
                            : Column(
                                children: [
                                  ZegoService().buttonUI(
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
                                      "time": showTalkTime.value,
                                    },
                                    isAstrologer: true,
                                    astrologerDisabledCalls: () {
                                      astroNotAcceptingCallsSnackBar(
                                        context: context,
                                        isVideoCall: true,
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "Video",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                      color: appColors.black,
                                    ),
                                  )
                                ],
                              );
                      },
                    ),
                    Obx(() {
                      return isCamera.value == 1
                          ? Column(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      if (await PermissionHelper()
                                          .getAllPermissionForCamera()) {
                                        openBottomSheet(Get.context!,
                                            functionalityWidget: Column(
                                              children: [
                                                Text("Choose Options",
                                                    style: TextStyle(
                                                        color:
                                                            appColors.textColor,
                                                        fontFamily: FontFamily
                                                            .metropolis,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Text(
                                                    "Only photos can be shared",
                                                    style: TextStyle(
                                                        color: appColors
                                                            .disabledGrey,
                                                        fontFamily: FontFamily
                                                            .metropolis,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                SizedBox(height: 20.w),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                        controller
                                                            .getImage(true);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 30),
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                color: appColors
                                                                    .disabledGrey,
                                                                size: 50),
                                                            Text("Camera",
                                                                style: TextStyle(
                                                                    color: appColors
                                                                        .textColor,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .metropolis,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                "Capture an image\nfrom your camera",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: appColors
                                                                        .disabledGrey,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .metropolis,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                        controller
                                                            .getImage(false);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 30),
                                                        child: Column(
                                                          children: [
                                                            Icon(Icons.image,
                                                                color: appColors
                                                                    .disabledGrey,
                                                                size: 50),
                                                            Text("Gallery",
                                                                style: TextStyle(
                                                                    color: appColors
                                                                        .textColor,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .metropolis,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                            Text(
                                                                "Select an image\nfrom your gallery",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: appColors
                                                                        .disabledGrey,
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .metropolis,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ));
                                      }
                                    },
                                    child: Center(
                                        child: SvgPicture.asset(
                                            "assets/svg/new_chat_camera.svg"))),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "Media",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    color: appColors.black,
                                  ),
                                )
                              ],
                            )
                          : SizedBox();
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void showCurvedBottomSheet(context) {
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
                        // var result =
                        //     await Get.toNamed(RouteName.chatSuggestRemedy);
                        // if (result != null) {
                        //   final String time =
                        //       "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
                        //   controller.addNewMessage(
                        //     time,
                        //     MsgType.remedies,
                        //     messageText: result.toString(),
                        //   );
                        // }
                        controller.openRemedies();
                        break;
                      case "deck":
                        // controller.isCardBotOpen.value = true;
                        // showCardChoiceBottomSheet(context, controller);

                        controller.openShowDeck(context, controller);
                        break;
                      case "product":
                        // var result = await Get.toNamed(
                        //     RouteName.chatAssistProductPage,
                        //     arguments: {
                        //       'customerId': int.parse(AppFirebaseService()
                        //           .orderData
                        //           .value["userId"]
                        //           .toString())
                        //     });
                        // if (result != null) {
                        //   final String time =
                        //       "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
                        //   controller.addNewMessage(
                        //     time,
                        //     MsgType.product,
                        //     data: {
                        //       'data': result,
                        //     },
                        //     messageText: 'Product',
                        //   );
                        // }
                        controller.openProduct(controller);
                        break;
                      // case "custom":
                      // print(controller.customProductData);
                      // print("controller.customProductData");
                      // Get.bottomSheet(
                      //   SavedRemediesBottomSheet(
                      //     controller: controller,
                      //     customProductData: controller.customProductData,
                      //   ),
                      // );

                      /*     controller.openCustomShop(controller);
                        break;*/
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
        print("manual backbutton press backFunction");
        controller.backFunction();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          color: appColors.white,
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
                        IconButton(
                          onPressed: controller.backFunction,
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: appColors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Obx(
                              () {
                                Map<String, dynamic> order = {};
                                order = AppFirebaseService().orderData.value;
                                String imageURL = order["customerImage"] ?? "";
                                String appended =
                                    "${controller.preference.getAmazonUrl()}/$imageURL";
                                print("img:: $appended");
                                return SizedBox(
                                  height: 35,
                                  width: 35,
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
                                  () => Row(
                                    children: [
                                      Text(
                                        AppFirebaseService()
                                                .orderData
                                                .value["customerName"] ??
                                            "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                            color: appColors.black),
                                      ),
                                      if (AppFirebaseService()
                                                  .orderData
                                                  .value["level"] !=
                                              null &&
                                          AppFirebaseService()
                                                  .orderData
                                                  .value["level"] !=
                                              "") ...[
                                        const SizedBox(width: 10),
                                        LevelWidget(
                                            level: AppFirebaseService()
                                                    .orderData
                                                    .value["level"] ??
                                                ""),
                                      ],
                                      const SizedBox(width: 10),
                                      Text(
                                        AppFirebaseService()
                                                    .orderData
                                                    .value["status"]
                                                    .toString() ==
                                                "4"
                                            ? "Chat Ended"
                                            : showTalkTime.value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: appColors.guideColor),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 200),
                                  crossFadeState: CrossFadeState.showFirst,
                                  secondChild: const SizedBox(),
                                  firstChild: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Chat in progress",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp,
                                          color: appColors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "(ID-${AppFirebaseService().orderData["orderId"]})",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: appColors.black),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
