import 'dart:developer';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/audio_view_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/custom_product_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/image_view_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/kundli_view.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/product_msg_view_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/remedies_view_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/request_gift_view_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/send_gift_widget.dart';
import 'package:divine_astrologer/new_chat/msg_bubble/text_view_widget.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:divine_astrologer/new_chat/widget/typing_widget.dart';
import 'package:divine_astrologer/new_chat/widget/visible_tarrot_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:swipe_to/swipe_to.dart';
import 'widget/chat_app_bar_widget.dart';
import 'widget/chat_bottom_bar_widget.dart';
import 'widget/end_chat_timer.dart';
import 'widget/message_template_widget.dart';
import 'widget/notice_board.dart';

class NewChatScreen extends GetView<NewChatController> {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return GetBuilder<NewChatController>(
      assignId: true,
      init: NewChatController(),
      builder: (controller) {
        return Stack(
          children: [
            Scaffold(
              appBar: ChatAppBarWidget(
                  controller: controller,
              ),
              body: Column(
                children: [
                  NoticeBoardWidget(controller: controller),
                  Expanded(
                    child: GestureDetector(
                      onPanDown: (details) {
                        if(controller.overlayEntry != null && controller.overlayEntry!.mounted){
                          controller.overlayEntry?.remove();
                        }
                      },
                      child: ListView.separated(
                        controller: controller.messageScrollController,
                        itemCount: controller.chatMessages.length,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        shrinkWrap: true,
                        reverse: true,
                        itemBuilder: (context, index) {
                          ChatMessage data = controller.chatMessages[index];
                          return SwipeTo(
                            key: UniqueKey(),
                            iconOnLeftSwipe: Icons.arrow_forward,
                            iconOnRightSwipe: Icons.replay,
                            onRightSwipe: (details) {
                              controller.isReplay.value = true;
                              controller.replayChatMessage.value = data;
                            },
                            swipeSensitivity: 5,
                            child: GestureDetector(
                              onLongPress: () {
                                showReactionPopup(context, controller.longPressDownDetails!.globalPosition, index);
                              },
                              onLongPressDown: (details) {
                                controller.longPressDownDetails = details;
                              },
                              child: Column(
                                children: [
                                  Obx(()=>controller.isLoading.value && (controller.chatMessages.length-1 == index) ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Colors.grey.withOpacity(0.6),
                                    ),
                                  )
                                      : const SizedBox()),
                                  Obx(() => Stack(
                                    alignment: data.msgSendBy == "1" ? Alignment.bottomRight : Alignment.bottomLeft,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: (controller.tempEmoji.value != "" && controller.tempIndex.value == index) ? 10.h : 0.0),
                                        child: socketMessageView(
                                          controller: controller,
                                          yourMessage: data.msgSendBy == "1",
                                          chatMessage: data,
                                          index: index,
                                        ),
                                      ),
                                      (controller.tempEmoji.value != "" && controller.tempIndex.value == index) ? Positioned(
                                        right: data.msgSendBy == "1" ? 15.0 : null,
                                        left: data.msgSendBy == "1" ? null : 55.0,
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 10.0),
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50.0),
                                              border: Border.all(color: const Color(0xffDCDCDC)),
                                              color: appColors.white
                                          ),
                                          child: Text(
                                            controller.tempEmoji.value,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                      ) : const SizedBox(),
                                    ],
                                  )),
                                  if (index ==0)
                                    TypingWidget(
                                      controller: controller,
                                      yourMessage: data.msgSendBy == "1",
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  VisibleTarrotCard(controller: controller),
                  EndChatTimer(controller: controller),
                  Obx(() {
                    return !controller.isEmojiShowing.value
                        ? Visibility(
                            visible: !keyboardVisible,
                            child:
                                MessageTemplateWidget(controller: controller))
                        : const SizedBox();
                  }),
                  ChatBottomBarWidget(controller: controller),
                  Obx(() => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: controller.isEmojiShowing.value ? 300 : 0,
                        child: SizedBox(
                          height: 300,
                          child: EmojiPicker(
                              onBackspacePressed: () {
                                controller.messageController
                                  ..text = controller
                                      .messageController.text.characters
                                      .toString()
                                  ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: controller
                                              .messageController.text.length));
                              },
                              textEditingController:
                                  controller.messageController,
                              config: const Config()),
                        ),
                      ))
                ],
              ),
            ),
            Center(
              child: SVGAImage(
                controller.svgaController,
              ),
            ),
          ],
        );
      },
    );
  }

  void showReactionPopup(BuildContext context, Offset position, int index) {
    controller.overlayEntry = OverlayEntry(
      builder: (context) => ReactionPopup(
        onReactionSelected: (reaction) {
          controller.tempEmoji.value = reaction;
          controller.tempIndex.value = index;
          controller.overlayEntry?.remove();
          },
        position: position,
        controller: controller,
      ),
    );

    Overlay.of(context).insert(controller.overlayEntry!);
  }

  Widget socketMessageView(
      {ChatMessage? chatMessage,
      NewChatController? controller,
      bool? yourMessage,
      int? index}) {
    switch (chatMessage!.msgType) {
      case MsgType.text:
        return TextViewWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage!,
          controller: controller,
        );
      case MsgType.audio:
        return AudioViewWidget(
            chatDetail: chatMessage,
            yourMessage: yourMessage!,
            controller: controller);
      case MsgType.gift:
        return RequestGiftViewWidget(
            chatDetail: chatMessage,
            yourMessage: yourMessage!,
            controller: controller);
      case MsgType.sendgifts:
        return SendGiftWidget(
            chatDetail: chatMessage,
            yourMessage: yourMessage!,
            controller: controller);
      case MsgType.image:
        return ImageViewWidget(
          image: chatMessage.base64Image ?? '',
          yourMessage: yourMessage!,
          chatDetail: chatMessage,
          controller: controller,
        );
      case MsgType.kundli:
        return KundliViewWidget(
          chatDetail: chatMessage,
          controller: controller,
          yourMessage: yourMessage!,
        );
      case MsgType.customProduct:
        return CustomProductWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage!,
          controller: controller,
        );
      case MsgType.product || MsgType.pooja:
        return ProductMsgViewWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage!,
          controller: controller,
        );
      case MsgType.remedies:
        return RemediesViewWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage!,
          controller: controller,
        );
      default:
        return Container();
    }
  }
}

class ReactionPopup extends StatelessWidget {
  final Function(String) onReactionSelected;
  final Offset position;
  final NewChatController controller;
  // final Size screenSize;

  ReactionPopup({required this.onReactionSelected, required this.position, required this.controller});

  @override
  Widget build(BuildContext context) {
    double left = position.dx;
    double top = position.dy;
    final screenSize = MediaQuery.of(context).size;
    if (left + 150 > screenSize.width) {
      left = (screenSize.width/2) - 150;
    }
    if (top + 60 > screenSize.height) {
      top = (screenSize.height/2) - 60;
    }
    return Positioned(
      // top: position.dy - 60,
      top: top,
      // left: position.dx - 75,
      left: left,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for(int i = 0 ; i < controller.emojiList.length ; i++)
                GestureDetector(
                  onTap: () {
                    onReactionSelected(controller.emojiList[i]);
                  },
                  child: Text(
                    controller.emojiList[i],
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

