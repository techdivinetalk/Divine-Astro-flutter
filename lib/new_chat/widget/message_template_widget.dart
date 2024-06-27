import 'package:divine_astrologer/common/app_textstyle.dart';
import 'package:divine_astrologer/common/routes.dart';
import 'package:divine_astrologer/model/chat_offline_model.dart';
import 'package:divine_astrologer/model/message_template_response.dart';
import 'package:divine_astrologer/new_chat/new_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessageTemplateWidget extends StatelessWidget {
  final NewChatController? controller;

  const MessageTemplateWidget({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 35,
        margin: const EdgeInsets.only(bottom: 7),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: controller!.messageTemplates.length + 1,
          separatorBuilder: (_, index) => SizedBox(width: 10.w),
          itemBuilder: (context, index) {
            return index == 0
                ? GestureDetector(
              onTap: () async {
                await Get.toNamed(RouteName.messageTemplate);
                controller!.getMessageTemplatesLocally();
                controller!.update();
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xffFFEEF0),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Text(
                  '+ Add',
                  style: AppTextStyle.textStyle12(
                      fontColor: const Color(0xff0E2339)),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                controller!.addNewMessage(
                  msgType: MsgType.text,
                  messageText:
                  controller!.messageTemplates[index - 1].message,
                );
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xffFFEEF0),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Text(
                  '${controller!.messageTemplates[index - 1].message}',
                  style: AppTextStyle.textStyle12(
                      fontColor: Color(0xff0E2339)),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
