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
              appBar: ChatAppBarWidget(controller: controller),

              body: Column(
                children: [
                  NoticeBoardWidget(controller: controller),
                  Expanded(
                    child: ListView.separated(
                      controller: controller.messageScrollController,
                      itemCount: controller.chatMessages.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        ChatMessage data = controller.chatMessages[index];
                        return Column(
                          children: [
                            Obx(()=>controller.isLoading.value && (controller.chatMessages.length-1 == index) ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            )
                            : const SizedBox()),
                            socketMessageView(
                              controller: controller,
                              yourMessage: data.msgSendBy == "1",
                              chatMessage: data,
                              index: index,
                            ),
                            if (index ==0)
                              TypingWidget(
                                controller: controller,
                                yourMessage: data.msgSendBy == "1",
                              ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
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
