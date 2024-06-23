

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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widget/chat_app_bar_widget.dart';
import 'widget/chat_bottom_bar_widget.dart';

class NewChatScreen extends GetView<NewChatController> {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewChatController>(
      assignId: true,
      init: NewChatController(),
      builder: (controller) {
        return Scaffold(
          appBar: ChatAppBarWidget(controller: controller),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: controller.messageScrollController,
                  itemCount: 50,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 30,
                      width: double.infinity,
                      color: Colors.red,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                ),
              ),
              ChatBottomBarWidget(controller: controller),
            ],
          ),
        );
      },
    );
  }

  Widget socketMessageView(BuildContext context, ChatMessage chatMessage,
      NewChatController controller, bool yourMessage, int index) {
    switch (chatMessage.msgType) {
      case MsgType.text:
        return TextViewWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage,
          controller: controller,
        );
      case MsgType.audio:
        return AudioViewWidget(
            chatDetail: chatMessage,
            yourMessage: yourMessage,
            controller: controller);
      case MsgType.gift:
        return RequestGiftViewWidget(
            chatDetail: chatMessage,
            yourMessage: yourMessage,
            controller: controller);
      case MsgType.sendgifts:
        return SendGiftWidget(
            chatDetail: chatMessage,
            yourMessage: yourMessage,
            controller: controller);
      case MsgType.image:
        return ImageViewWidget(
          image: chatMessage.base64Image ?? '',
          yourMessage: yourMessage,
          chatDetail: chatMessage,
          controller: controller,
        );
      case MsgType.kundli:
        return KundliViewWidget(
          chatDetail: chatMessage,
          controller: controller,
          yourMessage: yourMessage,
        );
      case MsgType.customProduct:
        return CustomProductWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage,
          controller: controller,
        );
      case MsgType.product || MsgType.pooja:
        return ProductMsgViewWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage,
          controller: controller,
        );
      case MsgType.remedies:
        return RemediesViewWidget(
          chatDetail: chatMessage,
          yourMessage: yourMessage,
          controller: controller,
        );
      default:
        return Container();
    }
  }
}
