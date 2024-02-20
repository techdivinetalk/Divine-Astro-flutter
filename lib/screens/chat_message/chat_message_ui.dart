import 'dart:ui';

import 'package:divine_astrologer/common/colors.dart';
import 'package:divine_astrologer/common/permission_handler.dart';
import 'package:divine_astrologer/model/chat_assistant/chat_assistant_chats_response.dart';
import 'package:divine_astrologer/repository/chat_repository.dart';
import 'package:divine_astrologer/repository/kundli_repository.dart';
import 'package:divine_astrologer/screens/chat_message/widgets/assist_message_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/app_textstyle.dart';
import '../../gen/assets.gen.dart';
import '../../utils/load_image.dart';
import '../live_page/constant.dart';
import 'chat_message_controller.dart';

class ChatMessageSupportUI extends GetView<ChatMessageController> {
  const ChatMessageSupportUI({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatMessageController(KundliRepository(), ChatRepository()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColors.yellow,
        centerTitle: false,
        leadingWidth: 30,
        title: Row(
          children: [
            SizedBox(
              height: 32.r,
              width: 32.r,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: LoadImage(
                    boxFit: BoxFit.fill,
                    imageModel: ImageModel(
                        assetImage: false,
                        placeHolderPath: Assets.images.defaultProfile.path,
                        imagePath:
                            "${globalConstantModel.data?.awsCredentails.baseurl}/${controller.args!.name ?? ''}",
                        loadingIndicator: SizedBox(
                            child: CircularProgressIndicator(
                                color: appColors.yellow, strokeWidth: 2))),
                  )),
            ),
            SizedBox(width: 10.w),
            Text(controller.args!.name ?? '',
                style: AppTextStyle.textStyle16(
                    fontWeight: FontWeight.w500, fontColor: appColors.brown))
          ],
        ),
      ),
      body: Stack(
        children: [
          Assets.images.bgChatWallpaper.image(
              width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
          Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification &&
                        notification.metrics.pixels == 0.0 &&
                        notification.metrics.axis == Axis.vertical &&
                        notification.dragDetails != null) {
                      // controller.getAssistantChatList();
                    }
                    return false;
                  },
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.chatMessageList.length,
                      controller: controller.messageScrollController,
                      reverse: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final currentMsg =
                            controller.chatMessageList[index] as AssistChatData;
                        final nextIndex =
                            controller.chatMessageList.length - 1 == index
                                ? index
                                : index + 1;
                        print(
                            'length of chat assist list ${controller.chatMessageList.length}');
                        print("chat assist msg data:${currentMsg.toJson()}");
                        return AssistMessageView(
                          index: index,
                          chatMessage: currentMsg,
                          nextMessage: controller.chatMessageList[nextIndex],
                          yourMessage: currentMsg.sendBy == SendBy.astrologer,
                          unreadMessage: controller.unreadMessageList.isNotEmpty
                              ? controller.chatMessageList[index].id ==
                                  controller.unreadMessageList.first.id
                              : false,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              chatBottomBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget chatBottomBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    // height: 50.h,
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
                      textInputAction: TextInputAction.newline,
                      maxLines: 1,

                      // focusNode: controller.msgFocus,
                      onChanged: (value) {
                        // controller.isEmojiShowing.value = true;
                        FocusManager.instance.primaryFocus?.hasFocus ?? false
                            ? controller.scrollToBottomFunc()
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: "message".tr,
                        isDense: true,
                        helperStyle: AppTextStyle.textStyle16(),
                        fillColor: appColors.white,
                        hintStyle:
                            AppTextStyle.textStyle16(fontColor: appColors.grey),
                        hoverColor: appColors.white,
                        filled: true,
                        constraints: BoxConstraints(maxHeight: 50.h),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide:
                                BorderSide(color: appColors.white, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide: BorderSide(
                                color: appColors.appColorLite, width: 1.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                InkWell(
                  onTap: () {
                    controller.sendMsg();
                  },
                  child: Assets.images.icSendMsg.svg(height: 48.h),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }
}
