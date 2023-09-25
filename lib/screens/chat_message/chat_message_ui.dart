// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:divine_astrologer/common/cached_network_image.dart';
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
import '../live_page/constant.dart';
import 'chat_message_controller.dart';

class ChatMessageUI extends GetView<ChatMessageController> {
  const ChatMessageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatMessageController>(builder: (controller) {
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
                // const SizedBox(height: 4),
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
                              crossFadeState: controller.chatMessages.isEmpty
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
                                  itemBuilder: (context, index) {
                                    var chatMessage =
                                        controller.chatMessages[index];

                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 12),
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
                                                          chatMessage
                                                                  .senderId ==
                                                              controller
                                                                  .userData?.id)
                                                      : textMsgView(
                                                          context,
                                                          chatMessage,
                                                          chatMessage
                                                                  .senderId ==
                                                              controller
                                                                  .userData
                                                                  ?.id),
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
                                  controller.scrollToBottomFunc();
                                  controller.updateReadMessageStatus();
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
                SizedBox(height: 10.h),
                Obx(() => controller.isOngoingChat.value
                    ? chatBottomBar()
                    : const SizedBox()),
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
            Obx(() => Visibility(
                visible: !controller.isDataLoad.value,
                child: const IgnorePointer(
                  ignoring: true,
                  child: LoadingIndicatorWidget(),
                ))),
          ],
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
                    child: Assets.images.icTyping.image(
                      width: 45,
                      height: 30,
                    ),
                    // child: Assets.lottie.typingIndicator.lottie(
                    //   width: 45,
                    //   height: 30,
                    //   repeat: true,
                    //   frameRate: FrameRate(120),
                    //   animate: true,
                    // ),
                  )
                : const SizedBox(),
          )),
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
                      minLines: 1,
                      maxLines: 3,
                      onTap: () {
                        controller.userTypingSocket(isTyping: true);
                        if (controller.isEmojiShowing.value) {
                          controller.isEmojiShowing.value = false;
                        }
                      },
                      scrollController: controller.typingScrollController,
                      onTapOutside: (value) {
                        FocusScope.of(Get.context!).unfocus();
                        controller.userTypingSocket(isTyping: false);
                      },
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
                            FocusManager.instance.primaryFocus?.unfocus();
                            controller.isEmojiShowing.value =
                                !controller.isEmojiShowing.value;
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 11.h),
                            child: Assets.images.icEmoji.svg(),
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            if (controller.isOngoingChat.value) {
                              controller.getImage(false);
                            } else {
                              divineSnackBar(
                                  data: "${'chatEnded'.tr}.",
                                  color: AppColors.appYellowColour);
                            }
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
                              color: AppColors.appYellowColour,
                              width: 1.0,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                InkWell(
                    onTap: () {
                      if (controller.isOngoingChat.value) {
                        controller.sendMsg();
                      } else {
                        divineSnackBar(
                            data: "${'chatEnded'.tr}.",
                            color: AppColors.appYellowColour);
                      }
                    },
                    child: Assets.images.icSendMsg.svg(height: 48.h))
              ],
            ),
          ),
          SizedBox(height: 20.h),
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
                minWidth: ScreenUtil().screenWidth * 0.25),
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
                                ? Assets.images.icDoubleTick
                                    .image(color: AppColors.greyColor)
                                : msgType.value == 2
                                    ? Assets.images.icDoubleTick.image()
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

  Widget imageMsgView(String image, bool yourMessage,
      {required ChatMessage chatDetail, required int index}) {
    Uint8List bytesImage = const Base64Decoder().convert(image);
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
                minWidth: ScreenUtil().screenWidth * 0.25),
            child: chatDetail.downloadedPath != ""
                ? InkWell(
                    onTap: () {
                      Get.toNamed(RouteName.imagePreviewUi,
                          arguments: chatDetail.downloadedPath);
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0.r),
                          child: Image.file(
                            File(chatDetail.downloadedPath??''),
                            fit: BoxFit.cover,
                            height: 200.h,
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                messageDateTime(chatDetail.time ?? 0),
                                style: AppTextStyle.textStyle10(
                                  fontColor: AppColors.darkBlue,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              if (yourMessage)
                                Obx(() => msgType.value == 0
                                    ? Assets.images.icSingleTick.svg()
                                    : msgType.value == 1
                                        ? Assets.images.icDoubleTick
                                            .image(color: AppColors.greyColor)
                                        : msgType.value == 2
                                            ? Assets.images.icDoubleTick.image()
                                            : Assets.images.icSingleTick.svg())
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0.sp),
                        child: ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Image.memory(
                            bytesImage,
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
                        child: const Icon(Icons.download),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              messageDateTime(chatDetail.time ?? 0),
                              style: AppTextStyle.textStyle10(
                                fontColor: AppColors.darkBlue,
                              ),
                            ),
                            SizedBox(width: 8.w),
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

  Widget kundliView({required ChatMessage chatDetail, required int index}) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.kundliDetail, arguments: {
          "kundli_id": chatDetail.kundliId,
          'from_kundli': true,
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
        child:  Text("unreadMessages".tr),
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
  AstrologerChatAppBar({Key? key}) : super(key: key);
  ChatMessageController controller = Get.find<ChatMessageController>();

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
                            url: controller.profileImage.value,
                          ),
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
                                    color: AppColors.darkBlue,
                                  ),
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
                                          controller.chatStatus.value != ""
                                              ? "(${timer.formattedTime()} mins) Remaining"
                                              : "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.sp,
                                            color: AppColors.brownColour,
                                          ),
                                        ),
                                        Text(
                                          controller.chatStatus.value,
                                          // "chatInProgress".tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp,
                                            color: AppColors.redColor,
                                          ),
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
                  Obx(() => Visibility(
                      visible: controller.isOngoingChat.value,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Duration initalTime = Duration(
                                    seconds:
                                        astroChatWatcher.value.talktime ?? 0);
                                var initalDateTime = DateTime(2001)
                                    .copyWith(second: initalTime.inSeconds);
                                var currentTime = timer.chatDuration.value;
                                var currentDateTime = DateTime(2001)
                                    .copyWith(second: currentTime.inSeconds);
                                int difference = initalDateTime
                                    .difference(currentDateTime)
                                    .inSeconds;
                                debugPrint(
                                    " 123 initialTime $initalTime \n 123 CurrentTime = $currentTime \n 123 InitialDateTime = $initalDateTime \n 123 CurrentDateTime = $currentDateTime \n 123 Difference = $difference");
                                if (difference < 60) {
                                  controller.cannotEndChat(Get.context!);
                                } else {
                                  controller.confirmChatEnd(Get.context!);
                                }
                              },
                              child: Assets.images.icEndChat.svg()),
                          SizedBox(width: 16.w),
                        ],
                      ))),
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
