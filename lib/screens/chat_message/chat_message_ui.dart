import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:divine_astrologer/common/colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/app_textstyle.dart';
import '../../common/common_functions.dart';
import '../../common/routes.dart';
import '../../gen/assets.gen.dart';
import '../../model/chat_offline_model.dart';
import 'chat_message_controller.dart';
import 'package:badges/badges.dart' as badges;

class ChatMessageUI extends GetView<ChatMessageController> {
  const ChatMessageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightYellow,
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Assets.images.bgChatUserPro.image(
                fit: BoxFit.cover,
                height: 32.r,
                width: 32.r,
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Text(
              "Customer Name",
              style: AppTextStyle.textStyle16(
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.brownColour),
            ),
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
                child: MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeTop: true,
                    child: Obx(
                      () => AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: controller.chatMessages.isEmpty
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        secondChild: Container(),
                        firstChild: NotificationListener(
                          onNotification: (t) {
                            if (t is ScrollEndNotification) {
                              controller.scrollToBottom.value = controller
                                          .messgeScrollController
                                          .position
                                          .pixels <
                                      controller.messgeScrollController.position
                                          .maxScrollExtent
                                  ? true
                                  : false;
                            }

                            return true;
                          },
                          child: ListView.builder(
                            controller: controller.messgeScrollController,
                            itemCount: controller.chatMessages.length,
                            shrinkWrap: true,
                            reverse: false,
                            itemBuilder: (context, index) {
                              var chatMessage = controller.chatMessages[index];

                              return Padding(
                                padding: EdgeInsets.all(12.h),
                                child: Column(
                                  children: [
                                    if (chatMessage.id ==
                                        controller.unreadMessageIndex.value)
                                      unreadMessageView(),
                                    chatMessage.msgType == "kundli"
                                        ? kundliView()
                                        : chatMessage.msgType == "image"
                                            ? imageMessage(
                                                controller.chatMessages[index]
                                                        .base64Image ??
                                                    "",
                                                chatDetail: controller
                                                    .chatMessages[index],
                                                index: index,
                                                chatMessage.senderId ==
                                                    controller.userData?.id)
                                            : chatMessage.senderId ==
                                                    controller.userData?.id
                                                ? rightView(
                                                    context,
                                                    chatMessage,
                                                  )
                                                : leftView(
                                                    context,
                                                    chatMessage.message ?? "",
                                                    messageDateTime(
                                                        chatMessage.time ?? 0)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 10.h),
              chatBottomBar(),
              Obx(() => Offstage(
                    offstage: controller.emojiShowing.value,
                    child: SizedBox(
                      height: 300,
                      child: EmojiPicker(
                          // onEmojiSelected: (Category? category, Emoji emoji) {
                          //   _onEmojiSelected(emoji);
                          // },
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
          Positioned(
            bottom: 90.h,
            right: 25.w,
            child: Obx(() => controller.scrollToBottom.value
                ? InkWell(
                    onTap: () {
                      controller.messgeScrollController.animateTo(
                          controller
                              .messgeScrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 20),
                          curve: Curves.easeOut);
                    },
                    child: badges.Badge(
                      badgeContent: controller.unreadMessageIndex != -1
                          ? Text('3')
                          : Text('0'),
                      child: Icon(Icons.arrow_drop_down_circle_outlined,
                          color: AppColors.appColorDark, size: 50.h),
                    ),
                  )
                : const SizedBox()),
          )
        ],
      ),
    );
  }

  Widget rightView(BuildContext context, ChatMessage chatMessage) {
    int msgType = chatMessage.type ?? 0;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: ScreenUtil().screenWidth * 0.5,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3.0,
              offset: const Offset(0.0, 3.0),
            ),
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatMessage.message ?? "",
                style: AppTextStyle.textStyle14(
                    fontColor: AppColors.darkBlue, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    messageDateTime(chatMessage.time ?? 0),
                    style: AppTextStyle.textStyle10(
                      fontColor: AppColors.darkBlue,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  msgType == 0
                      ? Assets.images.icSingleTick.svg()
                      : msgType == 1
                          ? Assets.images.icDoubleTick
                              .image(color: AppColors.greyColor)
                          : msgType == 2
                              ? Assets.images.icDoubleTick.image()
                              : Assets.images.icSingleTick.svg()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftView(BuildContext context, String msgText, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: ScreenUtil().screenWidth * 0.5,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3.0,
              offset: const Offset(0.0, 3.0),
            ),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.sp)),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msgText,
                style: AppTextStyle.textStyle14(
                  fontColor: AppColors.appRedColour,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    time,
                    style: AppTextStyle.textStyle10(
                      fontColor: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                      focusNode: controller.msgFocus,
                      decoration: InputDecoration(
                        hintText: "message".tr,
                        isDense: true,
                        helperStyle: AppTextStyle.textStyle16(),
                        fillColor: AppColors.white,
                        hintStyle:
                            AppTextStyle.textStyle16(fontColor: AppColors.grey),
                        hoverColor: AppColors.white,
                        prefixIcon: InkWell(
                          onTap: () async {
                            controller.emojiShowing.value =
                                !controller.emojiShowing.value;
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(6.w, 5.h, 6.w, 8.h),
                            child: Assets.images.icEmoji.svg(),
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            controller.getImage(false);
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.w, 9.h, 10.w, 10.h),
                            child: Assets.images.icAttechment.svg(),
                          ),
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide: const BorderSide(
                              color: AppColors.white,
                              width: 1.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0.sp),
                            borderSide: const BorderSide(
                              color: AppColors.appColorDark,
                              width: 1.0,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                InkWell(
                    onTap: () {
                      controller.sendMsg();
                    },
                    child: Assets.images.icSendMsg.svg(height: 48.h))
              ],
            ),
          ),
          SizedBox(height: 20.h)
        ],
      ),
    );
  }

  Widget imageMessage(String image, bool yourMessage,
      {required ChatMessage chatDetail, required int index}) {
    Uint8List bytesImage = const Base64Decoder().convert(image);
    return Align(
      alignment: yourMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: chatDetail.downloadedPath != ""
          ? InkWell(
              onTap: () {
                Get.toNamed(RouteName.imagePreviewUi,
                    arguments: chatDetail.downloadedPath);
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0.sp)),
                height: 150.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0.sp),
                  child: Image.file(File(chatDetail.downloadedPath!)),
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  height: 150.h,
                  width: ScreenUtil().screenWidth * 0.5,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(10.0.sp),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0.sp),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Image.memory(
                        bytesImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.downloadImage(
                        fileName: image, chatDetail: chatDetail, index: index);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 150.h,
                    width: ScreenUtil().screenWidth * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0.sp),
                    ),
                    child: const Icon(Icons.download),
                  ),
                )
              ],
            ),
    );
  }

  Widget kundliView() {
    return Card(
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
                  "P",
                  style: AppTextStyle.textStyle24(
                      fontColor: AppColors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Paras Shah",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "20 December 1989, 04:32 AM",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Mumbai, Maharashtra, India",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ],
                ),
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
        child: const Text("Unread Messages"),
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
