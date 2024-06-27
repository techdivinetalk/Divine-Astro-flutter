import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EndChatTimer extends StatelessWidget {
  final NewChatController? controller;
  const EndChatTimer({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Visibility(
        visible: controller!.showTalkTime.value == "-1",
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: appColors.grey, width: 2),
              borderRadius:
              const BorderRadius.all(Radius.circular(10.0)),
              color: appColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Chat Ended you can still send message till ${controller!.extraTalkTime.value}",
                  style: const TextStyle(
                      color: Colors.red, fontSize: 11),
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
